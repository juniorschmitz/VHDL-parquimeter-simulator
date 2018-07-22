----------------------------------------------------------------------------------
-- Trabalho do parquimetro, implementado para a disciplina de Projetos de Circuitos digitais do Mestrado
-- em Engenharia de Computação da FURG
-- Autor: Jacques Schmitz Junior.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parquimetro is
Port(  clk : in  std_logic;
			  rst : in  std_logic;
			  anodos : out std_logic_vector(3 downto 0);
			  vintecinco : in std_logic;
			  cinquenta : in std_logic;
			  cem : in std_logic;
			  confirma : in std_logic;
			  estouro : out std_logic;
			  display : out std_logic_vector(6 downto 0));
end parquimetro;

architecture Behavioral of parquimetro is

	component decoder7seg is 
		Port ( count : in integer range 0 to 11; 
				 seven_seg : out std_logic_vector(6 downto 0)); 
	end component;

	component clk1khz is
		Port ( clk_50MHz, reset : in  std_logic;
			  clk_1KHz : out  std_logic);
	end component;
	
	component clk2hz is
    Port ( clk_50MHz, reset : in  std_logic;
           clk_2Hz : out  std_logic);
	end component;

	type estados is(e0, e25, e50, e75, e100, e125, e150, e175, e200, erro, printtime);
	signal estado_atual : estados;
	signal clk_1KHz : std_logic := '0';
	signal clk_2Hz : std_logic := '0';
	--type displays is array(0 to 3) of integer range 0 to 11;
	--signal meus_displays : displays;
	signal d0 : integer range 0 to 11 := 0;
	signal d1 : integer range 0 to 11 := 0;
	signal d2 : integer range 0 to 11 := 0;
	signal d3 : integer range 0 to 11 := 0;
	signal seg0, seg1, seg2, seg3 : std_logic_vector(6 downto 0);
	
begin
	
	c1k : clk1khz port map (clk_50MHz => clk, reset => rst, clk_1KHz => clk_1KHz);
	c2h : clk2hz port map (clk_50MHz => clk, reset => rst, clk_2Hz => clk_2Hz);
	dec_seg0 : decoder7seg port map(count => d0, seven_seg => seg0);--Display0
	dec_seg1 : decoder7seg port map(count => d1, seven_seg => seg1);--Display1
	dec_seg2 : decoder7seg port map(count => d2, seven_seg => seg2);--Display2
	dec_seg3 : decoder7seg port map(count => d3, seven_seg => seg3);--Display3
	
	defineDisplay: process(clk_1KHz)
		variable an_aux : integer range 0 to 3 := 0;
		begin
			if rising_edge(clk_1KHz) then 
				if an_aux = 0 then
					anodos <= "1110";
					display <= seg0;
				elsif an_aux = 1 then
					anodos <= "1101";
					display <= seg1;
				elsif an_aux = 2 then
					anodos <= "1011";
					display <= seg2;
				elsif an_aux = 3 then
					anodos <= "0111";
					display <= seg3;
				end if;
				an_aux := an_aux + 1;
			end if;
		end process defineDisplay;
		
