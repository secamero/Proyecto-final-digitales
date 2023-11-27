LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--------------------------------------------------------------
ENTITY print_in_matrix IS

   GENERIC (lines : INTEGER := 8;
	         X     : INTEGER := 128;
            Y     : INTEGER := 8);
				
   PORT    ( clk       : IN STD_LOGIC;
				 rst       : IN STD_LOGIC;
				 position  : IN STD_LOGIC_VECTOR(X-1 DOWNTO 0);
             filas_out : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0);
		       cols1_out : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0);
		       cols2_out : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0));
				 
END ENTITY print_in_matrix;
---------------------------------------------------------------
ARCHITECTURE behavioral OF print_in_matrix IS

SIGNAL p0 : STD_LOGIC := '0';
SIGNAL p1 : STD_LOGIC := '0';
SIGNAL p2 : STD_LOGIC := '0';
SIGNAL p3 : STD_LOGIC := '0';
SIGNAL p4 : STD_LOGIC := '0';
SIGNAL p5 : STD_LOGIC := '0';
SIGNAL p6 : STD_LOGIC := '0';
SIGNAL p7 : STD_LOGIC := '0';
SIGNAL p8 : STD_LOGIC := '0';

SIGNAL maxtick0 : STD_LOGIC;
SIGNAL maxtick1 : STD_LOGIC;
SIGNAL maxtick2 : STD_LOGIC;

SIGNAL rst_counter_fila : STD_LOGIC;

SIGNAL y0 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010000";
SIGNAL y1 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100000";
SIGNAL y2 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110000";
SIGNAL y3 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1000000";
SIGNAL y4 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1010000";
SIGNAL y5 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1100000";
SIGNAL y6 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1110000";
SIGNAL y7 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010000";
SIGNAL y8 : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0001111";

SIGNAL counter_i : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL counter_F : STD_LOGIC_VECTOR(2 DOWNTO 0);

SIGNAL casi_filas : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
SIGNAL filas : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
SIGNAL casi_columnas : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
SIGNAL columnas : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";

SIGNAL entry_decoder : INTEGER;
SIGNAL entry_decoder1 : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL enter_clock : STD_LOGIC;

SIGNAL prueba : STD_LOGIC;

BEGIN

  counter_time: ENTITY work.univ_bin_counter_control_2
  GENERIC MAP( X => 16 ) --28)
   PORT MAP( clk => clk, 
	          rst => rst,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "0000000000000000",
			    ctrl => "0000000000000001",
--				 ctrl => "0011001011011101",
--				 ctrl => "1000111100001101000110000000",
				 max_tick => maxtick0);
				 
  counter_i1: ENTITY work.univ_bin_counter_control_2
  GENERIC MAP( X => 7)
   PORT MAP( clk => maxtick0, 
	          rst => rst,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "0000000",
			    ctrl => "1111111",
				 counter => counter_i);
  
  -- 260.41 us
  
  comparador1 : ENTITY work.comparador
  PORT MAP( x  => counter_i,
			   y	=> y0,
				eq => p0);
				
  comparador2 : ENTITY work.comparador
  PORT MAP( x  => counter_i,
			   y	=> y1,
				eq => p1);
				
  comparador3 : ENTITY work.comparador
  PORT MAP( x  => counter_i,
			   y	=> y2,
				eq => p2);
				
  comparador4 : ENTITY work.comparador
  PORT MAP( x  => counter_i,
			   y	=> y3,
				eq => p3);
				
  comparador5 : ENTITY work.comparador
  PORT MAP( x  => counter_i,
			   y	=> y4,
				eq => p4);
				
  comparador6 : ENTITY work.comparador
  PORT MAP( x  => counter_i,
			   y	=> y5,
				eq => p5);
				
  comparador7 : ENTITY work.comparador
  PORT MAP( x  => counter_i,
			   y	=> y6,
				eq => p6);
				
