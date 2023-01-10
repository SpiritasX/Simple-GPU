library ieee;
use ieee.std_logic_1164.all;

library work;
use work.gpu_top_types.all;

entity bus_interface is
	Port (
		iCLK   : in std_logic;
		inRST  : in std_logic;
		iADDR  : in std_logic_vector( 7 downto 0);
		iDATA  : in std_logic_vector(15 downto 0);
		oINSTR :out std_logic_vector(47 downto 0)
	);
end entity;

architecture Behavioral of bus_interface is
	signal sSTART : std_logic;
	signal sEND   : std_logic;
	signal sINSTR : std_logic_vector(47 downto 0);
begin
	
	sSTART <= '1' when iADDR(7 downto 0) = "00000000" else '0';

	sEND <= '1' when iADDR(7 downto 0) = "00000110" else '0';

	process (iCLK, inRST)
	begin
		if (inRST = '0') then
			sINSTR <= (others => '0');
		elsif (rising_edge(iCLK)) then
			if (sSTART = '1') then
				sINSTR <= (others => '0');
			elsif (iADDR(7 downto 0) = "00000001") then
				sINSTR <= sINSTR(41 downto 0) & iDATA(5 downto 0);
			elsif (iADDR(7 downto 0) = "00000010" or iADDR(7 downto 0) = "00000011" or iADDR(7 downto 0) = "00000100" or iADDR(7 downto 0) = "00000101") then
				sINSTR <= sINSTR(37 downto 0) & iDATA(9 downto 0);
			end if;
		end if;
	end process;

	process (sEND)
	begin
		if (sEND = '1') then
			oINSTR <= sINSTR;
		else
			oINSTR <= (others => '0');
		end if;
	end process;

end architecture;