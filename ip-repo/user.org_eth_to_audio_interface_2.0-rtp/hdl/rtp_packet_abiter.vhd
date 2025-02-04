----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/15/2019 03:08:36 PM
-- Design Name: 
-- Module Name: rtp_packet_abiter - Behavioral
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

entity rtp_packet_abiter is
generic (
        clk:  in std_logic;
     rst: in std_logic;
        
        SEQ_WIDTH :integer := 8;
        REQ_NUM :integer := 6
    );
Port (
SeqNumber1   :  in  std_logic_vector (SEQ_WIDTH-1 downto 0);
SeqNumber2   :  in  std_logic_vector (SEQ_WIDTH-1 downto 0);
SeqNumber3   :  in  std_logic_vector (SEQ_WIDTH-1 downto 0);
SeqNumber4   :  in  std_logic_vector (SEQ_WIDTH-1 downto 0);
SeqNumber5   :  in  std_logic_vector (SEQ_WIDTH-1 downto 0);
SeqNumber6   :  in  std_logic_vector (SEQ_WIDTH-1 downto 0);

fifo1Waiting :  in  std_logic;
fifo2Waiting :  in  std_logic;
fifo3Waiting :  in  std_logic;
fifo4Waiting :  in  std_logic;
fifo5Waiting :  in  std_logic;
fifo6Waiting :  in  std_logic;

fifo1Grant :    out std_logic;
fifo2Grant :    out std_logic;
fifo3Grant :    out std_logic;
fifo4Grant :    out std_logic;
fifo5Grant :    out std_logic;
fifo6Grant :    out std_logic;


SeqNumBusy_in  :in  std_logic
 );
end rtp_packet_abiter;

architecture Behavioral of rtp_packet_abiter is

component RTLTD_SLV_PIPELINE_SEARCH is
--Pipeline search, log(n)+1 clocks, n-1 comparators if data size is power of 2;
--Not to be used until thoroughly tested, it has not been!
 
  generic (
    C_MAX_DATA_SIZE : natural := 32;
    C_DATA_SIZE     : natural := 6;
    SEQ_WIDTH :integer := 8;
    C_LEN_BIT_SIZE     : natural := 4
    );
   
  port (
    aclk            : in  std_logic; --usual
    aresetn         : in  std_logic;  --culprits
    
    SeqNumber1   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber2   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber3   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber4   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber5   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    SeqNumber6   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
    
    fifo1Waiting :in  std_logic;
    fifo2Waiting :in  std_logic;
    fifo3Waiting :in  std_logic;
    fifo4Waiting :in  std_logic;
    fifo5Waiting :in  std_logic;
    fifo6Waiting :in  std_logic;
    
    find_min   : in std_logic;
    
    lowestIndex  :out std_logic_vector (SEQ_WIDTH-1 downto 0);
    done     : out std_logic
    
    );
     
end component;

signal lowestIndex  :std_logic_vector (SEQ_WIDTH-1 downto 0);
signal done     : std_logic; -- single cycle end pulse
begin

fifo1Grant <= '1' when fifo1Waiting='1';


FIND_LOWEST_SEQ_BUFFER : RTLTD_SLV_PIPELINE_SEARCH
--Pipeline search, log(n)+1 clocks, n-1 comparators if data size is power of 2;
--Not to be used until thoroughly tested, it has not been!
 
  generic map(
    C_MAX_DATA_SIZE => 32,
    C_DATA_SIZE  => 6,
    SEQ_WIDTH => 8,
    C_LEN_BIT_SIZE  => 4
    )
   
  port map (
    aclk => clk,
    aresetn  => rst,
    
    SeqNumber1 => SeqNumber1,
    SeqNumber2 => SeqNumber2,
    SeqNumber3 => SeqNumber3,
    SeqNumber4 => SeqNumber4,
    SeqNumber5 => SeqNumber5,
    SeqNumber6 => SeqNumber6,
    
    fifo1Waiting => fifo1Waiting,
    fifo2Waiting => fifo2Waiting,
    fifo3Waiting => fifo3Waiting,
    fifo4Waiting => fifo4Waiting,
    fifo5Waiting => fifo5Waiting,
    fifo6Waiting => fifo6Waiting,
    
    find_min   => '1',
    
    lowestIndex  => lowestIndex,
    done     => done
    
    );
     

end Behavioral;
