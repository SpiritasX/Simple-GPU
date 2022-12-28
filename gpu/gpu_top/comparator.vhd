library ieee;
use ieee.std_logic_1164.all;

entity comparator is
	Port (
			iA : in std_logic_vector(39 downto 0);
			iB : in t_pix_x;
			iC : in t_pix_y;
			oQ :out std_logic;
	);
end comparator;

architecture Behavioral of comparator
begin
	oQ <= '1' when (iB > iA(39 downto 30) and iB < iA(19 downto 10)) and (iC > iA(29 downto 20) and iC < iA(9 downto 0)) else '0';
end Behavioral;