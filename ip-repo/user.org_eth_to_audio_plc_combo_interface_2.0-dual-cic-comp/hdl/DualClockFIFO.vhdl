------------------------------------------------------------
-- Function : Asynchronous FIFO (w/ 2 asynchronous clocks).

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
    use ieee.numeric_std.all;
    
entity DualClockFIFO is
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
        -- Writing port.
        Data_in     :in  std_logic_vector (DATA_WIDTH-1 downto 0);
        PktEnd_in        :in  std_logic;
        Full_out    :out std_logic;
        WriteEn_in  :in  std_logic;
        WClk        :in  std_logic;
        
        
	    fifo_occ_out            : out unsigned(ADDR_WIDTH-1 downto 0);
        Clear_in    :in  std_logic
        
    );
end entity;

architecture rtl of DualClockFIFO is
    ----/Internal connections & variables------
    constant FIFO_DEPTH :integer := 2**ADDR_WIDTH;

--    type RAM is array (integer range <>)of std_logic_vector (DATA_WIDTH downto 0);
--    signal Mem : RAM (0 to FIFO_DEPTH);
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
    signal fifo_writes,  fifo_reads, fifo_occ  : unsigned(ADDR_WIDTH-1 downto 0);
    
    signal Data_to_Wr     : std_logic_vector (DATA_WIDTH downto 0);
    
    component GrayCounter is
    generic (
        COUNTER_WIDTH :integer := 4
    );
    port (
        GrayCount_out :out std_logic_vector (COUNTER_WIDTH-1 downto 0);
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


type ram_type is array (0 to FIFO_DEPTH-1) of std_logic_vector(Data_in'length downto 0);
  signal Mem : ram_type;

begin


MemDataWrite:    process (Clear_in,WClk) 
--type RAM is array (integer range <>)of std_logic_vector (DATA_WIDTH downto 0);
--    variable Mem : RAM (0 to FIFO_DEPTH); -- good for the simulator also works well for synthesis

begin
 
     if Clear_in = '1' then
        fifo_writes <=  (others=>'0');
     elsif (rising_edge(WClk)) then
            if (WriteEn_in = '1' and full = '0') then
                Mem(conv_integer(pNextWordToWrite)) <= Data_to_Wr;
                fifo_writes <= fifo_writes + 1;
            else
                fifo_writes <= fifo_writes;
            end if;
        end if;

end process;


MemDataRead:    process (Clear_in,RClk) 
--type RAM is array (integer range <>)of std_logic_vector (DATA_WIDTH downto 0);
--    variable Mem : RAM (0 to FIFO_DEPTH); -- good for the simulator also works well for synthesis

begin

          
         
     if Clear_in = '1' then
        fifo_reads <=  (others=>'0');
        Data_out_tmp <=  (others=>'0');
     elsif (rising_edge(RClk)) then
            if (ReadEn_in = '1' and empty = '0') then
                Data_out_tmp <= Mem(conv_integer(pNextWordToRead));
                fifo_reads <= fifo_reads + 1;
            else
                fifo_reads <= fifo_reads;
            end if;
        end if;
        




end process;

    --------------Code--------------/
    --Data ports logic:
    --(Uses a dual-port RAM).
    --'Data_out' logic:
--    process (Clear_in,RClk) begin
--    if Clear_in = '1' then
--        fifo_reads <=  (others=>'0');
--        else
--        if (rising_edge(RClk)) then
--            if (ReadEn_in = '1' and empty = '0') then
--                Data_out_tmp <= Mem(conv_integer(pNextWordToRead));
--                fifo_reads <= fifo_reads + 1;
--            end if;
--        end if;
--         end if;
--    end process;
            
    --'Data_in' logic:
--    process (Clear_in, WClk) begin
--        if Clear_in = '1' then
--        fifo_writes <=  (others=>'0');
--        else
--        if (rising_edge(WClk)) then
--            if (WriteEn_in = '1' and full = '0') then
--                Mem(conv_integer(pNextWordToWrite)) <= Data_to_Wr;
--                fifo_writes <= fifo_writes + 1;
--            end if;
--        end if;
--         end if;
--    end process;

    --Fifo addresses support logic: 
    --'Next Addresses' enable logic:
    NextWriteAddressEn <= WriteEn_in and (not full);
    NextReadAddressEn  <= ReadEn_in  and (not empty);
           
    --Addreses (Gray counters) logic:
    GrayCounter_pWr : GrayCounter
    generic map(
        COUNTER_WIDTH => ADDR_WIDTH
    )
    port map (
        GrayCount_out => pNextWordToWrite,
        Enable_in     => NextWriteAddressEn,
        Clear_in      => Clear_in,
        clk           => WClk
    );
       
    GrayCounter_pRd : GrayCounter
    generic map(
        COUNTER_WIDTH => ADDR_WIDTH
    )
    port map (
        GrayCount_out => pNextWordToRead,
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
    process (Set_Status, Rst_Status, Clear_in) begin--D Latch w/ Asynchronous Clear & Preset.
        if (Rst_Status = '1' or Clear_in = '1') then
            Status <= '0';  --Going 'Empty'.
        elsif (Set_Status = '1') then
            Status <= '1';  --Going 'Full'.
        else
            Status <= Status;
        end if;
    end process;
    
    --'Full_out' logic for the writing port:
    PresetFull <= Status and EqualAddresses;  --'Full' Fifo.
    
    process ( Clear_in, WClk, PresetFull) begin --D Flip-Flop w/ Asynchronous Preset.
        if Clear_in = '1' then
--            fifo_reads_125_tmp1 <= (others=>'0');
--            fifo_reads_125_tmp <= (others=>'0');
        else
            if (PresetFull = '1') then
                full <= '1';
            elsif (rising_edge(WClk)) then
                full <= '0';
--                fifo_reads_125_tmp <= fifo_reads;
--                fifo_reads_125_tmp1 <= fifo_reads_125_tmp;
                
            end if;
        end if;
    end process;
    Full_out <= full;
--    fifo_reads_125 <= fifo_reads_125_tmp1;
    
    
    --'Empty_out' logic for the reading port:
    PresetEmpty <= not Status and EqualAddresses;  --'Empty' Fifo.
    
    process (RClk, PresetEmpty) begin --D Flip-Flop w/ Asynchronous Preset.
        if (PresetEmpty = '1') then
            empty <= '1';
        elsif (rising_edge(RClk)) then
            empty <= '0';
        end if;
    end process;
    
    
    -- Update the fill count
  PROC_COUNT : process(Clear_in,fifo_writes, fifo_reads)
  begin
    if Clear_in = '1' then
    fifo_occ <= (others=>'0');
--   elsif (rising_edge(WClk)) then
    else
      if fifo_writes < fifo_reads then
          fifo_occ <= FIFO_DEPTH - (fifo_reads - fifo_writes);
        else
          fifo_occ <= fifo_writes - fifo_reads;
        end if;
  
  end if;
  
    
  end process;
    
    Empty_out <= empty;
    Data_out <= Data_out_tmp(DATA_WIDTH-1 downto 0);
    Data_to_Wr <= PktEnd_in & Data_in;
    PktEnd_out <= Data_out_tmp(Data_out_tmp'left);
--    fifo_occ <= (fifo_writes - fifo_reads_125 ) when (fifo_writes >= fifo_reads_125) else ((FIFO_DEPTH - fifo_reads_125) + fifo_writes);
    fifo_occ_out <= fifo_occ;
end architecture;


--------------------------------------------------------------
---- Function : Asynchronous FIFO (w/ 2 asynchronous clocks).
---- Coder    : Alex Claros F.
---- Date     : 15/May/2005.
---- Notes    : This implementation is based on the article 
----            'Asynchronous FIFO in Virtex-II FPGAs'
----            writen by Peter Alfke. This TechXclusive 
----            article can be downloaded from the
----            Xilinx website. It has some minor modifications.
---- Coder     : Deepak Kumar Tala (Verilog)
---- Translator: Alexander H Pham (VHDL)
---- Found at http://www.asic-world.com/examples/vhdl/asyn_fifo.html
--------------------------------------------------------------
--library ieee;
--    use ieee.std_logic_1164.all;
--    use ieee.std_logic_unsigned.all;
--    use ieee.numeric_std.all;
    
--entity DualClockFIFO is
--    generic (
--        DATA_WIDTH :integer := 8;
--        ADDR_WIDTH :integer := 4
--    );
--    port (
--        -- Reading port.
--        Data_out    :out std_logic_vector (DATA_WIDTH-1 downto 0);
--        PktEnd_out        :out  std_logic;
--        Empty_out   :out std_logic;
--        ReadEn_in   :in  std_logic;
--        RClk        :in  std_logic;
--        -- Writing port.
--        Data_in     :in  std_logic_vector (DATA_WIDTH-1 downto 0);
--        PktEnd_in        :in  std_logic;
--        Full_out    :out std_logic;
--        WriteEn_in  :in  std_logic;
--        WClk        :in  std_logic;
        
        
--	    fifo_occ_out            : out unsigned(ADDR_WIDTH-1 downto 0);
--        Clear_in    :in  std_logic
        
--    );
--end entity;

--architecture rtl of DualClockFIFO is
--    ----/Internal connections & variables------
--    constant FIFO_DEPTH :integer := 2**ADDR_WIDTH;

----    type RAM is array (integer range <>)of std_logic_vector (DATA_WIDTH downto 0);
----    signal Mem : RAM (0 to FIFO_DEPTH);
--    signal Data_out_tmp    :std_logic_vector (DATA_WIDTH downto 0);
    
--    signal pNextWordToWrite     :std_logic_vector (ADDR_WIDTH-1 downto 0);
--    signal pNextWordToRead      :std_logic_vector (ADDR_WIDTH-1 downto 0);
--    signal EqualAddresses       :std_logic;
--    signal NextWriteAddressEn   :std_logic;
--    signal NextReadAddressEn    :std_logic;
--    signal Set_Status           :std_logic;
--    signal Rst_Status           :std_logic;
--    signal Status               :std_logic;
--    signal PresetFull           :std_logic;
--    signal PresetEmpty          :std_logic;
--    signal empty,full           :std_logic;
--    signal fifo_writes,  fifo_reads, fifo_reads_125, fifo_reads_125_tmp, fifo_reads_125_tmp1, fifo_occ  : unsigned(ADDR_WIDTH-1 downto 0);
    
--    signal Data_to_Wr     : std_logic_vector (DATA_WIDTH downto 0);
    
--    component GrayCounter is
--    generic (
--        COUNTER_WIDTH :integer := 4
--    );
--    port (
--        GrayCount_out :out std_logic_vector (COUNTER_WIDTH-1 downto 0);
--        Enable_in     :in  std_logic;  --Count enable.
--        Clear_in      :in  std_logic;  --Count reset.
--        clk           :in  std_logic
--    );
--    end component;
    
--    component synchronizer is
--    generic ( 
--    STAGES : natural := 4
--    );
--    Port ( clk : in STD_LOGIC;
--           i : in STD_LOGIC;
--           o : out STD_LOGIC);
--    end component;


--begin


--MemDataReadWrite:    process (Clear_in,WClk,RClk) 
--type RAM is array (integer range <>)of std_logic_vector (DATA_WIDTH downto 0);
--    variable Mem : RAM (0 to FIFO_DEPTH); -- good for the simulator also works well for synthesis

--begin

          
         
--     if Clear_in = '1' then
--        fifo_writes <=  (others=>'0');
--     else
--        if (rising_edge(WClk)) then
--            if (WriteEn_in = '1' and full = '0') then
--                Mem(conv_integer(pNextWordToWrite)) := Data_to_Wr;
--                fifo_writes <= fifo_writes + 1;
--            end if;
--        end if;
        
         
         
--    if Clear_in = '1' then        
--        fifo_reads <=  (others=>'0');
--        Data_out_tmp <=  (others=>'0');
--     else
--        if (rising_edge(RClk)) then
--            if (ReadEn_in = '1' and empty = '0') then
--                Data_out_tmp <= Mem(conv_integer(pNextWordToRead));
--                fifo_reads <= fifo_reads + 1;
--            end if;
--        end if;
--      end if;
        
--      end if;



--end process;

--    --------------Code--------------/
--    --Data ports logic:
--    --(Uses a dual-port RAM).
--    --'Data_out' logic:
----    process (Clear_in,RClk) begin
----    if Clear_in = '1' then
----        fifo_reads <=  (others=>'0');
----        else
----        if (rising_edge(RClk)) then
----            if (ReadEn_in = '1' and empty = '0') then
----                Data_out_tmp <= Mem(conv_integer(pNextWordToRead));
----                fifo_reads <= fifo_reads + 1;
----            end if;
----        end if;
----         end if;
----    end process;
            
--    --'Data_in' logic:
----    process (Clear_in, WClk) begin
----        if Clear_in = '1' then
----        fifo_writes <=  (others=>'0');
----        else
----        if (rising_edge(WClk)) then
----            if (WriteEn_in = '1' and full = '0') then
----                Mem(conv_integer(pNextWordToWrite)) <= Data_to_Wr;
----                fifo_writes <= fifo_writes + 1;
----            end if;
----        end if;
----         end if;
----    end process;

--    --Fifo addresses support logic: 
--    --'Next Addresses' enable logic:
--    NextWriteAddressEn <= WriteEn_in and (not full);
--    NextReadAddressEn  <= ReadEn_in  and (not empty);
           
--    --Addreses (Gray counters) logic:
--    GrayCounter_pWr : GrayCounter
--    generic map(
--        COUNTER_WIDTH => ADDR_WIDTH
--    )
--    port map (
--        GrayCount_out => pNextWordToWrite,
--        Enable_in     => NextWriteAddressEn,
--        Clear_in      => Clear_in,
--        clk           => WClk
--    );
       
--    GrayCounter_pRd : GrayCounter
--    generic map(
--        COUNTER_WIDTH => ADDR_WIDTH
--    )
--    port map (
--        GrayCount_out => pNextWordToRead,
--        Enable_in     => NextReadAddressEn,
--        Clear_in      => Clear_in,
--        clk           => RClk
--    );

----    ReadSync : synchronizer is
----    generic map ( 
----    STAGES => 4,
----    WIDTH => ADDR_WIDTH
----    )
----    Port map( clk => WClk,
----           i => fifo_reads,
----           o=> fifo_reads_125
----         );

--    --'EqualAddresses' logic:
--    EqualAddresses <= '1' when (pNextWordToWrite = pNextWordToRead) else '0';

--    --'Quadrant selectors' logic:
--    process (pNextWordToWrite, pNextWordToRead)
--        variable set_status_bit0 :std_logic;
--        variable set_status_bit1 :std_logic;
--        variable rst_status_bit0 :std_logic;
--        variable rst_status_bit1 :std_logic;
--    begin
--        set_status_bit0 := pNextWordToWrite(ADDR_WIDTH-2) xnor pNextWordToRead(ADDR_WIDTH-1);
--        set_status_bit1 := pNextWordToWrite(ADDR_WIDTH-1) xor  pNextWordToRead(ADDR_WIDTH-2);
--        Set_Status <= set_status_bit0 and set_status_bit1;
        
--        rst_status_bit0 := pNextWordToWrite(ADDR_WIDTH-2) xor  pNextWordToRead(ADDR_WIDTH-1);
--        rst_status_bit1 := pNextWordToWrite(ADDR_WIDTH-1) xnor pNextWordToRead(ADDR_WIDTH-2);
--        Rst_Status      <= rst_status_bit0 and rst_status_bit1;
--    end process;
    
--    --'Status' latch logic:
--    process (Status, Set_Status, Rst_Status, Clear_in) begin--D Latch w/ Asynchronous Clear & Preset.
--        if (Rst_Status = '1' or Clear_in = '1') then
--            Status <= '0';  --Going 'Empty'.
--        elsif (Set_Status = '1') then
--            Status <= '1';  --Going 'Full'.
--        else
--            Status <= Status;
--        end if;
--    end process;
    
--    --'Full_out' logic for the writing port:
--    PresetFull <= Status and EqualAddresses;  --'Full' Fifo.
    
--    process ( Clear_in, WClk, PresetFull) begin --D Flip-Flop w/ Asynchronous Preset.
--        if Clear_in = '1' then
--            fifo_reads_125_tmp1 <= (others=>'0');
--            fifo_reads_125_tmp <= (others=>'0');
--        else
--            if (PresetFull = '1') then
--                full <= '1';
--            elsif (rising_edge(WClk)) then
--                full <= '0';
--                fifo_reads_125_tmp <= fifo_reads;
--                fifo_reads_125_tmp1 <= fifo_reads_125_tmp;
                
--            end if;
--        end if;
--    end process;
--    Full_out <= full;
----    fifo_reads_125 <= fifo_reads_125_tmp1;
--    fifo_reads_125 <= fifo_reads;
    
--    --'Empty_out' logic for the reading port:
--    PresetEmpty <= not Status and EqualAddresses;  --'Empty' Fifo.
    
--    process (RClk, PresetEmpty) begin --D Flip-Flop w/ Asynchronous Preset.
--        if (PresetEmpty = '1') then
--            empty <= '1';
--        elsif (rising_edge(RClk)) then
--            empty <= '0';
--        end if;
--    end process;
    
    
--    -- Update the fill count
--  PROC_COUNT : process(WClk,Clear_in,fifo_writes, fifo_reads_125)
--  begin
--      if Clear_in = '1' then
--        fifo_occ <= (others=>'0');
--      elsif (rising_edge(WClk)) then
--            if fifo_writes < fifo_reads_125 then
--              fifo_occ <= FIFO_DEPTH - (fifo_reads_125 - fifo_writes);
--            else
--              fifo_occ <= fifo_writes - fifo_reads_125;
--            end if;
      
--      end if;
  
    
--  end process;
    
--    Empty_out <= empty;
--    Data_out <= Data_out_tmp(DATA_WIDTH-1 downto 0);
--    Data_to_Wr <= PktEnd_in & Data_in;
--    PktEnd_out <= Data_out_tmp(Data_out_tmp'left);
----    fifo_occ <= (fifo_writes - fifo_reads_125 ) when (fifo_writes >= fifo_reads_125) else ((FIFO_DEPTH - fifo_reads_125) + fifo_writes);
--    fifo_occ_out <= fifo_occ;
--end architecture;
