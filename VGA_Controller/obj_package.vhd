library IEEE;
use IEEE.STD_LOGIC_1164.all;

package obj_package is
	
	-- Active Area Constants
	constant X_ACTIVE: integer := 640;
	constant Y_ACTIVE: integer := 480;
	
	--*** 						MY CODE						***--
	-- Define Custom Data Types (Similar to Type Def Struct in C)
	type coordinates is 
	record
		x					: integer;
		y 					: integer;
	end record;
	
	type velocity is 
	record
		vel_x				: integer;
		vel_y 			: integer;
	end record;
	
	type main_object is 
	record 	
		pos				: coordinates;
		width				: integer;
		height			: integer;
		vel				: velocity;
	end record;
	
	type boundary is 
	record
		left				: integer;
		right				: integer;
		top				: integer;
		bottom			: integer;
	end record;
	
	type draw is 
	record 
		-- NOTE: May need to change pixelOn type to STD_LOGIC
		pixelOn			: boolean;
		rgb				: std_logic_vector(7 downto 0);
	end record;
	
	type player_controls is
	record
		up 				: std_logic;
		down 				: std_logic;
	end record;


	-- Used to determine which side a paddle should be placed
	type position_side is (left, right);	
	
	-- Object Array 
	-- NOTE: **** MAY NEED THIS ***** 		
	type collision_obj_arr is array(natural range <>) of main_object; 
	
	
	-- ***		Define Constants				***--
	-- Default States of Objects
	constant default_obj: main_object := (pos => ORIGIN, width => 0, height => 0, vel => STATIC);
	constant default_draw: draw := (pixelOn => false, rgb => (others => '0'));
	
	-- Position Constants
	constant ORIGIN: coordinates := (x => 0, y => 0);
	constant CENTER: coordinates := (x => 319, y => 239);
	
	-- Speed Constant
	constant STATIC: velocity := (vel_x => 0, vel_y => 0);
	
	-- Declare Functions
	function set_boundary(colObject : main_object) return boundary;
	function check_collision_x( colObject_1, colObject_2 : main_object) return boolean;
	function check_collision_y( colObject_1, colObject_2 : main_object) return boolean;
	--*** 				END OF MY CODE						***--

end obj_package;

package body obj_package is
	
	
	function set_boundary( object : main_object) return boundary is 
		-- Declare Variables
		variable bounds: boundary;
		
		-- Declare Constants
		constant OBJ_LEFT_SIDE 		: integer := object.pos.x;
		constant OBJ_RIGHT_SIDE		: integer := object.pos.x + object.width -1;
		constant OBJ_TOP  			: integer:= object.pos.y;
		constant OBJ_BOTTOM  		: integer:= object.pos.y + object.height -1;
		
		begin 
			bound.left 			:= OBJ_LEFT_SIDE;
			bound.right 		:= OBJ_RIGHT_SIDE;
			bound.top 			:= OBJ_TOP;
			bound.right 		:= OBJ_BOTTOM; 
			
			return bounds;
	end set_boundary;
	
	function check_collision_x( object_1, object_2 : main_object) return boolean is
		-- Declare Variables
		variable object_1_bounds: boundary;
		variable object_2_bounds: boundary;
		
		-- Hit Scenarios
		-- Case 1: Right side of Object 1 hits Left side of Object 2
		-- Case 2: Left side of Object 1 hits Right side of Objec 2
		variable hit_case_1, hit_case_2: boolean;
		variable hit_1, hit_2, condition_1, condition_2: boolean;
		
		begin 
			-- Create boundaries for each object
			object_1_bounds := set_boundary(object_1);
			object_2_bounds := set_boundary(object_2);
			
			-- Set hit paramaters
			hit_1				:= object_1_bounds.right >= object_2_bounds.left;
			condition_1		:= object_1_bounds.right <= object_2_bounds.right;
			
			hit_2				:= object_1_bounds.left <= object_2_bounds.right;
			condition_2		:= object_1_bounds.left >= object_2_bounds.left;
			
			-- Create Hit Cases
			hit_case_1 		:= hit_1 AND condition_1;
			hit_case_2 		:= hit_2 AND condition_2;
			
			return( (hit_case_1) OR (hit_case_2) );
		
	end check_collision_x;
	
	
	function check_collision_y( object_1, object_2 : main_object) return boolean is
		-- Declare Variables
		variable object_1_bounds: boundary;
		variable object_2_bounds: boundary;
		
		-- Hit Scenarios
		-- Case 1: 
		-- Case 2: 
		variable hit_case_1, hit_case_2: boolean;
		variable hit_1, hit_2, condition_1, condition_2: boolean;
		
		begin 
			-- Create boundaries for each object
			object_1_bounds := set_boundary(object_1);
			object_2_bounds := set_boundary(object_2);
			
			-- Set hit paramaters
			hit_1				:= object_1_bounds.top <= object_2_bounds.bottom;
			condition_1		:= object_1_bounds.top >= object_2_bounds.top;
			
			hit_2				:= object_1_bounds.bottom >= object_2_bounds.top;
			condition_2		:= object_1_bounds.bottom <= object_2_bounds.bottom;
			
			-- Create Hit Cases
			hit_case_1 		:= hit_1 AND condition_1;
			hit_case_2 		:= hit_2 AND condition_2;
			
			return( (hit_case_1) OR (hit_case_2) );
		
	end check_collision_y;
	
	
end obj_package;
