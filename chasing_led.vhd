LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
-------------------------------------------------
ENTITY chasing_led IS
GENERIC (X : INTEGER := 4;
         Y : INTEGER := 8);
PORT( clk     : IN  STD_LOGIC;
		rst     : IN  STD_LOGIC;
      rd_data : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0);
		rd_dat2 : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0);
		rd_dat3 : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0));
END ENTITY chasing_led;
------------------------------------------------
ARCHITECTURE behavioral OF chasing_led IS
   SIGNAL addr     : UNSIGNED(X-1 DOWNTO 0);
   SIGNAL countert : STD_LOGIC_VECTOR(27 DOWNTO 0);
   SIGNAL counterR : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL counterL : STD_LOGIC_VECTOR(Y-1 DOWNTO 0);
   SIGNAL maxtick0 : STD_LOGIC;
   SIGNAL ena1     : STD_LOGIC := '1';
   SIGNAL ena2     : STD_LOGIC;
--	SIGNAL up1     : STD_LOGIC;
--	SIGNAL up2     : STD_LOGIC;
	
	TYPE state IS (state0, state1, state2);
	SIGNAL prstate, nxstate: state;
	SIGNAL prevstate : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL sensors : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
--	TYPE row IS ARRAY (Y-1 DOWNTO 0) OF STD_LOGIC_VECTOR;
	TYPE matrix IS ARRAY (0 TO Y-1) OF STD_LOGIC_VECTOR(Y-1 DOWNTO 0);
	
	CONSTANT filas: matrix := (
	"10000000",
	"01000000",
	"00100000",
	"00010000",
	"00001000",
	"00000100",
	"00000010",
	"00000001");
	
	CONSTANT columnas: matrix := (
	"01111111",
	"10111111",
	"11011111",
	"11101111",
	"11110111",
	"11111011",
	"11111101",
	"11111110");
	
BEGIN

   ena2 <= ena1 AND maxtick0;
	
	counter_t: ENTITY work.univ_bin_counter_control_2
   PORT MAP( clk => clk, 
	          rst => rst,
				 ena => ena1,
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "0000000000000000000000000000",
			    ctrl => "0000100110001001011010000000",
--           ctrl => "0000000000000000000000000001",
				 max_tick => maxtick0,
				 min_tick => OPEN,
				 counter => countert);
	
	Counter_r : ENTITY work.univ_bin_counter_control_2
	GENERIC MAP(X => 8)
	PORT MAP( clk => maxtick0, 
	          rst => rst,
				 ena  => ena2,
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "00000000",
				 ctrl => "00111111",
				 max_tick => OPEN,
				 min_tick => OPEN,
				 counter => counterR);
				 
