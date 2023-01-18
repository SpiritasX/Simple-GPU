
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

entity LPRS2_HDMI_Cam_Automotive_UART_LED_tb is
end LPRS2_HDMI_Cam_Automotive_UART_LED_tb;

architecture Behavior of LPRS2_HDMI_Cam_Automotive_UART_LED_tb is

	component top is
		generic(
			constant CLK_FREQ : positive := 12000000
		);
		port (
			i_clk           : in  std_logic;
			in_rst          : in  std_logic;
			
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
			o_uart_rx       : in  std_logic;
			
			o_led           : out std_logic_vector(7 downto 0)
		);
	end component top;
	
	
	signal i_clk           : std_logic;
	signal in_rst          : std_logic;
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
	signal o_led           : std_logic_vector(7 downto 0);

	constant iCLK_period : time := 83.333333 ns; -- 12MHz
	constant FRAME_LEN : natural := 1600;

begin


	-- Instantiate the Unit Under Test (UUT)
	uut: entity work.lprs2_hdmi_cam_automotive_uart_led
	generic map(
		-- Default frequency used in synthesis.
		CLK_FREQ => 120000
	)
	port map(
		i_clk           => i_clk       ,
		in_rst          => in_rst      ,
		op_hdmi_clk     => op_hdmi_clk ,
		on_hdmi_clk     => on_hdmi_clk ,
		op_hdmi_data    => op_hdmi_data,
		on_hdmi_data    => on_hdmi_data,
		o_cam_xclk      => o_cam_xclk  ,
		on_cam_rst      => on_cam_rst  ,
		o_cam_pwdn      => o_cam_pwdn  ,
		o_cam_sioc      => o_cam_sioc  ,
		io_cam_siod     => io_cam_siod ,
		i_cam_pclk      => i_cam_pclk  ,
		i_cam_vsync     => i_cam_vsync ,
		i_cam_href      => i_cam_href  ,
		i_cam_data      => i_cam_data  ,
		o_l_mot_in1     => o_l_mot_in1 ,
		o_l_mot_in2     => o_l_mot_in2 ,
		o_r_mot_in1     => o_r_mot_in1 ,
		o_r_mot_in2     => o_r_mot_in2 ,
		o_uart_tx       => o_uart_tx   ,
		o_uart_rx       => o_uart_rx   ,
		o_led           => o_led       
	);


	-- Clock process definitions
	iCLK_proc: process
	begin
		i_clk <= '0';
		wait for iCLK_period/2;
		i_clk <= '1';
		wait for iCLK_period/2;
	end process;


	-- Stimulus process
	stim_proc: process
	begin
		
		in_rst <= '0';
		wait for 2*iCLK_period;
		in_rst <= '1';
		
		
		
		wait;
	end process;

end architecture;
