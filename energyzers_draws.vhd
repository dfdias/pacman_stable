library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity energyzers_draws is
	port(
		map_x      :  in MAP_COORD_X_t;
		map_y      :  in MAP_COORD_Y_t;
		ram_x      : out MAP_TILES_X_t;
		ram_y      : out MAP_TILES_Y_t;
		ram_value  :  in ENERGYZER_TYPE_t;
		ARGB       : out VGA_ARGB_t
	);
end energyzers_draws;

architecture struct of energyzers_draws is
	signal s_stx, s_sty  :integer range 0 to 8-1;

begin

	ram_x <= map_x  /  8;
	ram_y <= map_y  /  8;
	s_stx <= map_x rem 8;
	s_sty <= map_y rem 8;

	textures: entity work.energyzers_tex_rom(RTL)
	port map(
		texture_id => ram_value,
		x          => s_stx,
		y          => s_sty,
		ARGB       => ARGB
	);

end struct;
