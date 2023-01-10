library ieee;
use ieee.std_logic_1164.all;

library work;
use work.gpu_types.all;
use work.gpu_top_types.all;

entity gpu is
	Port (
		iCLK      : in std_logic;
		iGPU_CLK  : in std_logic;
		inRST     : in std_logic;
		iADDR     : in std_logic_vector( 7 downto 0);
		iDATA     : in std_logic_vector(15 downto 0);
		i_pix_x   : in t_pix_x;
		i_pix_y   : in t_pix_y;
		o_pix_rgb :out t_rgb888
	);
end entity;

architecture Behavioral of gpu is
	signal sR     : t_register_array;
	signal sINSTR : std_logic_vector(47 downto 0);
begin
	i_bus_interface : entity work.bus_interface
	port map (
		iCLK   => iCLK,
		inRST  => inRST,
		iADDR  => iADDR,
		iDATA  => iDATA,
		oINSTR => sINSTR
	);

	i_ram : entity work.gpu_ram
	port map (
		iCLK   => iCLK,
		inRST  => inRST,
		iADDR  => "00000000",
		iINSTR => sINSTR,
		oQ     => sR
	);
	
	i_gpu_top : entity work.gpu_top
	port map (
		iCLK      => iGPU_CLK,
		inRST     => inRST,
		iR        => sR,
		i_pix_x   => i_pix_x,
		i_pix_y   => i_pix_y,
		o_pix_rgb => o_pix_rgb
	);
end architecture;