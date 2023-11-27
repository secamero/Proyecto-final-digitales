
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--------------------------------------------------------------
ENTITY ball_bouncing_final IS

   GENERIC (lines : INTEGER := 8;
	         X     : INTEGER := 128;
            Y     : INTEGER := 8);
				
   PORT    ( clk       : IN STD_LOGIC;
				 rst       : IN STD_LOGIC;
--				 posi1     : IN UNSIGNED(X-1 DOWNTO 0);
--				 posi2     : IN UNSIGNED(X-1 DOWNTO 0);
             posiout   : OUT STD_LOGIC_VECTOR(X-1 DOWNTO 0));
				 
END ENTITY ball_bouncing_final;
---------------------------------------------------------------
ARCHITECTURE behavioral OF ball_bouncing_final IS
  
  SIGNAL countert : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
  SIGNAL counterR : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
  SIGNAL counterM1 : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
  SIGNAL counterM2 : STD_LOGIC_VECTOR(27 DOWNTO 0) := (OTHERS => '0');
--  SIGNAL i        : INTEGER := 20;
  SIGNAL ena1     : STD_LOGIC := '1';
  SIGNAL maxtick0 : STD_LOGIC;
  SIGNAL maxtick1 : STD_LOGIC;
  SIGNAL maxtick2 : STD_LOGIC;
  SIGNAL maxtick3 : STD_LOGIC;
  SIGNAL next_s : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  
  SIGNAL PRUEBA1 : STD_LOGIC_VECTOR(15 DOWNTO 0) := "1010100011100110";
  SIGNAL PRUEBA2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL PRUEBA3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  
  SIGNAL enable_delete : STD_LOGIC;
  SIGNAL enable_update : STD_LOGIC;
  
  SIGNAL index_bola      : INTEGER := 1;
  SIGNAL index_bola_past : INTEGER;
  
  SIGNAL a1 : UNSIGNED(127 DOWNTO 0);
  SIGNAL a2 : UNSIGNED(127 DOWNTO 0);
  SIGNAL a3 : UNSIGNED(127 DOWNTO 0);
  SIGNAL a4 : UNSIGNED(127 DOWNTO 0);
  
  SIGNAL x1 : INTEGER;
  SIGNAL x2 : INTEGER;
  SIGNAL x3 : INTEGER;
  SIGNAL x4 : INTEGER;
  SIGNAL y1 : INTEGER;
  SIGNAL sel : STD_LOGIC_VECTOR(1 DOWNTO 0);

  TYPE STATES IS (abajo_der, borrar1, abajo_iz, borrar2, arriba_der, borrar3, arriba_iz, borrar4);
