library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity andGate2Inputs is
	Port(
		A, B : in STD_LOGIC;
		Z : out STD_LOGIC
	);
end adnGate2Inputs;

architecture behavior of andGate2Inputs is begin
	Z <= A and B;
end behavior;