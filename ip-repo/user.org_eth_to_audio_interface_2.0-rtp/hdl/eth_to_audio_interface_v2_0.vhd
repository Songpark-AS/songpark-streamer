library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eth_to_audio_interface_v2_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6;
		AXIS_UDP_DATA_WIDTH         : integer   := 8;
		PACKET_COUNT_W             : natural   :=  32;
		BUF_COUNT_W             : natural   :=  16;
		SEQ_WIDTH :integer := 8
	);
	port (
		-- Users to add ports here
        audio_l_out            : out STD_LOGIC_VECTOR(23 downto 0);
        audio_r_out            : out STD_LOGIC_VECTOR(23 downto 0);
        newsample_in           : in    STD_LOGIC;
        sample_48k_in           : in    STD_LOGIC;
        irq_out                 : out    STD_LOGIC; 
		clk_48                  :  in    STD_LOGIC;
		fifo_full_out                 : out    STD_LOGIC; 
		fifo_empty_out                 : out    STD_LOGIC; 
--		-- PS Side
--        IRQ      : out   STD_LOGIC;
        
        -- Board Side
          CLK_100  : in    STD_LOGIC;
          CLK_125  : in    STD_LOGIC;
--        AC_ADR0  : out   STD_LOGIC;
--        AC_ADR1  : out   STD_LOGIC;
--        AC_GPIO0 : out   STD_LOGIC;  -- I2S MISO
--        AC_GPIO1 : in    STD_LOGIC;  -- I2S MOSI
--        AC_GPIO2 : in    STD_LOGIC;  -- I2S_bclk
--        AC_GPIO3 : in    STD_LOGIC;  -- I2S_LR
--        AC_MCLK  : out   STD_LOGIC;
--        AC_SCK   : out   STD_LOGIC;
--        AC_SDA   : inout STD_LOGIC;
        
		-- User ports ends
		-- Do not modify the ports beyond this line
		
--		/*
--    * AXIS AUDIO Stream Slave (Receiving into the core from eth)
--    */
    s_ch1_audio_payload_axis_tdata : in std_logic_vector(7 downto 0);
    s_ch1_audio_payload_axis_tvalid : in std_logic;
    s_ch1_audio_payload_axis_tready	: out std_logic;
    s_ch1_audio_payload_axis_tlast : in std_logic;
    s_ch1_audio_payload_axis_tuser: in std_logic;
    
    s_ch1_audio_payload_hdr_ready: out std_logic;
    
    
--    udp_payload_length: out std_logic_vector(15 downto 0);


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end eth_to_audio_interface_v2_0;

architecture arch_imp of eth_to_audio_interface_v2_0 is

--    component adau1761_izedboard is
--    Port ( clk_48    : in  STD_LOGIC;
--           AC_ADR0   : out   STD_LOGIC;
--           AC_ADR1   : out   STD_LOGIC;
--           AC_GPIO0  : out   STD_LOGIC;  -- I2S MISO
--           AC_GPIO1  : in    STD_LOGIC;  -- I2S MOSI
--           AC_GPIO2  : in    STD_LOGIC;  -- I2S_bclk
--           AC_GPIO3  : in    STD_LOGIC;  -- I2S_LR
--           AC_MCLK   : out   STD_LOGIC;
--           AC_SCK    : out   STD_LOGIC;
--           AC_SDA    : inout STD_LOGIC;
--           hphone_l  : in    std_logic_vector(23 downto 0);
--           hphone_r  : in    std_logic_vector(23 downto 0);
--           line_in_l : out   std_logic_vector(23 downto 0);
--           line_in_r : out   std_logic_vector(23 downto 0);
--           new_sample: out   std_logic
--        );
--    end component;

	-- component declaration
	component eth_to_audio_interface_v2_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
        writeReg        : out std_logic;
        wValue          : out std_logic_vector(31 downto 0);
        wAdr            : out std_logic_vector( 5 downto 2);
        wLane           : out std_logic_vector( 3 downto 0);
        
        readReg         : out std_logic;
        rAdr            : out std_logic_vector( 5 downto 2);
        rValue          : in  std_logic_vector(31 downto 0);
		
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component eth_to_audio_interface_v2_0_S00_AXI;
	
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

--    component clocking
--    port(
--       CLK_100           : in     std_logic;
--       CLK_48            : out    std_logic;
--       RESET             : in     std_logic;
--       LOCKED            : out    std_logic
--       );
--    end component;

component rtp_receiver is
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
	 
        Clear_in    :in  std_logic
    );
