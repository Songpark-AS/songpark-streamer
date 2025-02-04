------------------------------------------------------------
--
------------------------------------------------------------
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;
    
entity DualClockLIFO is
    generic (
        DATA_WIDTH :integer := 8;
        ADDR_WIDTH :integer := 4
    );
    port (
        -- Reading port.
        Data_out    :out std_logic_vector (DATA_WIDTH-1 downto 0);
        PktEnd_out        :out  std_logic;
        Empty_out   :out std_logic;
        ReadEn_in   :in  std_logic;
        RClk        :in  std_logic;        
        Replace_pkt_in        :in  std_logic;
        Replace_inprogress_in        :in  std_logic; --- This can also do Replace_overlap by prolonging it until the end of the first packet
        
        -- Writing port.
        Data_in     :in  std_logic_vector (DATA_WIDTH-1 downto 0);
        Full_out    :out std_logic;
        WriteEn_in  :in  std_logic;
        WClk        :in  std_logic;
        PktEnd_in        :in  std_logic;
        
        
	    fifo_occ_out            : out unsigned(ADDR_WIDTH-1 downto 0);
        Clear_in    :in  std_logic
        
    );
end entity;

architecture rtl of DualClockLIFO is
    ----/Internal connections & variables------
    constant FIFO_DEPTH :integer := 2**ADDR_WIDTH;

    type RAM is array (integer range <>)of std_logic_vector (DATA_WIDTH downto 0);
    signal Mem : RAM (0 to FIFO_DEPTH);
    signal Data_out_tmp    :std_logic_vector (DATA_WIDTH downto 0);
    
    signal pNextWordToWrite     :std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal pNextWordToRead      :std_logic_vector (ADDR_WIDTH-1 downto 0);
    signal EqualAddresses       :std_logic;
    signal NextWriteAddressEn   :std_logic;
    signal NextReadAddressEn    :std_logic;
    signal Set_Status           :std_logic;
    signal Rst_Status           :std_logic;
    signal Status               :std_logic;
    signal PresetFull           :std_logic;
    signal PresetEmpty          :std_logic;
    signal empty,full           :std_logic;
    signal fifo_writes,  fifo_reads, fifo_reads_125, fifo_reads_125_tmp, fifo_reads_125_tmp1, fifo_occ  : unsigned(ADDR_WIDTH-1 downto 0);
    
    component GrayCounterC is
    generic (
        COUNTER_WIDTH :integer := 4
    );
    port (
        GrayCount_out :out std_logic_vector (COUNTER_WIDTH-1 downto 0);
        BinaryCount_in   :in std_logic_vector (COUNTER_WIDTH-1 downto 0); 
        Enable_in     :in  std_logic;  --Count enable.
        Clear_in      :in  std_logic;  --Count reset.
        clk           :in  std_logic
    );
    end component;
    
    component synchronizer is
    generic ( 
    STAGES : natural := 4
    );
    Port ( clk : in STD_LOGIC;
           i : in STD_LOGIC;
           o : out STD_LOGIC);
    end component;

signal BinaryCountRd   : unsigned (ADDR_WIDTH-1 downto 0); 
signal BinaryCountWr   : unsigned  (ADDR_WIDTH-1 downto 0);
signal LastBinaryCountRdPkt   : unsigned  (ADDR_WIDTH-1 downto 0); 
signal BinaryCountRdCache   : unsigned  (ADDR_WIDTH-1 downto 0); 

signal PktCountRd   : unsigned (ADDR_WIDTH-1 downto 0); 
signal PktCountWr   : unsigned (ADDR_WIDTH-1 downto 0);

signal RdCached, RdCachedCaptured        :std_logic := '0';
--signal PktEnd_occ        :std_logic := '1';
signal Replace_inprogress_reg  :std_logic := '0';
signal Replace_inprogress_pos_edge  :std_logic := '0';
signal Replace_inprogress_neg_edge  :std_logic := '0';


