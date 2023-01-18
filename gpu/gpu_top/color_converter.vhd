library ieee;
use ieee.std_logic_1164.all;

entity color_converter is
	Port (
		i6bitColor  : in std_logic_vector( 5 downto 0);
		o24bitColor :out std_logic_vector(23 downto 0)
	);
end color_converter;

architecture Behavioral of color_converter is
	signal sRED   : std_logic_vector(7 downto 0);
	signal sGREEN : std_logic_vector(7 downto 0);
	signal sBLUE  : std_logic_vector(7 downto 0);
begin
	with i6bitColor(5 downto 4) select sRED <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
	
	with i6bitColor(3 downto 2) select sGREEN <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with i6bitColor(1 downto 0) select sBLUE <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
	
	o24bitCOlor <= sBLUE & sGREEN & sRED;
end Behavioral;