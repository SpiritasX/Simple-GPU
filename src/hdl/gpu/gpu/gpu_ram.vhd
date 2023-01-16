library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.gpu_top_types.all;

entity gpu_ram is
	Port (
		iCLK   : in std_logic;
		inRST  : in std_logic;
		iEN    : in std_logic;
		iINSTR : in std_logic_vector(47 downto 0);
		iADDR  : in std_logic_vector(15 downto 0);
		oQ     :out t_register_array
	);
end entity;

architecture Behavioral of gpu_ram is
	signal sLOAD      : std_logic_vector(N-1 downto 0);
	signal sQ         : t_register_array;
	signal sNEXT_LOAD : std_logic_vector(N-1 downto 0);
begin

	process (iCLK, inRST)
	begin
		if (inRST <= '0') then
			sLOAD <= (others => '0');
		elsif (rising_edge(iCLK)) then
			if (iEN = '1') then
				sLOAD <= sNEXT_LOAD;
			end if;
		end if;
	end process;

	process (iADDR)
	begin
		sNEXT_LOAD <= (others => '0');
		
		for i in 0 to N-1 loop
			if (iADDR = std_logic_vector(to_unsigned(i, 16))) then
				sNEXT_LOAD(i) <= '1';
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