--	Counter_l : ENTITY work.univ_bin_counter_control_2
--	GENERIC MAP(X => X)
--	PORT MAP( clk => clk, 
--	          rst => rst,
--				 ena  => ena2,
--				 syn_clr => '0',
--				 load => '0',
--				 up => up2,
--				 d => "0000",
--				 ctrl => "0111",
--				 max_tick => OPEN,
--				 min_tick => OPEN,
--				 counter => counterL);		 
				 
	rom_data2: PROCESS(counterR)
	BEGIN
	   CASE counterR IS
		   WHEN "00000000" => rd_data <= filas(0); rd_dat2 <= columnas(0); rd_dat3 <= filas(7);
			WHEN "00000001" => rd_data <= filas(1); rd_dat2 <= columnas(0); rd_dat3 <= filas(6);
			WHEN "00000010" => rd_data <= filas(2); rd_dat2 <= columnas(0); rd_dat3 <= filas(5);
			WHEN "00000011" => rd_data <= filas(3); rd_dat2 <= columnas(0); rd_dat3 <= filas(4);
			WHEN "00000100" => rd_data <= filas(4); rd_dat2 <= columnas(0); rd_dat3 <= filas(3);
			WHEN "00000101" => rd_data <= filas(5); rd_dat2 <= columnas(0); rd_dat3 <= filas(2);
			WHEN "00000110" => rd_data <= filas(6); rd_dat2 <= columnas(0); rd_dat3 <= filas(1);
			WHEN "00000111" => rd_data <= filas(7); rd_dat2 <= columnas(0); rd_dat3 <= filas(0);
			------------------------------------------------------------------------------------
			WHEN "00001000" => rd_data <= filas(7); rd_dat2 <= columnas(1); rd_dat3 <= filas(0);
			WHEN "00001001" => rd_data <= filas(6); rd_dat2 <= columnas(1); rd_dat3 <= filas(1);
			WHEN "00001010" => rd_data <= filas(5); rd_dat2 <= columnas(1); rd_dat3 <= filas(2);
			WHEN "00001011" => rd_data <= filas(4); rd_dat2 <= columnas(1); rd_dat3 <= filas(3);
			WHEN "00001100" => rd_data <= filas(3); rd_dat2 <= columnas(1); rd_dat3 <= filas(4);
			WHEN "00001101" => rd_data <= filas(2); rd_dat2 <= columnas(1); rd_dat3 <= filas(5);
			WHEN "00001110" => rd_data <= filas(1); rd_dat2 <= columnas(1); rd_dat3 <= filas(6);
			WHEN "00001111" => rd_data <= filas(0); rd_dat2 <= columnas(1); rd_dat3 <= filas(7);
			------------------------------------------------------------------------------------
			WHEN "00010000" => rd_data <= filas(0); rd_dat2 <= columnas(2); rd_dat3 <= filas(7);
			WHEN "00010001" => rd_data <= filas(1); rd_dat2 <= columnas(2); rd_dat3 <= filas(6);
			WHEN "00010010" => rd_data <= filas(2); rd_dat2 <= columnas(2); rd_dat3 <= filas(5);
			WHEN "00010011" => rd_data <= filas(3); rd_dat2 <= columnas(2); rd_dat3 <= filas(4);
			WHEN "00010100" => rd_data <= filas(4); rd_dat2 <= columnas(2); rd_dat3 <= filas(3);
			WHEN "00010101" => rd_data <= filas(5); rd_dat2 <= columnas(2); rd_dat3 <= filas(2);
			WHEN "00010110" => rd_data <= filas(6); rd_dat2 <= columnas(2); rd_dat3 <= filas(1);
			WHEN "00010111" => rd_data <= filas(7); rd_dat2 <= columnas(2); rd_dat3 <= filas(0);
			------------------------------------------------------------------------------------
			WHEN "00011000" => rd_data <= filas(7); rd_dat2 <= columnas(3); rd_dat3 <= filas(0);
			WHEN "00011001" => rd_data <= filas(6); rd_dat2 <= columnas(3); rd_dat3 <= filas(1);
			WHEN "00011010" => rd_data <= filas(5); rd_dat2 <= columnas(3); rd_dat3 <= filas(2);
			WHEN "00011011" => rd_data <= filas(4); rd_dat2 <= columnas(3); rd_dat3 <= filas(3);
			WHEN "00011100" => rd_data <= filas(3); rd_dat2 <= columnas(3); rd_dat3 <= filas(4);
			WHEN "00011101" => rd_data <= filas(2); rd_dat2 <= columnas(3); rd_dat3 <= filas(5);
			WHEN "00011110" => rd_data <= filas(1); rd_dat2 <= columnas(3); rd_dat3 <= filas(6);
			WHEN "00011111" => rd_data <= filas(0); rd_dat2 <= columnas(3); rd_dat3 <= filas(7);
			------------------------------------------------------------------------------------
			WHEN "00100000" => rd_data <= filas(0); rd_dat2 <= columnas(4); rd_dat3 <= filas(7);
			WHEN "00100001" => rd_data <= filas(1); rd_dat2 <= columnas(4); rd_dat3 <= filas(6);
			WHEN "00100010" => rd_data <= filas(2); rd_dat2 <= columnas(4); rd_dat3 <= filas(5);
			WHEN "00100011" => rd_data <= filas(3); rd_dat2 <= columnas(4); rd_dat3 <= filas(4);
			WHEN "00100100" => rd_data <= filas(4); rd_dat2 <= columnas(4); rd_dat3 <= filas(3);
			WHEN "00100101" => rd_data <= filas(5); rd_dat2 <= columnas(4); rd_dat3 <= filas(2);
			WHEN "00100110" => rd_data <= filas(6); rd_dat2 <= columnas(4); rd_dat3 <= filas(1);
			WHEN "00100111" => rd_data <= filas(7); rd_dat2 <= columnas(4); rd_dat3 <= filas(0);
			------------------------------------------------------------------------------------
			WHEN "00101000" => rd_data <= filas(7); rd_dat2 <= columnas(5); rd_dat3 <= filas(0);
			WHEN "00101001" => rd_data <= filas(6); rd_dat2 <= columnas(5); rd_dat3 <= filas(1);
			WHEN "00101010" => rd_data <= filas(5); rd_dat2 <= columnas(5); rd_dat3 <= filas(2);
			WHEN "00101011" => rd_data <= filas(4); rd_dat2 <= columnas(5); rd_dat3 <= filas(3);
			WHEN "00101100" => rd_data <= filas(3); rd_dat2 <= columnas(5); rd_dat3 <= filas(4);
			WHEN "00101101" => rd_data <= filas(2); rd_dat2 <= columnas(5); rd_dat3 <= filas(5);
			WHEN "00101110" => rd_data <= filas(1); rd_dat2 <= columnas(5); rd_dat3 <= filas(6);
			WHEN "00101111" => rd_data <= filas(0); rd_dat2 <= columnas(5); rd_dat3 <= filas(7);
			------------------------------------------------------------------------------------
			WHEN "00110000" => rd_data <= filas(0); rd_dat2 <= columnas(6); rd_dat3 <= filas(7);
			WHEN "00110001" => rd_data <= filas(1); rd_dat2 <= columnas(6); rd_dat3 <= filas(6);
			WHEN "00110010" => rd_data <= filas(2); rd_dat2 <= columnas(6); rd_dat3 <= filas(5);
			WHEN "00110011" => rd_data <= filas(3); rd_dat2 <= columnas(6); rd_dat3 <= filas(4);
			WHEN "00110100" => rd_data <= filas(4); rd_dat2 <= columnas(6); rd_dat3 <= filas(3);
			WHEN "00110101" => rd_data <= filas(5); rd_dat2 <= columnas(6); rd_dat3 <= filas(2);
			WHEN "00110110" => rd_data <= filas(6); rd_dat2 <= columnas(6); rd_dat3 <= filas(1);
			WHEN "00110111" => rd_data <= filas(7); rd_dat2 <= columnas(6); rd_dat3 <= filas(0);
			------------------------------------------------------------------------------------
			WHEN "00111000" => rd_data <= filas(7); rd_dat2 <= columnas(7); rd_dat3 <= filas(0);
			WHEN "00111001" => rd_data <= filas(6); rd_dat2 <= columnas(7); rd_dat3 <= filas(1);
			WHEN "00111010" => rd_data <= filas(5); rd_dat2 <= columnas(7); rd_dat3 <= filas(2);
			WHEN "00111011" => rd_data <= filas(4); rd_dat2 <= columnas(7); rd_dat3 <= filas(3);
			WHEN "00111100" => rd_data <= filas(3); rd_dat2 <= columnas(7); rd_dat3 <= filas(4);
			WHEN "00111101" => rd_data <= filas(2); rd_dat2 <= columnas(7); rd_dat3 <= filas(5);
			WHEN "00111110" => rd_data <= filas(1); rd_dat2 <= columnas(7); rd_dat3 <= filas(6);
			WHEN "00111111" => rd_data <= filas(0); rd_dat2 <= columnas(7); rd_dat3 <= filas(7);
			WHEN OTHERS => rd_data <= filas(0); rd_dat2 <= columnas(0); rd_dat3 <= filas(7);
		END CASE;
	END PROCESS;
END ARCHITECTURE behavioral;