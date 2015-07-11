library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity game_controller is
	port(
		clk   : in std_logic;
		reset : in std_logic;

	   -- up    : in std_logic;	      -- teclas de controlo do pac_man
	    --down  : in std_logic;
	    --left  : in std_logic;
	    --right : in std_logic;

		-- dados posicionais do mapa e do pacman
		
		ram_x    :  in MAP_TILES_X_t;
		ram_y    :  in MAP_TILES_Y_t;
		ram_data : out ENERGYZER_TYPE_t;
		
		pac_x    :  in MAP_COORD_X_t;
		pac_y    :  in MAP_COORD_Y_t; 
		
		score_out : out SCORE_t      --array(5 downto 0) of integer range 0 to 10;
		-- life  : out integer range 0 to 2-1;
	);
end game_controller;

architecture b of game_controller is

signal s_ram_tx                : MAP_TILES_X_t;
signal s_ram_ty                : MAP_TILES_Y_t;
signal s_ram_write_enable      : std_logic;
signal s_ram_write_data        : ENERGYZER_TYPE_t;
signal s_ram_read_data         : ENERGYZER_TYPE_t;

signal s_rom_tx, s_rom_tx_next : MAP_TILES_X_t;
signal s_rom_ty, s_rom_ty_next : MAP_TILES_Y_t;
signal s_rom_data              : ENERGYZER_TYPE_t;

signal s_score                : SCORE_t;
signal s_score_next           : SCORE_t;

signal s_copy_cnt               : integer range 0 to MAP_N_TILES_X * MAP_N_TILES_Y;
signal s_copy_cnt_next          : integer range 0 to MAP_N_TILES_X * MAP_N_TILES_Y;

type state                     is (Ram_Copy,Play);--states declaration
signal PS,NS                   : state; -- Present an Next State declaration

begin

	rom_access: entity work.energyzers_location_rom(RTL)
	port map(
		tx       => s_rom_tx,
		ty       => s_rom_ty,
		data_out => s_rom_data
	);

	ram_access: entity work.energyzer_location_ram(RTL)
	port map(
		controller_tx           => s_ram_tx,
		controller_ty           => s_ram_ty, 
		controller_write_clock  => clk,
		controller_write_enable => s_ram_write_enable,
		controller_write_data   => s_ram_write_data, 
		controller_read_data    => s_ram_read_data,
		
		draw_x     => ram_x,
		draw_y     => ram_y,
		draw_value => ram_data
	);

	fsm_state_proc: process(clk, reset)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				PS         <= Ram_Copy;
				s_rom_tx   <= 0;
				s_rom_ty   <= 0;
				s_score <= (others => 0);
			else
				PS         <= NS;
				s_rom_tx   <= s_rom_tx_next;
				s_rom_ty   <= s_rom_ty_next;
				s_score    <= s_score_next;
			end if;
		end if;
	end process;

	fsm_comb_proc: process(PS, s_rom_tx, s_rom_ty, s_rom_data)
	begin
		NS <= PS;
		s_rom_tx_next <= s_rom_tx;
		s_rom_ty_next <= s_rom_ty;
		
		s_ram_tx           <= 0;
		s_ram_ty           <= 0;
		s_ram_write_data   <= BLANK;
		s_ram_write_enable <= '0';

		case PS is
			when Ram_Copy =>
				s_ram_tx           <= s_rom_tx;
				s_ram_ty           <= s_rom_ty;
				s_ram_write_data   <= s_rom_data;
				s_ram_write_enable <= '1';
				
				if s_rom_tx = MAP_N_TILES_X - 1 then
					s_rom_tx_next <= 0;
					if s_rom_ty = MAP_N_TILES_Y - 1 then
						NS <= Play;
					else
						s_rom_ty_next <= s_rom_ty + 1;
					end if;
				else
					s_rom_tx_next <= s_rom_tx + 1;
				end if;

		when Play =>
			s_ram_tx <= pac_x / 8;
			s_ram_ty <= pac_y / 8;
			
			if s_ram_read_data = SMALL_ENERGYZER then
				s_ram_write_enable <= '1';
				s_ram_write_data   <= BLANK;
				
				s_score_next(5) <= s_score(5) + 0;
				s_score_next(4) <= s_score(4) + 1;

			
			elsif s_ram_read_data = BIG_ENERGYZER then
				s_ram_write_enable <= '1';
				s_ram_write_data   <= BLANK;
				

				s_score_next(5) <= s_score(5) + 0;
				s_score_next(4) <= s_score(4) + 5 ;
				
			end if;
		end case;
	end process;

	cnt_manager: entity work.score_arith(behav)
	port map(
		score_in  => s_score,
		score_out => score_out
	);

end b;


