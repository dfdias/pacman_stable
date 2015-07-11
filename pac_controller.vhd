library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.defines.all;

entity pac_controller is 
port (clk : in std_logic;
		rst :in std_logic;
		
 		up : in std_logic;
	  	down : in std_logic;
	  	lft : in std_logic;
	  	rght : in std_logic;


     	pac_x : out integer range 0 to 28*8-1;
      pac_y : out integer range 0 to 36*8-1;
	   pac_dir : out PAC_DIR_t;
      pac_sprite_id : out integer range 0 to 8
		
       );
end pac_controller;

architecture behav of pac_controller is 

	--signal s_u, down, rght, lft : std_logic;
	signal s_pac_x, s_pac_x_next : integer range 0 to 28*8-1;
	signal s_pac_y, s_pac_y_next : integer range 0 to 36*8-1;
	type state is (S,R,L,U,D);
	signal PS ,NS : state;
	signal s_u,s_d,s_l,s_r : std_logic;
	signal s_phys : std_logic_vector(3 downto 0);
	signal s_tx : integer range 0 to 28-1;
	signal s_ty : integer range 0 to 36-1;
	signal s_stx: integer range 0 to 7;
	signal s_sty: integer range 0 to 7;
	constant T                   : integer := 100;
   signal cnt                   : integer range 0 to T;
   signal cnt_next              : integer range 0 to T;

begin

	s_tx <= (s_pac_x)/8;
	s_ty <= (s_pac_y)/8;

	s_stx <= s_pac_x - s_tx * 8;
	s_sty <= s_pac_y - s_ty * 8;

	map_phys_rom: entity work.map_phys(RTL)
	port map (tx => s_tx,
					ty => s_ty,
					dataout => s_phys);

	s_u <= s_phys(3);
	s_d <= s_phys(2);
	s_l <= s_phys(1);
	s_r <= s_phys(0);

	process(PS)
	begin
		pac_dir <= PAC_START_DIR;
		
		case PS is
			when S => pac_dir <= PAC_START_DIR;
			when U => pac_dir <= PAC_UP;
			when R => pac_dir <= PAC_RIGHT;
			when L => pac_dir <= PAC_LEFT;
			when D => pac_dir <= PAC_DOWN;		
		end case;
	end process;
	
	mov_sync_mangr : process(rst, clk)
	begin
		if(rst = '1') then 
			s_pac_x <= 14*8 + 0;
			s_pac_y <= 26*8 + 4;
			PS <= S;
			cnt <= 0;
		elsif rising_edge(clk) then
			PS <= NS;
			s_pac_x <= s_pac_x_next;
			s_pac_y <= s_pac_y_next;
			cnt     <= cnt_next;
		end if;
	end process;

	mov_state_mangr: process(up,down,lft,rght,PS,s_u,s_d,s_l,s_r,s_pac_x,s_pac_y,s_stx,s_sty,cnt)
	begin
		NS <= PS;
		
		s_pac_x_next <= s_pac_x;
		s_pac_y_next <= s_pac_y;
		cnt_next <= cnt + 1;
			
		if up= '1' and s_u = '1' and s_stx = 3 then
			NS <= U;
			s_pac_y_next <= s_pac_y-1;
		
		elsif down = '1' and s_d = '1' and s_stx = 3 then
			NS <= D;
			s_pac_y_next <= s_pac_y+1;
		
		elsif rght = '1'  and s_r = '1' and s_sty = 4 then
			NS <= R;
			s_pac_x_next <= s_pac_x+1;
			
		elsif lft = '1' and s_l = '1' and s_sty = 4 then
			NS <= L;
			s_pac_x_next <= s_pac_x-1;
		
		elsif PS = U and (s_u = '1' or s_sty > 4) then 
			s_pac_y_next <= s_pac_y-1;
			
		elsif PS = D and (s_d = '1' or s_sty < 4) then 
			s_pac_y_next <= s_pac_y+1;
			
		elsif PS = R and (s_r = '1' or s_stx < 3) then 
			s_pac_x_next <= s_pac_x+1;
			
		elsif PS = L and (s_l = '1' or s_stx > 3) then 
			s_pac_x_next <= s_pac_x-1;
		
		elsif s_pac_x = 27 * 8 and s_pac_y = 18*8 then
		  s_pac_x_next <= 1;
		  s_pac_y_next <= 18*8;
		  
		elsif s_pac_x = 0 and s_pac_y = 18*8 then
		  s_pac_x_next <= 27*8;
		  s_pac_y_next <= 18*8;
			
		end if;
	
	end process;
	



	txt_mngr : process (NS,PS,cnt)
	begin
		pac_sprite_id <= 0;
		
	 if (NS /= PS) then 
	  pac_sprite_id <= 1;
	 elsif  cnt  <= T rem 16 then
	  pac_sprite_id <= 2;
	 elsif cnt <= 2*(T rem 16) then
	  pac_sprite_id <= 3;
	 elsif cnt <= 3*(T rem 16) then
	  pac_sprite_id <= 4;
	 elsif cnt <= 4*(T rem 16) then
	  pac_sprite_id <= 4;
	 elsif cnt <= 5*(T rem 16) then
	  pac_sprite_id <= 5;	  
	 elsif cnt <= 6*(T rem 16) then
	  pac_sprite_id <= 6;	 	
	 elsif cnt <= 7*(T rem 16) then
	  pac_sprite_id <= 7;
	 elsif cnt <= 8*(T rem 16) then
	  pac_sprite_id <= 8;
	 elsif cnt <= 9*(T rem 16) then
	  pac_sprite_id <= 7;
	 elsif cnt <= 10*(T rem 16) then
	  pac_sprite_id <= 6;
	 elsif cnt <= 11*(T rem 16) then
	  pac_sprite_id <= 5;
	 elsif cnt <= 12*(T rem 16) then
	  pac_sprite_id <= 4;
	 elsif cnt <= 13*(T rem 16) then
	  pac_sprite_id <= 3;
	 elsif cnt <= 14*(T rem 16) then
	  pac_sprite_id <= 2;
	 elsif cnt <= T then
	  pac_sprite_id <= 1;
	 end if;
	end process;
	
	pac_x <= s_pac_x;
	pac_y <= s_pac_y; 

end behav;



