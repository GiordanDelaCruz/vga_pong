----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:21:00 11/10/2021 
-- Design Name: 
-- Module Name:    video_controller - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library work;
use work.obj_package.ALL;

entity video_controller is
	
	port(
		
		clk			:	IN		STD_LOGIC;
		reset			:	IN		STD_LOGIC;
		draw_elems	:	IN		draw_obj_arr;
		h_sync		:	OUT	STD_LOGIC;
		v_sync		:	OUT	STD_LOGIC;
		
		red			:	OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
		green 		:	OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
		blue			:	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		h_pixel		:	OUT	INTEGER;
		v_pixel		:	OUT	INTEGER
	);


end video_controller;

architecture Behavioral of video_controller is

	-- Define VGA Specifications
	-- Horizontal Parameters
	constant H_ACTIVE_AREA: natural := 640;
	constant H_FRONT_PORCH: natural := 16;
	--constant H_ACTIVE_END: natural := H_BACK_PORCH + H_ACTIVE_AREA;
	constant H_SYNC_PULSE: natural := 96;
	constant H_BACK_PORCH: natural := 48;
	constant H_SYNC_START: natural := H_ACTIVE_AREA + H_FRONT_PORCH;
	constant H_SYNC_END: natural := H_ACTIVE_AREA + H_FRONT_PORCH + H_SYNC_PULSE;
	constant H_SYNC_CYCLE: natural := H_ACTIVE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
	
	-- Vertical Parameters
	constant V_ACTIVE_AREA: natural := 480;
	constant V_FRONT_PORCH: natural := 10;
	--constant V_ACTIVE_END: natural := V_BACK_PORCH + V_ACTIVE_AREA;
	constant V_SYNC_PULSE: natural := 2;
	constant V_BACK_PORCH: natural := 33;
	constant V_SYNC_START: natural := V_ACTIVE_AREA + V_FRONT_PORCH;
	constant V_SYNC_END: natural := V_ACTIVE_AREA + V_FRONT_PORCH + V_SYNC_PULSE;
	constant V_SYNC_CYCLE: natural := V_ACTIVE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;
	
	-- Game Field Parameters
	constant PLAY_AREA_TOP : integer := 15;
	constant PLAY_AREA_BOTTOM: integer := 465;
	constant PLAY_AREA_LEFT: integer := 30;
	constant PLAY_AREA_RIGHT: integer := 610;
	constant WALL_THICKNESS : integer := 10;
	
	-- Global Constants 
	constant ROM_add_width: integer := 1;
	constant ROM_data_width: integer := 8;
	
	-- For use in video ROM
	signal char_code : STD_LOGIC_VECTOR(ROM_add_width - 1 DOWNTO 0) := (others => '0');
	signal index		: integer range 0 to 7 := 0;
	signal rom_out : STD_LOGIC_VECTOR(ROM_data_width - 1 downto 0) := (others => '0');
	signal shift_reg : STD_LOGIC_VECTOR(ROM_data_width - 1 downto 0) := (others => '0');
	
	-- Flag for whether the current pixel needs to be drawn
	signal pixelOn : STD_LOGIC := '0';
	
	-- video clock signal for slowing down the output of the pixels
	signal video_clk : STD_LOGIC := '0';
	
	-- signals for the x and y coordinate we're currently drawing, defaulted to the end of the active area
	signal h_count: natural := H_ACTIVE_AREA - 1;
	signal v_count: natural := V_ACTIVE_AREA - 1;
	
	begin
		
		-- entity declaration for video ROM
		symbolROM: entity work.videoROM
		port map(
			clk => clk,
			index => index,
			char_code => char_code,
			data_out => rom_out
		);
		
		clkDiv: entity work.clock_divider
		port map(
			clk_in => clk,
			reset => reset,
			clk_out => video_clk
		);
		
		process (video_clk)
		
			-- variable to easily set and change RGB value
			variable rgb : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
			
			begin
			
			if rising_edge(video_clk) then
			
-- 			Handles h_count and v_count incrementing every cycle and 
-- 			staying within the VGA size of 800x525
				if(h_count < H_SYNC_CYCLE) then
					h_count <= h_count + 1;
				else 
					h_count <= 0;
					if(v_count < V_SYNC_CYCLE) then
						 v_count <= v_count + 1;
					else
						 v_count <= 0;
					end if;
				end if;
				
			  
-- 			Handles the h_sync and v_sync pulses
				if(h_count >= H_SYNC_START and h_count < H_SYNC_END) then
					h_sync <= '0';
				else 
					h_sync <= '1';
				end if;
				
				if(v_count >= V_SYNC_START and v_count < V_SYNC_END) then
					v_sync <= '0';
				else 
					v_sync <= '1';
				end if;
				
				
-- 			Write signal to VGA output within active area
-- 			NOTE: H_BACK_PORCH is the start of the active area
				if (h_count >= 0 AND h_count < H_ACTIVE_AREA AND 
					 v_count >= 0 AND v_count < V_ACTIVE_AREA) THEN
					
					rgb := "00011100";
					
					-- center line
					if ((h_count >= 318 AND h_count < 322) AND
						(v_count >= PLAY_AREA_TOP AND v_count < PLAY_AREA_BOTTOM)) then
						rgb := "01100001";
						--report "center line " & integer'image(h_count) & integer'image(v_count);
					end if;
					
					
					-- borders
					-- Top and bottom borders
					if ((v_count >= PLAY_AREA_TOP - WALL_THICKNESS AND v_count < PLAY_AREA_TOP) OR 
						(v_count >= PLAY_AREA_BOTTOM AND v_count < PLAY_AREA_BOTTOM + WALL_THICKNESS)) and 
						(h_count >= PLAY_AREA_LEFT - (2 * WALL_THICKNESS) AND h_count < PLAY_AREA_RIGHT + (2 * WALL_THICKNESS)) then
						rgb := "11111111";
						--report "top/bottom border line " & integer'image(h_count) & integer'image(v_count);
					end if;
					
					-- Left and right borders
					if ((h_count >= PLAY_AREA_LEFT - (2 * WALL_THICKNESS) AND h_count < PLAY_AREA_LEFT - WALL_THICKNESS) OR 
						(h_count >= PLAY_AREA_RIGHT + WALL_THICKNESS AND h_count < PLAY_AREA_RIGHT + (2 * WALL_THICKNESS))) AND 
						(v_count >= PLAY_AREA_TOP AND v_count < PLAY_AREA_BOTTOM) then
						rgb := "11111111";
						--report "left/right border line " & integer'image(h_count) & integer'image(v_count);
					end if;
					
					for i in draw_elems'range loop
						if draw_elems(i).pixelOn then
							rgb := draw_elems(i).rgb;
						end if;
					end loop;
					
					
					red <= rgb(7 DOWNTO 5);
					green <= rgb(4 DOWNTO 2);
					blue <= rgb(1 DOWNTO 0);
				end if;
			end if;
			
			h_pixel <= h_count;
			v_pixel <= v_count;
			
		end process;
		
--		draw: process (clk)
--		begin
--			if rising_edge(clk) then
--			
--				if (symbol.pixelOn = true) then
--					
--				end if;
--			
--			end if;
--		end process;
		
	end Behavioral;

