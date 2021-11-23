----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:56:04 11/20/2021 
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
    Port ( clk : in  STD_LOGIC;
           red : in  STD_LOGIC;
           blue : in  STD_LOGIC;
           green : in  STD_LOGIC;
           row_index : out integer;
           column_index : out integer;
           Rout : out  STD_LOGIC;
           Gout : out  STD_LOGIC;
           Bout : out  STD_LOGIC;
           H : out  STD_LOGIC;
           V : out  STD_LOGIC);
end game;

architecture Behavioral of game is
-- Define VGA Specifications

-- Horizontal Parameters
constant H_BACK_PORCH: natural := 48;
constant H_ACTIVE_AREA: natural := 640;
constant H_FRONT_PORCH: natural := 16;
constant H_SYNC_PULSE: natural := 96;
constant H_SYNC_START: natural := H_BACK_PORCH + H_ACTIVE_AREA;
constant H_SYNC_END: natural := H_BACK_PORCH + H_ACTIVE_AREA + H_FRONT_PORCH;
constant H_SYNC_CYCLE: natural := H_BACK_PORCH +  H_ACTIVE_AREA + H_FRONT_PORCH + H_SYNC_PULSE;

-- Vertical Parameters
constant V_BACK_PORCH: natural := 33;
constant V_ACTIVE_AREA: natural := 480;
constant V_FRONT_PORCH: natural := 10;
constant V_SYNC_PULSE: natural := 2;
constant V_SYNC_START: natural := V_BACK_PORCH + V_ACTIVE_AREA;
constant V_SYNC_END: natural := V_BACK_PORCH + V_ACTIVE_AREA + V_FRONT_PORCH;
constant V_SYNC_CYCLE: natural := V_BACK_PORCH +  V_ACTIVE_AREA + V_FRONT_PORCH + V_SYNC_PULSE;

begin
	
	-- Set output siganals
	Rout <= red;
	Gout <= green;
	Bout <= blue;
	
	process(clk) 
		-- Define Variables 
		variable h_count, v_count : integer := 0;
		
	begin
		
		-- Increment counters
		if( h_count < (H_SYNC_CYCLE - 1) ) then
			h_count := h_count + 1;
			
		-- End of column
		else 
		
			-- Reset h_count
			h_count := 0;
			
			-- Check if this is end of frame
			if( v_count < (V_SYNC_CYCLE - 1) ) then
			
				-- Go to next row
				v_count := v_count + 1;
			else
				-- Reset v_count
				v_count := 0;
			
			end if;
		end if;
		
		-- NOTE: My H_pulse and V_pulse may be wrong for the H_SYNC_END and V_SYNC_END values
		-- Define H pulse
		if( h_count >= H_SYNC_START and h_count < H_SYNC_END) then
			H <= '1';
		else 
			H <= '0';
		end if;
		
		-- Define V pulse
		if( v_count >= V_SYNC_START and v_count < V_SYNC_END) then
			V <= '1';
		else 
			V <= '0';
		end if;
		
		-- location of current pixel
		row_index <= v_count; 
		column_index <= h_count;
		
	end process;

end Behavioral;

