library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity test_top_fase_1 is
end entity;

architecture test of test_top_fase_1 is

-- Segnales del DUT
  signal clk:          std_logic;
  signal nRst:         std_logic;
  signal pos_X:        std_logic_vector(1 downto 0);
  signal pos_Y:        std_logic_vector(1 downto 0);
  signal nCS:          std_logic;
  signal SPC:          std_logic;
  signal MISO:         std_logic;
  signal MOSI:         std_logic;
  signal ini_tx:       std_logic;
  signal tipo_op_nW_R: std_logic;
  signal reg_addr:     std_logic_vector(5 downto 0);
  signal dato_wr:      std_logic_vector(7 downto 0);
  signal ena_rd:       std_logic;
  signal dato_rd:      std_logic_vector(7 downto 0);
  signal ready_tx:     std_logic;
  
  constant Tclk:       time := 20 ns; -- reloj de 50 MHz
  
  begin

  -- Reloj de 50 MHz
  process
  begin
    clk <= '0';
    wait for Tclk/2;
    clk <= '1';
    wait for Tclk/2;
  end process;
  
  -- Esclavo SPI
  agente_spi: entity work.agente_spi(sim)
    port map(pos_X => pos_X,
             pos_Y => pos_Y,
             nCS   => nCS,
             SPC   => SPC,
             SDI   => MOSI,
             SDO   => MISO);

  -- DUT
  spi_master: entity work.spi_master(rtl)
    port map(clk          => clk         ,
             nRst         => nRst        ,
             nCS          => nCS         ,
             SPC          => SPC         ,
             MISO         => MISO         ,
             MOSI         => MOSI         ,
             ini_tx       => ini_tx      ,
             tipo_op_nW_R => tipo_op_nW_R,
             reg_addr     => reg_addr    ,
             dato_wr      => dato_wr     ,
             ena_rd       => ena_rd      ,
             dato_rd      => dato_rd     ,
             ready_tx     => ready_tx);
  
-- Secuencia de estimulos

  process
  begin
    report "*********************************************TEST: comienza el test";
    report "*********************************************TEST: comienza el reset asincrono";
    -- Reset
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    nRst <= '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    
    nRst <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    ini_tx <= '0';
    dato_wr      <= X"00";
    reg_addr     <= "000000";
    tipo_op_nW_R <= '0';
    pos_X <= "00";
    pos_Y <= "00";
    
    
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    nRst <= '1';
    
    -- Fin de reset
    
    -- 1: tx de escritura
    report "1: tx de escritura";
    
    wait for 10*Tclk;
    wait until clk'event and clk = '1';
    
    tipo_op_nW_R <= '0';
    reg_addr <= "101010";
    dato_wr <= X"ea";
    wait until clk'event and clk = '1';
    
    ini_tx <= '1';
    wait until clk'event and clk = '1';
    ini_tx <= '0';
    
    wait for 200 us;
    wait until clk'event and clk = '1';
    
    
    -- 2: tx de lectura pos_X 00, pos_Y 00
    report "2: tx de lectura pos_X 00, pos_Y 00";
    
    pos_X <= "00";
    pos_Y <= "00";
    
    tipo_op_nW_R <= '1';
    reg_addr <= "110011";
    wait until clk'event and clk = '1';
    
    ini_tx <= '1';
    wait until clk'event and clk = '1';
    ini_tx <= '0';
    
    wait for 200 us;
    wait until clk'event and clk = '1';
    
    
    -- 3: tx de lectura pos_X 10, pos_Y 10
    report "3: tx de lectura pos_X 10, pos_Y 10";
    
    pos_X <= "10";
    pos_Y <= "10";
    
    tipo_op_nW_R <= '1';
    reg_addr <= "110011";
    wait until clk'event and clk = '1';
    
    ini_tx <= '1';
    wait until clk'event and clk = '1';
    ini_tx <= '0';
    
    wait for 200 us;
    wait until clk'event and clk = '1';
    
    
    -- 4: tx de lectura pos_X 11, pos_Y 11
    report "4: tx de lectura pos_X 11, pos_Y 11";
    
    pos_X <= "11";
    pos_Y <= "11";
    
    tipo_op_nW_R <= '1';
    reg_addr <= "110011";
    wait until clk'event and clk = '1';
    
    ini_tx <= '1';
    wait until clk'event and clk = '1';
    ini_tx <= '0';
    
    wait for 200 us;
    wait until clk'event and clk = '1';
  
    -- Fin del test
    assert false
    report "fin del test de MEDTH"
    severity failure;

  end process;
end test;
