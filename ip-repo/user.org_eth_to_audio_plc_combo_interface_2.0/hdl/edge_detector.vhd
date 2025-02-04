library ieee;
use ieee.std_logic_1164.all;
entity edge_detector is
port (
  i_clk                       : in  std_logic;
  i_rst                      : in  std_logic;
  i_input                     : in  std_logic;
  o_pos_edge                     : out std_logic;
  o_neg_edge                     : out std_logic);
end edge_detector;
architecture rtl of edge_detector is
signal r0_input                           : std_logic;
signal r1_input                           : std_logic;
begin
p_rising_edge_detector : process(i_clk,i_rst)
begin
  if(i_rst='1') then
    r0_input           <= '0';
    r1_input           <= '0';
  elsif(rising_edge(i_clk)) then
    r0_input           <= i_input;
    r1_input           <= r0_input;
  end if;
end process p_rising_edge_detector;
o_pos_edge            <= not r1_input and r0_input;
o_neg_edge            <= not r0_input and r1_input;
end rtl;
