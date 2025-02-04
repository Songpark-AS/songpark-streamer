----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2019 08:46:14 PM
-- Design Name: 
-- Module Name: rtp_packet_buffer - Behavioral
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

entity rtp_packet_buffer is
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
        SeqNumber   :in  std_logic_vector (SEQ_WIDTH-1 downto 0);
        WClk        :in  std_logic;
	 
        Clear_in    :in  std_logic
    );
end rtp_packet_buffer;

architecture Behavioral of rtp_packet_buffer is

component DualClockFIFO is
        generic (
            DATA_WIDTH :integer := 8;
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
         
            Clear_in    :in  std_logic
        );
    end component;
    
    
    signal fifo1Empty, fifo1ReadEn, fifo1ReadClk, fifo1Full, fifo1WriteEn, fifo1WriteClk, fifo1Reset          :std_logic;
    signal fifo2Empty, fifo2ReadEn, fifo2ReadClk, fifo2Full, fifo2WriteEn, fifo2WriteClk, fifo2Reset          :std_logic;
    signal fifo3Empty, fifo3ReadEn, fifo3ReadClk, fifo3Full, fifo3WriteEn, fifo3WriteClk, fifo3Reset          :std_logic;
    signal fifo4Empty, fifo4ReadEn, fifo4ReadClk, fifo4Full, fifo4WriteEn, fifo4WriteClk, fifo4Reset          :std_logic;
    signal fifo5Empty, fifo5ReadEn, fifo5ReadClk, fifo5Full, fifo5WriteEn, fifo5WriteClk, fifo5Reset          :std_logic;
    signal fifo6Empty, fifo6ReadEn, fifo6ReadClk, fifo6Full, fifo6WriteEn, fifo6WriteClk, fifo6Reset          :std_logic;
    signal fifo1DataOut, fifo2DataOut, fifo3DataOut, fifo4DataOut, fifo5DataOut, fifo6DataOut                 :std_logic_vector(DATA_WIDTH-1 downto 0);
    signal fifo1DataIn, fifo2DataIn, fifo3DataIn, fifo4DataIn, fifo5DataIn, fifo6DataIn                       :std_logic_vector(DATA_WIDTH-1 downto 0);

begin






FIFO_Packet1 : DualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 10
    )
    port map (
        -- Reading port.
        Data_out    => fifo1DataOut,
        Empty_out   => fifo1Empty,
        ReadEn_in   => fifo1ReadEn,
        RClk        => fifo1ReadClk,
        
        -- Writing port.
        Data_in     => fifo1DataIn,
        Full_out    => fifo1Full,
        WriteEn_in  => fifo1WriteEn,
        WClk        => fifo1WriteClk,
     
        Clear_in    => fifo1Reset
    );
    
    
 FIFO_Packet2 : DualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 10
    )
    port map (
        -- Reading port.
        Data_out    => fifo2DataOut,
        Empty_out   => fifo2Empty,
        ReadEn_in   => fifo2ReadEn,
        RClk        => fifo2ReadClk,
        
        -- Writing port.
        Data_in     => fifo2DataIn,
        Full_out    => fifo2Full,
        WriteEn_in  => fifo2WriteEn,
        WClk        => fifo2WriteClk,
     
        Clear_in    => fifo2Reset
    );
    
    
    
    FIFO_Packet3 : DualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 10
    )
    port map (
        -- Reading port.
        Data_out    => fifo3DataOut,
        Empty_out   => fifo3Empty,
        ReadEn_in   => fifo3ReadEn,
        RClk        => fifo3ReadClk,
        
        -- Writing port.
        Data_in     => fifo3DataIn,
        Full_out    => fifo3Full,
        WriteEn_in  => fifo3WriteEn,
        WClk        => fifo3WriteClk,
     
        Clear_in    => fifo3Reset
    );
    
    
  FIFO_Packet4 : DualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 10
    )
    port map (
        -- Reading port.
        Data_out    => fifo4DataOut,
        Empty_out   => fifo4Empty,
        ReadEn_in   => fifo4ReadEn,
        RClk        => fifo4ReadClk,
        
        -- Writing port.
        Data_in     => fifo4DataIn,
        Full_out    => fifo4Full,
        WriteEn_in  => fifo4WriteEn,
        WClk        => fifo4WriteClk,
     
        Clear_in    => fifo4Reset
    );
    
    
    
    FIFO_Packet5 : DualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 10
    )
    port map (
        -- Reading port.
        Data_out    => fifo5DataOut,
        Empty_out   => fifo5Empty,
        ReadEn_in   => fifo5ReadEn,
        RClk        => fifo5ReadClk,
        
        -- Writing port.
        Data_in     => fifo5DataIn,
        Full_out    => fifo5Full,
        WriteEn_in  => fifo5WriteEn,
        WClk        => fifo5WriteClk,
     
        Clear_in    => fifo5Reset
    );  
    
    
    FIFO_Packet6 : DualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 10
    )
    port map (
        -- Reading port.
        Data_out    => fifo6DataOut,
        Empty_out   => fifo6Empty,
        ReadEn_in   => fifo6ReadEn,
        RClk        => fifo6ReadClk,
        
        -- Writing port.
        Data_in     => fifo6DataIn,
        Full_out    => fifo6Full,
        WriteEn_in  => fifo6WriteEn,
        WClk        => fifo6WriteClk,
     
        Clear_in    => fifo6Reset
    );  
    


end Behavioral;
