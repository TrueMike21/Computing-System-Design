library ieee;
use ieee.std_logic_1164.all;

entity controller_struct is
    port(
        clk   : in  std_logic;
        rst   : in  std_logic;   -- synchronous reset to enter LOAD
        Q0    : in  std_logic;   -- Q(0)
        Qm1   : in  std_logic;   -- Q(-1)
        count : in  std_logic;   -- '1' => iterations remain

        add   : out std_logic;
        sub   : out std_logic;
        load  : out std_logic;
        shift : out std_logic;
        dc    : out std_logic
    );
end entity controller_struct;

architecture structural of controller_struct is

    --------------------------------------------------------------------
    -- One-hot state encoding using your enabled D-FFs:
    -- L  = LOAD
    -- T  = TEST (decide add/sub/shift-only)
    -- A  = ADD
    -- SB = SUB
    -- SH = SHIFT
    -- DN = DONE
    --------------------------------------------------------------------
    component en_dff_ms is
        port(
            D   : in  std_logic;
            en  : in  std_logic;
            clk : in  std_logic;
            Q   : out std_logic;
            Qn  : out std_logic
        );
    end component;

    -- Current-state bits
    signal L, T, A, SB, SH, DN : std_logic;

    -- Next-state bits
    signal NL, NT, NA, NSB, NSH, NDN : std_logic;

    -- Helper conditions from inputs
    signal c_add, c_sub, c_shift_only, c_more : std_logic;

    -- Constant enable = '1' for all DFFs
    constant VCC : std_logic := '1';

    -- Unused inverted outputs
    signal Ln, Tn, An, SBn, SHn, DNn : std_logic;

begin
    --------------------------------------------------------------------
    -- Booth decision conditions
    --------------------------------------------------------------------
    c_add        <= (not Q0) and (Qm1);     -- Q0Q-1 = 01
    c_sub        <= (Q0) and (not Qm1);     -- Q0Q-1 = 10
    c_shift_only <= (not c_add) and (not c_sub); -- 00 or 11
    c_more       <= count;                  -- '1' => continue

    --------------------------------------------------------------------
    -- Next-state equations (purely combinational)
    -- Synchronous reset to LOAD: on rst='1', NL='1' and others '0'
    --------------------------------------------------------------------
    NL  <= rst or '0';  -- LOAD is entered when rst='1'
    NT  <= (L) or (SH and c_more);
    NA  <= (T and c_add);
    NSB <= (T and c_sub);
    NSH <= (A) or (SB) or (T and c_shift_only);
    NDN <= (SH and (not c_more)) or (DN and (not rst));  -- hold in DONE until rst

    -- NOTE: Because reset is synchronous, assert rst='1' for one clock
    -- to re-enter LOAD. If you prefer an asynchronous reset, you would
    -- need a DFF with an async reset input. Your DFF does not have one. [1](https://uottawa-my.sharepoint.com/personal/mkouo073_uottawa_ca/Documents/Microsoft%20Copilot%20Chat%20Files/D-FLIP-FLOP.txt)

    --------------------------------------------------------------------
    -- State registers (your enabled D-FFs; en='1' so they update each clk)
    --------------------------------------------------------------------
    ff_L  : en_dff_ms port map(D => NL,  en => VCC, clk => clk, Q => L,  Qn => Ln);
    ff_T  : en_dff_ms port map(D => NT,  en => VCC, clk => clk, Q => T,  Qn => Tn);
    ff_A  : en_dff_ms port map(D => NA,  en => VCC, clk => clk, Q => A,  Qn => An);
    ff_SB : en_dff_ms port map(D => NSB, en => VCC, clk => clk, Q => SB, Qn => SBn);
    ff_SH : en_dff_ms port map(D => NSH, en => VCC, clk => clk, Q => SH, Qn => SHn);
    ff_DN : en_dff_ms port map(D => NDN, en => VCC, clk => clk, Q => DN, Qn => DNn);

    --------------------------------------------------------------------
    -- Moore-style outputs (combinational from state bits)
    --------------------------------------------------------------------
    load  <= L;       -- assert during LOAD
    add   <= A;       -- assert during ADD
    sub   <= SB;      -- assert during SUB
    shift <= SH;      -- assert during SHIFT
    dc    <= SH;      -- decrement during SHIFT

end architecture structural;