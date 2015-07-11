library ieee;
use ieee.std_logic_1164.all;

library work;
use work.defines.all;

entity map_draws is
	port(
		map_x    : in  MAP_COORD_X_t;
		map_y    : in  MAP_COORD_Y_t;
		map_ARGB : out VGA_ARGB_t
	);
end map_draws;

architecture behav of map_draws is
signal s_texture_id : integer range 0 to 32-1;
signal s_tx : integer range 0 to MAP_N_TILES_X - 1; 
signal s_ty : integer range 0 to MAP_N_TILES_Y - 1;
signal s_stx, s_sty: integer range 0 to 8-1;

begin
	s_tx  <= map_x /   8;
	s_ty  <= map_y /   8;
	s_stx <= map_x rem 8;
	s_sty <= map_y rem 8;

	map_textures: entity work.map_draws_rom(RTL)
	port map(
		tx         => s_tx,
		ty         => s_ty,
		texture_id => s_texture_id
	);

	textures: entity work.map_draws_textures(RTL)
	port map(
		texture_id => s_texture_id,
		x          => s_stx,
		y          => s_sty,
		ARGB       => map_ARGB
	);

end behav;