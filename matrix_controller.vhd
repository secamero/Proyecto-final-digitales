LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
----------------------------------------------------------
ENTITY matrix_controller IS
   GENERIC (lines : INTEGER := 8;
	         X     : INTEGER := 4;
            Y     : INTEGER := 8);
   PORT    ( clk       : IN STD_LOGIC;
	          sel       : IN STD_LOGIC;
				 rst       : IN STD_LOGIC;
	          filas1    : OUT STD_LOGIC_VECTOR(lines-1 DOWNTO 0);
			    columnas1 : OUT STD_LOGIC_VECTOR(lines-1 DOWNTO 0);
				 filas2    : OUT STD_LOGIC_VECTOR(lines-1 DOWNTO 0);
			    columnas2 : OUT STD_LOGIC_VECTOR(lines-1 DOWNTO 0));
END ENTITY matrix_controller;
----------------------------------------------------------
ARCHITECTURE behaviour OF matrix_controller IS
   SIGNAL cc  : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL fc  : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL cc1 : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL fc1 : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL cs  : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL fs  : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL cs1 : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL fs1 : STD_logic_VECTOR(lines-1 DOWNTO 0);
	
	SIGNAL a  : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL b : STD_logic_VECTOR(lines-1 DOWNTO 0);
	SIGNAL c : STD_logic_VECTOR(lines-1 DOWNTO 0);
	
	SIGNAL posi : STD_logic_VECTOR(127 DOWNTO 0);--:= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
	SIGNAL columnas : STD_logic_VECTOR(15 DOWNTO 0);
	
	  SIGNAL maxtick0 : STD_LOGIC;
  SIGNAL maxtick1 : STD_LOGIC;
  SIGNAL maxtick2 : STD_LOGIC;
  SIGNAL maxtick3 : STD_LOGIC;
  
    SIGNAL countert : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
  SIGNAL counterR : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
  
BEGIN
	
   
   	
--	carita : ENTITY work.async_rom_carita
--	PORT MAP( clk => clk,
--	          rst => rst,
--	          rd_data => fc,
--				 rd_dat2 => cc);
--				 
--	corazon : ENTITY work.async_rom_corazon
--	PORT MAP( clk => clk,
--	          rst => rst,
--	          rd_data => fc1,
--				 rd_dat2 => cc1);
--	
--	chasing : ENTITY work.chasing_led
--   PORT MAP( clk => clk,
--	          rst => rst,
--				 rd_data => fs,
--				 rd_dat2 => cs,
--				 rd_dat3 => fs1);
--				
--	cs1 <= cs;	
--   
----	filas1 <= fc WHEN sel = '0' ELSE fs;   -- el else se reemplaza por la salida del chasing led
----	filas2 <= fc1 WHEN sel = '0' ELSE fs1; -- el else se reemplaza por la salida del chasing led
----	columnas1 <= cc WHEN sel = '0' ELSE cs; -- el else se reemplaza por la salida del chasing led
----	columnas2 <= cc1 WHEN sel = '0' ELSE cs1; -- el else se reemplaza por la salida del chasing led
--	
	bounce : ENTITY work.ball_bouncing_final
	PORT MAP( clk => clk,
	          rst => rst,
--				 rd_data => a,
--				 rd_dat2 => b,
--				 rd_dat3 => c);
   			 posiout => posi);			 
 
  print : ENTITY work.print_in_matrix
  PORT MAP( clk       => clk,
				rst       => rst,
				position  => posi,
            filas_out => a,
		      cols1_out => b,
		      cols2_out => c);
				
  filas1 <= b;
  filas2 <= c;
  columnas1 <= a;
  columnas2 <= a;

END ARCHITECTURE behaviour;