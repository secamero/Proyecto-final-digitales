LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--------------------------------------------------------------
ENTITY player1 IS

   GENERIC (lines : INTEGER := 8;
	         X     : INTEGER := 128;
            Y     : INTEGER := 8);
				
   PORT    ( clk       : IN STD_LOGIC;
				 rst       : IN STD_LOGIC;
             button1   : IN STD_LOGIC;
				 maxtick0  : IN STD_LOGIC;
				 button2   : IN STD_LOGIC;
				 positionout  : OUT STD_LOGIC_VECTOR(X-1 DOWNTO 0));
				 
END ENTITY player1;
---------------------------------------------------------------
ARCHITECTURE behavioral OF player1 IS

 SIGNAL buttonup1 : STD_LOGIC;
 SIGNAL buttonup2 : STD_LOGIC;
 
 SIGNAL butt12     : STD_LOGIC;
 SIGNAL butt22     : STD_LOGIC;
 
 SIGNAL p1        : INTEGER := 48;
 SIGNAL p2        : INTEGER := 64;
 SIGNAL p3        : INTEGER := 80;
 
 SIGNAL next_p1   : INTEGER;
 SIGNAL next_p2   : INTEGER;
 SIGNAL next_p3   : INTEGER;
 
 TYPE STATES IS (up, down, static);
 SIGNAL pr_state, nx_state: STATES;
 
 TYPE position IS ARRAY (128-1 DOWNTO 0) OF STD_LOGIC;
  
 SIGNAL posi: position := (OTHERS => '0');
 
BEGIN
 
 butt12 <= not button1;
 butt22 <= not button2;
 
 up1 : ENTITY work.edge_detect
 PORT MAP( clk => clk,
	        async_sig => butt12,
			  rise => buttonup1,
			  fall => OPEN);
 
 up2 : ENTITY work.edge_detect
 PORT MAP( clk => clk,
	        async_sig => butt22,
			  rise => buttonup2,
			  fall => OPEN);
			  			  
 transtions : PROCESS (rst, maxtick0, p1, p2, p3)  
  BEGIN 
    IF (rst ='1') THEN 
        pr_state <= static;
        p1 <= 48;
        p2 <= 64;
        p3 <= 80;		  
    ELSIF (rising_edge(maxtick0)) THEN 
        pr_state <= nx_state;
	 END IF;
  END PROCESS transtions;
  
 raqueta_move : PROCESS (pr_state, p1, p2, p3, posi)
  
  VARIABLE next_i : INTEGER;
  
  BEGIN
    CASE pr_state IS
	   WHEN up =>
		
		 next_p1 <= p1-16;
		 next_p2 <= p2-16;
		 next_p3 <= p3-16;
		 IF (buttonup1 = '1') THEN
		    IF (next_p1 = 0) THEN
		        posi(p1) <= '0';
			     posi <= (OTHERS => '0');
		        posi(next_p1) <= '1';
				  posi(next_p2) <= '1';
				  posi(next_p3) <= '1';
			     p1 <= next_p1;	
				  p2 <= next_p2;
				  p3 <= next_p3;
			     nx_state <= static;
			 ELSE
			     posi(p1) <= '0';
			     posi <= (OTHERS => '0');
		        posi(next_p1) <= '1';
				  posi(next_p2) <= '1';
				  posi(next_p3) <= '1';
			     p1 <= next_p1;	
				  p2 <= next_p2;
				  p3 <= next_p3;
			     nx_state <= up;
	       END IF;
		ELSE
		    nx_state <= static;
		END IF;
		
	   WHEN down =>
		
		next_p1 <= p1+16;
		next_p2 <= p2+16;
		next_p3 <= p3+16;
		 IF (buttonup2 = '1') THEN
		    IF (next_p3 = 112) THEN
		        posi(p3) <= '0';
			     posi <= (OTHERS => '0');
		        posi(next_p1) <= '1';
				  posi(next_p2) <= '1';
				  posi(next_p3) <= '1';
			     p1 <= next_p1;	
				  p2 <= next_p2;
				  p3 <= next_p3;
			     nx_state <= static;
			 ELSE
			     posi(p3) <= '0';
			     posi <= (OTHERS => '0');
		        posi(next_p1) <= '1';
				  posi(next_p2) <= '1';
				  posi(next_p3) <= '1';
			     p1 <= next_p1;	
				  p2 <= next_p2;
				  p3 <= next_p3;
				  nx_state <= down;
	       END IF;
		ELSE
		    nx_state <= static;
		END IF;
		
		WHEN static =>
		 
		 IF ((buttonup1 = '1') AND (p1 = 0))THEN
		    nx_state <= static;
		 ELSIF ((buttonup2 = '1') AND (p3 = 112))THEN
		    nx_state <= static;
		 ELSIF ((buttonup1 = '1') AND (p1 /= 0))THEN
		    nx_state <= up;
		 ELSIF ((buttonup2 = '1') AND (p3 /= 112))THEN
		    nx_state <= down;
		 ELSE
		    nx_state <= static;
		 END IF;
		 END CASE;
  END PROCESS;
  
  positionout <= STD_LOGIC_VECTOR(posi);
 
END ARCHITECTURE behavioral;
  