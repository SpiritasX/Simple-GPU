library ieee;
use ieee.std_logic_1164.all;

entity mux is
	Port (
		iD0 : in std_logic_vector(23 downto 0);
		iD1 : in std_logic_vector(23 downto 0);
		iD2 : in std_logic_vector(23 downto 0);
		iD3 : in std_logic_vector(23 downto 0);
		iD4 : in std_logic_vector(23 downto 0);
		iD5 : in std_logic_vector(23 downto 0);
		iD6 : in std_logic_vector(23 downto 0);
		iD7 : in std_logic_vector(23 downto 0);
		iSEL: in std_logic_vector( 2 downto 0);
		oQ  :out std_logic_vector(23 downto 0)
	);
end mux;

architecture Behavioral of mux is
begin
	with iSEL select oQ <=
		iD0 when "000",
		iD1 when "001",
		iD2 when "010",
		iD3 when "011",
		iD4 when "100",
		iD5 when "101",
		iD6 when "110",
		iD7 when others;
		
end Behavioral;