end component;

--    signal clk_48     : std_logic;
	
	
	-- Register Adressing
    signal writeReg        : std_logic;
    signal wValue          : std_logic_vector(31 downto 0);
    signal wAdr            : std_logic_vector( 5 downto 2);
    signal wLane           : std_logic_vector( 3 downto 0);
    signal readReg         : std_logic;
    signal rAdr            : std_logic_vector( 5 downto 2);
    signal rValue          : std_logic_vector(31 downto 0);
    
    -- Physical Registers
    signal resetLeftDACFifo    : std_logic;
    signal resetRightDACFifo    : std_logic;
    
    signal payload_length           : std_logic_vector( 15 downto 0);
    signal tready : std_logic := '0';
    signal tdata  : std_logic_vector(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
    signal hdr_ready : std_logic := '0';
     signal tvalid : std_logic := '0';
    
    
    -- FIFO, Clock Connection
    signal needNewSample : std_logic;
    signal leftOut24Bit,rightOut24Bit : std_logic_vector(23 downto 0);
    signal dacLeftFIFOData, dacRightFIFOData  : std_logic_vector(23 downto 0);
    signal dacLeftFIFOEmpty, dacLeftFIFOFull : std_logic;
    signal dacRightFIFOEmpty, dacRightFIFOFull : std_logic;
    
    signal leftFifo24BitIn,rightFifo24BitIn : std_logic_vector(23 downto 0);
    signal leftFifo24BitInEth,rightFifo24BitInEth : std_logic_vector(23 downto 0);
    signal leftFifo24BitInArm,rightFifo24BitInArm : std_logic_vector(23 downto 0);

    signal writeLeftDACFifo : std_logic;
    signal writeRightDACFifo : std_logic;
    signal writeLeftDACFifoArm : std_logic;
    signal writeRightDACFifoArm : std_logic;
    signal writeLeftDACFifoEth : std_logic;
    signal writeRightDACFifoEth : std_logic;
    
    signal writeSourceSelect : std_logic :='0';  
    signal sample_48k : std_logic := '0';
    signal writeDACFifoClk  : std_logic := '0';
    
    
    signal packet_count : std_logic_vector(PACKET_COUNT_W-1 downto 0):= x"0000_0300";
    signal packet_count_mirror : unsigned(PACKET_COUNT_W-1 downto 0):=  x"0000_0300";
    signal packet_count_cnt : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    signal packet_count_cnt_final : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    
    
    signal buf_count : std_logic_vector(BUF_COUNT_W-1 downto 0):= x"0100";
    signal buf_count_mirror : unsigned(BUF_COUNT_W-1 downto 0):=  x"0100";
    signal buf_count_cnt : unsigned(BUF_COUNT_W-1 downto 0)  := (others => '0');
    signal buf_count_cnt_final : unsigned(BUF_COUNT_W-1 downto 0)  := (others => '0');
    
    signal enablePacketCount      : std_logic := '0';
    signal enablePacketCount_final: std_logic := '0';
    signal resetPktCount            : std_logic := '0';
    
    signal leftOut24BitTmp,rightOut24BitTmp : std_logic_vector(23 downto 0);
    signal newsample_reg, newsample_change, newsample_rdy : std_logic := '0';
    signal fifo_write, fifo_write_reg, fifo_write_change : std_logic := '0';
    signal sample_buf_good, dac_fifo_read : std_logic := '0';
    
    
    -- first, some declarations for readability instead of magic numbers
    constant clock_period : time := 10 ns; 
    --WARNING : Synplicity has a bug : by default it rounds to nanoseconds!
    constant longest_delay : time := 100 ms;
--    subtype delay_type is natural range 0 to longest_delay / clock_period;
subtype delay_type is natural range 0 to 10000000;
    
    
    
--    constant reset_delay : delay_type := ((100 ms / clock_period) - 1);
--    constant s1_delay  : delay_type := ((50 us / clock_period) - 1);
--    constant s2_delay  : delay_type := ((360 us / clock_period) - 1);
constant reset_delay : delay_type := 99999;
    constant s1_delay  : delay_type := 4999;
    constant s2_delay  : delay_type := (35999);
    constant hdr_valid_delay : delay_type := 4;
    
    constant fiforst_delay  : delay_type := 4999;
    -- NB take care to avoid off-by-1 error!
    signal frst_delay : delay_type;
    signal SeqNumber  : std_logic_vector (SEQ_WIDTH-1 downto 0);
    

begin

    -- Instantiation of Axi Bus Interface S00_AXI
    eth_to_audio_interface_v2_0_S00_AXI_inst : eth_to_audio_interface_v2_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        -- Register Management Port
        writeReg        => writeReg,
        wValue          => wValue,
        wAdr            => wAdr,
        wLane           => wLane,
        
        readReg         => readReg,
        rAdr            => rAdr,
        rValue          => rValue,
        
        -- AXI Slave Port
        S_AXI_ACLK	    => s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
	
	-- 100 Mhz -> 48 Mhz clock conversion.
--    i_clocking : clocking port map (
--      CLK_100 => CLK_100,
--      CLK_48  => CLK_48,
--      RESET   => '0',
--      LOCKED  => open
--    );
	
    -- Register Read Process (NOT CLOCKED !)
    process(readReg,rAdr, dacLeftFIFOEmpty,dacLeftFIFOFull, dacRightFIFOEmpty,dacRightFIFOFull)
    begin
        rValue <= (others => '0');
        if (readReg='1') then
            case rAdr is
            when "0000" =>  
                rValue(2) <= dacLeftFIFOEmpty;
                rValue(3) <= dacRightFIFOEmpty;
                rValue(4) <= dacLeftFIFOFull;
                rValue(5) <= dacRightFIFOFull;
                rValue(6) <= enablePacketCount;
            when "0100" =>  
		          -- Offset 16
                rValue <=  std_logic_vector(packet_count_cnt_final);
             when "0101" =>  
		          -- Offset 20
                rValue <=  X"0000"&std_logic_vector(buf_count_cnt_final);
            when others =>
                -- See problem (1)
--                rValue    <= adcFIFOReadData;
            end case;
        end if;
    end process;
    
    
    -- Register Write Process
    process(s00_axi_aclk,s00_axi_aresetn,wAdr,writeReg,wValue)
    begin
        if rising_edge(s00_axi_aclk) then
            
            
            if s00_axi_aresetn = '0' then
                -- Reset
                resetLeftDACFifo <= '1';
                resetRightDACFifo <= '1';
                enablePacketCount <= '0';
                writeSourceSelect <= '0';
                frst_delay <= 0;
            else
            
                if frst_delay > 0 then 
                    frst_delay <= frst_delay - 1;                 
                 else
                    resetLeftDACFifo <= '0';
                    resetRightDACFifo <= '0';
                end if;
                
                if (writeReg = '1') then
                    case wAdr is
                    when "0000" =>  
--                        resetADCFifo <= wValue(0);                
                        resetLeftDACFifo <= wValue(1);
                        resetRightDACFifo <= wValue(1);
                        writeSourceSelect <= wValue(2);
                        enablePacketCount <= wValue(6);
                        resetPktCount <=  wValue(7);
                        frst_delay <= fiforst_delay;
                     when "0101" =>  
		                  -- Offset 20
                        buf_count <= wValue(buf_count_w-1 downto 0); 
                    when others =>
                    end case;
                end if;
            end if;
        end if;
    end process;
    
    
    
    packet_count_cnt_final <= packet_count_cnt;
    buf_count_cnt_final <= buf_count_cnt;
    enablePacketCount_final <= enablePacketCount;
    leftFifo24BitInEth <= leftOut24BitTmp;
    rightFifo24BitInEth <= rightOut24BitTmp;
    
     -- M AXIS Write Process
    m_axis_writer: process(CLK_125,s00_axi_aresetn) is
        type state_type is (st_in_hdr_idle, st_in_pkt_idle, st_Lbyte1, st_Lbyte2, st_Lbyte3, st_Rbyte1, st_Rbyte2, st_Rbyte3, st_push_fifo);
        variable state : state_type := st_in_hdr_idle;
        variable bytecount : integer range 0 to 2000 := 0;
        
        
    begin
    
        if rising_edge(CLK_125) then
            
            if s00_axi_aresetn = '0' then
                -- Reset
                state := st_in_hdr_idle;
                hdr_ready <= '0';
                writeRightDACFifoEth <= '0';
                writeLeftDACFifoEth <= '0'; 
                tready <= '0';
            else
                
                
                --tready <= '0';
                --hdr_ready <= '0';
                case state is
                    when st_in_hdr_idle =>
                    when st_in_pkt_idle =>                           
                           if(dacRightFIFOFull='0' or dacLeftFIFOFull = '0') then
                                hdr_ready <= '1';       
                                state := st_Lbyte1;
                                tready <= '1';
                            else
                                hdr_ready <= '0';
                                tready <= '0';
                            end if;
                                                 
                            --bytecount := 0;  
                            writeRightDACFifoEth <= '0';
                            writeLeftDACFifoEth <= '0';              
                    --MSB first    
                    when st_Lbyte1 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            leftOut24BitTmp(23 downto 16) <= tdata;
                            state := st_Lbyte2; 
                            bytecount := bytecount + 1;
                        end if;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                        
                        
                    when st_Lbyte2 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            leftOut24BitTmp(15 downto 8) <= tdata;
                            state := st_Lbyte3; 
                            bytecount := bytecount + 1;
                        end if;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                    when st_Lbyte3 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            leftOut24BitTmp(7 downto 0) <= tdata;
                            state := st_Rbyte1; 
                            bytecount := bytecount + 1;                            
                        end if;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                  
                        
                   when st_Rbyte1 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            rightOut24BitTmp(23 downto 16) <= tdata;
                            state := st_Rbyte2; 
                            bytecount := bytecount + 1;                            
                        end if;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                        
                    when st_Rbyte2 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            rightOut24BitTmp(15 downto 8) <= tdata;
                            state := st_Rbyte3; 
                            bytecount := bytecount + 1;
                        end if;
                        
                   when st_Rbyte3 =>
                        tready <= '0';
                        hdr_ready <= hdr_ready;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0';
                        if tvalid = '1' then
                            rightOut24BitTmp(7 downto 0) <= tdata;
--                            state := st_push_fifo; 
                            bytecount := bytecount + 1;
--                            if(dacRightFIFOFull='0' or dacLeftFIFOFull = '0') then                            
                                writeRightDACFifoEth <= '1';
                                writeLeftDACFifoEth <= '1';
--                                if (sample_buf_good = '0') then
--                                    buf_count_cnt <= buf_count_cnt + 1;
--                                else
--                                    buf_count_cnt <= buf_count_cnt;
--                                end if;
                                state := st_in_pkt_idle; 
                       
--                            end if;
                            
                        end if;
                        
                        if s_ch1_audio_payload_axis_tlast = '1' then
                           bytecount := 0; 
                           hdr_ready <= '1';
                           if enablePacketCount_final = '1' then
                                packet_count_cnt <= packet_count_cnt + 1;
--                                if (packet_count_cnt_final >= (packet_count_mirror-1) ) then        
--                                    packet_count_cnt    <= (others => '0');
--                                end if;  
                                state := st_in_hdr_idle;
                            end if;   
                        end if;
                        
                        
                        
--                   when st_push_fifo =>
--                        tready <= '0';
--                        hdr_ready <= hdr_ready;       
--                        if(dacRightFIFOFull='0' or dacLeftFIFOFull = '0') then                            
--                            writeRightDACFifoEth <= '1';
--                            writeLeftDACFifoEth <= '1';
--                            state := st_idle; 
                       
--                       end if;
                       
                   when others =>
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0';
                        state := st_in_hdr_idle;   
                end case;
                
                
                if resetPktCount = '1' then
                    packet_count_cnt <= (others => '0');
                end if;
                
                
                if (resetLeftDACFifo ='1' or resetRightDACFifo  ='1') then
                    state := st_in_hdr_idle; 
--                    buf_count_cnt <= (others => '0');
                end if;
        end if;
    end if;
            
end process;


-- This syncronises the newsample_in signal to the axis 125MHz clock
newsample_delay: process(CLK_48, s00_axi_aresetn)
begin
    if s00_axi_aresetn = '0' then
        newsample_reg <= '0';        
    elsif rising_edge (CLK_48) then
        newsample_reg <= sample_48k;
    end if;
end process;

newsample_change <= (sample_48k xor newsample_reg) when (sample_48k='1') else '0';


fifo_write <= (writeLeftDACFifoEth or writeRightDACFifoEth);

fifo_write_delay: process(CLK_125, s00_axi_aresetn)
begin
    if s00_axi_aresetn = '0' then
        fifo_write_reg <= '0';        
    elsif rising_edge (CLK_125) then
        fifo_write_reg <=  fifo_write;
    end if;
end process;


fifo_write_change <= (fifo_write xor fifo_write_reg) when (fifo_write='1') else '0';



-- This handle the buf
sample_buf: process(CLK_125, s00_axi_aresetn)
begin
    if s00_axi_aresetn = '0' then
        buf_count_cnt <= (others => '0');      
    elsif rising_edge (CLK_125) then
        if (fifo_write_change='1') and (sample_buf_good = '0') then 
             
                buf_count_cnt <= buf_count_cnt + 1;
        else
                buf_count_cnt <= buf_count_cnt;
        end if;
     
        if (resetLeftDACFifo ='1' or resetRightDACFifo  ='1') then            
            buf_count_cnt <= (others => '0');
        end if;
        
                               
    end if;
end process;

    sample_buf_good <= '1' when (buf_count_cnt  >= buf_count_mirror ) else '0';
    
    dac_fifo_read <= '1' when (sample_buf_good = '1' and newsample_change='1') else '0';    
    --Thus Bit 3 and bit 2 so ==== OFFSET 0 => 0000 OFFSET 4 => 0001 OFFSET 8 => 0010 ....
    --wAdr="0001" OFFSET=4
    writeLeftDACFifoArm <= '1' when (writeReg = '1' and wAdr="0001") else '0';
    writeRightDACFifoArm <= '1' when (writeReg = '1' and wAdr="0010") else '0';
--    readADCFifo  <= '1' when (readReg  = '1' and rAdr="0010") else '0';

    writeLeftDACFifo <= writeLeftDACFifoEth;-- when (writeSourceSelect = '0') else writeLeftDACFifoArm;
    writeRightDACFifo <= writeRightDACFifoEth;-- when (writeSourceSelect = '0') else writeRightDACFifoArm;
    
    
    writeDACFifoClk <= CLK_125;-- when (writeSourceSelect = '0') else s00_axi_aclk;
    
    
    leftFifo24BitIn <= leftFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
    rightFifo24BitIn <= rightFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
    

    payload_length <= wValue(15 downto  0) when (writeReg = '1' and wAdr="0011") else (others => '0');
    
    FIFO_L_OutDAC : DualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 15
    )
    port map (
        -- Reading port.
        Data_out    => dacLeftFIFOData,
        Empty_out   => dacLeftFIFOEmpty,
        ReadEn_in   => dac_fifo_read,
        RClk        => clk_48,
        
        -- Writing port.
        Data_in     => leftFifo24BitIn,
        Full_out    => dacLeftFIFOFull,
        WriteEn_in  => writeLeftDACFifo,
        WClk        => writeDACFifoClk,
     
        Clear_in    => resetLeftDACFifo
    );
    
    
    
    
    FIFO_R_OutDAC : DualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 15
    )
    port map (
        -- Reading port.
        Data_out    => dacRightFIFOData,
        Empty_out   => dacRightFIFOEmpty,
        ReadEn_in   => dac_fifo_read,
        RClk        => clk_48,
        
        -- Writing port.
        Data_in     => rightFifo24BitIn,
        Full_out    => dacRightFIFOFull,
        WriteEn_in  => writeRightDACFifo,
        WClk        => writeDACFifoClk,
     
        Clear_in    => resetRightDACFifo
    );
    
    
    RTP_PACKET_RECEIVER : rtp_receiver
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => 15
    )
    port map (
        -- Reading port.
        Data_out    => dacRightFIFOData,
        Empty_out   => dacRightFIFOEmpty,
        ReadEn_in   => dac_fifo_read,
        RClk        => clk_125,
        
        -- Writing port.
        Data_in     => rightFifo24BitIn,
        Full_out    => dacRightFIFOFull,
        WriteEn_in  => writeRightDACFifo,
        WClk        => clk_125,
        
        SeqNumber   => SeqNumber, 
     
        Clear_in    => resetRightDACFifo
    );

    -- PROBLEM (1) : Output of ADC FIFO is LATE when read bit is set (1 cycle latency)
    -- RREADY bit in AXI Bus need to wait.
    
