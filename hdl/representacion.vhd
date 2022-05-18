library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity representacion is port(
    clk           : in std_logic;
    nRst          : in std_logic;
    
    -- Resultado de estimador, salidas para estimador, entradas para representacion
    X_media:          in std_logic_vector(11 downto 0); 
    Y_media:          in std_logic_vector(11 downto 0);
    
    -- salidas para control de displays y leds
    seg           : buffer std_logic_vector(6 downto 0);
    disp          : buffer std_logic_vector(7 downto 0);
    leds          : buffer std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of representacion is
  
  -- valores que determinan la representación del grado de inclinacion (del 1 al 15)
  signal N_X      : std_logic_vector(3 downto 0);
  signal N_Y      : std_logic_vector(3 downto 0);
  
  -- tic para multiplexacion de displays (fdc = 50000)
  signal cnt_tic_1ms  : std_logic_vector(15 downto 0);
  signal T_TIC_MUX  : natural := 50000;
  
  -- señal para marcar que leds/displays tienen que encenderse
  signal mascara_on : std_logic_vector(7 downto 0);
  signal display_desplazamiento : std_logic_vector(7 downto 0);
  

begin
  
  -- Los displays muestran el simbolo '8' cuando estan encendidos
  seg <= "1111111";
  
  -- Obtencion de N_X para valores de la formula medida_eje < (2*N-15)/15
  N_X <= X"1" when X_media < -221 else -- -0.867 g
         X"2" when X_media < -187 else -- -0.733 g
         X"3" when X_media < -153 else -- -0.600 g
         X"4" when X_media < -119 else -- -0.467 g
         X"5" when X_media < -85  else -- -0.333 g
         X"6" when X_media < -51  else -- -0.200 g
         X"7" when X_media < -17  else -- -0.067 g
         X"8" when X_media < 17   else -- 0.067 g
         X"9" when X_media < 51   else -- 0.200 g
         X"A" when X_media < 85   else -- 0.333 g
         X"B" when X_media < 119  else -- 0.467 g
         X"C" when X_media < 153  else -- 0.600 g
         X"D" when X_media < 187  else -- 0.733 g
         X"E" when X_media < 221  else -- 0.867 g
         X"F";                         -- 1.000 g
  
  -- Obtencion de N_Y para valores de la formula medida_eje < (2*N-15)/15
  N_Y <= X"1" when Y_media < -221 else -- -0.867 g
         X"2" when Y_media < -187 else -- -0.733 g
         X"3" when Y_media < -153 else -- -0.600 g
         X"4" when Y_media < -119 else -- -0.467 g
         X"5" when Y_media < -85  else -- -0.333 g
         X"6" when Y_media < -51  else -- -0.200 g
         X"7" when Y_media < -17  else -- -0.067 g
         X"8" when Y_media < 17   else --  0.067 g
         X"9" when Y_media < 51   else --  0.200 g
         X"A" when Y_media < 85   else --  0.333 g
         X"B" when Y_media < 119  else --  0.467 g
         X"C" when Y_media < 153  else --  0.600 g
         X"D" when Y_media < 187  else --  0.733 g
         X"E" when Y_media < 221  else --  0.867 g
         X"F";                         --  1.000 g
  
  -- los leds son activos a nivel bajo
  leds <= not "10000000" when N_X = X"1" else
          not "11000000" when N_X = X"2" else
          not "11100000" when N_X = X"3" else
          not "11110000" when N_X = X"4" else
          not "11111000" when N_X = X"5" else
          not "11111100" when N_X = X"6" else
          not "11111110" when N_X = X"7" else
          not "11111111" when N_X = X"8" else
          not "01111111" when N_X = X"9" else
          not "00111111" when N_X = X"A" else
          not "00011111" when N_X = X"B" else
          not "00001111" when N_X = X"C" else
          not "00000111" when N_X = X"D" else
          not "00000011" when N_X = X"E" else
          not "00000001"; -- when N_X = X"F"
  
  mascara_on <= "10000000" when N_Y = X"1" else
          "11000000" when N_Y = X"2" else
          "11100000" when N_Y = X"3" else
          "11110000" when N_Y = X"4" else
          "11111000" when N_Y = X"5" else
          "11111100" when N_Y = X"6" else
          "11111110" when N_Y = X"7" else
          "11111111" when N_Y = X"8" else
          "01111111" when N_Y = X"9" else
          "00111111" when N_Y = X"A" else
          "00011111" when N_Y = X"B" else
          "00001111" when N_Y = X"C" else
          "00000111" when N_Y = X"D" else
          "00000011" when N_Y = X"E" else
          "00000001"; -- when N_Y = X"F"
  
  -- Generacion de tic para multiplexacion de displays
  process(clk, nRst)
  begin
    if nRst = '0' then
      cnt_tic_1ms <= (0=> '0',others => '1');
      
    elsif clk'event and clk = '1' then
    
      if cnt_tic_1ms = T_TIC_MUX then
        cnt_tic_1ms <= (0=> '0',others => '1');
        
      else
        cnt_tic_1ms <= cnt_tic_1ms + 1;
      end if;
      
    end if;
  end process;
  
  -- Activacion de los catodos
  process(clk, nRst)
  begin
    if nRst = '0' then
      display_desplazamiento <= (0=> '1',others => '0');
      disp <= (others => '1');
      
    elsif clk'event and clk = '1' then
    
      if cnt_tic_1ms = T_TIC_MUX then
        display_desplazamiento <= display_desplazamiento(6 downto 0) & display_desplazamiento(7);
        disp <= not (display_desplazamiento and mascara_on); -- activacion de displays activa a nivel bajo
      end if;
      
    end if;
  end process;
  
end rtl;