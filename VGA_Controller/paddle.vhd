----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:39:59 11/22/2021 
-- Design Name: 
-- Module Name:    paddle - Behavioral 
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

library work;
use work.obj_package.all;

entity paddle is
		generic(
			paddle_side : position_side := left;
			paddle_height : integer := 60;
			paddle_width : integer := 10;
			rgb : std_logic_vector(7 downto 0) := "111" & "111" & "11"
		);
		port(
			reset: in std_logic;
			clk: in std_logic;
			h_count: in integer range 0 to 1023;
			v_count: in integer range 0 to 1023;
			col_object: out main_object := default_obj;
			
			--controls: in type_controls;
			draw_element: out draw:= default_draw
		);
end paddle;

architecture Behavioral of paddle is
	-- Create paddle
	signal paddle_obj: main_object := default_obj;
	
begin

	-- Map output port
	col_object <= paddle_obj;
	
	-- Animation Process
	animate: process(clk)
	
		-- Define variables
		variable paddle_bounds: boundary;
		
		-- Define Constants
		constant wall_space: integer := 25;
	
		begin
			
			if( reset = '1') then 
				-- ** Initialization **
				
				-- Create Paddles
				case paddle_side is
					
					when left => 
						-- Center point at top left
						paddle_obj.pos.x <= wall_space;
					
					when right => 
						-- Center point at top left
						paddle_obj.pos.x <= X_ACTIVE - paddle_width - wall_space;
						
					when others =>
						-- Do nothing
						null;
				end case;
			
				-- Define remaining parameters for paddle
				paddle_obj.pos.y <= ( (Y_ACTIVE/2)- 1) - (paddle_height/2);	
				paddle_obj.width <= paddle_width;
				paddle_obj.height <= paddle_height;
				paddle_obj.vel <= STATIC;
				
			else 
			
				-- Determine player movements
				
			end if;
			
		
				
	end process;
	
end Behavioral;

