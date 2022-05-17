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
  -- signal N_X_aux  : std_logic_vector(3 downto 0);
  -- signal N_Y_aux  : std_logic_vector(3 downto 0);
  
  -- -- señales auxiliares con las que comparar la medida real
  -- signal medida_X_aux  : std_logic_vector(11 downto 0);
  -- signal medida_Y_aux  : std_logic_vector(11 downto 0);
  -- 
  -- -- tic para multiplexacion de displays (fdc = 50000)
  -- signal cnt_tic_1ms  : std_logic_vector(15 downto 0);
  -- signal T_TIC_MUX  : natural := 50000;
  
  -- -- señal para marcar que leds/displays tienen que encenderse
  -- signal mascara_on : std_logic_vector(7 downto 0);
  

begin
  
  -- Los displays muestran el simbolo '8' cuando estan encendidos
  seg <= "1111111";
  
  -- Obtencion de N_X para valores de la formula medida_eje < (2*N-15)/15
  N_X <= X"1" when X_media < "1100100011" else -- 0d-221 -> -0.867 g
         X"2" when X_media < "1101000101" else -- 0d-187 -> -0.733 g
         X"3" when X_media < "1101100111" else -- 0d-153 -> -0.600 g
         X"4" when X_media < "1110001001" else -- 0d-119 -> -0.467 g
         X"5" when X_media < "1110101011" else -- 0d-85  -> -0.333 g
         X"6" when X_media < "1111001101" else -- 0d-51  -> -0.200 g
         X"7" when X_media < "1111101111" else -- 0d-17  -> -0.067 g
         X"8" when X_media < "0000010001" else -- 0d17   ->  0.067 g
         X"9" when X_media < "0000110011" else -- 0d51   ->  0.200 g
         X"A" when X_media < "0001010101" else -- 0d85   ->  0.333 g
         X"B" when X_media < "0001110111" else -- 0d119  ->  0.467 g
         X"C" when X_media < "0010011001" else -- 0d153  ->  0.600 g
         X"D" when X_media < "0010111011" else -- 0d187  ->  0.733 g
         X"E" when X_media < "0011011101" else -- 0d221  ->  0.867 g
         X"F";                                 -- 0d255  ->  1.000 g
  
  -- Obtencion de N_Y para valores de la formula medida_eje < (2*N-15)/15
  N_Y <= X"1" when Y_media < "1100100011" else -- 0d-221 -> -0.867 g
         X"2" when Y_media < "1101000101" else -- 0d-187 -> -0.733 g
         X"3" when Y_media < "1101100111" else -- 0d-153 -> -0.600 g
         X"4" when Y_media < "1110001001" else -- 0d-119 -> -0.467 g
         X"5" when Y_media < "1110101011" else -- 0d-85  -> -0.333 g
         X"6" when Y_media < "1111001101" else -- 0d-51  -> -0.200 g
         X"7" when Y_media < "1111101111" else -- 0d-17  -> -0.067 g
         X"8" when Y_media < "0000010001" else -- 0d17   ->  0.067 g
         X"9" when Y_media < "0000110011" else -- 0d51   ->  0.200 g
         X"A" when Y_media < "0001010101" else -- 0d85   ->  0.333 g
         X"B" when Y_media < "0001110111" else -- 0d119  ->  0.467 g
         X"C" when Y_media < "0010011001" else -- 0d153  ->  0.600 g
         X"D" when Y_media < "0010111011" else -- 0d187  ->  0.733 g
         X"E" when Y_media < "0011011101" else -- 0d221  ->  0.867 g
         X"F";                                 -- 0d255  ->  1.000 g
  
  leds <= "10000000" when N_X = X"1" else
          "11000000" when N_X = X"2" else
          "11100000" when N_X = X"3" else
          "11110000" when N_X = X"4" else
          "11111000" when N_X = X"5" else
          "11111100" when N_X = X"6" else
          "11111110" when N_X = X"7" else
          "11111111" when N_X = X"8" else
          "01111111" when N_X = X"9" else
          "00111111" when N_X = X"A" else
          "00011111" when N_X = X"B" else
          "00001111" when N_X = X"C" else
          "00000111" when N_X = X"D" else
          "00000011" when N_X = X"E" else
          "00000001"; -- when N_X = X"F"
  
  disp <= "10000000" when N_Y = X"1" else
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
  
  
  -- OJO Estos dos procesos comentados serian para obtener N_X y N_Y de manera "dinamica",
  -- calculando la formula durante ejecucion
  -- process(clk, nRst)
  -- begin
  --   if nRst = '0' then
  --     N_X     <= (others => '0');
  --     N_X_aux <= (others => '0');
  --     N_X     <= (others => '0');
  --     N_Y_aux <= (others => '0');
  --     
  --   elsif clk'event and clk = '1' then
  --     
  --     if N_X_aux
  --     
  --   end if;
  -- end process;
  -- 
  -- se realiza el calculo de la derecha de la siguiente formula:
  -- medida_eje < (2*N-15)/15 [g]
  -- medida_X_aux <= ((N_x(1)) & '0') - 15); -- como se hace /15?? -> vale, seria pasar el 15 multiplicando a la izquierda)
  
  -- OJO, hace falta multiplexar displays?
  -- -- Generacion de tic para multiplexacion de displays
  -- process(clk, nRst)
  -- begin
  --   if nRst = '0' then
  --     cnt_tic_1ms <= (0=> '0',others => '1');
  --     
  --   elsif clk'event and clk = '1' then
  --   
  --     if cnt_tic_1ms = T_TIC_MUX then
  --       cnt_tic_1ms <= (0=> '0',others => '1');
  --     else
  --       cnt_tic_1ms <= cnt_tic_1ms + 1;
  --     end if;
  --     
  --   end if;
  -- end process;
  -- 
  --- - Activacion de los catodos
  -- atodos: process(clk, nRst)
  -- begin
  --   if nRst = '0' then
  --     disp <= (0=> '0',others => '1');
  --     
  --   elsif clk'event and clk = '1' then
  --   
  --     if tic_1ms = '1' then
  --       disp <= disp(6 downto 0) & disp(7);
  --     end if;
  --     
  --   end if;
  -- end process catodos;
  
end rtl;