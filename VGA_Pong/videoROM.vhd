----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:42:02 11/21/2021 
-- Design Name: 
-- Module Name:    videoROM - Behavioral 
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


entity videoROM is
	generic(
		add_width: integer := 1;
		data_width: integer := 8
	);
	
	Port ( 
		clk : in  STD_LOGIC;
		char_code : in  STD_LOGIC_VECTOR (add_width - 1 downto 0);
		index		:	in integer range 0 to 7;
		data_out : out  STD_LOGIC_VECTOR (data_width - 1 downto 0));
end videoROM;

architecture Behavioral of videoROM is
	
	-- 512x8 array, enough for 64 character codes
	type rom_type is array (0 TO (2 ** add_width * 8) - 1) of STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
	
	-- rom definition
	signal rom: rom_type := (
		-- char code 0: null
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		"00000000",
		-- char code 1: square
		"11111111",
		"11111111",
		"11111111",
		"11111111",
		"11111111",
		"11111111",
		"11111111",
		"11111111");
		-- TBD: add other symbols if needed

	begin
		process (clk)
			begin
				if (clk'event AND clk = '1') then
					data_out <= rom((to_integer(unsigned(char_code)) * 8) + index);
				end if;
		end process;

end Behavioral;

