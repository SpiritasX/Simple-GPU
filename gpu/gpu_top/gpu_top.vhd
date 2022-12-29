library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.gpu_types.all;
use work.gpu_top_types.all;

entity gpu_top is
	Port (
		iCLK      : in std_logic;
		inRST     : in std_logic;
		iLOAD     : in std_logic_vector(N-1 downto 0);
		iINSTR    : in std_logic_vector(47 downto 0);
		i_pix_x   : in t_pix_x;
		i_pix_y   : in t_pix_x;
		o_pix_rgb :out t_rgb888
	);
end gpu_top;

architecture Behavioral of gpu_top is

	signal sCOMP : t_comp_array;
	signal sR    : t_register_array;
	signal sRCOLOR : INPUTS(N-1 downto 0);
	
	signal sCOMP_COMBINED : std_logic_vector(N-1 downto 0);
	
	signal sCOLOR_SEL : std_logic_vector(log2N-1 downto 0);
	
begin

	G_1 : for i in 0 to N-1 generate
		COMPARATOR : entity work.comparator
		port map (
			iA => sR(i)(39 downto 0),
			iB => i_pix_x,
			iC => i_pix_y,
			oQ => sCOMP(i)
		);
	end generate;
	
	G_2 : for i in 0 to N-1 generate
		REGISTAR : entity work.registar
		port map (
			iCLK  => iCLK,
			inRST => inRST,
			iWE   => iLOAD(i),
			iD    => iINSTR,
			oQ    => sR(i)
		);
	end generate;
	
	G_3 : for i in 0 to N-1 generate
		COLOR_CONVERTER : entity work.color_converter
		port map (
			i6bitColor  => sR(i)(45 downto 40),
			o24bitColor => sRCOLOR(i)
		);
	end generate;
	
	G_4 : for i in 0 to N-1 generate
		sCOMP_COMBINED(i) <= sCOMP(i);
	end generate;
	
	coder : entity work.priority_coder
	port map (
		iD => sCOMP_COMBINED,
		oQ => sCOLOR_SEL
	);
	
	mux_i : entity work.mux
	generic map (
		N     => N,
		log2N => log2N
	)
	port map (
		iD   => sRCOLOR,
		iSEL => sCOLOR_SEL,
		oQ   => o_pix_rgb
	);
end Behavioral;