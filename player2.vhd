LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--------------------------------------------------------------
ENTITY player2 IS

   GENERIC (lines : INTEGER := 8;
	         X     : INTEGER := 128;
            Y     : INTEGER := 8);
				
   PORT    ( clk       : IN STD_LOGIC;
				 rst       : IN STD_LOGIC;
             button3   : IN STD_LOGIC;
				 maxtick0  : IN STD_LOGIC;
				 button4   : IN STD_LOGIC;
				 positionout : OUT STD_LOGIC_VECTOR(X-1 DOWNTO 0));
				 
END ENTITY player2;
---------------------------------------------------------------
ARCHITECTURE behavioral OF player2 IS

 SIGNAL buttonup3 : STD_LOGIC;
 SIGNAL buttonup4 : STD_LOGIC;
 
 SIGNAL butt13     : STD_LOGIC;
 SIGNAL butt24     : STD_LOGIC;
 
 SIGNAL p4        : INTEGER := 48;
 SIGNAL p5        : INTEGER := 64;
 SIGNAL p6        : INTEGER := 80;
 
 SIGNAL next_p4   : INTEGER;
 SIGNAL next_p5   : INTEGER;
 SIGNAL next_p6   : INTEGER;
 
 TYPE STATES IS (up, down, static);
 SIGNAL pr_state, nx_state: STATES;
 
 TYPE position IS ARRAY (128-1 DOWNTO 0) OF STD_LOGIC;
  
 SIGNAL posi: position := (OTHERS => '0');
 
BEGIN
 
 butt13 <= not button3;
 butt24 <= not button4;
 
 up1 : ENTITY work.edge_detect
 PORT MAP( clk => clk,
	        async_sig => butt13,
			  rise => buttonup3,
			  fall => OPEN);
 
 up2 : ENTITY work.edge_detect
 PORT MAP( clk => clk,
	        async_sig => butt24,
			  rise => buttonup4,
			  fall => OPEN);
			  
 transtions : PROCESS (rst, maxtick0, p4, p5, p6)  
  BEGIN 
    IF (rst ='1') THEN 
        pr_state <= static;
        p4 <= 47;
        p5 <= 63;
        p6 <= 79;		  
    ELSIF (rising_edge(maxtick0)) THEN 
        pr_state <= nx_state;
	 END IF;
  END PROCESS transtions;
  
 raqueta_move : PROCESS (pr_state, p4, p5, p6, posi)
  
  VARIABLE next_i : INTEGER;
  
  BEGIN
    CASE pr_state IS
	   WHEN up =>
		
		 next_p4 <= p4-16;
		 next_p5 <= p5-16;
		 next_p6 <= p6-16;
		 IF (buttonup3 = '1') THEN
		    IF (next_p4 = 15) THEN
		        posi(p4) <= '0';
			     posi <= (OTHERS => '0');
		        posi(next_p4) <= '1';
				  posi(next_p5) <= '1';
				  posi(next_p6) <= '1';
			     p4 <= next_p4;	
				  p5 <= next_p5;
				  p6 <= next_p6;
			     nx_state <= static;
			 ELSE
			     posi(p4) <= '0';
			     posi <= (OTHERS => '0');
		        posi(next_p4) <= '1';
				  posi(next_p5) <= '1';
				  posi(next_p6) <= '1';
			     p4 <= next_p4;	
				  p5 <= next_p5;
				  p6 <= next_p6;
			     nx_state <= up;
	       END IF;
		ELSE
		    nx_state <= static;
		END IF;
		
	   WHEN down =>
		
		next_p4 <= p4+16;
		next_p5 <= p5+16;
		next_p6 <= p6+16;
		 IF (buttonup4 = '1') THEN
		    IF (next_p6 = 127) THEN
		        posi(p6) <= '0';
			     posi <= (OTHERS => '0');
		        posi(next_p4) <= '1';
				  posi(next_p5) <= '1';
				  posi(next_p6) <= '1';
			     p4 <= next_p4;	
				  p5 <= next_p5;
				  p6 <= next_p6;
			     nx_state <= static;
			 ELSE
			     posi(p6) <= '0';
			     posi <= (OTHERS => '0');
		        posi(next_p4) <= '1';
				  posi(next_p5) <= '1';
				  posi(next_p6) <= '1';
			     p4 <= next_p4;	
				  p5 <= next_p5;
				  p6 <= next_p6;
				  nx_state <= down;
	       END IF;
		ELSE
		    nx_state <= static;
		END IF;
		
		WHEN static =>
		 
		 IF ((buttonup3 = '1') AND (p4 = 15))THEN
		    nx_state <= static;
		 ELSIF ((buttonup4 = '1') AND (p6 = 127))THEN
		    nx_state <= static;
		 ELSIF ((buttonup3 = '1') AND (p4 /= 15))THEN
		    nx_state <= up;
		 ELSIF ((buttonup4 = '1') AND (p6 /= 112))THEN
		    nx_state <= down;
		 ELSE
		    nx_state <= static;
		 END IF;
		 END CASE;
  END PROCESS;
  
  positionout <= STD_LOGIC_VECTOR(posi);
 
END ARCHITECTURE behavioral;