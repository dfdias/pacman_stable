library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.defines.all;

entity energyzer_location_ram is
	port(
		controller_tx           :  in MAP_TILES_X_t;
		controller_ty           :  in MAP_TILES_Y_t;
		controller_write_clock  :  in std_logic; 
		controller_write_enable :  in std_logic;
		controller_write_data   :  in ENERGYZER_TYPE_t;
		controller_read_data    : out ENERGYZER_TYPE_t;
		
		draw_x     :  in MAP_TILES_X_t;
		draw_y     :  in MAP_TILES_Y_t;
		draw_value : out ENERGYZER_TYPE_t
		
	);

end energyzer_location_ram;

architecture RTL of energyzer_location_ram is

type st is array (0 to MAP_N_TILES_X * MAP_N_TILES_Y - 1) of ENERGYZER_TYPE_t;
signal s_memory : st ;

signal controller_addr : integer range 0 to MAP_N_TILES_X * MAP_N_TILES_Y - 1;
signal draw_addr       : integer range 0 to MAP_N_TILES_X * MAP_N_TILES_Y - 1;

begin
	controller_addr <= controller_tx + controller_ty * MAP_N_TILES_X;
	
	controller_process: process(controller_write_clock)
	begin
		if rising_edge(controller_write_clock) then
			--controller_read_data <= s_memory(controller_addr);
			if controller_write_enable = '1' then
				s_memory(controller_addr) <= controller_write_data;
			end if;
		end if;
	end process;
	
	controller_read_data <= s_memory(controller_addr);

	draw_addr <= draw_x + draw_y * MAP_N_TILES_X;

--	draw_process: process(controller_write_clock)
--	begin
--		if falling_edge(controller_write_clock) then
			draw_value <= s_memory(draw_addr);
--		end if;
--	end process;

end RTL;
