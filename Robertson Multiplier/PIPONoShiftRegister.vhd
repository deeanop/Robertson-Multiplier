library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIPONoShiftRegister is
    port(
        read_en: in STD_LOGIC;
        clr: in STD_LOGIC;
        write_en: in STD_LOGIC;
        clk: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR(7 downto 0);
        Q: out STD_LOGIC_VECTOR(7 downto 0)
    );
end PIPONoShiftRegister;
architecture behavior of PIPONoShiftRegister is
    signal internal_Q: STD_LOGIC_VECTOR(7 downto 0);
    signal d_input: STD_LOGIC_VECTOR(7 downto 0);
begin
    d_input <= A when (write_en = '1') else internal_Q;
    gen_D: for i in 0 to 7 generate begin
        D_inst: entity work.DFlipFlop
            port map(
                D => d_input(i),
                clk => clk,
                clr => clr,
                Q => internal_Q(i)
            );
    end generate;
    Q <= internal_Q when (read_en = '1') else (others => 'Z');
end behavior;
