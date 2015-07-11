library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_textio.all;

library work;
use work.defines.all;

library std;
use std.textio.all;

entity vga_draws_tb is
end;

architecture TB of vga_draws_tb is
	signal s_clk   : std_logic;
	signal s_reset : std_logic;

	signal s_vga_x : integer range 0 to VGA_WIDTH  - 1;
	signal s_vga_y : integer range 0 to VGA_HEIGHT - 1;

	signal s_pac_x : MAP_COORD_X_t;
	signal s_pac_y : MAP_COORD_X_t;

	signal s_RGB   : VGA_RGB_t;

	signal s_ram_x     : MAP_TILES_X_t;
	signal s_ram_y     : MAP_TILES_Y_t;
	signal s_ram_value : ENERGYZER_TYPE_t;

begin
	draw: entity work.vga_draws
	port map(
		vga_x     => s_vga_x,
		vga_y     => s_vga_y,
		pac_x     => s_pac_x,
		pac_y     => s_pac_y,
		ram_x     => s_ram_x,
		ram_y     => s_ram_y,
		ram_value => s_ram_value,
		score     => (others => 0),
		RGB       => s_RGB
	);
	
	controller: entity work.game_controller(b)
	port map(
		clk      => s_clk,
		reset    => s_reset,
		ram_x    => s_ram_x,
		ram_y    => s_ram_y,
		ram_data => s_ram_value,
		pac_x    => s_pac_x,
		pac_y    => s_pac_y
	);
	
	process
	begin
		s_clk <= '0'; wait for 100 ns;
		s_clk <= '1'; wait for 100 ns;
	end process;

	process
		file     log_file  : text open write_mode is "vga_draws_tb.txt";
		variable log_file_l: line;
		
		variable v_vga_x  : integer range 0 to VGA_WIDTH  - 1;
		variable v_vga_y  : integer range 0 to VGA_HEIGHT - 1;
		
		variable v_RGB: std_logic_vector(2 downto 0);
	begin
		s_pac_x <= PAC_START_X;
		s_pac_y <= PAC_START_Y;
		
		s_reset <= '1';
		wait for 200 ns;
		s_reset <= '0';
		
		wait for 300 us;

		for v_vga_y in 0 to VGA_HEIGHT - 1 loop
		for v_vga_x in 0 to VGA_WIDTH  - 1 loop
			s_vga_x <= v_vga_x;
			s_vga_y <= v_vga_y;
				
			wait for 5 ns;

			write(log_file_l, s_RGB);
			writeline(log_file, log_file_l);
		end loop;
		end loop;

		wait;
	end process;
	
end;
