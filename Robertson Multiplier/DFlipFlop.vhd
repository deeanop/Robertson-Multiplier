library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DFlipFlop is
    port(
        D: in STD_LOGIC;
        clk: in STD_LOGIC;
        clr: in STD_LOGIC;
        Q: out STD_LOGIC
    );
end DFlipFlop;
architecture behavior of DFlipFlop is begin
    process(clk, clr) begin
        if clr = '1' then
            Q <= '0';
        elsif rising_edge(clk) then
            Q <= D;
        end if;
    end process;
end behavior;