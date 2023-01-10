library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.gpu_top_types.all;

entity priority_coder is
	Port (
		iD : in std_logic_vector(N-1 downto 0);
		oQ :out std_logic_vector(log2N-1 downto 0)
	);
end priority_coder;

architecture Behavioral of priority_coder is
begin
	process (iD)
	begin
		oQ <= (others => '0');
		G_1 : for i in 0 to N-1 loop
			if (iD(i) = '1') then
				oQ <= std_logic_vector(to_unsigned(i, log2N));
			end if;
		end loop;
	end process;
end Behavioral;