library ieee;
use ieee.std_logic_1164.all;

entity mux2to1_23 is
    port(
        Sel : in  std_logic;
        A   : in  std_logic_vector(22 downto 0);
        B   : in  std_logic_vector(22 downto 0);
        C   : out std_logic_vector(22 downto 0)
    );
end entity mux2to1_23;

architecture structural of mux2to1_23 is
    -- Component declaration (VHDL-93 style). If you use VHDL-2008, you can
    -- directly instantiate 'entity work.mux2to1' without this component.
    component mux2to1 is
        port(
            Sel : in  std_logic;
            A   : in  std_logic;
            B   : in  std_logic;
            C   : out std_logic
        );
    end component;
begin
    gen_mux : for i in 0 to 22 generate
        u_mux : mux2to1
            port map(
                Sel => Sel,
                A   => A(i),
                B   => B(i),
                C   => C(i)
            );
    end generate gen_mux;
end architecture structural;