--    FIFO_InADC : DualClockFIFO
--    generic map (
--        DATA_WIDTH => 32,
--        ADDR_WIDTH => 11
--    )
--    port map (
--        -- Reading port.
--        Data_out    => adcFIFOReadData,
--        Empty_out   => adcFIFOEmpty,
--        ReadEn_in   => readADCFifo,
--        RClk        => s00_axi_aclk,
        
--        -- Writing port.
--        Data_in     => adcFIFOData,
--        Full_out    => adcFIFOFull,
--        WriteEn_in  => sample_48k,
--        WClk        => clk_48,
     
--        Clear_in    => resetADCFifo
--    );
    
    -- 16 bit to 24 bit conversion OUT
--    leftOut24Bit  <= dacFIFOData(31 downto 16) & dacFIFOData(31 downto 24);
--    rightOut24Bit <= dacFIFOData(15 downto  0) & dacFIFOData(15 downto  8);
    
    leftOut24Bit(23 downto  0)  <= dacLeftFIFOData(23 downto 0);
    rightOut24Bit(23 downto  0) <= dacRightFIFOData(23 downto  0);

    -- 24 bit to 16 bit conversion IN
--    adcFIFOData(31 downto 16) <=  leftIn24Bit(23 downto 8);
--    adcFIFOData(15 downto  0) <= rightIn24Bit(23 downto 8);
    
