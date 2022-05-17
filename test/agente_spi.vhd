-- El agente spi responde a la siguiente secuencia de acciones durante el test desarrollado:
-- 1. Almacena en reg_comandos el valor que se escribe en el primer registro de configuracion (ignora la direccion)
-- 2. Almacena en reg_comandos el valor que se escribe en el segundo registro de configuracion (ignora la direccion)
-- 3. Devuelve las 32 primeras medidas con los siguientes valores para establecer el offset:
--     - Para X simula OUT_X_L = 0x40, OUT_X_H = 0x00, esto se corresponde con el valor 0b0000_0000_01 (0d1)
--     - Para Y simula OUT_Y_L = 0x80, OUT_Y_H = 0xff, esto se corresponde con el valor 0b1111_1111_10 (0d-2)
-- 4. A partir de aqui devuelve las medidas segun se configure pos_X y pos_Y, ver comentarios abajo en la funcion calcular_reg_lectura,
-- tanto pos_X como pos_Y -> 00: horizontal, 01, inclinado negativo, 10 o 11: inclinado positivo.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity agente_spi is
port(pos_X:   in std_logic_vector(1 downto 0);
     pos_Y:   in std_logic_vector(1 downto 0);

     nCS:     in     std_logic;                      -- chip select
     SPC:     in     std_logic;                      -- clock SPI (5 MHz) 
     SDI:     in     std_logic;                      -- Slave Data input  (connected to Master SDO)
     SDO:     buffer std_logic);                     -- Slave Data Output (connected to Slave SDI)
     
end entity;

architecture sim of agente_spi is
  type t_estado is(reposo, byte_1st_Rd, byte_1st_Wr, enviar_lecturas, registrar_comando);
  signal estado: t_estado;

  signal reg_comandos: std_logic_vector(7 downto 0) := X"00";
  signal reg_lecturas: std_logic_vector(31 downto 0) := X"4000_80ff"; --offset 1, -2
  signal cnt_rd_muestras: natural := 0;

  -- Calcula el resultado de la medida a entregar segun el valor de pos_X y pos_Y.
  -- El resultado se devuelve en little endian (LSB primero, MSB despues) y justificado a la izquierda,
  -- por eso se añaden '0' al primer byte (LSB de la medida).
  function calcular_reg_lectura(signal pos_X: in std_logic_vector(1 downto 0);
                                signal pos_Y: in std_logic_vector(1 downto 0)) return std_logic_vector is

    constant horizontal:    std_logic_vector(9 downto 0) := "0001011101";                   -- (93) mod < 150
    constant inclinado_neg: std_logic_vector(9 downto 0) := "1100101000";                   -- (-216) mod < -150
    constant inclinado_pos: std_logic_vector(9 downto 0) := "0011101000";                   -- (232) mod > 150

    variable dato_X: std_logic_vector(15 downto 0);
    variable dato_Y: std_logic_vector(15 downto 0);
   
    variable cadena: std_logic_vector(31 downto 0);
  begin
    case pos_X is 
      when "00"   => dato_X := horizontal(1 downto 0)    & "000000" & horizontal(9 downto 2);    -- 0x4017
      when "10"   => dato_X := inclinado_neg(1 downto 0) & "000000" & inclinado_neg(9 downto 2); -- 0x00ca
      when others => dato_X := inclinado_pos(1 downto 0) & "000000" & inclinado_pos(9 downto 2); -- 0x003a

    end case;

    case pos_Y is 
      when "00"   => dato_Y := horizontal(1 downto 0)    & "000000" & horizontal(9 downto 2);    -- 0x4017
      when "10"   => dato_Y := inclinado_neg(1 downto 0) & "000000" & inclinado_neg(9 downto 2); -- 0x00ca
      when others => dato_Y := inclinado_pos(1 downto 0) & "000000" & inclinado_pos(9 downto 2); -- 0x003a

    end case;

    cadena := (dato_X & dato_Y);
    return cadena;
    
  end function;

begin

-- Lee los datos de SPI bit a bit
process(nCS, SPC)
  variable cnt_bits: natural := 0;
  
begin
  if nCS = '1' then                     -- Esclavo en reposo
    cnt_bits := 0;
    estado <= reposo;

  elsif SPC'event and SPC = '1' then    -- flanco de subida del reloj SPI
    cnt_bits := cnt_bits + 1;
    if cnt_bits = 1 then
      if SDI = '1' then -- operacion de lectura (medida)
        estado <= byte_1st_Rd;
        cnt_rd_muestras <= cnt_rd_muestras + 1; -- se cuentan el numero de medidas realizadas

      else -- operacion de escritura
        estado <= byte_1st_Wr;

      end if;

    elsif cnt_bits = 8 then 
      if estado = byte_1st_Rd then -- realiza escritura de la medida
        estado <= enviar_lecturas;

      else
        estado <= registrar_comando;

      end if;
    end if;
  end if;
end process;


process
begin
  
  if nCS = '0' then
    wait until nCS'event or SPC'event;
      if SPC'event then
        if estado = registrar_comando and SPC = '1' then -- se almacena en reg_comandos el valor que se da al registro de configuracion
          reg_comandos <= reg_comandos(6 downto 0) & SDI;

        elsif estado = enviar_lecturas and SPC = '0' then -- se saca por SPI la medida
          SDO <= reg_lecturas(31) after 25 ns;
          reg_lecturas <= reg_lecturas(30 downto 0)&reg_lecturas(31);

        end if;
      end if;

  else
    SDO <= '1';
    if nCS'event and nCS = '1' then
      if cnt_rd_muestras >= 64 then -- se actualiza el valor del registro de medidas si se han enviado ya más de 64 medidas (despues del calculo del offset inicial)
        reg_lecturas <= calcular_reg_lectura(pos_X, pos_Y); 
      
      end if;
    end if;
    wait until nCS'event;

  end if;
end process;

end sim;