signal Replace_inprogress_reg_rclk  :std_logic := '0';
signal Replace_inprogress_pos_edge_rclk  :std_logic := '0';
signal Replace_inprogress_neg_edge_rclk  :std_logic := '0';

signal updateWrPktCount, cacheNextReadPktPtr, clearReadCache,updateRdPktCount, loopRdPktCount, updateLastRdPktCount         :std_logic := '0';
signal PktEnd_rd_pos_edge, PktEnd_rd_reg, PktEnd_rd, PktEnd_ph        : std_logic;
signal Data_to_Wr     : std_logic_vector (DATA_WIDTH downto 0);

begin

    --------------Code--------------/
    --Data ports logic:
    --(Uses a dual-port RAM).
    --'Data_out' logic:
--    process (Clear_in,RClk) begin
--        if Clear_in = '1' then
--            fifo_reads <=  (others=>'0');
--            BinaryCountRd   <= conv_std_logic_vector(1, ADDR_WIDTH); 
--        else
--        if (rising_edge(RClk)) then
--            if (ReadEn_in = '1' and empty = '0') then
--                Data_out <= Mem(conv_integer(pNextWordToRead));
--                fifo_reads <= fifo_reads + 1;
--                BinaryCountRd   <= BinaryCountRd - 1;
--            end if;
--        end if;
--         end if;
--    end process;
            
--    --'Data_in' logic:
--    process (Clear_in, WClk) begin
--        if Clear_in = '1' then
--            fifo_writes <=  (others=>'0');
--            BinaryCountWr   <= conv_std_logic_vector(1, ADDR_WIDTH); 
--        else
--        if (rising_edge(WClk)) then
--            if (WriteEn_in = '1' and full = '0') then
--                Mem(conv_integer(pNextWordToWrite)) <= Data_in;
--                fifo_writes <= fifo_writes + 1;
--                BinaryCountWr   <= BinaryCountWr + 1;
--            end if;
--        end if;
--         end if;
--    end process;


 process (Clear_in, WClk) begin
        if Clear_in = '1' then
            PktCountRd <= (others=>'0');
            updateLastRdPktCount <= '0';
        else
            
            if (rising_edge(WClk)) then
                if (updateRdPktCount = '1') then
--                    LastBinaryCountRdPkt <= BinaryCountRd+1; -- the last address is +1 because we subtract to advance
                    PktCountRd <= PktCountRd +1;  
                    updateLastRdPktCount <= '1';              
                elsif(Replace_inprogress_neg_edge_rclk = '1') then
                    PktCountRd <= (others=>'0');
                elsif(loopRdPktCount = '1') then
                    PktCountRd <= PktCountRd - 1;-- this is a cheat to clear empty flag to that we can loop
                else
                    
                    PktCountRd <= PktCountRd;
                end if;
                
                
                if (updateLastRdPktCount = '1'  and (PktCountWr - PktCountRd = 1)) then
                    LastBinaryCountRdPkt <= BinaryCountRd+1; -- the last address is +1 because we subtract to advance
                    updateLastRdPktCount <= '0'; 
                elsif(updateRdPktCount = '1') then
                    updateLastRdPktCount <= '1'; 
                else
                    updateLastRdPktCount <= '0'; 
                    LastBinaryCountRdPkt <= LastBinaryCountRdPkt;
                end if;
            end if;
            
        end if;
       
 end process;   
    
