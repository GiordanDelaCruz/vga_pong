----------------------------------------------------------------------------------
-- Company: Ryerson University
-- Engineer: Sampson Cao & Giordan Dela Cruz
-- 
-- Create Date:    19:11:21 11/17/2021 
-- Design Name: 	 
-- Module Name:    clock_divider - Behavioral 
-- Project Name: 	 project2_videogame
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--	This program divides clock frequency by 4 which in our project, is to get the
-- video clock which is 25 MHz, from the CPU clock which is 100 MHz
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port (
			clk_in 	: 	IN  	STD_LOGIC;
			reset		:	IN		STD_LOGIC;
			clk_out 	: 	OUT  	STD_LOGIC);
end clock_divider;

architecture Behavioral of clock_divider is

	signal counter : INTEGER := 0;
	signal temp		: STD_LOGIC := '0';

begin
	
	process (clk_in, reset)
		begin
			if (reset = '1') then
				temp <= '0';
				counter <= 0;
			elsif (clk_in'event and clk_in = '1') then
				if (counter = 1) then
					temp <= NOT temp;
					counter <= 0;
				else
					counter <= counter + 1;
				end if;
			end if;
			clk_out <= temp;
	end process;

end Behavioral;

