LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
-------------------------------------------------------------
ENTITY decoder3_8 IS
	PORT(	    x	           :	IN		STD_LOGIC_VECTOR(2 DOWNTO 0);
	          ena          :   IN		STD_LOGIC;
			    y	           :	OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0));
END ENTITY decoder3_8;
-------------------------------------------------------------
ARCHITECTURE functional OF decoder3_8 IS

SIGNAL x1 : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN
	
	x1 <= ena & x;
	
	y <= "00000001" WHEN (x1 = "1000") ELSE 
	     "00000010" WHEN (x1 = "1001") ELSE
		  "00000100" WHEN (x1 = "1010") ELSE
		  "00001000" WHEN (x1 = "1011") ELSE
		  "00010000" WHEN (x1 = "1100") ELSE
		  "00100000" WHEN (x1 = "1101") ELSE
		  "01000000" WHEN (x1 = "1110") ELSE
		  "10000000" WHEN (x1 = "1111") ELSE
		  "00000000";
				  
END ARCHITECTURE functional;