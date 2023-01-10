library ieee;
use ieee.std_logic_1164.all;

library work;
use work.gpu_top_types.all;

entity gpu_ram is
	Port (
		iCLK   : in std_logic;
		inRST  : in std_logic;
		iADDR  : in std_logic_vector(  7 downto 0);
		iINSTR : in std_logic_vector( 47 downto 0);
		oQ     :out t_register_array
	);
end entity;

architecture Behavioral of gpu_ram is
	signal sLOAD : std_logic_vector(N-1 downto 0);
	signal sQ    : t_register_array;
begin
	
	process (iINSTR)
	begin
		sLOAD <= (others => '0');
		for i in 0 to N-1 loop
			if (sQ(i) = "000000000000000000000000000000000000000000000000") then
				sLOAD(i) <= '1';
				exit;
			end if;
		end loop;
	end process;

	Regs : for i in 0 to N-1 generate
		REGISTAR : entity work.registar
		port map (
			iCLK  => iCLK,
			inRST => inRST,
			iWE   => sLOAD(i),
			iD    => iINSTR,
			oQ    => sQ(i)
		);
	end generate;
	
	oQ <= sQ;
end architecture;