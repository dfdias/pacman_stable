library ieee;
use ieee.std_logic_1164.all;

library work;
use work.defines.all;

entity map_draws_rom is
	port(
		tx         : in  integer range 0 to MAP_N_TILES_X-1;
		ty         : in  integer range 0 to MAP_N_TILES_Y-1;
		texture_id : out integer range 0 to 32-1
	);
end map_draws_rom;

architecture RTL of map_draws_rom is
	subtype t is integer range 0 to 32-1;
	type st is array (0 to MAP_N_TILES_X*MAP_N_TILES_Y-1) of t;
	constant c_memory : st := (
	--                                 1                             2
	--   0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7
		31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31, --  0
		31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31, --  1
		31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31, --  2
		 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 9,10, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, --  3
		 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,17,17, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 8, --  4
		 5, 6,12,16,16,13, 6,12,16,16,16,13, 6,17,17, 6,12,16,16,16,13, 6,12,16,16,13, 6, 8, --  5
		 5, 6,17, 6, 6,17, 6,17, 6, 6, 6,17, 6,17,17, 6,17, 6, 6, 6,17, 6,17, 6, 6,17, 6, 8,
		 5, 6,15,16,16,14, 6,15,16,16,16,14, 6,15,14, 6,15,16,16,16,14, 6,15,16,16,14, 6, 8,
		 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 8,
		 5, 6,12,16,16,13, 6,12,13, 6,12,16,16,16,16,16,16,13, 6,12,13, 6,12,16,16,13, 6, 8,
		 5, 6,15,16,16,14, 6,17,17, 6,15,16,16,13,12,16,16,14, 6,17,17, 6,15,16,16,14, 6, 8, -- 10
		 5, 6, 6, 6, 6, 6, 6,17,17, 6, 6, 6, 6,17,17, 6, 6, 6, 6,17,17, 6, 6, 6, 6, 6, 6, 8,
		 2, 7, 7, 7, 7,24, 6,17,15,16,16,13, 6,17,17, 6,12,16,16,14,17, 6,23, 7, 7, 7, 7, 3,
		 6, 6, 6, 6, 6,11, 6,17,12,16,16,14, 6,15,14, 6,15,16,16,13,17, 6, 8, 6, 6, 6, 6, 6,
		 6, 6, 6, 6, 6,11, 6,17,17, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,17,17, 6, 8, 6, 6, 6, 6, 6,
		 6, 6, 6, 6, 6,11, 6,17,17, 6,18, 7, 7,19,19, 7, 7,20, 6,17,17, 6, 8, 6, 6, 6, 6, 6, -- 15
		 4, 4, 4, 4, 4,25, 6,15,14, 6, 8, 6, 6, 6, 6, 6, 6,11, 6,15,14, 6,26, 4, 4, 4, 4, 4,
		 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 8, 6, 6, 6, 6, 6, 6,11, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
		 7, 7, 7, 7, 7,24, 6,12,13, 6, 8, 6, 6, 6, 6, 6, 6,11, 6,12,13, 6,23, 7, 7, 7, 7, 7,
		 6, 6, 6, 6, 6,11, 6,17,17, 6,21, 4, 4, 4, 4, 4, 4,22, 6,17,17, 6, 8, 6, 6, 6, 6, 6,
		 6, 6, 6, 6, 6,11, 6,17,17, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,17,17, 6, 8, 6, 6, 6, 6, 6, -- 20
		 6, 6, 6, 6, 6,11, 6,17,17, 6,12,16,16,16,16,16,16,13, 6,17,17, 6, 8, 6, 6, 6, 6, 6,
		 0, 4, 4, 4, 4,25, 6,15,14, 6,15,16,16,13,12,16,16,14, 6,15,14, 6,26, 4, 4, 4, 4, 1,
		 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,17,17, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 8,
		 5, 6,12,16,16,13, 6,12,16,16,16,13, 6,17,17, 6,12,16,16,16,13, 6,12,16,16,13, 6, 8,
		 5, 6,15,16,13,17, 6,15,16,16,16,14, 6,15,14, 6,15,16,16,16,14, 6,17,12,16,14, 6, 8, -- 25
		 5, 6, 6, 6,17,17, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,17,17, 6, 6, 6, 8,
		28,16,13, 6,17,17, 6,12,13, 6,12,16,16,16,16,16,16,13, 6,12,13, 6,17,17, 6,12,16,30,
		27,16,14, 6,15,14, 6,17,17, 6,15,16,16,13,12,16,16,14, 6,17,17, 6,15,14, 6,15,16,29,
		 5, 6, 6, 6, 6, 6, 6,17,17, 6, 6, 6, 6,17,17, 6, 6, 6, 6,17,17, 6, 6, 6, 6, 6, 6, 8,
		 5, 6,12,16,16,16,16,14,15,16,16,13, 6,17,17, 6,12,16,16,14,15,16,16,16,16,13, 6, 8, -- 30
		 5, 6,15,16,16,16,16,16,16,16,16,14, 6,15,14, 6,15,16,16,16,16,16,16,16,16,14, 6, 8,
		 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 8,
		 2, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 3,
		31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,
		31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31,31  -- 35
	);

begin

	texture_id <= c_memory(tx + ty * MAP_N_TILES_X);

end RTL;
