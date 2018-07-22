
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk2hz is
    Port ( clk_50MHz : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_2Hz : out  STD_LOGIC);
end clk2hz;

architecture Behavioral of clk2hz is

	signal clk_2Hz_aux : std_logic := '0';

begin

	-- generate 2Hz oscillator 
	two_hertz_process: process(reset, clk_50MHz) 
	variable counter_50M : integer range 0 to 3_800_000; 
	begin 
		if reset = '1' then 
			counter_50M := 0; 
		elsif rising_edge(clk_50MHz) then 
			counter_50M := counter_50M + 1; 
			if counter_50M = 3_800_000 then 
				clk_2Hz_aux <= NOT clk_2Hz_aux; 
				counter_50M := 0; 
			end if; 
		end if; 
	end process two_hertz_process;
	
	-- setando o valor logico do clock de 2 hertz
	clk_2Hz <= clk_2Hz_aux;
	
 

end Behavioral;
