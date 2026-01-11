library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JKFlipFlop is
    port(
        J, K, clk : in STD_LOGIC;
        Q : out STD_LOGIC
    );
end JKFlipFlop;

architecture behavior of JKFlipFlop is
    signal q_internal: STD_LOGIC := '0';
begin
    process(clk) begin
        if rising_edge(clk) then
            q_internal <= (J and not q_internal) or (not K and q_internal);
        end if;
    end process;
    Q <= q_internal;
end behavior;