library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parallelAdder is
    Port(
        A, B : in STD_LOGIC_VECTOR(7 downto 0);
        S : out STD_LOGIC_VECTOR(7 downto 0);
        AdderCout : out STD_LOGIC
    );
end parallelAdder;

architecture compose of parallelAdder is
    signal intern : STD_LOGIC_VECTOR(7 downto 1);
begin
    LSB_Cell: entity work.HalfAdderCell
        port map(
            A => A(0),
            B => B(0),
            S => S(0),
            Cout => intern(1)
        );
    FA_GEN: for i in 1 to 6 generate
        FAC: entity work.FullAdderCell
            port map(
                A => A(i),
                B => B(i),
                Cin => intern(i),
                S => S(i),
                Cout => intern(i+1) 
            );
    end generate FA_GEN;
    MSB_Cell: entity work.FullAdderCell
        port map(
            A => A(7),
            B => B(7),
            Cin => intern(7),
            S=> S(7),
            Cout => AdderCout
        );
end compose;
