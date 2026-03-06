library ieee;
use ieee.std_logic_1164.all;

entity dff_ms is
  port(
    D : in  std_logic;
    clk : in  std_logic;
    Q : out std_logic;
	 Qn: out std_logic
  );
end entity dff_ms;

architecture rtl of dff_ms is

signal s,s1,s2,s3, r,r1,r2,r3 : std_logic;

begin

s<=not(D and not(clk));
s1<=not(s and r1);
s2<=not(s1 and clk);
s3<=not(s2 and r3);

r<=not(not(D) and not(clk));
r1<=not(s1 and r);
r2<=not(r1 and clk);
r3<=not(s3 and r2);

Q<=s3;
Qn<=r3;
  
end architecture rtl;