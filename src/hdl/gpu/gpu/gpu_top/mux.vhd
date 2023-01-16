library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.gpu_top_types.all;

entity mux_gen is
	Generic (
		N     : integer := 8;
		log2N : integer := 3
	);
	Port (
		iD  : in INPUTS(N-1 downto 0);
		iSEL: in std_logic_vector(log2N-1 downto 0);
		oQ  :out std_logic_vector(23 downto 0)
	);
end mux_gen;

architecture Behavioral of mux_gen is
begin
	process (iD, iSEL)
	begin
		oQ <= iD(to_integer(unsigned(iSEL)));
	end process;
end Behavioral;