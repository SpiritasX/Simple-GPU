library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package gpu_top_types is
	constant N : integer := 8;
	constant log2N : integer := positive(ceil(log2(real(N))));

	type INPUTS is array (integer range <>) of std_logic_vector(23 downto 0);
	type t_comp_array is array (0 to N-1) of std_logic;
	type t_register_array is array (0 to N-1) of std_logic_vector(47 downto 0);
end package gpu_top_types;

