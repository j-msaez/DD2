-- Fichero spi_master.vhd
-- Descripcion del fichero
--
-- El reloj del circuito es de 50 MHz (Tclk = 20 ns)
--
-- Especificación funcional y detalles de la implementación:
--
--
--    Designer: d.allegue@alumnos.upm.es, hector.garpalencia@alumnos.upm.es & j.msaez@alumnos.upm.es
--    Versión: 1.0
--    Fecha: 25-04-2022

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity spi_master is
port(clk:           in std_logic;                         -- Señal de reloj.
     nRst:          in std_logic;                         -- Reset asíncrono.

     -- Entradas/Salidas linea SPI a 4 hilos
     nCS:           buffer std_logic;                     -- Liena SPI Chip Select (nCS)
     SPC:           buffer std_logic;                     -- Linea SPI Serial Peripheral Clock (SPC)
     SDI:           in std_logic;                         -- Linea SPI Slave Data In (SDI)
     SDO:           buffer std_logic;                     -- Linea SPI Slave Data Out (SDO)

     -- Entradas de control externo
     ini_tx:        in std_logic;                         -- Orden de inicio de transaccion
     tipo_op_nW_R:  in std_logic;                         -- nW/R, ('0' escribir un byte, '1' leer) 
     
     -- Entradas de datos de escritura
     reg_addr:      in std_logic_vector(5 downto 0);      -- Registro sobre el cual se realizan las operaciones de RW.

     -- Entradas de datos de escritura
     dato_wr:       in std_logic_vector(7 downto 0);      -- Dato de escritura entrante.

     -- Salidas de datos de lectura
     ena_rd:        buffer std_logic;                     -- Indicacion de dato de lectura valido. ('0' dato invalido, '1' dato valido) aka fin_byte
     dato_rd:       buffer std_logic_vector(7 downto 0);  -- Dato de lectura saliente.

     -- Salidas de control externo
     ready_tx:      buffer std_logic                      -- Indicaccion de estado ('0' ocupado, '1' libre)
     );
end entity;

architecture rtl of spi_master is
-- Estado del gestor del bus y signals de control derivadas
  type t_estado is (libre, start_tx, wr_op, rd_op, end_tx);
  signal estado: t_estado;

  constant SPI_T_CLK: natural := 8;                 -- Periodo de SPC en tics de 20 ns (8 -> T=160 ns -> f=6.25MHz)
  constant SPI_T_2_CLK: natural := 5;               -- Semiperiodo de SPC en tics de 20 ns.
  constant SPI_ENA_RD: natural := 5;                -- Habilitacion de lectura del bit en SDI.
  constant SPI_ENA_WR: natural := 2;                -- Habilitacion de escritura del bit en SDO, para respetar t_h(SDO)
  
  
  signal SPC_ena: std_logic;                        -- Habilita la generacion de SPC.
  signal SPC_ena_rd: std_logic;                     -- Identifica un flanco de subida.
  signal SPC_ena_wr: std_logic;                     -- Identifica un flanco de bajada.
  signal SPC_cnt: std_logic_vector(3 downto 0);     -- Contador de numero de tics de 20 ns para generacion de SPC.
  
  signal reg_SDO: std_logic_vector(15 downto 0);    -- registro para desplazamiento del dato de salida
  signal reg_SDI: std_logic_vector(31 downto 0);    -- registro para desplazamiento del dato de entrada, cuando esta completo:
                                                    -- reg_SDI(31 downto 24): OUT_X_L
                                                    -- reg_SDI(23 downto 16): OUT_X_H
                                                    -- reg_SDI(15 downto 8): OUT_Y_L
                                                    -- reg_SDI(7 downto 0): OUT_Y_H
  
  signal cnt_bits_tx: std_logic_vector(5 downto 0); -- Numero de bits transmitidos en una operacion ya sean de lectura o escritura (max 40)
  
  signal fin_tx: std_logic;                         -- Fin de transaccion.
  
  signal ena_rd_reg: std_logic;                     -- Salida ena_rd registrada para evitar glitches.
--  signal ready_tx_reg: std_logic;                   -- Salida ready_tx registrada para evitar glitches.

begin
  -- Maquina de estados para el control de transacciones
  process(clk, nRst)
  begin
    if nRst = '0' then
      estado         <= libre;
--    ena_rd         <= '0';
--    cnt_bits_tx <= (others => '0');
      SPC_ena <= '0';
      nCS <= '1';

    elsif clk'event and clk = '1' then
      case estado is
        when libre =>                   -- Preparado para transmitir.
          if ini_tx = '1' then          -- Orden de comienzo.
            nCS <= '0';                 -- Activar Chip Select (nCS)
            estado <= start_tx;
            
          end if;
          
        when start_tx =>                -- Comienzo de la transmision.
          SPC_ena <= '1';               -- Habilitar la generacion de SPC.
          
          if tipo_op_nW_R = '0' then    -- Operacion de escritura.
            estado <= wr_op;

          elsif tipo_op_nW_R = '1' then -- Operacion de lectura.
            estado <= rd_op;
          
          end if;

        when wr_op | rd_op =>           -- Operacion de escritura/lectura.
          if fin_tx = '1' then          -- Fin de la transmsion.
            estado <= end_tx;
            SPC_ena <= '0';             -- Deshabilitar generacion de SPC.

          end if;
        
        when end_tx =>                  -- Fin de la transmsion.
          nCS <= '1';                   -- Desctivar Chip Select (nCS)
          estado <= libre;
          
      end case;

    end if;
  end process;

  ready_tx <= nCS;

