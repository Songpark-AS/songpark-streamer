library ieee;
--library extras;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use extras.synchronizing.reset_synchronizer;

entity eth_to_audio_plc_combo_interface_v2_0 is
	generic (
		-- Users to add parameters here
        PACKET_COUNT_W             : natural   :=  32;
        FIFO_DATA_WIDTH           : natural := 24;
		FIFO_ADDR_WIDTH           : natural := 8;
		LIFO_ADDR_WIDTH           : natural := 13;
		SIM_PKT_LEN_WIDTH :integer := 4;
		--SIM_PKT_SIZE : integer := 16; -- must be a factor of pkt size and a power of 2
		GLITCH_FILTER_LENGTH   : natural := 15;
		TC_BIT_LENGTH               : natural   :=  32;
--		HDR_LENGTH              : natural := 12;
		BUF_COUNT_W             : natural   :=  32;
		PACKET_SEQ_W: natural   :=  16;
		S_COUNT: natural   :=  64;-- number of SEQ slots
		STEP_WIDTH     : natural   :=  32;
		 INTBIT_WIDTH  : integer := 24;
        FRACBIT_WIDTH : integer := 8; --now, its calculated below, in port mapping
        
        REL_PIPE_LENGTH : integer := 12;
        EXIT_FADE_LENGTH : integer := 96; -- must be >= 96
        ENTRY_FADE_LENGTH : integer := 10;
        COMP_SIG_OUT_WIDTH :integer := 30;
        CIC_SIG_OUT_WIDTH :integer := 28;
        CIC_SIG_IN_WIDTH :integer := 24;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 7;
		AXIS_UDP_DATA_WIDTH         : integer   := 8
		
		
	);
	port (
		-- Users to add ports here
		rst_out           : out    STD_LOGIC;
		
        dpk_audio_l_out            : out STD_LOGIC_VECTOR(23 downto 0);
        dpk_audio_r_out            : out STD_LOGIC_VECTOR(23 downto 0);
        
        plc_audio_l_out            : out STD_LOGIC_VECTOR(23 downto 0);
        plc_audio_r_out            : out STD_LOGIC_VECTOR(23 downto 0);
        
        fifo_occ_out            : out STD_LOGIC_VECTOR(FIFO_ADDR_WIDTH -1 downto 0);
        play_out_ready_out                 : out    STD_LOGIC; 
        replace_pkt_out  : out    STD_LOGIC; 
        newsample_in           : in    STD_LOGIC;
        
        
--        tc_sync_in           : in    STD_LOGIC;
        tc_sync_en_in           : in    STD_LOGIC;
        
        new_pkt_ready_in       : in     STD_LOGIC;
--        replace_pkt_end_in     : in     STD_LOGIC;
        dpk_pkt_end_out        : out    STD_LOGIC;
        plc_pkt_end_out        : out    STD_LOGIC;
        
         status1_out           : out    STD_LOGIC;
         status2_out           : out    STD_LOGIC;
        
        
--        tc_adjust_in : in    STD_LOGIC;
--        tc_count_adjust : in STD_LOGIC_VECTOR(TC_BIT_LENGTH-1 downto 0);

        sync_time_code_in : in STD_LOGIC_VECTOR(TC_BIT_LENGTH-1 downto 0);
        
--        tc_sync_en_int_in           : in    STD_LOGIC;
        
        rx_time_code_out        : out std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
        rx_packet_seq_cnt_out   : out std_logic_vector(PACKET_SEQ_W-1 downto 0);
--        sync_time_code_out      : out unsigned(TC_BIT_LENGTH  -1 downto 0);
        
--        tsync_in                : in    STD_LOGIC; 
--        sync_en_in             : in    STD_LOGIC; 
--        sample_48k_in           : in    STD_LOGIC;
        irq_out                 : out    STD_LOGIC; 
--		clk_48                  :  in    STD_LOGIC;
		fifo_full_out                 : out    STD_LOGIC; 
		fifo_empty_out                 : out    STD_LOGIC; 
		replace_inprogress_in         : in    STD_LOGIC;
--		-- PS Side
--        IRQ      : out   STD_LOGIC;
        
        -- Board Side
          --CLK_100  : in    STD_LOGIC;
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

        fade_dpk_enable_out       : out STD_LOGIC;
        fade_plc_enable_out       : out STD_LOGIC;
		fade_plc_direction_out    : out STD_LOGIC;
		fade_dpkt_direction_out   : out STD_LOGIC;
		fade_dpk_clear_out        : out STD_LOGIC;
		fade_plc_clear_out        : out STD_LOGIC;
		
		fade_dpk_max_out              : out STD_LOGIC;
		fade_dpk_min_out              : out STD_LOGIC;
		
		fade_plc_max_out              : out STD_LOGIC;
		fade_plc_min_out              : out STD_LOGIC;
		

--		IN_SIG_L      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
--		IN_SIG_R      : in  signed((INTBIT_WIDTH - 1) downto 0); --amplifier input signal 24-bit
		UP_STEP_PULSES_OUT	: out std_logic_vector(STEP_WIDTH-1 downto 0);
		DOWN_STEP_PULSES_OUT	: out std_logic_vector(STEP_WIDTH-1 downto 0);
		COEF_MIN_OUT     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		COEF_MAX_OUT     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
--		COEF_IN     : in  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1

        newsample_125_out: out STD_LOGIC;
        
        
        play_out_delay_out : out std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
       next_play_out_time_out : out std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
       current_sync_time_out : out std_logic_vector(TC_BIT_LENGTH  -1 downto 0);    
        skip_slot_out: out STD_LOGIC;
        
        packet_available_in : in STD_LOGIC;

        
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
    s_ch1_audio_payload_axis_aresetn : in std_logic;
    
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
end eth_to_audio_plc_combo_interface_v2_0;

architecture arch_imp of eth_to_audio_plc_combo_interface_v2_0 is 

 
	-- component declaration
	component eth_to_audio_interface_v2_0_S00_AXI is
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


        dacLeftFIFOEmpty_in : in std_logic;
       dacLeftFIFOFull_in : in std_logic;
       dacRightFIFOEmpty_in : in std_logic;
       dacRightFIFOFull_in : in std_logic;
       play_out_en_in : in std_logic;
       fifo_writes_in  : in unsigned(FIFO_ADDR_WIDTH -1 downto 0);
       fifo_reads_in : in unsigned(FIFO_ADDR_WIDTH -1 downto 0);
       odd_fifo_occ_in : in unsigned(FIFO_ADDR_WIDTH -1 downto 0);
       even_fifo_occ_in : in unsigned(FIFO_ADDR_WIDTH -1 downto 0);
       rxtc_fifo_occ_in : in unsigned(8 -1 downto 0);
       --buf_count_err_final_in : in unsigned(BUF_COUNT_W-1 downto 0);
       packet_count_final_in : in unsigned(PACKET_COUNT_W-1 downto 0);  
          
       packet_dumped_cnt_final_in :  in unsigned(PACKET_COUNT_W-1 downto 0);   
       
       buf_corr_window_out        : out unsigned(BUF_COUNT_W-1 downto 0);  
     
       sync_time_code_in      : in unsigned(TC_BIT_LENGTH  -1 downto 0);
       rx_time_code_in : in std_logic_vector(TC_BIT_LENGTH  -1 downto 0);   
       rx_time_code_eff_in : in std_logic_vector(TC_BIT_LENGTH  -1 downto 0);   
       rx_time_code_fout_in  : in std_logic_vector(TC_BIT_LENGTH  -1 downto 0);   
       play_out_time_in : in unsigned(TC_BIT_LENGTH  -1 downto 0);
       
       
       UP_STEP_PULSES_OUT	: out std_logic_vector(STEP_WIDTH-1 downto 0);
		DOWN_STEP_PULSES_OUT	: out std_logic_vector(STEP_WIDTH-1 downto 0);
		COEF_MIN_OUT     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		COEF_MAX_OUT     : out  signed(((INTBIT_WIDTH + FRACBIT_WIDTH) - 1) downto 0); -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
       

       enableReplacePkt_out          : out std_logic;
       fifo_occ_lim_out  : out unsigned(FIFO_ADDR_WIDTH -1 downto 0);
--       fifo_occ_rep_lim_out : out unsigned(FIFO_ADDR_WIDTH -1 downto 0);
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
        
        media_timer_en_out : out std_logic;
        media_timer_limit_out : out unsigned(TC_BIT_LENGTH  -1 downto 0);
        e_slot_skip_count_out : out unsigned(TC_BIT_LENGTH  -1 downto 0);
        o_slot_skip_count_out : out unsigned(TC_BIT_LENGTH  -1 downto 0);
        
        late_allowance_out : out unsigned(TC_BIT_LENGTH  -1 downto 0);
        
        media_channel_dropped_in : in std_logic;
        
        replace_events_in  : in unsigned(TC_BIT_LENGTH  -1 downto 0);
        
        bad_pkt_count_in : in unsigned(TC_BIT_LENGTH  -1 downto 0);
		
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
	
    component SyncDualClockFIFO is
        generic (
            DATA_WIDTH :integer := 8;
            ADDR_WIDTH :integer := FIFO_ADDR_WIDTH
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
    end component;
    
    
    component cic_filter is 
    generic (
        SIG_IN_WIDTH :integer := CIC_SIG_IN_WIDTH;
        SIG_OUT_WIDTH :integer := CIC_SIG_OUT_WIDTH
    );
    port (
        clk: in std_logic;
        rst: in std_logic;
        x: in signed (CIC_SIG_IN_WIDTH-1 downto 0);
        dvi: in std_logic;
        y: out signed (CIC_SIG_OUT_WIDTH-1 downto 0);
        dvo: out std_logic
    );
end component;


--component cic_filter is 
--    generic (
--        SIG_IN_WIDTH :integer := CIC_SIG_IN_WIDTH;
--        SIG_OUT_WIDTH :integer := CIC_SIG_OUT_WIDTH
--    );
--    port (
--        x  : in std_logic_vector(SIG_IN_WIDTH-1 downto 0);
--    clock_slow     : in std_logic;
--    clock_fast     : in std_logic;
--    rst       : in std_logic; 
--    y     : out std_logic_vector(SIG_IN_WIDTH-1 downto 0);
--    dvo : out std_logic
--    );
--end component;


component compfilt is
generic (
        SIG_IN_WIDTH :integer := CIC_SIG_OUT_WIDTH;
        SIG_OUT_WIDTH :integer := COMP_SIG_OUT_WIDTH
    );
    port (
        clk: in std_logic;
        rst: in std_logic;
        x: in signed (SIG_IN_WIDTH-1 downto 0);
        xdv: in std_logic;
        y: out signed (SIG_OUT_WIDTH-1 downto 0);
        ydv: out std_logic
    );
end component;
    
    component DualClockLIFO is
        generic (
        DATA_WIDTH :integer := 8;
        ADDR_WIDTH :integer := 4;
        PKT_LEN_WIDTH :integer := 4;
        GUARD_SAMPLES : integer := 5
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
     
     
component  interpolator_basic is
generic( AUDIO_WIDTH  : integer := 24
);
  Port ( 
  audio_in            : in STD_LOGIC_VECTOR(23 downto 0);
  in_newsample           : in    STD_LOGIC;
  out_newsample           : in    STD_LOGIC;
  reset_in                    : in    STD_LOGIC;
  audio_out            : out STD_LOGIC_VECTOR(23 downto 0)  
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
	
	
	
    -- Physical Registers
    constant BUF_ERR_DEPTH :integer := 2**BUF_COUNT_W;
    signal resetOddDACFifo    : std_logic;
    signal resetEvenDACFifo    : std_logic;
    
    signal payload_length        : std_logic_vector( PACKET_SEQ_W  - 1 downto 0);
    signal sample_read_counter           : unsigned( PACKET_SEQ_W  - 1 downto 0);
    signal tready : std_logic := '0';
    signal tdata  : std_logic_vector(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
    signal hdr_ready : std_logic := '0';
     signal tvalid, tlast : std_logic := '0';
     
     
    
    signal state_val : std_logic_vector(4 downto 0);
    
    
    -- FIFO, Clock Connection
--    signal needNewSample : std_logic;
    signal leftOut24Bit,rightOut24Bit : std_logic_vector(23 downto 0);
--    signal leftOddOut24Bit,rightOddOut24Bit, leftEvenOut24Bit,rightEvenOut24Bit : std_logic_vector(23 downto 0);
--    signal leftOddIntOut24Bit, leftEvenIntOut24Bit, rightOddIntOut24Bit, rightEvenIntOut24Bit : signed(23 downto 0);
    signal leftIntOut24Bit, rightIntOut24Bit : signed(23 downto 0);
    
--    signal leftOddIntOut24Bit_tmp, leftEvenIntOut24Bit_tmp, rightOddIntOut24Bit_tmp, rightEvenIntOut24Bit_tmp : signed(COMP_SIG_OUT_WIDTH-1 downto 0);
    signal leftIntOut24Bit_tmp, rightIntOut24Bit_tmp : signed(COMP_SIG_OUT_WIDTH-1 downto 0);
    
--    signal leftOddIntOut24Bit_cic, leftEvenIntOut24Bit_cic, rightOddIntOut24Bit_cic, rightEvenIntOut24Bit_cic : signed(CIC_SIG_OUT_WIDTH-1 downto 0);
    signal leftIntOut24Bit_cic, rightIntOut24Bit_cic : signed(CIC_SIG_OUT_WIDTH-1 downto 0);
    
    
    signal dacLeftFIFOData, dacRightFIFOData  : std_logic_vector(23 downto 0);
    
    signal dacLeftOddFIFOData, dacLeftEvenFIFOData, dacRightOddFIFOData, dacRightEvenFIFOData  : std_logic_vector(23 downto 0);
    
    
    
    signal dacLeftOddFIFOEmpty, dacLeftOddFIFOFull, dacRightOddFIFOEmpty, dacRightOddFIFOFull: std_logic;
    signal dacLeftEvenFIFOEmpty, dacLeftEvenFIFOFull, dacRightEvenFIFOEmpty, dacRightEvenFIFOFull: std_logic;
    

    
    signal intpOdd, intpEven            : std_logic := '0';
    
    signal dacLeftLIFOData, dacRightLIFOData  : std_logic_vector(23 downto 0);
    signal dacLeftLIFOEmpty, dacLeftLIFOFull, rxtcLIFOFull : std_logic;
    signal dacRightLIFOEmpty, dacRightLIFOFull, rxtcLIFOEmpty : std_logic;
    
    
    signal leftFifo24BitIn,rightFifo24BitIn : std_logic_vector(23 downto 0);
    signal leftFifo24BitInEth,rightFifo24BitInEth : std_logic_vector(23 downto 0);
    
    
    signal leftOut24BitTmp, rightOut24BitTmp : std_logic_vector(23 downto 0);
--    signal oddFifo24BitInEth, evenFifo24BitInEth : std_logic_vector(23 downto 0);
--    signal leftFifo24BitInArm,rightFifo24BitInArm : std_logic_vector(23 downto 0);

    signal writeOddDACFifo : std_logic;
    signal writeEvenDACFifo : std_logic;
    
     signal writeLeftDACLifo, writeLeftDACLifoDly : std_logic;
    signal writeRightDACLifo, writeRightDACLifoDly : std_logic;
    
    signal writeLeftDACFifoArm : std_logic;
    signal writeRightDACFifoArm : std_logic;
    
    signal writeOddDACFifoEth : std_logic;
    signal writeEvenDACFifoEth : std_logic;
    
    signal rxtc_fifo_read, rxtc_fifo_read_init, rxtc_fifo_read_cyc, first_pkt_ind, first_pkt_wrt, first_pkt_rdr, resetErrCount : std_logic;
    signal rxtc_fifo_write : std_logic;
    
    signal writeSourceSelect : std_logic :='0';  
--    signal sample_48k : std_logic := '0';
    signal writeDACFifoClk, writeDACLifoClk  : std_logic := '0';
    
    
    signal packet_count : std_logic_vector(PACKET_COUNT_W-1 downto 0):= x"0000_01E0";
    signal packet_count_mirror : unsigned(PACKET_COUNT_W-1 downto 0):=  x"0000_01E0";
    signal packet_count_cnt, packet_dumped_cnt : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    signal packet_count_final, packet_dumped_cnt_final : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    
    
    signal buf_count : std_logic_vector(BUF_COUNT_W-1 downto 0):= x"0000_01E0";--0x1E0 is 5ms
    signal buf_count_mirror : unsigned(BUF_COUNT_W-1 downto 0):=  x"0000_01E0";
    
    
--    signal buf_count_err, buf_count_err_corr, buf_count_err_net : unsigned(BUF_COUNT_W-1 downto 0)  := (others => '0');
   -- signal buf_count_err_final : unsigned(BUF_COUNT_W-1 downto 0)  := (others => '0');
   -- signal buf_err_corr : std_logic := '0';

    
    signal enablePacketCount      : std_logic := '0';
    signal enablePacketCount_final: std_logic := '0';
    signal resetPktCount            : std_logic := '0';
    
--    signal data24BitTmp : std_logic_vector(23 downto 0);
    signal newsample_reg, newsample_div2_reg, newsample_change, newsample_rdy, newsample_in_div2 : std_logic := '0';
    signal newsample_125, newsample_125n, newsample_div2_125, newsample_mul2_125 : std_logic := '0';
--     signal newsample_125_2, newsample_125_1, newsample_125_cic, newsample_div2_125_1, newsample_div2_125_2, newsample_div2_125_o : std_logic := '0';
    signal fifo_write_odd, fifo_write_odd_reg, fifo_write_odd_change : std_logic := '0';
    signal fifo_write_even, fifo_write_even_reg, fifo_write_even_change : std_logic := '0';
    signal sample_buf_good, dac_efifo_read, dac_ofifo_read, dac_fifo_read_reg : std_logic := '0';
    
    signal dac_lifo_read, dac_lifo_read_reg, dac_lifo_read_change : std_logic := '0';
    
    
     signal last_left_plc_value  : std_logic_vector(23 downto 0);
     signal last_right_plc_value  : std_logic_vector(23 downto 0);
    
    signal fifo_writes,  fifo_reads, fifo_reads_125,  fifo_reads_125_tmp, fifo_reads_125_tmp1: unsigned(FIFO_ADDR_WIDTH -1 downto 0);
    signal left_odd_fifo_occ,left_even_fifo_occ, right_odd_fifo_occ, right_even_fifo_occ, fifo_occ, fifo_occ_lim, fifo_occ_rep_lim, playout_start_lim: unsigned(FIFO_ADDR_WIDTH -1 downto 0);
    signal lifo_writes,  lifo_reads, lifo_reads_125, left_lifo_occ,right_lifo_occ,lifo_occ, lifo_reads_125_tmp, lifo_reads_125_tmp1, lifo_occ_lim: unsigned(LIFO_ADDR_WIDTH -1 downto 0);
    signal  rxtc_fifo_occ, rel_counter, exit_counter, entry_counter  : unsigned(8 -1 downto 0) := (others => '0');

    signal last_pkt_seq_count : unsigned(PACKET_SEQ_W-1 downto 0):=  x"0000";
    
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
    
    
    
--    signal adcLeftData, adcRightData : std_logic_vector(23 downto 0);
    signal testLeftData, testRightData : std_logic_vector(23 downto 0);
--    signal ethLeftData, ethRightData : std_logic_vector(23 downto 0);
    
    
    constant TEST_PULSE_WIDTH :natural := 3125000;-- 20Hz @ 125MHz ;1200000;--20Hz @ 48MHz base clock
    signal testWave24Bit : std_logic_vector(23 downto 0) := X"00FFFF";
    signal testWaveTimer : unsigned(32 downto 0);
    
    
    signal sampleCounter: unsigned(15 downto 0);
    
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
    
    signal media_channel_dropped : std_logic := '0';
    signal stream_pkt_start : std_logic  := '1';
    --signal hdrstrip_reg, hdrstrip : std_logic  := '0';
    signal tc_sync , tc_sync_reg, tc_sync_125, tc_sync_int, play_out_en, pkt_too_late, media_timer_en, media_timer_reset : std_logic  := '0';
    signal sync_time_code      : unsigned(TC_BIT_LENGTH  -1 downto 0) := X"0000_0000";
    signal media_timer_count, media_timer_limit             : unsigned(TC_BIT_LENGTH  -1 downto 0) := X"0000_0000";
--    signal sr_count, sr_count_final      : unsigned(TC_BIT_LENGTH  -1 downto 0) := X"0002_EE00";
    signal rx_time_code, last_rx_time_code : unsigned(TC_BIT_LENGTH  -1 downto 0);
    signal rx_time_code_fout : unsigned(TC_BIT_LENGTH  -1 downto 0);
    signal rx_time_code_eff, timing_offset : unsigned(TC_BIT_LENGTH  -1 downto 0);
    signal play_out_delay : std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
    signal play_out_delay_reg : unsigned(TC_BIT_LENGTH  -1 downto 0);
    signal play_out_time : unsigned(TC_BIT_LENGTH  -1 downto 0);
    
    signal bad_pkt_count : unsigned(TC_BIT_LENGTH  -1 downto 0);
    
    
     
    
    signal rx_packet_seq_cnt : unsigned(PACKET_SEQ_W-1 downto 0);
    
    signal last_rx_packet_seq_cnt : unsigned(PACKET_SEQ_W-1 downto 0);
    
    signal next_rx_packet_seq_cnt : unsigned(PACKET_SEQ_W-1 downto 0);    
    signal allow_packet, allow_packet_odd : std_logic := '0';
    
    signal buf_corr_window        : unsigned(BUF_COUNT_W-1 downto 0);
    signal enable_buf_corr, tc_sync_en, axis_tlast_pulse, axis_tlast_reg           : std_logic := '0';
    
    signal lock_pkts_limit : unsigned(31 downto 0);
    signal lock_pkts_count : unsigned(31 downto 0) := X"0000_0000";
    signal resetFifos, resetLifos     : std_logic := '0';
    
    signal PktEnd_LIFO_R, PktEnd_LIFO_L, dpk_pkt_end, plc_pkt_end_left, plc_pkt_end_right, fade_dpk_enable_reg, fade_plc_enable_reg        : std_logic := '0';
--    signal PktEnd_LIFO_R_reg, PktEnd_LIFO_L_reg, PktEnd_LIFO_R_pulse, PktEnd_LIFO_L_pulse        : std_logic := '0';
    signal PktEnd_FIFO_LeftEven, PktEnd_FIFO_LeftOdd, PktEnd_FIFO_RightEven, PktEnd_FIFO_RightOdd      : std_logic := '0';
--    signal PktEnd_FIFO_LO_pulse, PktEnd_FIFO_LE_pulse, PktEnd_FIFO_LO_reg, PktEnd_FIFO_LE_reg  : std_logic := '0';
--    signal PktEnd_FIFO_RO_pulse, PktEnd_FIFO_RE_pulse, PktEnd_FIFO_RO_reg, PktEnd_FIFO_RE_reg : std_logic := '0';
    

    signal oddEvenReadSelect, oddEvenWriteSelect, switch_to_even, switch_to_odd  : std_logic := '0';
    
     signal fade_dpkt_direction_reg, pkt_end_sim : std_logic := '0'; -- UP
     signal fade_plc_direction_reg, last_oddEvenWriteSelect  : std_logic := '1'; -- Down
     signal fade_dpk_clear_reg: std_logic := '0'; -- UP
     signal fade_plc_clear_reg  : std_logic := '0'; -- Down
     
     signal fade_dpk_max_reg, fade_plc_max_reg         : std_logic := '0'; 
     signal fade_dpk_min_reg, fade_plc_min_reg        : std_logic := '0'; 
     
--    signal new_pkt_ready_in_pulse, new_pkt_ready_in_reg     : std_logic;
    
    signal sync_time_code_roll_over, sync_time_code_roll_over_rst  : std_logic := '0'; 
    
    signal replace_inprogress_in_neg, replace_inprogress_in_pos, replace_inprogress_in_reg, replace_inprogress_sig, replace_lock : STD_LOGIC := '0';
    
    signal replace_inprogress_sig_neg, replace_inprogress_sig_pos, replace_inprogress_sig_reg : STD_LOGIC := '0';
    
    signal pause_stream, read_PLC_Clk, read_Odd_FIFOClk, read_Even_FIFOClk,   startRead, dump_pkt, clearFifos  : std_logic := '0'; 
--    signal replace_timeout        : std_logic := '0'; 
    signal enableReplacePkt          : std_logic;
    signal after_replace_inprogress_pulse  : std_logic := '0'; 
    
--    type state_type is (st_idle, st_Lock, st_HdrBytes, st_ChkTc, st_DumpPkt, st_Lbyte1, st_Lbyte2, st_Lbyte3, st_Rbyte1, st_Rbyte2, st_Rbyte3);
    type state_type is (st_idle, st_Lock, st_HdrBytes, st_ChkTc, st_DumpPkt, st_Lbyte1, st_Lbyte2, st_Rbyte1, st_Rbyte2, st_WriteFifo);
    signal state : state_type := st_idle;
    
    signal replace_pkt_raw, replace_pkt_trig, replace_pkt_rel, replace_pkt_entry, replace_pkt_exit : std_logic := '0';
    
    
    type plc_state_type is (idle, fade_entry, replace, release, fade_exit);
    signal plc_state : plc_state_type := idle;
    
    signal hdrbytecount : unsigned(3 downto 0) := (others => '0');
    
    signal just_b4_replacing, replace_pkt_set, plc_read_ptr_set, plc_move_to_replace : std_logic := '0';
   
     signal  next_play_out_time : unsigned(TC_BIT_LENGTH  -1 downto 0);
     signal o_slot_skip_count : unsigned(TC_BIT_LENGTH  -1 downto 0);
     signal e_slot_skip_count : unsigned(TC_BIT_LENGTH  -1 downto 0);
     signal late_allowance : unsigned(TC_BIT_LENGTH  -1 downto 0); 
    
    signal replace_events : unsigned(TC_BIT_LENGTH  -1 downto 0); 

    constant SIM_PKT_SIZE : integer :=  2**(SIM_PKT_LEN_WIDTH);
---------------------------------------------------------------------------------------------------------------------------------------



begin
--play_out_delay_reg <= unsigned(play_out_delay);
--playout_start_reg <= play_out_delay_reg(FIFO_ADDR_WIDTH -1 downto 0);
--playout_start_lim <= '0' & playout_start_reg( playout_start_reg'left downto 1 );


play_out_delay_reg <= unsigned(play_out_delay);

--playout_start_reg <= shift_left(unsigned(fifo_occ_lim), 2); 
--playout_start_reg <= to_unsigned(96, playout_start_reg'length);
playout_start_lim <= to_unsigned(96, playout_start_lim'length);



    -- Instantiation of Axi Bus Interface S00_AXI
    eth_to_audio_interface_v2_0_S00_AXI_inst : eth_to_audio_interface_v2_0_S00_AXI
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
       dacLeftFIFOEmpty_in => dacLeftOddFIFOEmpty,
       dacRightFIFOEmpty_in => dacRightEvenFIFOEmpty,
       dacRightFIFOFull_in => dacRightEvenFIFOFull,
       dacLeftFIFOFull_in => dacLeftOddFIFOFull,
       play_out_en_in => play_out_en,
       fifo_writes_in =>  fifo_writes ,
       fifo_reads_in => fifo_reads,
       odd_fifo_occ_in => left_odd_fifo_occ,
       even_fifo_occ_in => left_even_fifo_occ,
       rxtc_fifo_occ_in => rxtc_fifo_occ,
       --buf_count_err_final_in => buf_count_err_final,
       
       buf_corr_window_out => buf_corr_window,
       packet_count_final_in => packet_count_final,
       packet_dumped_cnt_final_in => packet_dumped_cnt_final,
       sync_time_code_in      => sync_time_code ,
       rx_time_code_in => std_logic_vector(rx_time_code),
       rx_time_code_eff_in => std_logic_vector(rx_time_code_eff),
       rx_time_code_fout_in => std_logic_vector(rx_time_code_fout),
       play_out_time_in => play_out_time,
       enableReplacePkt_out => enableReplacePkt,
       
       UP_STEP_PULSES_OUT	=> UP_STEP_PULSES_OUT,
		DOWN_STEP_PULSES_OUT	=> DOWN_STEP_PULSES_OUT,
		COEF_MIN_OUT     => COEF_MIN_OUT, -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
		COEF_MAX_OUT     => COEF_MAX_OUT, -- 32 bit COEF from a register. Last 8 bits are fractional for volume control 0<-->1
       
       
       
       lock_pkts_limit_out => lock_pkts_limit,
       
       media_timer_en_out => media_timer_en, 
       media_timer_limit_out => media_timer_limit,
       media_channel_dropped_in  => media_channel_dropped, 
       
       e_slot_skip_count_out => e_slot_skip_count,
       o_slot_skip_count_out => o_slot_skip_count,
       late_allowance_out => late_allowance,
       
       replace_events_in => replace_events,
       bad_pkt_count_in => bad_pkt_count,
       
      payload_length_out   => payload_length,       
      fifo_occ_lim_out  => fifo_occ_lim,   
--      fifo_occ_rep_lim_out => fifo_occ_rep_lim,    
      enablePacketCount_out      => enablePacketCount,
      enable_buf_corr_out => enable_buf_corr,
      resetPktCount_out            => resetPktCount,  
      resetLeftDACFifo_out => resetOddDACFifo,     
      resetRightDACFifo_out => resetEvenDACFifo,     
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
-------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Add user logic here
	
	-- Add user logic here
	
	
	packet_count_final <= packet_count_cnt;
    packet_dumped_cnt_final <= packet_dumped_cnt;
    enablePacketCount_final <= enablePacketCount;
--    oddFifo24BitIn <= data24BitTmp;
--    evenFifo24BitIn <= data24BitTmp;
    rx_time_code_out <= std_logic_vector(rx_time_code);
    rx_packet_seq_cnt_out <= std_logic_vector(rx_packet_seq_cnt);
    
--    oddEvenWriteSelect <= '1' when rx_packet_seq_cnt(0) = '1' else '0';
      

 rx_time_code <= unsigned(rx_time_code_1 & rx_time_code_2 & rx_time_code_3 & rx_time_code_4); 

-- M AXIS Write Process old
    m_axis_reader: process(CLK_125,s_ch1_audio_payload_axis_aresetn, resetOddDACFifo, resetEvenDACFifo) is
        
        variable bytecount : integer range 0 to 2000 := 0;
        --variable hdrbytecount : integer range 0 to 32 := 0;
        
        
    begin
    
        if (s_ch1_audio_payload_axis_aresetn = '0' or (resetOddDACFifo ='1' or resetEvenDACFifo  ='1')) then
                -- Reset
--                state <= st_idle;
                state <= st_Lock; 
                lock_pkts_count <= (others => '0');
                bytecount := 0;
--                hdrbytecount <= (others => '0');
                hdrbytecount <= (others => '0');
                hdr_ready <= '0';
--                oddEvenWriteSelect <= '0';
--                last_oddEvenWriteSelect <= '1';
--                oddEvenReadSelect <= '0'; 
--                switch_to_even <= '0';
                startRead <= '0';
                stream_pkt_start <= '1';
                writeEvenDACFifoEth <= '0';
                writeOddDACFifoEth <= '0'; 
                tready <= '0';
                state_val <= "00000";
                first_pkt_rdr <= '0';
                first_pkt_wrt <= '1';
                rxtc_fifo_write <= '0';
                resetErrCount <= '0';
                media_timer_reset <= '0';
                oddEvenWriteSelect <= '0';
                bad_pkt_count <= (others => '0');
                
--                rx_time_code_out <= (others => '0');
--                rx_packet_seq_cnt_out  <= (others => '0');
                fifo_writes <= (others => '0');
--                buf_count_err_corr <= (others => '0');
--                rx_time_code <= (others => '0');
                
                rx_time_code_1  <= (others => '0');
                rx_time_code_2  <= (others => '0');
                rx_time_code_3  <= (others => '0');
                rx_time_code_4 <= (others => '0');
                
                last_rx_time_code <= (others => '0');
                
                
                rx_packet_seq_cnt_1  <= (others => '0');
                rx_packet_seq_cnt_2 <= (others => '0');
                
            elsif rising_edge(CLK_125) then
            
            
                
                
                --tready <= '0';
                --hdr_ready <= '0';
                case state is
                    when st_idle =>      
                            dpk_pkt_end <= '0'; 
                            dump_pkt <= '0';   
                            clearFifos <= '0';   
                            bytecount := 0;              
                            tready <= '0';
                            hdr_ready <= '0';
                            hdrbytecount <= (others => '0');
                            state <= st_idle;
                            writeEvenDACFifoEth <= '0';
                            writeOddDACFifoEth <= '0';
                            media_timer_reset <= '0';
                            --last_rx_time_code <= rx_time_code;should be done conditionally in chk
                           if(stream_pkt_start = '1') then -- we do not know what the future holds
                                hdr_ready <= '0'; 
                                bytecount := 0; 
                                if hdr_strip = '1' then     
                                    state <= st_HdrBytes;
                                    state_val <= "00001"; 
                                    tready <= '1';                                   
                                elsif((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then -- we do not know what the future holds
                                        state <= st_Lbyte1;
                                        state_val <= "00100";
                                        tready <= '1';                                   
                                end if;
                                stream_pkt_start <= '0';
                                
                                
                                hdrbytecount <= (others => '0');
                            elsif(stream_pkt_start = '0') then
                                hdr_ready <= '0';       
                                if((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then -- we do not know what the future holds
                                    state <= st_Lbyte1;
                                    state_val <= "00100";
                                    tready <= '1';
                                 end if;
                            end if;
                            lock_pkts_count <= (others => '0');                     
                            --bytecount := 0;  
                    --HDR is LSB first    
                    when st_HdrBytes =>
                        dpk_pkt_end <= '0';
                        hdr_ready <= hdr_ready;
--                        rxtc_fifo_write <= '0';
                        tready <= '1';
                        media_timer_reset <= '0';
                        writeEvenDACFifoEth <= '0';
                        writeOddDACFifoEth <= '0';
                        stream_pkt_start <= '0';
                        if (hdrbytecount < hdr_length-1) then
--                            data24BitTmp(23 downto 16) <= tdata;                                 
--                            tready <= '1';
                            if tvalid = '1' then 
                                
                                if (hdrbytecount = 0) then
                                    rx_packet_seq_cnt_2 <= tdata;                                
                                elsif(hdrbytecount = 1) then
                                    rx_packet_seq_cnt_1 <= tdata; 
                                                             
                                elsif(hdrbytecount = 2) then
                                    rx_time_code_4 <= tdata;--lsb first       
                                                     
                                elsif(hdrbytecount = 3) then
                                    rx_time_code_3 <= tdata; 
                                                                   
                                elsif(hdrbytecount = 4) then
                                    rx_time_code_2 <= tdata;  
                                                                 
                                elsif(hdrbytecount = 5) then
                                    rx_time_code_1 <= tdata;  
                                    last_pkt_seq_count <= unsigned(rx_packet_seq_cnt);
                                elsif(hdrbytecount = 6) then
                                    rx_packet_seq_cnt <= unsigned(rx_packet_seq_cnt_1 & rx_packet_seq_cnt_2);
                                    
                                    
    --                                if(tc_sync_en = '1') then
--                                    rx_time_code <= unsigned(rx_time_code_1 & rx_time_code_2 & rx_time_code_3 & rx_time_code_4); 
                               
                                end if;
                            
                                bytecount := bytecount + 1;
                                hdrbytecount <= hdrbytecount + 1;
                                state <= st_HdrBytes;  
                            end if;
                        --elsif (hdrbytecount >= hdr_length-1) then
                        elsif tvalid = '1' and (hdrbytecount >= hdr_length-1) then
--                            if first_pkt_wrt <= '1' then
--                                rxtc_fifo_write <= '1';  
--                            end if;
--                            data24BitTmp(23 downto 16) <= tdata;
--                            if ((play_out_en = '1') or (tc_sync_en = '0')) then
                                
                                
                                
                                tready <= '0';
--                                    last_oddEvenWriteSelect <= oddEvenWriteSelect;
--                                    oddEvenWriteSelect <= rx_packet_seq_cnt(0);

                                    oddEvenWriteSelect <= rx_packet_seq_cnt(0);
                                    state <= st_ChkTc;
                                    state_val <= "00010";
--                                    hdrbytecount <= (others => '0');
                                    bytecount := bytecount + 1; 
                                    --block_on_next <= '1'; 
                                
--                            else
--                                tready <= '0';
--                                state <= st_HdrBytes;
--                                bytecount := bytecount;
--                                hdrbytecount := hdrbytecount;
--                            end if;
                             
                            
                            
                            -- TC LSB first
--                            rx_time_code <= rx_time_code_1 & rx_time_code_2 & rx_time_code_3 & rx_time_code_4;
--                            rx_packet_seq_cnt <= rx_packet_seq_cnt_1 & rx_packet_seq_cnt_2;
                        end if;
                        
                        writeEvenDACFifoEth <= '0';
                        writeEvenDACFifoEth <= '0'; 
                        
                        
                        
                        if s_ch1_audio_payload_axis_tlast = '1' then
                                bytecount := 0; 
                               hdr_ready <= '1'; 
                               startRead <= '0';   
                               stream_pkt_start <= '1';
                               first_pkt_wrt <= '0';
                               dpk_pkt_end <= '1'; 
                               state <= st_idle; 
                               state_val <= "00000";   
                               tready <= '0';   
                               bad_pkt_count <= bad_pkt_count + 1;
                            end if;
                        
                   
                when st_ChkTc =>
                       dpk_pkt_end <= '0';
                       writeOddDACFifoEth <= '0';
                       writeEvenDACFifoEth <= '0';    
                       media_timer_reset <= '0';
                       tready <= '0';
                       stream_pkt_start <= '0';
                       hdrbytecount <= (others => '0');
                       bytecount := bytecount;
                       
--                       if (((rx_time_code < last_rx_time_code) and ((last_rx_time_code - rx_time_code) < 100000000)) ) then
--                                    state <= st_DumpPkt; -- drop the packet
--                                    state_val <= "11110";
--                                    tready <= '1'; 
--                       els
                       if(pkt_too_late = '1') then 
                            state <= st_DumpPkt; -- drop the packet
                            state_val <= "11110";
                            tready <= '1'; 
                       elsif (play_out_en = '1') then
                            if((dacLeftOddFIFOFull='1' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '1' and oddEvenWriteSelect='0')) then
                                state <= st_DumpPkt; -- drop the packet
                                state_val <= "11110";
                                tready <= '1'; 
                                
                            else    
                            
                            
                                state <= st_Lbyte1;
                                state_val <= "01000";                                
                                tready <= '1';
                                last_rx_time_code <= rx_time_code;                                
    --                        elsif ((unsigned(buf_count_err) >= unsigned(payload_length)-1)) then
    --                            state <= st_dumpPkt;
    --                              buf_count_err_corr <= buf_count_err_corr + payload_length - 1;
                                                     
                            end if;
                            
--                            if((last_oddEvenWriteSelect = oddEvenWriteSelect) and (oddEvenWriteSelect = '0')) then  -- odd pkt is missing
--                                switch_to_even <= '1';
--                                oddEvenReadSelect <= '0';
--                            elsif((last_oddEvenWriteSelect = oddEvenWriteSelect) and (oddEvenWriteSelect = '1')) then  -- even pkt is missing
--                                switch_to_even <= '0';
--                                oddEvenReadSelect <= '1';
--                            else
--                                switch_to_even <= '0';
--                                oddEvenReadSelect <= '0';
--                            end if;
                        else -- block until we are good
                            state <= st_ChkTc;
                            state_val <= "00010";                                
                            tready <= '0';       
                            
                        end if;
                        
                        if s_ch1_audio_payload_axis_tlast = '1' then
                                bytecount := 0; 
                               hdr_ready <= '1';    
                               stream_pkt_start <= '1';
                               startRead <= '0';
                               first_pkt_wrt <= '0';
                               dpk_pkt_end <= '1'; 
                               state <= st_idle; 
                               state_val <= "00000";   
                               tready <= '0';   
                               bad_pkt_count <= bad_pkt_count + 1;
                            end if;

--                   when st_ChkTc =>
--                       dpk_pkt_end <= '0';
--                       writeOddDACFifoEth <= '0';
--                       writeEvenDACFifoEth <= '0'; 
----                       replace_oe_pkt <= '0';    
--                       last_pkt_seq_count <= unsigned(rx_packet_seq_cnt);
--                       tready <= '0';
--                       stream_pkt_start <= '0';
--                       hdrbytecount <= (others => '0');
--                       bytecount := bytecount;
--                       if (((rx_time_code < last_rx_time_code) and ((last_rx_time_code - rx_time_code) < 100000000)) ) then
--                                    state <= st_DumpPkt; -- drop the packet
--                                    state_val <= "11110";
--                                    tready <= '1'; 
--                       elsif((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then
--                           if (play_out_en = '1') then 
--                                state <= st_Lbyte1;
--                                state_val <= "01000";                                
--                                tready <= '1';
--                                last_rx_time_code <= rx_time_code;                                
--    --                        elsif ((unsigned(buf_count_err) >= unsigned(payload_length)-1)) then
--    --                            state <= st_dumpPkt;
--    --                              buf_count_err_corr <= buf_count_err_corr + payload_length - 1;
--                            else    -- block until we are good
--                                state <= st_ChkTc;
--                                state_val <= "00010";                                
--                                tready <= '0';                            
--                            end if;
                            
----                            if((last_oddEvenSelect = oddEvenWriteSelect) and (oddEvenWriteSelect = '0')) then  -- odd pkt is missing
----                                switch_to_even <= '1';
----                                switch_to_odd <= '0';
----                            elsif((last_oddEvenSelect = oddEvenSelect) and (oddEvenSelect = '1')) then  -- even pkt is missing
----                                switch_to_even <= '0';
----                                switch_to_odd <= '1';
----                            else
----                                switch_to_even <= '0';
----                                switch_to_odd <= '0';
----                            end if;
                            
--                        end if;
                        
--                        if s_ch1_audio_payload_axis_tlast = '1' then
--                                bytecount := 0; 
--                               hdr_ready <= '1';    
--                               stream_pkt_start <= '1';
--                               startRead <= '0';
--                               first_pkt_wrt <= '0';
--                               dpk_pkt_end <= '1'; 
--                               state <= st_idle; 
--                               state_val <= "00000";   
--                               tready <= '0';   
                               
--                            end if;
                        
                    when st_DumpPkt =>
                            dpk_pkt_end <= '0';
                            tready <= '1';
                            media_timer_reset <= '0';
                            resetErrCount <= '0';
                            state <= st_DumpPkt;
                            writeEvenDACFifoEth <= '0';
                            writeOddDACFifoEth <= '0';
                            stream_pkt_start <= '0';
                            if s_ch1_audio_payload_axis_tvalid = '1' and s_ch1_audio_payload_axis_tlast = '1' then
                                state <= st_idle;  
                                state_val <= "00000";
                               bytecount := 0; 
                               hdr_ready <= '1';
                               tready <= '0';
                               dpk_pkt_end <= '1';
                               media_timer_reset <= '1'; -- dont block stream if you are dropping packets
                                --first_pkt_rdr <= '1';
                               stream_pkt_start <= '1';  
                               packet_dumped_cnt <= packet_dumped_cnt + 1;
                            else
                              state <= st_DumpPkt; 
                            end if;
                    --MSB first Odd/Even   
                 
--                  when st_GetNext =>
                  
--                  if((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then
--                    state <= st_Lbyte1;
--                    state_val <= "01000";
--                    hdr_ready <= '1';
--                    tready <= '1';
--                  else
--                    state <= st_GetNext;
--                    hdr_ready <= '0';
--                    tready <= '0';
--                  end if;
                  
--                  writeEvenDACFifoEth <= '0';
--                  writeOddDACFifoEth <= '0';   
                  when st_Lbyte1 =>
                        media_timer_reset <= '0';
                        dpk_pkt_end <= '0';
                        tready <= '1';
                        rxtc_fifo_write <= '0';
                        hdr_ready <= hdr_ready; 
                        writeEvenDACFifoEth <= '0';
                        writeOddDACFifoEth <= '0';
                        stream_pkt_start <= '0';
                        if tvalid = '1' then
                            leftOut24BitTmp(23 downto 16) <= tdata;
                            state <= st_Lbyte2; 
                            state_val <= "01001";
                            bytecount := bytecount + 1;
                            
                            
                            
                        end if;
                        
                        if s_ch1_audio_payload_axis_tlast = '1' then
                               bytecount := 0; 
                               hdr_ready <= '1';    
                               stream_pkt_start <= '1';
                               startRead <= '0';
                               first_pkt_wrt <= '0';
                               dpk_pkt_end <= '1'; 
                               state <= st_idle; 
                               state_val <= "00000";  
                               tready <= '0';  
                               bad_pkt_count <= bad_pkt_count + 1;                                                 
                            end if;
                        
                        
--                    when st_Lbyte2 =>
--                        dpk_pkt_end <= '0';
--                        tready <= '1';
--                        hdr_ready <= hdr_ready;
--                        writeEvenDACFifoEth <= '0';
--                        writeOddDACFifoEth <= '0';
--                        stream_pkt_start <= '0'; 
--                        if tvalid = '1' then
--                            leftOut24BitTmp(15 downto 8) <= tdata;
--                            state <= st_Lbyte3; 
--                            state_val <= "01010";
--                            bytecount := bytecount + 1;
                            
--                        end if;
                        
--                        if s_ch1_audio_payload_axis_tlast = '1' then
--                               bytecount := 0; 
--                               hdr_ready <= '1';    
--                               stream_pkt_start <= '1';
--                               startRead <= '0';
--                               first_pkt_wrt <= '0';
--                               dpk_pkt_end <= '1'; 
--                               state <= st_idle; 
--                               state_val <= "00000";  
--                               tready <= '0';                                                   
--                            end if;
                        
                        
                    when st_Lbyte2 =>
                        dpk_pkt_end <= '0';
                        media_timer_reset <= '0';
                        tready <= '1';
                        hdr_ready <= hdr_ready; 
                        writeEvenDACFifoEth <= '0';
                        writeOddDACFifoEth <= '0';
                        stream_pkt_start <= '0';
                        if tvalid = '1' then
                            leftOut24BitTmp(15 downto 8) <= tdata;
                            state <= st_Rbyte1; 
                            state_val <= "01011";
                            bytecount := bytecount + 1; 
                                        
                        end if;
                        
                        if s_ch1_audio_payload_axis_tlast = '1' then
                               bytecount := 0; 
                               hdr_ready <= '1';    
                               stream_pkt_start <= '1';
                               startRead <= '0';
                               first_pkt_wrt <= '0';
                               dpk_pkt_end <= '1'; 
                               state <= st_idle; 
                               state_val <= "00000";  
                               tready <= '0';  
                               bad_pkt_count <= bad_pkt_count + 1;                                                 
                            end if;
                        
                        
                   when st_Rbyte1 =>
                        dpk_pkt_end <= '0';
                        media_timer_reset <= '0';
                        tready <= '1';
                        hdr_ready <= hdr_ready;  
                        writeEvenDACFifoEth <= '0';
                        writeOddDACFifoEth <= '0';
                        stream_pkt_start <= '0';
                        if tvalid = '1' then
                            rightOut24BitTmp(23 downto 16) <= tdata;
                            state <= st_Rbyte2; 
                            state_val <= "01100";
                            bytecount := bytecount + 1; 
                     
                                                       
                        end if;
                        
                        
                        if s_ch1_audio_payload_axis_tlast = '1' then
                               bytecount := 0; 
                               hdr_ready <= '1';    
                               stream_pkt_start <= '1';
                               startRead <= '0';
                               first_pkt_wrt <= '0';
                               dpk_pkt_end <= '1'; 
                               state <= st_idle; 
                               state_val <= "00000";  
                               tready <= '0';  
                               bad_pkt_count <= bad_pkt_count + 1;                                                 
                            end if;
                        
                        
--                    when st_Rbyte2 =>
--                        dpk_pkt_end <= '0';
--                        tready <= '1';
--                        hdr_ready <= hdr_ready;  
--                        writeEvenDACFifoEth <= '0';
--                        writeOddDACFifoEth <= '0';
--                        stream_pkt_start <= '0';
--                        if tvalid = '1' then
--                            rightOut24BitTmp(15 downto 8) <= tdata;
--                            state <= st_Rbyte3; 
--                            state_val <= "01101";
--                            bytecount := bytecount + 1;
                            
                            
--                        end if;
                        
                        
--                        if s_ch1_audio_payload_axis_tlast = '1' then
--                               bytecount := 0; 
--                               hdr_ready <= '1';    
--                               stream_pkt_start <= '1';
--                               startRead <= '0';
--                               first_pkt_wrt <= '0';
--                               dpk_pkt_end <= '1'; 
--                               state <= st_idle; 
--                               state_val <= "00000";  
--                               tready <= '0';                                                   
--                            end if;
                        
                   when st_Rbyte2 =>
                        dpk_pkt_end <= '0';
                        media_timer_reset <= '0';
                        tready <= '1';
                        hdr_ready <= hdr_ready;
                        writeEvenDACFifoEth <= '0';
                        writeOddDACFifoEth <= '0';  
                        stream_pkt_start <= '0';
                        if tvalid = '1' then
                            rightOut24BitTmp(15 downto 8) <= tdata;
                            bytecount := bytecount + 1; 
--                            if ((buf_err_corr = '1') and (tc_sync_en = '1')) then  --- drop sample for soft correction                     
--                                writeRightDACFifoEth <= '0';
--                                writeLeftDACFifoEth <= '0';
--                                fifo_writes <= fifo_writes;
--                                buf_count_err_corr <= buf_count_err_corr + 1;
--                            else
                                if(oddEvenWriteSelect = '0') then
                                    writeEvenDACFifoEth <= '1';
                                    writeOddDACFifoEth <= '0';
                                else
                                    writeOddDACFifoEth <= '1';
                                     writeEvenDACFifoEth <= '0';
                                end if;
--                                buf_count_err_corr <= buf_count_err_corr;
                                fifo_writes <= fifo_writes + 1;
                            
--                            end if;

                                state <= st_idle; 
                                state_val <= "00000";
                                tready <= '0';
                                
                          if s_ch1_audio_payload_axis_tlast = '1' then
                               bytecount := 0; 
                               hdr_ready <= '1';
                               media_timer_reset <= '1';
                               stream_pkt_start <= '1';
--                               first_pkt_rdr <= '1';
--                               startRead <= '1';
                               first_pkt_wrt <= '0';
                               dpk_pkt_end <= '1';
                               --oddEvenWriteSelect <= oddEvenWriteSelect xor '1';  --toggle odd/even flag bad idea use sequence numbers
    --                           if enablePacketCount_final = '1' then
                                    packet_count_cnt <= packet_count_cnt + 1;
    --                                if (packet_count_cnt_final >= (packet_count_mirror-1) ) then        
    --                                    packet_count_cnt    <= (others => '0');
    --                                end if;  
    --                            end if;   
                            end if;
                            
                        end if;
                        
                        
--                        if packet_count_cnt >= x"0000_0002" then
                        if((left_odd_fifo_occ > (fifo_occ_lim + ((EXIT_FADE_LENGTH + REL_PIPE_LENGTH)/2))) or (left_even_fifo_occ > (fifo_occ_lim+((EXIT_FADE_LENGTH+REL_PIPE_LENGTH)/2)))) then
                            first_pkt_rdr <= '1';
                            startRead <= '1';
                        else
                        
                            first_pkt_rdr <= first_pkt_rdr;
                            startRead <= startRead;
                        
                        end if;
                        
                        
                        
                        
                   
                   when st_Lock =>   
                        media_timer_reset <= '0';
                        if tlast = '1' and tvalid = '1' then   
                           --if axis_tlast_pulse = '1' then                         
                            lock_pkts_count <= lock_pkts_count + 1;  
                            media_timer_reset <= '1';                         
                        else                        
                            lock_pkts_count <= lock_pkts_count;
                        end if;
                        
                        if lock_pkts_count >= lock_pkts_limit then
                            state <= st_idle; 
                            state_val <= "00000";
                            lock_pkts_count <= (others => '0');
                            tready <= '0';
                        else                        
                             state_val <= "11111";
                            state <= st_Lock; 
                            tready <= '1';
                            rx_time_code_1  <= (others => '0');
                            rx_time_code_2  <= (others => '0');
                            rx_time_code_3  <= (others => '0');
                            rx_time_code_4 <= (others => '0');
--                            rx_time_code <= (others => '0');
                        end if;     
                        
                       
                   when others =>
                        writeEvenDACFifoEth <= '0';
                        writeOddDACFifoEth <= '0';
                        state <= st_Lock;
                        lock_pkts_count <= (others => '0');
                        hdr_ready <= '0';
                        media_timer_reset <= '0';
                        dpk_pkt_end <= '0';
                        tready <= '0';  
                        rxtc_fifo_write <= '0';  
                        startRead <= '0';
                        stream_pkt_start <= '1';
--                        oddEvenWriteSelect <= '0';
--                        last_oddEvenWriteSelect <= '1';
--                        oddEvenReadSelect <= '0'; 
--                        switch_to_even <= '0';
                end case;
                
                
                
                
                
                if resetPktCount = '1' then
                    packet_count_cnt <= (others => '0');
                end if;
                               
                if (resetOddDACFifo ='1' or resetEvenDACFifo  ='1') then
                    state <= st_Lock;  
                    lock_pkts_count <= (others => '0');
                    bytecount := 0;
                    hdrbytecount <= (others => '0');
                    startRead <= '0';
--                    oddEvenWriteSelect <= '0';
--                    last_oddEvenWriteSelect <= '1';
--                    oddEvenReadSelect <= '0'; 
--                    switch_to_even <= '0';
                    media_timer_reset <= '0';
                    --lockRead <= '1';
                    hdr_ready <= '0';
                    dpk_pkt_end <= '0';
                    first_pkt_wrt <= '1';
                    stream_pkt_start <= '1';
                    writeEvenDACFifoEth <= '0';
                    writeOddDACFifoEth <= '0';
                    rxtc_fifo_write <= '0';  
                    first_pkt_rdr <= '0';
                    tready <= '0';
--                    oddEvenWriteSelect <= '0';
                    resetErrCount <= '0';
                    rx_time_code_1  <= (others => '0');
                    rx_time_code_2  <= (others => '0');
                    rx_time_code_3  <= (others => '0');
                    rx_time_code_4 <= (others => '0');
--                    rx_time_code <= (others => '0');
                    
                    last_rx_time_code <= (others => '0');
--                    buf_count_err_corr <= (others => '0');
                    fifo_writes <= (others => '0');
--                    rx_time_code_out <= (others => '0');
                    
--                    rx_packet_seq_cnt_out  <= (others => '0');
--                    rx_packet_seq_cnt_1  <= (others => '0');
--                    rx_packet_seq_cnt_2 <= (others => '0');
--                    buf_count_cnt <= (others => '0');
                end if;
                
                
--                 if (tc_sync_en = '0') then
--                    rx_time_code_1  <= (others => '0');
--                    rx_time_code_2  <= (others => '0');
--                    rx_time_code_3  <= (others => '0');
--                    rx_time_code_4 <= (others => '0');
----                    rx_time_code <= (others => '0');
--                    last_rx_time_code <= (others => '0');
----                    buf_count_err_corr <= (others => '0');
                        
--                end if;
                
     
        
        
       
    end if; -- reset
            
end process;






newsample_div2: process(newsample_in)
begin
  if(rising_edge(newsample_in)) then
    newsample_in_div2   <= not newsample_in_div2;
  
  end if;
end process newsample_div2;


-- This syncronises the newsample_in signal to the axis 125MHz clock
newsample_div2_delay: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
begin
    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1'  then
        newsample_div2_reg <= '0';        
    elsif rising_edge (CLK_125) then
        newsample_div2_reg <= newsample_in_div2;
    end if;
end process;

newsample_div2_125 <= (newsample_in_div2 xor newsample_div2_reg) when (newsample_in_div2 = '1') else '0';

-- This syncronises the newsample_in signal to the axis 125MHz clock
newsample_delay: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
begin
    if s_ch1_audio_payload_axis_aresetn = '0'   or resetFifos = '1' then
        newsample_reg <= '0';        
    elsif rising_edge (CLK_125) then
        newsample_reg <= newsample_in;
    end if;
end process;

newsample_125 <= (newsample_in xor newsample_reg) when (newsample_in = '1') else '0';
newsample_125n <= (newsample_in xor newsample_reg) when (newsample_in = '0') else '0';
newsample_mul2_125 <= newsample_125 or newsample_125n;
--newsample_change <= newsample_in; 


--clk_bufg_inst :  BUFG
--port map (
--    I => (newsample_in),
----    I => (tc_sync_in),
--    O => (tc_sync_int)
    
--);
tc_sync_int <= newsample_in;


tc_sync_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
begin
    if s_ch1_audio_payload_axis_aresetn = '0'  then
        tc_sync_reg <= '0';        
    elsif rising_edge (CLK_125) then
        tc_sync_reg <= tc_sync_int;
    end if;
end process;

tc_sync_125 <= (tc_sync_int xor tc_sync_reg) when (tc_sync_int='1') else '0';


--tlast_pulse_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1' then
--        axis_tlast_reg <= '0';        
--    elsif rising_edge (CLK_125) then
--        axis_tlast_reg <=  s_ch1_audio_payload_axis_tlast;
--    end if;
--end process;

--axis_tlast_pulse <=  (axis_tlast_reg xor s_ch1_audio_payload_axis_tlast)  when  s_ch1_audio_payload_axis_tlast = '1' else '0';

sync_time_code <= unsigned(sync_time_code_in);
--sync_time_code_out <= sync_time_code;
--rx_time_code_eff <= rx_time_code when (first_pkt_wrt = '1') else rx_time_code_fout;
--rx_time_code_eff <= rx_time_code_fout;
rx_time_code_eff <= rx_time_code;



media_timer_count_process: process(CLK_125, newsample_125, s_ch1_audio_payload_axis_aresetn, resetFifos, media_timer_reset)
begin
    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1' or media_timer_reset = '1'then
        --sync_time_code <= (others=>'0');   bad idea   
        media_timer_count <= (others=>'0'); 
--        media_channel_dropped <= '0';
    elsif rising_edge (CLK_125) then
--        if ((tc_sync_125 = '1') and (media_timer_en = '1') and (media_timer_reset = '0') and (media_channel_dropped = '0') and (newsample_125 = '1')) then
--        if ((tc_sync_125 = '1') and (media_timer_reset = '0') and (media_channel_dropped = '0') and (newsample_125 = '1')) then
--            media_timer_count <= media_timer_count + 1;   
--        elsif(media_timer_reset = '1') then
--            media_timer_count <= (others=>'0'); 
--        else 
--            media_timer_count <= media_timer_count;   
--        end if;  
        
        
        if ((tc_sync_125 = '1') and (media_channel_dropped = '0') and (media_timer_en = '1') and (newsample_125 = '1')) then
            media_timer_count <= media_timer_count + 1;   
        else 
            media_timer_count <= media_timer_count;   
        end if;  
        
--        if((media_timer_count >= media_timer_limit) and (media_timer_en = '1') and (media_timer_reset = '0')) then
--            media_channel_dropped <= '1';
--        else
--            media_channel_dropped <= '0';
--        end if;  
        
        
--        rx_time_code_eff <= rx_time_code; 
--        sync_time_code <= unsigned(sync_time_code_in);   
    
    end if;
end process;

media_channel_dropped <= '1' when ((media_timer_count >= media_timer_limit) and (media_timer_en = '1') and (media_timer_reset = '0')) else '0';
--media_channel_dropped <= '1' when ((media_timer_count >= media_timer_limit) and (media_timer_reset = '0')) else '0';

--sr_count_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1' then
----        sr_count <= (others=>'0');    
--        just_b4_replacing <= '0';
--    elsif rising_edge (CLK_125) then        
            
----            if((writeEvenDACFifoEth = '1') or (writeOddDACFifoEth = '1')) then
----                 sr_count <= (others=>'0');
----            elsif(replace_inprogress_in = '1' and newsample_125 = '1' and replace_timeout = '0') then
----                sr_count <= sr_count + 1;
----            else 
----                sr_count <= sr_count;
----            end if;
            
----            if(oddEvenWriteSelect= '1') then
----                next_play_out_time <= (unsigned(payload_length) + play_out_time - e_slot_skip_count);
----            else 
----                next_play_out_time <= (play_out_time + o_slot_skip_count);
----            end if;
            
            
----            if((left_odd_fifo_occ < (fifo_occ_lim+4)) and (left_even_fifo_occ < (fifo_occ_lim+4)) and (first_pkt_rdr = '1') and (startRead = '1') and (replace_pkt_raw = '0')) then
            
----            if((left_odd_fifo_occ < (fifo_occ_lim+4)) and (left_even_fifo_occ < (fifo_occ_lim+4)) and (first_pkt_rdr = '1') and (startRead = '1') and (replace_pkt_raw = '0')) then
--            if((left_odd_fifo_occ < (4)) and (left_even_fifo_occ < (4)) and (startRead = '1') ) then
--                just_b4_replacing <= '1';
--            else
--                just_b4_replacing <= '0';
--            end if;    
               
            
            
            
            
    
--    end if;
--end process;

--replace_timeout <= '0' when sr_count < sr_count_final else '1';


replace_in_progress_pulse_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
begin
    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1'  then
        replace_inprogress_in_reg <= '0';      
    elsif rising_edge (CLK_125) then
        replace_inprogress_in_reg <=  replace_pkt_raw;
    end if;
end process;


replace_inprogress_in_pos <=  (replace_inprogress_in_reg xor replace_pkt_raw) when  (replace_pkt_raw = '1') else '0';
replace_inprogress_in_neg <=  (replace_inprogress_in_reg xor replace_pkt_raw) when  (replace_pkt_raw = '0') else '0';


replace_inprogress_sig_pulse_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
begin
    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1'  then
        replace_inprogress_sig_reg <= '0';      
    elsif rising_edge (CLK_125) then
        replace_inprogress_sig_reg <=  replace_inprogress_sig;
    end if;
end process;

replace_inprogress_sig_pos <=  (replace_inprogress_sig_reg xor replace_inprogress_sig) when  (replace_inprogress_sig = '1') else '0';
replace_inprogress_sig_neg <=  (replace_inprogress_sig_reg xor replace_inprogress_sig) when  (replace_inprogress_sig = '0') else '0';



timing_offset <= ((unsigned(rx_time_code_eff) - sync_time_code)) when unsigned(rx_time_code_eff) > sync_time_code else (others=>'0');
play_out_time <= (unsigned(rx_time_code) + unsigned(play_out_delay)) when (tc_sync_en = '1') else (others=>'0');

--next_play_out_time <= (unsigned(payload_length) + play_out_time) when oddEvenWriteSelect= '1' else (play_out_time + 8);
play_out_delay_out <= std_logic_vector(play_out_delay);
current_sync_time_out   <= std_logic_vector(sync_time_code);


just_b4_replacing <= '1' when (((left_odd_fifo_occ < o_slot_skip_count) and (left_even_fifo_occ < o_slot_skip_count)) and (startRead = '1')) else '0';

--skip_slot_out <= '1' when ((sync_time_code >= next_play_out_time) or (just_b4_replacing = '1')) else '0';
skip_slot_out <= just_b4_replacing;


next_play_out_time_out <= std_logic_vector(next_play_out_time);
--play_out_en <= '1' when (sync_time_code >= play_out_time) or (replace_inprogress_in = '1') else '0';
--play_out_en <= '1' when ((state_val /= "11111") and ((sync_time_code >= play_out_time) or (tc_sync_en = '0'))) else '0';
--play_out_en <= '1' when (((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (sync_time_code_roll_over = '1'))) else '0';
--play_out_en <= '1' when (((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (just_b4_replacing = '1' and oddEvenWriteSelect = '1'))) else '0';
--play_out_en <= '1' when (((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (just_b4_replacing = '1'))) else '0';
play_out_en <= '1' when ((sync_time_code >= play_out_time)) else '0';

--play_out_en <= '1' when (((sync_time_code >= play_out_time) and just_b4_replacing = '0') or ((sync_time_code >= play_out_time - e_slot_skip_count) and just_b4_replacing = '1')) else '0';
                    


play_out_ready_out <= play_out_en;
--dac_fifo_read <= play_out_en; -- now only used to control the axis bus only

--pkt_too_late <=  '1' when (((sync_time_code > play_out_time+late_allowance) and (just_b4_replacing = '1')) or ((sync_time_code > play_out_time + 4) and (just_b4_replacing = '0'))) else '0';
pkt_too_late <=  '1' when (((sync_time_code > play_out_time+late_allowance))) else '0';-- put allowance for serial packtes (parallel is ideal)


test_pattern_gen : process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)                                                                        
  begin   
    if s_ch1_audio_payload_axis_aresetn = '0'   or resetFifos = '1' then
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
        
        if (resetOddDACFifo ='1' or resetEvenDACFifo  ='1') then
            leftTest24Bit <= (others => '0');
            rightTest24Bit <= (others => '0');
      end if;
                                                                            
  end process test_pattern_gen; 
  
  
  testLeftData <= std_logic_vector(leftTest24Bit);
  testRightData <= std_logic_vector(rightTest24Bit);
--  adcLeftData <= line_in_l_in;
--  adcRightData <= line_in_r_in;
  test_mode_final <= test_mode; 
  
--  leftOut24Bit <= dacOddFIFOData when (test_mode_final = '0') else testLeftData;
--  rightOut24Bit <=  dacEvenFIFOData when (test_mode_final = '0') else testRightData;
  
  
  
     
   

--    payload_length <= wValue(15 downto  0) when (writeReg = '1' and wAdr="0011") else payload_length;
    
    FIFO_LEFT_ODD_OutDAC : SyncDualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => FIFO_ADDR_WIDTH
    )
    port map (
        -- Reading port.
        Data_out    => dacLeftOddFIFOData,
        PktEnd_out  => PktEnd_FIFO_LeftOdd,
        Empty_out   => dacLeftOddFIFOEmpty,
        ReadEn_in   => dac_ofifo_read,
        RClk        => read_Odd_FIFOClk,
        
        -- Writing port.
        Data_in     => leftOut24BitTmp,
        PktEnd_in  => dpk_pkt_end,
        Full_out    => dacLeftOddFIFOFull,
        WriteEn_in  => writeOddDACFifo,
        WClk        => writeDACFifoClk,
     
        fifo_occ_out => left_odd_fifo_occ,--open,
        Clear_in    => resetFifos
    );
    
    
    
    
    FIFO_LEFT_EVEN_OutDAC : SyncDualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => FIFO_ADDR_WIDTH
    )
    port map (
        -- Reading port.
        Data_out    => dacLeftEvenFIFOData,
        PktEnd_out  => PktEnd_FIFO_LeftEven,
        Empty_out   => dacLeftEvenFIFOEmpty,
        ReadEn_in   => dac_efifo_read,
        RClk        => read_Even_FIFOClk,
        
        -- Writing port.
        Data_in     => leftOut24BitTmp,
        PktEnd_in  => dpk_pkt_end,
        Full_out    => dacLeftEvenFIFOFull,
        WriteEn_in  => writeEvenDACFifo,
        WClk        => writeDACFifoClk,
     
        fifo_occ_out => left_even_fifo_occ,
        Clear_in    => resetFifos
    );
    
    
    
    FIFO_RIGHT_ODD_OutDAC : SyncDualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => FIFO_ADDR_WIDTH
    )
    port map (
        -- Reading port.
        Data_out    => dacRightOddFIFOData,
        PktEnd_out  => PktEnd_FIFO_RightOdd,
        Empty_out   => dacRightOddFIFOEmpty,
        ReadEn_in   => dac_ofifo_read,
        RClk        => read_Odd_FIFOClk,
        
        -- Writing port.
        Data_in     => rightOut24BitTmp,
        PktEnd_in  => dpk_pkt_end,
        Full_out    => dacRightOddFIFOFull,
        WriteEn_in  => writeOddDACFifo,
        WClk        => writeDACFifoClk,
     
        fifo_occ_out => right_odd_fifo_occ,
        Clear_in    => resetFifos
    );
    
    
    
    
    FIFO_RIGHT_EVEN_OutDAC : SyncDualClockFIFO
    generic map (
        DATA_WIDTH => 24,
        ADDR_WIDTH => FIFO_ADDR_WIDTH
    )
    port map (
        -- Reading port.
        Data_out    => dacRightEvenFIFOData,
        PktEnd_out  => PktEnd_FIFO_RightEven,
        Empty_out   => dacRightEvenFIFOEmpty,
        ReadEn_in   => dac_efifo_read,
        RClk        => read_Even_FIFOClk,
        
        -- Writing port.
        Data_in     => rightOut24BitTmp,
        PktEnd_in  => dpk_pkt_end,
        Full_out    => dacRightEvenFIFOFull,
        WriteEn_in  => writeEvenDACFifo,
        WClk        => writeDACFifoClk,
     
        fifo_occ_out => right_even_fifo_occ,
        Clear_in    => resetFifos
    );
    
    
    read_Odd_FIFOClk <=  newsample_div2_125 when startRead = '1'  else '0';
    read_Even_FIFOClk <= newsample_div2_125 when startRead = '1' else '0';
    
    
 

 
 
 
--  leftOut24Bit <=  leftOddOut24Bit when (oddEvenReadSelect = '0') else leftEvenOut24Bit;
--  rightOut24Bit <=  rightOddOut24Bit when (oddEvenReadSelect = '0') else rightEvenOut24Bit;

--leftOut24Bit <=  leftOddOut24Bit when (oddEvenReadSelect = '0' and intpOdd = '0') else leftEvenOut24Bit when (oddEvenReadSelect = '1' and intpEven = '0') else leftOddIntOut24Bit when (intpOdd = '1') else leftEvenIntOut24Bit when (intpEven = '1');
--rightOut24Bit <=  rightOddOut24Bit when (oddEvenReadSelect = '0' and intpOdd = '0') else rightEvenOut24Bit when (oddEvenReadSelect = '1' and intpEven = '0') else rightOddIntOut24Bit when (intpOdd = '1') else rightEvenIntOut24Bit when (intpEven = '1');

--leftOut24Bit  <=  leftOddIntOut24Bit  when (intpOdd = '1' and lockRead = '0') else leftEvenIntOut24Bit  when (intpEven = '1' and lockRead = '0') else dacLeftOddFIFOData  when (oddEvenReadSelect = '0' and intpOdd = '0' and intpEven = '0' and lockRead = '0' and (dacLeftOddFIFOEmpty = '0')) else dacLeftEvenFIFOData  when (oddEvenReadSelect = '1' and intpEven = '0' and intpOdd = '0' and lockRead = '0' and (dacLeftEvenFIFOEmpty = '0')) else leftOut24Bit;
--rightOut24Bit <=  rightOddIntOut24Bit when (intpOdd = '1' and lockRead = '0') else rightEvenIntOut24Bit when (intpEven = '1' and lockRead = '0') else dacRightOddFIFOData when (oddEvenReadSelect = '0' and intpOdd = '0' and intpEven = '0' and lockRead = '0' and (dacRightOddFIFOEmpty = '0')) else dacRightEvenFIFOData when (oddEvenReadSelect = '1' and intpEven = '0' and intpOdd = '0' and lockRead = '0' and (dacRightEvenFIFOEmpty = '0')) else rightOut24Bit;

--leftOut24Bit  <=  std_logic_vector(leftOddIntOut24Bit)  when (intpOdd = '1') else std_logic_vector(leftEvenIntOut24Bit) when (intpEven = '1') else leftOut24Bit;
--rightOut24Bit <=  std_logic_vector(rightOddIntOut24Bit) when (intpOdd = '1') else std_logic_vector(rightEvenIntOut24Bit) when (intpEven = '1') else rightOut24Bit;


--leftOut24Bit  <=  std_logic_vector(leftOddIntOut24Bit)  when (intpOdd = '1'and intpEven = '0') else std_logic_vector(leftEvenIntOut24Bit) when (intpEven = '1' and intpOdd = '0') else std_logic_vector(leftOddIntOut24Bit);
--rightOut24Bit <=  std_logic_vector(rightOddIntOut24Bit) when (intpOdd = '1'and intpEven = '0') else std_logic_vector(rightEvenIntOut24Bit) when (intpEven = '1' and intpOdd = '0') else std_logic_vector(rightOddIntOut24Bit);


--leftOut24Bit  <=  std_logic_vector(leftOddIntOut24Bit)  when (oddEvenReadSelect = '1') else std_logic_vector(leftEvenIntOut24Bit);
--rightOut24Bit <=  std_logic_vector(rightOddIntOut24Bit) when (oddEvenReadSelect = '1') else std_logic_vector(rightEvenIntOut24Bit);

dacLeftFIFOData <= std_logic_vector(dacLeftOddFIFOData)  when (oddEvenReadSelect = '1') else std_logic_vector(dacLeftEvenFIFOData);
dacRightFIFOData  <= std_logic_vector(dacRightOddFIFOData)  when (oddEvenReadSelect = '1') else std_logic_vector(dacRightEvenFIFOData);




--plc_pkt_end_right <= PktEnd_FIFO_RightEven when (oddEvenReadSelect = '0') else PktEnd_FIFO_RightOdd;
--plc_pkt_end_left <= PktEnd_FIFO_LeftEven when (oddEvenReadSelect = '0') else PktEnd_FIFO_LeftOdd;




--intpOdd <= '1' when ((dacLeftEvenFIFOEmpty = '1') and (dacLeftOddFIFOEmpty = '0'))  else '0'; 
--intpEven <= '1' when ((dacLeftEvenFIFOEmpty = '0') and (dacLeftOddFIFOEmpty = '1'))  else '0';   
intpOdd <= '1' when (dacLeftOddFIFOEmpty = '0')  else '0'; 
intpEven <= '1' when (dacLeftEvenFIFOEmpty = '0')  else '0'; 

--oddEvenReadSelect <= '1' when ((left_odd_fifo_occ > left_even_fifo_occ) and (left_even_fifo_occ < 6)) else '0' when ((left_odd_fifo_occ < left_even_fifo_occ) and (left_odd_fifo_occ < 6)) else oddEvenReadSelect;


out_oe_selct_process: process(newsample_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
begin
    if s_ch1_audio_payload_axis_aresetn = '0' or resetFifos = '1' then
        oddEvenReadSelect <= '0';  
        
--        dac_efifo_read <= '0'; 
--        dac_ofifo_read <= '0';  

--        replace_pkt_raw_d <= '0';
    elsif rising_edge (newsample_125) then   
     

        if ((left_odd_fifo_occ > left_even_fifo_occ) and (left_even_fifo_occ <= 1 and left_odd_fifo_occ > 1) ) then
                oddEvenReadSelect <= '1' ;
        elsif ((left_even_fifo_occ > left_odd_fifo_occ) and (left_odd_fifo_occ <= 1 and left_even_fifo_occ > 1)) then
            oddEvenReadSelect <= '0' ;
        else         
            oddEvenReadSelect <= oddEvenReadSelect;
        end if;
        
        
--        if (dacLeftEvenFIFOEmpty = '0' and startRead = '1' and (replace_pkt_raw = '0' or replace_pkt_rel = '1' or replace_pkt_exit = '1')) then
--            dac_efifo_read <= '1';
--        else 
--            dac_efifo_read <= '0'; 
--        end if;
        
--        if(dacLeftOddFIFOEmpty = '0'and startRead = '1'  and (replace_pkt_raw = '0' or replace_pkt_rel = '1' or replace_pkt_exit = '1')) then
--            dac_ofifo_read <= '1';
--        else 
--            dac_ofifo_read <= '0'; 
--        end if;
        
        

        
--        replace_pkt_raw_d <= replace_pkt_raw;
        
        
        
        
        
    end if;
end process;

 
 dac_efifo_read <= '1' when (dacLeftEvenFIFOEmpty = '0' and startRead = '1' and (replace_pkt_raw = '0' or replace_pkt_rel = '1' or replace_pkt_exit = '1')) else '0';
 dac_ofifo_read <= '1' when (dacLeftOddFIFOEmpty = '0'and startRead = '1'  and (replace_pkt_raw = '0' or replace_pkt_rel = '1' or replace_pkt_exit = '1')) else '0';
 
 
 
 
 
 
 
 
 





cic_interpolator_left: cic_filter
    generic map(
        SIG_IN_WIDTH => CIC_SIG_IN_WIDTH,
        SIG_OUT_WIDTH => CIC_SIG_OUT_WIDTH
    )
    port map(
        clk  => newsample_125,
        rst => resetFifos,
        x   => signed(dacLeftFIFOData),
        dvi => '1',--newsample_in_div2, --read_Odd_FIFOClk, --'1', --dac_ofifo_read,
        y => leftIntOut24Bit_cic,
        dvo => open
    );



comp_interpolator_left: compfilt
generic map (
        SIG_IN_WIDTH => CIC_SIG_OUT_WIDTH,
        SIG_OUT_WIDTH => COMP_SIG_OUT_WIDTH
    )
    port map(
        clk  => newsample_125,
        rst => resetFifos,
        x => leftIntOut24Bit_cic,
        xdv => '1',
        y => leftIntOut24Bit_tmp,
        ydv => open
    );

--leftOddIntOut24Bit <= leftOddIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto CIC_SIG_OUT_WIDTH-CIC_SIG_IN_WIDTH);
--leftOddIntOut24Bit <= leftOddIntOut24Bit_tmp(27 downto 4);
leftIntOut24Bit <= resize ( leftIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 2) , leftIntOut24Bit ' length ) ; --good
--leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 1) , leftOddIntOut24Bit ' length ) ; --good
--leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_cic , leftOddIntOut24Bit ' length ) ; saturates
--leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto 2) , leftOddIntOut24Bit ' length ) ;
--leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_tmp , leftOddIntOut24Bit ' length ) ;


cic_interpolator_right: cic_filter
    generic map(
        SIG_IN_WIDTH => CIC_SIG_IN_WIDTH,
        SIG_OUT_WIDTH => CIC_SIG_OUT_WIDTH
    )
    port map(
        clk  => newsample_125,
        rst => resetFifos,
        x   => signed(dacRightFIFOData),
        dvi => '1',--newsample_in_div2, --read_Odd_FIFOClk, -- '1', --dac_ofifo_read,
        y => rightIntOut24Bit_cic,
        dvo => open
    );



comp_interpolator_odd_right: compfilt
generic map (
        SIG_IN_WIDTH => CIC_SIG_OUT_WIDTH,
        SIG_OUT_WIDTH => COMP_SIG_OUT_WIDTH
    )
    port map(
        clk  => newsample_125,
        rst => resetFifos,
        x => rightIntOut24Bit_cic,
        xdv => '1',
        y => rightIntOut24Bit_tmp,
        ydv => open
    );
--rightOddIntOut24Bit <= rightOddIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto CIC_SIG_OUT_WIDTH-CIC_SIG_IN_WIDTH);
--rightOddIntOut24Bit <= rightOddIntOut24Bit_tmp(27 downto 4);
rightIntOut24Bit <= resize ( rightIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 2) , rightIntOut24Bit ' length ) ;--good
--rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 1) , rightOddIntOut24Bit ' length ) ; --good
--rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_cic , rightOddIntOut24Bit ' length ) ;--saturates
--rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto 2) , rightOddIntOut24Bit ' length ) ;
--rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_tmp , rightOddIntOut24Bit ' length ) ;



leftOut24Bit  <=  std_logic_vector(leftIntOut24Bit);
rightOut24Bit <=  std_logic_vector(rightIntOut24Bit);
  
plc_read_ptr_set <= '1' when ((left_odd_fifo_occ <= fifo_occ_lim+1) and (left_even_fifo_occ <= fifo_occ_lim+1) and (first_pkt_rdr = '1') and (startRead = '1')) else '0'; 
plc_move_to_replace <= '1' when ((left_odd_fifo_occ <= fifo_occ_lim) and (left_even_fifo_occ <= fifo_occ_lim) and (first_pkt_rdr = '1') and (startRead = '1')) else '0';

plc_controller: process(newsample_125,s_ch1_audio_payload_axis_aresetn, resetOddDACFifo, resetEvenDACFifo) is      
        
    begin
    
        if (s_ch1_audio_payload_axis_aresetn = '0' or (resetOddDACFifo ='1' or resetEvenDACFifo  ='1')) then
                replace_pkt_trig <= '0';
                replace_pkt_raw <= '0';  
                replace_pkt_rel <= '0';
                replace_pkt_exit <= '0';
                replace_pkt_entry <= '0';
                replace_pkt_set <= '0'; 
                pkt_end_sim <= '0';
                entry_counter <= (others => '0');
                replace_events <= (others => '0');
                exit_counter <= (others => '0');
                rel_counter <= (others => '0');
                sampleCounter <= (others => '0');
                last_left_plc_value <= (others => '0');
                last_right_plc_value <= (others => '0');
                 plc_state <= idle;
        elsif rising_edge(newsample_125) then
            
          case plc_state is
             when idle =>      
                exit_counter <= (others => '0');
                entry_counter <= (others => '0');
                rel_counter <= (others => '0'); 
                replace_pkt_rel <= '0'; 
                replace_pkt_trig <= '0';   
                replace_pkt_exit <= '0';  
                replace_pkt_entry <= '0';
                replace_pkt_raw <= '0';
                replace_pkt_set <= '0';    
                

                
                if(startRead = '1'  and (sampleCounter < SIM_PKT_SIZE)) then
                    sampleCounter <= sampleCounter + 1;
                    pkt_end_sim <= '0';
                else
                    sampleCounter <= (others => '0'); 
                    pkt_end_sim <= '1';       
                end if;
    --                if (packet_available_in = '0' and plc_read_ptr_set = '1') then
                if (plc_read_ptr_set = '1') then
                    replace_pkt_set <= '1';-- when  
                end  if;   
--                if (plc_move_to_replace = '1' and packet_available_in = '0') then -- causes plc not to kick in sometimes -> playout delay requirements
                if (plc_move_to_replace = '1') then
                    replace_pkt_trig <= '1';-- when  
                    replace_events <= replace_events + 1;
--                    if(ENTRY_FADE_LENGTH > 2) then
--                        replace_pkt_entry <= '1';    
--                        plc_state <= fade_entry;
--                    else
                        replace_pkt_raw <= '1';
                        replace_pkt_entry <= '0';  
                        replace_pkt_set <= '0';   
                        pkt_end_sim <= '0'; 
                        plc_state <= replace;
--                    end if;
                else
                    plc_state <= idle;
                    replace_events <= replace_events;
                end  if;
            
                
                
                
--                if(startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter = SIM_PKT_SIZE-1)) then
--                    pkt_end_sim <= '1';
--                else
--                    pkt_end_sim <= '0';       
--                end if;
                
                
                
               
        
        
    --        if((replace_pkt_raw = '1') or (replace_pkt_rel = '1') or (replace_pkt_trig = '1') or (replace_pkt_exit = '0')) then
--            if(replace_pkt_exit = '0') then
                last_left_plc_value <= dacLeftLIFOData;
                last_right_plc_value <= dacRightLIFOData;
--            end if;
                when fade_entry =>        
                   entry_counter <= entry_counter + 1;
                   replace_pkt_raw <= '1';
                   replace_pkt_rel <= '0';
                   replace_pkt_set <= '0'; 
                   if(entry_counter >= ENTRY_FADE_LENGTH) then                        
                       replace_pkt_entry <= '0';
                        plc_state <= replace;          
                    else
                        replace_pkt_entry <= '1'; 
                        plc_state <= fade_entry;
                    end if;
                    last_left_plc_value <= dacLeftLIFOData;
                    last_right_plc_value <= dacRightLIFOData;
                when replace=>
                    entry_counter <= (others => '0');
                    exit_counter <= (others => '0');
                    rel_counter <= (others => '0'); 
                    sampleCounter <= (others => '0');
                    replace_pkt_set <= '0'; 
                    replace_pkt_raw <= '1';
                    replace_pkt_entry <= '0';
                    pkt_end_sim <= '0';
                    last_left_plc_value <= dacLeftLIFOData;
                    last_right_plc_value <= dacRightLIFOData;
                    
                    if ((left_odd_fifo_occ > (fifo_occ_lim + ((EXIT_FADE_LENGTH + REL_PIPE_LENGTH)/2))) or (left_even_fifo_occ > (fifo_occ_lim+((EXIT_FADE_LENGTH+REL_PIPE_LENGTH)/2)))) then
                        replace_pkt_rel <= '1'; 
                        plc_state <= release;          
                    else
                        replace_pkt_rel <= '0'; 
                        plc_state <= replace;
                    end if;
                        
               when release =>
                    exit_counter <= (others => '0');
                    entry_counter <= (others => '0');
                    sampleCounter <= (others => '0');
                    replace_pkt_entry <= '0';
                    replace_pkt_set <= '0'; 
                    replace_pkt_raw <= '1';
                    rel_counter <= rel_counter + 1;
                    if(rel_counter >= REL_PIPE_LENGTH) then        
                       
                       replace_pkt_rel <= '0';
                         
                        
--                         if(EXIT_FADE_LENGTH > 2) then
                            replace_pkt_exit <= '1';
                            replace_pkt_raw <= '1';
                            plc_state <= fade_exit;
--                        else
--                            replace_pkt_exit <= '0';    
--                            plc_state <= idle;
--                            replace_pkt_raw <= '0';
--                        end if;        
                    else
                        replace_pkt_rel <= '1'; 
                        plc_state <= release;
                    end if;
                    last_left_plc_value <= dacLeftLIFOData;
                    last_right_plc_value <= dacRightLIFOData;
                        
                   when fade_exit =>
                        entry_counter <= (others => '0');
                        rel_counter <= (others => '0'); 
--                        sampleCounter <= (others => '0');
                        replace_pkt_entry <= '0';
                        replace_pkt_set <= '0'; 
                        
                        exit_counter <= exit_counter + 1;                      
                        
                        replace_pkt_raw <= '1';
                        replace_pkt_rel <= '0';
                        if(exit_counter >= EXIT_FADE_LENGTH) then
                            replace_pkt_exit <= '0';
                            replace_pkt_raw <= '0';
                            plc_state <= idle;
                        else                        
                            replace_pkt_exit <= '1';
                        end if;
    
                        if(startRead = '1' and (sampleCounter < SIM_PKT_SIZE)) then
                            sampleCounter <= sampleCounter + 1;
                            pkt_end_sim <= '0';
                        else
                            sampleCounter <= (others => '0'); 
                            pkt_end_sim <= '1';       
                        end if;
                        
                        
--                        if(startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter = SIM_PKT_SIZE - 1)) then
--                            pkt_end_sim <= '1';
--                        else
--                            pkt_end_sim <= '0';       
--                        end if;
                         last_left_plc_value <= dacLeftLIFOData;
                          last_right_plc_value <= dacRightLIFOData;
                       
                   when others =>
                        plc_state <= idle;
                        replace_pkt_rel <= '0'; 
                        replace_pkt_entry <= '0';
                        replace_pkt_trig <= '0';   
                        replace_pkt_exit <= '0';  
                        replace_pkt_raw <= '0';  
                        replace_pkt_set <= '0'; 
                        pkt_end_sim <= '0';
                        sampleCounter <= (others => '0');    
                        exit_counter <= (others => '0');
                        entry_counter <= (others => '0');
                        rel_counter <= (others => '0'); 

                end case;
                
                

                               
                if (resetOddDACFifo ='1' or resetEvenDACFifo  ='1') then
                     exit_counter <= (others => '0');
                     rel_counter <= (others => '0'); 
                     sampleCounter <= (others => '0');
                end if;
               
                
     
        
        
       
    end if; -- reset
            
end process;


--pkt_end_sim <= '1' when (startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter = SIM_PKT_SIZE - 1)) else '0';

fader_direction_process: process(s_ch1_audio_payload_axis_aresetn, resetFifos, media_channel_dropped, replace_pkt_exit, replace_pkt_entry, replace_pkt_raw, replace_pkt_rel)
    begin
    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1' then
            fade_dpkt_direction_reg <= '0'; -- up
            fade_plc_direction_reg <= '1'; -- down
            fade_plc_max_reg   <= '0';
            fade_dpk_min_reg   <= '0';
            fade_plc_min_reg   <= '1'; 
            fade_dpk_max_reg   <= '1';  
            rst_out <= '1'; 
        else

            if(media_channel_dropped = '1') then
                fade_plc_min_reg   <= '1'; 
                fade_dpk_max_reg   <= '0'; 
                fade_dpk_min_reg   <= '1'; 
                fade_plc_max_reg   <= '0';    
                
                fade_dpkt_direction_reg <= '0'; -- up
                fade_plc_direction_reg <= '1'; -- down  
            elsif(replace_pkt_exit = '1') then
                -- Disable min max to get sweeping control
                fade_plc_min_reg   <= '0'; 
                fade_plc_max_reg   <= '0'; 
                fade_dpk_min_reg   <= '0'; 
                fade_dpk_max_reg   <= '0'; 
                
                fade_dpkt_direction_reg <= '0'; -- up
                fade_plc_direction_reg <= '1'; -- down
            elsif(replace_pkt_entry = '1') then
                fade_plc_min_reg   <= '0'; 
                fade_plc_max_reg   <= '0'; 
                fade_dpk_min_reg   <= '0'; 
                fade_dpk_max_reg   <= '0'; 
                
                fade_dpkt_direction_reg <= '1'; -- down
                fade_plc_direction_reg <= '0'; -- up
--            elsif((replace_pkt_raw = '1' or (replace_pkt_rel = '1')) and (replace_pkt_exit = '0') and (replace_pkt_entry = '0')) then    
            elsif((replace_pkt_raw = '1') or (replace_pkt_rel = '1')) then 
                fade_dpk_min_reg   <= '1'; 
                fade_plc_max_reg   <= '1'; 
                fade_plc_min_reg   <= '0'; 
                fade_dpk_max_reg   <= '0'; 
                
                fade_dpkt_direction_reg <= '0'; -- up
                fade_plc_direction_reg <= '1'; -- down                
            else
                 fade_plc_min_reg   <= '1'; 
                fade_dpk_max_reg   <= '1'; 
                fade_dpk_min_reg   <= '0'; 
                fade_plc_max_reg   <= '0'; 
                
                fade_dpkt_direction_reg <= '0'; -- up
                fade_plc_direction_reg <= '1'; -- down
            end if;     
            
            
--            if(media_channel_dropped = '1') then
--                fade_plc_min_reg   <= '1'; 
--                fade_dpk_max_reg   <= '0'; 
--                fade_dpk_min_reg   <= '1'; 
--                fade_plc_max_reg   <= '0';             
--            end if;          

            
          rst_out <= resetFifos;  
            
       end if;
    --fade_dpkt_direction_reg <= '0' when (new_pkt_ready_in_pulse = '1' and replace_inprogress_in = '1') else '1' when replace_inprogress_in_pulse =  '1' else fade_dpkt_direction_reg;
    
    --fade_plc_direction_reg <= '1' when (new_pkt_ready_in_pulse = '1' and replace_inprogress_in = '1') else '0' when replace_inprogress_in_pulse =  '1' else fade_plc_direction_reg;
end process;


fade_dpk_enable_reg <= '1'; -- this allows to hold the fade values, great for zero values
--    fade_plc_enable_reg <= '1' when (replace_pkt_raw = '0') else '0';
--fade_plc_enable_reg <= '1' when (replace_pkt_raw = '1') else '0';
fade_plc_enable_reg <= '1';

--clear takes values to delault == max
fade_dpk_clear_reg <= '0';
fade_plc_clear_reg <= '0';



fade_dpkt_direction_out <= fade_dpkt_direction_reg;  --- Up
fade_plc_direction_out <= fade_plc_direction_reg;  --- Up;  --- down

fade_dpk_enable_out <= fade_dpk_enable_reg;--fade_enable_reg and replace_inprogress_in;
fade_plc_enable_out <= fade_plc_enable_reg;

fade_plc_clear_out  <= fade_plc_clear_reg;-- when ((fade_enable_reg and replace_inprogress_in) = '1') else '1';
--    fade_dpk_clear_out  <= '0' when (replace_inprogress_in = '1') else '1';
fade_dpk_clear_out  <= fade_dpk_clear_reg;




fade_plc_max_out   <= fade_plc_max_reg;
fade_plc_min_out   <= fade_plc_min_reg;

fade_dpk_min_out   <= fade_dpk_min_reg;      
fade_dpk_max_out   <= fade_dpk_max_reg;

        
--pkt_end_sim <= '0' when (sampleCounter < 4) else '1';        
writeOddDACFifo <= writeOddDACFifoEth;-- when (writeSourceSelect = '0') else writeLeftDACFifoArm;
writeEvenDACFifo <= writeEvenDACFifoEth;-- when (writeSourceSelect = '0') else writeRightDACFifoArm;

fifo_write_odd <= writeOddDACFifoEth;
fifo_write_even <= writeEvenDACFifoEth;

leftFifo24BitIn <= leftFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
rightFifo24BitIn <= rightFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);

    
    writeDACFifoClk <= CLK_125;-- when (writeSourceSelect = '0') else s00_axi_aclk;
    
    
    
    
    leftFifo24BitIn <= leftFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
    rightFifo24BitIn <= rightFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
    
    
   
   
   

    -----------------------------------------------------------------------PLC-------------------------------------------------------------------
    
   
    LIFO_L_OutDAC : DualClockLIFO
    generic map (
        DATA_WIDTH => FIFO_DATA_WIDTH,
        ADDR_WIDTH => LIFO_ADDR_WIDTH,
        PKT_LEN_WIDTH => SIM_PKT_LEN_WIDTH
    )
    port map (
        -- Reading port.
        Data_out    => dacLeftLIFOData,
        Empty_out   => dacLeftLIFOEmpty,
        ReadEn_in   => dac_lifo_read,
        RClk        => read_PLC_Clk,
        
        PktEnd_out  => PktEnd_LIFO_L,
        Replace_pkt_in => replace_pkt_set,
        Replace_inprogress_in  =>   replace_inprogress_sig, --- This can also do Replace_overlap by prolonging it until the end of the first packet
--        Replace_inprogress_in  =>   replace_pkt_raw,
        
        -- Writing port.
        
        PktEnd_in  => plc_pkt_end_left,
        Data_in     => leftOut24Bit,
        Full_out    => dacLeftLIFOFull,
        WriteEn_in  => writeLeftDACLifo,
        WClk        => writeDACLifoClk,
     
        fifo_occ_out => left_lifo_occ,--open,
        Clear_in    => resetLifos
    );
    
    
    
    
    LIFO_R_OutDAC : DualClockLIFO
    generic map (
        DATA_WIDTH => FIFO_DATA_WIDTH,
        ADDR_WIDTH => LIFO_ADDR_WIDTH,
        PKT_LEN_WIDTH => SIM_PKT_LEN_WIDTH
    )
    port map (
        -- Reading port.
        Data_out    => dacRightLIFOData,
        Empty_out   => dacRightLIFOEmpty,
        ReadEn_in   => dac_lifo_read,
        RClk        => read_PLC_Clk,
        
        PktEnd_out  => PktEnd_LIFO_R,
        Replace_pkt_in => replace_pkt_set,
        Replace_inprogress_in  =>   replace_inprogress_sig, --- This can also do Replace_overlap by prolonging it until the end of the first packet
--        Replace_inprogress_in  =>   replace_pkt_raw,
        
        -- Writing port.
        
        PktEnd_in  => plc_pkt_end_right,

        Data_in     => rightOut24Bit,
        Full_out    => dacRightLIFOFull,
        WriteEn_in  => writeRightDACLifo, 
        WClk        => writeDACLifoClk,
     
        fifo_occ_out => right_lifo_occ,
        Clear_in    => resetLifos
    );
    
    
    
    
    resetFifos <= '1' when (resetEvenDACFifo = '1' or resetOddDACFifo = '1' or s_ch1_audio_payload_axis_aresetn = '0' or clearFifos = '1') else '0';
    resetLifos <= '1' when (resetEvenDACFifo = '1' or resetOddDACFifo = '1' or s_ch1_audio_payload_axis_aresetn = '0' or clearFifos = '1') else '0';
    
    read_PLC_Clk <= newsample_125 when startRead = '1' else '0'; 
--    read_PLC_Clk <= newsample_in;
    writeDACLifoClk <= newsample_125 when startRead = '1' else '0'; 
    
    
    dac_lifo_read <= '1' when ((replace_pkt_raw = '1' or replace_pkt_exit = '1') and  startRead = '1') else '0'; 
    replace_inprogress_sig <= '1' when ((replace_pkt_raw = '1' or replace_pkt_exit = '1') and  startRead = '1') else '0'; 

    
    writeRightDACLifo <= '1' when ((replace_pkt_raw = '0'  or replace_pkt_exit = '1') and  startRead = '1') else '0'; --(dac_efifo_read or dac_ofifo_read);
    writeLeftDACLifo <= '1' when ((replace_pkt_raw = '0'  or replace_pkt_exit = '1') and  startRead = '1') else '0'; --writeRightDACLifo;
    --dpk_pkt_end <= s_ch1_audio_payload_axis_tlast; bad idea
    ---------------------------------------------------------------------------------------------------------------------------------------------

    plc_pkt_end_right <= pkt_end_sim;
    plc_pkt_end_left <= pkt_end_sim;


    
    
    
    

    

    tc_sync_en <= tc_sync_en_in;

    test_sig_sel <= (test_mode_final & test_pattern);
    -- IRQ Generation.
    -- TODO (2), make sure we generate ONE pulse ? Assert until... ?
    irq_out <= '0';
    


    
    plc_audio_l_out <=  dacLeftLIFOData when (replace_pkt_raw = '1' or replace_pkt_exit = '1') else last_left_plc_value;
    plc_audio_r_out <= dacRightLIFOData when (replace_pkt_raw = '1' or replace_pkt_exit = '1') else last_right_plc_value;

--    plc_audio_l_out <=  last_left_plc_value when (replace_pkt_exit = '1') else dacLeftLIFOData;
--    plc_audio_r_out <=  last_right_plc_value when (replace_pkt_exit = '1') else dacRightLIFOData;
    
    
    
--    dpk_audio_l_out <=  leftOut24Bit when (replace_pkt_raw = '0') else dacLeftLIFOData;
--    dpk_audio_r_out <= rightOut24Bit when (replace_pkt_raw = '0') else dacRightLIFOData;
    
    dpk_audio_l_out <=  leftOut24Bit;
    dpk_audio_r_out <= rightOut24Bit;
    
    
    s_ch1_audio_payload_hdr_ready <= hdr_ready;
    s_ch1_audio_payload_axis_tready <= tready;
    tvalid <= s_ch1_audio_payload_axis_tvalid;
    tdata <= s_ch1_audio_payload_axis_tdata;
    tlast <= s_ch1_audio_payload_axis_tlast;
	-- User logic ends
	packet_count_mirror <= unsigned(packet_count);
	buf_count_mirror <= unsigned(buf_count);
	
	fifo_full_out <= '1' when (dacLeftEvenFIFOFull='1' or dacLeftOddFIFOFull = '1') else '0';
	fifo_empty_out <= '1' when (dacLeftEvenFIFOEmpty='1' or dacLeftOddFIFOEmpty = '1') else '0';
	

    
    fifo_occ <= left_odd_fifo_occ when left_odd_fifo_occ >= left_even_fifo_occ else left_even_fifo_occ;
    fifo_occ_out <= STD_LOGIC_VECTOR(fifo_occ);


    status2_out  <= '1' when state_val = "00000" else '0';  
    status1_out  <= '1' when (dacLeftEvenFIFOFull='0' or dacLeftOddFIFOFull = '0') else '0';
    
    
    first_pkt_ind <= first_pkt_wrt;
    
    
    newsample_125_out <= newsample_125;
    

    
end arch_imp;
--	packet_count_final <= packet_count_cnt;
--    packet_dumped_cnt_final <= packet_dumped_cnt;
--    enablePacketCount_final <= enablePacketCount;
----    oddFifo24BitIn <= data24BitTmp;
----    evenFifo24BitIn <= data24BitTmp;
--    rx_time_code_out <= std_logic_vector(rx_time_code);
--    rx_packet_seq_cnt_out <= std_logic_vector(rx_packet_seq_cnt);
    
--    next_rx_packet_seq_cnt <= rx_packet_seq_cnt + 1;
    
    
----    oddEvenWriteSelect <= '1' when rx_packet_seq_cnt(0) = '1' else '0';
      

-- rx_time_code <= unsigned(rx_time_code_1 & rx_time_code_2 & rx_time_code_3 & rx_time_code_4); 

---- M AXIS Write Process old
--    m_axis_reader: process(CLK_125,s_ch1_audio_payload_axis_aresetn, resetOddDACFifo, resetEvenDACFifo) is
        
--        variable bytecount : integer range 0 to 2000 := 0;
--        --variable hdrbytecount : integer range 0 to 32 := 0;
        
        
--    begin
    
--        if (s_ch1_audio_payload_axis_aresetn = '0' or (resetOddDACFifo ='1' or resetEvenDACFifo  ='1')) then
--                -- Reset
----                state <= st_idle;
--                state <= st_Lock; 
--                lock_pkts_count <= (others => '0');
--                bytecount := 0;
----                hdrbytecount <= (others => '0');
--                hdrbytecount <= (others => '0');
--                hdr_ready <= '0';
----                oddEvenWriteSelect <= '0';
----                last_oddEvenWriteSelect <= '1';
----                oddEvenReadSelect <= '0'; 
----                switch_to_even <= '0';
--                startRead <= '0';
--                stream_pkt_start <= '1';
--                writeEvenDACFifoEth <= '0';
--                writeOddDACFifoEth <= '0'; 
--                tready <= '0';
--                state_val <= "00000";
--                first_pkt_rdr <= '0';
--                first_pkt_wrt <= '1';
--                rxtc_fifo_write <= '0';
--                resetErrCount <= '0';
--                media_timer_reset <= '0';
--                oddEvenWriteSelect <= '0';
--                bad_pkt_count <= (others => '0');
                
--                leftOut24BitTmp <= (others => '0');
--                rightOut24BitTmp <= (others => '0');
                
                
----                rx_time_code_out <= (others => '0');
----                rx_packet_seq_cnt_out  <= (others => '0');
--                fifo_writes <= (others => '0');
----                buf_count_err_corr <= (others => '0');
----                rx_time_code <= (others => '0');
                
--                rx_time_code_1  <= (others => '0');
--                rx_time_code_2  <= (others => '0');
--                rx_time_code_3  <= (others => '0');
--                rx_time_code_4 <= (others => '0');
                
--                last_rx_time_code <= (others => '0');
                
                
--                rx_packet_seq_cnt_1  <= (others => '0');
--                rx_packet_seq_cnt_2 <= (others => '0');
                
--                rx_packet_seq_cnt   <= (others => '0');
--                last_rx_packet_seq_cnt   <= (others => '0');
                
--            elsif rising_edge(CLK_125) then
            
            
                
                
--                --tready <= '0';
--                --hdr_ready <= '0';
--                case state is
--                    when st_idle =>      
--                            dpk_pkt_end <= '0'; 
--                            dump_pkt <= '0';   
--                            clearFifos <= '0';   
--                            bytecount := 0;              
--                            tready <= '0';
--                            hdr_ready <= '0';
--                            hdrbytecount <= (others => '0');
--                            state <= st_idle;
--                            writeEvenDACFifoEth <= '0';
--                            writeOddDACFifoEth <= '0';
--                            media_timer_reset <= '0';
--                            last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
--                            --last_rx_time_code <= rx_time_code;should be done conditionally in chk
--                           if(stream_pkt_start = '1') then -- we do not know what the future holds
--                                hdr_ready <= '0'; 
--                                bytecount := 0; 
--                                if hdr_strip = '1' then     
--                                    state <= st_HdrBytes;
--                                    state_val <= "00001"; 
--                                    tready <= '1';                                   
--                                elsif((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then -- we do not know what the future holds
--                                        state <= st_Lbyte1;
--                                        state_val <= "00100";
--                                        tready <= '1';                                   
--                                end if;
--                                stream_pkt_start <= '0';
                                
                                
--                                hdrbytecount <= (others => '0');
--                            elsif(stream_pkt_start = '0') then
--                                hdr_ready <= '0';       
--                                if((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then -- we do not know what the future holds
--                                    state <= st_Lbyte1;
--                                    state_val <= "00100";
--                                    tready <= '1';
--                                 end if;
--                            end if;
--                            lock_pkts_count <= (others => '0');                     
--                            --bytecount := 0;  
--                    --HDR is LSB first    
--                    when st_HdrBytes =>
--                        dpk_pkt_end <= '0';
--                        hdr_ready <= hdr_ready;
--                        last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
----                        rxtc_fifo_write <= '0';
--                        tready <= '0';
--                        writeEvenDACFifoEth <= '0';
--                        writeOddDACFifoEth <= '0';
--                        stream_pkt_start <= '0';
--                        if (hdrbytecount < hdr_length-1) then
----                            data24BitTmp(23 downto 16) <= tdata;                                 
--                            tready <= '1';
--                            if tvalid = '1' then 
                                
--                                if (hdrbytecount = 0) then
--                                    rx_packet_seq_cnt_2 <= tdata;                                
--                                elsif(hdrbytecount = 1) then
--                                    rx_packet_seq_cnt_1 <= tdata; 
                                                             
--                                elsif(hdrbytecount = 2) then
--                                    rx_time_code_4 <= tdata;--lsb first       
                                                     
--                                elsif(hdrbytecount = 3) then
--                                    rx_time_code_3 <= tdata; 
                                                                   
--                                elsif(hdrbytecount = 4) then
--                                    rx_time_code_2 <= tdata;  
                                                                 
--                                elsif(hdrbytecount = 5) then
--                                    rx_time_code_1 <= tdata;  
                             
--                                elsif(hdrbytecount = 6) then
--                                    last_pkt_seq_count <= unsigned(rx_packet_seq_cnt);
--                                    rx_packet_seq_cnt <= unsigned(rx_packet_seq_cnt_1 & rx_packet_seq_cnt_2);
                                    
                                    
--    --                                if(tc_sync_en = '1') then
----                                    rx_time_code <= unsigned(rx_time_code_1 & rx_time_code_2 & rx_time_code_3 & rx_time_code_4); 
                               
--                                end if;
                            
--                                bytecount := bytecount + 1;
--                                hdrbytecount <= hdrbytecount + 1;
--                                state <= st_HdrBytes;  
--                            end if;
--                        --elsif (hdrbytecount >= hdr_length-1) then
--                        elsif tvalid = '1' and (hdrbytecount >= hdr_length-1) then
----                            if first_pkt_wrt <= '1' then
----                                rxtc_fifo_write <= '1';  
----                            end if;
----                            data24BitTmp(23 downto 16) <= tdata;
----                            if ((play_out_en = '1') or (tc_sync_en = '0')) then
                                
                                
                                
--                                tready <= '0';
----                                    last_oddEvenWriteSelect <= oddEvenWriteSelect;
----                                    oddEvenWriteSelect <= rx_packet_seq_cnt(0);

--                                    oddEvenWriteSelect <= rx_packet_seq_cnt(0);
--                                    state <= st_ChkTc;
--                                    state_val <= "00010";
----                                    hdrbytecount <= (others => '0');
--                                    bytecount := bytecount + 1; 
--                                    --block_on_next <= '1'; 
                                
----                            else
----                                tready <= '0';
----                                state <= st_HdrBytes;
----                                bytecount := bytecount;
----                                hdrbytecount := hdrbytecount;
----                            end if;
                             
                            
                            
--                            -- TC LSB first
----                            rx_time_code <= rx_time_code_1 & rx_time_code_2 & rx_time_code_3 & rx_time_code_4;
----                            rx_packet_seq_cnt <= rx_packet_seq_cnt_1 & rx_packet_seq_cnt_2;
--                        end if;
                        
--                        writeEvenDACFifoEth <= '0';
--                        writeEvenDACFifoEth <= '0'; 
                        
                        
                        
--                        if s_ch1_audio_payload_axis_tlast = '1' then
--                                bytecount := 0; 
--                               hdr_ready <= '1'; 
--                               startRead <= '0';   
--                               stream_pkt_start <= '1';
--                               first_pkt_wrt <= '0';
--                               dpk_pkt_end <= '1'; 
--                               state <= st_idle; 
--                               state_val <= "00000";   
--                               tready <= '0';   
--                               bad_pkt_count <= bad_pkt_count + 1;
--                            end if;
                        
                   
--                when st_ChkTc =>
--                       dpk_pkt_end <= '0';
--                       writeOddDACFifoEth <= '0';
--                       writeEvenDACFifoEth <= '0';    
                       
--                       tready <= '0';
--                       stream_pkt_start <= '0';
--                       hdrbytecount <= (others => '0');
--                       bytecount := bytecount;
--                       last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
----                       if (((rx_time_code < last_rx_time_code) and ((last_rx_time_code - rx_time_code) < 100000000)) ) then
----                                    state <= st_DumpPkt; -- drop the packet
----                                    state_val <= "11110";
----                                    tready <= '1'; 
----                       els
----                       if (((rx_time_code < last_rx_time_code) and ((last_rx_time_code - rx_time_code) < 100000000)) ) then
----                                    state <= st_DumpPkt; -- drop the packet
----                                    state_val <= "11110";
----                                    tready <= '1'; 
--                       if(pkt_too_late = '1') then 
--                            state <= st_DumpPkt; -- drop the packet
--                            state_val <= "11110";
--                            tready <= '1'; 
--                       elsif((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then
                       
--                            if (play_out_en = '1') then                            
----                                state <= st_DumpPkt; -- drop the packet
----                                state_val <= "11110";
----                                tready <= '1'; 
                                
----                            else    
                            
                               
--                                state <= st_Lbyte1;
--                                state_val <= "01000";                                
--                                tready <= '1';
--                                last_rx_time_code <= rx_time_code;   
--                                last_rx_packet_seq_cnt <= rx_packet_seq_cnt;                             
--                            else    -- block until we are good
--                                state <= st_ChkTc;
--                                state_val <= "00010";                                
--                                tready <= '0';  
                                                     
--                            end if;
                            
----                            if((last_oddEvenWriteSelect = oddEvenWriteSelect) and (oddEvenWriteSelect = '0')) then  -- odd pkt is missing
----                                switch_to_even <= '1';
----                                oddEvenReadSelect <= '0';
----                            elsif((last_oddEvenWriteSelect = oddEvenWriteSelect) and (oddEvenWriteSelect = '1')) then  -- even pkt is missing
----                                switch_to_even <= '0';
----                                oddEvenReadSelect <= '1';
----                            else
----                                switch_to_even <= '0';
----                                oddEvenReadSelect <= '0';
----                            end if;
--                        else -- block until we are good
--                            state <= st_ChkTc;
--                            state_val <= "00010";                                
--                            tready <= '0';       
                            
--                        end if;
                        
--                        if s_ch1_audio_payload_axis_tlast = '1' then
--                                bytecount := 0; 
--                               hdr_ready <= '1';    
--                               stream_pkt_start <= '1';
----                               startRead <= '0';
--                               first_pkt_wrt <= '0';
--                               last_rx_packet_seq_cnt <= rx_packet_seq_cnt;
--                               dpk_pkt_end <= '1'; 
--                               state <= st_idle; 
--                               state_val <= "00000";   
--                               tready <= '0';   
--                               bad_pkt_count <= bad_pkt_count + 1;
--                            end if;

----                   when st_ChkTc =>
----                       dpk_pkt_end <= '0';
----                       writeOddDACFifoEth <= '0';
----                       writeEvenDACFifoEth <= '0'; 
------                       replace_oe_pkt <= '0';    
----                       last_pkt_seq_count <= unsigned(rx_packet_seq_cnt);
----                       tready <= '0';
----                       stream_pkt_start <= '0';
----                       hdrbytecount <= (others => '0');
----                       bytecount := bytecount;
----                       if (((rx_time_code < last_rx_time_code) and ((last_rx_time_code - rx_time_code) < 100000000)) ) then
----                                    state <= st_DumpPkt; -- drop the packet
----                                    state_val <= "11110";
----                                    tready <= '1'; 
----                       elsif((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then
----                           if (play_out_en = '1') then 
----                                state <= st_Lbyte1;
----                                state_val <= "01000";                                
----                                tready <= '1';
----                                last_rx_time_code <= rx_time_code;                                
----    --                        elsif ((unsigned(buf_count_err) >= unsigned(payload_length)-1)) then
----    --                            state <= st_dumpPkt;
----    --                              buf_count_err_corr <= buf_count_err_corr + payload_length - 1;
----                            else    -- block until we are good
----                                state <= st_ChkTc;
----                                state_val <= "00010";                                
----                                tready <= '0';                            
----                            end if;
                            
------                            if((last_oddEvenSelect = oddEvenWriteSelect) and (oddEvenWriteSelect = '0')) then  -- odd pkt is missing
------                                switch_to_even <= '1';
------                                switch_to_odd <= '0';
------                            elsif((last_oddEvenSelect = oddEvenSelect) and (oddEvenSelect = '1')) then  -- even pkt is missing
------                                switch_to_even <= '0';
------                                switch_to_odd <= '1';
------                            else
------                                switch_to_even <= '0';
------                                switch_to_odd <= '0';
------                            end if;
                            
----                        end if;
                        
----                        if s_ch1_audio_payload_axis_tlast = '1' then
----                                bytecount := 0; 
----                               hdr_ready <= '1';    
----                               stream_pkt_start <= '1';
----                               startRead <= '0';
----                               first_pkt_wrt <= '0';
----                               dpk_pkt_end <= '1'; 
----                               state <= st_idle; 
----                               state_val <= "00000";   
----                               tready <= '0';   
                               
----                            end if;
                        
--                    when st_DumpPkt =>
--                            dpk_pkt_end <= '0';
--                            tready <= '1';
--                            resetErrCount <= '0';
--                            state <= st_DumpPkt;
--                            writeEvenDACFifoEth <= '0';
--                            writeOddDACFifoEth <= '0';
--                            stream_pkt_start <= '0';
--                            last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
--                            if s_ch1_audio_payload_axis_tvalid = '1' and s_ch1_audio_payload_axis_tlast = '1' then
--                                state <= st_idle;  
--                                state_val <= "00000";
--                               bytecount := 0; 
--                               hdr_ready <= '1';
--                               tready <= '0';
--                               dpk_pkt_end <= '1';
--                                --first_pkt_rdr <= '1';
--                               stream_pkt_start <= '1';  
--                               packet_dumped_cnt <= packet_dumped_cnt + 1;
--                            else
--                              state <= st_DumpPkt; 
--                            end if;
--                    --MSB first Odd/Even   
                 
----                  when st_GetNext =>
                  
----                  if((dacLeftOddFIFOFull='0' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '0' and oddEvenWriteSelect='0')) then
----                    state <= st_Lbyte1;
----                    state_val <= "01000";
----                    hdr_ready <= '1';
----                    tready <= '1';
----                  else
----                    state <= st_GetNext;
----                    hdr_ready <= '0';
----                    tready <= '0';
----                  end if;
                  
----                  writeEvenDACFifoEth <= '0';
----                  writeOddDACFifoEth <= '0';   
--                  when st_Lbyte1 =>
--                        dpk_pkt_end <= '0';
--                        tready <= '1';
--                        rxtc_fifo_write <= '0';
--                        hdr_ready <= hdr_ready; 
--                        writeEvenDACFifoEth <= '0';
--                        writeOddDACFifoEth <= '0';
--                        stream_pkt_start <= '0';
--                        last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
--                        if tvalid = '1' then
--                            leftOut24BitTmp(23 downto 16) <= tdata;
--                            state <= st_Lbyte2; 
--                            state_val <= "01001";
--                            bytecount := bytecount + 1;
                            
                            
                            
--                        end if;
                        
--                        if s_ch1_audio_payload_axis_tlast = '1' then
--                               bytecount := 0; 
--                               hdr_ready <= '1';    
--                               stream_pkt_start <= '1';
----                               startRead <= '0';
--                               first_pkt_wrt <= '0';
--                               dpk_pkt_end <= '1'; 
--                               state <= st_idle; 
--                               state_val <= "00000";  
--                               tready <= '0';  
--                               bad_pkt_count <= bad_pkt_count + 1;                                                 
--                            end if;
                        
                        
----                    when st_Lbyte2 =>
----                        dpk_pkt_end <= '0';
----                        tready <= '1';
----                        hdr_ready <= hdr_ready;
----                        writeEvenDACFifoEth <= '0';
----                        writeOddDACFifoEth <= '0';
----                        stream_pkt_start <= '0'; 
----                        if tvalid = '1' then
----                            leftOut24BitTmp(15 downto 8) <= tdata;
----                            state <= st_Lbyte3; 
----                            state_val <= "01010";
----                            bytecount := bytecount + 1;
                            
----                        end if;
                        
----                        if s_ch1_audio_payload_axis_tlast = '1' then
----                               bytecount := 0; 
----                               hdr_ready <= '1';    
----                               stream_pkt_start <= '1';
----                               startRead <= '0';
----                               first_pkt_wrt <= '0';
----                               dpk_pkt_end <= '1'; 
----                               state <= st_idle; 
----                               state_val <= "00000";  
----                               tready <= '0';                                                   
----                            end if;
                        
                        
--                    when st_Lbyte2 =>
--                        dpk_pkt_end <= '0';
--                        tready <= '1';
--                        hdr_ready <= hdr_ready; 
--                        writeEvenDACFifoEth <= '0';
--                        writeOddDACFifoEth <= '0';
--                        stream_pkt_start <= '0';
--                        if tvalid = '1' then
--                            leftOut24BitTmp(15 downto 8) <= tdata;
--                            state <= st_Rbyte1; 
--                            state_val <= "01011";
--                            bytecount := bytecount + 1; 
                                        
--                        end if;
--                        last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
--                        if s_ch1_audio_payload_axis_tlast = '1' then
--                               bytecount := 0; 
--                               hdr_ready <= '1';    
--                               stream_pkt_start <= '1';
----                               startRead <= '0';
--                               first_pkt_wrt <= '0';
--                               dpk_pkt_end <= '1'; 
--                               state <= st_idle; 
--                               state_val <= "00000";  
--                               tready <= '0';     
--                               bad_pkt_count <= bad_pkt_count + 1;                                              
--                            end if;
                        
                        
--                   when st_Rbyte1 =>
--                        dpk_pkt_end <= '0';
--                        tready <= '1';
--                        hdr_ready <= hdr_ready;  
--                        writeEvenDACFifoEth <= '0';
--                        writeOddDACFifoEth <= '0';
--                        stream_pkt_start <= '0';
--                        last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
--                        if tvalid = '1' then
--                            rightOut24BitTmp(23 downto 16) <= tdata;
--                            state <= st_Rbyte2; 
--                            state_val <= "01100";
--                            bytecount := bytecount + 1; 
                     
                                                       
--                        end if;
                        
                        
--                        if s_ch1_audio_payload_axis_tlast = '1' then
--                               bytecount := 0; 
--                               hdr_ready <= '1';    
--                               stream_pkt_start <= '1';
----                               startRead <= '0';
--                               first_pkt_wrt <= '0';
--                               dpk_pkt_end <= '1'; 
--                               state <= st_idle; 
--                               state_val <= "00000";  
--                               tready <= '0';   
--                               bad_pkt_count <= bad_pkt_count + 1;                                                
--                            end if;
                        
                        
----                    when st_Rbyte2 =>
----                        dpk_pkt_end <= '0';
----                        tready <= '1';
----                        hdr_ready <= hdr_ready;  
----                        writeEvenDACFifoEth <= '0';
----                        writeOddDACFifoEth <= '0';
----                        stream_pkt_start <= '0';
----                        if tvalid = '1' then
----                            rightOut24BitTmp(15 downto 8) <= tdata;
----                            state <= st_Rbyte3; 
----                            state_val <= "01101";
----                            bytecount := bytecount + 1;
                            
                            
----                        end if;
                        
                        
----                        if s_ch1_audio_payload_axis_tlast = '1' then
----                               bytecount := 0; 
----                               hdr_ready <= '1';    
----                               stream_pkt_start <= '1';
----                               startRead <= '0';
----                               first_pkt_wrt <= '0';
----                               dpk_pkt_end <= '1'; 
----                               state <= st_idle; 
----                               state_val <= "00000";  
----                               tready <= '0';                                                   
----                            end if;
                        
--                   when st_Rbyte2 =>
--                        dpk_pkt_end <= '0';
--                        tready <= '1';
--                        hdr_ready <= hdr_ready;
--                        writeEvenDACFifoEth <= '0';
--                        writeOddDACFifoEth <= '0';  
--                        stream_pkt_start <= '0';
--                        last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
--                        if tvalid = '1' then
--                            rightOut24BitTmp(15 downto 8) <= tdata;
--                            bytecount := bytecount + 1; 


----                                if(oddEvenWriteSelect = '0') then
----                                    writeEvenDACFifoEth <= '1';
----                                    writeOddDACFifoEth <= '0';
----                                else
----                                    writeOddDACFifoEth <= '1';
----                                     writeEvenDACFifoEth <= '0';
----                                end if;
----                                buf_count_err_corr <= buf_count_err_corr;
----                                fifo_writes <= fifo_writes + 1;
                            


--                                state <= st_WriteFifo; 
--                                state_val <= "01101";
--                                tready <= '0';
                                
--                          if s_ch1_audio_payload_axis_tlast = '1' then
--                               bytecount := 0; 
--                               hdr_ready <= '1';
--                               media_timer_reset <= '1';
--                               stream_pkt_start <= '1';
----                               first_pkt_rdr <= '1';
----                               startRead <= '1';
--                               first_pkt_wrt <= '0';
--                               dpk_pkt_end <= '1';
--                               --oddEvenWriteSelect <= oddEvenWriteSelect xor '1';  --toggle odd/even flag bad idea use sequence numbers
--    --                           if enablePacketCount_final = '1' then
--                                    packet_count_cnt <= packet_count_cnt + 1;
--    --                                if (packet_count_cnt_final >= (packet_count_mirror-1) ) then        
--    --                                    packet_count_cnt    <= (others => '0');
--    --                                end if;  
--    --                            end if;   
--                            end if;
                            
--                        end if;
                        
                        
----                        if packet_count_cnt >= x"0000_0002" then
--                            if packet_count_cnt >= x"0000_0002" then
--                                first_pkt_rdr <= '1';
--                            end if;




--                        if((left_odd_fifo_occ > playout_start_lim) or (left_even_fifo_occ > playout_start_lim)) then
--                            startRead <= '1';
--                        else
--                            startRead <= startRead;
                        
--                        end if;
                        
                        
--                   when st_WriteFifo =>
--                       tready <= '0';
--                       last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
--                       if((dacLeftOddFIFOFull='1' and oddEvenWriteSelect='1') or (dacLeftEvenFIFOFull = '1' and oddEvenWriteSelect='0')) then
--                           state <= st_WriteFifo; 
--                            state_val <= "01101";
--                            writeEvenDACFifoEth <= '0';
--                            writeOddDACFifoEth <= '0';
--                            fifo_writes <= fifo_writes;        
--                        else
--                            if(oddEvenWriteSelect = '0') then
--                                writeEvenDACFifoEth <= '1';
--                                writeOddDACFifoEth <= '0';
--                            else
--                                writeOddDACFifoEth <= '1';
--                                 writeEvenDACFifoEth <= '0';
--                            end if;
--    --                                buf_count_err_corr <= buf_count_err_corr;
--                            fifo_writes <= fifo_writes + 1;
                        
--    --                            end if;
    
--                            state <= st_idle; 
--                            state_val <= "00000";                    
                        
                            
--                        end if;     
                        
                        
                        
                        
                   
--                   when st_Lock =>   
--                        last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
--                        if tlast = '1' and tvalid = '1' then   
--                           --if axis_tlast_pulse = '1' then                         
--                            lock_pkts_count <= lock_pkts_count + 1;  
--                            media_timer_reset <= '1';                         
--                        else                        
--                            lock_pkts_count <= lock_pkts_count;
--                        end if;
                        
--                        if lock_pkts_count >= lock_pkts_limit then
--                            state <= st_idle; 
--                            state_val <= "00000";
--                            lock_pkts_count <= (others => '0');
--                            tready <= '0';
--                        else                        
--                             state_val <= "11111";
--                            state <= st_Lock; 
--                            tready <= '1';
--                            rx_time_code_1  <= (others => '0');
--                            rx_time_code_2  <= (others => '0');
--                            rx_time_code_3  <= (others => '0');
--                            rx_time_code_4 <= (others => '0');
----                            rx_time_code <= (others => '0');
--                        end if;     
                        
                       
--                   when others =>
--                        writeEvenDACFifoEth <= '0';
--                        writeOddDACFifoEth <= '0';
--                        state <= st_Lock;
--                        lock_pkts_count <= (others => '0');
--                        hdr_ready <= '0';
--                        media_timer_reset <= '0';
--                        dpk_pkt_end <= '0';
--                        tready <= '0';  
--                        rxtc_fifo_write <= '0';  
--                        startRead <= '0';
--                        stream_pkt_start <= '1';
--                        last_rx_packet_seq_cnt <= last_rx_packet_seq_cnt;
----                        oddEvenWriteSelect <= '0';
----                        last_oddEvenWriteSelect <= '1';
----                        oddEvenReadSelect <= '0'; 
----                        switch_to_even <= '0';
--                end case;
                
                
                
                
                
--                if resetPktCount = '1' then
--                    packet_count_cnt <= (others => '0');
--                end if;
                               
--                if (resetOddDACFifo ='1' or resetEvenDACFifo  ='1') then
--                    state <= st_Lock;  
--                    lock_pkts_count <= (others => '0');
--                    bytecount := 0;
--                    hdrbytecount <= (others => '0');
--                    startRead <= '0';
----                    oddEvenWriteSelect <= '0';
----                    last_oddEvenWriteSelect <= '1';
----                    oddEvenReadSelect <= '0'; 
----                    switch_to_even <= '0';
--                    media_timer_reset <= '0';
--                    --lockRead <= '1';
--                    hdr_ready <= '0';
--                    dpk_pkt_end <= '0';
--                    first_pkt_wrt <= '1';
--                    stream_pkt_start <= '1';
--                    writeEvenDACFifoEth <= '0';
--                    writeOddDACFifoEth <= '0';
--                    rxtc_fifo_write <= '0';  
--                    first_pkt_rdr <= '0';
--                    tready <= '0';
----                    oddEvenWriteSelect <= '0';
--                    resetErrCount <= '0';
--                    rx_time_code_1  <= (others => '0');
--                    rx_time_code_2  <= (others => '0');
--                    rx_time_code_3  <= (others => '0');
--                    rx_time_code_4 <= (others => '0');
                    
----                    rx_time_code <= (others => '0');
                    
--                    last_rx_time_code <= (others => '0');
----                    buf_count_err_corr <= (others => '0');
--                    fifo_writes <= (others => '0');
----                    rx_time_code_out <= (others => '0');
                    
----                    rx_packet_seq_cnt_out  <= (others => '0');
----                    rx_packet_seq_cnt_1  <= (others => '0');
----                    rx_packet_seq_cnt_2 <= (others => '0');
----                    buf_count_cnt <= (others => '0');
--                end if;
                
                
--                 if (tc_sync_en = '0') then
--                    rx_time_code_1  <= (others => '0');
--                    rx_time_code_2  <= (others => '0');
--                    rx_time_code_3  <= (others => '0');
--                    rx_time_code_4 <= (others => '0');
----                    rx_time_code <= (others => '0');
--                    last_rx_time_code <= (others => '0');
----                    buf_count_err_corr <= (others => '0');
                        
--                end if;
                
     
        
        
       
--    end if; -- reset
            
--end process;






--newsample_div2: process(newsample_in)
--begin
--  if(rising_edge(newsample_in)) then
--    newsample_in_div2   <= not newsample_in_div2;
  
--  end if;
--end process newsample_div2;


---- This syncronises the newsample_in signal to the axis 125MHz clock
--newsample_div2_delay: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1'  then
--        newsample_div2_reg <= '0';        
--    elsif rising_edge (CLK_125) then
--        newsample_div2_reg <= newsample_in_div2;
--        dpk_pkt_end_dly <= dpk_pkt_end;
--    end if;
--end process;

--newsample_div2_125 <= (newsample_in_div2 xor newsample_div2_reg) when (newsample_in_div2 = '1') else '0';

---- This syncronises the newsample_in signal to the axis 125MHz clock
--newsample_delay: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'   or resetFifos = '1' then
--        newsample_reg <= '0';        
--    elsif rising_edge (CLK_125) then
--        newsample_reg <= newsample_in;
--    end if;
--end process;

--newsample_125 <= (newsample_in xor newsample_reg) when (newsample_in = '1') else '0';
--newsample_125n <= (newsample_in xor newsample_reg) when (newsample_in = '0') else '0';
--newsample_mul2_125 <= newsample_125 or newsample_125n;
----newsample_change <= newsample_in; 


----clk_bufg_inst :  BUFG
----port map (
----    I => (newsample_in),
------    I => (tc_sync_in),
----    O => (tc_sync_int)
    
----);
--tc_sync_int <= newsample_in;


--tc_sync_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  then
--        tc_sync_reg <= '0';        
--    elsif rising_edge (CLK_125) then
--        tc_sync_reg <= tc_sync_int;
--    end if;
--end process;

--tc_sync_125 <= (tc_sync_int xor tc_sync_reg) when (tc_sync_int='1') else '0';


--tlast_pulse_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1' then
--        axis_tlast_reg <= '0';        
--    elsif rising_edge (CLK_125) then
--        axis_tlast_reg <=  s_ch1_audio_payload_axis_tlast;
--    end if;
--end process;

--axis_tlast_pulse <=  (axis_tlast_reg xor s_ch1_audio_payload_axis_tlast)  when  s_ch1_audio_payload_axis_tlast = '1' else '0';

--sync_time_code <= unsigned(sync_time_code_in);
----sync_time_code_out <= sync_time_code;
----rx_time_code_eff <= rx_time_code when (first_pkt_wrt = '1') else rx_time_code_fout;
----rx_time_code_eff <= rx_time_code_fout;
--rx_time_code_eff <= rx_time_code;



--media_timer_count_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1' then
--        --sync_time_code <= (others=>'0');   bad idea   
--        media_timer_count <= (others=>'0'); 
----        media_channel_dropped <= '0';
--    elsif rising_edge (CLK_125) then
--        if ((tc_sync_125 = '1') and (media_timer_en = '1') and (media_timer_reset = '0') and (media_channel_dropped = '0')) then
--            media_timer_count <= media_timer_count + 1;   
--        elsif(media_timer_reset = '1') then
--            media_timer_count <= (others=>'0'); 
--        else 
--            media_timer_count <= media_timer_count;   
--        end if;  
        
        
        
        
----        if((media_timer_count >= media_timer_limit) and (media_timer_en = '1') and (media_timer_reset = '0')) then
----            media_channel_dropped <= '1';
----        else
----            media_channel_dropped <= '0';
----        end if;  
        
        
----        rx_time_code_eff <= rx_time_code; 
----        sync_time_code <= unsigned(sync_time_code_in);   
    
--    end if;
--end process;

--media_channel_dropped <= '1' when ((media_timer_count >= media_timer_limit) and (media_timer_en = '1') and (media_timer_reset = '0')) else '0';

--sr_count_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos, replace_inprogress_in, newsample_125, writeEvenDACFifoEth, writeOddDACFifoEth, replace_timeout)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1' then
--        sr_count <= (others=>'0');    
--    elsif rising_edge (CLK_125) then        
            
--            if((writeEvenDACFifoEth = '1') or (writeOddDACFifoEth = '1')) then
--                 sr_count <= (others=>'0');
--            elsif(replace_inprogress_in = '1' and newsample_125 = '1' and replace_timeout = '0') then
--                sr_count <= sr_count + 1;
--            else 
--                sr_count <= sr_count;
--            end if;
            
----            if(oddEvenWriteSelect= '1') then
----                next_play_out_time <= (unsigned(payload_length) + play_out_time - e_slot_skip_count);
----            else 
----                next_play_out_time <= (play_out_time + o_slot_skip_count);
----            end if;
            
            
----            if((left_odd_fifo_occ < (fifo_occ_lim+4)) and (left_even_fifo_occ < (fifo_occ_lim+4)) and (first_pkt_rdr = '1') and (startRead = '1') and (replace_pkt_raw = '0')) then
            
----            if((left_odd_fifo_occ < (fifo_occ_lim+2)) and (left_even_fifo_occ < (fifo_occ_lim+2)) and (startRead = '1') and (replace_pkt_raw = '0')) then
--            if((left_odd_fifo_occ < 8) and (left_even_fifo_occ < 8) and (startRead = '1')) then
--                just_b4_replacing <= '1';
--            else
--                just_b4_replacing <= '0';
--            end if;    
               
            
            
            
            
    
--    end if;
--end process;

--replace_timeout <= '0' when sr_count < sr_count_final else '1';


--replace_in_progress_pulse_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1'  then
--        replace_inprogress_in_reg <= '0';      
--    elsif rising_edge (CLK_125) then
--        replace_inprogress_in_reg <=  replace_pkt_raw;
--    end if;
--end process;


--replace_inprogress_in_pos <=  (replace_inprogress_in_reg xor replace_pkt_raw) when  (replace_pkt_raw = '1') else '0';
--replace_inprogress_in_neg <=  (replace_inprogress_in_reg xor replace_pkt_raw) when  (replace_pkt_raw = '0') else '0';


--replace_inprogress_sig_pulse_process: process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1'  then
--        replace_inprogress_sig_reg <= '0';      
--    elsif rising_edge (CLK_125) then
--        replace_inprogress_sig_reg <=  replace_inprogress_sig;
--    end if;
--end process;

--replace_inprogress_sig_pos <=  (replace_inprogress_sig_reg xor replace_inprogress_sig) when  (replace_inprogress_sig = '1') else '0';
--replace_inprogress_sig_neg <=  (replace_inprogress_sig_reg xor replace_inprogress_sig) when  (replace_inprogress_sig = '0') else '0';



--timing_offset <= ((unsigned(rx_time_code_eff) - sync_time_code)) when unsigned(rx_time_code_eff) > sync_time_code else (others=>'0');
--play_out_time <= (unsigned(rx_time_code) + unsigned(play_out_delay)) when (tc_sync_en = '1') else (others=>'0');

----next_play_out_time <= (unsigned(payload_length) + play_out_time) when oddEvenWriteSelect= '1' else (play_out_time + 8);
--play_out_delay_out <= std_logic_vector(play_out_delay);
--current_sync_time_out   <= std_logic_vector(sync_time_code);

----skip_slot_out <= '1' when ((sync_time_code >= next_play_out_time) or (just_b4_replacing = '1')) else '0';
--skip_slot_out <= just_b4_replacing;
----skip_slot_out <= '0';

--next_play_out_time_out <= std_logic_vector(next_play_out_time);
--allow_packet <= '1' when (((last_rx_packet_seq_cnt + 1 = rx_packet_seq_cnt) and (last_rx_packet_seq_cnt(0) = '0')) or ((last_rx_packet_seq_cnt + 2 = rx_packet_seq_cnt) and (last_rx_packet_seq_cnt(0) = '1'))) else '0';
----allow_packet <= '1' when ((last_rx_packet_seq_cnt + 1 = rx_packet_seq_cnt) and (last_rx_packet_seq_cnt(0) = '0')) else '0';

----allow_packet_odd <= '1' when ((last_rx_packet_seq_cnt + 1 = rx_packet_seq_cnt) and (last_rx_packet_seq_cnt(0) = '0')) else '0';
--allow_packet_odd <= '1' when ((last_rx_packet_seq_cnt + 1 = rx_packet_seq_cnt) and (oddEvenWriteSelect = '1')) else '0';
----allow_packet <= '1' when (last_rx_packet_seq_cnt + 2 = rx_packet_seq_cnt) else '0';
----play_out_en <= '1' when (sync_time_code >= play_out_time) or (replace_inprogress_in = '1') else '0';
----play_out_en <= '1' when ((state_val /= "11111") and ((sync_time_code >= play_out_time) or (tc_sync_en = '0'))) else '0';
----play_out_en <= '1' when (((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (sync_time_code_roll_over = '1'))) else '0';
----play_out_en <= '1' when (((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (just_b4_replacing = '1' and oddEvenWriteSelect = '1'))) else '0';
----play_out_en <= '1' when (((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (just_b4_replacing = '1'))) else '0';
----play_out_en <= '1' when (((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (just_b4_replacing = '1' and allow_packet = '1'))) else '0';

----play_out_en <= '1' when ((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (just_b4_replacing = '1' and allow_packet = '1') or (allow_packet_odd = '1')) else '0';

----play_out_en <= '1' when ((sync_time_code >= play_out_time) or (tc_sync_en = '0') or (just_b4_replacing = '1') or (allow_packet_odd = '1')) else '0';
--play_out_en <= '1' when ((sync_time_code >= play_out_time) or ((sync_time_code >= play_out_time - 8) and (just_b4_replacing = '1'))) else '0';


----play_out_en <= '0' when ((sync_time_code < play_out_time) and (tc_sync_en = '1')) else '1';

--play_out_ready_out <= play_out_en;
----dac_fifo_read <= play_out_en; -- now only used to control the axis bus only

----pkt_too_late <=  '0' when ((sync_time_code >= play_out_time+late_allowance) and (just_b4_replacing = '0')) else '0';
--pkt_too_late <=  '0' when (sync_time_code >= play_out_time+4) else '0';



--test_pattern_gen : process(CLK_125, s_ch1_audio_payload_axis_aresetn, resetFifos)                                                                        
--  begin   
--    if s_ch1_audio_payload_axis_aresetn = '0'   or resetFifos = '1' then
----        adcLeftData <= (others => '0'); 
----        adcRightData <= (others => '0'); 
--        leftTest24Bit <= (others => '0');
--        rightTest24Bit <= (others => '0');
--        testWaveTimer <= (others => '0');
        
--    elsif (rising_edge (CLK_125)) then  
----            newsample_125 <= newsample_change; --one reg delay to avoid quick read 
--                testWaveTimer <= testWaveTimer+1;
--                 if (testWaveTimer = TEST_PULSE_WIDTH) then 
--                    testWaveTimer <= (others => '0');
--                    testWave24Bit(23) <= testWave24Bit(23) xor '1';
--                end if;

--                if (newsample_125 = '1') then
                       
--                    case (test_sig_sel) is
--                        when "1000" =>  
--                            leftTest24Bit  <= leftTest24Bit +1;
--                            rightTest24Bit <= rightTest24Bit +1;
--                        when "1001" => 
--                            leftTest24Bit  <= X"555555";
--                            rightTest24Bit <= X"555555";                                
--                        when "1010" =>  
--                            leftTest24Bit  <= X"000000";
--                            rightTest24Bit <= X"FFFFFF";    
--                        when "1011" =>       
--                            leftTest24Bit <= not leftTest24Bit;
--                            rightTest24Bit <= not rightTest24Bit;  
--                        when "1100" =>  
                           
--                            leftTest24Bit  <= unsigned(testWave24Bit);     --b"0000_0000_0000_0000";  
--                            rightTest24Bit <= unsigned(testWave24Bit); --b"0000_0000_0000_0000";
--                        when others =>
--                            leftTest24Bit <= leftTest24Bit;
--                            rightTest24Bit <= rightTest24Bit;
--                        end case;
                 
--                end if; 
                
--        end if; 
        
--        if (resetOddDACFifo ='1' or resetEvenDACFifo  ='1') then
--            leftTest24Bit <= (others => '0');
--            rightTest24Bit <= (others => '0');
--      end if;
                                                                            
--  end process test_pattern_gen; 
  
  
--  testLeftData <= std_logic_vector(leftTest24Bit);
--  testRightData <= std_logic_vector(rightTest24Bit);
----  adcLeftData <= line_in_l_in;
----  adcRightData <= line_in_r_in;
--  test_mode_final <= test_mode; 
  
----  leftOut24Bit <= dacOddFIFOData when (test_mode_final = '0') else testLeftData;
----  rightOut24Bit <=  dacEvenFIFOData when (test_mode_final = '0') else testRightData;
  
 





--cic_interpolator_odd_left: cic_filter
--    generic map(
--        SIG_IN_WIDTH => CIC_SIG_IN_WIDTH,
--        SIG_OUT_WIDTH => CIC_SIG_OUT_WIDTH
--    )
--    port map(
--        clk  => newsample_125,
--        rst => resetFifos,
--        x   => signed(dacLeftOddFIFOData),
--        dvi => '1',--newsample_in_div2, --read_Odd_FIFOClk, --'1', --dac_ofifo_read,
--        y => leftOddIntOut24Bit_cic,
--        dvo => open
--    );



--comp_interpolator_odd_left: compfilt
--generic map (
--        SIG_IN_WIDTH => CIC_SIG_OUT_WIDTH,
--        SIG_OUT_WIDTH => COMP_SIG_OUT_WIDTH
--    )
--    port map(
--        clk  => newsample_125,
--        rst => resetFifos,
--        x => leftOddIntOut24Bit_cic,
--        xdv => '1',
--        y => leftOddIntOut24Bit_tmp,
--        ydv => open
--    );

----leftOddIntOut24Bit <= leftOddIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto CIC_SIG_OUT_WIDTH-CIC_SIG_IN_WIDTH);
----leftOddIntOut24Bit <= leftOddIntOut24Bit_tmp(27 downto 4);
--leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 2) , leftOddIntOut24Bit ' length ) ; --good
----leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 1) , leftOddIntOut24Bit ' length ) ; --good
----leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_cic , leftOddIntOut24Bit ' length ) ; saturates
----leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto 2) , leftOddIntOut24Bit ' length ) ;
----leftOddIntOut24Bit <= resize ( leftOddIntOut24Bit_tmp , leftOddIntOut24Bit ' length ) ;


--cic_interpolator_even_left: cic_filter
--    generic map(
--        SIG_IN_WIDTH => CIC_SIG_IN_WIDTH,
--        SIG_OUT_WIDTH => CIC_SIG_OUT_WIDTH
--    )
--    port map(
--        clk  => newsample_125,
--        rst => resetFifos,
--        x   => signed(dacLeftEvenFIFOData),
--        dvi => '1',--newsample_in_div2, --read_Even_FIFOClk, --'1', --dac_efifo_read,
--        y => leftEvenIntOut24Bit_cic,
--        dvo => open
--    );



--comp_interpolator_even_left: compfilt
--generic map (
--        SIG_IN_WIDTH => CIC_SIG_OUT_WIDTH,
--        SIG_OUT_WIDTH => COMP_SIG_OUT_WIDTH
--    )
--    port map(
--        clk  => newsample_125,
--        rst => resetFifos,
--        x => leftEvenIntOut24Bit_cic,
--        xdv => '1',
--        y => leftEvenIntOut24Bit_tmp,
--        ydv => open
--    );  
    
----    leftEvenIntOut24Bit <= leftEvenIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto CIC_SIG_OUT_WIDTH-CIC_SIG_IN_WIDTH);
----    leftEvenIntOut24Bit <= leftEvenIntOut24Bit_tmp(27 downto 4);
----    leftEvenIntOut24Bit <= resize ( leftEvenIntOut24Bit_cic , leftEvenIntOut24Bit ' length ) ; saturates
--leftEvenIntOut24Bit <= resize ( leftEvenIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 2) , leftEvenIntOut24Bit ' length ) ; --good
----leftEvenIntOut24Bit <= resize ( leftEvenIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 1) , leftEvenIntOut24Bit ' length ) ; --good
----leftEvenIntOut24Bit <= resize ( leftEvenIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto 2) , leftEvenIntOut24Bit ' length ) ;    
----    leftEvenIntOut24Bit <= resize ( leftEvenIntOut24Bit_tmp , leftEvenIntOut24Bit ' length ) ;

  
--cic_interpolator_odd_right: cic_filter
--    generic map(
--        SIG_IN_WIDTH => CIC_SIG_IN_WIDTH,
--        SIG_OUT_WIDTH => CIC_SIG_OUT_WIDTH
--    )
--    port map(
--        clk  => newsample_125,
--        rst => resetFifos,
--        x   => signed(dacRightOddFIFOData),
--        dvi => '1',--newsample_in_div2, --read_Odd_FIFOClk, -- '1', --dac_ofifo_read,
--        y => rightOddIntOut24Bit_cic,
--        dvo => open
--    );



--comp_interpolator_odd_right: compfilt
--generic map (
--        SIG_IN_WIDTH => CIC_SIG_OUT_WIDTH,
--        SIG_OUT_WIDTH => COMP_SIG_OUT_WIDTH
--    )
--    port map(
--        clk  => newsample_125,
--        rst => resetFifos,
--        x => rightOddIntOut24Bit_cic,
--        xdv => '1',
--        y => rightOddIntOut24Bit_tmp,
--        ydv => open
--    );
----rightOddIntOut24Bit <= rightOddIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto CIC_SIG_OUT_WIDTH-CIC_SIG_IN_WIDTH);
----rightOddIntOut24Bit <= rightOddIntOut24Bit_tmp(27 downto 4);
--rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 2) , rightOddIntOut24Bit ' length ) ;--good
----rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 1) , rightOddIntOut24Bit ' length ) ; --good
----rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_cic , rightOddIntOut24Bit ' length ) ;--saturates
----rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto 2) , rightOddIntOut24Bit ' length ) ;
----rightOddIntOut24Bit <= resize ( rightOddIntOut24Bit_tmp , rightOddIntOut24Bit ' length ) ;

--cic_interpolator_even_right: cic_filter
--    generic map(
--        SIG_IN_WIDTH => CIC_SIG_IN_WIDTH,
--        SIG_OUT_WIDTH => CIC_SIG_OUT_WIDTH
--    )
--    port map(
--        clk  => newsample_125,
--        rst => resetFifos,
--        x   => signed(dacRightEvenFIFOData),
--        dvi => '1',--newsample_in_div2, --read_Even_FIFOClk, --'1', --dac_efifo_read,
--        y => rightEvenIntOut24Bit_cic,
--        dvo => open
--    );



--comp_interpolator_even_right: compfilt
--generic map (
--        SIG_IN_WIDTH => CIC_SIG_OUT_WIDTH,
--        SIG_OUT_WIDTH => COMP_SIG_OUT_WIDTH
--    )
--    port map(
--        clk  => newsample_125,
--        rst => resetFifos,
--        x => rightEvenIntOut24Bit_cic,
--        xdv => '1',
--        y => rightEvenIntOut24Bit_tmp,
--        ydv => open
--    );    
    
----  rightEvenIntOut24Bit <= rightEvenIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto CIC_SIG_OUT_WIDTH-CIC_SIG_IN_WIDTH);
----  rightEvenIntOut24Bit <= rightEvenIntOut24Bit_tmp(27 downto 4);
----  rightEvenIntOut24Bit <= resize ( rightEvenIntOut24Bit_cic , rightEvenIntOut24Bit ' length ) ;--saturates
--  rightEvenIntOut24Bit <= resize ( rightEvenIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 2) , rightEvenIntOut24Bit ' length ) ;--good
----  rightEvenIntOut24Bit <= resize ( rightEvenIntOut24Bit_tmp(COMP_SIG_OUT_WIDTH-1 downto 1) , rightEvenIntOut24Bit ' length ) ;--good
---- rightEvenIntOut24Bit <= resize ( rightEvenIntOut24Bit_cic(CIC_SIG_OUT_WIDTH-1 downto 2) , rightEvenIntOut24Bit ' length ) ;
----  rightEvenIntOut24Bit <= resize ( rightEvenIntOut24Bit_tmp , rightEvenIntOut24Bit ' length );
  
----  leftOut24Bit <=  leftOddOut24Bit when (oddEvenReadSelect = '0') else leftEvenOut24Bit;
----  rightOut24Bit <=  rightOddOut24Bit when (oddEvenReadSelect = '0') else rightEvenOut24Bit;

----leftOut24Bit <=  leftOddOut24Bit when (oddEvenReadSelect = '0' and intpOdd = '0') else leftEvenOut24Bit when (oddEvenReadSelect = '1' and intpEven = '0') else leftOddIntOut24Bit when (intpOdd = '1') else leftEvenIntOut24Bit when (intpEven = '1');
----rightOut24Bit <=  rightOddOut24Bit when (oddEvenReadSelect = '0' and intpOdd = '0') else rightEvenOut24Bit when (oddEvenReadSelect = '1' and intpEven = '0') else rightOddIntOut24Bit when (intpOdd = '1') else rightEvenIntOut24Bit when (intpEven = '1');

----leftOut24Bit  <=  leftOddIntOut24Bit  when (intpOdd = '1' and lockRead = '0') else leftEvenIntOut24Bit  when (intpEven = '1' and lockRead = '0') else dacLeftOddFIFOData  when (oddEvenReadSelect = '0' and intpOdd = '0' and intpEven = '0' and lockRead = '0' and (dacLeftOddFIFOEmpty = '0')) else dacLeftEvenFIFOData  when (oddEvenReadSelect = '1' and intpEven = '0' and intpOdd = '0' and lockRead = '0' and (dacLeftEvenFIFOEmpty = '0')) else leftOut24Bit;
----rightOut24Bit <=  rightOddIntOut24Bit when (intpOdd = '1' and lockRead = '0') else rightEvenIntOut24Bit when (intpEven = '1' and lockRead = '0') else dacRightOddFIFOData when (oddEvenReadSelect = '0' and intpOdd = '0' and intpEven = '0' and lockRead = '0' and (dacRightOddFIFOEmpty = '0')) else dacRightEvenFIFOData when (oddEvenReadSelect = '1' and intpEven = '0' and intpOdd = '0' and lockRead = '0' and (dacRightEvenFIFOEmpty = '0')) else rightOut24Bit;

----leftOut24Bit  <=  std_logic_vector(leftOddIntOut24Bit)  when (intpOdd = '1') else std_logic_vector(leftEvenIntOut24Bit) when (intpEven = '1') else leftOut24Bit;
----rightOut24Bit <=  std_logic_vector(rightOddIntOut24Bit) when (intpOdd = '1') else std_logic_vector(rightEvenIntOut24Bit) when (intpEven = '1') else rightOut24Bit;


----leftOut24Bit  <=  std_logic_vector(leftOddIntOut24Bit)  when (intpOdd = '1'and intpEven = '0') else std_logic_vector(leftEvenIntOut24Bit) when (intpEven = '1' and intpOdd = '0') else std_logic_vector(leftOddIntOut24Bit);
----rightOut24Bit <=  std_logic_vector(rightOddIntOut24Bit) when (intpOdd = '1'and intpEven = '0') else std_logic_vector(rightEvenIntOut24Bit) when (intpEven = '1' and intpOdd = '0') else std_logic_vector(rightOddIntOut24Bit);


--leftOut24Bit  <=  std_logic_vector(leftOddIntOut24Bit)  when (oddEvenReadSelect = '1') else std_logic_vector(leftEvenIntOut24Bit);
--rightOut24Bit <=  std_logic_vector(rightOddIntOut24Bit) when (oddEvenReadSelect = '1') else std_logic_vector(rightEvenIntOut24Bit);


----leftOut24Bit  <=  std_logic_vector(leftOddIntOut24Bit);
----rightOut24Bit <=  std_logic_vector(rightOddIntOut24Bit);

----plc_pkt_end_right <= PktEnd_FIFO_RightEven when (oddEvenReadSelect = '0') else PktEnd_FIFO_RightOdd;
----plc_pkt_end_left <= PktEnd_FIFO_LeftEven when (oddEvenReadSelect = '0') else PktEnd_FIFO_LeftOdd;




----intpOdd <= '1' when ((dacLeftEvenFIFOEmpty = '1') and (dacLeftOddFIFOEmpty = '0'))  else '0'; 
----intpEven <= '1' when ((dacLeftEvenFIFOEmpty = '0') and (dacLeftOddFIFOEmpty = '1'))  else '0';   
--intpOdd <= '1' when (dacLeftOddFIFOEmpty = '0')  else '0'; 
--intpEven <= '1' when (dacLeftEvenFIFOEmpty = '0')  else '0'; 

----oddEvenReadSelect <= '1' when ((left_odd_fifo_occ > left_even_fifo_occ) and (left_even_fifo_occ < 6)) else '0' when ((left_odd_fifo_occ < left_even_fifo_occ) and (left_odd_fifo_occ < 6)) else oddEvenReadSelect;


--out_oe_selct_process: process(newsample_125, s_ch1_audio_payload_axis_aresetn, resetFifos)
--begin
--    if s_ch1_audio_payload_axis_aresetn = '0' or resetFifos = '1' then
--        oddEvenReadSelect <= '0';  
        
----        dac_efifo_read <= '0'; 
----        dac_ofifo_read <= '0';  

----        replace_pkt_raw_d <= '0';
--    elsif rising_edge (newsample_125) then   
     

--        if ((left_odd_fifo_occ > left_even_fifo_occ) and (left_even_fifo_occ < 6 and left_odd_fifo_occ > 6 ) ) then
--                oddEvenReadSelect <= '1' ;
--        elsif ((left_even_fifo_occ > left_odd_fifo_occ) and (left_odd_fifo_occ < 6 and left_even_fifo_occ > 6)) then
--            oddEvenReadSelect <= '0' ;
--        else         
--            oddEvenReadSelect <= oddEvenReadSelect;
--        end if;
        
        
----        if (dacLeftEvenFIFOEmpty = '0' and startRead = '1' and (replace_pkt_raw = '0' or replace_pkt_rel = '1' or replace_pkt_exit = '1')) then
----            dac_efifo_read <= '1';
----        else 
----            dac_efifo_read <= '0'; 
----        end if;
        
----        if(dacLeftOddFIFOEmpty = '0'and startRead = '1'  and (replace_pkt_raw = '0' or replace_pkt_rel = '1' or replace_pkt_exit = '1')) then
----            dac_ofifo_read <= '1';
----        else 
----            dac_ofifo_read <= '0'; 
----        end if;
        
        

        
----        replace_pkt_raw_d <= replace_pkt_raw;
        
        
        
        
        
--    end if;
--end process;


--dac_ofifo_read <= '1' when (dacLeftOddFIFOEmpty = '0'and startRead = '1'  and (replace_pkt_raw = '0' or replace_pkt_rel = '1' or replace_pkt_exit = '1')) else '0';
--dac_efifo_read <= '1' when (dacLeftEvenFIFOEmpty = '0'and startRead = '1'  and (replace_pkt_raw = '0' or replace_pkt_rel = '1' or replace_pkt_exit = '1')) else '0';




--plc_controller: process(newsample_125,s_ch1_audio_payload_axis_aresetn, resetOddDACFifo, resetEvenDACFifo) is      
        
--    begin
    
--        if (s_ch1_audio_payload_axis_aresetn = '0' or (resetOddDACFifo ='1' or resetEvenDACFifo  ='1')) then
--                replace_pkt_trig <= '0';
--                replace_pkt_raw <= '0';  
--                replace_pkt_rel <= '0';
--                replace_pkt_exit <= '0';
--                replace_pkt_entry <= '0';
--                replace_pkt_set <= '0'; 
--                entry_counter <= (others => '0');
--                replace_events <= (others => '0');
--                exit_counter <= (others => '0');
--                rel_counter <= (others => '0');
--                sampleCounter <= (others => '0');
--                last_left_plc_value <= (others => '0');
--                last_right_plc_value <= (others => '0');
--                 plc_state <= idle;
--        elsif rising_edge(newsample_125) then
            
--          case plc_state is
--             when idle =>      
--                exit_counter <= (others => '0');
--                entry_counter <= (others => '0');
--                rel_counter <= (others => '0'); 
--                replace_pkt_rel <= '0'; 
--                replace_pkt_trig <= '0';   
--                replace_pkt_exit <= '0';  
--                replace_pkt_entry <= '0';
--                replace_pkt_raw <= '0';
--                replace_pkt_set <= '0';    

----                if ((left_odd_fifo_occ < fifo_occ_lim+1) and (left_even_fifo_occ < fifo_occ_lim+1) and (startRead = '1')) then
--                if ((left_odd_fifo_occ < 1) and (left_even_fifo_occ < 1) and (startRead = '1')) then
--                    replace_pkt_set <= '1';-- when  
--                end  if;
                
                
                   
--                if ((left_odd_fifo_occ < 2) and (left_even_fifo_occ < 2) and (startRead = '1')) then
----                if ((dacLeftOddFIFOEmpty = '1') and (dacLeftEvenFIFOEmpty = '1') and (startRead = '1')) then
--                    replace_pkt_trig <= '1';-- when  
--                    replace_events <= replace_events + 1;
----                    if(ENTRY_FADE_LENGTH > 2) then
----                        replace_pkt_entry <= '1';    
----                        plc_state <= fade_entry;
----                    else
--                        replace_pkt_raw <= '1';
--                        replace_pkt_entry <= '0';  
--                        replace_pkt_set <= '0';    
--                        plc_state <= replace;
----                    end if;
--                else
--                    plc_state <= idle;
--                    replace_events <= replace_events;
--                end  if;
            
--                if(startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter <= SIM_PKT_SIZE)) then
--                    sampleCounter <= sampleCounter + 1;
--        --            pkt_end_sim <= '0';
--                else
--                    sampleCounter <= (others => '0'); 
--        --            pkt_end_sim <= '1';       
--                end if;
                
                
----                if(startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter >= SIM_PKT_SIZE)) then
----                    pkt_end_sim <= '1';
----                else
----                    pkt_end_sim <= '0';       
----                end if;
                
                
                
               
        
        
--    --        if((replace_pkt_raw = '1') or (replace_pkt_rel = '1') or (replace_pkt_trig = '1') or (replace_pkt_exit = '0')) then
----            if(replace_pkt_exit = '0') then
--                last_left_plc_value <= dacLeftLIFOData;
--                last_right_plc_value <= dacRightLIFOData;
----            end if;
--                when fade_entry =>     -- use entry to empty filter   
--                   entry_counter <= entry_counter + 1;
--                   replace_pkt_raw <= '0';
--                   replace_pkt_rel <= '0';
--                   replace_pkt_set <= '0'; 
                   
--                   if(entry_counter = ENTRY_FADE_LENGTH - 1) then  
--                        replace_pkt_set <= '1';-- when  
--                    end  if;
                   
--                   if(entry_counter >= ENTRY_FADE_LENGTH) then                        
--                       replace_pkt_entry <= '0';
--                       replace_pkt_raw <= '1';
                       
--                        plc_state <= replace;  
--                        replace_events <= replace_events + 1;        
--                    else
--                        replace_pkt_entry <= '1'; 
--                        plc_state <= fade_entry;
--                    end if;
--                    last_left_plc_value <= dacLeftLIFOData;
--                    last_right_plc_value <= dacRightLIFOData;
                    
--                    if ((left_odd_fifo_occ > (fifo_occ_lim + 24)) or (left_even_fifo_occ > (fifo_occ_lim + 24))) then
--                        replace_pkt_entry <= '0';
--                        replace_pkt_raw <= '0';
--                           replace_pkt_rel <= '0';
--                           replace_pkt_set <= '0';
--                        plc_state <= idle;          
--                    end if;
                    
                    
--                    if(startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter <= SIM_PKT_SIZE)) then
--                        sampleCounter <= sampleCounter + 1;
--            --            pkt_end_sim <= '0';
--                    else
--                        sampleCounter <= (others => '0'); 
--            --            pkt_end_sim <= '1';       
--                    end if;
                    
--                when replace=>
--                    entry_counter <= (others => '0');
--                    exit_counter <= (others => '0');
--                    rel_counter <= (others => '0'); 
--                    sampleCounter <= (others => '0');
--                    replace_pkt_set <= '0'; 
--                    replace_pkt_raw <= '1';
--                    replace_pkt_entry <= '0';
--                    last_left_plc_value <= dacLeftLIFOData;
--                    last_right_plc_value <= dacRightLIFOData;
                    
--                    if ((left_odd_fifo_occ > (((EXIT_FADE_LENGTH + REL_PIPE_LENGTH)/2))) or (left_even_fifo_occ > (((EXIT_FADE_LENGTH+REL_PIPE_LENGTH)/2)))) then
--                        replace_pkt_rel <= '1'; 
--                        plc_state <= release;          
--                    else
--                        replace_pkt_rel <= '0'; 
--                        plc_state <= replace;
--                    end if;
                        
--               when release =>
--                    exit_counter <= (others => '0');
--                    entry_counter <= (others => '0');
--                    sampleCounter <= (others => '0');
--                    replace_pkt_entry <= '0';
--                    replace_pkt_set <= '0'; 
--                    replace_pkt_raw <= '1'; 
--                    rel_counter <= rel_counter + 1;
--                    if(rel_counter >= REL_PIPE_LENGTH) then        
                       
--                       replace_pkt_rel <= '0';
                         
                        
----                         if(EXIT_FADE_LENGTH > 2) then
--                            replace_pkt_exit <= '1';
----                            replace_pkt_raw <= '1';
--                            plc_state <= fade_exit;
----                        else
----                            replace_pkt_exit <= '0';    
----                            plc_state <= idle;
----                            replace_pkt_raw <= '0';
----                        end if;        
--                    else
--                        replace_pkt_rel <= '1'; 
--                        replace_pkt_exit <= '0';   
--                        plc_state <= release;
--                    end if;
--                    last_left_plc_value <= dacLeftLIFOData;
--                    last_right_plc_value <= dacRightLIFOData;
                        
--                   when fade_exit =>
--                        entry_counter <= (others => '0');
--                        rel_counter <= (others => '0'); 
--                        sampleCounter <= (others => '0');
--                        replace_pkt_entry <= '0';
--                        replace_pkt_set <= '0'; 
                        
--                        exit_counter <= exit_counter + 1;                      
                        
--                        replace_pkt_raw <= '1';
--                        replace_pkt_rel <= '0';
--                        if(exit_counter >= EXIT_FADE_LENGTH) then
--                            replace_pkt_exit <= '0';
--                            replace_pkt_raw <= '0';
--                            plc_state <= idle;
--                        else                        
--                            replace_pkt_exit <= '1';
--                        end if;
--                        --do not cause pkt_end based update of the read pointer while replacing
----                        if(startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter <= SIM_PKT_SIZE)) then
----                            sampleCounter <= sampleCounter + 1;
----                --            pkt_end_sim <= '0';
----                        else
----                            sampleCounter <= (others => '0'); 
----                --            pkt_end_sim <= '1';       
----                        end if;
                        
                        
----                        if(startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter >= SIM_PKT_SIZE)) then
----                            pkt_end_sim <= '1';
----                        else
----                            pkt_end_sim <= '0';       
----                        end if;
--                         last_left_plc_value <= dacLeftLIFOData;
--                          last_right_plc_value <= dacRightLIFOData;
                       
--                   when others =>
--                        plc_state <= idle;
--                        replace_pkt_rel <= '0'; 
--                        replace_pkt_entry <= '0';
--                        replace_pkt_trig <= '0';   
--                        replace_pkt_exit <= '0';  
--                        replace_pkt_raw <= '0';  
--                        replace_pkt_set <= '0'; 
--                        sampleCounter <= (others => '0');    
--                        exit_counter <= (others => '0');
--                        entry_counter <= (others => '0');
--                        rel_counter <= (others => '0'); 

--                end case;
                
                

                               
--                if (resetOddDACFifo ='1' or resetEvenDACFifo  ='1') then
--                     exit_counter <= (others => '0');
--                     rel_counter <= (others => '0'); 
--                     sampleCounter <= (others => '0');
--                end if;
               
                
     
        
        
       
--    end if; -- reset
            
--end process;

--pkt_end_sim <= '1' when (startRead = '1'  and replace_pkt_raw = '0' and (sampleCounter >= SIM_PKT_SIZE)) else '0';


--fader_direction_process: process(s_ch1_audio_payload_axis_aresetn, resetFifos, replace_pkt_exit, replace_pkt_entry, replace_pkt_raw, replace_pkt_rel)
--    begin
--    if s_ch1_audio_payload_axis_aresetn = '0'  or resetFifos = '1' then
--            fade_dpkt_direction_reg <= '0'; -- up
--            fade_plc_direction_reg <= '1'; -- down
--            fade_plc_max_reg   <= '0';
--            fade_dpk_min_reg   <= '0';
--            fade_plc_min_reg   <= '1'; 
--            fade_dpk_max_reg   <= '1';  
--            rst_out <= '1'; 
--        else

--            if(replace_pkt_exit = '1') then
--                -- Disable min max to get sweeping control
--                fade_plc_min_reg   <= '0'; 
--                fade_plc_max_reg   <= '0'; 
--                fade_dpk_min_reg   <= '0'; 
--                fade_dpk_max_reg   <= '0'; 
                
--                fade_dpkt_direction_reg <= '0'; -- up
--                fade_plc_direction_reg <= '1'; -- down
----            elsif(replace_pkt_entry = '1') then
----                fade_plc_min_reg   <= '0'; 
----                fade_plc_max_reg   <= '0'; 
----                fade_dpk_min_reg   <= '0'; 
----                fade_dpk_max_reg   <= '0'; 
                
----                fade_dpkt_direction_reg <= '1'; -- down
----                fade_plc_direction_reg <= '0'; -- up
--            elsif((replace_pkt_raw = '1' or (replace_pkt_rel = '1')) and (replace_pkt_exit = '0') and (replace_pkt_entry = '0')) then    
--                fade_dpk_min_reg   <= '1'; 
--                fade_plc_max_reg   <= '1'; 
--                fade_plc_min_reg   <= '0'; 
--                fade_dpk_max_reg   <= '0';                 
--            else
--                 fade_plc_min_reg   <= '1'; 
--                fade_dpk_max_reg   <= '1'; 
--                fade_dpk_min_reg   <= '0'; 
--                fade_plc_max_reg   <= '0'; 
--            end if;               

            
--          rst_out <= resetFifos;  
            
--       end if;
--    --fade_dpkt_direction_reg <= '0' when (new_pkt_ready_in_pulse = '1' and replace_inprogress_in = '1') else '1' when replace_inprogress_in_pulse =  '1' else fade_dpkt_direction_reg;
    
--    --fade_plc_direction_reg <= '1' when (new_pkt_ready_in_pulse = '1' and replace_inprogress_in = '1') else '0' when replace_inprogress_in_pulse =  '1' else fade_plc_direction_reg;
--end process;


--fade_dpk_enable_reg <= '1'; -- this allows to hold the fade values, great for zero values
----    fade_plc_enable_reg <= '1' when (replace_pkt_raw = '0') else '0';
----fade_plc_enable_reg <= '1' when (replace_pkt_raw = '1') else '0';
--fade_plc_enable_reg <= '1';

----clear takes values to delault == max
--fade_dpk_clear_reg <= '0';
--fade_plc_clear_reg <= '0';



--fade_dpkt_direction_out <= fade_dpkt_direction_reg;  --- Up
--fade_plc_direction_out <= fade_plc_direction_reg;  --- Up;  --- down

--fade_dpk_enable_out <= fade_dpk_enable_reg;--fade_enable_reg and replace_inprogress_in;
--fade_plc_enable_out <= fade_plc_enable_reg;

--fade_plc_clear_out  <= fade_plc_clear_reg;-- when ((fade_enable_reg and replace_inprogress_in) = '1') else '1';
----    fade_dpk_clear_out  <= '0' when (replace_inprogress_in = '1') else '1';
--fade_dpk_clear_out  <= fade_dpk_clear_reg;




--fade_plc_max_out   <= fade_plc_max_reg;
--fade_plc_min_out   <= fade_plc_min_reg;

--fade_dpk_min_out   <= fade_dpk_min_reg;      
--fade_dpk_max_out   <= fade_dpk_max_reg;

        
----pkt_end_sim <= '0' when (sampleCounter < 4) else '1';        
--writeOddDACFifo <= writeOddDACFifoEth;-- when (writeSourceSelect = '0') else writeLeftDACFifoArm;
--writeEvenDACFifo <= writeEvenDACFifoEth;-- when (writeSourceSelect = '0') else writeRightDACFifoArm;

--fifo_write_odd <= writeOddDACFifoEth;
--fifo_write_even <= writeEvenDACFifoEth;

--leftFifo24BitIn <= leftFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
--rightFifo24BitIn <= rightFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);

    
--    writeDACFifoClk <= CLK_125;-- when (writeSourceSelect = '0') else s00_axi_aclk;
    
    
    
    
--    leftFifo24BitIn <= leftFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
--    rightFifo24BitIn <= rightFifo24BitInEth;-- when (writeSourceSelect = '0') else wValue(23 downto 0);
    
    
   
   
   
   
   

----    payload_length <= wValue(15 downto  0) when (writeReg = '1' and wAdr="0011") else payload_length;
    
--    FIFO_LEFT_ODD_OutDAC : DualClockFIFO
--    generic map (
--        DATA_WIDTH => 24,
--        ADDR_WIDTH => FIFO_ADDR_WIDTH
--    )
--    port map (
--        -- Reading port.
--        Data_out    => dacLeftOddFIFOData,
--        PktEnd_out  => PktEnd_FIFO_LeftOdd,
--        Empty_out   => dacLeftOddFIFOEmpty,
--        ReadEn_in   => dac_ofifo_read,
--        RClk        => read_Odd_FIFOClk,
        
--        -- Writing port.
--        Data_in     => leftOut24BitTmp,
--        PktEnd_in  => dpk_pkt_end,
--        Full_out    => dacLeftOddFIFOFull,
--        WriteEn_in  => writeOddDACFifo,
--        WClk        => writeDACFifoClk,
     
--        fifo_occ_out => left_odd_fifo_occ,--open,
--        Clear_in    => resetFifos
--    );
    
    
    
    
--    FIFO_LEFT_EVEN_OutDAC : DualClockFIFO
--    generic map (
--        DATA_WIDTH => 24,
--        ADDR_WIDTH => FIFO_ADDR_WIDTH
--    )
--    port map (
--        -- Reading port.
--        Data_out    => dacLeftEvenFIFOData,
--        PktEnd_out  => PktEnd_FIFO_LeftEven,
--        Empty_out   => dacLeftEvenFIFOEmpty,
--        ReadEn_in   => dac_efifo_read,
--        RClk        => read_Even_FIFOClk,
        
--        -- Writing port.
--        Data_in     => leftOut24BitTmp,
--        PktEnd_in  => dpk_pkt_end,
--        Full_out    => dacLeftEvenFIFOFull,
--        WriteEn_in  => writeEvenDACFifo,
--        WClk        => writeDACFifoClk,
     
--        fifo_occ_out => left_even_fifo_occ,
--        Clear_in    => resetFifos
--    );
    
    
    
--    FIFO_RIGHT_ODD_OutDAC : DualClockFIFO
--    generic map (
--        DATA_WIDTH => 24,
--        ADDR_WIDTH => FIFO_ADDR_WIDTH
--    )
--    port map (
--        -- Reading port.
--        Data_out    => dacRightOddFIFOData,
--        PktEnd_out  => PktEnd_FIFO_RightOdd,
--        Empty_out   => dacRightOddFIFOEmpty,
--        ReadEn_in   => dac_ofifo_read,
--        RClk        => read_Odd_FIFOClk,
        
--        -- Writing port.
--        Data_in     => rightOut24BitTmp,
--        PktEnd_in  => dpk_pkt_end,
--        Full_out    => dacRightOddFIFOFull,
--        WriteEn_in  => writeOddDACFifo,
--        WClk        => writeDACFifoClk,
     
--        fifo_occ_out => right_odd_fifo_occ,
--        Clear_in    => resetFifos
--    );
    
    
    
    
--    FIFO_RIGHT_EVEN_OutDAC : DualClockFIFO
--    generic map (
--        DATA_WIDTH => 24,
--        ADDR_WIDTH => FIFO_ADDR_WIDTH
--    )
--    port map (
--        -- Reading port.
--        Data_out    => dacRightEvenFIFOData,
--        PktEnd_out  => PktEnd_FIFO_RightEven,
--        Empty_out   => dacRightEvenFIFOEmpty,
--        ReadEn_in   => dac_efifo_read,
--        RClk        => read_Even_FIFOClk,
        
--        -- Writing port.
--        Data_in     => rightOut24BitTmp,
--        PktEnd_in  => dpk_pkt_end,
--        Full_out    => dacRightEvenFIFOFull,
--        WriteEn_in  => writeEvenDACFifo,
--        WClk        => writeDACFifoClk,
     
--        fifo_occ_out => right_even_fifo_occ,
--        Clear_in    => resetFifos
--    );
    
    
--    read_Odd_FIFOClk <=  newsample_div2_125 when startRead = '1'  else '0';
--    read_Even_FIFOClk <= newsample_div2_125 when startRead = '1' else '0';
    
    
--    -----------------------------------------------------------------------PLC-------------------------------------------------------------------
    
   
--    LIFO_L_OutDAC : DualClockLIFO
--    generic map (
--        DATA_WIDTH => FIFO_DATA_WIDTH,
--        ADDR_WIDTH => LIFO_ADDR_WIDTH
--    )
--    port map (
--        -- Reading port.
--        Data_out    => dacLeftLIFOData,
--        Empty_out   => dacLeftLIFOEmpty,
--        ReadEn_in   => dac_lifo_read,
--        RClk        => read_PLC_Clk,
        
--        PktEnd_out  => PktEnd_LIFO_L,
--        Replace_pkt_in => replace_pkt_set,
--        Replace_inprogress_in  =>   replace_inprogress_sig, --- This can also do Replace_overlap by prolonging it until the end of the first packet
----        Replace_inprogress_in  =>   replace_pkt_raw,
        
--        -- Writing port.
        
--        PktEnd_in  => plc_pkt_end_left,
--        Data_in     => leftOut24Bit,
--        Full_out    => dacLeftLIFOFull,
--        WriteEn_in  => writeLeftDACLifo,
--        WClk        => writeDACLifoClk,
     
--        fifo_occ_out => left_lifo_occ,--open,
--        Clear_in    => resetLifos
--    );
    
    
    
    
--    LIFO_R_OutDAC : DualClockLIFO
--    generic map (
--        DATA_WIDTH => FIFO_DATA_WIDTH,
--        ADDR_WIDTH => LIFO_ADDR_WIDTH
--    )
--    port map (
--        -- Reading port.
--        Data_out    => dacRightLIFOData,
--        Empty_out   => dacRightLIFOEmpty,
--        ReadEn_in   => dac_lifo_read,
--        RClk        => read_PLC_Clk,
        
--        PktEnd_out  => PktEnd_LIFO_R,
--        Replace_pkt_in => replace_pkt_set,
--        Replace_inprogress_in  =>   replace_inprogress_sig, --- This can also do Replace_overlap by prolonging it until the end of the first packet
----        Replace_inprogress_in  =>   replace_pkt_raw,
        
--        -- Writing port.
        
--        PktEnd_in  => plc_pkt_end_right,

--        Data_in     => rightOut24Bit,
--        Full_out    => dacRightLIFOFull,
--        WriteEn_in  => writeRightDACLifo, 
--        WClk        => writeDACLifoClk,
     
--        fifo_occ_out => right_lifo_occ,
--        Clear_in    => resetLifos
--    );
    
    
    
    
--    resetFifos <= '1' when (resetEvenDACFifo = '1' or resetOddDACFifo = '1' or s_ch1_audio_payload_axis_aresetn = '0' or clearFifos = '1') else '0';
--    resetLifos <= '1' when (resetEvenDACFifo = '1' or resetOddDACFifo = '1' or s_ch1_audio_payload_axis_aresetn = '0' or clearFifos = '1') else '0';
    
--    read_PLC_Clk <= newsample_125 when startRead = '1' else '0'; 
----    read_PLC_Clk <= newsample_in;
--    writeDACLifoClk <= newsample_125 when startRead = '1' else '0'; 
    
    
--    dac_lifo_read <= '1' when ((replace_pkt_raw = '1' or replace_pkt_exit = '1') and  startRead = '1') else '0'; 
--    replace_inprogress_sig <= '1' when ((replace_pkt_raw = '1' or replace_pkt_exit = '1') and  startRead = '1') else '0'; 

    
--    writeRightDACLifo <= '1' when ((replace_pkt_raw = '0'  or replace_pkt_exit = '1') and  startRead = '1') else '0'; --(dac_efifo_read or dac_ofifo_read);
--    writeLeftDACLifo <= '1' when ((replace_pkt_raw = '0'  or replace_pkt_exit = '1') and  startRead = '1') else '0'; --writeRightDACLifo;
--    --dpk_pkt_end <= s_ch1_audio_payload_axis_tlast; bad idea
--    ---------------------------------------------------------------------------------------------------------------------------------------------

--    plc_pkt_end_right <= pkt_end_sim;
--    plc_pkt_end_left <= pkt_end_sim;


    
    
    
    

    

--    tc_sync_en <= tc_sync_en_in;

--    test_sig_sel <= (test_mode_final & test_pattern);
--    -- IRQ Generation.
--    -- TODO (2), make sure we generate ONE pulse ? Assert until... ?
--    irq_out <= '0';
    


    
--    plc_audio_l_out <=  dacLeftLIFOData when (replace_pkt_raw = '1' or replace_pkt_exit = '1') else last_left_plc_value;
--    plc_audio_r_out <= dacRightLIFOData when (replace_pkt_raw = '1' or replace_pkt_exit = '1') else last_right_plc_value;

----    plc_audio_l_out <=  last_left_plc_value when (replace_pkt_exit = '1') else dacLeftLIFOData;
----    plc_audio_r_out <=  last_right_plc_value when (replace_pkt_exit = '1') else dacRightLIFOData;
    
    
    
----    dpk_audio_l_out <=  leftOut24Bit when (replace_pkt_raw = '0') else dacLeftLIFOData;
----    dpk_audio_r_out <= rightOut24Bit when (replace_pkt_raw = '0') else dacRightLIFOData;
    
--    dpk_audio_l_out <=  leftOut24Bit;
--    dpk_audio_r_out <= rightOut24Bit;
    
    
--    s_ch1_audio_payload_hdr_ready <= hdr_ready;
--    s_ch1_audio_payload_axis_tready <= tready;
--    tvalid <= s_ch1_audio_payload_axis_tvalid;
--    tdata <= s_ch1_audio_payload_axis_tdata;
--    tlast <= s_ch1_audio_payload_axis_tlast;
--	-- User logic ends
--	packet_count_mirror <= unsigned(packet_count);
--	buf_count_mirror <= unsigned(buf_count);
	
--	fifo_full_out <= '1' when (dacLeftEvenFIFOFull='1' or dacLeftOddFIFOFull = '1') else '0';
--	fifo_empty_out <= '1' when (dacLeftEvenFIFOEmpty='1' or dacLeftOddFIFOEmpty = '1') else '0';
	

    
--    fifo_occ <= left_odd_fifo_occ when left_odd_fifo_occ >= left_even_fifo_occ else left_even_fifo_occ;
--    fifo_occ_out <= STD_LOGIC_VECTOR(fifo_occ);


--    status2_out  <= '1' when state_val = "00000" else '0';  
--    status1_out  <= '1' when (dacLeftEvenFIFOFull='0' or dacLeftOddFIFOFull = '0') else '0';
    
    
--    first_pkt_ind <= first_pkt_wrt;
    
    
--    newsample_125_out <= newsample_125;
    

    
--end arch_imp;

