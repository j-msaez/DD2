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

     -- Salidas de control externo
     ready_tx:      in std_logic                          -- Indicaccion de estado del master SPI ('0' ocupado, '1' libre)
     );
end entity;

architecture rtl of spi_controlador is
---- Estado del gestor del bus y signals de control derivadas
  type t_estado is (initialization, configure_reg_4, configure_reg_1, measure);
  signal estado: t_estado;
  
-- (Revisar) 2.6.3 High resolution, normal mode, low-power mode - Table 9. Operating mode selection 
-- Normal mode: Turn-on time [ms] -> 1.6 ms ~ 2 ms (margen de seguridad)

  constant T_CNT_5_ms: natural := 250000;               -- Periodo de 5ms para realizar lecturas periodicas (250000 * 20ns -> 5 ms).
  
  signal cnt_t_meas: std_logic_vector(17 downto 0); -- Contador para generar la temporizacion de la realizacion de medidas (250000 -> 18 bits)
  
  signal conf_op: std_logic;                        -- Signal que indica cuando se está produciendo una operacion de configuracion.
  
begin
  
  -- ¿Automata para manejar que hacer en cada momento?
  -- Maquina de estados para el controlador.
  process(clk, nRst)
  begin
    if nRst = '0' then
      estado <= initialization;
      
      conf_op <= '0';
      
      tipo_op_nW_R <= '0';
      reg_addr     <= (others => '0');
      dato_wr      <= (others => '0');
      ini_tx       <= '0';
      
    elsif clk'event and clk = '1' then
      
      case estado is
        when initialization =>  -- A la espera de la entrada en operacion del sensor.
          if cnt_t_meas = T_CNT_5_ms then
            estado <= configure_reg_4;
            
          end if;
          
        when configure_reg_4 => -- Realizar las configuraciones del esclavo.
          
          if conf_op = '0' and ready_tx = '1' then
            conf_op      <= '1';              -- Indicacion de operacion de configuracion en curso.
            
            tipo_op_nW_R <= '0';              -- Write Operation.
            reg_addr     <= "100011";         -- CTRL_REG4 register (0x23) -> BDU BLE FS1 FS0  HR ST1 ST0 SIM 
            dato_wr      <= X"80";            -- CTRL_REG4 value    (0x80) ->  1   0   0   0   0   0   0   0  
            ini_tx       <= '1';              -- Init Operation.
            
          elsif ini_tx = '1' and ready_tx = '0' then
            ini_tx       <= '0';              -- Desactivar signal de inicio de operacion ( 1 ciclo de reloj)
          
          elsif ini_tx = '0' and ready_tx = '1' then
            estado       <= configure_reg_1;
            conf_op      <= '0';              -- Indicacion de operacion de configuracion finalizada.
            
          end if;
          
        when configure_reg_1 => -- Realizar las configuraciones del esclavo.
        
          if conf_op = '0' and ini_tx = '0' and ready_tx = '1' then
            conf_op      <= '1';            -- Indicacion de operacion de configuracion en curso.
            
            tipo_op_nW_R <= '0';            -- Write Operation.
            reg_addr     <= "100000";       -- CTRL_REG1 register (0x20) -> ODR3 ODR2 ODR1 ODR0 LPen Zen Yen Xen
            dato_wr      <= X"63";          -- CTRL_REG1 value    (0x63) ->  0    1    1    0    0    0   1   1 
            ini_tx       <= '1';            -- Init Operation.
          
          elsif ini_tx = '1' and ready_tx = '0' then
            ini_tx       <= '0';            -- Desactivar signal de inicio de operacion ( 1 ciclo de reloj)
          
          elsif ini_tx = '0' and ready_tx = '1' then
            estado       <= measure;
            conf_op      <= '0';            -- Indicacion de operacion de configuracion finalizada.
            
          end if;
          
        when measure => -- Operacion de escritura/lectura.
          
          if ready_tx = '1' and cnt_t_meas = T_CNT_5_ms then
            tipo_op_nW_R <= '1';          -- Read Operation.
            reg_addr     <= "101000";     -- OUT_X_L register (0x28)
            ini_tx       <= '1';          -- Init Operation.
          
          elsif ini_tx = '1' and ready_tx = '0' then
            ini_tx       <= '0';
          
          end if;
          
        end case;
      
    end if;
  end process;
  
  -- Control de cnt_t_meas.
  process(clk, nRst)
  begin
    if nRst = '0' then
      cnt_t_meas <= (others => '0');
      
    elsif clk'event and clk = '1' then
      if cnt_t_meas < T_CNT_5_ms then
        cnt_t_meas <= cnt_t_meas + 1;
        
      else 
        cnt_t_meas <= (others => '0');
        
      end if;
    end if;
  end process;

end rtl;