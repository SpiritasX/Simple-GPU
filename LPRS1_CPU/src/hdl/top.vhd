
----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2011/2012,2021
--
-- Computer system top level
--
-- authors:
-- Ivan Kastelan (ivan.kastelan@rt-rk.com)
-- Milos Subotic (milos.subotic@uns.ac.rs)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;

entity top is
	generic(
		-- Default frequency used in synthesis.
		constant CLK_FREQ         : positive := 12000000;
		constant CNT_BITS_COMPENS : integer  := 0
	);
	port(
		iCLK       : in  std_logic;
		inRST      : in  std_logic;
		oLED       : out std_logic_vector(15 downto 0);
		
		iGPU_RD    : in  std_logic_vector(15 downto 0);
		oGPU_WE    : out std_logic;
		oBUS_A     : out std_logic_vector( 7 downto 0);
		oBUS_WD    : out std_logic_vector(15 downto 0)
	);
end entity top;


architecture arch of top is

	signal sINSTR : std_logic_vector(14 downto 0);
	signal sPC     : std_logic_vector(15 downto 0);
	
	signal sBUS_A  : std_logic_vector(15 downto 0);
	
	signal sBUS_RD : std_logic_vector(15 downto 0);
	signal sMEM_RD : std_logic_vector(15 downto 0);
	
	signal sBUS_WD : std_logic_vector(15 downto 0);
	
	signal sBUS_WE : std_logic;
	signal sMEM_WE : std_logic;


begin

	cpu_top_i: entity work.cpu_top
	port map(
		iCLK    => iCLK,
		inRST   => inRST,
		oPC     => sPC,
		iINSTR  => sINSTR,
		oADDR   => sBUS_A,
		oDATA   => sBUS_WD,
		oMEM_WE => sBUS_WE,
		iDATA   => sBUS_RD,
		oLED    => oLED
	);

	i_instr_rom: entity work.instr_rom
	port map(
		iA => sPC,
		oQ => sINSTR
	);

	i_data_ram: entity work.data_ram
	port map(
		iCLK  => iCLK,
		inRST => inRST,
		iA    => sBUS_A(7 downto 0),
		iD    => sBUS_WD,
		iWE   => sMEM_WE,
		oQ    => sMEM_RD
	);
	
	-- Data Write Enable demux.
	process(sBUS_A, sBUS_WE)
	begin
		sMEM_WE <= '0';
		oGPU_WE <= '0';
		case sBUS_A(9 downto 8) is
			when "00" =>
				sMEM_WE <= sBUS_WE;
			when "11" =>
				oGPU_WE <= sBUS_WE;
			when others =>
		end case;
	end process;
	-- Data Read mux.
	process(sBUS_A, sMEM_RD, iGPU_RD)
	begin
		case sBUS_A(9 downto 8) is
			when "00" =>
				sBUS_RD <= sMEM_RD;
			when "11" =>
				sBUS_RD <= iGPU_RD;
			when others =>
				sBUS_RD <= x"baba";
		end case;
	end process;

	oBUS_A  <= sBUS_A( 7 downto 0);
	oBUS_WD <= sBUS_WD;
	
end architecture;
