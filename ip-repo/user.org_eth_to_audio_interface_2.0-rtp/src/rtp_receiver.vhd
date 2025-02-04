----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2019 08:39:21 PM
-- Design Name: 
-- Module Name: rtp_receiver - Behavioral
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

entity rtp_receiver is
    generic (
        DATA_WIDTH :integer := 8;
        ADDR_WIDTH :integer := 4;
        SEQ_WIDTH :integer := 8
    );
    port (
        -- Reading port.
        Data_out    :out std_logic_vector (DATA_WIDTH-1 downto 0);
        Empty_out   :out std_logic;
        ReadEn_in   :in  std_logic;
        RClk        :in  std_logic;
        -- Writing port.
        Data_in     :in  std_logic_vector (DATA_WIDTH-1 downto 0);
        Full_out    :out std_logic;
        WriteEn_in  :in  std_logic;
        WClk        :in  std_logic;
        
        SeqNumber   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
        SeqNumWriteEn_in  :in  std_logic;
        pktEnd_in  :in  std_logic;
	 
        Clear_in    :in  std_logic
    );
end rtp_receiver;

architecture Behavioral of rtp_receiver is

component rtp_packet_buffer is
generic (
        DATA_WIDTH :integer := 8;
        SEQ_WIDTH :integer := 8;
        ADDR_WIDTH :integer := 4
    );
    port (
        -- Reading port.
        Data_out    :out std_logic_vector (DATA_WIDTH-1 downto 0);
        Empty_out   :out std_logic;
        ReadEn_in   :in  std_logic;
        RClk        :in  std_logic;
        -- Writing port.
        Data_in     :in  std_logic_vector (DATA_WIDTH-1 downto 0);
        Full_out    :out std_logic;
        WriteEn_in  :in  std_logic;
      
        WClk        :in  std_logic;
        
        SeqNumber   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
        SeqNumWriteEn_in  :in  std_logic;
        
	 
        Clear_in    :in  std_logic
    );
end component;

 signal fifoEmpty, fifoReadEn, fifoReadClk, fifoFull, fifoWriteEn, fifoWriteClk, fifoReset          :std_logic;
 signal fifoDataOut, fifoDataIn                :std_logic_vector(DATA_WIDTH-1 downto 0);
 signal SeqNumberSig   : std_logic_vector (SEQ_WIDTH-1 downto 0);
 signal CurrSeqNumber   : std_logic_vector (SEQ_WIDTH-1 downto 0);
 signal PrevSeqNumber   : std_logic_vector (SEQ_WIDTH-1 downto 0);
 signal ArbSeqNumber   : std_logic_vector (SEQ_WIDTH-1 downto 0);

begin

RTP_PKT_PRIORITY_FIFO : rtp_packet_buffer
    generic map (
        DATA_WIDTH => 24,
        SEQ_WIDTH => 16,
        ADDR_WIDTH => 15
    )
    port map (
        -- Reading port.
        Data_out    => fifoDataOut,
        Empty_out   => fifoEmpty,
        ReadEn_in   => fifoReadEn,
        RClk        => fifoReadClk,
        
        -- Writing port.
        Data_in     => fifoDataIn,
        Full_out    => fifoFull,
        WriteEn_in  => fifoWriteEn,
        WClk        => fifoWriteClk,        
        SeqNumber   => SeqNumber,  
        SeqNumWriteEn_in => SeqNumWriteEn_in,   
        Clear_in    => fifoReset
    );
 SeqNumberSig <= SeqNumber when SeqNumWriteEn_in='1' else SeqNumberSig;
 
 

end Behavioral;
