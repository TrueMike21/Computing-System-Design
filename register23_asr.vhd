library ieee;
use ieee.std_logic_1164.all;

entity register23_asr is
    port(
        Qin     : in  std_logic_vector(22 downto 0);
        Load    : in  std_logic;
        clk     : in  std_logic;
        R_shift : in  std_logic;
        Qout    : out std_logic_vector(22 downto 0)
    );
end entity register23_asr;

architecture structural of register23_asr is

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

    -- Internal signal to hold the state of the registers
    signal d : std_logic_vector(22 downto 0);

begin

    -- Instance for Bit 0 (LSB)
    u0 : en_dff_ms 
        port map(
            D   => (Load and Qin(0)) xor (d(1) and R_shift), 
            en  => Load xor R_shift, 
            clk => clk, 
            Q   => d(0), 
            Qn  => open
        );

    -- Instances for Bits 1 through 21
    gen_bits: for i in 1 to 21 generate
        u_loop : en_dff_ms 
            port map(
                D   => (Load and Qin(i)) xor (d(i+1) and R_shift), 
                en  => Load xor R_shift, 
                clk => clk, 
                Q   => d(i), 
                Qn  => open
            );
    end generate;

    -- Instance for Bit 22 (MSB)
    u22 : en_dff_ms 
        port map(
            D   => (Load and Qin(22)) xor (d(22) and R_shift), -- Copy MSB
            en  => Load xor R_shift, 
            clk => clk, 
            Q   => d(22), 
            Qn  => open
        );

    Qout <= d;

end architecture structural;