--  TYPE position IS ARRAY (X-1 DOWNTO 0) OF STD_LOGIC;
--  
  SIGNAL posi : STD_LOGIC_VECTOR(127 DOWNTO 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
--  SIGNAL posi1 : STD_LOGIC_VECTOR(0 TO 127);
--  SIGNAL posi2 : STD_LOGIC_VECTOR(0 TO 127);

----SIGNAL posi: position := "00000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000";
--  SIGNAL msuperior  : STD_LOGIC_VECTOR(127 DOWNTO 0) := "11111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
--  SIGNAL minferior  : STD_LOGIC_VECTOR(127 DOWNTO 0) := "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111111111";
--  SIGNAL mizquierdo : STD_LOGIC_VECTOR(127 DOWNTO 0) := "10000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000";
--  SIGNAL mderecho   : STD_LOGIC_VECTOR(127 DOWNTO 0) := "00000000000000010000000000000001000000000000000100000000000000010000000000000001000000000000000100000000000000010000000000000001";
  SIGNAL pr_state, nx_state, futurestate: STATES;
  
BEGIN
  
  counter_t: ENTITY work.univ_bin_counter_control_2
   PORT MAP( clk => clk, 
	          rst => rst,
				 ena => '1',
				 syn_clr => '0',
				 load => '0',
				 up => '1',
				 d => "0000000000000000000000000000",
--			    ctrl => "0000100110001001011010000000",
--				 ctrl => "0010111110101111000010000000",
             ctrl => "0000000000000000000000000100",
--             ctrl => "1000111100001101000110000000",
				 max_tick => maxtick0,
				 min_tick => OPEN,
				 counter => countert);
  
  
  x1 <= index_bola+17;
  x2 <= index_bola-17;
  x3 <= index_bola+15;
  x4 <= index_bola-15;
  
  desition : ENTITY work.mux4_1_when_else_integer
  PORT MAP( x1    => x1,
	         x2    => x2,
				x3    => x3,
				x4    => x4,
				sel   => sel,
				y     => y1);

  
  register1 : ENTITY work.datff
  PORT MAP( dta   => y1,
		      clk	=> clk,
			   res	=> rst,
				en		=> maxtick0,
				q		=> index_bola);
				
  register2 : ENTITY work.datff
  PORT MAP( dta   => index_bola,
		      clk	=> clk,
			   res	=> rst,
				en		=> maxtick0,
				q		=> index_bola_past);
				
  transtions : PROCESS (rst, maxtick0, posi)  
  BEGIN 
    IF (rst ='1') THEN 
        pr_state <= abajo_der;
--	     posi <= "00000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000"; 	  
    ELSIF (rising_edge(maxtick0)) THEN 
        pr_state <= nx_state;
--		  IF (enable_delete = '1') THEN
--		     posi(index_bola_past) <= '0';
--        END IF;			  
	 END IF;
  END PROCESS transtions;	
  
--  a1 <= (UNSIGNED(posi) AND UNSIGNED(minferior));
--  a2 <= (UNSIGNED(posi) AND UNSIGNED(mderecho));
--  a3 <= (UNSIGNED(posi) AND UNSIGNED(mizquierdo));
--  a4 <= (UNSIGNED(posi) AND UNSIGNED(msuperior));
  

  rebotes: PROCESS (pr_state, posi, index_bola, index_bola_past)
  BEGIN
    CASE pr_state IS
	
	   WHEN abajo_der => --# 1
		
		sel <= "00";
		IF (((posi(126) AND '1') OR (posi(125) AND '1') OR (posi(124) AND '1') OR (posi(123) AND '1') OR (posi(122) AND '1') OR (posi(121) AND '1') OR (posi(120) AND '1') OR (posi(119) AND '1') OR (posi(118) AND '1') OR (posi(117) AND '1') OR (posi(116) AND '1') OR (posi(115) AND '1') OR (posi(114) AND '1') OR (posi(113) AND '1')) = '1') THEN
		   next_s <= "0011";
			nx_state <= borrar1;
	   ELSIF (((posi(31) AND '1') OR (posi(47) AND '1') OR (posi(63) AND '1') OR (posi(79) AND '1') OR (posi(95) AND '1') OR (posi(111) AND '1')) = '1') THEN
		   next_s <= "0101";
			nx_state <= borrar1;
	   ELSIF ((posi(127) AND '1') = '1') THEN
		   next_s <= "0111";
			nx_state <= borrar1;
		ELSE
		  next_s <= "0001";
		  nx_state <= borrar1;
		END IF;
		
	   WHEN borrar1 => --# 2
		
		posi(index_bola_past) <= '0';
		posi(index_bola) <= '1';
		
		IF (next_s = "0011") THEN
	      nx_state <= arriba_der;
		ELSIF (next_s = "0101") THEN
	      nx_state <= abajo_iz;
		ELSIF (next_s = "0111") THEN
	      nx_state <= arriba_iz;
		ELSE
		   nx_state <= abajo_der;
		END IF;	
------------------------------------------------------------		
	   WHEN arriba_der => --# 3
		
		sel <= "11";
		IF (index_bola > 1 AND index_bola < 15) THEN
		   next_s <= "0001";
			nx_state <= borrar2;
	   ELSIF ((index_bola = 31) OR (index_bola = 47) OR (index_bola = 63) OR (index_bola = 79) OR (index_bola = 95) OR (index_bola = 111)) THEN
		   next_s <= "0111";
			nx_state <= borrar2;
		ELSIF ((index_bola = 15)) THEN
		   next_s <= "0101";
			nx_state <= borrar2;
		ELSE
		   next_s <= "0011";
			nx_state <= borrar2;
		END IF;
		
	   WHEN borrar2 => --# 4
		
		posi(index_bola_past) <= '0';
		posi(index_bola) <= '1';
		
		IF (next_s = "0001") THEN
	      nx_state <= abajo_der;
		ELSIF (next_s = "0111") THEN
	      nx_state <= arriba_iz;
		ELSIF (next_s = "0101") THEN
	      nx_state <= abajo_iz;
		ELSE
		   nx_state <= arriba_der;
		END IF;
--------------------------------------------------------		
		WHEN abajo_iz => --# 5
		
		sel <= "10";
		IF (index_bola > 123 AND index_bola < 127) THEN
		   next_s <= "0111";
			nx_state <= borrar3;
	   ELSIF ((index_bola = 16) OR (index_bola = 32) OR (index_bola = 48) OR (index_bola = 64) OR (index_bola = 80) OR (index_bola = 96)) THEN
		   next_s <= "0001";
			nx_state <= borrar3;
		ELSIF ((index_bola = 112)) THEN
		   next_s <= "0011";
			nx_state <= borrar3;
		ELSE
		   next_s <= "0101";
			nx_state <= borrar3;
		END IF;
		
		WHEN borrar3 => --# 6
		
		posi(index_bola_past) <= '0';
		posi(index_bola) <= '1';
		
		IF (next_s = "0111") THEN
	      nx_state <= arriba_iz;
		ELSIF (next_s = "0001") THEN
	      nx_state <= abajo_der;
		ELSIF (next_s = "0011") THEN
	      nx_state <= arriba_der;
		ELSE
		   nx_state <= abajo_iz;
		END IF;
--------------------------------------------------------		
		WHEN arriba_iz => --# 7
		
		sel <= "01";
		IF (index_bola > 0 AND index_bola < 15) THEN
		   next_s <= "0101";
			nx_state <= borrar4;
	   ELSIF ((index_bola = 16) OR (index_bola = 32) OR (index_bola = 48) OR (index_bola = 64) OR (index_bola = 80) OR (index_bola = 96)) THEN
		   next_s<= "0011";
			nx_state <= borrar4;
		ELSIF ((index_bola = 0)) THEN
		   next_s <= "0001";
			nx_state <= borrar4;
		ELSE
		   next_s <= "0111";
			nx_state <= borrar4;
		END IF;
		
		WHEN borrar4 => --# 8
		
		posi(index_bola_past) <= '0';
		posi(index_bola) <= '1';
		
		IF (next_s = "0101") THEN
	      nx_state <= abajo_iz;
		ELSIF (next_s = "0011") THEN
	      nx_state <= arriba_der;
		ELSIF (next_s = "0001") THEN
	      nx_state <= abajo_der;
		ELSE
		   nx_state <= arriba_iz;
		END IF;
	   
	 END CASE;
  END PROCESS;
  
  posiout <= std_LOGIC_VECTOR(posi);
  
END ARCHITECTURE behavioral;