--    updateRdPktCount <= '1' when (ReadEn_in = '1' and empty = '0') and (Data_out_tmp(Data_out_tmp'left) = '1') else '0';
    updateRdPktCount <= '1' when (ReadEn_in = '1' and empty = '0') and (PktEnd_rd_pos_edge = '1') else '0';
    loopRdPktCount <= '1' when (ReadEn_in = '1' and empty = '1') else '0';
    
    
    process (Clear_in,RClk) begin
        if Clear_in = '1' then
            fifo_reads <=  (others=>'0');
            Data_out_tmp <= (others=>'0');
--            fifo_writes <=  (others=>'0');
--            PktEnd_occ <= '1';
--            PktCountRd <= (others=>'0');
            --BinaryCountWr   <= conv_std_logic_vector(1, ADDR_WIDTH); do not use conv_std_logic_vector requires use IEEE.std_logic_arith.ALL which is pure evil
            --BinaryCountRd   <= conv_std_logic_vector(1, ADDR_WIDTH); 
--            BinaryCountRd   <=  std_logic_vector(to_unsigned(1, ADDR_WIDTH));  -- CHANGED THIS
            BinaryCountRd   <=  to_unsigned(1, ADDR_WIDTH);  -- CHANGED THIS
        else
            if (rising_edge(RClk)) then
                if (ReadEn_in = '1' and empty = '0') then  
                                    
                    Data_out_tmp <= Mem(conv_integer(pNextWordToRead));
                    fifo_reads <= fifo_reads + 1;
                    BinaryCountRd   <= BinaryCountRd - 1;                  
                    
                elsif(empty = '1') then
                    fifo_reads <= fifo_reads;
                    BinaryCountRd <= LastBinaryCountRdPkt; -- loop back
                else
                    fifo_reads <= fifo_reads;
                    BinaryCountRd   <= BinaryCountRd;
                end if;
                
                
                
                
            end if;
            
            if(RdCached  = '1') then      
                RdCachedCaptured <= '1';                   
               BinaryCountRd <=         BinaryCountRdCache;
            else
             RdCachedCaptured <= '0'; 
            end if;
        
         end if;
    end process;
    
    
    Data_to_Wr <= PktEnd_ph & Data_in;
    updateWrPktCount <= '1' when (WriteEn_in = '1' and full = '0') and (PktEnd_in = '1') else '0';
    cacheNextReadPktPtr <= '1' when (Replace_inprogress_in = '0' and (PktEnd_in = '1')) else '0';
--    clearReadCache <= '1' when (WriteEn_in = '1' and full = '0') and (RdCachedCaptured = '1') else '0';
    clearReadCache <= '1' when (RdCachedCaptured = '1') else '0';
    
    process (Clear_in, WClk) begin
        if Clear_in = '1' then
--            fifo_reads <=  (others=>'0');
            fifo_writes <=  (others=>'0');
            PktCountWr <= (others=>'0');
--            PktEnd_occ <= '1';
            PktEnd_ph  <= '1';
            --BinaryCountWr   <= conv_std_logic_vector(1, ADDR_WIDTH); do not use conv_std_logic_vector requires use IEEE.std_logic_arith.ALL which is pure evil
            --BinaryCountRd   <= conv_std_logic_vector(1, ADDR_WIDTH); 
--            BinaryCountWr   <=  std_logic_vector(to_unsigned(1, ADDR_WIDTH));  -- CHANGED THIS
            BinaryCountWr   <=  to_unsigned(1, ADDR_WIDTH);  -- CHANGED THIS
            
        else
            
            
            if (rising_edge(WClk)) then
                if (WriteEn_in = '1' and full = '0') then
                    Mem(conv_integer(pNextWordToWrite)) <= Data_to_Wr;
                    fifo_writes <= fifo_writes + 1;
                    BinaryCountWr   <= BinaryCountWr + 1; 
                    PktEnd_ph  <= '0';                  
--                    if(PktEnd_occ <= '1')then                        
--                        PktEnd_occ <= '0';
--                    else
--                        PktEnd_occ <= PktEnd_occ;
--                    end if;
                    
                    
                    
                end if;
                
                if(Replace_inprogress_pos_edge = '1') then
                    BinaryCountWr   <=  to_unsigned(1, ADDR_WIDTH);  -- set to start                    
                end if;
                
               
                
                
                 if (cacheNextReadPktPtr = '1') then
                        BinaryCountRdCache   <= BinaryCountWr;
                        RdCached  <= '1';
                 elsif (clearReadCache = '1') then 
                    RdCached  <= '0';
                end if;
                
                 if(Replace_inprogress_neg_edge = '1') then
--                    PktEnd_ph  <= '1';
                    PktCountWr <= to_unsigned(1, ADDR_WIDTH);  -- set pkt count to  1 because we have one this edge must come after the tlast for the overlapped pkt                      
                elsif(updateWrPktCount = '1') then
--                        PktEnd_occ <= '1';
                        PktEnd_ph  <= '1';
                    PktCountWr <= PktCountWr +1;
                else
--                        PktEnd_occ <= PktEnd_occ;
                    PktCountWr <= PktCountWr;
                end if;
                
                
                
                
                
            end if;
        
         end if;
    end process;

    --Fifo addresses support logic: 
    --'Next Addresses' enable logic:
    NextWriteAddressEn <= WriteEn_in and (not full);
    NextReadAddressEn  <= ReadEn_in  and (not empty);
           
    --Addreses (Gray counters) logic:
    GrayCounter_pWr : GrayCounterC
    generic map(
        COUNTER_WIDTH => ADDR_WIDTH
    )
    port map (
        GrayCount_out => pNextWordToWrite,
        BinaryCount_in => std_logic_vector(BinaryCountWr),
        Enable_in     => NextWriteAddressEn,
        Clear_in      => Clear_in,
        clk           => WClk
    );
       
    GrayCounter_pRd : GrayCounterC
    generic map(
        COUNTER_WIDTH => ADDR_WIDTH
    )
    port map (
        GrayCount_out => pNextWordToRead,
        BinaryCount_in => std_logic_vector(BinaryCountRd),
        Enable_in     => NextReadAddressEn,
        Clear_in      => Clear_in,
        clk           => RClk
    );

--    ReadSync : synchronizer is
--    generic map ( 
--    STAGES => 4,
--    WIDTH => ADDR_WIDTH
--    )
--    Port map( clk => WClk,
--           i => fifo_reads,
--           o=> fifo_reads_125
--         );

    --'EqualAddresses' logic:
    EqualAddresses <= '1' when (pNextWordToWrite = pNextWordToRead) else '0';

    --'Quadrant selectors' logic:
    process (pNextWordToWrite, pNextWordToRead)
        variable set_status_bit0 :std_logic;
        variable set_status_bit1 :std_logic;
        variable rst_status_bit0 :std_logic;
        variable rst_status_bit1 :std_logic;
    begin
        set_status_bit0 := pNextWordToWrite(ADDR_WIDTH-2) xnor pNextWordToRead(ADDR_WIDTH-1);
        set_status_bit1 := pNextWordToWrite(ADDR_WIDTH-1) xor  pNextWordToRead(ADDR_WIDTH-2);
        Set_Status <= set_status_bit0 and set_status_bit1;
        
        rst_status_bit0 := pNextWordToWrite(ADDR_WIDTH-2) xor  pNextWordToRead(ADDR_WIDTH-1);
        rst_status_bit1 := pNextWordToWrite(ADDR_WIDTH-1) xnor pNextWordToRead(ADDR_WIDTH-2);
        Rst_Status      <= rst_status_bit0 and rst_status_bit1;
    end process;
    
    --'Status' latch logic:
    process (Status, Set_Status, Rst_Status, Clear_in) begin--D Latch w/ Asynchronous Clear & Preset.
        if (Rst_Status = '1' or Clear_in = '1') then
            Status <= '0';  --Going 'Empty'.
        elsif (Set_Status = '1') then
            Status <= '1';  --Going 'Full'.
        else
            Status <= Status;
        end if;
    end process;
    
    --'Full_out' logic for the writing port:
--    PresetFull <= Status and EqualAddresses;  --'Full' Fifo.no full flag for this one
     PresetFull <= '0';
     
    process ( Clear_in, WClk, PresetFull) begin --D Flip-Flop w/ Asynchronous Preset.
        if Clear_in = '1' then
            fifo_reads_125_tmp1 <= (others=>'0');
            fifo_reads_125_tmp <= (others=>'0');
        else
            if (PresetFull = '1') then
                full <= '1';
            elsif (rising_edge(WClk)) then
                full <= '0';
                fifo_reads_125_tmp <= fifo_reads;
                fifo_reads_125_tmp1 <= fifo_reads_125_tmp;
                
            end if;
        end if;
    end process;
    Full_out <= full;
    fifo_reads_125 <= fifo_reads_125_tmp1;
    
    
    --'Empty_out' logic for the reading port:
    --PresetEmpty <= not Status and EqualAddresses;  --'Empty' Fifo.
    PresetEmpty <= '1' when PktCountWr = PktCountRd else '0';
    
    process (RClk, PresetEmpty) begin --D Flip-Flop w/ Asynchronous Preset.
        if (PresetEmpty = '1') then
            empty <= '1';
        elsif (rising_edge(RClk)) then
            empty <= '0';
        end if;
    end process;
    
    
    -- Update the fill count
  PROC_COUNT : process(WClk,Clear_in,fifo_writes, fifo_reads_125)
  begin
  if Clear_in = '1' then
    fifo_occ <= (others=>'0');
  else
      if fifo_writes < fifo_reads_125 then
          fifo_occ <= FIFO_DEPTH - (fifo_reads_125 - fifo_writes);
        else
          fifo_occ <= fifo_writes - fifo_reads_125;
        end if;
  
  end if;
  
    
  end process;
    
    -- This syncronises the newsample_in signal to the axis 125MHz clock
replace_edge: process(WClk, Clear_in)
begin
    if Clear_in = '1' then
        Replace_inprogress_reg <= '0';        
    elsif rising_edge (WClk) then
        Replace_inprogress_reg <= Replace_inprogress_in;
    end if;
end process;

Replace_inprogress_pos_edge <= (Replace_inprogress_in xor Replace_inprogress_reg) when (Replace_inprogress_in='1') else '0';
Replace_inprogress_neg_edge <= (Replace_inprogress_in xor Replace_inprogress_reg) when (Replace_inprogress_in='0') else '0';
   -- This syncronises the newsample_in signal to the axis 125MHz clock
replace_edge_rclk: process(RClk, Clear_in)
begin
    if Clear_in = '1' then
        Replace_inprogress_reg_rclk <= '0';        
    elsif rising_edge (RClk) then
        Replace_inprogress_reg_rclk <= Replace_inprogress_in;
    end if;
end process;
Replace_inprogress_pos_edge_rclk <= (Replace_inprogress_in xor Replace_inprogress_reg_rclk) when (Replace_inprogress_in='1') else '0';
Replace_inprogress_neg_edge_rclk <= (Replace_inprogress_in xor Replace_inprogress_reg_rclk) when (Replace_inprogress_in='0') else '0';


    pkt_end_edge: process(WClk, Clear_in)
begin
    if Clear_in = '1' then
        PktEnd_rd_reg <= '0';        
    elsif rising_edge (WClk) then
        PktEnd_rd_reg <= PktEnd_rd;
    end if;
end process;
    PktEnd_rd_pos_edge <= (PktEnd_rd xor PktEnd_rd_reg) when (PktEnd_rd='1') else '0';
    
    Data_out <= Data_out_tmp(DATA_WIDTH-1 downto 0);
    Empty_out <= empty;
    PktEnd_rd <= '1' when Data_out_tmp(Data_out_tmp'left) ='1' else '0';
    PktEnd_out <= PktEnd_rd when (ReadEn_in = '1') else '0'; 
--    fifo_occ <= (fifo_writes - fifo_reads_125 ) when (fifo_writes >= fifo_reads_125) else ((FIFO_DEPTH - fifo_reads_125) + fifo_writes);
    fifo_occ_out <= fifo_occ;
end architecture;
