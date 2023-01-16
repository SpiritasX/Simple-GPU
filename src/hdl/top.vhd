
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
		iCLK         : in  std_logic;
		inRST        : in  std_logic;
		oLED         : out std_logic_vector(15 downto 0);
		
		op_hdmi_clk     : out std_logic;
		on_hdmi_clk     : out std_logic;
		op_hdmi_data    : out std_logic_vector(2 downto 0);
		on_hdmi_data    : out std_logic_vector(2 downto 0);
		
		o_cam_xclk      : out   std_logic;
		on_cam_rst      : out   std_logic;
		o_cam_pwdn      : out   std_logic;
		o_cam_sioc      : out   std_logic;
		io_cam_siod     : inout std_logic;
		i_cam_pclk      : in    std_logic;
		i_cam_vsync     : in    std_logic;
		i_cam_href      : in    std_logic;
		i_cam_data      : in    std_logic_vector(7 downto 0);

		-- Motors.
		o_l_mot_in1     : out std_logic;
		o_l_mot_in2     : out std_logic;
		o_r_mot_in1     : out std_logic;
		o_r_mot_in2     : out std_logic;
		
		-- UART.
		o_uart_tx       : out std_logic;
		o_uart_rx       : in  std_logic
	);
end entity top;


architecture arch of top is

	signal sINSTR : std_logic_vector(14 downto 0);
	signal sPC     : std_logic_vector(15 downto 0);
	
	signal sBUS_A  : std_logic_vector(15 downto 0);
	
	signal sBUS_RD : std_logic_vector(15 downto 0);
	signal sMEM_RD : std_logic_vector(15 downto 0);
	signal sGPU_RD : std_logic_vector(15 downto 0);
	
	signal sBUS_WD : std_logic_vector(15 downto 0);
	
	signal sBUS_WE : std_logic;
	signal sMEM_WE : std_logic;
	signal sGPU_WE : std_logic;


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
	
	i_gpu: entity work.lprs2_hdmi_cam_automotive_uart_led
	generic map (
		CLK_FREQ => CLK_FREQ
	)
	port map (
		i_clk           => iCLK,
		in_rst          => inRST,
		op_hdmi_clk     => op_hdmi_clk,
		on_hdmi_clk     => on_hdmi_clk,
		op_hdmi_data    => op_hdmi_data,
		on_hdmi_data    => on_hdmi_data,
		o_cam_xclk      => o_cam_xclk,
		on_cam_rst      => on_cam_rst,
		o_cam_pwdn      => o_cam_pwdn,
		o_cam_sioc      => o_cam_sioc,
		io_cam_siod     => io_cam_siod,
		i_cam_pclk      => i_cam_pclk,
		i_cam_vsync     => i_cam_vsync,
		i_cam_href      => i_cam_href,
		i_cam_data      => i_cam_data,
		o_l_mot_in1     => o_l_mot_in1,
		o_l_mot_in2     => o_l_mot_in2,
		o_r_mot_in1     => o_r_mot_in1,
		o_r_mot_in2     => o_r_mot_in2,
		o_uart_tx       => o_uart_tx,
		o_uart_rx       => o_uart_rx,
		o_led           => open,
		iBUS_A          => sBUS_A(7 downto 0),
		oBUS_RD         => sGPU_RD,
		iBUS_WE         => sGPU_WE,
		iBUS_WD         => sBUS_WD
	);
	
	-- Data Write Enable demux.
	process(sBUS_A, sBUS_WE)
	begin
		sMEM_WE <= '0';
		sGPU_WE <= '0';
		case sBUS_A(9 downto 8) is
			when "00" =>
				sMEM_WE <= sBUS_WE;
			when "11" =>
				sGPU_WE <= sBUS_WE;
			when others =>
		end case;
	end process;
	-- Data Read mux.
	process(sBUS_A, sMEM_RD, sGPU_RD)
	begin
		case sBUS_A(9 downto 8) is
			when "00" =>
				sBUS_RD <= sMEM_RD;
			when "11" =>
				sBUS_RD <= sGPU_RD;
			when others =>
				sBUS_RD <= x"baba";
		end case;
	end process;

end architecture;
