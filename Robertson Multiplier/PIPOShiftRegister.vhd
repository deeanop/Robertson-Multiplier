library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIPOShiftRegister is
    port(
        read_en: in STD_LOGIC;
        write_en: in STD_LOGIC;
        clr: in STD_LOGIC;
        clk: in STD_LOGIC;
        shift_nload: in STD_LOGIC;
        ser_in: in STD_LOGIC;
        A: in STD_LOGIC_VECTOR(7 downto 0);
        Q: out STD_LOGIC_VECTOR(7 downto 0)
    );
end PIPOShiftRegister;
architecture behavior of PIPOShiftRegister is
    signal internal_Q: STD_LOGIC_VECTOR(7 downto 0);
    signal mux_out: STD_LOGIC_VECTOR(7 downto 0);
    signal d_final: STD_LOGIC_VECTOR(7 downto 0);
begin
    gen_logic: for i in 0 to 7 generate
        bit_7: if i = 7 generate
            mux_out(i) <= A(i) when shift_nload = '0' else ser_in;
        end generate;
        bit_rest: if i < 7 generate
            mux_out(i) <= A(i) when shift_nload = '0' else internal_Q(i+1);
        end generate;
    end generate;
    d_final <= mux_out when write_en = '1' else internal_Q;
    gen_D: for i in 0 to 7 generate begin
        D_inst: entity work.DFlipFlop
            port map(
                D => d_final(i),
                clk => clk,
                clr => clr,
                Q => internal_Q(i)
            );
    end generate;
    Q <= internal_Q when read_en = '1' else (others => 'Z');
end behavior;
