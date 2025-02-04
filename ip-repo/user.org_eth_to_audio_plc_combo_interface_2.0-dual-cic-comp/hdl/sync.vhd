----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2022 02:57:28 PM
-- Design Name: 
-- Module Name: sync - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_sinal is
generic (
        STAGES :integer := 4
    );
    port (
        clk        :in  std_logic; 
        sig_in     :in  std_logic;
        sig_out     :out  std_logic
    );
end sync_sinal;

architecture Behavioral of sync_sinal is
signal delay: std_logic_vector(0 to STAGES - 1);

begin

dsync: process (clk)
begin
  if rising_edge(clk) then
    delay <= sig_in & delay(0 to STAGES - 2);
  end if;
end process;
sig_out <= delay(STAGES - 1);

end Behavioral;
