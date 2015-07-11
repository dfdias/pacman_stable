library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;

entity vga_controller is
	port(
		reset :  in std_logic;
		clk   :  in std_logic;
		
		x     : out integer range 0 to 800-1;
		y     : out integer range 0 to 600-1;
		
		R     :  in std_logic;
		G     :  in std_logic;
		B     :  in std_logic;
		
		dac_clk     : out std_logic;
		dac_red     : out std_logic_vector(7 downto 0); -- blue  signal for further conection to dac
		dac_green   : out std_logic_vector(7 downto 0); -- green signal for further conection to dac 
		dac_blue    : out std_logic_vector(7 downto 0); -- blue  signal for further conection to dac
		dac_n_sync  : out std_logic; -- dac
		dac_n_blank : out std_logic; -- dac
		
		vga_h_sync  : out std_logic;
		vga_v_sync  : out std_logic
	);
end	vga_controller;

architecture struct of vga_controller is
	type x_zone_t is (X_A, X_B, X_C, X_D);
	type y_zone_t is (Y_A, Y_B, Y_C, Y_D);

	constant h_a : integer :=  80; --  1.6 us @ 50 Mhz
	constant h_b : integer := 160; --  3.2 us @ 50 Mhz
	constant h_c : integer := 800; -- 16.2 us @ 50 Mhz
	constant h_d : integer :=  15; --  0.6 us @ 50 Mhz

	constant v_a : integer :=   3; -- a   3 lines
	constant v_b : integer :=  21; -- b  21 lines
	constant v_c : integer := 600; -- c 600 lines
	constant v_d : integer :=   1; -- d  49 lines

	signal s_x, s_x_next : integer range 0 to 1054;
	signal s_y, s_y_next : integer range 0 to  638;
	signal s_h_sync      : std_logic;
	signal s_v_sync      : std_logic;
	signal s_n_sync      : std_logic;
	signal s_n_blank     : std_logic;
	signal s_x_zone      : x_zone_t;
	signal s_y_zone      : y_zone_t;

begin

	state_mngr: process( clk ) 
	begin 
		if( rising_edge(clk) ) then 
			if reset = '1' then
				s_x <= 	h_c + h_d;
				s_y	<=	v_c + v_d;
			else
				s_x <= s_x_next;
				s_y <= s_y_next;
			end if;
		end if;
	end process;

	x_proc: process(s_x)
		begin
			s_x_next <= s_x;
			
			if s_x = h_a + h_b + h_c + h_d - 1 then
				s_x_next <= 0;
			else
				s_x_next <= s_x + 1;
			end if;
	end process;

	y_proc:	process(s_x, s_y)
	begin
		s_y_next <= s_y;
		
		if s_x = h_c + h_d - 1 then
			if s_y = v_a + v_b + v_c + v_d - 1 then
				s_y_next <= 0;
			else
				s_y_next <= s_y + 1;
			end if;
		end if ;
	end process;

	x_zone_proc: process(s_x)
		begin
			if    s_x < h_c then
				s_x_zone <= X_C;
			
			elsif s_x < h_c + h_d then
				s_x_zone <= X_D;
			
			elsif s_x < h_c + h_d + h_a then
				s_x_zone <= X_A;
			
			else
				s_x_zone <= X_B;
			end if;
		end process;

	y_zone_proc: process(s_y)
	begin
		if    s_y < v_c then
			s_y_zone <= Y_C;
		
		elsif s_y < v_c + v_d  then
			s_y_zone <= Y_D;
		
		elsif s_y < v_c + v_d + v_a then
			s_y_zone <= Y_A;
		
		else
			s_y_zone <= Y_B;
		
		end if;
	end process;

	h_sync_proc: process(s_x_zone)
	begin
		if s_x_zone = X_A then
			s_h_sync <= '1';
		else
			s_h_sync <= '0';
		end if ;
	end process;

	v_sync_proc: process(s_y_zone)
	begin
		if s_y_zone = Y_A then
			s_v_sync <= '1';
		else
			s_v_sync <= '0';
		end if ;
	end process;

	n_blank_proc: process(s_y_zone, s_x_zone)
	begin
		if (s_x_zone = X_C) and (s_y_zone = Y_C) then
			s_n_blank <= '1';
		else
			s_n_blank <= '0';
		end if ;
	end process;

	n_sync_proc: process(s_y_zone, s_x_zone)
	begin
		if (s_x_zone = X_A) or (s_y_zone = Y_A) then
			s_n_sync <= '0';
		else
			s_n_sync <= '1';
		end if ;
	end process;

	outs_proc: process(clk)
	begin
		if rising_edge(clk) then
			vga_v_sync  <= s_v_sync;
			vga_h_sync  <= s_h_sync;
			dac_n_sync  <= s_n_sync;
			dac_n_blank <= s_n_blank;
			x           <= s_x;
			y           <= s_y;
			dac_red     <= (others => R);
			dac_green   <= (others => G);
			dac_blue    <= (others => B);
			end if;
	end process;

	dac_clk <= not clk;

end;
