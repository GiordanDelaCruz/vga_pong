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
			rgb_color : std_logic_vector(7 downto 0) := "111" & "111" & "11"
		);
		port(
			reset: in std_logic;
			clk: in std_logic;
			h_count: in integer range 0 to 1023;
			v_count: in integer range 0 to 1023;
			col_object: out main_object := DEFAULT_OBJ;
			
			p_controls: in player_controls;
			draw_element: out draw_object:= DEFAULT_DRAW
		);
end paddle;

architecture Behavioral of paddle is
	
	-- Create paddle object
	signal paddle_obj: main_object := default_obj;
	
begin

	-- Map output port
	col_object <= paddle_obj;
	
	-- Animation Process
	animate: process(clk)
	
		-- ** Define variables** 
		variable paddle_bounds: boundary;
		
		variable clk_count: integer := 0;
		variable slow_down_factor: integer := 500000;

		variable ok_to_move_up: integer;
		variable ok_to_move_down: integer;
		
		-- ** Define Constants ** 
		constant wall_space: integer := 25;
		
		-- NOTE: Top border starts at index 10 and has a height of 5
		-- 		Similar case with Bottom border. 
		--			(i.e starts at index 470 and has a height of 5.
		-- Define field border constants
		constant PLAY_AREA_TOP: integer := 15;
		constant PLAY_AREA_BOTTOM: integer := 465;
			
			
			
		begin
			if( rising_edge(clk) ) then
			
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
						
					-- Note: Used a slower clk frequency so that the paddle will update at
					--			a more appropriate speed. It would appear as if teleportation occured
					--       if the same clock frequency was used. 
					if( clk_count >= slow_down_factor ) then
						
						-- Determine player inputs
						-- Up Input
						if( p_controls.up = '1') then
							paddle_obj.vel.vel_y <= paddle_obj.vel.vel_y - 1;
						end if;
						
						-- Down Input
						if( p_controls.down = '1') then
							paddle_obj.vel.vel_y <= paddle_obj.vel.vel_y + 1;
						end if;
						
						-- Handle when player has no input	
						if( p_controls.up = '0' and p_controls.down = '0') then
							paddle_obj.vel.vel_y <= 0;
						end if;
						
						-- Update paddle bounds				
						paddle_bounds := set_boundary(paddle_obj);
																					
						-- Check if is okay for paddle to move up or down
						ok_to_move_up 			:= paddle_bounds.top + paddle_obj.vel.vel_y;
						ok_to_move_down 		:= paddle_bounds.bottom + paddle_obj.vel.vel_y;
						
						-- Movement of paddle if possible
						if( ok_to_move_up >= PLAY_AREA_TOP and 
							 ok_to_move_down <= PLAY_AREA_BOTTOM) then
							
							-- Move paddle up or down
							paddle_obj.pos.y 	<= paddle_obj.pos.y + paddle_obj.vel.vel_y;
							
						else 
						
							-- EDGE CASE
							-- Paddle hit a boundary
							if( ok_to_move_up < PLAY_AREA_TOP ) then
							
								-- Top boundary position restriction
								paddle_obj.pos.y <= PLAY_AREA_TOP;
								
							elsif( ok_to_move_down > PLAY_AREA_BOTTOM ) then
							
								-- Bottom boundary position restriction
								paddle_obj.pos.y <= PLAY_AREA_BOTTOM - paddle_height;	
							end if;
							
							-- If you hit a wall bleed off...
							paddle_obj.vel.vel_y <= 0;
						end if;	
						
						clk_count :=  0;
					end if;
					
					clk_count :=  clk_count + 1;
					
				 end if;			
		end if;
			
	end process;
	
	
	-- Draw process
	drawing: process(clk)
			-- Define variables
			variable paddle_bounds: boundary;
			
	begin
		if rising_edge(clk) then
			if reset = '1' then
				draw_element.pixelOn <= false;
				draw_element.rgb <= (others => '0');
					
			else
				draw_element.rgb <= rgb_color;
				
				-- Determine paddle boundary
				paddle_bounds := set_boundary(paddle_obj);

				-- Draw paddle if h_count & v_count is within the boundaries of
				-- paddle hitbox
				if h_count >= paddle_bounds.left and h_count <= paddle_bounds.right and 
					v_count >= paddle_bounds.top and v_count <= paddle_bounds.bottom then
					
					draw_element.pixelOn <= true;
				else
				
					draw_element.pixelOn <= false;
				end if;
				
			end if;
		end if;
	end process;
	
	
end Behavioral;