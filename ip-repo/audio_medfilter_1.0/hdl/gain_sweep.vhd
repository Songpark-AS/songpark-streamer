----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2020 07:26:44 PM
-- Design Name: 
-- Module Name: gain_sweep - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Gain_Sweep is
    generic ( INTBIT_WIDTH    	:   integer;
			 FRACBIT_WIDTH		:	 integer;
			 STEP_WIDTH			: integer
			 ); 
		port(
			--		OUT_VOLCTRL_L : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); -- 24 bit signed output
--		OUT_VOLCTRL_R : out signed((INTBIT_WIDTH - 1) downto 0) := (others => '0'); -- 24 bit signed output
		OUT_RDY       : out STD_LOGIC;
		
		fade_enable_in       : in STD_LOGIC;
		fade_direction_in    : in STD_LOGIC;
		fade_clear_in        : in STD_LOGIC;
		
		fade_max_in          : in STD_LOGIC;
		fade_min_in          : in STD_LOGIC;
		
		new_sample_in        : in STD_LOGIC;
		replace_in_progress_in    : in STD_LOGIC;
		

--		IN_SIG_L      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
--		IN_SIG_R      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
		UP_STEP_PULSES	: in std_logic_vector(STEP_WIDTH-1 downto 0);
		DOWN_STEP_PULSES	: in std_logic_vector(STEP_WIDTH-1 downto 0);
		IN_COEF_MIN     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		IN_COEF_MAX     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		OUT_COEF     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		
		CLK_HI_IN    : in  STD_LOGIC;
		RESET         : in  STD_LOGIC
		);
end Gain_Sweep;

architecture Behavioral of Gain_Sweep is

--signal OUT_COEF_UP     : signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0) := (others => '0');
--signal OUT_COEF_DOWN     : signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0) := X"0000_00C0";
signal OUT_COEF_REG    : signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0) := X"0000_00C0";
--signal DOWN_STEP_PULSES_COUNTER, UP_STEP_PULSES_COUNTER	: unsigned(STEP_WIDTH-1 downto 0) := (others => '0');
 signal newsample_reg, newsample_change, newsample_rdy : std_logic := '0';
    signal newsample_125 : std_logic := '0';


begin
 
 
 newsample_delay: process(CLK_HI_IN,fade_clear_in)
begin
    if fade_clear_in = '1'   then
        newsample_reg <= '0';        
    elsif rising_edge (CLK_HI_IN) then
        newsample_reg <= new_sample_in;
    end if;
end process;

newsample_125 <= (new_sample_in xor newsample_reg) when (new_sample_in = '1') else '0';

	sweep : process(CLK_HI_IN, newsample_125, fade_clear_in, fade_min_in, fade_max_in)
	begin
		if fade_clear_in = '1' then
--	      OUT_COEF_DOWN <=  X"0000_00C0";
--	      OUT_COEF_UP  <= X"0000_00C0";
            OUT_COEF_REG <= X"0000_00C0";
--	      UP_STEP_PULSES_COUNTER <= (others => '0');
--	      DOWN_STEP_PULSES_COUNTER <= (others => '0');
	    elsif rising_edge(CLK_HI_IN) then
	       
	       if fade_min_in ='0' and fade_max_in = '0' then
	       
                if (newsample_125  = '1') then
                
                
                    --  update the ready signal when new values gets written to the buffer
                    --if (fade_direction_in = '0' and OUT_COEF_UP < X"0000_0120" and (UP_STEP_PULSES_COUNTER >= unsigned(UP_STEP_PULSES))) then
                    if (fade_direction_in = '0' and OUT_COEF_REG < X"0000_00C0") then
                        OUT_COEF_REG <= OUT_COEF_REG + 2;
    --					UP_STEP_PULSES_COUNTER <= UP_STEP_PULSES_COUNTER + 1;
--                        OUT_COEF_DOWN <=  OUT_COEF_UP;
                    elsif(fade_direction_in = '1' and OUT_COEF_REG > X"0000_0000") then
                        OUT_COEF_REG <= OUT_COEF_REG - 2;
    --					DOWN_STEP_PULSES_COUNTER <= DOWN_STEP_PULSES_COUNTER + 1;
--                        OUT_COEF_UP  <= OUT_COEF_DOWN ;
                    else
                        OUT_COEF_REG <= OUT_COEF_REG;
    --					UP_STEP_PULSES_COUNTER <= (others => '0');
    --					DOWN_STEP_PULSES_COUNTER <= (others => '0');
--                        OUT_COEF_DOWN <= OUT_COEF_DOWN;
                    end if;
                    
                else    
                    OUT_COEF_REG <= OUT_COEF_REG;
--                    OUT_COEF_UP <= OUT_COEF_UP;
--                    OUT_COEF_DOWN <= OUT_COEF_DOWN;
                    
                end if;
			
			else
			     if fade_max_in = '1' then
			         OUT_COEF_REG <=  X"0000_00C0";
--	                 OUT_COEF_UP  <= X"0000_00C0";
			     elsif fade_min_in = '1' then
			         OUT_COEF_REG <=  X"0000_0000";
--	                 OUT_COEF_UP  <= X"0000_0000";
	             else
	               OUT_COEF_REG <= OUT_COEF_REG;
--	               OUT_COEF_DOWN <= OUT_COEF_DOWN;
--	               OUT_COEF_UP <= OUT_COEF_UP;
			     end if;
			end if;
			
		end if;
	end process;
	
	

	
	
--	OUT_COEF <= OUT_COEF_UP when (fade_direction_in = '0' and fade_enable_in = '1') else OUT_COEF_DOWN  when (fade_direction_in = '1' and fade_enable_in = '1') else X"0000_0000";-- factor == 1:: This is assumming the coefficient if frac=8bits int=24bits
    OUT_COEF <= OUT_COEF_REG when fade_enable_in = '1' else X"0000_0000";

end Behavioral;
