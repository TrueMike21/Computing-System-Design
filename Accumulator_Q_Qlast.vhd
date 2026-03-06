library ieee;
use ieee.std_logic_1164.all;

entity Accumulator_Q_Qlast is
    port(add,sub: in std_logic;    
        Accumulator, Multiplier     : in  std_logic_vector(22 downto 0);
        Load    : in  std_logic;
        clk     : in  std_logic;
        R_shift : in  std_logic;
		  Q_0     : out std_logic;
		  Q_last  : out std_logic;
		  Ac_mul  : out std_logic_vector(22 downto 0);
        Qout    : out std_logic_vector(45 downto 0)
    );
end entity Accumulator_Q_Qlast;

architecture structural of Accumulator_Q_Qlast is

 component register23_rsh_in_MSB is
    port(
	     newMSB  : in std_logic;
        Qin     : in  std_logic_vector(22 downto 0);
        Load    : in  std_logic;
        clk     : in  std_logic;
        R_shift : in  std_logic;
        Qout    : out std_logic_vector(22 downto 0)
    );
end component register23_rsh_in_MSB;

 component register23_asr is
    port(
        Qin     : in  std_logic_vector(22 downto 0);
        Load    : in  std_logic;
        clk     : in  std_logic;
        R_shift : in  std_logic;
        Qout    : out std_logic_vector(22 downto 0)
    );
end component register23_asr;

   component en_dff_ms is  
	port(
    D : in  std_logic;
	 en: in std_logic;
    clk : in  std_logic;
    Q : out std_logic;
	 Qn: out std_logic
  );
end component en_dff_ms;

signal Acc,quo: std_logic_vector(22 downto 0);
 
begin

unitqlast: en_dff_ms
port map(
    D=>quo(0) and R_shift,
	 en=>R_shift,
	 clk=>clk,
	 Q=>Q_last);
	 
unitMultiplier: register23_rsh_in_MSB 
    port map(
	     newMSB=>Acc(0),  
        Qin=> Multiplier,  
        Load =>Load,
        clk=>clk,   
        R_shift=>R_shift,
        Qout=>quo);
		  
unitAcc: register23_asr
port map(
        Qin=>Accumulator,     
        Load=>Load xor add xor sub,    
        clk=>clk,    
        R_shift=>R_shift, 
        Qout=>Acc    
	 );
	 
	
-- Map quo -> Qout(22 downto 0)
    gen_quo : for i in 0 to 22 generate
        Qout(i) <= quo(i);
    end generate;

    -- Map Acc -> Qout(45 downto 23)
    gen_acc : for i in 0 to 22 generate
        Qout(i + 23) <= Acc(i);
    end generate;
	 
	 Ac_mul<=Acc;
	 Q_0<=quo(0);
	 
end architecture structural;
	 
	 
