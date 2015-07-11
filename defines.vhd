library IEEE;
use	IEEE.STD_LOGIC_1164.all;

package defines is

constant VGA_WIDTH  : integer := 800;
constant VGA_HEIGHT : integer := 600;

constant MAP_N_TILES_X : integer := 28;
constant MAP_N_TILES_Y : integer := 36;

subtype  MAP_TILES_X_t is integer range 0 to MAP_N_TILES_X - 1;
subtype  MAP_TILES_Y_t is integer range 0 to MAP_N_TILES_Y - 1;

constant MAP_COORD_X : integer := MAP_N_TILES_X * 8;
constant MAP_COORD_Y : integer := MAP_N_TILES_Y * 8;

subtype  MAP_COORD_X_t is integer range 0 to MAP_COORD_X - 1;
subtype  MAP_COORD_Y_t is integer range 0 to MAP_COORD_Y - 1;

constant MAP_VGA_OFFSET_X : integer := 176;
constant MAP_VGA_OFFSET_Y : integer :=  12;

constant MAP_VGA_WIDTH  : integer := MAP_N_TILES_X * 8 * 2;
constant MAP_VGA_HEIGHT : integer := MAP_N_TILES_Y * 8 * 2;

subtype  VGA_RGB_t  is std_logic_vector(2 downto 0);
subtype  VGA_ARGB_t is std_logic_vector(3 downto 0);

constant PAC_START_X : integer := 14 * 8 + 0;
constant PAC_START_Y : integer := 26 * 8 + 4;

type SCORE_t is array(0 to 5) of integer range 0 to 10;

type ENERGYZER_TYPE_t is (BLANK, SMALL_ENERGYZER, BIG_ENERGYZER);

type PAC_DIR_t is (PAC_UP, PAC_DOWN, PAC_LEFT, PAC_RIGHT, PAC_START_DIR);

end package;
