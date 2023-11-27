LIBRARY IEEE;
USE ieee.std_logic_1164.all;
----------------------------------------------------------
ENTITY mux4_1_when_else IS
   PORT(    x1    :  IN   STD_LOGIC;
	         x2    :  IN   STD_LOGIC;
				x3    :  IN   STD_LOGIC;
				x4    :  IN   STD_LOGIC;
				sel   :  IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
				y     :  OUT  STD_LOGIC);
END ENTITY mux4_1_when_else;
----------------------------------------------------------
ARCHITECTURE functional OF mux4_1_when_else IS
BEGIN
   y <= x1   WHEN sel="00"  ELSE
	     x2   WHEN sel="01"  ELSE
		  x3   WHEN sel="10"  ELSE
		  x4;
			  
END ARCHITECTURE functional;