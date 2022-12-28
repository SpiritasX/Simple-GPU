library ieee;
use ieee.std_logic_1164.all;

entity priority_coder is
	Port (
		iD : in std_logic_vector(7 downto 0);
		oQ :out std_logic_vector(2 downto 0);
	);
end priority_coder;

architecture Behavioral of priority_coder
begin
	oQ <= "000" when iD(7) = '1' else
	      "001" when iD(6) = '1' else
			"010" when iD(5) = '1' else
			"011" when iD(4) = '1' else
			"100" when iD(3) = '1' else
			"101" when iD(2) = '1' else
			"110" when iD(1) = '1' else
			"111";
end Behavioral;