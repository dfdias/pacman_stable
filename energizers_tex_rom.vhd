library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity energyzers_tex_rom is
	port(
		texture_id :  in ENERGYZER_TYPE_t;
		x          :  in integer range 0 to 8-1;
		y          :  in integer range 0 to 8-1;
		ARGB       : out VGA_ARGB_t
	);
end energyzers_tex_rom;

architecture RTL of energyzers_tex_rom is
	signal s_texture_offset : integer range 0 to 4-1;

	signal s_dataout : integer range 0 to 1;
	subtype t is integer range 0 to 1;
	type st is array (0 to (4*8*8)-1) of t;

	constant c_memory : st := ( 


0,1,1,1,1,1,1,0,
1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,
0,1,1,1,1,1,1,0,

0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,1,0,0,0,
0,0,0,1,1,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,

0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,

0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,1,1,0,0,0,
0,0,0,1,1,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0

);

begin
	process(texture_id)
	begin
		s_texture_offset <= 3;
		
		if texture_id = BLANK then
			s_texture_offset <= 2;
			
		elsif texture_id = SMALL_ENERGYZER then
			s_texture_offset <= 1;

		elsif texture_id = BIG_ENERGYZER then
			s_texture_offset <= 0;

		end if;
	end process;

	s_dataout <= c_memory(s_texture_offset * 8 * 8 + x + y * 8);										  

	color_map : process(s_dataout)
	begin	
		if s_dataout = 1 then
			ARGB <= '1' & "111";
		else
			ARGB <= '0' & "000";
		end if ;
	end process;

end;
