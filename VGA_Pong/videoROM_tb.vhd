--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:08:04 11/22/2021
-- Design Name:   
-- Module Name:   C:/Users/Sampson/Documents/School Stuff/COE758/project2_videogame/videoROM_tb.vhd
-- Project Name:  project2_videogame
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: videoROM
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY videoROM_tb IS
END videoROM_tb;
 
ARCHITECTURE behavior OF videoROM_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT videoROM
    PORT(
         clk : IN  std_logic;
         char_code : IN  std_logic_vector(0 downto 0);
         index : IN  integer range 0 to 7;
         data_out : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal char_code : std_logic_vector(0 downto 0) := (others => '0');
   signal index : integer := 0;

 	--Outputs
   signal data_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: videoROM PORT MAP (
          clk => clk,
          char_code => char_code,
          index => index,
          data_out => data_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		wait for 20 ns;
      -- insert stimulus here 
		char_code <= "1";
		index <= 3;
		wait for 20 ns;
		
		index <= 6;
		
		wait for 20 ns;
		
		
      wait;
   end process;

END;
