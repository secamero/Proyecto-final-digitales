LIBRARY IEEE;
USE ieee.std_logic_1164.all;
----------------------------------------------------------
ENTITY mux4_1_when_else_integer IS
   PORT(    x1    :  IN   INTEGER;
	         x2    :  IN   INTEGER;
				x3    :  IN   INTEGER;
				x4    :  IN   INTEGER;
				sel   :  IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
				y     :  OUT  INTEGER);
END ENTITY mux4_1_when_else_integer;
----------------------------------------------------------
ARCHITECTURE functional OF mux4_1_when_else_integer IS
BEGIN
   y <= x1   WHEN sel="00"  ELSE
	     x2   WHEN sel="01"  ELSE
		  x3   WHEN sel="10"  ELSE
		  x4;
			  
END ARCHITECTURE functional;