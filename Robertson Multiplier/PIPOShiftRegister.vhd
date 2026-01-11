library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIPOShiftRegister is
    port(
        read_en: in STD_LOGIC;
        write_en: in STD_LOGIC;
        clr: in STD_LOGIC;
        clk: in STD_LOGIC;
        shift_nload: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR(7 downto 0);
        Q: out STD_LOGIC_VECTOR(7 downto 0)
    );
end PIPOShiftRegister;
architecture behavior of PIPOShiftRegister is
    signal internal_Q: STD_LOGIC_VECTOR(7 downto 0);
    signal D_in: STD_LOGIC_VECTOR(7 downto 0);
begin
    D_in(0) <= A(0) when shift_nload = '0' else '0';
    gen_logic: for i in 0 to 7 generate
        D_in(i) <= (internal_Q(i-1) and shift_nload) or (A(i) and not shift_nload);
    end generate;
    gen_FF: for i in 0 to 7 generate
        D_inst: entity work.DFlipFlop
            port map(
                D => D_in(i),
                clk => clk,
                clr => clr,
                Q => internal_Q(i)
            );
    end generate;
    Q <= internal_Q when read_en = '1' else (others => 'Z');
end behavior;