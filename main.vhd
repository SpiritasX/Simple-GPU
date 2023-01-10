
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.gpu_types.all;
use work.automotive_types.all;

entity main is
	port (
		i_clk           : in    std_logic; -- 12 MHz
		i_gpu_clk       : in    std_logic; -- 100 MHz
		in_rst          : in    std_logic;
		
		i_cam_rgb       : in    t_rgb888;
		i_pix_phase     : in    t_pix_phase;
		i_pix_x         : in    t_pix_x;
		i_pix_y         : in    t_pix_y;
		o_pix_rgb       : out   t_rgb888;
		
		o_chassis       : out   t_chassis;
		
		-- UART.
		i_uart_rx_d  : in  std_logic_vector(7 downto 0);
		i_uart_rx_dv : in  std_logic;
		o_uart_tx_d  : out std_logic_vector(7 downto 0);
		o_uart_tx_dv : out std_logic;
		
		o_led        : out std_logic_vector(7 downto 0)
	);
end entity main;

architecture arch of main is
	
	
	signal chassis_cmd : std_logic_vector(5 downto 0);
	signal chassis_speed : std_logic_vector(1 downto 0);
	signal chassis_cmd_decoded : t_chassis;
	signal chassis_pwm : std_logic;
	signal chassis_cmd_idle : t_chassis := (CM_IDLE, CT_STRAIGHT, CTH_FLOAT);
	
	-- ~12.5Hz, yo work on lowest speed, bcs need on time at least 10ms.
	constant PWM_CNT_BITS : natural := 20;
	signal pwm_cnt : std_logic_vector(PWM_CNT_BITS-1 downto 0);
	signal pwm_cnt_upper : std_logic_vector(2 downto 0);
	signal pwm_cnt_threshold : std_logic_vector(3 downto 0);
	
	signal sDATA0 : std_logic_vector(47 downto 0);
	signal sDATA1 : std_logic_vector(47 downto 0);
	signal sDATA2 : std_logic_vector(47 downto 0);
	signal sDATA3 : std_logic_vector(47 downto 0);
	signal sDATA4 : std_logic_vector(47 downto 0);
	signal sDATA5 : std_logic_vector(47 downto 0);
	signal sDATA6 : std_logic_vector(47 downto 0);
	signal sDATA7 : std_logic_vector(47 downto 0);
	
	
	signal sCNT   : std_logic_vector(23 downto 0);
	signal sCNT_S : std_logic_vector(1 downto 0);
	signal sCNT_S2 : std_logic_vector(1 downto 0);
	signal sTC    : std_logic;
	signal sTC2    : std_logic;
	signal sLOAD  : std_logic_vector(7 downto 0);
	signal sDATA  : std_logic_vector(47 downto 0);
	
-- | o o | r r | g g | b b | x1 x1 x1 x1 x1 x1 x1 x1 x1 x1 | y1 y1 y1 y1 y1 y1 y1 y1 y1 y1 | x2 x2 x2 x2 x2 x2 x2 x2 x2 x2 | y2 y2 y2 y2 y2 y2 y2 y2 y2 y2 |
begin

	sDATA0 <= "01"&"110000"&"0110000000"&"0100000000"&"0110100000"&"0100100000";
	sDATA1 <= "00"&"000000"&"0000000000"&"0000000000"&"0000000000"&"0000000000";
	sDATA2 <= "01"&"001100"&"0000011000"&"0000001000"&"0001001000"&"0011000000";
	sDATA3 <= "00"&"000000"&"0000000000"&"0000000000"&"0000000000"&"0000000000";
	sDATA4 <= "00"&"000000"&"0000000000"&"0000000000"&"0000000000"&"0000000000";
	sDATA5 <= "00"&"000000"&"0000000000"&"0000000000"&"0000000000"&"0000000000";
	sDATA6 <= "01"&"000011"&"0001000010"&"0000110000"&"0100110000"&"0010100000";
	sDATA7 <= "00"&"000000"&"0000000000"&"0000000000"&"0000000000"&"0000000000";
	
--	process (i_clk, in_rst)
--	begin
--		if (in_rst = '0') then
--			sCNT <= (others => '0');
--		elsif (rising_edge(i_clk)) then
--			if (sCNT = 12000000 - 1) then
--				sCNT <= (others => '0');
--			else
--				sCNT <= sCNT + 1;
--			end if;
--		end if;
--	end process;
--	
--	sTC <= '1' when sCNT = 12000000 - 1 else '0';
--	
--	process (i_clk, in_rst)
--	begin
--		if (in_rst = '0') then
--			sCNT_S <= (others => '0');
--		elsif (rising_edge(i_clk)) then
--			if (sTC = '1') then
--				if (sCNT_S = 10) then
--					sCNT_S <= (others => '0');
--				else
--					sCNT_S <= sCNT_S + 1;
--				end if;
--			end if;
--		end if;
--	end process;
--	
--	sTC2 <= '1' when sCNT_S = 2 else '0';
--	
--	process (i_clk, in_rst)
--	begin
--		if (in_rst = '0') then
--			sCNT_S2 <= (others => '0');
--		elsif (rising_edge(i_clk)) then
--			if (sTC2 = '1' and sTC = '1') then
--				if (sCNT_S2 = 3) then
--					sCNT_S2 <= (others => '0');
--				else
--					sCNT_S2 <= sCNT_S2 + 1;
--				end if;
--			end if;
--		end if;
--	end process;
--	
--	sLOAD <= "10000000" when sCNT_S2 = 0 else
--				"01000000" when sCNT_S2 = 1 else
--				"00100000" when sCNT_S2 = 2 else
--				"00010000";
--	
--	sDATA <= sDATA4 when sCNT_S2 = 0 else
--				sDATA2 when sCNT_S2 = 1 else
--				sDATA6 when sCNT_S2 = 2 else
--				sDATA0;
	
	i_gpu : entity work.gpu
	port map (
		iCLK      => i_clk,
		iGPU_CLK  => i_gpu_clk,
		inRST     => in_rst,
		iADDR     => "00000000",
		iDATA     => "0000000000000000",
		i_pix_x   => i_pix_x,
		i_pix_y   => i_pix_y,
		o_pix_rgb => o_pix_rgb
	);

	-- Loop it back.
	o_uart_tx_d <= i_uart_rx_d;
	o_uart_tx_dv <= i_uart_rx_dv;
	
	o_led <= i_uart_rx_d;
	
	chassis_cmd <= i_uart_rx_d(5 downto 0);
	chassis_speed <= i_uart_rx_d(7 downto 6);
	-- For testing.
	--chassis_cmd <= "000010";
	--chassis_speed <= "00";
	
	
	chassis_cmd_decoded <= conv_t_chassis(chassis_cmd);
	
	
	process(i_clk, in_rst)
	begin
		if in_rst = '0' then
			pwm_cnt <= (others => '0');
		elsif rising_edge(i_clk) then
			pwm_cnt <= pwm_cnt + 1;
		end if;
	end process;
	pwm_cnt_upper <= pwm_cnt(pwm_cnt'high downto pwm_cnt'high-2);
	with chassis_speed select pwm_cnt_threshold <=
		"0001" when "00",
		"0010" when "01",
		"0100" when "10",
		"1000" when others;
	
	chassis_pwm <= '1' when pwm_cnt_upper < pwm_cnt_threshold else '0';
	
	
	with chassis_pwm select o_chassis <=
		chassis_cmd_decoded when '1',
		chassis_cmd_idle when others;
	
end architecture arch;
