library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xorGate is
	Port(
		A, B : in STD_LOGIC;
		Z : out STD_LOGIC
	);
end xorGate;

architecture behavior of xorGate is begin
	Z <= A xor B;
end behavior;