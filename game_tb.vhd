--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:27:28 11/23/2020
-- Design Name:   
-- Module Name:   E:/COE 758/Labs/Project2/Game_tb.vhd
-- Project Name:  Project2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Game
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE std.textio.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

library work;
use work.obj_package.ALL;

 
ENTITY Game_tb IS
END Game_tb;
 
ARCHITECTURE behavior OF Game_tb IS 
 
	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT video_controller
	port(
		
		clk			:	IN		STD_LOGIC;
		reset			:	IN		STD_LOGIC;
		draw_elems	:	IN		draw_obj_arr;
		
		-- VGA output signals 
		h_sync		:	OUT	STD_LOGIC;
		v_sync		:	OUT	STD_LOGIC;
		red			:	OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
		green 		:	OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
		blue			:	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		-- debug/intermediate signals
		h_pixel		: 	OUT  	INTEGER;
		v_pixel 		: 	OUT  	INTEGER

	);
	END COMPONENT;
    

   -- Inputs
   signal clk : std_logic;
	signal p1_controls : player_controls;
	signal p2_controls : player_controls;
   signal power : std_logic := '0';
	signal reset : std_logic := '0';

 	-- Outputs
   signal h_sync : std_logic;
   signal v_sync : std_logic;
   signal red : std_logic_vector(2 downto 0);
   signal green : std_logic_vector(2 downto 0);
   signal blue : std_logic_vector(1 downto 0);
   signal h_pixel : integer := 0;
   signal v_pixel : integer := 0;
	signal score : score := DEFAULT_SCORE;
	
	-- intermediate signals
	signal col_objects: collision_obj_arr(0 to 1) := (others => DEFAULT_OBJ);
	signal ball : main_object := DEFAULT_OBJ;
	signal draw_elements : draw_obj_arr (0 to 2) := (others => DEFAULT_DRAW);


   -- Clock period definitions
   constant clk_period : time := 10 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
		  
	uut1: video_controller PORT MAP (
          clk => clk,
			 reset => reset,
			 draw_elems => draw_elements,
          h_sync => h_sync,
          v_sync => v_sync,
          red => red,
          green => green,
          blue => blue,
			 h_pixel => h_pixel,
			 v_pixel => v_pixel
			);
		  
	p1: entity work.paddle 
	GENERIC MAP(
		paddle_side => left,
		rgb_color => "01100010"
	)
	PORT MAP (
			clk => clk,
			reset => reset,
			p_controls => p1_controls,
			h_count => h_pixel,
			v_count => v_pixel,
			col_object => col_objects(0),
			draw_element => draw_elements(0)
	);
	
	p2: entity work.paddle
		GENERIC MAP(
		paddle_side => right,
		rgb_color => "00001011"
	)
	PORT MAP (
		clk => clk,
		reset => reset,
		p_controls => p2_controls,
		h_count => h_pixel,
		v_count => v_pixel,
		col_object => col_objects(1),
		draw_element => draw_elements(1)
	);	  
	
	b: entity work.ball
--		GENERIC MAP(
--			rgb_color => "01101111"
--		)
		PORT MAP(
			reset	=> reset,
			clk => clk,
			h_count => h_pixel,
			v_count => v_pixel,
			col_object => ball,
			col_object_array => col_objects,
			score_signal => score,	
			draw_element => draw_elements(2)
		);

   -- Clock process definitions
	process(clk)
		file file_pointer: text is out "write.txt";
		variable line_el: line;
	begin
		if rising_edge(clk) then
			write(line_el, now);
			write(line_el, ":");
			write(line_el, " ");
			write(line_el, h_sync);
			write(line_el, " ");
			write(line_el, v_sync);
			write(line_el, " ");
			write(line_el, red);
			write(line_el, " ");
			write(line_el, green);
			write(line_el, " ");
			write(line_el, blue);
			writeline(file_pointer, line_el);
		end if;
	end process;
	
   clk_process : process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		
		wait for 10 ns;
		reset <= '1';
		wait for 100 ns;
		reset <= '0';

      -- insert stimulus here 
		
		p1_controls.up <= '1';
		wait for 40000000 ns;
		p2_controls.down <= '1';

      wait;
   end process;

END;
