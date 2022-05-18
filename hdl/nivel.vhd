library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity nivel is
  port(
  clk:              in std_logic;
  nRst:             in std_logic;
  nCS:              buffer std_logic;
  SPC:              buffer std_logic;
  MISO:             in std_logic;
  MOSI:             buffer std_logic;
  seg             : buffer std_logic_vector(6 downto 0);
  disp            : buffer std_logic_vector(7 downto 0);
  leds            : buffer std_logic_vector(7 downto 0)
  );
end entity;

architecture struct of nivel is

  signal ini_tx:           std_logic;
  signal tipo_op_nW_R:     std_logic;
  signal reg_addr:         std_logic_vector(5 downto 0);
  signal dato_wr:          std_logic_vector(7 downto 0);
  signal ena_rd:           std_logic;
  signal dato_rd:          std_logic_vector(7 downto 0);
  signal ready_tx:         std_logic;
  signal X_out_bias:       std_logic_vector(10 downto 0);
  signal Y_out_bias:       std_logic_vector(10 downto 0);
  signal muestra_bias_rdy: std_logic;
  signal X_media:          std_logic_vector(11 downto 0); 
  signal Y_media:          std_logic_vector(11 downto 0);
  
  
  begin

  spi_master: entity work.spi_master(rtl)
    port map(clk          => clk         ,
             nRst         => nRst        ,
             nCS          => nCS         ,
             SPC          => SPC         ,
             MISO         => MISO        ,
             MOSI         => MOSI        ,
             ini_tx       => ini_tx      ,
             tipo_op_nW_R => tipo_op_nW_R,
             reg_addr     => reg_addr    ,
             dato_wr      => dato_wr     ,
             ena_rd       => ena_rd      ,
             dato_rd      => dato_rd     ,
             ready_tx     => ready_tx);
  
  spi_controlador: entity work.spi_controlador(rtl)
    port map(clk          => clk         ,
             nRst         => nRst        ,
             ini_tx       => ini_tx      ,
             tipo_op_nW_R => tipo_op_nW_R,
             reg_addr     => reg_addr    ,
             dato_wr      => dato_wr     ,
             ready_tx     => ready_tx);
  
  calc_offset: entity work.calc_offset(rtl)
    generic map(N => 64)
    port map (nRst              => nRst            ,
              clk               => clk             ,
              ena_rd            => ena_rd          ,
              dato_rd           => dato_rd         ,
              X_out_bias        => X_out_bias      ,
              Y_out_bias        => Y_out_bias      ,
              muestra_bias_rdy  => muestra_bias_rdy);
  
  estimador: entity work.estimador(rtl)
    generic map(N => 32)
    port map (nRst             => nRst            ,
              clk              => clk             ,
              X_out_bias       => X_out_bias      ,
              Y_out_bias       => Y_out_bias      ,
              muestra_bias_rdy => muestra_bias_rdy,
              X_media          => X_media         ,
              Y_media          => Y_media         );
              
  representacion: entity work.representacion(rtl)
    port map (clk           => clk    ,
              nRst          => nRst   ,
              X_media       => X_media,
              Y_media       => Y_media,
              seg           => seg    ,
              disp          => disp   ,
              leds          => leds   );
  
end struct;
