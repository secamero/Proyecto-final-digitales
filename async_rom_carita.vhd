LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
-------------------------------------------------
ENTITY async_rom_carita IS
GENERIC (X : INTEGER := 4;
         Y : INTEGER := 8);
PORT( clk     : IN  STD_LOGIC;
		rst     : IN  STD_LOGIC;
      rd_data : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0);
		rd_dat2 : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0));
END ENTITY async_rom_carita;
-------------------------------------------------
ARCHITECTURE behavioral OF async_rom_carita IS
  SIGNAL addr     : UNSIGNED(3 DOWNTO 0);
  SIGNAL counter00 : STD_LOGIC_VECTOR(27 DOWNTO 0);
  SIGNAL counter11 : STD_LOGIC_VECTOR(X-1 DOWNTO 0);
  SIGNAL maxtick00 : STD_LOGIC;
  SIGNAL ena      : STD_LOGIC := '1';
  SIGNAL ena2     : STD_LOGIC;
BEGIN
   
	ena2 <= ena AND maxtick00;
	
	Counter_00 : ENTITY work.univ_bin_counter_control_2
	PORT MAP( clk => clk, 
	          rst => rst,
				 ena  => ena,
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "0000000000000000000000000000",
			    ctrl => "0000000000000000100111000100",
				 max_tick => maxtick00,
				 min_tick => OPEN,
				 counter => counter00);
	
	Counter_11 : ENTITY work.univ_bin_counter_control_2
	GENERIC MAP(X => X)
	PORT MAP( clk => clk, 
	          rst => rst,
				 ena  => ena2,
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "0000",
				 ctrl => "1010",
				 max_tick => OPEN,
				 min_tick => OPEN,
				 counter => counter11);
	
	addr <= UNSIGNED(counter11);
	
   rom_data1: PROCESS(addr)
	BEGIN
	   CASE addr IS
		   WHEN "0000" => rd_data <= "00111100"; rd_dat2 <= "01111111";
			WHEN "0001" => rd_data <= "01000010"; rd_dat2 <= "10111111";
			WHEN "0010" => rd_data <= "10100101"; rd_dat2 <= "11011111";
			WHEN "0011" => rd_data <= "10000001"; rd_dat2 <= "11101111";
			WHEN "0100" => rd_data <= "10100101"; rd_dat2 <= "11110111";
			WHEN "0101" => rd_data <= "10011001"; rd_dat2 <= "11111011";
			WHEN "0110" => rd_data <= "01000010"; rd_dat2 <= "11111101";
			WHEN "0111" => rd_data <= "00111100"; rd_dat2 <= "11111110";
			WHEN OTHERS => rd_data <= "00000000"; rd_dat2 <= "00000000";
		END CASE;
	END PROCESS;
END ARCHITECTURE Behavioral;	