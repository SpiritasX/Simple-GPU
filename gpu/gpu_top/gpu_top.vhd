library ieee;
use ieee.std_logic_1164.all;

library work;
use work.gpu_types.all;

entity gpu_top is
	Port (
		iCLK      : in std_logic;
		inRST     : in std_logic;
		iLOAD     : in std_logic_vector(7 downto 0);
		iINSTR    : in std_logic_vector(47 downto 0);
		i_pix_x   : in t_pix_x;
		i_pix_y   : in t_pix_x;
		o_pix_rgb :out t_rgb888
	);
end gpu_top;

architecture Behavioral of gpu_top is
	signal sCOMP0 : std_logic;
	signal sCOMP1 : std_logic;
	signal sCOMP2 : std_logic;
	signal sCOMP3 : std_logic;
	signal sCOMP4 : std_logic;
	signal sCOMP5 : std_logic;
	signal sCOMP6 : std_logic;
	signal sCOMP7 : std_logic;
	
	signal sR0 : std_logic_vector(47 downto 0);
	signal sR1 : std_logic_vector(47 downto 0);
	signal sR2 : std_logic_vector(47 downto 0);
	signal sR3 : std_logic_vector(47 downto 0);
	signal sR4 : std_logic_vector(47 downto 0);
	signal sR5 : std_logic_vector(47 downto 0);
	signal sR6 : std_logic_vector(47 downto 0);
	signal sR7 : std_logic_vector(47 downto 0);
	
	signal sR0COLOR : std_logic_vector(23 downto 0);
	signal sR1COLOR : std_logic_vector(23 downto 0);
	signal sR2COLOR : std_logic_vector(23 downto 0);
	signal sR3COLOR : std_logic_vector(23 downto 0);
	signal sR4COLOR : std_logic_vector(23 downto 0);
	signal sR5COLOR : std_logic_vector(23 downto 0);
	signal sR6COLOR : std_logic_vector(23 downto 0);
	signal sR7COLOR : std_logic_vector(23 downto 0);
	
	signal sCOLOR_SEL : std_logic_vector(2 downto 0);
begin
	COMP0 : entity work.comparator
	port map (
		iA => sR0(39 downto 0),
		iB => i_pix_x,
		iC => i_pix_y,
		oQ => sCOMP0
	);
	
	COMP1 : entity work.comparator
	port map (
		iA => sR1(39 downto 0),
		iB => i_pix_x,
		iC => i_pix_y,
		oQ => sCOMP1
	);
	
	COMP2 : entity work.comparator
	port map (
		iA => sR2(39 downto 0),
		iB => i_pix_x,
		iC => i_pix_y,
		oQ => sCOMP2
	);
	
	COMP3 : entity work.comparator
	port map (
		iA => sR3(39 downto 0),
		iB => i_pix_x,
		iC => i_pix_y,
		oQ => sCOMP3
	);
	
	COMP4 : entity work.comparator
	port map (
		iA => sR4(39 downto 0),
		iB => i_pix_x,
		iC => i_pix_y,
		oQ => sCOMP4
	);
	
	COMP5 : entity work.comparator
	port map (
		iA => sR5(39 downto 0),
		iB => i_pix_x,
		iC => i_pix_y,
		oQ => sCOMP5
	);
	
	COMP6 : entity work.comparator
	port map (
		iA => sR6(39 downto 0),
		iB => i_pix_x,
		iC => i_pix_y,
		oQ => sCOMP6
	);
	
	COMP7 : entity work.comparator
	port map (
		iA => sR7(39 downto 0),
		iB => i_pix_x,
		iC => i_pix_y,
		oQ => sCOMP7
	);
	
	R0_color : entity work.color_converter
	port map (
		i6bitColor  => sR0(45 downto 40),
		o24bitColor => sR0COLOR
	);
	
	R1_color : entity work.color_converter
	port map (
		i6bitColor  => sR1(45 downto 40),
		o24bitColor => sR1COLOR
	);
	
	R2_color : entity work.color_converter
	port map (
		i6bitColor  => sR2(45 downto 40),
		o24bitColor => sR2COLOR
	);
	
	R3_color : entity work.color_converter
	port map (
		i6bitColor  => sR3(45 downto 40),
		o24bitColor => sR3COLOR
	);
	
	R4_color : entity work.color_converter
	port map (
		i6bitColor  => sR4(45 downto 40),
		o24bitColor => sR4COLOR
	);
	
	R5_color : entity work.color_converter
	port map (
		i6bitColor  => sR5(45 downto 40),
		o24bitColor => sR5COLOR
	);
	
	R6_color : entity work.color_converter
	port map (
		i6bitColor  => sR6(45 downto 40),
		o24bitColor => sR6COLOR
	);
	
	R7_color : entity work.color_converter
	port map (
		i6bitColor  => sR7(45 downto 40),
		o24bitColor => sR7COLOR
	);
	
	coder : entity work.priority_coder
	port map (
		iD => sCOMP0 & sCOMP1 & sCOMP2 & sCOMP3 & sCOMP4 & sCOMP5 & sCOMP6 & sCOMP7,
		oQ => sCOLOR_SEL
	);

	R0 : entity work.registar
	port map (
		iCLK  => iCLK,
		inRST => inRST,
		iWE   => iLOAD(0),
		iD    => iINSTR,
		oQ    => sR0
	);

	R1 : entity work.registar
	port map (
		iCLK  => iCLK,
		inRST => inRST,
		iWE   => iLOAD(1),
		iD    => iINSTR,
		oQ    => sR1
	);

	R2 : entity work.registar
	port map (
		iCLK  => iCLK,
		inRST => inRST,
		iWE   => iLOAD(2),
		iD    => iINSTR,
		oQ    => sR2
	);

	R3 : entity work.registar
	port map (
		iCLK  => iCLK,
		inRST => inRST,
		iWE   => iLOAD(3),
		iD    => iINSTR,
		oQ    => sR3
	);

	R4 : entity work.registar
	port map (
		iCLK  => iCLK,
		inRST => inRST,
		iWE   => iLOAD(4),
		iD    => iINSTR,
		oQ    => sR4
	);

	R5 : entity work.registar
	port map (
		iCLK  => iCLK,
		inRST => inRST,
		iWE   => iLOAD(5),
		iD    => iINSTR,
		oQ    => sR5
	);

	R6 : entity work.registar
	port map (
		iCLK  => iCLK,
		inRST => inRST,
		iWE   => iLOAD(6),
		iD    => iINSTR,
		oQ    => sR6
	);

	R7 : entity work.registar
	port map (
		iCLK  => iCLK,
		inRST => inRST,
		iWE   => iLOAD(7),
		iD    => iINSTR,
		oQ    => sR7
	);
	
	mux_i : entity work.mux
	port map (
		iD0  => sR0COLOR,
		iD1  => sR1COLOR,
		iD2  => sR2COLOR,
		iD3  => sR3COLOR,
		iD4  => sR4COLOR,
		iD5  => sR5COLOR,
		iD6  => sR6COLOR,
		iD7  => sR7COLOR,
		iSEL => sCOLOR_SEL,
		oQ   => o_pix_rgb
	);
end Behavioral;