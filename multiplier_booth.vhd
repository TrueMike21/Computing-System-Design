library ieee;
use ieee.std_logic_1164.all;

entity multiplier_booth is
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;

        Multiplicand : in  std_logic_vector(22 downto 0);
        Multiplier   : in  std_logic_vector(22 downto 0);
        Accumulator  : in  std_logic_vector(22 downto 0);

        Qout         : out std_logic_vector(45 downto 0);
        Q0           : out std_logic;
        Q_last       : out std_logic
    );
end entity multiplier_booth;


architecture structural of multiplier_booth is

    --------------------------------------------------------------------
    -- COMPONENT DECLARATIONS
    --------------------------------------------------------------------

    -- Datapath (from your lab1_mul_datapath.txt)
    component datpath_multiplier is
        port(
            add, sub      : in  std_logic;
            Accumulator   : in  std_logic_vector(22 downto 0);
            Multiplier    : in  std_logic_vector(22 downto 0);
            Multiplicand  : in  std_logic_vector(22 downto 0);
            decrement     : in  std_logic;
            Load          : in  std_logic;
            clk           : in  std_logic;
            R_shift       : in  std_logic;
            Q_0           : out std_logic;
            Q_last        : out std_logic;
            Qout          : out std_logic_vector(45 downto 0)
        );
    end component;

    -- Controller (structural version using your D-FFs)
    component controller_struct is
        port(
            clk   : in  std_logic;
            rst   : in  std_logic;
            Q0    : in  std_logic;
            Qm1   : in  std_logic;
            count : in  std_logic;

            add   : out std_logic;
            sub   : out std_logic;
            load  : out std_logic;
            shift : out std_logic;
            dc    : out std_logic
        );
    end component;

    --------------------------------------------------------------------
    -- INTERNAL SIGNALS
    --------------------------------------------------------------------
    signal add_s, sub_s, load_s, shift_s, dc_s : std_logic;
    signal Q0_s, Q_last_s : std_logic;
    signal count_s : std_logic;

begin

    --------------------------------------------------------------------
    -- INSTANTIATE DATAPATH
    --------------------------------------------------------------------
    U_DATAPATH : datpath_multiplier
        port map(
            add         => add_s,
            sub         => sub_s,
            Accumulator => Accumulator,
            Multiplier  => Multiplier,
            Multiplicand=> Multiplicand,
            decrement   => dc_s,
            Load        => load_s,
            clk         => clk,
            R_shift     => shift_s,
            Q_0         => Q0_s,
            Q_last      => Q_last_s,
            Qout        => Qout
        );

    --------------------------------------------------------------------
    -- INSTANTIATE CONTROLLER (pure structural)
    --------------------------------------------------------------------
    U_CTRL : controller_struct
        port map(
            clk   => clk,
            rst   => rst,
            Q0    => Q0_s,
            Qm1   => Q_last_s,
            count => count_s,

            add   => add_s,
            sub   => sub_s,
            load  => load_s,
            shift => shift_s,
            dc    => dc_s
        );

    --------------------------------------------------------------------
    -- OUTPUTS
    --------------------------------------------------------------------
    Q0     <= Q0_s;
    Q_last <= Q_last_s;

end architecture structural;