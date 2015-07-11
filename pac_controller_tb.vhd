library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity pac_controller_tb is
end;

architecture TB of pac_controller_tb is
signal s_clk   : std_logic;
signal s_reset : std_logic;

signal s_up   : std_logic;
signal s_down : std_logic;
signal s_left : std_logic;
signal s_right: std_logic;

signal s_pac_x: integer range 0 to 28*8-1;
signal s_pac_y: integer range 0 to 36*8-1;

constant I_POS_X : integer := 14*8+0;
constant I_POS_Y : integer := 26*8+4;

begin
	
	uut: entity work.pac_controller(behav)
	port map(
		clk   => s_clk,
		rst   => s_reset,
		
 		up    => s_up,
		down  => s_down,
		lft   => s_left,
		rght  => s_right,
		
		pac_x => s_pac_x,
		pac_y => s_pac_y
	);
	
	process
	begin
		s_clk <= '1';
		wait for 100 ns;
		
		s_clk <= '0';
		wait for 100 ns;
	end process;
	
	process
	begin
		s_reset <= '1';
		s_up    <= '0';
		s_down  <= '0';
		s_left  <= '0';
		s_right <= '0';
		
		wait for 350 ns;
	
		assert s_pac_x = I_POS_X report "Posicao inicial errada" severity failure;
		assert s_pac_y = I_POS_Y report "Posicao inicial errada" severity failure;
	
		s_reset <= '0';
	
		wait for 200 ns;
		
		assert s_pac_x = I_POS_X report "Posicao inicial tem que se manter" severity failure;
		assert s_pac_y = I_POS_Y report "Posicao inicial tem que se manter" severity failure;
	
		s_right  <= '1';
		
		wait for 200 ns;
		
		assert s_pac_x = I_POS_X+1 report "Nova posicao errada" severity failure;
		assert s_pac_y = I_POS_Y   report "Nova posicao errada" severity failure;
		
		wait;
	end process;
end;
