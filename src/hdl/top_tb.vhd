
----------------------------------------------------------------------------------
-- Logicko projektovanje racunarskih sistema 1
-- 2011/2012,2020
-- Lab 6
--
-- Computer system top level testbench
--
-- authors:
-- Ivan Kastelan (ivan.kastelan@rt-rk.com)
-- Milos Subotic (milos.subotic@uns.ac.rs)
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity top_tb is
end top_tb;

architecture Behavior of top_tb is

	component top is
		generic(
			-- Default frequency used in synthesis.
			constant CLK_FREQ         : positive := 12000000;
			constant CNT_BITS_COMPENS : integer  := 0
		);
		port(
			iCLK            : in  std_logic;
			inRST           : in  std_logic;
			oLED            : out std_logic_vector(15 downto 0);
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
			o_l_mot_in1     : out std_logic;
			o_l_mot_in2     : out std_logic;
			o_r_mot_in1     : out std_logic;
			o_r_mot_in2     : out std_logic;
			o_uart_tx       : out std_logic;
			o_uart_rx       : in  std_logic
		);
	end component top;
	
	
	--Inputs
	signal iCLK       : std_logic := '0';
	signal inRST      : std_logic := '0';
	signal oLED       : std_logic_vector (15 downto 0);

	signal op_hdmi_clk     : std_logic;
	signal on_hdmi_clk     : std_logic;
	signal op_hdmi_data    : std_logic_vector(2 downto 0);
	signal on_hdmi_data    : std_logic_vector(2 downto 0);
	signal o_cam_xclk      : std_logic;
	signal on_cam_rst      : std_logic;
	signal o_cam_pwdn      : std_logic;
	signal o_cam_sioc      : std_logic;
	signal io_cam_siod     : std_logic;
	signal i_cam_pclk      : std_logic;
	signal i_cam_vsync     : std_logic;
	signal i_cam_href      : std_logic;
	signal i_cam_data      : std_logic_vector(7 downto 0);
	signal o_l_mot_in1     : std_logic;
	signal o_l_mot_in2     : std_logic;
	signal o_r_mot_in1     : std_logic;
	signal o_r_mot_in2     : std_logic;
	signal o_uart_tx       : std_logic;
	signal o_uart_rx       : std_logic;
	
	constant iCLK_period : time := 83.333333 ns; -- 12MHz
	constant FRAME_LEN : natural := 1600;
	
	
	subtype tRGB is std_logic_vector(2 downto 0);
	type tRGB_MATRIX is array (0 to 7, 0 to 7) of tRGB;
	-- Indeksing goes like: sRGB_MATRIX(y, x)
	signal sRGB_MATRIX : tRGB_MATRIX;
	
	file fo : text open WRITE_MODE is "STD_OUTPUT";

begin


	-- Instantiate the Unit Under Test (UUT)
	uut: top
	generic map(
		--TODO Make it round. To have change on every 1 us.
		CLK_FREQ         => 120000, -- Everything is 100x faster.
		CNT_BITS_COMPENS => 0 -- Less bits to avoid warnings.
	)
	port map(
		iCLK         => iCLK,      
		inRST        => inRST,       
		oLED         => oLED,
		op_hdmi_clk  => op_hdmi_clk,
		on_hdmi_clk  => on_hdmi_clk,
		op_hdmi_data => op_hdmi_data,
		on_hdmi_data => on_hdmi_data,
		o_cam_xclk   => o_cam_xclk, 
		on_cam_rst   => on_cam_rst, 
		o_cam_pwdn   => o_cam_pwdn, 
		o_cam_sioc   => o_cam_sioc, 
		io_cam_siod  => io_cam_siod, 
		i_cam_pclk   => i_cam_pclk,
		i_cam_vsync  => i_cam_vsync,
		i_cam_href   => i_cam_href,
		i_cam_data   => i_cam_data,
		o_l_mot_in1  => o_l_mot_in1,
		o_l_mot_in2  => o_l_mot_in2,
		o_r_mot_in1  => o_r_mot_in1,
		o_r_mot_in2  => o_r_mot_in2,
		o_uart_tx    => o_uart_tx,
		o_uart_rx    => o_uart_rx
	);


	-- Clock process definitions
	iCLK_proc: process
	begin
		iCLK <= '0';
		wait for iCLK_period/2;
		iCLK <= '1';
		wait for iCLK_period/2;
	end process;


	-- Stimulus process
	stim_proc: process
	begin
		
		inRST <= '0';
		wait for 2*iCLK_period;
		inRST <= '1';
		
		
		
		wait;
	end process;
	
end architecture;
