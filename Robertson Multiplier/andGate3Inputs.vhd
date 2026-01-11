library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity andGate3Inputs is
	Port(
		A, B, C : in STD_LOGIC;
		Z : out STD_LOGIC
	);
end andGate3Inputs;

architecture behavior of andGate3Inputs is
	signal partialZ : STD_LOGIC;
begin
	partialZ <= A and B;
	Z <= partialZ and C;
end behavior; 