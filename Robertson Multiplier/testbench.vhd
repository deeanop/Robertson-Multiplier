library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RobertsonMultiplier_tb is
end RobertsonMultiplier_tb;

architecture behavior of RobertsonMultiplier_tb is
    signal clk: STD_LOGIC := '0';
    signal reset: STD_LOGIC := '0';
    signal begin_sig: STD_LOGIC := '0';
    signal inbus: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal end_sig: STD_LOGIC;
    signal outbus: STD_LOGIC_VECTOR(15 downto 0);
    signal overflow: STD_LOGIC;
    constant CLK_PERIOD: time := 10 ns;

    type test_vector_array is array (0 to 5) of STD_LOGIC_VECTOR(7 downto 0);
    type result_array is array (0 to 5) of STD_LOGIC_VECTOR(15 downto 0);

    constant test_inputs      : test_vector_array := (
        0 => "11111011",
	1 => "00000011",
        2 => "00001010",
        3 => "00001011",
        4 => "10101100",
        5 => "11110000"
    );
    constant test_multipliers : test_vector_array := (
        0 => "00000101",
	1 => "00000101",
        2 => "11111110",
        3 => "00110110",
        4 => "11100110",
        5 => "00000000"
    );

begin
    uut: entity work.RobertsonMultiplier
        port map(
            clk => clk,
            begin_sig => begin_sig,
            end_sig => end_sig,
            inbus => inbus,
            reset => reset,
            outbus => outbus,
            overflow => overflow
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_proc: process
    begin
        reset <= '1';
        wait for 2*CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;

        for i in 0 to 5 loop
            inbus <= test_inputs(i);
            wait until rising_edge(clk);
            begin_sig <= '1';  
            wait until rising_edge(clk);
            begin_sig <= '0';
	    wait until rising_edge(clk);
            inbus <= test_multipliers(i);
	    wait until rising_edge(clk);
            wait until end_sig = '1';
            wait until rising_edge(clk);
            reset <= '1';
            wait until rising_edge(clk);
            reset <= '0';
            wait until rising_edge(clk);
        end loop;

        report "All tests completed.";
        wait;
    end process;

end behavior;

