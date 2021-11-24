----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:25 11/23/2021 
-- Design Name: 
-- Module Name:    ball - Behavioral 
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

entity ball is
		generic(
			num_collision_objects: integer := 2;
			ball_radius : integer := 8;
			rgb_color : std_logic_vector(7 downto 0) := "111" & "111" & "11"
		);
		port(
			reset						: in std_logic;
			clk						: in std_logic;
			h_count					: in integer range 0 to 1023;
			v_count					: in integer range 0 to 1023;
			col_object				: out main_object := DEFAULT_OBJ;
			col_object_array		: in collision_obj_arr(0 to num_collision_objects -1);
			score_signal			: out score := DEFAULT_SCORE;		
			draw_element: out draw_object:= DEFAULT_DRAW
		);
	
end ball;

architecture Behavioral of ball is
	-- Create a ball object
	signal ball_obj: main_object := DEFAULT_OBJ;
	
	-- Declare constants
	constant DEFAULT_SPEED_X	: integer := 5;
	constant DEFAULT_SPEED_Y	: integer := 5;
	
	-- Declare Field parameters
	constant FIELD_SIDE			: integer := 10;
	constant BORDER_WIDTH		: integer := 10;
	constant WALL_SPACE			: integer := 10;
	
	-- 	***	Declare Play_Area		***
	-- NOTE: Top border starts at index 10 and has a height of 10
	-- 		Similar case with Bottom border. 
	--			(i.e starts at index 470 and has a height of 10.
	-- Define field border constants
	constant PLAY_AREA_TOP			: integer := FIELD_SIDE + BORDER_WIDTH;
	constant PLAY_AREA_BOTTOM		: integer := Y_ACTIVE -(FIELD_SIDE + BORDER_WIDTH);
	constant PLAY_AREA_LEFT			: integer := FIELD_SIDE + BORDER_WIDTH;
	constant PLAY_AREA_RIGHT		: integer := X_ACTIVE - (FIELD_SIDE + BORDER_WIDTH);
	
	-- Declare Goal Area
	constant GOAL_AREA_TOP			: integer := (Y_ACTIVE/2) + 100; 
	constant GOAL_AREA_BOTTOM		: integer := (Y_ACTIVE/2) - 100;
	
begin

	-- Map output port
	col_object <= ball_obj;

	-- Animate the ball to move
	move_ball: process(clk)
	
		-- Declare variables
		-- Counters
		variable clk_count: integer := 0;
		variable slow_down_factor: integer := 500000;
		
		-- Object Boundaries
		variable ball_obj_bounds: boundary;
		variable col_obj_bounds: boundary;
		 
		-- Score board
		variable score_board: score := DEFAULT_SCORE;
		
		-- Declare Goal Scenario Cases
		variable GOAL_LEFT_NET_CASE 			: boolean := false;
		variable GOAL_RIGHT_NET_CASE			: boolean := false;
		variable GOAL_AREA_NET_CASE			: boolean := false;
		
	begin
		if( rising_edge(clk) ) then
			
			-- ** Initialization **
			if( reset = '1' ) then 
				
				-- Create ball dimensions & positions
				ball_obj.height <= 2 * ball_radius;
				ball_obj.width <= 2 * ball_radius;
				ball_obj.pos <= CENTER;
				
				-- Give ball a intial direction upon start-up
				ball_obj.vel.vel_x <= DEFAULT_SPEED_X;
				ball_obj.vel.vel_y <= DEFAULT_SPEED_Y;
				
			
			-- Handle ball moving
			else
				
				-- Note: Used a slower clk frequency so that the ball will update at
				--			a more appropriate speed. It would appear as if teleportation occured
				--       if the same clock frequency was used. 
				if( clk_count >= slow_down_factor ) then
					
					-- Update ball boundary
					ball_obj_bounds := set_boundary(ball_obj);
										
					-- Set Goal Scenario Cases
					GOAL_AREA_NET_CASE	:= ball_obj_bounds.top >= GOAL_AREA_TOP and
													ball_obj_bounds.bottom <= GOAL_AREA_BOTTOM;
					GOAL_LEFT_NET_CASE 	:= ball_obj_bounds.left <= PLAY_AREA_LEFT and 
													GOAL_AREA_NET_CASE;
					GOAL_RIGHT_NET_CASE 	:= ball_obj_bounds.right >= PLAY_AREA_RIGHT and 
													GOAL_AREA_NET_CASE;
					
					-- Determine if Player gets a point
					if( GOAL_LEFT_NET_CASE ) then
						
						-- Update Player_Right_Side Score
						score_board.right := score_board.right + 1;
						
						-- Reset position of ball
						ball_obj.pos <= CENTER;
				
						-- Give ball a intial direction upon start-up
						ball_obj.vel.vel_x <= DEFAULT_SPEED_X;
						ball_obj.vel.vel_y <= DEFAULT_SPEED_Y;
						
					elsif( GOAL_RIGHT_NET_CASE ) then
					
						-- Update Player_Left_Side Score
						score_board.left := score_board.left + 1;
						
						-- Reset position of ball
						ball_obj.pos <= CENTER;
				
						-- Give ball a intial direction upon start-up
						ball_obj.vel.vel_x <= DEFAULT_SPEED_X;
						ball_obj.vel.vel_y <= DEFAULT_SPEED_Y;
					end if;
					
					-- Map score to output
					score_signal <= score_board;
					
					-- Update ball boundary
					ball_obj_bounds := set_boundary(ball_obj);
					
					
					-- Reflect ball if it hits Play_Area borders
					-- Top Border
					if( ball_obj_bounds.top <= PLAY_AREA_TOP) then
						ball_obj.vel.vel_y <= ball_obj.vel.vel_y * (-1);
						
					-- Bottom Border
					elsif ( ball_obj_bounds.bottom >= PLAY_AREA_BOTTOM ) then
						ball_obj.vel.vel_y <= (-1) * (ball_obj.vel.vel_y);
					
					-- Left Boarder
					elsif( ball_obj_bounds.left <= PLAY_AREA_LEFT and not
							(GOAL_AREA_NET_CASE) ) then		
						ball_obj.vel.vel_x <= (-1) * (ball_obj.vel.vel_x);
					
					-- Right Boarder
					elsif ( ball_obj_bounds.right >= PLAY_AREA_LEFT and not
							(GOAL_AREA_NET_CASE) ) then
						ball_obj.vel.vel_x <= (-1) * (ball_obj.vel.vel_x);
					end if;
					
					clk_count :=  0;
				end if;
				clk_count :=  clk_count + 1;
	
			end if;
		end if;
	end process;
	
end Behavioral;