--  comparador8 : ENTITY work.comparador
--  PORT MAP( x  => counter_i,
--			   y	=> y7,
--				eq => p7);
				
  comparador_retro : ENTITY work.comparador_less
  PORT MAP( x  => counter_i,
			   y	=> y8,
				ls => p8);
				
  rst_counter_fila <= (rst OR p8);
  
  enter_clock <= p0 OR P1 OR p2 OR P3 OR p4 OR P5 OR p6;
				
  counter_fila: ENTITY work.univ_bin_counter_control_2
  GENERIC MAP ( X => 3)
   PORT MAP( clk => enter_clock, 
	          rst => rst_counter_fila,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "000",
			    ctrl => "111",
				 counter => counter_F);
				 
  filas_decoder : ENTITY work.decoder3_8
  PORT MAP( x => counter_F,
            ena => prueba,
            y => casi_filas);
				
  filas <= (NOT casi_filas);
  
  entry_decoder <= ((to_integer(unsigned(counter_i))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))) - (to_integer(unsigned(counter_F))));
  
  entry_decoder1	<=	std_logic_vector(to_unsigned(entry_decoder, entry_decoder1'length));
  
  columnas_decoder : ENTITY work.decoder4_16
  PORT MAP( x => entry_decoder1,
            ena => prueba,
            y => casi_columnas);
				
  prueba <= position(to_integer(unsigned(counter_i)));
				
--  c

--  columnas(0) <= (casi_columnas(0) AND position((unsigned(counter_i))));
--  columnas(1) <= (casi_columnas(1) AND position((unsigned(counter_i))));
--  columnas(2) <= (casi_columnas(2) AND position((unsigned(counter_i))));
--  columnas(3) <= (casi_columnas(3) AND position((unsigned(counter_i))));
--  columnas(4) <= (casi_columnas(4) AND position((unsigned(counter_i))));
--  columnas(5) <= (casi_columnas(5) AND position((unsigned(counter_i))));
--  columnas(6) <= (casi_columnas(6) AND position((unsigned(counter_i))));
--  columnas(7) <= (casi_columnas(7) AND position((unsigned(counter_i))));
--  columnas(8) <= (casi_columnas(8) AND position((unsigned(counter_i))));
--  columnas(9) <= (casi_columnas(9) AND position((unsigned(counter_i))));
--  columnas(10) <= (casi_columnas(10) AND position((unsigned(counter_i))));
--  columnas(11) <= (casi_columnas(11) AND position((unsigned(counter_i))));
--  columnas(12) <= (casi_columnas(12) AND position((unsigned(counter_i))));
--  columnas(13) <= (casi_columnas(13) AND position((unsigned(counter_i))));
--  columnas(14) <= (casi_columnas(14) AND position((unsigned(counter_i))));
--  columnas(15) <= (casi_columnas(15) AND position((unsigned(counter_i))));
  
--  columnas <= columnas(15) & columnas(14) & columnas(13) & columnas(12) & columnas(11) & columnas(10) & columnas(9) & columnas(8) & columnas(7) & columnas(6) & columnas(5) & columnas(4) & columnas(3) & columnas(2) & columnas(1) & columnas(0);
  columnas <= casi_columnas;
--    columnas <= "1000000000000000";

--  columnas(0) <= (casi_columnas(0) AND prueba);
--  columnas(1) <= (casi_columnas(1) AND prueba);
--  columnas(2) <= (casi_columnas(2) AND prueba);
--  columnas(3) <= (casi_columnas(3) AND prueba);
--  columnas(4) <= (casi_columnas(4) AND prueba);
--  columnas(5) <= (casi_columnas(5) AND prueba);
--  columnas(6) <= (casi_columnas(6) AND prueba);
--  columnas(7) <= (casi_columnas(7) AND prueba);
--  columnas(8) <= (casi_columnas(8) AND prueba);
--  columnas(9) <= (casi_columnas(9) AND prueba);
--  columnas(10) <= (casi_columnas(10) AND prueba);
--  columnas(11) <= (casi_columnas(11) AND prueba);
--  columnas(12) <= (casi_columnas(12) AND prueba);
--  columnas(13) <= (casi_columnas(13) AND prueba);
--  columnas(14) <= (casi_columnas(14) AND prueba);
--  columnas(15) <= (casi_columnas(15) AND prueba);
--  
  
  filas_out <= filas;
--  filas_out <= "11111110";
  cols1_out <= columnas(15 DOWNTO 8);
  cols2_out <= columnas(7 DOWNTO 0);  

--  cols1_out <= casi_columnas(7 DOWNTO 0);
--  cols2_out <= casi_columnas(15 DOWNTO 8);
				 
END ARCHITECTURE behavioral;