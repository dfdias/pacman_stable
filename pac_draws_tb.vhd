library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity pac_draws_tb is
end;

architecture TB of pac_draws_tb is
signal s_pac_x, s_x : integer range 0 to (26*8)-1;
signal s_pac_y, s_y : integer range 0 to (34*8)-1; 
signal s_RGB : std_logic_vector(2 downto 0);

begin
	
	uut: entity work.pac_draws(struct)
	port map(
		texture_id => 0,
		pac_x      => s_pac_x,
		pac_y      => s_pac_y,
		x          => s_x,
		y          => s_y,
		RGB        => s_RGB
	);
	
	process
		variable v_x : integer range -8 to 8-1;
		variable v_y : integer range -8 to 8-1;
	begin
		s_pac_x <= 50;
		s_pac_y <= 50;
		for v_y in -8 to 8 - 1 loop
			for v_x in -8 to 8 - 1 loop
				s_x <= 50 + v_x;
				s_y <= 50 + v_y;
				wait for 5 ns;
			end loop;
		end loop;
		
		wait for 5 ns;

		--wait for 1000 ns;
	
		--s_pac_x <= 0;
		--s_pac_y <= 0;
		--for v_x in -8 to 8 - 1 loop
		--	for v_y in -8 to 8 - 1 loop
		--		s_x <= 50 + v_x;
		--		s_y <= 50 + v_y;
		--		wait for 5 ns;
		--	end loop;
		--end loop;
		
		--wait for 1000 ns;
		
		--s_pac_x <= 50 - 8;
		--s_pac_y <= 50 - 8;
		--for v_x in -8 to 8 - 1 loop
		--	for v_y in -8 to 8 - 1 loop
		--		s_x <= 50 + v_x;
		--		s_y <= 50 + v_y;
		--		wait for 5 ns;
		--	end loop;
		--end loop;
		
		--wait for 1000 ns;
	
		wait;
	end process;
	
end;