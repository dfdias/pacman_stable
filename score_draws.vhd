library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity score_draws is
port(
		map_x      :  in MAP_COORD_X_t;
		map_y      :  in MAP_COORD_Y_t;
      score      :  in SCORE_t; 
		ARGB       : out VGA_ARGB_t);
end score_draws;

architecture struct of score_draws is
	signal s_tx             : integer range 0 to MAP_N_TILES_X-1;
	signal s_ty             : integer range 0 to MAP_N_TILES_Y-1;
	signal s_stx            : integer range 0 to 8-1; 
	signal s_sty            : integer range 0 to 8-1; 
	signal letter_tex_id    : integer range 0 to 10;
	signal number_tex_id    : integer range 0 to 10;
	signal s_letter_ARGB    : VGA_ARGB_t;
	signal s_number_ARGB    : VGA_ARGB_t;
begin

	s_tx  <= map_x  /  8;
	s_ty  <= map_y  /  8;
	s_stx <= map_x rem 8;
	s_sty <= map_y rem 8;

	drawing : process(s_tx, s_ty, SCORE, s_letter_ARGB, s_number_ARGB)
	begin
		letter_tex_id <= 0;
		number_tex_id <= 0;
		ARGB          <= "0000";

		if s_ty = 0 then
			if    s_tx =  4 then letter_tex_id <= 9; ARGB <= s_letter_ARGB;
			elsif s_tx =  5 then letter_tex_id <= 8; ARGB <= s_letter_ARGB;
			elsif s_tx =  9 then letter_tex_id <= 0; ARGB <= s_letter_ARGB;
			elsif s_tx = 10 then letter_tex_id <= 1; ARGB <= s_letter_ARGB;
			elsif s_tx = 11 then letter_tex_id <= 2; ARGB <= s_letter_ARGB;
			elsif s_tx = 12 then letter_tex_id <= 0; ARGB <= s_letter_ARGB;
			elsif s_tx = 14 then letter_tex_id <= 3; ARGB <= s_letter_ARGB;
			elsif s_tx = 15 then letter_tex_id <= 5; ARGB <= s_letter_ARGB;
			elsif s_tx = 16 then letter_tex_id <= 4; ARGB <= s_letter_ARGB;
			elsif s_tx = 17 then letter_tex_id <= 6; ARGB <= s_letter_ARGB;
			elsif s_tx = 18 then letter_tex_id <= 7; ARGB <= s_letter_ARGB;
			end if;
		
		elsif s_ty = 1 then
			if    s_tx = 0 then number_tex_id <= score(0); ARGB <= s_number_ARGB;
			elsif s_tx = 1 then number_tex_id <= score(1); ARGB <= s_number_ARGB;
			elsif s_tx = 2 then number_tex_id <= score(2); ARGB <= s_number_ARGB;
			elsif s_tx = 3 then number_tex_id <= score(3); ARGB <= s_number_ARGB;
			elsif s_tx = 4 then number_tex_id <= score(4); ARGB <= s_number_ARGB;
			elsif s_tx = 5 then number_tex_id <= score(5); ARGB <= s_number_ARGB;
			end if ;
		
		end if;
	end process;

	letters_rom : entity work.letters_rom(RTL)
	port map(
		texture_id => letter_tex_id,
		x          => s_stx,
		y          => s_sty,
		ARGB       => s_letter_ARGB
	);

	numbers_rom : entity work.num_rom(RTL)
	port map (
		texture_id => number_tex_id,
		x          => s_stx,
		y          => s_sty,
		ARGB       => s_number_ARGB
	);

end struct;
