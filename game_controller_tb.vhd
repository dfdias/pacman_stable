library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity game_controller_tb is
end;

architecture TB of game_controller_tb is
signal s_clk   : std_logic;
signal s_reset : std_logic;

signal s_pac_x    : MAP_COORD_X_t;
signal s_pac_y    : MAP_COORD_X_t;
signal s_ram_x    : MAP_TILES_X_t;
signal s_ram_y    : MAP_TILES_X_t;
signal s_ram_data : ENERGYZER_TYPE_t;

begin

	uut: entity work.game_controller(b)
	port map(
		clk      => s_clk,
		reset    => s_reset,
		ram_x    => s_ram_x,
		ram_y    => s_ram_y,
		ram_data => s_ram_data,
		pac_x    => s_pac_x,
		pac_y    => s_pac_y
	);

	process
	begin
		s_clk <= '0'; wait for 100 ns;
		s_clk <= '1'; wait for 100 ns;
	end process;

	process
	begin
		s_ram_x <= 0;
		s_ram_y <= 0;
		s_reset <= '1';
		
		wait for 200 ns;
		
		s_reset <= '0';
		
		wait;
	end process;

end;
