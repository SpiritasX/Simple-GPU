library ieee;
use ieee.std_logic_1164.all;

entity mux is
	Port (
		iD0 : in std_logic_vector(7 downto 0);
		iD1 : in std_logic_vector(7 downto 0);
		iD2 : in std_logic_vector(7 downto 0);
		iD3 : in std_logic_vector(7 downto 0);
		iSEL: in std_logic_vector(1 downto 0);
		oQ  :out std_logic_vector(7 downto 0);
	);
end mux;

architecture Behavioral of mux
begin
	with iSEL select oQ<=
		iD0 when "00",
		iD1 when "01",
		iD2 when "10",
		iD3 when others;
end Behavioral;