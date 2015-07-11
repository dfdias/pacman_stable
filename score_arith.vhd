library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.defines.all;

entity score_arith is
port (score_in  :  in SCORE_t;
      score_out : out SCORE_t);

end score_arith;

architecture behav of score_arith is
begin

 cnt_manager:process(score_in)
 begin
	


 	if score_in(5) = 9 then
 		score_out(4) <= score_in(4)+1;
 		score_out(5) <= 0;

    elsif score_in(4) = 9 then
        score_out(3) <= score_in(3)+1;
        score_out(4) <= 0; 	

    elsif score_in(3) = 9 then
        score_out(2) <= score_in(2)+1;
        score_out(3) <= 0;

    elsif score_in(2) = 9 then
        score_out(1) <= score_in(1)+1;
        score_out(2) <= 0;

    elsif score_in(1) = 9 then
        score_out(0) <= score_in(0)+1;
        score_out(1) <= 0;

 	elsif score_in(0) =  9 then
     score_out <= (others => 0);
 	 		
	end if;
	
score_out <= score_in;
 end process;
 
 
end;