-- Fichero spi_controlador.vhd
-- Descripcion del fichero
--
-- El reloj del circuito es de 50 MHz (Tclk = 20 ns)
--
-- Especificación funcional y detalles de la implementación:
--
--
--    Designer: d.allegue@alumnos.upm.es, hector.garpalencia@alumnos.upm.es & j.msaez@alumnos.upm.es
--    Versión: 1.0
--    Fecha: 04-05-2022

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity spi_controlador is
port(clk:           in std_logic;                         -- Señal de reloj.
     nRst:          in std_logic;                         -- Reset asíncrono.

     -- Entradas de control externo
     ini_tx:        buffer std_logic;                     -- Orden de inicio de transaccion
     tipo_op_nW_R:  buffer std_logic;                     -- nW/R, ('0' escribir un byte, '1' leer) 
     
     -- Entradas de datos de escritura
     reg_addr:      buffer std_logic_vector(5 downto 0);  -- Registro sobre el cual se realizan las operaciones de RW.

     -- Entradas de datos de escritura
     dato_wr:       buffer std_logic_vector(7 downto 0);  -- Dato de escritura saliente.

     -- Salidas de datos de lectura
     ena_rd:        in std_logic;                         -- Indicacion de dato de lectura valido. ('0' dato invalido, '1' dato valido)
     dato_rd:       in std_logic_vector(7 downto 0);      -- Dato de lectura ofrecido por el master SPI.

     -- Salidas de control externo
     ready_tx:      in std_logic                          -- Indicaccion de estado del master SPI ('0' ocupado, '1' libre)
     
     -- ¿Habría que añadir mas puertos para manejar el estimador y el calc_offset?
     );
end entity;

architecture rtl of spi_controlador is
---- ¿Automata para manejar que hacer en cada momento?
---- Estado del gestor del bus y signals de control derivadas
--  type t_estado is (initialization, configure, measure);
--  signal estado: t_estado;
  
-- 2.6.3 High resolution, normal mode, low-power mode - Table 9. Operating mode selection 
-- Normal mode: Turn-on time [ms] -> 1.6 ms ~ 2 ms (margen de seguridad)

  constant INIT_T_CLK: natural := 100000;             -- Periodo de 2ms a esperar hasta que el sensor se encuentra operativo (100000 * 20ns -> 2 ms).
  constant MEAS_T_CLK: natural := 250000;             -- Periodo de 5ms para realizar lecturas periodicas (250000 * 20ns -> 5 ms).
  
  signal meas_ena:  std_logic;                        -- Señal que indica si el sensor se encuentra operativo o no.
  
  signal cnt_t_meas: std_logic_vector(17 downto 0);   -- Contador para generar la temporizacion de la realizacion de medidas (250000 -> 18 bits)
  signal cnt_t_ref:  std_logic_vector(5 downto 0);    -- Contador para generar la temporizacion del calculo del promedio (320 ms / 5 ms = 64 -> 6 bits).
  
  signal reg_pos_x_ini: std_logic_vector(9 downto 0); -- Registro para almacenar la posicion inicial, en el eje X, de la tarjeta.
  signal reg_pos_y_ini: std_logic_vector(9 downto 0); -- Registro para almacenar la posicion inicial, en el eje Y, de la tarjeta.
  
  
begin
--  -- ¿Automata para manejar que hacer en cada momento?
--  -- Maquina de estados para el controlador.
--  process(clk, nRst)
--  begin
--    if nRst = '0' then
--      estado <= initialization;
-- 
--    elsif clk'event and clk = '1' then
--      case estado is
--        when initialization =>          -- A la espera de la entrada en operacion del sensor.
--          if meas_ena = '1' then
--            estado <= configure;
--            
--          end if;
--          
--        when configure =>               -- Realizar las configuraciones del esclavo.
--          estado <= measure;
-- 
--        when measure =>                 -- Operacion de escritura/lectura.
--          tipo_op_nW_R <= '1';
--          reg_addr     <= X"28";
--      end case;
--
--    end if;
--  end process;
  
  -- Control de cnt_t_meas.
  process(clk, nRst)
  begin
    if nRst = '0' then
      cnt_t_meas <= (others => '0');
      meas_ena <= '0';
      
    elsif clk'event and clk = '1' then
      if meas_ena = '1' then              -- Si la señal meas_ena no está activa, no se deben realizar lecturas.
        if cnt_t_meas < MEAS_T_CLK then
          cnt_t_meas <= cnt_t_meas + 1;
          
        else 
          cnt_t_meas <= (others => '0');
          
        end if;

      else                                -- Reutilizamos el contador para realizar la espera inicial de 2 ms.
        if cnt_t_meas < INIT_T_CLK then
          cnt_t_meas <= cnt_t_meas + 1;
          
        else 
          cnt_t_meas <= (others => '0');  -- Finalizada la espera, se resetea el contador y
          meas_ena <= '1';                -- Se activa la señal meas_ena.
          
        end if;
        
      end if;
    end if;
  end process;
  
--  ini_tx <= '1' when (etado = measure   and meas_ena = '1' and cnt_t_meas = MEAS_T_CLK) and ready_tx = '1' else
--            '1' when (etado = configure and meas_ena = '1')                             and ready_tx = '1' else
--            '0';

end rtl;