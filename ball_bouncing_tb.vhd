LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--------------------------------------------------------------
ENTITY ball_bouncing_tb IS			 
END ENTITY ball_bouncing_tb;
---------------------------------------------------------------
ARCHITECTURE testbench OF ball_bouncing_tb IS
  
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL rst_tb : STD_LOGIC := '1';
--  SIGNAL rd1_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL rd2_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
--  SIGNAL rd3_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL posi_tb : STD_LOGIC_VECTOR(127 DOWNTO 0);
  
BEGIN

  clk_tb <= (NOT clk_tb) after 10ns;
  
  rst_tb <= '0' AFTER 20ns;
  
  DUT1 : ENTITY work.ball_bouncing_final
  PORT MAP( clk => clk_tb,
            rst => rst_tb,
--				rd_data => rd1_tb,
--		      rd_dat2 => rd2_tb,
--		      rd_dat3 => rd3_tb);
            posiout => posi_tb);

END ARCHITECTURE testbench;