--clk'event and clk='1'
process(clk_2Hz, rst, vintecinco, cinquenta, cem, confirma)
		begin
			if rst='1' then
				estado_atual <= e0;
			elsif (confirma='1') then
				estado_atual <= printtime;
			elsif (rising_edge(clk_2Hz) and (vintecinco = '1' or cinquenta = '1' or cem = '1')) then
				case estado_atual is
					when printtime =>
						estado_atual <= printtime;
						if(confirma='1') then
							estado_atual <= e0;
						end if;
					when e0 =>  if(vintecinco = '1') then estado_atual <= e25;  
									elsif(cinquenta = '1') then estado_atual <= e50;
									elsif(cem = '1') then estado_atual <= e100;
									else estado_atual <= e0;
									end if;
					when e25 => if(vintecinco = '1') then estado_atual <= e50;
									elsif(cinquenta = '1') then estado_atual <= e75;
									elsif(cem = '1') then estado_atual <= e125;
									else estado_atual <= e25;
									end if;
					when e50 => if(vintecinco = '1') then estado_atual <= e75;
									elsif(cinquenta = '1') then estado_atual <= e100;
									elsif(cem = '1') then estado_atual <= e150;
									else estado_atual <= e50;
									end if;
					when e75 => if(vintecinco = '1') then estado_atual <= e100;
									elsif(cinquenta = '1') then estado_atual <= e125;
									elsif(cem = '1') then estado_atual <= e175;
									else estado_atual <= e75;
									end if;
					when e100 =>if(vintecinco = '1') then estado_atual <= e125;
									elsif(cinquenta = '1') then estado_atual <= e150;
									elsif(cem = '1') then estado_atual <= e200;
									else estado_atual <= e100;
									end if;
					when e125 =>if(vintecinco = '1') then estado_atual <= e150;
									elsif(cinquenta = '1') then estado_atual <= e175;
									elsif(cem = '1') then estado_atual <=erro;
									else estado_atual <= e125;
									end if;
					when e150 =>if(vintecinco = '1') then estado_atual <= e175;
									elsif(cinquenta = '1') then estado_atual <= e200;
									elsif(cem = '1') then estado_atual <= erro;
									else estado_atual <= e150;
									end if;
					when e175 =>if(vintecinco = '1') then estado_atual <= e200;
									elsif(cinquenta = '1' or cem = '1') then estado_atual <= erro;
									else estado_atual <= e175;
									end if;
					when e200 =>if(vintecinco = '1' or cinquenta = '1' or cem = '1') then estado_atual <= erro;
									else estado_atual <= e200;
									end if;
					when erro => if(vintecinco = '1' or cinquenta = '1' or cem = '1') then estado_atual <= erro;
									elsif (confirma = '1') then estado_atual <= e0;
					end if;
				end case;
			end if;
		end process;
		
	process (estado_atual)
	variable printt : integer;
   begin
      case estado_atual is
			when printtime =>
				if(printt = 0) then d3 <= 10; d2 <= 11; d1 <= 11; d0 <= 0;
				elsif (printt = 30) then d3 <= 10; d2 <= 11; d1 <= 3; d0 <= 0;
				elsif (printt = 45) then d3 <= 10; d2 <= 11; d1 <= 4; d0 <= 5;
				elsif (printt = 60) then d3 <= 10; d2 <= 1; d1 <= 0; d0 <= 0;
				elsif (printt = 75) then d3 <= 10; d2 <= 1; d1 <= 1; d0 <= 5;
				elsif (printt = 90) then d3 <= 10; d2 <= 1; d1 <= 3; d0 <= 0;
				elsif (printt = 105) then d3 <= 10; d2 <= 1; d1 <= 4; d0 <= 5;
				elsif (printt = 120) then d3 <= 10; d2 <= 2; d1 <= 0; d0 <= 0;
				end if;
				estouro <= '0';
         when e0 => printt := 0;
				estouro <= '0';
				d3 <= 11; d2 <= 11; d1 <= 11; d0 <= 0;
         when e25 => printt := 0;
				estouro <= '0';
            d3 <= 11; d2 <= 11; d1 <= 2; d0 <= 5;
         when e50 => printt := 30;
				estouro <= '0';
            d3 <= 11; d2 <= 11; d1 <= 5; d0 <= 0;
			when e75 => printt := 45;
				estouro <= '0';
            d3 <= 11; d2 <= 11; d1 <= 7; d0 <= 5;
			when e100 => printt := 60;
				estouro <= '0';
            d3 <= 11; d2 <= 1; d1 <= 0; d0 <= 0;
			when e125 => printt := 75;
				estouro <= '0';
            d3 <= 11; d2 <= 1; d1 <= 2; d0 <= 5;
			when e150 => printt := 90;
				estouro <= '0';
            d3 <= 11; d2 <= 1; d1 <= 5; d0 <= 0;
			when e175 => printt := 105;
				estouro <= '0';
            d3 <= 11; d2 <= 1; d1 <= 7; d0 <= 5;
			when e200 => printt := 120;
				estouro <= '0';
            d3 <= 11; d2 <= 2; d1 <= 0; d0 <= 0;
			when erro => printt := 0;
				estouro <= '1';
            d3 <= 11; d2 <= 11; d1 <= 11; d0 <= 11;
      end case;
   end process;
end Behavioral;

