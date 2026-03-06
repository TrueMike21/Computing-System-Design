library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
    port(
        Sel     : in  std_logic;
        A    : in  std_logic;
        B     : in  std_logic;
        C    : out std_logic
    );
end entity mux2to1;

architecture structural of mux2to1 is

begin

C<=(not(Sel) and A) or (Sel and B);

end architecture structural;
