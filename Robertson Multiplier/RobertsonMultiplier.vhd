library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RobertsonMultiplier is
    port(
        clk       : in  STD_LOGIC;
        begin_sig : in  STD_LOGIC;
        end_sig   : out STD_LOGIC;
        inbus     : in  STD_LOGIC_VECTOR(7 downto 0);
        reset     : in  STD_LOGIC;
        outbus    : out STD_LOGIC_VECTOR(15 downto 0);
        overflow  : out STD_LOGIC
    );
end RobertsonMultiplier;

architecture structural of RobertsonMultiplier is
    signal controls : STD_LOGIC_VECTOR(6 downto 0);
    signal A_reg, Q_reg, M_reg : STD_LOGIC_VECTOR(7 downto 0);
    signal fromAdderToAcc  : STD_LOGIC_VECTOR(7 downto 0);
    signal fromEXORToAdder : STD_LOGIC_VECTOR(7 downto 0);
    signal overflow_int    : STD_LOGIC;
    signal fromCounterToControl : STD_LOGIC;
    signal A_parallel_in : STD_LOGIC_VECTOR(7 downto 0);
    signal Q_parallel_in : STD_LOGIC_VECTOR(7 downto 0);
    signal A_write_en : STD_LOGIC;
    signal Q_write_en : STD_LOGIC;
    signal zeros8 : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal signM, signQ : STD_LOGIC;
    signal signOut      : STD_LOGIC;
    signal C2_eff: STD_LOGIC;
    signal in_xor_M  : STD_LOGIC_VECTOR(7 downto 0);
    signal in_xor_Q  : STD_LOGIC_VECTOR(7 downto 0);
    signal absM_in   : STD_LOGIC_VECTOR(7 downto 0);
    signal absQ_in   : STD_LOGIC_VECTOR(7 downto 0);
    signal dummy_cM  : STD_LOGIC;
    signal dummy_cQ  : STD_LOGIC;
    signal signM_clr, signQ_clr : STD_LOGIC;
    signal signM_D, signQ_D     : STD_LOGIC;
    signal prod_raw   : STD_LOGIC_VECTOR(15 downto 0);
    signal prod_xor   : STD_LOGIC_VECTOR(15 downto 0);
    signal prod_final : STD_LOGIC_VECTOR(15 downto 0);
    signal low_sum, high_sum : STD_LOGIC_VECTOR(7 downto 0);
    signal c_low, c_high     : STD_LOGIC;
    signal zeros16_hi : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin
    ControlUnit: entity work.ControlUnit
        port map(
            clk        => clk,
            rst        => reset,
            start      => begin_sig,
            q0         => Q_reg(0),
            count_done => fromCounterToControl,
            C0         => controls(0),
            C1         => controls(1),
            C2         => controls(2),
            C3         => controls(3),
            C4         => controls(4),
            C5         => controls(5),
            C6         => controls(6),
            done       => end_sig
        );

    Counter: entity work.synchronousCounter
        port map(
            clk   => clk,
            reset => controls(0),
            en    => controls(3),
            done  => fromCounterToControl
        );

    signM_clr <= reset;
    signQ_clr <= reset;
    C2_eff <= controls(2) and not controls(4);
    signM_D <= inbus(7) when controls(0)='1' else signM;
    signQ_D <= inbus(7) when controls(1)='1' else signQ;

    SignMFF: entity work.DFlipFlop
        port map(D => signM_D, clk => clk, clr => signM_clr, Q => signM);

    SignQFF: entity work.DFlipFlop
        port map(D => signQ_D, clk => clk, clr => signQ_clr, Q => signQ);

    signOut <= signM xor signQ;

    AbsMXorGen: for i in 0 to 7 generate
        X_M: entity work.xorGate
            port map(A => inbus(i), B => inbus(7), Z => in_xor_M(i));
    end generate;

    AbsMAdder: entity work.parallelAdder
        port map(
            A          => in_xor_M,
            B          => zeros8,
            Cin_global => inbus(7),
            S          => absM_in,
            AdderCout  => dummy_cM
        );

    AbsQXorGen: for i in 0 to 7 generate
        X_Q: entity work.xorGate
            port map(A => inbus(i), B => inbus(7), Z => in_xor_Q(i));
    end generate;

    AbsQAdder: entity work.parallelAdder
        port map(
            A          => in_xor_Q,
            B          => zeros8,
            Cin_global => inbus(7),
            S          => absQ_in,
            AdderCout  => dummy_cQ
        );

    Multiplicand: entity work.PIPONoShiftRegister
        port map(
            clk      => clk,
            clr      => reset,
            read_en  => '1',
            write_en => controls(0),
            A        => absM_in,
            Q        => M_reg
        );

    fromEXORToAdder <= M_reg;

    Adder: entity work.parallelAdder
        port map(
            A          => fromEXORToAdder,
            B          => A_reg,
            Cin_global => '0',
            S          => fromAdderToAcc,
            AdderCout  => overflow_int
        );

    overflow <= overflow_int;

    A_parallel_in <= (others => '0') when controls(0) = '1'
                 else fromAdderToAcc when C2_eff = '1'
                 else A_reg;

    A_write_en <= controls(0) or C2_eff or controls(5) or controls(3);

    Accumulator: entity work.PIPOShiftRegister
        port map(
            clk        => clk,
            shift_nLoad => controls(3),
            ser_in      => '0',
            read_en     => '1',
            write_en    => A_write_en,
            clr         => reset,
            A           => A_parallel_in,
            Q           => A_reg
        );

    Q_parallel_in <= absQ_in when controls(1)='1' else Q_reg;
    Q_write_en    <= controls(1) or controls(3);

    Multiplier: entity work.PIPOShiftRegister
        port map(
            clk        => clk,
            shift_nLoad => controls(3),
            ser_in      => A_reg(0),
            read_en     => '1',
            write_en    => Q_write_en,
            clr         => reset,
            A           => Q_parallel_in,
            Q           => Q_reg
        );

    prod_raw <= A_reg & Q_reg;

    ProdXorGen: for i in 0 to 15 generate
        X_P: entity work.xorGate
            port map(A => prod_raw(i), B => signOut, Z => prod_xor(i));
    end generate;

    AddLow: entity work.parallelAdder
        port map(
            A          => prod_xor(7 downto 0),
            B          => zeros8,
            Cin_global => signOut,
            S          => low_sum,
            AdderCout  => c_low
        );

    AddHigh: entity work.parallelAdder
        port map(
            A          => prod_xor(15 downto 8),
            B          => zeros16_hi,
            Cin_global => c_low,
            S          => high_sum,
            AdderCout  => c_high
        );

    prod_final <= high_sum & low_sum;
    outbus <= prod_final;

end structural;
