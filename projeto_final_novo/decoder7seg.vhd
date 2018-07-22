
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder7seg is
    Port ( count : in  integer range 0 to 11;
           seven_seg : out  STD_LOGIC_VECTOR (6 downto 0));
end decoder7seg;

architecture Behavioral of decoder7seg is

	constant zero : std_logic_vector(6 downto 0) := "1000000"; 
	constant one : std_logic_vector(6 downto 0) := "1111001";
	--constant letterA : std_logic_vector(6 downto 0) := "0001000";
	--constant letterB : std_logic_vector(6 downto 0) := "0000011";
	--constant letterC : std_logic_vector(6 downto 0) := "1000110"; 
	--constant letterD : std_logic_vector(6 downto 0) := "0100001"; 
	constant nothing : std_logic_vector(6 downto 0) := "1111111"; 

	constant two : std_logic_vector(6 downto 0) := "0100100";
	constant three : std_logic_vector(6 downto 0) := "0110000"; 
	constant four : std_logic_vector(6 downto 0) := "0011001";
	constant five : std_logic_vector(6 downto 0) := "0010010"; 
	constant six : std_logic_vector(6 downto 0) := "0000010"; 
	constant seven : std_logic_vector(6 downto 0) := "1111000"; 
	constant eight : std_logic_vector(6 downto 0) := "0000000"; -- aqui eh 8 msm
	constant nine : std_logic_vector(6 downto 0) := "0000100"; 
	constant h : std_logic_vector(6 downto 0) := "0001001"; -- 8 = H, teste
	--constant t : std_logic_vector(6 downto 0) := "1111110";
begin
	--display the count value on the seven segments 
	seven_segment_decoder_process: process(count) 
	begin 
		case count is 
			when 0 => seven_seg <= zero; 
			when 1 => seven_seg <= one; 
			when 2 => seven_seg <= two; 
			when 3 => seven_seg <= three; 
			when 4 => seven_seg <= four; 
			when 5 => seven_seg <= five; 
			when 6 => seven_seg <= six;
			when 7 => seven_seg <= seven;
			when 8 => seven_seg <= eight;
			when 9 => seven_seg <= nine;
			when 10 => seven_seg <= h;
			when 11 => seven_seg <= nothing;
		end case; 
	end process seven_segment_decoder_process; 
end Behavioral;