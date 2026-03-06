library ieee;
use ieee.std_logic_1164.all;

entity fullAdder is
  port(
    A : in  std_logic;
    B : in  std_logic;
    Cin : in std_logic;
	 S : out std_logic;
	 Cout: out std_logic
  );
end entity fullAdder;

architecture rtl of fullAdder is

begin

S<=(A xor B) xor Cin;
Cout<=((A xor B) and Cin) or (A and B);

end architecture rtl;