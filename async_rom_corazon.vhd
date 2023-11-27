LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
-------------------------------------------------
ENTITY async_rom_corazon IS
GENERIC (X : INTEGER := 4;
         Y : INTEGER := 8);
PORT( clk     : IN  STD_LOGIC;
		rst     : IN  STD_LOGIC;
		--addr    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      rd_data : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0);
		rd_dat2 : OUT STD_LOGIC_VECTOR(Y-1 DOWNTO 0));
END ENTITY async_rom_corazon;
-------------------------------------------------
ARCHITECTURE behavioral OF async_rom_corazon IS
  SIGNAL addr     : UNSiGNED(3 DOWNTO 0);
  SIGNAL counter  : STD_LOGIC_VECTOR(27 DOWNTO 0);
  SIGNAL counter1 : STD_LOGIC_VECTOR(X-1 DOWNTO 0);
  SIGNAL maxtick0 : STD_LOGIC;
  SIGNAL ena1     : STD_LOGIC := '1';
  SIGNAL ena2     : STD_LOGIC;
BEGIN
   
	ena2 <= ena1 AND maxtick0;
	
	Counter0 : ENTITY work.univ_bin_counter_control_2
	PORT MAP( clk => clk, 
	          rst => rst,
				 ena => ena1,
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "0000000000000000000000000000",
			    ctrl => "0000000000000000100111000100",
				 max_tick => maxtick0,
				 min_tick => OPEN,
				 counter => counter);
	
	Counter_1 : ENTITY work.univ_bin_counter_control_2
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
				 counter => counter1);
	
	addr <= UNSIGNED(counter1);
	
	rom_data2: PROCESS(addr)
	BEGIN
	   CASE addr IS
		   WHEN "0000" => rd_data <= "00000000"; rd_dat2 <= "01111111";
			
			WHEN "0001" => rd_data <= "01100110"; rd_dat2 <= "10111111";
			WHEN "0010" => rd_data <= "11111111"; rd_dat2 <= "11011111";
			WHEN "0011" => rd_data <= "11111111"; rd_dat2 <= "11101111";
			WHEN "0100" => rd_data <= "01111110"; rd_dat2 <= "11110111";
			WHEN "0101" => rd_data <= "00111100"; rd_dat2 <= "11111011";
			WHEN "0110" => rd_data <= "00011000"; rd_dat2 <= "11111101";
			WHEN "0111" => rd_data <= "00000000"; rd_dat2 <= "11111110";
			WHEN OTHERS => rd_data <= "00000000"; rd_dat2 <= "00000000";
		END CASE;
	END PROCESS;
END ARCHITECTURE Behavioral;	