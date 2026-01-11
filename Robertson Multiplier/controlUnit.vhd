library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    port(
        clk: in STD_LOGIC;
        rst: in STD_LOGIC;
        start: in STD_LOGIC;
        q0: in STD_LOGIC;
        count_val: in integer range 0 to 7;
        C0: out STD_LOGIC;
        C1: out STD_LOGIC;
        C2: out STD_LOGIC;
        C3: out STD_LOGIC;
        C4: out STD_LOGIC;
        C5: out STD_LOGIC;
        C6: out STD_LOGIC;
        done: out STD_LOGIC
    );
end ControlUnit;
architecture behavior of ControlUnit is
    type state_type is (S_BEGIN, S_INPUT_Q, S_TEST1, S_ADD, S_SHIFT, S_TEST2, S_TEST3, S_CORR, S_OUT_A, S_OUT_Q, S_END);
    signal current_state, next_state: state_type;
begin
    process(clk, rst) begin
        if rst = '1' then
            current_state <= S_BEGIN;
        elsif rising_Edge(clk) then
            current_State <= next_state;
        end if;
    end process;
    process(current_state, start, q0, count_val) begin
        C0 <= '0'; C1 <= '0'; C2 <= '0'; C3 <= '0'; C4 <= '0'; C5 <= '0'; C6 <= '0'; done <= '0';
        next_state <= current_state;
        case current_state is
            when S_BEGIN => 
                C0 <= '1';
                if start = '1' then 
                    next_state <= S_INPUT_Q;
                end if;
            when S_INPUT_Q => 
                C1 <= '1';
                next_state <= S_TEST1;
            when S_TEST1 => 
                if q0 = '1' then 
                    next_state <= S_ADD;
                else
                    next_state <= S_SHIFT;
                end if;
            when S_ADD =>
                C2 <= '1';
                next_state <= S_SHIFT;
            when S_SHIFT => 
                C3 <= '1';
                next_state <= S_TEST2;
            when S_TEST2 => 
                if count_val < 7 then
                    next_state <= S_TEST1;
                else
                    next_state <= S_TEST3;
                end if;
            when S_TEST3 => 
                if q0 = '1' then
                    next_state <= S_CORR;
                else
                    next_state <= S_OUT_A;
                end if;
            when S_CORR => 
                C2 <= '1';
                C4 <= '1';
                next_state <= S_OUT_A;
            when S_OUT_A => 
                C5 <= '1';
                next_state <= S_OUT_Q;
            when S_OUT_Q => 
                C6 <= '1';
                next_state <= S_END; 
            when S_END => 
                done <= '1';
                if start = '0' then
                    next_state <= S_BEGIN;
                end if;
        end case;
    end process;
end behavior;