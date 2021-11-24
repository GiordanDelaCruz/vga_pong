----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:27:26 11/10/2021 
-- Design Name: 
-- Module Name:    game - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity game is
	
	PORT(
		
		clk		:	IN		STD_LOGIC;
		-- player controls
		up_p1		:	IN		STD_LOGIC;
		down_p1	:	IN		STD_LOGIC;
		up_p2		:	IN		STD_LOGIC;
		down_p2	:	IN		STD_LOGIC;
		power		:	IN		STD_LOGIC;
		reset		:	IN		STD_LOGIC;
		
		-- outputs
		h_sync_vga 	: OUT  std_logic;
      v_sync_vga 	: OUT  std_logic;
      red_vga		: OUT  std_logic_vector(2 downto 0);
      green_vga 	: OUT  std_logic_vector(2 downto 0);
      blue_vga 	: OUT  std_logic_vector(1 downto 0);
		
		-- these two have some unknown purpose in game_tb
      h_pixel		: OUT  std_logic_vector(9 downto 0);
      v_pixel 		: OUT  std_logic_vector(9 downto 0)
		
		
		
	);
	
end game;

architecture Behavioral of game is

begin		
	
	process (clk)
		begin
			
			
	end process;
	
	

end Behavioral;

