
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk1khz is
    Port ( clk_50MHz : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_1KHz : out  STD_LOGIC);
end clk1khz;

architecture Behavioral of clk1khz is

	signal clk_1KHz_aux : std_logic := '0';

begin

	-- generate 1kHz oscillator 
	mil_hertz_process: process(reset, clk_50MHz) 
	variable counter_50M : integer range 0 to 50_000; 
	begin 
		if reset = '1' then 
			counter_50M := 0; 
		elsif rising_edge(clk_50MHz) then 
			counter_50M := counter_50M + 1; 
			if counter_50M = 50_000 then 
				clk_1KHz_aux <= NOT clk_1KHz_aux; 
				counter_50M := 0; 
			end if; 
		end if; 
	end process mil_hertz_process;
	
	-- setando o valor logico do clock de 1 kilo hertz
	clk_1KHz <= clk_1KHz_aux;
	
 

end Behavioral;
