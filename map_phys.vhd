library ieee;
use ieee.std_logic_1164.all;

entity map_phys is

    Port ( tx : in  integer range 0 to 28-1;
           ty : in  integer range 0 to 36-1;
           dataout : out std_logic_vector(3 downto 0)); -- U D L R
end map_phys;

architecture RTL of map_phys is
signal s_dataout : integer range 0 to 12-1;

subtype t is integer range 0 to 12-1;
	type st is array (0 to 28*36-1) of t;
	constant c_memory : st := (
	--                                 1                             2
	--   0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7
		 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, --  0
		 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, --  1
		 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, --  2
		 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, --  3
		 0, 1, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 4, 0, 0, 1, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 4, 0, --  4
		 0, 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 5, 0, --  5
		 0, 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 5, 0,
		 0, 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 5, 0,
		 0, 6, 2, 2, 2, 2, 7, 2, 2, 3, 2, 2, 8, 2, 2, 8, 2, 2, 3, 2, 2, 7, 2, 2, 2, 2, 9, 0,
		 0, 5, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 5, 0,
		 0, 5, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 5, 0, -- 10
		 0,11, 2, 2, 2, 2, 9, 0, 0,11, 2, 2, 4, 0, 0, 1, 2, 2,10, 0, 0, 6, 2, 2, 2, 2,10, 0,
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0,
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0,
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 1, 2, 2, 8, 2, 2, 8, 2, 2, 4, 0, 0, 5, 0, 0, 0, 0, 0, 0,
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, -- 15
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0,
		 2, 2, 2, 2, 2, 2, 7, 2, 2, 9, 0, 0, 0, 0, 0, 0, 0, 0, 6, 2, 2, 7, 2, 2, 2, 2, 2, 2,
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0,
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0,
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 6, 2, 2, 2, 2, 2, 2, 2, 2, 9, 0, 0, 5, 0, 0, 0, 0, 0, 0, -- 20
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0,
		 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0,
		 0, 1, 2, 2, 2, 2, 7, 2, 2, 8, 2, 2, 4, 0, 0, 1, 2, 2, 8, 2, 2, 7, 2, 2, 2, 2, 4, 0,
		 0, 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 5, 0,
		 0, 5, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 5, 0, -- 25
		 0,11, 2, 4, 0, 0, 6, 2, 2, 3, 2, 2, 8, 2, 2, 8, 2, 2, 3, 2, 2, 9, 0, 0, 1, 2,10, 0,
		 0, 0, 0, 5, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 5, 0, 0, 0,
		 0, 0, 0, 5, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 5, 0, 0, 0,
		 0, 1, 2, 8, 2, 2,10, 0, 0,11, 2, 2, 4, 0, 0, 1, 2, 2,10, 0, 0,11, 2, 2, 8, 2, 4, 0,
		 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, -- 30
		 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0,
		 0,11, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 8, 2, 2, 8, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,10, 0,
		 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  -- 35
	);

begin
	s_dataout <= c_memory(tx + ty*28);

decoder : process (s_dataout)
begin
	dataout <= "0000";
	
	if s_dataout = 0 then
	dataout <= "0000";
	elsif s_dataout = 1 then
	dataout <= "0101";
	elsif s_dataout = 2 then
	dataout <= "0011";
	elsif s_dataout = 3 then
	dataout <= "0111";
	elsif s_dataout = 4 then
	dataout <= "0110";
	elsif s_dataout = 5 then
	dataout <= "1100";
	elsif s_dataout = 6 then
	dataout <= "1101";
	elsif s_dataout = 7 then
	dataout <= "1111";
	elsif s_dataout = 8 then
	dataout <= "1011";
	elsif s_dataout = 9 then
	dataout <= "1110";
	elsif s_dataout = 10 then
	dataout <= "1010";
	elsif s_dataout = 11 then
	dataout <= "1001";
	end if ;
end process;
	


end RTL;
