library work;
use work.auxiliar.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

-- Lleva a cabo la medida del offset inicial
-- mediante el promediado de una serie configurable de medidas al inicio de operación.
-- La medida del offset inicial se hace los primeros 320 ms, que se corresponde con 64 medidas
-- Posteriomente, calcula el valor corregido de las muestras en X e Y a partir del offset
-- previamente calculado.

entity calc_offset is
generic(N:        in positive := 32);     -- numero de registros del banco (potencia de 2) aka numero de medidas para calculo de offset inicial (64 para nuestra aplicacion)
port(nRst:             in     std_logic;
     clk:              in     std_logic;
     
     -- Entradas para calc_offset, salidas de spi_master
     ena_rd:           in     std_logic;
     dato_rd:          in     std_logic_vector(7 downto 0);

     -- Salidas para calc_offset, entradas para estimador
     X_out_bias:       buffer std_logic_vector(10 downto 0);
     Y_out_bias:       buffer std_logic_vector(10 downto 0);
     muestra_bias_rdy: buffer std_logic);
     
end entity;

architecture rtl of calc_offset is
  signal cnt_rd:          std_logic_vector(2+ceil_log(N) downto 0); -- 9 bits -> un bit mas que para 256 cuentas -> 256/4 = 64 medidas de X (2 lecturas para cada medida de X), lo mismo para Y
  signal ena_calc:        std_logic;
  signal offset_rdy:      std_logic;

  signal muestra_X:       std_logic_vector(9 downto 0); 
  signal muestra_Y:       std_logic_vector(9 downto 0); 

  signal offset_X:        std_logic_vector(10 downto 0); 
  signal offset_Y:        std_logic_vector(10 downto 0); 
 
  signal acum_X:          std_logic_vector(9+ceil_log(N) downto 0); -- 15 bits, hasta
  signal acum_Y:          std_logic_vector(9+ceil_log(N) downto 0); 

begin
  -- Contador de lecturas
  process(nRst, clk)
  begin
    if nRst = '0' then
      cnt_rd <= (others => '0');
      ena_calc <= '0';
      muestra_bias_rdy <= '0';

    elsif clk'event and clk = '1' then
      if ena_rd = '1' then
        cnt_rd(1 downto 0) <= cnt_rd(1 downto 0) + 1;
        if cnt_rd(1 downto 0) = "11" then
          if offset_rdy = '0' then
            cnt_rd(2+ceil_log(N) downto 2) <= cnt_rd(2+ceil_log(N) downto 2) + 1;
            ena_calc <= '1';

          else -- el offset ya se ha hecho y se le pasa una medida al estimador
            muestra_bias_rdy <= '1';

          end if;          
        end if;

      else -- si ena_rd = '0' se desactivan señales de habilitacion
        ena_calc <= '0';
        muestra_bias_rdy <= '0';

      end if;
    end if;
  end process;

  offset_rdy <= cnt_rd(2+ceil_log(N));


  -- Captura de valores de muestras
  process(nRst, clk)
  begin
    if nRst = '0' then
      muestra_X <= (others => '0');
      muestra_Y <= (others => '0');

    elsif clk'event and clk = '1' then
      if ena_rd = '1' then
        case cnt_rd(1 downto 0) is
          when "00" => muestra_X(1 downto 0) <= dato_rd(7 downto 6);
          when "01" => muestra_X(9 downto 2) <= dato_rd;
          when "10" => muestra_Y(1 downto 0) <= dato_rd(7 downto 6);
          when "11" => muestra_Y(9 downto 2) <= dato_rd;
          when others => null;

        end case;
      end if;
    end if;
  end process;

  -- Acumulador
  process(nRst, clk)
  begin
    if nRst = '0' then
      acum_X <= (others => '0');
      acum_Y <= (others => '0');

    elsif clk'event and clk = '1' then  
      if ena_calc = '1' then
        acum_X <= acum_X + muestra_X;
        acum_Y <= acum_Y + muestra_Y;

      end if;
    end if;
  end process;

  offset_X <= acum_X(9+ceil_log(N))&acum_X(9+ceil_log(N) downto ceil_log(N)); -- medida del offset inicial 
  offset_Y <= acum_Y(9+ceil_log(N))&acum_Y(9+ceil_log(N) downto ceil_log(N)); -- medida del offset inicial 

  X_out_bias <= muestra_X - offset_X when offset_rdy = '1' else
                (others => '0');
  Y_out_bias <= muestra_Y - offset_Y when offset_rdy = '1' else
                (others => '0');


end rtl;