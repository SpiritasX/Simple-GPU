library ieee;
use ieee.std_logic_1164.all;

library work;

entity gpu_top is
	Port (
		iCLK : in std_logic;
		inRST : in std_logic;
		iLOAD : in std_logic_vector(7 downto 0);
		iINSTR : in std_logic_vector(47 downto 0);
	);
end gpu_top;

architecture Behavioral of gpu_top
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
	
--	mux_i : entity work.mux
--	port map (
--		iD => sR(
--		iD => sR(
--		iD => sR(
--		iD => sR(
--		iD => sR(
--		iD => sR(
--		iD => sR(
--		iD => sR(
--	);
--	
--	
--	mux_boje : entity work.mux_boje
--	port map (
--		iD0  => "00000000",
--		iD1  => "01010101",
--		iD2  => "10101010",
--		iD3  => "11111111",
--		iSEL => sSEL,
--		oQ   => sQ0
--	);
-- mux_boje : entity work.mux_boje
--	port map (
--		iD0  => "00000000",
--		iD1  => "01010101",
--		iD2  => "10101010",
--		iD3  => "11111111",
--		iSEL => sSEL,
--		oQ   => sQ0
--	);
-- mux_boje : entity work.mux_boje
--	port map (
--		iD0  => "00000000",
--		iD1  => "01010101",
--		iD2  => "10101010",
--		iD3  => "11111111",
--		iSEL => sSEL,
--		oQ   => sQ0
--	);
end Behavioral;