library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity vga_draws is
	port(
		vga_x :  in integer range 0 to VGA_WIDTH  - 1;
		vga_y :  in integer range 0 to VGA_HEIGHT - 1;
		pac_x :  in MAP_COORD_X_t;
		pac_y :  in MAP_COORD_Y_t;
		ram_x :  out MAP_TILES_X_t;
		ram_y :  out MAP_TILES_Y_t;
		ram_value :in ENERGYZER_TYPE_t;
		pac_dir                                              : in  PAC_DIR_t;
      pac_sprite_id                                        : in integer range 1 to 8-1;
		score :  in SCORE_t;
		RGB   : out VGA_RGB_t
	);
end vga_draws;

architecture behav of vga_draws is
signal s_map_x           : MAP_COORD_X_t;
signal s_map_y           : MAP_COORD_Y_t;
signal s_in_map          : std_logic;
signal s_map_ARGB        : VGA_ARGB_t;
signal s_pac_ARGB        : VGA_ARGB_t;
signal s_scores_ARGB     : VGA_ARGB_t;
signal s_energyzers_ARGB : VGA_ARGB_t;


begin

	tiles_calc:	process (vga_x, vga_y)
	begin
		s_map_x  <= 0;
		s_map_y  <= 0;
		s_in_map <= '0';
		
		if ( vga_x >= MAP_VGA_OFFSET_X and vga_x <= MAP_VGA_OFFSET_X + MAP_VGA_WIDTH  - 1 ) then
		if ( vga_y >= MAP_VGA_OFFSET_Y and vga_y <= MAP_VGA_OFFSET_Y + MAP_VGA_HEIGHT - 1 ) then
			s_map_x  <= (vga_x - MAP_VGA_OFFSET_X)/2;
			s_map_y  <= (vga_y - MAP_VGA_OFFSET_Y)/2;
			s_in_map <= '1';
		end if;
		end if;
	end process;

	map_draws: entity work.map_draws(behav)
	port map(
		map_x    => s_map_x,
		map_y    => s_map_y,
		map_ARGB => s_map_ARGB
	);

	pac_draws: entity work.pac_draws(struct)
	port map(
		map_x      => s_map_x,
		map_y      => s_map_y,
		pac_x      =>   pac_x,
		pac_y      =>   pac_y,
		texture_id => 0,
		pac_dir    => pac_dir,
		ARGB       => s_pac_ARGB
	);

	score_draws : entity work.score_draws(struct)
	port map(
		map_x => s_map_x,
		map_y => s_map_y,
		score => score,
		ARGB  => s_scores_ARGB
	);

	energyzers_draws : entity work.energyzers_draws(struct)
	port map(
		map_x     => s_map_x,
		map_y     => s_map_y,
		ram_x     => ram_x,
		ram_y     => ram_y,
		ram_value => ram_value,
		ARGB      => s_energyzers_ARGB
	); 

	process (s_in_map, s_pac_ARGB, s_map_ARGB, s_scores_ARGB, s_energyzers_ARGB)
	begin
		RGB <= "000";
		
		if ( s_in_map = '1' ) then
			if    ( s_pac_ARGB(3)        = '1' ) then
				RGB <= s_pac_ARGB(2 downto 0);
			
			elsif ( s_energyzers_ARGB(3) = '1' ) then
				RGB <= s_energyzers_ARGB(2 downto 0);
			
			elsif ( s_map_ARGB(3)        = '1' ) then
				RGB <= s_map_ARGB(2 downto 0);
			
			elsif ( s_scores_ARGB(3)     = '1' ) then
				RGB <= s_scores_ARGB(2 downto 0);
			
			end if;
		end if;
		
	end process;

end behav;
