library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdderCell is
    Port(
        A, B, Cin : in STD_LOGIC;
        S, Cout : out STD_LOGIC
    );
end FullAdderCell;

architecture behavior of FullAdderCell is begin
    S <= A xor B xor Cin;
    Cout <= (A and B) or (B and Cin) or (A and Cin);
end behavior;
