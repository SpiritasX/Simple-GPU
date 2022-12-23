
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
	
	
	
	signal sR0 : std_logic_vector(47 downto 0);
	signal sR1 : std_logic_vector(47 downto 0);
	signal sR2 : std_logic_vector(47 downto 0);
	signal sR3 : std_logic_vector(47 downto 0);
	signal sR4 : std_logic_vector(47 downto 0);
	signal sR5 : std_logic_vector(47 downto 0);
	signal sR6 : std_logic_vector(47 downto 0);
	signal sR7 : std_logic_vector(47 downto 0);
	
	signal sDATA0 : std_logic_vector(47 downto 0);
	signal sDATA1 : std_logic_vector(47 downto 0);
	signal sDATA2 : std_logic_vector(47 downto 0);
	signal sDATA3 : std_logic_vector(47 downto 0);
	signal sDATA4 : std_logic_vector(47 downto 0);
	signal sDATA5 : std_logic_vector(47 downto 0);
	signal sDATA6 : std_logic_vector(47 downto 0);
	signal sDATA7 : std_logic_vector(47 downto 0);
	
	signal sCOMP0 : std_logic;
	signal sCOMP1 : std_logic;
	signal sCOMP2 : std_logic;
	signal sCOMP3 : std_logic;
	signal sCOMP4 : std_logic;
	signal sCOMP5 : std_logic;
	signal sCOMP6 : std_logic;
	signal sCOMP7 : std_logic;
	
	signal sCOMP  : std_logic_vector(7 downto 0);
	
	signal sPC    : std_logic_vector(2 downto 0);
	
	
	signal sR0FULL : std_logic_vector(7 downto 0);
	signal sG0FULL : std_logic_vector(7 downto 0);
	signal sB0FULL : std_logic_vector(7 downto 0);
	signal sR1FULL : std_logic_vector(7 downto 0);
	signal sG1FULL : std_logic_vector(7 downto 0);
	signal sB1FULL : std_logic_vector(7 downto 0);
	signal sR2FULL : std_logic_vector(7 downto 0);
	signal sG2FULL : std_logic_vector(7 downto 0);
	signal sB2FULL : std_logic_vector(7 downto 0);
	signal sR3FULL : std_logic_vector(7 downto 0);
	signal sG3FULL : std_logic_vector(7 downto 0);
	signal sB3FULL : std_logic_vector(7 downto 0);
	signal sR4FULL : std_logic_vector(7 downto 0);
	signal sG4FULL : std_logic_vector(7 downto 0);
	signal sB4FULL : std_logic_vector(7 downto 0);
	signal sR5FULL : std_logic_vector(7 downto 0);
	signal sG5FULL : std_logic_vector(7 downto 0);
	signal sB5FULL : std_logic_vector(7 downto 0);
	signal sR6FULL : std_logic_vector(7 downto 0);
	signal sG6FULL : std_logic_vector(7 downto 0);
	signal sB6FULL : std_logic_vector(7 downto 0);
	signal sR7FULL : std_logic_vector(7 downto 0);
	signal sG7FULL : std_logic_vector(7 downto 0);
	signal sB7FULL : std_logic_vector(7 downto 0);
	
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

	process (i_clk, in_rst)
	begin
		if (in_rst = '0') then
			sR0 <= (others => '0');
		elsif (rising_edge(i_clk)) then
			sR0 <= sDATA0;
		end if;
	end process;
	
	process (i_clk, in_rst)
	begin
		if (in_rst = '0') then
			sR1 <= (others => '0');
		elsif (rising_edge(i_clk)) then
			sR1 <= sDATA1;
		end if;
	end process;
	
	process (i_clk, in_rst)
	begin
		if (in_rst = '0') then
			sR2 <= (others => '0');
		elsif (rising_edge(i_clk)) then
			sR2 <= sDATA2;
		end if;
	end process;
	
	process (i_clk, in_rst)
	begin
		if (in_rst = '0') then
			sR3 <= (others => '0');
		elsif (rising_edge(i_clk)) then
			sR3 <= sDATA3;
		end if;
	end process;
	
	process (i_clk, in_rst)
	begin
		if (in_rst = '0') then
			sR4 <= (others => '0');
		elsif (rising_edge(i_clk)) then
			sR4 <= sDATA4;
		end if;
	end process;
	
	process (i_clk, in_rst)
	begin
		if (in_rst = '0') then
			sR5 <= (others => '0');
		elsif (rising_edge(i_clk)) then
			sR5 <= sDATA5;
		end if;
	end process;
	
	process (i_clk, in_rst)
	begin
		if (in_rst = '0') then
			sR6 <= (others => '0');
		elsif (rising_edge(i_clk)) then
			sR6 <= sDATA6;
		end if;
	end process;
	
	process (i_clk, in_rst)
	begin
		if (in_rst = '0') then
			sR7 <= (others => '0');
		elsif (rising_edge(i_clk)) then
			sR7 <= sDATA7;
		end if;
	end process;
	
	sCOMP0 <= '1' when (i_pix_x > sR0(39 downto 30) and i_pix_x < sR0(19 downto 10)) and (i_pix_y > sR0(29 downto 20) and i_pix_y < sR0(9 downto 0)) else '0';
	sCOMP1 <= '1' when (i_pix_x > sR1(39 downto 30) and i_pix_x < sR1(19 downto 10)) and (i_pix_y > sR1(29 downto 20) and i_pix_y < sR1(9 downto 0)) else '0';
	sCOMP2 <= '1' when (i_pix_x > sR2(39 downto 30) and i_pix_x < sR2(19 downto 10)) and (i_pix_y > sR2(29 downto 20) and i_pix_y < sR2(9 downto 0)) else '0';
	sCOMP3 <= '1' when (i_pix_x > sR3(39 downto 30) and i_pix_x < sR3(19 downto 10)) and (i_pix_y > sR3(29 downto 20) and i_pix_y < sR3(9 downto 0)) else '0';
	sCOMP4 <= '1' when (i_pix_x > sR4(39 downto 30) and i_pix_x < sR4(19 downto 10)) and (i_pix_y > sR4(29 downto 20) and i_pix_y < sR4(9 downto 0)) else '0';
	sCOMP5 <= '1' when (i_pix_x > sR5(39 downto 30) and i_pix_x < sR5(19 downto 10)) and (i_pix_y > sR5(29 downto 20) and i_pix_y < sR5(9 downto 0)) else '0';
	sCOMP6 <= '1' when (i_pix_x > sR6(39 downto 30) and i_pix_x < sR6(19 downto 10)) and (i_pix_y > sR6(29 downto 20) and i_pix_y < sR6(9 downto 0)) else '0';
	sCOMP7 <= '1' when (i_pix_x > sR7(39 downto 30) and i_pix_x < sR7(19 downto 10)) and (i_pix_y > sR7(29 downto 20) and i_pix_y < sR7(9 downto 0)) else '0';
	
	sCOMP <= sCOMP0 & sCOMP1 & sCOMP2 & sCOMP3 & sCOMP4 & sCOMP5 & sCOMP6 & sCOMP7;
	
	sPC <= "000" when sCOMP(7) = '1' else
			 "001" when sCOMP(6) = '1' else
			 "010" when sCOMP(5) = '1' else
			 "011" when sCOMP(4) = '1' else
			 "100" when sCOMP(3) = '1' else
			 "101" when sCOMP(2) = '1' else
			 "110" when sCOMP(1) = '1' else
			 "111";									-- TODO dodati 9. registar koji je uvek crna boja??
	
	with sR0(45 downto 44) select sR0FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR0(43 downto 42) select sG0FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR0(41 downto 40) select sB0FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR1(45 downto 44) select sR1FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR1(43 downto 42) select sG1FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR1(41 downto 40) select sB1FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR2(45 downto 44) select sR2FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR2(43 downto 42) select sG2FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR2(41 downto 40) select sB2FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR3(45 downto 44) select sR3FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR3(43 downto 42) select sG3FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR3(41 downto 40) select sB3FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
	
	with sR4(45 downto 44) select sR4FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR4(43 downto 42) select sG4FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR4(41 downto 40) select sB4FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR5(45 downto 44) select sR5FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR5(43 downto 42) select sG5FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR5(41 downto 40) select sB5FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR6(45 downto 44) select sR6FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR6(43 downto 42) select sG6FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR6(41 downto 40) select sB6FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR7(45 downto 44) select sR7FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR7(43 downto 42) select sG7FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
		
	with sR7(41 downto 40) select sB7FULL <=
		"00000000" when "00",
		"01010101" when "01",
		"10101010" when "10",
		"11111111" when others;
	
	with sPC select o_pix_rgb <=
		sB0FULL & sG0FULL & sR0FULL when "000",
		sB1FULL & sG1FULL & sR1FULL when "001",
		sB2FULL & sG2FULL & sR2FULL when "010",
		sB3FULL & sG3FULL & sR3FULL when "011",
		sB4FULL & sG4FULL & sR4FULL when "100",
		sB5FULL & sG5FULL & sR5FULL when "101",
		sB6FULL & sG6FULL & sR6FULL when "110",
		sB7FULL & sG7FULL & sR7FULL when others;
	
--	o_pix_rgb <=
--		sBFULL & sGFULL & sRFULL when ((i_pix_x > sX1 and i_pix_x < sX2) and (i_pix_y > sY1 and i_pix_y < sY2)) else
--	   x"000000";
	
--	o_pix_rgb <= 
--		x"0000ff" when i_pix_x < 100 else
--		x"00ff00" when i_pix_x < 200 else
--		x"ff0000" when i_pix_x < 300 else
--		i_cam_rgb;
	
--	o_pix_rgb <= x"0000ff" when (i_pix_x > 100 and i_pix_x < 300) and (i_pix_y > 100 and i_pix_y < 300) else x"000000";
	
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
