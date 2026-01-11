library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HalfAdderCell is
    Port(
        A, B : in STD_LOGIC;
        S, Cout : out STD_LOGIC
    );
end HalfAdderCell;

architecture behavior of HalfAdderCell is begin
    S <= A xor B;
    Cout <= A and B;
end behavior;