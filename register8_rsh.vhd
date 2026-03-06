library ieee;
use ieee.std_logic_1164.all;

entity register8_rsh is
 port(
      Qin: in std_logic_vector(7 downto 0);
		Load: in std_logic;
		clk: in std_logic;
		R_shift: in std_logic;
		Qout: out std_logic_vector(7 downto 0)
		);
end entity register8_rsh;

architecture rtl of register8_rsh is

component en_dff_ms is
  port(
    D : in  std_logic;
	 en: in std_logic;
    clk : in  std_logic;
    Q : out std_logic;
	 Qn: out std_logic
  );
end component en_dff_ms;

signal d: std_logic_vector(7 downto 0);

begin

u0  : en_dff_ms port map(D=>(Load and Qin(0)) xor (d(1) and R_shift), en=>Load xor R_shift, clk=>clk, Q=>d(0), Qn=>open);

u1  : en_dff_ms port map(D => (Load and Qin(1))  xor (d(2)  and R_shift), en => Load xor R_shift, clk => clk, Q => d(1),  Qn => open);

u2  : en_dff_ms port map(D => (Load and Qin(2))  xor (d(3)  and R_shift), en => Load xor R_shift, clk => clk, Q => d(2),  Qn => open);

u3  : en_dff_ms port map(D => (Load and Qin(3))  xor (d(4)  and R_shift), en => Load xor R_shift, clk => clk, Q => d(3),  Qn => open);

u4  : en_dff_ms port map(D => (Load and Qin(4))  xor (d(5)  and R_shift), en => Load xor R_shift, clk => clk, Q => d(4),  Qn => open);

u5  : en_dff_ms port map(D => (Load and Qin(5))  xor (d(6)  and R_shift), en => Load xor R_shift, clk => clk, Q => d(5),  Qn => open);

u6  : en_dff_ms port map(D => (Load and Qin(6))  xor (d(7)  and R_shift), en => Load xor R_shift, clk => clk, Q => d(6),  Qn => open);

u7 : en_dff_ms port map(D => (Load and Qin(7)) xor ('0' and R_shift), en => Load xor R_shift, clk => clk, Q => d(7), Qn => open);

Qout<=d;

end architecture rtl; 