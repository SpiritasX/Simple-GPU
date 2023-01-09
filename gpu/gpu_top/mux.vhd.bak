library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.gpu_top_types.all;

entity mux is
	Generic (
		N     : integer := 8;
		log2N : integer := 3
	);
	Port (
		iD  : in INPUTS(N-1 downto 0);
		iSEL: in std_logic_vector(log2N-1 downto 0);
		oQ  :out std_logic_vector(23 downto 0)
	);
end mux;

architecture Behavioral of mux is
begin
	process (iD)
	begin
		L_1 : for i in 0 to N-1 loop
			if (to_integer(unsigned(iSEL)) = i) then
				oQ <= iD(i);
			end if;
		end loop;
	end process;
end Behavioral;