-- -- Comentario:
-- process(clk, nRst)
-- begin
--   if nRst = '0' then
--     ready_tx <= '0';
--     
--   elsif clk'event and clk = '1' then
--     ready_tx <= ready_tx_reg;
--     
--   end if;
-- end process;
-- 
-- ready_tx_reg <= nCS;

  -- Generacion de la señal de reloj (SPC) para el bus SPI.
  process(clk, nRst)
  begin
    if nRst = '0' then
      SPC_cnt <= (0 => '1', others => '0');

    elsif clk'event and clk = '1' then
      if SPC_ena = '1' then -- utilizar un ena_SPC en vez de nCS para habilitar SPC respetando tiempos o ya se respetan porque esto es un ciclo de reloj despues en verdad?
        if SPC_cnt < SPI_T_CLK then
          SPC_cnt <= SPC_cnt + 1;

        else
          SPC_cnt <= (0 => '1', others => '0');
       
        end if;
        
      end if;
    end if;
  end process;

  SPC <= '0' when SPC_cnt < SPI_T_2_CLK and SPC_ena = '1' else
         '1';

  SPC_ena_rd <= '1' when SPC_cnt = SPI_ENA_RD else
                '0';


  SPC_ena_wr <= '1' when SPC_cnt = SPI_ENA_WR else
              '0';

-- hacer filtrado de SPC como se hacia para scl en i2c?

-- Control de cnt_bits_tx.
  process(clk, nRst)
  begin
    if nRst = '0' then
      cnt_bits_tx <= (0 => '1', others => '0');
      
    elsif clk'event and clk = '1' then
      if estado = start_tx then
        cnt_bits_tx <= (0 => '1', others => '0');
        
      elsif SPC_ena_wr = '1' and ((estado = wr_op and cnt_bits_tx <= 16) or (estado = rd_op and cnt_bits_tx <= 8)) then
        cnt_bits_tx <= cnt_bits_tx + 1;
        
      elsif SPC_ena_rd = '1' and estado = rd_op and cnt_bits_tx > 8 and cnt_bits_tx <= 40 then
        cnt_bits_tx <= cnt_bits_tx + 1;
        
      end if;
      
    end if;
  end process;


  -- Reg_out: Registro de desplazamiento para los datos de salida
  -- escritura de bit en flancos de bajada de SPC
  -- implementado para que la escritura del bit se produzca un ciclo
  -- de clk más tarde, para respetar t_h(SO)=5ns
  process(clk, nRst)
  begin
    if nRst = '0' then
      reg_SDO <= (others => '0');
      SDO <= '1'; -- OJO
      
    elsif clk'event and clk = '1' then
      if estado = start_tx then
        if tipo_op_nW_R = '0' then                            -- Operacion de escritura.
          reg_SDO <= tipo_op_nW_R & tipo_op_nW_R & reg_addr & -- primer byte: tipo de operacion y direccion.
                     dato_wr;                                 -- segundo byte: dato a escribir.

        elsif tipo_op_nW_R = '1' then                         -- Operacion de lectura.
          reg_SDO <= tipo_op_nW_R & tipo_op_nW_R & reg_addr & -- primer byte: tipo de operacion y direccion.
                     X"00";                                   -- segundo byte: vacio para operaciones de lectura.
        
        end if;
        
      elsif SPC_ena_wr = '1' and 
         ((estado = wr_op and cnt_bits_tx <= 16) or 
         (estado = rd_op and cnt_bits_tx <= 8)) then
         
        SDO <= reg_SDO(15);
        reg_SDO <= reg_SDO(14 downto 0) & '0'; -- OJO
        
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
         
      end if;
      
    end if;
  end process;
  
  -- ena_rd: salida registrada que indica cuando s¡un dato es valido
  -- para su lectura. (Filtrar glitches)
  process(clk, nRst)
  begin
    if nRst = '0' then
      ena_rd <= '0';
      
    elsif clk'event and clk = '1' then
      ena_rd <= ena_rd_reg;
      
    end if;
  end process;
  
  -- Presenta glitches. Registrar la señal.
  ena_rd_reg <= '1' when estado = rd_op and SPC_ena_rd = '1' and (cnt_bits_tx = 16 or cnt_bits_tx = 24 or cnt_bits_tx = 32 or cnt_bits_tx = 40) else
                '0';
  
  dato_rd <= reg_SDI(7 downto 0); -- OJO
  
  -- Generacion de señal de fin de transmision
  fin_tx <= '1' when estado = wr_op and cnt_bits_tx = 16 and SPC_cnt = SPI_T_2_CLK else
            '1' when estado = rd_op and cnt_bits_tx = 40 else -- OJO
            '0';

end rtl;