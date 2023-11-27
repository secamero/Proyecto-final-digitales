LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
-------------------------------------------------------------
ENTITY comparador_less IS
   GENERIC ( MAX_WIDHT    :   INTEGER := 7);
	PORT(	    x	           :	IN		STD_LOGIC_VECTOR(MAX_WIDHT-1 DOWNTO 0);
			    y	           :	IN 	STD_LOGIC_VECTOR(MAX_WIDHT-1 DOWNTO 0);
				 ls           :   OUT   STD_LOGIC);
END ENTITY comparador_less;
-------------------------------------------------------------
ARCHITECTURE gateLevel OF comparador_less IS
   SIGNAL   eqs  :  STD_LOGIC_VECTOR(MAX_WIDHT-1 DOWNTO 0);
BEGIN
	
	ls <= '1' WHEN (UNSIGNED(x) < UNSIGNED(y)) ELSE '0';
				  
END ARCHITECTURE gateLevel;