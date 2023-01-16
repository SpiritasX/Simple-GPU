library ieee;
use ieee.std_logic_1164.all;

library work;
use work.gpu_top_types.all;

entity bus_interface is
	Generic (
		constant CLK_FREQ : integer
	);
	Port (
		iCLK    : in std_logic;
		inRST   : in std_logic;
		iADDR   : in std_logic_vector( 7 downto 0);
		iDATA   : in std_logic_vector(15 downto 0);
		oINSTR  :out std_logic_vector(47 downto 0);
		oADDR   :out std_logic_vector(15 downto 0);
		oBUS_RD :out std_logic_vector(15 downto 0);
		iEN     : in std_logic;
		oMEM_EN :out std_logic
	);
end entity;

architecture Behavioral of bus_interface is
	signal sSTART : std_logic;
	signal sEND   : std_logic;
	signal sINSTR : std_logic_vector(47 downto 0);
	
	signal half_sec_en : std_logic;
	signal sFRAME_SYNC : std_logic_vector(0 downto 0);
begin
	
	count_ms: entity work.counter
	generic map(
		CNT_MOD  => CLK_FREQ/1000,
		CNT_BITS => 22
	)
	port map(
		i_clk  => iCLK,
		in_rst => inRST,
		
		i_rst  => '0',
		i_en   => '1',
		o_cnt  => open,
		o_tc   => half_sec_en
	);
	
	count_half_secs: entity work.counter
	generic map(
		CNT_MOD  => 2,
		CNT_BITS => 1
	)
	port map(
		i_clk  => iCLK,
		in_rst => inRST,
		
		i_rst  => '0',
		i_en   => half_sec_en,
		o_cnt  => sFRAME_SYNC,
		o_tc   => open
	);

	process (iCLK, inRST)
	begin
		if (inRST = '0') then
			sEND <= '0';
		elsif (rising_edge(iCLK)) then
			if (iEN = '1') then
				if (iADDR = "00000110") then
					sEND <= '1';
				else
					sEND <= '0';
				end if;
			end if;
		end if;
	end process;

	process (iCLK, inRST)
	begin
		if (inRST = '0') then
			sINSTR <= (others => '0');
		elsif (rising_edge(iCLK)) then
			if (iEN = '1') then
				case iADDR is
					when "00000000" =>
						sINSTR <= (others => '0');
					when "00000001" =>
						sINSTR <= sINSTR(41 downto 0) & iDATA(5 downto 0);
					when "00000010" =>
						sINSTR <= sINSTR(37 downto 0) & iDATA(9 downto 0);
					when "00000011" =>
						sINSTR <= sINSTR(37 downto 0) & iDATA(9 downto 0);
					when "00000100" =>
						sINSTR <= sINSTR(37 downto 0) & iDATA(9 downto 0);
					when "00000101" =>
						sINSTR <= sINSTR(37 downto 0) & iDATA(9 downto 0);
					when others =>
				end case;
			end if;
		end if;
	end process;

	process (sEND)
	begin
		oMEM_EN <= '0';
		oADDR   <= (others => '0');
		oINSTR  <= (others => '0');
		
		if (sEND = '1') then
			oMEM_EN <= '1';
			oADDR   <= iDATA;
			oINSTR  <= sINSTR;
		end if;
	end process;
	
	process(iADDR, sFRAME_SYNC)
	begin
		if iADDR = "01000000" then
			oBUS_RD <= "000000000000000" & sFRAME_SYNC;
		else
			oBUS_RD <= x"deda";
		end if;
	end process;
	
end architecture;