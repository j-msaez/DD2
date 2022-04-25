-- Fichero spi_master.vhd
-- Descripcion del fichero

-- El reloj del circuito es de 50 MHz (Tclk = 20 ns)

-- Especificación funcional y detalles de la implementación:

--
--    Designer: d.allegue@alumnos.upm.es, hector.garpalencia@alumnos.upm.es & j.msaez@alumnos.upm.es
--    Versión: 1.0
--    Fecha: 25-04-2022

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity spi_master is
port(clk:           in std_logic;
     nRst:          in std_logic;

     -- Entradas/Salidas linea SPI a 4 hilos
     CS:            buffer std_logic;
     SPC:           buffer std_logic;
     SDI:           buffer std_logic;
     SDO:           buffer std_logic;

     -- Entradas de control externo
     ini_tx:        in std_logic;                         -- Orden de inicio de transaccion
     tipo_op_nW_R:  in std_logic;                         -- nW/R, ('0' escribir un byte, '1' leer) 
     
     -- Entradas de datos de escritura
     reg_addr:      buffer std_logic_vector(5 downto 0);  -- Registro sobre el cual se realizan las operaciones de RW.

     -- Entradas de datos de escritura
     dato_wr:       buffer std_logic_vector(7 downto 0);  -- Dato de escritura entrante

     -- Salidas de datos de lectura
     ena_rd:        buffer std_logic;                     -- Indiaccion de dato de lectura valido. ('0' dato invalido, '1' dato valido) 
     dato_rd:       buffer std_logic_vector(7 downto 0);  -- Dato de lectura saliente.

     -- Salidas de control externo
     ready_tx:      buffer std_logic;                     -- Indiaccion de estado ('0' ocupado, '1' libre) 
     fin_tx:        buffer std_logic                      -- Fin de transaccion.
     );
end entity;

architecture rtl of spi_master is
-- Estado del gestor del bus y segnales de control derivadas
  type t_estado is (libre, wr_op, rd_op);
  signal estado: t_estado;

  signal SPC_cnt: std_logic_vector(2 downto 0);

  signal op_out:  std_logic_vector(7 downto 0);

begin
  -- Maquina de estados para el control de transacciones
  process(clk, nRst)
  begin
    if nRst = '0' then
      estado         <= libre;
      fin_tx         <= '1';
      ready_tx       <= '1';
      ena_rd         <= '0';

    elsif clk'event and clk = '1' then
      case estado is
        when libre =>                                 -- Preparado para transmitir
          if ini_tx = '1' then                        -- Orden de start                         
            if tipo_op_nW_R = '0' then
              estado <= wr_op;
              op_out <= tipo_op_nW_R & tipo_op_nW_R & reg_addr; 

            elsif tipo_op_nW_R = '1' then 
              estado <= rd_op;
              op_out <= tipo_op_nW_R & tipo_op_nW_R & reg_addr;
          
            end if;
          end if;

        when wr_op =>
          CS <= '0';
          if fin_tx = '1' then
            esatdo <= libre;

          end if;

        when rd_op =>                              
          CS <= '0';
          if fin_tx = '1' then
            esatdo <= libre;

          end if;
      end case;

    end if;
  end process;


  ready_tx <= '1' when estado = libre else
              '0';

  -- Generacion de la señal de reloj para el bus SPI
  process(clk, nRst)
  begin
    if nRst = '0' then
     SPC <= '1';
     SPC_cnt <= (others => '0');

    elsif clk'event and clk = '1' then
     if CS = '0' then
       if SPC_cnt = 3 then
         SPC_cnt <= (others => '0');
         SPC <= not SPC;

       else
        SPC_cnt <= SPC_cnt + 1;
       
       end if;

      elsif CS = '1' then
        SPC <= '1';

      end if;
    end if;
  end process;

  -- Reg_out: Registro de desplazamiento para los datos de salida 

  -- Reg_in: Registro de desplazamiento para los datos de entrada 


end rtl;