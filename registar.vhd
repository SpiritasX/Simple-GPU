library ieee;
use ieee.std_logic_1164.all;

entity registar is
	Port (
			iD    : in std_logic_vector(47 downto 0);
			iCLK  : in std_logic;
			inRST : in std_logic;
			iWE   : in std_logic;
			oQ    : out std_logic_vector(47 downto 0)
	);
end registar;

architecture Behavioral of registar is
begin
	process (iCLK, inRST)
	begin
		if (inRST = '0') then
			oQ <= (others => '0');
		elsif (rising_edge(iCLK)) then
			if(iWE = '1') then
				oQ <= iD;
			end if;
		end if;
	end process;	
end Behavioral;