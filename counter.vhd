library ieee;
use ieee.std_logic_1164.all;

entity counter is
    port(
	     Load: in std_logic;
	     decrement: in std_logic;
		  clk : in  std_logic;
		  count: out std_logic
    );
end entity counter;

architecture structural  of counter is
    -- Component Declaration
    component en_dff_ms is
        port(
            D   : in  std_logic;
            en  : in  std_logic;
            clk : in  std_logic;
            Q   : out std_logic;
            Qn  : out std_logic
        );
    end component en_dff_ms;
	 
  component fullAdder is
  port(
    A : in  std_logic;
    B : in  std_logic;
    Cin : in std_logic;
	 S : out std_logic;
	 Cout: out std_logic
  );
end component fullAdder;

signal s,d: std_logic_vector(4 downto 0);   
signal c1, c2, c3,c4: std_logic; 
	 
begin
 
    u0 : en_dff_ms 
        port map(
            D   => (Load and '1') xor (decrement and s(0)), 
            en  => Load xor decrement, 
            clk => clk, 
            Q   => d(0), 
            Qn  => open
        );
		  
		  
    u1 : en_dff_ms 
        port map(
            D   => (Load and '1') xor (decrement and s(1)), 
            en  => Load xor decrement, 
            clk => clk, 
            Q   => d(1), 
            Qn  => open
        );
		  
   
    u2 : en_dff_ms 
        port map(
            D   => (Load and '1') xor (decrement and s(2)), 
            en  => Load xor decrement, 
            clk => clk, 
            Q   => d(2), 
            Qn  => open
        );
		  
		  
    u3 : en_dff_ms 
        port map(
            D   => (Load and '0') xor (decrement and s(3)), 
            en  => Load xor decrement, 
            clk => clk, 
            Q   => d(3), 
            Qn  => open
        );
		  
    u4 : en_dff_ms 
        port map(
            D   => (Load and '1') xor (decrement and s(4)), 
            en  => Load xor decrement, 
            clk => clk, 
            Q   => d(4), 
            Qn  => open
        );
		  
		 sum0: fullAdder
		 port map(
		 A=>d(0),
		 B=>'1',
		 Cin=>'0',
		 S=>s(0),
		 Cout=>c1);
		 
		 sum1: fullAdder
		 port map(
		 A=>d(1),
		 B=>'1',
		 Cin=>c1,
		 S=>s(1),
		 Cout=>c2);
		 
		 sum2: fullAdder
		 port map(
		 A=>d(2),
		 B=>'1',
		 Cin=>c2,
		 S=>s(2),
		 Cout=>c3);
		 
		 sum3: fullAdder
		 port map(
		 A=>d(3),
		 B=>'1',
		 Cin=>c3,
		 S=>s(3),
		 Cout=>c4);
		 
		 sum4: fullAdder
		 port map(
		 A=>d(4),
		 B=>'1',
		 Cin=>c4,
		 S=>s(4),
		 Cout=>open);
		 
		 count<=not(d(0)) and not(d(1)) and not(d(2)) and not(d(3)) and not(d(4));
		 
end architecture structural;