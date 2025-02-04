----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/04/2020 06:50:32 PM
-- Design Name: 
-- Module Name: interpolator_basic - Behavioral
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
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee_proposed.math_utility_pkg.all;
--use ieee_proposed.fixed_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity interpolator_basic is
generic( AUDIO_WIDTH  : integer := 24
);
  Port ( 
  audio_in            : in STD_LOGIC_VECTOR(AUDIO_WIDTH-1 downto 0);
  in_newsample           : in    STD_LOGIC;
  out_newsample           : in    STD_LOGIC;
  reset_in                    : in    STD_LOGIC;
  audio_out            : out STD_LOGIC_VECTOR(AUDIO_WIDTH-1 downto 0)
  
  );
end interpolator_basic;

architecture Behavioral of interpolator_basic is

signal audio_last : signed(AUDIO_WIDTH-1 downto 0);
signal audio_sum : signed(AUDIO_WIDTH downto 0);

signal audio_avg : signed(AUDIO_WIDTH-1 downto 0);

signal int_sample           :    STD_LOGIC := '0';

begin


set_last: process(in_newsample, reset_in)
begin
    if reset_in = '1'  then
        audio_last <= (others=>'0');      
    elsif rising_edge (in_newsample) then   
    
        audio_last <= signed(audio_in);   
          
    end if;
end process;


get_avg: process(out_newsample, reset_in)
begin
    if reset_in = '1'  then
        audio_sum <= (others=>'0');  
        int_sample <= '0';    
    elsif rising_edge (out_newsample) then   
    
        --audio_sum <= signed(audio_in) + audio_last;
        --sum <= ('0' & operand1) + ('0' & operand2); -- unsigned
        --sum <= (operand1(N-1) & operand1) + (operand2(N-1) & operand2); -- signed
        audio_sum <= resize(signed(audio_in), audio_sum'length) + resize(audio_last, audio_sum'length);
         
        
        int_sample <= int_sample xor '1';       
          
    end if;
end process;

audio_out <= audio_in when (int_sample = '0') else STD_LOGIC_VECTOR(audio_sum(24 downto 1));

end Behavioral;
