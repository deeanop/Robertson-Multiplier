library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity synchronousCounter is
    port(
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        en: in STD_LOGIC;
        done: out STD_LOGIC
    );
end synchronousCounter;
architecture behavior of synchronousCounter is
    signal temp_count: unsigned(3 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            temp_count <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                if temp_count < to_unsigned(8, 4) then
                    temp_count <= temp_count + 1;
                end if;
            end if;
        end if;
    end process;
    done <= '1' when temp_count =  to_unsigned(8, 4) else '0';

end behavior;