--    adau1761_izedboard_inst : adau1761_izedboard
--    Port map ( 
--       clk_48    => clk_48,
--       AC_ADR0   => AC_ADR0,
--       AC_ADR1   => AC_ADR1,
--       AC_GPIO0  => AC_GPIO0,
--       AC_GPIO1  => AC_GPIO1,
--       AC_GPIO2  => AC_GPIO2,
--       AC_GPIO3  => AC_GPIO3,
--       AC_MCLK   => AC_MCLK,
--       AC_SCK    => AC_SCK,
--       AC_SDA    => AC_SDA,
--       hphone_l  => leftOut24Bit,
--       hphone_r  => rightOut24Bit,
--       line_in_l => leftIn24Bit,
--       line_in_r => rightIn24Bit,
--       new_sample=> sample_48k
--    );

    -- IRQ Generation.
    -- TODO (2), make sure we generate ONE pulse ? Assert until... ?
    irq_out <= '0';
    
--    leftIn24Bit <= line_in_l_in;
--    rightIn24Bit <= line_in_r_in;
    audio_l_out <= leftOut24Bit;
    audio_r_out <= rightOut24Bit;

    needNewSample <= newsample_in;
    sample_48k <= sample_48k_in;
--    udp_payload_length <= payload_length;
    
    s_ch1_audio_payload_hdr_ready <= hdr_ready;
    s_ch1_audio_payload_axis_tready <= tready;
    tvalid <= s_ch1_audio_payload_axis_tvalid;
    tdata <= s_ch1_audio_payload_axis_tdata;
	-- User logic ends
	packet_count_mirror <= unsigned(packet_count);
	buf_count_mirror <= unsigned(buf_count);
	
	fifo_full_out <= '1' when (dacRightFIFOFull='1' or dacLeftFIFOFull = '1') else '0';
	fifo_empty_out <= '1' when (dacRightFIFOEmpty='1' or dacLeftFIFOEmpty = '1') else '0';
	

end arch_imp;
