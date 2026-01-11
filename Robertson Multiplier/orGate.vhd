library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
	
entity orGate is
	Port(
		A, B : in STD_LOGIC;
		Z : out STD_LOGIC
	);
end orGate;

architecture behavior of orGate is begin
	Z < A or B;
end behavior;