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
     ena_rd:        buffer std_logic;                     -- Indicacion de dato de lectura valido. ('0' dato invalido, '1' dato valido) 
     dato_rd:       buffer std_logic_vector(7 downto 0);  -- Dato de lectura saliente.

     -- Salidas de control externo
     ready_tx:      buffer std_logic                      -- Indicaccion de estado ('0' ocupado, '1' libre)
     );
end entity;

architecture rtl of spi_master is
-- Estado del gestor del bus y segnales de control derivadas
  type t_estado is (libre, start_tx, wr_op, rd_op, end_tx);
  signal estado: t_estado;

  signal SPC_cnt: std_logic_vector(3 downto 0); -- contador de numero de tics de 20 ns para generacion de SPC
  constant SPI_T_CLK: natural := 8; -- periodo de SPC en tics de 20 ns (8 -> T=160 ns -> f=6.25MHz)
  constant SPI_T_2_CLK: natural := 4;
  constant SPI_ENA_RD: natural := 5; -- habilitacion de lectura del bit en SDI
  constant SPI_ENA_WR: natural := 2; -- habilitacion de escritura del bit en SDO
  
  signal SPC_ena_rd: std_logic; -- identifica un flanco de subida
  signal SPC_ena_wr: std_logic; -- identifica un flanco de bajada
  signal SPC_ena: std_logic;
  
  signal reg_SDO: std_logic_vector(15 downto 0); -- registro para desplazamiento del dato de salida
  signal reg_SDI: std_logic_vector(31 downto 0); -- registro para desplazamiento del dato de entrada, cuando esta completo:
                                                 -- reg_SDI(31 downto 24): OUT_X_L
                                                 -- reg_SDI(23 downto 16): OUT_X_H
                                                 -- reg_SDI(15 downto 8): OUT_Y_L
                                                 -- reg_SDI(7 downto 0): OUT_Y_H
  
  signal cnt_bits_tx: std_logic_vector(5 downto 0); -- numero de bits transmitidos en una operacion ya sean de lectura o escritura (max 40)
  signal cnt_T_clks: std_logic_vector(5 downto 0); -- numero de bits transmitidos en una operacion ya sean de lectura o escritura (max 40)
  
  signal fin_tx: std_logic;                      -- Fin de transaccion.

begin
  -- Maquina de estados para el control de transacciones
  process(clk, nRst)
  begin
    if nRst = '0' then
      estado         <= libre;
      fin_tx         <= '1';
      ready_tx       <= '1';
      ena_rd         <= '0';
      cnt_bits_tx <= (others => '0');
      SPC_ena <= '0';

    elsif clk'event and clk = '1' then
      case estado is
        when libre =>                                 -- Preparado para transmitir
          if ini_tx = '1' then                        -- Orden de start
            CS <= '0';
            estado <= start_tx;
            
          end if;
          
        when start_tx =>
          SPC_ena <= '1';
          
          if tipo_op_nW_R = '0' then -- write
            estado <= wr_op;
            reg_SDO <= tipo_op_nW_R & tipo_op_nW_R & reg_addr & -- primer byte: tipo de operacion y direccion
                       dato_wr;                                 -- segundo byte: dato a escribir

          elsif tipo_op_nW_R = '1' then -- read
            estado <= rd_op;
            reg_SDO <= tipo_op_nW_R & tipo_op_nW_R & reg_addr & -- primer byte: tipo de operacion y direccion
                       X"00";                                   -- segundo byte vacio para operaciones de lectura
            reg_SDI <= (others => '0');
          
          end if;

        when wr_op | rd_op =>
          if fin_tx = '1' then
            estado <= end_tx;
            cnt_bits_tx <= (others => '0');
            SPC_ena <= '0';

          end if;
        
        when end_tx =>
          CS <= '1';
          estado <= libre;
          
      end case;

    end if;
  end process;

  ready_tx <= CS;

  -- Generacion de la señal de reloj para el bus SPI
  process(clk, nRst)
  begin
    if nRst = '0' then
     SPC <= '1';
     SPC_cnt <= (0 => '1', others => '0');

    elsif clk'event and clk = '1' then
      if SPC_ena = '0' then -- utilizar un ena_SPC en vez de CS para habilitar SPC respetando tiempos o ya se respetan porque esto es un ciclo de reloj despues en verdad?
        if SPC_cnt < SPI_T_CLK then
          SPC_cnt <= SPC_cnt + 1;

        else
          SPC_cnt <= (0 => '1', others => '0');
       
        end if;
        
      end if;
    end if;
  end process;

  SPC <= '0' when SPC_cnt < SPI_T_2_CLK and SPC_ena = '0' else
         '1';
  
  SPC_ena_rd <= '1' when SPC_cnt = SPI_ENA_RD else
                '0';
  
  SPC_ena_wr <= '1' when SPC_cnt = SPI_ENA_WR else
              '0';
  
  -- hacer filtrado de SPC como se hacia para scl en i2c?

  -- Reg_out: Registro de desplazamiento para los datos de salida
  -- escritura de bit en flancos de bajada de SPC
  -- implementado para que la escritura del bit se produzca un ciclo
  -- de clk más tarde, para respetar t_h(SO)=5ns
  process(clk, nRst)
  begin
    if nRst = '0' then
      reg_SDO <= (others => '0');
      
    elsif clk'event and clk = '1' then
      if SPC_ena_wr = '1' and 
         ((estado = wr_op and cnt_bits_tx <= 16) or 
         (estado = rd_op and cnt_bits_tx <= 8)) then
      
        SDO <= reg_SDO(15);
        reg_SDO <= reg_SDO(14 downto 0) & '0';
        cnt_bits_tx <= cnt_bits_tx + 1;
        
      end if;
      
    end if;
  end process;

  -- Reg_in: Registro de desplazamiento para los datos de entrada
  -- lectura de bit en flancos de subida de SPC
  process(clk, nRst)
  begin
    if nRst = '0' then
      reg_SDI <= (others => '0');
      
    elsif clk'event and clk = '1' then
      if estado = rd_op and SPC_ena_rd = '1' and 
         cnt_bits_tx > 8 and cnt_bits_tx <= 40 then
         
        reg_SDI <= reg_SDI(30 downto 0) & SDI;
        cnt_bits_tx <= cnt_bits_tx + 1;
         
      end if;
    end if;
  end process;
  
  -- Generacion de señal de fin de transmision
  fin_tx <= '1' when estado = wr_op and cnt_bits_tx = 16 and SPC_cnt = SPI_T_2_CLK else
            '1' when estado = rd_op and cnt_bits_tx = 40 else -- OJO
            '0';


end rtl;