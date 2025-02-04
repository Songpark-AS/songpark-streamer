library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity plc_downstream_v1_0  is
	generic (
		-- Users to add parameters here
        PACKET_COUNT_W             : natural   :=  32;
		FIFO_ADDR_WIDTH           : natural := 14;
		GLITCH_FILTER_LENGTH   : natural := 15;
		TC_BIT_LENGTH               : natural   :=  32;
--		HDR_LENGTH              : natural := 12;
		BUF_COUNT_W             : natural   :=  32;
		PACKET_SEQ_W: natural   :=  16;
		S_COUNT: natural   :=  64;-- number of SEQ slots
		FIFO_DATA_WIDTH           : natural := 24;
		
		STEP_WIDTH			: integer := 32;
		 INTBIT_WIDTH  : integer := 24;
                FRACBIT_WIDTH : integer := 8; --now, its calculated below, in port mapping
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 7;
		AXIS_UDP_DATA_WIDTH         : integer   := 8
		
		
	);
	port (
		-- Users to add ports here
		rst_in           : in    STD_LOGIC;		
        audio_l_out            : out STD_LOGIC_VECTOR(23 downto 0);
        audio_r_out            : out STD_LOGIC_VECTOR(23 downto 0);
        fifo_occ_out            : out STD_LOGIC_VECTOR(FIFO_ADDR_WIDTH -1 downto 0);
        play_out_ready_out                 : out    STD_LOGIC;         
        replace_pkt_in          : in    STD_LOGIC; 
        newsample_in           : in    STD_LOGIC;
        replace_inprogress_in         : in    STD_LOGIC;
        
--        tc_sync_in           : in    STD_LOGIC;
        tc_sync_en_in           : in    STD_LOGIC;
        sync_time_code_in      : in unsigned(TC_BIT_LENGTH  -1 downto 0);        
         status1_out           : out    STD_LOGIC;
         status2_out           : out    STD_LOGIC;
         
        new_pkt_ready_in       : in     STD_LOGIC;
        replace_pkt_end_out     : out   STD_LOGIC;
        

        irq_out                 : out    STD_LOGIC; 
--		clk_48                  :  in    STD_LOGIC;
		fifo_full_out                 : out    STD_LOGIC; 
		fifo_empty_out                 : out    STD_LOGIC; 
		
--		-- PS Side
--        IRQ      : out   STD_LOGIC;
        
        -- Board Side
          --CLK_100  : in    STD_LOGIC;
          CLK_125  : in    STD_LOGIC;
          
          
--          fade_enable_out       : out STD_LOGIC;
		fade_direction_out    : out STD_LOGIC;
--		fade_clear_out        : out STD_LOGIC;
		

--		IN_SIG_L      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
--		IN_SIG_R      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
		UP_STEP_PULSES_OUT	: out std_logic_vector(STEP_WIDTH-1 downto 0);
		DOWN_STEP_PULSES_OUT	: out std_logic_vector(STEP_WIDTH-1 downto 0);
		COEF_MIN_OUT     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		COEF_MAX_OUT     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		COEF_IN     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1


        
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
end plc_downstream_v1_0 ;

architecture arch_imp of plc_downstream_v1_0  is

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
	component plc_downstream_v1_0_S00_AXI is
		generic (
		TC_BIT_LENGTH               : natural   :=  32;
        PACKET_SEQ_W                : natural   :=  16;
        FIFO_ADDR_WIDTH             : natural := 4;
        PACKET_COUNT_W              : natural   :=  32;
        BUF_COUNT_W             : natural   :=  32;
        
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 7
		);
		port (
--        writeReg        : out std_logic;
--        wValue          : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
--        wAdr            : out std_logic_vector( C_S00_AXI_ADDR_WIDTH-1 downto 2);
--        wLane           : out std_logic_vector( 3 downto 0);
        
--        readReg         : out std_logic;
--        rAdr            : out std_logic_vector( C_S00_AXI_ADDR_WIDTH-1 downto 2);
--        rValue          : in  std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);

        dacLeftFIFOEmpty_in : in std_logic;
       dacLeftFIFOFull_in : in std_logic;
       dacRightFIFOEmpty_in : in std_logic;
       dacRightFIFOFull_in : in std_logic;
       play_out_en_in : in std_logic;
       fifo_writes_in  : in unsigned(FIFO_ADDR_WIDTH -1 downto 0);
       fifo_reads_in : in unsigned(FIFO_ADDR_WIDTH -1 downto 0);
       fifo_occ_in : in unsigned(FIFO_ADDR_WIDTH -1 downto 0);
       rxtc_fifo_occ_in : in unsigned(8 -1 downto 0);
       buf_count_err_final_in : in unsigned(BUF_COUNT_W-1 downto 0);
       packet_count_final_in : in unsigned(PACKET_COUNT_W-1 downto 0);  
          
       packet_dumped_cnt_final_in :  in unsigned(PACKET_COUNT_W-1 downto 0);   
       
       buf_corr_window_out        : out unsigned(BUF_COUNT_W-1 downto 0);  
     
       sync_time_code_in      : in unsigned(TC_BIT_LENGTH  -1 downto 0);
       rx_time_code_in : in std_logic_vector(TC_BIT_LENGTH  -1 downto 0);   
       rx_time_code_eff_in : in std_logic_vector(TC_BIT_LENGTH  -1 downto 0);   
       rx_time_code_fout_in  : in std_logic_vector(TC_BIT_LENGTH  -1 downto 0);   
       play_out_time_in : in unsigned(TC_BIT_LENGTH  -1 downto 0);
       

       
       fifo_occ_lim_out  : out unsigned(FIFO_ADDR_WIDTH -1 downto 0);
      enablePacketCount_out      : out std_logic;
      resetPktCount_out            : out std_logic;
       enable_buf_corr_out           : out std_logic;
       writeSourceSelect_out : out std_logic;
       play_out_delay_out : out std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
       buf_count_out : out std_logic_vector(BUF_COUNT_W-1 downto 0);
       
       lock_pkts_limit_out : out unsigned(BUF_COUNT_W - 1 downto 0);
       
       payload_length_out           : out std_logic_vector( PACKET_SEQ_W - 1 downto 0);
       hdr_strip_out : out std_logic;
       hdr_length_out  : out unsigned(7 downto 0);
        test_mode_out : out   std_logic;
        test_pattern_out : out  std_logic_vector(2 downto 0);
        
        resetLeftDACFifo_out : out   std_logic;
        resetRightDACFifo_out : out   std_logic;
		
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
	end component plc_downstream_v1_0_S00_AXI;
	
    component DualClockLIFO is
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
    end component;

    component BUFG is 
    port (
        I: in std_logic;
        O: out std_logic
    );
     end component;

component filtered_io is
generic (FILTER_LENGTH : integer := 15);
port(
    data : out std_logic;
    input : in std_logic;
    reset : in std_logic;
    CLK : in std_logic
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

--    signal clk_48     : std_logic;
	
	
	-- Register Adressing
--    signal writeReg        : std_logic;
--    signal wValue          : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
--    signal wAdr            : std_logic_vector( C_S00_AXI_ADDR_WIDTH-1 downto 2);
--    signal wLane           : std_logic_vector( 3 downto 0);
--    signal readReg         : std_logic;
--    signal rAdr            : std_logic_vector( C_S00_AXI_ADDR_WIDTH-1 downto 2);
--    signal rValue          : std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
    
    -- Physical Registers
    constant BUF_ERR_DEPTH :integer := 2**BUF_COUNT_W;
    signal resetLeftDACFifo    : std_logic;
    signal resetRightDACFifo    : std_logic;
    
    signal payload_length        : std_logic_vector( PACKET_SEQ_W  - 1 downto 0);
    signal sample_read_counter           : unsigned( PACKET_SEQ_W  - 1 downto 0);
    signal tready : std_logic := '0';
    signal tdata  : std_logic_vector(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
    signal hdr_ready : std_logic := '0';
     signal tvalid : std_logic := '0';
     
     
    
    signal state_val : std_logic_vector(4 downto 0);
    
    
    -- FIFO, Clock Connection
--    signal needNewSample : std_logic;
    signal leftOut24Bit,rightOut24Bit : std_logic_vector(23 downto 0);
    signal dacLeftFIFOData, dacRightFIFOData  : std_logic_vector(23 downto 0);
    signal dacLeftFIFOEmpty, dacLeftFIFOFull, rxtcFIFOFull : std_logic;
    signal dacRightFIFOEmpty, dacRightFIFOFull, rxtcFIFOEmpty : std_logic;
    
    signal leftFifo24BitIn,rightFifo24BitIn : std_logic_vector(23 downto 0);
    signal leftFifo24BitInEth,rightFifo24BitInEth : std_logic_vector(23 downto 0);
    signal leftFifo24BitInArm,rightFifo24BitInArm : std_logic_vector(23 downto 0);

    signal writeLeftDACFifo : std_logic;
    signal writeRightDACFifo : std_logic;
    signal writeLeftDACFifoArm : std_logic;
    signal writeRightDACFifoArm : std_logic;
    signal writeLeftDACFifoEth : std_logic;
    signal writeRightDACFifoEth : std_logic;
    
    signal rxtc_fifo_read, rxtc_fifo_read_init, rxtc_fifo_read_cyc, first_pkt_wrt, first_pkt_rdr, resetErrCount : std_logic;
    signal rxtc_fifo_write : std_logic;
    
    signal writeSourceSelect : std_logic :='0';  
--    signal sample_48k : std_logic := '0';
    signal writeDACFifoClk  : std_logic := '0';
    
    
    signal packet_count : std_logic_vector(PACKET_COUNT_W-1 downto 0):= x"0000_01E0";
    signal packet_count_mirror : unsigned(PACKET_COUNT_W-1 downto 0):=  x"0000_01E0";
    signal packet_count_cnt, packet_dumped_cnt : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    signal packet_count_final, packet_dumped_cnt_final : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    
    
    signal buf_count : std_logic_vector(BUF_COUNT_W-1 downto 0):= x"0000_01E0";--0x1E0 is 5ms
    signal buf_count_mirror : unsigned(BUF_COUNT_W-1 downto 0):=  x"0000_01E0";
    
    
    signal buf_count_err, buf_count_err_corr, buf_count_err_net : unsigned(BUF_COUNT_W-1 downto 0)  := (others => '0');
    signal buf_count_err_final : unsigned(BUF_COUNT_W-1 downto 0)  := (others => '0');
    signal buf_err_corr : std_logic := '0';

    
    signal enablePacketCount      : std_logic := '0';
    signal enablePacketCount_final: std_logic := '0';
    signal resetPktCount            : std_logic := '0';
    
    signal leftOut24BitTmp,rightOut24BitTmp : std_logic_vector(23 downto 0);
    signal newsample_reg, newsample_change, newsample_rdy : std_logic := '0';
    signal newsample_125 : std_logic := '0';
    signal fifo_write, fifo_write_reg, fifo_write_change : std_logic := '0';
    signal sample_buf_good, dac_fifo_read, dac_fifo_read_reg, dac_fifo_read_change, replace_pkt_raw : std_logic := '0';
    
    
    
    signal fifo_writes,  fifo_reads, fifo_reads_125, left_fifo_occ,right_fifo_occ,fifo_occ, fifo_reads_125_tmp, fifo_reads_125_tmp1, fifo_occ_lim: unsigned(FIFO_ADDR_WIDTH -1 downto 0);
    signal  rxtc_fifo_occ  : unsigned(8 -1 downto 0);
    signal resetFifos     : std_logic := '0';
    
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
    
    
    
    signal adcLeftData, adcRightData : std_logic_vector(23 downto 0);
    signal testLeftData, testRightData : std_logic_vector(23 downto 0);
    signal ethLeftData, ethRightData : std_logic_vector(23 downto 0);
    
    
    constant TEST_PULSE_WIDTH :natural := 3125000;-- 20Hz @ 125MHz ;1200000;--20Hz @ 48MHz base clock
    signal testWave24Bit : std_logic_vector(23 downto 0) := X"00FFFF";
    signal testWaveTimer : unsigned(32 downto 0);
    
--    signal hdrbytecount : unsigned(7 downto 0) := (others => '0');
    signal hdr_length  : unsigned(7 downto 0) :=  X"0C";
    
    signal rx_time_code_1, rx_time_code_2, rx_time_code_3, rx_time_code_4, rx_packet_seq_cnt_1, rx_packet_seq_cnt_2 : std_logic_vector(7 downto 0) :=  X"00";
    
--    signal m_audio_payload_hdr_valid_next : std_logic := '0';
--    signal m_audio_payload_hdr_valid_reg : std_logic  := '0';
    
    signal hdr_strip : std_logic  := '1';
    signal test_mode : std_logic := '0';
    signal test_pattern : std_logic_vector(2 downto 0):= b"100";
    signal test_mode_final : std_logic := '0';
    signal test_sig_sel : std_logic_vector(3 downto 0);
    
    signal leftTest24Bit,rightTest24Bit : unsigned(23 downto 0) := (others => '0');
    
    signal stream_pkt_start : std_logic  := '1';
    signal hdrstrip_reg, hdrstrip : std_logic  := '0';
    signal tc_sync , tc_sync_reg, tc_sync_125, tc_sync_int, play_out_en : std_logic  := '0';
    signal sync_time_code      : unsigned(TC_BIT_LENGTH  -1 downto 0) := X"0000_0000";
    signal rx_time_code : std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
    signal rx_time_code_fout : std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
    signal rx_time_code_eff : std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
    signal play_out_delay : std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
    signal play_out_time : unsigned(TC_BIT_LENGTH  -1 downto 0);
    
    signal rx_packet_seq_cnt : std_logic_vector(PACKET_SEQ_W-1 downto 0);
    
    signal buf_corr_window        : unsigned(BUF_COUNT_W-1 downto 0);
    signal enable_buf_corr, tc_sync_en, axis_tlast_pulse, axis_tlast_reg           : std_logic;
    
    signal lock_pkts_limit : unsigned(31 downto 0);
    signal lock_pkts_count : unsigned(31 downto 0) := X"0000_0000";
    
    
    signal PktEnd_R, PktEnd_L, plc_pkt_end         : std_logic;      

        
        -- Writing port.


begin

    -- Instantiation of Axi Bus Interface S00_AXI
    plc_downstream_v1_0_S00_AXI_inst : plc_downstream_v1_0_S00_AXI
	generic map (
	   TC_BIT_LENGTH => TC_BIT_LENGTH,
        PACKET_SEQ_W  => PACKET_SEQ_W,
        FIFO_ADDR_WIDTH => FIFO_ADDR_WIDTH,
        PACKET_COUNT_W  => PACKET_COUNT_W,
        BUF_COUNT_W     => BUF_COUNT_W, 
	
	
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        -- Register Management Port
       dacLeftFIFOEmpty_in => dacLeftFIFOEmpty,
       dacRightFIFOEmpty_in => dacRightFIFOEmpty,
       dacRightFIFOFull_in => dacRightFIFOFull,
       dacLeftFIFOFull_in => dacLeftFIFOFull,
       play_out_en_in => play_out_en,
       fifo_writes_in =>  fifo_writes ,
       fifo_reads_in => fifo_reads,
       fifo_occ_in => fifo_occ,
       rxtc_fifo_occ_in => rxtc_fifo_occ,
       buf_count_err_final_in => buf_count_err_final,
       
       buf_corr_window_out => buf_corr_window,
       packet_count_final_in => packet_count_final,
       packet_dumped_cnt_final_in => packet_dumped_cnt_final,
       sync_time_code_in      => sync_time_code ,
       rx_time_code_in => rx_time_code,
       rx_time_code_eff_in => rx_time_code_eff,
       rx_time_code_fout_in => rx_time_code_fout,
       play_out_time_in => play_out_time,
       
       lock_pkts_limit_out => lock_pkts_limit,
       
      payload_length_out   => payload_length,       
      fifo_occ_lim_out  => fifo_occ_lim,       
      enablePacketCount_out      => enablePacketCount,
      enable_buf_corr_out => enable_buf_corr,
      resetPktCount_out            => resetPktCount,  
      resetLeftDACFifo_out => resetLeftDACFifo,     
      resetRightDACFifo_out => resetRightDACFifo,     
      writeSourceSelect_out => writeSourceSelect,
      play_out_delay_out => play_out_delay,
      buf_count_out => buf_count,       
      hdr_strip_out => hdr_strip,
      hdr_length_out  => hdr_length,
      test_mode_out => test_mode,
      test_pattern_out => test_pattern,
        
        -- AXI Slave Port
        S_AXI_ACLK	=> s00_axi_aclk,
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
	
	packet_count_final <= packet_count_cnt;
    packet_dumped_cnt_final <= packet_dumped_cnt;
    enablePacketCount_final <= enablePacketCount;
    leftFifo24BitInEth <= leftOut24BitTmp;
    rightFifo24BitInEth <= rightOut24BitTmp;
--    rx_time_code_out <= rx_time_code;
--    rx_packet_seq_cnt_out <= rx_packet_seq_cnt;
    
     -- s_axis_reader Process
    s_axis_reader: process(CLK_125,s00_axi_aresetn, rst_in, s_ch1_audio_payload_axis_tlast) is
        type state_type is (st_idle, st_HdrBytes, st_ChkTc, st_DumpPkt, st_Lbyte1, st_Lbyte2, st_Lbyte3, st_Rbyte1, st_Rbyte2, st_Rbyte3, st_Lock);
    variable state : state_type := st_idle;
        variable bytecount : integer range 0 to 2400 := 0;
        variable hdrbytecount : integer range 0 to 32 := 0;
        
        
    begin
    
        if rising_edge(CLK_125) then
            
            if s00_axi_aresetn = '0' or rst_in = '1' then
                -- Reset
                state := st_Lock; -- go to lock state to sync packet
                state_val <= "11111";
                bytecount := 0;
--                hdrbytecount <= (others => '0');
                hdrbytecount := 0;
                hdr_ready <= '0';
                stream_pkt_start <= '1';
                writeRightDACFifoEth <= '0';
                writeLeftDACFifoEth <= '0'; 
                tready <= '0';
                first_pkt_rdr <= '0';
                first_pkt_wrt <= '1';
                rxtc_fifo_write <= '0';
                resetErrCount <= '0';
                plc_pkt_end  <= '0';
                --lock_pkts_limit <= X"0000_0400";
                lock_pkts_count <= X"0000_0000";
--                rx_time_code_out <= (others => '0');
--                rx_packet_seq_cnt_out  <= (others => '0');
                fifo_writes <= (others => '0');
                buf_count_err_corr <= (others => '0');
                rx_time_code <= (others => '0');
                
                rx_time_code_1  <= (others => '0');
                rx_time_code_2  <= (others => '0');
                rx_time_code_3  <= (others => '0');
                rx_time_code_4 <= (others => '0');
                
                rx_packet_seq_cnt_1  <= (others => '0');
                rx_packet_seq_cnt_2 <= (others => '0');
            else
                
                --bytecount := 0;
                --tready <= '0';
                --hdr_ready <= '0';
                case state is
                    when st_idle => 
                           --status1_out  <= '1';                          
                           if((dacRightFIFOFull='0' or dacLeftFIFOFull = '0') and (stream_pkt_start = '1')) then
                                writeRightDACFifoEth <= '0';
                                writeLeftDACFifoEth <= '0';   
                                hdr_ready <= '1'; 
                                tready <= '0';
                                plc_pkt_end  <= '0';  

                                if hdr_strip = '1' and tvalid = '1' then   
                                     
                                    state := st_HdrBytes;
                                    state_val <= "00001";
                                    tready <= '1';
                                    stream_pkt_start <= '0';
                                elsif hdr_strip = '0' and tvalid = '1' then 
                                    state := st_Lbyte1;
                                    state_val <= "00100";
                                    tready <= '1';
                                    stream_pkt_start <= '0';                                
                                end if;
                                
                                
--                                hdrbytecount <= (others => '0');
                                hdrbytecount := 0;
                            elsif((dacRightFIFOFull='0' or dacLeftFIFOFull = '0') and (stream_pkt_start = '0')) then
                                hdr_ready <= '1';       
                                state := st_Lbyte1;
                                state_val <= "00100";
                                tready <= '1';
                                writeRightDACFifoEth <= '0';
                                writeLeftDACFifoEth <= '0';   
                            else
                                hdr_ready <= '0';
                                tready <= '0';
                            end if;
                                                 
                            --bytecount := 0;  
                            
                    --HDR is LSB first    
                    when st_HdrBytes =>
                        
                        hdr_ready <= hdr_ready;
--                        rxtc_fifo_write <= '0';  
                        if tvalid = '1' and (hdrbytecount < hdr_length-1) then
--                            leftOut24BitTmp(23 downto 16) <= tdata;                                 
                            tready <= '1';
                            
                            if (hdrbytecount = 0) then
                                rx_packet_seq_cnt_2 <= tdata;                                
                                state_val <= "10000";
                            elsif(hdrbytecount = 1) then
                                rx_packet_seq_cnt_1 <= tdata; 
                                state_val <= "10001";                         
                            elsif(hdrbytecount = 2) then
                                rx_time_code_4 <= tdata;--lsb first       
                                state_val <= "10010";                 
                            elsif(hdrbytecount = 3) then
                                rx_time_code_3 <= tdata; 
                                state_val <= "10011";                               
                            elsif(hdrbytecount = 4) then
                                rx_time_code_2 <= tdata;  
                                state_val <= "10100";                             
                            elsif(hdrbytecount = 5) then
                                rx_time_code_1 <= tdata;  
                                state_val <= "10101";
                            elsif(hdrbytecount = 6) then
                                rx_packet_seq_cnt <= rx_packet_seq_cnt_1 & rx_packet_seq_cnt_2;
--                                if(tc_sync_en = '1') then
                                rx_time_code <= rx_time_code_1 & rx_time_code_2 & rx_time_code_3 & rx_time_code_4; 
                                                                   
--                                else
--                                    rx_time_code <= (others => '0');
--                                end if;
--                            elsif(hdrbytecount = 7) and (first_pkt_rdr = '1') then
--                                rxtc_fifo_write <= '1';                                
                                state_val <= "10110";
                            end if;
                            
                            bytecount := bytecount + 1;
                            hdrbytecount := hdrbytecount + 1;
                            state := st_HdrBytes; 
                            --state_val <= "00001"; 
                        elsif tvalid = '1' and (hdrbytecount >= hdr_length-1) then
--                            if first_pkt_wrt <= '1' then
--                                rxtc_fifo_write <= '1';  
--                            end if;
--                            leftOut24BitTmp(23 downto 16) <= tdata;
--                            if ((play_out_en = '1') or (tc_sync_en = '0')) then
                                state := st_ChkTc;
                                state_val <= "00010";
                                hdrbytecount := 0;
                                bytecount := bytecount + 1;
                                tready <= '0';
--                            else
--                                tready <= '0';
--                                state := st_HdrBytes;
--                                bytecount := bytecount;
--                                hdrbytecount := hdrbytecount;
--                            end if;
                             
                            
                            
                            -- TC LSB first
--                            rx_time_code <= rx_time_code_1 & rx_time_code_2 & rx_time_code_3 & rx_time_code_4;
--                            rx_packet_seq_cnt <= rx_packet_seq_cnt_1 & rx_packet_seq_cnt_2;
                        end if;
                        
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                        
                        
                   when st_ChkTc => -- needed
                       writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                       if (play_out_en = '1') then 
                            state := st_Lbyte1;
                            state_val <= "00100";
                            hdrbytecount := 0;
                            bytecount := bytecount;
                            tready <= '1';
--                        elsif ((unsigned(buf_count_err) >= unsigned(payload_length)-1)) then
--                            state := st_dumpPkt;
--                              buf_count_err_corr <= buf_count_err_corr + payload_length - 1;
                        else    -- block until we are good
                            state := st_ChkTc;
                            state_val <= "00010";
                            hdrbytecount := 0;
                            bytecount := bytecount;
                            tready <= '0';
                        
                        end if;
                        
                    when st_DumpPkt =>
                            tready <= '1';
                            resetErrCount <= '0';
                            state := st_DumpPkt;
                            writeRightDACFifoEth <= '0';
                            writeLeftDACFifoEth <= '0';
                            if s_ch1_audio_payload_axis_tlast = '1' then
                                state := st_idle;  
                               bytecount := 0; 
                               hdr_ready <= '1';
                               tready <= '0';
                                first_pkt_rdr <= '1';
                               stream_pkt_start <= '1';  
                               packet_dumped_cnt <= packet_dumped_cnt + 1;
                               
                            end if;
                    --MSB first    
                    
                    when st_Lbyte1 =>
                        tready <= '1';
                        rxtc_fifo_write <= '0';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
--                            if replace_inprogress_in = '1' then
--                                rightOut24BitTmp(7 downto 0) <= tdata;
--                            else
                                leftOut24BitTmp(23 downto 16) <= tdata;
--                            end if;
                            state := st_Lbyte2; 
                            state_val <= "00101";
                            bytecount := bytecount + 1;
                        end if;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                        
                        
                    when st_Lbyte2 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            --leftOut24BitTmp(15 downto 8) <= tdata;
--                            if replace_inprogress_in = '1' then
--                                rightOut24BitTmp(15 downto 8) <= tdata;
--                            else
                                leftOut24BitTmp(15 downto 8) <= tdata;
--                            end if;
                            state := st_Lbyte3; 
                            state_val <= "00110";
                            bytecount := bytecount + 1;
                        end if;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                    when st_Lbyte3 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            
--                            if replace_inprogress_in = '1' then
--                                rightOut24BitTmp(23 downto 16) <= tdata;
--                            else
                                leftOut24BitTmp(7 downto 0) <= tdata;
--                            end if;
                            state := st_Rbyte1; 
                            state_val <= "01000";
                            bytecount := bytecount + 1;                            
                        end if;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                  
                        
                   when st_Rbyte1 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            --rightOut24BitTmp(23 downto 16) <= tdata;
--                            if replace_inprogress_in = '1' then
--                                leftOut24BitTmp(7 downto 0) <= tdata;
--                            else
                                rightOut24BitTmp(23 downto 16) <= tdata;
--                            end if;
                            state := st_Rbyte2; 
                            state_val <= "01001";
                            bytecount := bytecount + 1;                            
                        end if;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                        
                    when st_Rbyte2 =>
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        if tvalid = '1' then
                            --rightOut24BitTmp(15 downto 8) <= tdata;
--                            if replace_inprogress_in = '1' then
--                                leftOut24BitTmp(15 downto 8) <= tdata;
--                            else
                                rightOut24BitTmp(15 downto 8) <= tdata;
--                            end if;
                            state := st_Rbyte3; 
                            state_val <= "01010";
                            bytecount := bytecount + 1;
                        end if;
                        
                   when st_Rbyte3 =>
                        tready <= '0';
                        hdr_ready <= hdr_ready;
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0';
                        if tvalid = '1' then
                            --rightOut24BitTmp(7 downto 0) <= tdata;
--                            if replace_inprogress_in = '1' then
--                                leftOut24BitTmp(23 downto 16) <= tdata;
--                            else
                                rightOut24BitTmp(7 downto 0) <= tdata;
--                            end if;
                            bytecount := bytecount + 1; 
                            if ((buf_err_corr = '1') and (tc_sync_en = '1')) then  --- drop sample for soft correction                     
                                writeRightDACFifoEth <= '0';
                                writeLeftDACFifoEth <= '0';
                                fifo_writes <= fifo_writes;
                                buf_count_err_corr <= buf_count_err_corr + 1;
                            else
                                writeRightDACFifoEth <= '1';
                                writeLeftDACFifoEth <= '1';
                                buf_count_err_corr <= buf_count_err_corr;
                                fifo_writes <= fifo_writes + 1;
                            
                            end if;

                                state := st_idle; 
                                state_val <= "00000";
                      
                            
                        
                        
                        if s_ch1_audio_payload_axis_tlast = '1' then
                           bytecount := 0; 
                           hdr_ready <= '1';
                           --status1_out  <= '0'; 
                            first_pkt_rdr <= '1';
                           stream_pkt_start <= '1';
                           first_pkt_wrt <= '0';
                           plc_pkt_end  <= '1';  

                           if enablePacketCount_final = '1' then
                                packet_count_cnt <= packet_count_cnt + 1;
--                                if (packet_count_cnt_final >= (packet_count_mirror-1) ) then        
--                                    packet_count_cnt    <= (others => '0');
--                                end if;  
                            end if;   
                        end if;
                        
                     end if;   
                    when st_Lock =>    
                       
                       
                        if axis_tlast_pulse = '1' then                            
                            lock_pkts_count <= lock_pkts_count + 1;                           
                        else                        
                            lock_pkts_count <= lock_pkts_count;
                        end if;
                        
                        if lock_pkts_count >= lock_pkts_limit then
                            state := st_idle; 
                            state_val <= "00000";
                            tready <= '0';
                        else                        
                             state_val <= "11111";
                            state := st_Lock; 
                            tready <= '1';
                            rx_time_code_1  <= (others => '0');
                            rx_time_code_2  <= (others => '0');
                            rx_time_code_3  <= (others => '0');
                            rx_time_code_4 <= (others => '0');
                            rx_time_code <= (others => '0');
                        end if;
                        
                        
                   when others =>
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0';
                        state := st_idle;
                        state_val <= "00000";
                        hdr_ready <= '0';
                        writeRightDACFifoEth <= '0';
                        writeLeftDACFifoEth <= '0'; 
                        tready <= '0';  
                        rxtc_fifo_write <= '0';  
                end case;
                
                
                if resetPktCount = '1' then
                    packet_count_cnt <= (others => '0');
                end if;
                               
                if (resetLeftDACFifo ='1' or resetRightDACFifo  ='1') then
--                    state := st_idle;
--                    state_val <= "00000";
                    state_val <= "11111";
                    state := st_Lock; 
                    bytecount := 0;
                    hdrbytecount := 0;
                    hdr_ready <= '0';
                    plc_pkt_end  <= '0'; 
                    first_pkt_wrt <= '1';
                    stream_pkt_start <= '1';
                    writeRightDACFifoEth <= '0';
                    writeLeftDACFifoEth <= '0'; 
                    rxtc_fifo_write <= '0';  
                    first_pkt_rdr <= '0';
                    tready <= '0';
                    resetErrCount <= '0';
                    --lock_pkts_limit <= X"0000_0400";
                    lock_pkts_count <= X"0000_0000";
                    rx_time_code_1  <= (others => '0');
                    rx_time_code_2  <= (others => '0');
                    rx_time_code_3  <= (others => '0');
                    rx_time_code_4 <= (others => '0');
                    rx_time_code <= (others => '0');
                    buf_count_err_corr <= (others => '0');
                    fifo_writes <= (others => '0');
--                    rx_time_code_out <= (others => '0');
                    
--                    rx_packet_seq_cnt_out  <= (others => '0');
--                    rx_packet_seq_cnt_1  <= (others => '0');
--                    rx_packet_seq_cnt_2 <= (others => '0');
--                    buf_count_cnt <= (others => '0');
                end if;
                
                
                 if (tc_sync_en = '0') then
                    rx_time_code_1  <= (others => '0');
                    rx_time_code_2  <= (others => '0');
                    rx_time_code_3  <= (others => '0');
                    rx_time_code_4 <= (others => '0');
                    rx_time_code <= (others => '0');
                    buf_count_err_corr <= (others => '0');
                        
                end if;
        end if;
    end if;
            
end process;








-- This syncronises the newsample_in signal to the axis 125MHz clock
newsample_delay: process(CLK_125, s00_axi_aresetn, rst_in)
begin
    if s00_axi_aresetn = '0'  or rst_in = '1' then
        newsample_reg <= '0';        
    elsif rising_edge (CLK_125) then
        newsample_reg <= newsample_in;
    end if;
end process;

newsample_125 <= (newsample_in xor newsample_reg) when (newsample_in='1') else '0';
--newsample_change <= newsample_in; 


--clk_bufg_inst :  BUFG
--port map (
--    I => (newsample_in),
----    I => (tc_sync_in),
--    O => (tc_sync_int)
    
--);
tc_sync_int <= newsample_in;


tc_sync_process: process(CLK_125, s00_axi_aresetn, rst_in)
begin
    if s00_axi_aresetn = '0' or rst_in = '1' then
        tc_sync_reg <= '0';        
    elsif rising_edge (CLK_125) then
        tc_sync_reg <= tc_sync_int;
    end if;
end process;

tc_sync_125 <= (tc_sync_int xor tc_sync_reg) when (tc_sync_int='1') else '0';


tlast_pulse_process: process(CLK_125, s00_axi_aresetn, rst_in)
begin
    if s00_axi_aresetn = '0' or rst_in = '1' then
        axis_tlast_reg <= '0';        
    elsif rising_edge (CLK_125) then
        axis_tlast_reg <=  s_ch1_audio_payload_axis_tlast;
    end if;
end process;

axis_tlast_pulse <=   (axis_tlast_reg xor s_ch1_audio_payload_axis_tlast) when s_ch1_audio_payload_axis_tlast = '1';


--tc_sync_count_process: process(CLK_125, s00_axi_aresetn, rst_in)
--begin
--    if s00_axi_aresetn = '0' or rst_in = '1' then
--        --sync_time_code <= (others=>'0');      
--    elsif rising_edge (CLK_125) then
--        if ((tc_sync_125 = '1') and (tc_sync_en = '1') and (tc_adjust_in = '0')) then
--            sync_time_code <= sync_time_code + 1; 
--        elsif (tc_adjust_in = '1') then
--            sync_time_code <= unsigned(tc_count_adjust) + 1;     
--        elsif (tc_sync_en = '0') then
--            sync_time_code <= (others=>'0');     
--        end if;        
    
--    end if;
--end process;

--sync_time_code_out <= sync_time_code;
--rx_time_code_eff <= rx_time_code when (first_pkt_wrt = '1') else rx_time_code_fout;
--rx_time_code_eff <= rx_time_code_fout;
rx_time_code_eff <= rx_time_code;

playout_process: process(CLK_125, s00_axi_aresetn, rst_in)
begin
    if s00_axi_aresetn = '0' or rst_in = '1' then
        play_out_time <= (others=>'0');      
    elsif rising_edge (CLK_125) then   
    
        if (state_val = "11111") then
              play_out_time <= (others=>'0');   
        elsif (tc_sync_en = '1') then
              play_out_time <= (unsigned(rx_time_code_eff) + unsigned(play_out_delay)); 
        else    
              play_out_time <= (others=>'0');   
        end if;    
        
        
          
    end if;
end process;



--play_out_time <= (unsigned(rx_time_code) + unsigned(play_out_delay)) when (tc_sync_en = '1') else (others=>'0');

--play_out_en <= '1' when (sync_time_code >= play_out_time) or (replace_inprogress_in = '1') else '0';
play_out_en <= '1' when ((state_val /= "11111") and ((sync_time_code >= play_out_time) or (tc_sync_en = '0'))) else '0';
--play_out_en <= '0' when ((sync_time_code < play_out_time) and (tc_sync_en = '1')) else '1';

play_out_ready_out <= play_out_en;
--dac_fifo_read <= play_out_en; -- now only used to control the axis bus only
dac_fifo_read <= replace_inprogress_in; 


fifo_empty_read: process(CLK_125, s00_axi_aresetn, rst_in)
begin
    if s00_axi_aresetn = '0' or rst_in = '1' then
        buf_count_err <= (others => '0');  
    elsif rising_edge (CLK_125) then      
        
        if ((newsample_125='1') and (dacLeftFIFOEmpty = '1') and (tc_sync_en = '1') and (play_out_en = '1') and (enable_buf_corr = '1') and (unsigned(rx_time_code)>0))  then
            buf_count_err <= buf_count_err + 1; 
        elsif ((enable_buf_corr = '0') or (resetLeftDACFifo ='1') or (tc_sync_en = '0')) then          
            buf_count_err <= (others => '0');     
        end if;
        
    end if;
end process;


fifo_empty_read_net: process(CLK_125, s00_axi_aresetn, rst_in)
begin
    if s00_axi_aresetn = '0' or rst_in = '1' then
        buf_count_err_net <= (others => '0');
    elsif rising_edge (CLK_125) then    
        
        if (buf_count_err < buf_count_err_corr) then
          buf_count_err_net <= BUF_ERR_DEPTH - (buf_count_err_corr - buf_count_err);
        else
          buf_count_err_net <= buf_count_err - buf_count_err_corr;
        end if;
        
        
        if ((enable_buf_corr = '0') or (resetLeftDACFifo ='1') or (tc_sync_en = '0')) then          
            buf_count_err_net <= (others => '0');
        end if;
        
    end if;
end process;

buf_err_corr <= '1' when ((buf_count_err_net > buf_corr_window) and (tc_sync_en = '1')) else '0';

test_pattern_gen : process(CLK_125, s00_axi_aresetn, rst_in)                                                                        
  begin   
    if s00_axi_aresetn = '0'  or rst_in = '1' then
--        adcLeftData <= (others => '0'); 
--        adcRightData <= (others => '0'); 
        leftTest24Bit <= (others => '0');
        rightTest24Bit <= (others => '0');
        testWaveTimer <= (others => '0');
        
    elsif (rising_edge (CLK_125)) then  
--            newsample_125 <= newsample_change; --one reg delay to avoid quick read 
                testWaveTimer <= testWaveTimer+1;
                 if (testWaveTimer = TEST_PULSE_WIDTH) then 
                    testWaveTimer <= (others => '0');
                    testWave24Bit(23) <= testWave24Bit(23) xor '1';
                end if;
                
                
                
                if (newsample_125 = '1') then
                       
                    case (test_sig_sel) is
                        when "1000" =>  
                            leftTest24Bit  <= leftTest24Bit +1;
                            rightTest24Bit <= rightTest24Bit +1;
                        when "1001" => 
                            leftTest24Bit  <= X"555555";
                            rightTest24Bit <= X"555555";                                
                        when "1010" =>  
                            leftTest24Bit  <= X"000000";
                            rightTest24Bit <= X"FFFFFF";    
                        when "1011" =>       
                            leftTest24Bit <= not leftTest24Bit;
                            rightTest24Bit <= not rightTest24Bit;  
                        when "1100" =>  
                           
                            leftTest24Bit  <= unsigned(testWave24Bit);     --b"0000_0000_0000_0000";  
                            rightTest24Bit <= unsigned(testWave24Bit); --b"0000_0000_0000_0000";
                        when others =>
                            leftTest24Bit <= leftTest24Bit;
                            rightTest24Bit <= rightTest24Bit;
                        end case;
                 
                end if; 
                
        end if; 
        
        if (resetLeftDACFifo ='1' or resetRightDACFifo  ='1') then
            leftTest24Bit <= (others => '0');
            rightTest24Bit <= (others => '0');
      end if;
                                                                            
  end process test_pattern_gen; 
  
  
  testLeftData <= std_logic_vector(leftTest24Bit);
  testRightData <= std_logic_vector(rightTest24Bit);
--  adcLeftData <= line_in_l_in;
--  adcRightData <= line_in_r_in;
  test_mode_final <= test_mode; 
  
  leftOut24Bit <= dacLeftFIFOData when (test_mode_final = '0') else testLeftData;
  rightOut24Bit <=  dacRightFIFOData when (test_mode_final = '0') else testRightData;


fifo_write <= (writeLeftDACFifoEth or writeRightDACFifoEth);


    --fifo_write_change <= (fifo_write xor fifo_write_reg) when (fifo_write='1') else '0';
fifo_write_change <= (writeLeftDACFifoEth or writeRightDACFifoEth);

--dac_fifo_read_change <= (dac_fifo_read xor dac_fifo_read_reg) when (dac_fifo_read='1') else '0';
dac_fifo_read_change <= dac_fifo_read;
    

    
    
    writeLeftDACFifo <= writeLeftDACFifoEth;-- when (writeSourceSelect = '0') else writeLeftDACFifoArm;
    writeRightDACFifo <= writeRightDACFifoEth;-- when (writeSourceSelect = '0') else writeRightDACFifoArm;
    
    
    writeDACFifoClk <= CLK_125;-- when (writeSourceSelect = '0') else s00_axi_aclk;
    
    
    leftFifo24BitIn <= leftFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
    rightFifo24BitIn <= rightFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
    

--    payload_length <= wValue(15 downto  0) when (writeReg = '1' and wAdr="0011") else payload_length;
    
    FIFO_L_OutDAC : DualClockLIFO
    generic map (
        DATA_WIDTH => FIFO_DATA_WIDTH,
        ADDR_WIDTH => FIFO_ADDR_WIDTH
    )
    port map (
        -- Reading port.
        Data_out    => dacLeftFIFOData,
        Empty_out   => dacLeftFIFOEmpty,
        ReadEn_in   => dac_fifo_read,
        RClk        => newsample_125,
        
        PktEnd_out  => PktEnd_L,
        Replace_pkt_in => replace_pkt_in,
        Replace_inprogress_in  =>   replace_inprogress_in, --- This can also do Replace_overlap by prolonging it until the end of the first packet
        
        -- Writing port.
        
        PktEnd_in  => plc_pkt_end,
        Data_in     => leftFifo24BitIn,
        Full_out    => dacLeftFIFOFull,
        WriteEn_in  => writeLeftDACFifo,
        WClk        => writeDACFifoClk,
     
        fifo_occ_out => left_fifo_occ,--open,
        Clear_in    => resetFifos
    );
    
    
    
    
    FIFO_R_OutDAC : DualClockLIFO
    generic map (
        DATA_WIDTH => FIFO_DATA_WIDTH,
        ADDR_WIDTH => FIFO_ADDR_WIDTH
    )
    port map (
        -- Reading port.
        Data_out    => dacRightFIFOData,
        Empty_out   => dacRightFIFOEmpty,
        ReadEn_in   => dac_fifo_read,
        RClk        => newsample_125,
        
        PktEnd_out  => PktEnd_R,
        Replace_pkt_in => replace_pkt_in,
        Replace_inprogress_in  =>   replace_inprogress_in, --- This can also do Replace_overlap by prolonging it until the end of the first packet
        
        -- Writing port.
        
        PktEnd_in  => plc_pkt_end,

        Data_in     => rightFifo24BitIn,
        Full_out    => dacRightFIFOFull,
        WriteEn_in  => writeRightDACFifo,
        WClk        => writeDACFifoClk,
     
        fifo_occ_out => open,--right_fifo_occ,
        Clear_in    => resetFifos
    );
    
    resetFifos <= '1' when (resetRightDACFifo = '1' or resetLeftDACFifo = '1' or s00_axi_aresetn = '0' or rst_in = '1') else '0';
    
    fade_direction_out <= '1';  --- down

    replace_pkt_end_out <= PktEnd_R;
    tc_sync_en <= tc_sync_en_in;

    test_sig_sel <= (test_mode_final & test_pattern);
    -- IRQ Generation.
    -- TODO (2), make sure we generate ONE pulse ? Assert until... ?
    irq_out <= '0';
    
--    leftIn24Bit <= line_in_l_in;
--    rightIn24Bit <= line_in_r_in;
    audio_l_out <= leftOut24Bit;
    audio_r_out <= rightOut24Bit;
--        newsample_125 <= newsample_in;
--    needNewSample <= newsample_in;
--    sample_48k <= sample_48k_in;
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
	
--    fifo_occ <= (fifo_writes - fifo_reads_125 ) when (fifo_writes >= fifo_reads_125) else ((((2**(FIFO_ADDR_WIDTH))) - fifo_reads_125) + fifo_writes);
    --fifo_occ <= (fifo_writes - fifo_reads ) when (fifo_writes >= fifo_reads) else ( fifo_writes - fifo_reads + ((2**(FIFO_ADDR_WIDTH))-1));
--    fifo_occ_out <= STD_LOGIC_VECTOR(fifo_occ);
    fifo_occ <= left_fifo_occ;
    fifo_occ_out <= STD_LOGIC_VECTOR(fifo_occ);
--    replace_pkt_raw <= '1' when ((fifo_occ < fifo_occ_lim) and (sample_buf_good = '1')) else '0';
--    replace_pkt_raw <= '1' when ((fifo_occ < fifo_occ_lim) and (play_out_en = '1')) else '0';
--    replace_pkt_out <= replace_pkt_raw;
--    replace_pkt_raw <= '1' when ((dacRightFIFOEmpty='1' or dacLeftFIFOEmpty = '1') and (sample_buf_good = '1')) else '0';
    sync_time_code <= sync_time_code_in;
    status2_out  <= '1' when state_val = "00000" else '0';  
    status1_out  <= '1' when (dacRightFIFOFull='0' or dacLeftFIFOFull = '0') else '0';
    
end arch_imp;

