library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity time_sync_block_v2_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 7;
		AXIS_UDP_DATA_WIDTH     : integer   := 8;
		SEQ_NUM_LENGTH          : natural   :=  2;
		TC_LENGTH               : natural   :=  4;
		TC_BIT_LENGTH               : natural   :=  32;
		PACKET_LEN_WIDTH              : natural   :=  32;
		SINE_DIV_WIDTH             : natural   :=  32;
		PACKET_SEQ_W: natural   :=  16;
		
		TC_COUNT_WIDTH  : natural   := 32;
        MIN_UDP_PKT_SIZE	 : natural   := 32;
        UDP_LENGTH_WIDTH  : natural   := 16
	);
	port (
		-- Users to add ports here

        signal newsample_in            : in    STD_LOGIC;
        signal tc_running_in            : in    STD_LOGIC;

        signal sync_request_rx_out                : out    STD_LOGIC; 
        signal initiate_sync_request_out             : out    STD_LOGIC; 
        signal initiate_sync_response_out             : out    STD_LOGIC; 
        
        signal sync_response_done       : out    STD_LOGIC;
        signal sync_done_out            : out    STD_LOGIC; 
         signal status1_out            : out    STD_LOGIC; 
         signal status2_out            : out    STD_LOGIC; 
        signal tc_sync_en_out              : out    STD_LOGIC; 
        signal tc_adjust_out              : out    STD_LOGIC;
        

        signal sync_time_code_out : out STD_LOGIC_VECTOR(TC_BIT_LENGTH-1 downto 0);
        
        signal media_pkt_tx_en_in : in STD_LOGIC;
        signal path_tc_valid_in : in STD_LOGIC;
        signal path_tx_tc_code_in: in STD_LOGIC_VECTOR(TC_BIT_LENGTH-1 downto 0);
        signal path_rx_tc_code_in: in STD_LOGIC_VECTOR(TC_BIT_LENGTH-1 downto 0);
--		clk_48                  :  in    STD_LOGIC;
--		-- PS Side
--        IRQ                   : out   STD_LOGIC;
        
        -- Board Side
--          CLK_100               : in    STD_LOGIC;
          signal CLK_125               : in    STD_LOGIC;  --- AXIS clock
          signal    round_path_delay_out      : out std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
          
--          signal    tc_count_in      : in std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
          signal    rx_packet_seq_cnt_in : in unsigned(PACKET_SEQ_W-1 downto 0);

		-- User ports ends
		-- Do not modify the ports beyond this line
--         /*
--    * AXIS AUDIO Stream Master (Sending out of the core)
--    */
    
    m_time_sync_axis_tdata	: out std_logic_vector(AXIS_UDP_DATA_WIDTH-1 downto 0);
    m_time_sync_axis_tvalid	: out std_logic;
    m_time_sync_axis_tready	: in std_logic;
    m_time_sync_axis_tlast	: out std_logic;
    m_time_sync_axis_tuser	: out std_logic;
    
    m_time_sync_hdr_valid   : out std_logic;
    m_time_sync_hdr_ready   : in std_logic;
    
    
    
    s_time_sync_axis_tdata : in std_logic_vector(7 downto 0);
    s_time_sync_axis_tvalid : in std_logic;
    s_time_sync_axis_tready	: out std_logic;
    s_time_sync_axis_tlast : in std_logic;
    s_time_sync_axis_tuser: in std_logic;
    
    s_time_sync_hdr_ready: out std_logic;
    
    
    
    
    udp_payload_length           : out std_logic_vector(15 downto 0);

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
end time_sync_block_v2_0;

architecture arch_imp of time_sync_block_v2_0 is



	-- component declaration
	component time_sync_block_v2_0_S00_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= C_S00_AXI_ADDR_WIDTH
		);
		port (
        writeReg        : out std_logic;
        wValue          : out std_logic_vector(31 downto 0);
        wAdr            : out std_logic_vector( C_S_AXI_ADDR_WIDTH-1 downto 2);
        wLane           : out std_logic_vector( 3 downto 0);
        
        readReg         : out std_logic;
        rAdr            : out std_logic_vector( C_S_AXI_ADDR_WIDTH-1 downto 2);
        rValue          : in  std_logic_vector(31 downto 0);
        rDataValid_in   : in std_logic;
		
		S_AXI_ACLK	    : in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	    : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	    : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	    : out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	    : out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component time_sync_block_v2_0_S00_AXI;
	
	
	component moving_average is
generic (
  G_NBIT                     : integer := TC_BIT_LENGTH;
  G_AVG_LEN_LOG              : integer := 2 );
port (
  i_clk                      : in  std_logic;
  i_rstb                     : in  std_logic;
  i_sync_reset               : in  std_logic;
  -- input
  i_data_ena                 : in  std_logic;
  i_data                     : in  std_logic_vector(G_NBIT-1 downto 0);
  -- output
  o_data_valid               : out std_logic;
  o_data                     : out std_logic_vector(G_NBIT-1 downto 0));
end component moving_average;
	
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
    
  

component BUFG is 
port (
    I: in std_logic;
    O: out std_logic
);
 end component;
 

	
	
	-- Register Adressing
    signal writeReg        : std_logic;
    signal wValue          : std_logic_vector(31 downto 0);
    signal wAdr            : std_logic_vector( C_S00_AXI_ADDR_WIDTH-1 downto 2);
    signal wLane           : std_logic_vector( 3 downto 0);
    signal readReg         : std_logic;
    signal rAdr            : std_logic_vector( C_S00_AXI_ADDR_WIDTH-1 downto 2);
    signal rValue          : std_logic_vector(31 downto 0);
    signal rDataValid_sig  : std_logic;
    -- Physical Registers
--    signal resetADCLeftFifo     : std_logic;
--    signal resetADCRightFifo    : std_logic;
    
    constant PACKET_W   : natural :=  15;
    constant PACKET_COUNT_W       : natural :=  32;
    
    signal payload_length         : std_logic_vector(15 downto 0):= x"024C"; -- formula == 6*N + 12 == must be even
    signal payload_length_mirror  : unsigned(15 downto 0):= x"024C"; -- formula == 6*N + 12 was 
    signal packet_len_cnt         : unsigned(PACKET_W-1 downto 0)  := (others => '0');
    signal packet_len_cnt_final   : unsigned(PACKET_W-1 downto 0)  := (others => '0');
    
    signal enablePacketCount      : std_logic := '0';
    signal enablePacketCount_final: std_logic := '0';
    
    signal packet_count : std_logic_vector(PACKET_COUNT_W-1 downto 0):= x"0000_0240";  -- formula == 6*N + 2 == must be even
    signal packet_count_mirror : unsigned(PACKET_COUNT_W-1 downto 0):=  x"0000_0240"; --- 794
    signal packet_count_cnt : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    signal packet_count_cnt_final : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    
    signal in_packet_count : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    signal out_packet_count : unsigned(PACKET_COUNT_W-1 downto 0)  := (others => '0');
    
    
    signal leftTest24Bit,rightTest24Bit : unsigned(23 downto 0) := (others => '0');
    
    
    signal packet_seq_cnt : unsigned(PACKET_SEQ_W-1 downto 0):=  x"0000";
    signal add_seq : std_logic := '1';
    
    
    signal tvalid, tready, s_tready : std_logic := '0';
    signal tdata  : std_logic_vector(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
    
    -- FIFO, Clock Connection
    signal newsample_125, tc_div_125 : std_logic;
    
    signal test_mode : std_logic := '0';
    signal test_pattern : std_logic_vector(2 downto 0):= b"100";
    signal test_mode_final : std_logic := '0';
    
    
    signal initiate_sync_request, initiate_tms_request, initiate_mock_request, initiate_mock_request_reg, pkt_is_expected : std_logic  := '0';

    subtype delay_type is natural range 0 to 10000000;
    

    constant reset_delay : delay_type := 99999;
    constant s1_delay  : delay_type := 4999;
    constant s2_delay  : delay_type := (35999);
    constant hdr_valid_delay : delay_type := 4;
    -- NB take care to avoid off-by-1 error!
    signal delay : delay_type;
    
    
    ---Test code
--    constant PACKET_LEN : natural :=  16;
  
  
  -- Define the states of state machine                                             
--  type    state is (IDLE, SEND_STREAM);          

--  signal  sm_state_next : state := IDLE;                                                   
signal    tx_time_code, sync_time_code      : unsigned(TC_BIT_LENGTH  -1 downto 0);
  -- AXI Stream internal signals
--  signal tvalid         : std_logic := '0';
  signal tlast, tuser         : std_logic := '0';  
  signal hdr_valid     : std_logic := '0';
  
--  signal sample_48k : std_logic := '0';
  signal newsample_reg, newsample_change, newsample_rdy, tc_gen_reg : std_logic := '0';
--  signal hdr_valid_next     : std_logic := '0';  
--  signal data           : unsigned(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
--  signal data_out           : unsigned(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
  
  
  
  
  
  constant TEST_PULSE_WIDTH :natural := 3125000;--20Hz @ 125MHz base
    signal testWave24Bit : std_logic_vector(23 downto 0) := X"00FFFF";
    signal testWaveTimer : unsigned(32 downto 0);
    
    signal sync_done, sync_response_done_reg, sync_responded_reg, tms_done, tms_responded_reg, sync_responded, tms_responded, avg_i_data_valid, avg_o_data_valid    : std_logic := '0';
    
    
    constant TC_DEPTH :integer := 2**TC_COUNT_WIDTH;
    
    
    signal 	m_time_sync_payload_length : unsigned( 15 downto 0);
    signal last_tms_pkt_seq, tms_pkt_seq, tms_req_pkt_seq_reg, sync_req_pkt_seq_reg : unsigned( 7 downto 0);
    signal corresp_pkt_seq_reg, rx_sync_req_pkt_seq_reg : std_logic_vector( 7 downto 0);
	signal   sync_response_trigger, tms_response_trigger,sync_request_pkt, sync_response_pkt,  waiting_for_response  : std_logic := '0';
	signal   tc_adjust_reg, tc_adjust, sync_done_reg, tms_done_reg, sync_reset, sync_reset_reg, send_mock_pkt : std_logic := '0';
	
	signal    tc_sync_en  : std_logic := '1';
	
	signal tms_request_magic_byte : std_logic_vector( 7 downto 0) := X"A5";
	signal tms_response_magic_byte : std_logic_vector( 7 downto 0) := X"5A";
    signal sync_request_magic_byte : std_logic_vector( 7 downto 0) := X"80";
    signal sync_response_magic_byte : std_logic_vector( 7 downto 0) := X"F0";
	
	signal in_state_val : std_logic_vector( 7 downto 0);
	signal out_state_val : std_logic_vector( 7 downto 0);
	  
	signal path_m_counter : unsigned( 15 downto 0);
	  
	signal 	  media_round_path_delay, round_path_delay_reg, half_path_delay, oneway_path_delay_reg, oneway_path_delay, tc_count_rx, clk_offset_reg:  unsigned(TC_COUNT_WIDTH-1 downto 0);
	
	signal sync_response_trigger_reg, tms_response_trigger_reg, clk_offset_dir: std_logic := '0';
	signal 	 tc_count_rx_reg, orig_tc_count_rx_reg, tms_interval_count_rx_reg, tms_interval_count, oneway_path_delay_avg, oneway_path_delay_val :  std_logic_vector(TC_COUNT_WIDTH-1 downto 0);
	signal round_trip_wait_delay, sync_time_code_adj, oneway_delay_count :  unsigned(TC_COUNT_WIDTH-1 downto 0);
	signal 	 round_trip_delay_count :  unsigned(TC_COUNT_WIDTH-1 downto 0) := X"0773_5940";  -- Delay for 1 sec at
	signal 	 orig_tc_count_rx :  unsigned(TC_COUNT_WIDTH-1 downto 0);
	signal 	 oneway_delay_accum, oneway_delay_accum_reg, round_trip_delay_accum, round_trip_delay_accum_reg, 
	initial_tc_reg, initial_tc, initial_mock_tc_reg, initial_mock_tc, mock_tc_val :  unsigned(TC_COUNT_WIDTH-1 downto 0);

    signal 	 decode_unblock_delay_accum, decode_unblock_delay_accum_reg :  unsigned(TC_COUNT_WIDTH-1 downto 0);
	signal 	 decode_unblock_delay_count :  unsigned(TC_COUNT_WIDTH-1 downto 0) := X"0773_5940";
	
	signal 	 path_data_valid, sync_request_initiated, round_path_delay_2_high, path_avg_sync_rst : std_logic := '0';
    signal 	 avg_path_data_valid : std_logic;
    signal media_path_delay_val, media_half_path_delay_val, media_half_path_delay :  unsigned(TC_COUNT_WIDTH-1 downto 0);
    signal media_half_path_delay_avg :  std_logic_vector(TC_COUNT_WIDTH-1 downto 0);
    
    
    signal last_rx_req_packt_tc :  std_logic_vector(TC_COUNT_WIDTH-1 downto 0);
  

begin

    -- Instantiation of Axi Bus Interface S00_AXI
    time_sync_block_v2_0_S00_AXI_inst : time_sync_block_v2_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
        -- Register Management Port
        writeReg        => writeReg, --AXI protocol driven
        wValue          => wValue,
        wAdr            => wAdr,
        wLane           => wLane,
        
        readReg         => readReg,--AXI protocol driven
        rAdr            => rAdr,
        rValue          => rValue,
        rDataValid_in   => rDataValid_sig,
--        rDataValid_in   => '1',
        
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
	
	
	mvn_avg_inst : moving_average
generic map (
  G_NBIT                => TC_BIT_LENGTH ,
  G_AVG_LEN_LOG        => 4  
  )
port map(
  i_clk                     => CLK_125,
  i_rstb                    => s00_axi_aresetn,
  i_sync_reset              => sync_reset,
  -- input
  i_data_ena                => avg_i_data_valid,
  i_data                    => std_logic_vector(oneway_path_delay),
  -- output
  o_data_valid             => avg_o_data_valid,
  o_data                   => oneway_path_delay_avg
  );

	                         
	oneway_path_delay_val <= oneway_path_delay_avg when avg_o_data_valid = '1' else oneway_path_delay_val;

	-- Add user logic here
	
	-- 100 Mhz -> 48 Mhz clock conversion.
--    i_clocking : clocking port map (
--      CLK_100 => CLK_100,
--      CLK_48  => CLK_48,
--      RESET   => '0',
--      LOCKED  => open
--    );
	
    -- Register Read Process (NOT CLOCKED !)
    --Thus Bit 3 and bit 2 so ==== OFFSET 0 => 0000 OFFSET 4 => 0001 OFFSET 8 => 0010 ....
    process(readReg,rAdr)
    begin
        rValue <= (others => '0');
        if (readReg='1') then
            case rAdr is
            when "00000" =>  
		        rValue(0) <= initiate_sync_request;
		        rValue(1) <= initiate_tms_request;
		        rValue(2) <= sync_done_reg;
		        rValue(3) <= sync_reset;
		        rValue(4) <= sync_response_done_reg;
		        rValue(5) <= initiate_mock_request;
		        rValue(6) <= tc_sync_en;
		        rValue(7) <= waiting_for_response;
		        rValue(12) <= round_path_delay_2_high;
            when "00001" =>
               
                    rValue    <= x"0000_00"&sync_request_magic_byte;
                
            when "00010" =>

                   rValue    <= x"0000_00"&sync_response_magic_byte;
                   
             when "00011" =>
               
                    rValue    <= x"0000_00"&tms_request_magic_byte;
             when "00100" =>  
                    rValue    <= x"0000_00"&tms_response_magic_byte;
             when "00101" =>  
		          -- Offset 12
                rValue <=    b"0000_0000_0000_0000"&payload_length;
             when "00110" =>  
		          -- Offset 16
                rValue <=    packet_count(31 downto  0);
            when "00111" =>  
		          -- Offset 16
                rValue <=    std_logic_vector(round_trip_delay_count(31 downto  0));
            
            when "01000" =>  
		          -- Offset 16
                rValue <=    std_logic_vector(round_trip_wait_delay(31 downto  0));
            when "01001" =>
                rValue <=    std_logic_vector(decode_unblock_delay_count(31 downto  0));
             when "01010" =>
                rValue <=    std_logic_vector(oneway_path_delay(31 downto  0));
                
             when "01011" =>
                rValue <=    oneway_path_delay_val;
             when "01100" =>
                rValue <=    std_logic_vector(mock_tc_val);
            when "01101" =>
                rValue <=    std_logic_vector(media_round_path_delay);
            when "01110" =>
                rValue <=    std_logic_vector(media_half_path_delay_val);
             when "01111" =>
                rValue <=    std_logic_vector(round_path_delay_reg);
             when "10000" =>
                rValue <=    std_logic_vector(half_path_delay);
                
            when "10001" =>
                rValue <=    std_logic_vector(in_packet_count);
            when "10010" =>
                rValue <=    std_logic_vector(out_packet_count);
            when "10011" =>
                rValue <=    in_state_val & x"0000" & out_state_val;
            when others =>  
                rValue <=    rAdr&b"111_1111_1111"&X"FFFF";  
            end case;
        end if;
    end process;
    
    
    -- Register Write Process
    process(s00_axi_aclk,packet_len_cnt, s00_axi_aresetn,wAdr,writeReg,wValue)
    begin
        if rising_edge(s00_axi_aclk) then
--            resetADCLeftFifo <= '0';
--            resetADCRightFifo <= '0';
            
            if (s00_axi_aresetn = '0'  or sync_reset = '1') then
--                -- Reset
--                resetADCLeftFifo <= '1';
--                resetADCRightFifo <= '1';
                initiate_sync_request <= '0';
                initiate_tms_request <= '0';
                test_mode <= '0';
                sync_reset_reg <= '0';
                initiate_mock_request_reg   <= '0';
                round_trip_wait_delay <= x"0000_0240"; 
                m_time_sync_payload_length <= X"0040";
                test_pattern <= b"100";
                packet_count<= x"0000_0010"; 
                payload_length <= x"024C";-- formula == 6*N + 12 even
                mock_tc_val <= x"0000_0030";--1ms
                
                round_trip_delay_count <= X"0773_5940"; --- 1 second @ 125MHz X"2540_BE40"; --- 5 seconds @ 125MHz
                oneway_delay_count  <= X"0773_5940"; --- 1 second @ 125MHz
                decode_unblock_delay_count <= X"0773_5940";
                
                tms_interval_count <= X"00BE_BC20";   -- 100ms @ 125MHz
                
                tc_sync_en <= '1';
                
            else
                if (writeReg = '1') then
                    case wAdr is
                    when "00000" =>  
                            initiate_sync_request <= wValue(0);  
                            initiate_tms_request <= wValue(1);
                            sync_reset_reg <= wValue(2);
                            
                            initiate_mock_request_reg   <= wValue(5);
--                        resetADCLeftFifo <= wValue(0);                
--                        resetADCRightFifo <= wValue(1);
                        enablePacketCount <= wValue(6);
                        test_mode <= wValue(7);                                                  
                        test_pattern <= wValue(11 downto 9);   
    
                    when "00001" =>
                        sync_request_magic_byte <= wValue(7 downto  0);
                    when "00010" =>
                        sync_response_magic_byte <= wValue(7 downto  0);
                   when "00011" =>
                        tms_request_magic_byte <= wValue(7 downto  0);
                   when "00100" =>
                        tms_response_magic_byte  <= wValue(7 downto  0);
                    when "00101" =>
                        m_time_sync_payload_length <= unsigned(wValue(15 downto  0));
                    when "00110" =>
                        --sync_reset_reg <= wValue(0); 
                        mock_tc_val <= unsigned(wValue);
                    when "00111" =>  
		          -- Offset 16
                       round_trip_delay_count <= unsigned(wValue(31 downto  0));
                   when "01000" =>  
		                  oneway_delay_count <= unsigned(wValue(31 downto  0));
                    when  "01001" =>
                        decode_unblock_delay_count <= unsigned(wValue(31 downto  0));
                    when "01010" =>
                        packet_count <= wValue(31 downto  0);
                    when "01011" =>    
                        tms_interval_count  <= wValue(31 downto  0);
                   when "01100" =>
                        tc_sync_en <= wValue(0);
                    when others =>
--                        resetADCLeftFifo <= resetADCLeftFifo;                
--                        resetADCRightFifo <= resetADCRightFifo;
                        test_mode <= test_mode;
                        initiate_mock_request_reg <= initiate_mock_request_reg;
                        round_trip_delay_count <= round_trip_delay_count;
                        oneway_delay_count <= oneway_delay_count;
                        enablePacketCount <= enablePacketCount;                        
                        initiate_sync_request <= initiate_sync_request;  
                        test_pattern <= test_pattern;
                        sync_request_magic_byte <= sync_request_magic_byte;
                        sync_response_magic_byte <= sync_response_magic_byte;
                        tms_request_magic_byte <= tms_request_magic_byte;
                        tms_response_magic_byte <= tms_response_magic_byte;
                        m_time_sync_payload_length <= m_time_sync_payload_length;
                        payload_length <= payload_length; 
                        packet_count <= packet_count;
                        mock_tc_val <= mock_tc_val;
                        tms_interval_count  <= tms_interval_count;
                        decode_unblock_delay_count <= decode_unblock_delay_count;
                    end case;
                end if;
                
               
                if sync_request_initiated = '1' then            
                    initiate_sync_request <= '0';
                end if;   
                
                
                if(sync_reset = '1') then
                    initiate_sync_request <= '0';  
                    initiate_tms_request <= '0';                    
                    initiate_mock_request_reg   <= '0';
                end if; 
                
            end if;
        end if;
    end process;
    
--    initiate_sync_request_out <= initiate_sync_request;
    sync_reset <= sync_reset_reg;


-- I/O Connections assignments
--  m_axis_tstrb   <= (others => '1');     -- byte enables always high
  m_time_sync_axis_tvalid  <= tvalid;
  m_time_sync_axis_tlast   <= tlast;
--  data(PACKET_W-1 downto 0)  <= packet_len_cnt; 
  m_time_sync_axis_tuser <= tuser; 
  m_time_sync_axis_tdata   <= tdata;
  m_time_sync_hdr_valid <= hdr_valid;
  tready <= m_time_sync_axis_tready;
  
--  adcLeftData <= adcLeftDataTmp;
--  adcRightData <= adcRightDataTmp;
  
  
  test_mode_final <= test_mode;  
  packet_len_cnt_final <= packet_len_cnt;
  packet_count_cnt_final <= packet_count_cnt;
  enablePacketCount_final <= enablePacketCount;
  
  
  send_mock_pkt <= '1' when (((sync_time_code > initial_mock_tc) and (sync_time_code - initial_mock_tc >= mock_tc_val)) or (initial_mock_tc > (sync_time_code ) and (X"FFFF_FFFF" - initial_mock_tc + sync_time_code >= mock_tc_val))) else '0';

audio_to_eth : process(CLK_125, s00_axi_aresetn, sync_reset)   is
        type    state is (IDLE, SEND_SYNC_REQUEST, SEND_TMS_REQUEST, SEND_MOCK_REQUEST, SEND_SYNC_RESPONSE, SEND_TMS_RESPONSE, WAIT_SYNC_RESPONSE, WAIT_TMS_RESPONSE, WAIT_TMS_INTERVAL);      
        variable sm_state : state := IDLE;
        variable mock_return_state : state := IDLE;
        variable resp_return_state : state := IDLE;
        variable byte_count : integer range 0 to 65535 := 0;
        variable pktcount : integer range 0 to 255 := 0;                                                        
  begin                                                                                       
    if (s00_axi_aresetn = '0' or sync_reset = '1') then
        sm_state          := IDLE;
        mock_return_state          := IDLE;
        delay             <= reset_delay;
        tvalid            <= '0';
        tlast             <= '0';
        tuser             <= '0';   
        hdr_valid         <= '0';
        sync_response_done_reg <= '0';
        byte_count := 0;
        pktcount := 0;
        tdata <= (others => '0'); 
         waiting_for_response <= '0';
        packet_len_cnt    <= (others => '0');
        packet_count_cnt    <= (others => '0');
        add_seq <= '1';  
        out_packet_count <= x"0000_0000"; 
        if(s00_axi_aresetn = '0') then 
            corresp_pkt_seq_reg <= X"00";
            sync_req_pkt_seq_reg <= X"00";
            tms_req_pkt_seq_reg<= X"00";
        else
            corresp_pkt_seq_reg  <= X"FF";
            sync_req_pkt_seq_reg <= sync_req_pkt_seq_reg;
            tms_req_pkt_seq_reg <= tms_req_pkt_seq_reg;
        end if;
        round_trip_delay_accum_reg <= X"0000_0000";     
        sync_responded_reg <= '0';   
        initiate_sync_request_out <= '0';
        initiate_sync_response_out <= '0';    
        initial_mock_tc_reg  <= X"0000_0000";   
        sync_request_initiated <= '0';   
          
      
      
   elsif  (rising_edge (CLK_125))  then
             
    --------------------------------------------------- RUN MODE ------------------------------------------------------------
--        if(initiate_sync_request_final = '1') then                                          
                  case (sm_state) is                                                              
                    when IDLE =>
                      tvalid            <= '0';
                      tlast             <= '0';
                      tuser             <= '0'; 
                      tdata <= (others => '0'); 
                      sm_state        := IDLE;
        --                m_time_sync_hdr_valid <= '0';
                      hdr_valid <= '0';
                      byte_count := 0; 
                      pktcount := 0;  
                      sync_responded_reg <= '0'; 
                      tms_responded_reg <= '0';
                      waiting_for_response <= '0';  
                      sync_request_initiated <= '0';   
                      sync_response_done_reg <= sync_response_done_reg;
                        round_trip_delay_accum_reg <= X"0000_0000";  
                        oneway_delay_accum_reg  <= X"0000_0000";  
                        resp_return_state := IDLE;
                        if (sync_response_trigger = '1')  then   
                            sm_state        :=  SEND_SYNC_RESPONSE;                                                                              
                            hdr_valid <= '1';
                            sync_response_done_reg <= '0';
                            initiate_sync_response_out <= '1';
                            sync_responded_reg <= '1';   
                            corresp_pkt_seq_reg <= corresp_pkt_seq_reg;                            
                        elsif (tms_response_trigger = '1')  then   
                            sm_state        :=  SEND_TMS_RESPONSE;                                                                              
                            hdr_valid <= '1';
--                            initiate_sync_response_out <= '1';
                            tms_responded_reg <= '1';   
                            corresp_pkt_seq_reg <= corresp_pkt_seq_reg;
                        elsif( initiate_sync_request = '1' and sync_done = '0')then
                            sm_state        := SEND_SYNC_REQUEST; 
                            initiate_sync_request_out <= '1'; 
                            sync_response_done_reg <= '0';
                            initial_tc_reg <= sync_time_code;   
                            sync_request_initiated <= '1';                      
                            hdr_valid <= '1';
                            corresp_pkt_seq_reg <= std_logic_vector(sync_req_pkt_seq_reg);
                       elsif( initiate_tms_request = '1' and tms_done = '0')then
                            sm_state        := SEND_TMS_REQUEST; 
--                            initiate_sync_request_out <= '1';
                            initial_tc_reg <= sync_time_code;                         
                            hdr_valid <= '1';
                            corresp_pkt_seq_reg <= std_logic_vector(corresp_pkt_seq_reg);
                       elsif( initiate_mock_request = '1' and tms_done = '0' and sync_done = '0' and sync_responded = '0'  and media_pkt_tx_en_in = '0')then
                            if((unsigned(initial_mock_tc) = X"0000_0000") or (send_mock_pkt = '1')) then
                                sm_state        := SEND_MOCK_REQUEST; 
    --                            initiate_sync_request_out <= '1';
                                                         
                                hdr_valid <= '1';
                                mock_return_state := IDLE;  
                            else
                                sm_state        := IDLE;  
                                hdr_valid <= '0';    
                            end if;  
                            corresp_pkt_seq_reg <= corresp_pkt_seq_reg;                                      
                        else                                                        
                            sm_state        := IDLE;  
                            hdr_valid <= '0'; 
                            corresp_pkt_seq_reg <= corresp_pkt_seq_reg;                                     
                          end if; 
                          
                          
                            
                    when  SEND_SYNC_REQUEST=>
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= '1';
                        tuser <= '0';
                        
                           
                        if( byte_count = 0) then
                           
                               tdata <=    X"AA"; -- pkt type
                               sm_state        := SEND_SYNC_REQUEST;   
                        elsif( byte_count = 1) then 
                               tdata <=   X"01";-- pkt src id will be made dynamic
                               sm_state        := SEND_SYNC_REQUEST;  
                       elsif( byte_count = 2) then
                           
                               tdata <=    sync_request_magic_byte; -- sync_request_magic_byte; 
                               sm_state        := SEND_SYNC_REQUEST;   
                        elsif( byte_count = 3) then 
                               tdata <=   std_logic_vector(sync_req_pkt_seq_reg);
                               sm_state        := SEND_SYNC_REQUEST; 
                        elsif( byte_count = 4) then 
                               tdata <=   std_logic_vector(sync_time_code(31 downto 24));
                               sm_state        := SEND_SYNC_REQUEST;  
                        elsif( byte_count = 5)
                           then 
                               tdata <=  std_logic_vector(sync_time_code(23 downto 16));
                               sm_state        := SEND_SYNC_REQUEST; 
                        elsif( byte_count = 6)
                           then 
                               tdata <= std_logic_vector(sync_time_code(15 downto 8)); 
                               sm_state        := SEND_SYNC_REQUEST;    
                        elsif( byte_count = 7)
                           then
                               tdata <= std_logic_vector(sync_time_code(7 downto 0));
                               sm_state        := SEND_SYNC_REQUEST;      
                        elsif( byte_count = 8)
                           then 
                               tdata <= X"FF";  
                               sm_state        := SEND_SYNC_REQUEST;      
                        elsif( byte_count >= m_time_sync_payload_length-1)
                           then 
                               tdata <=  X"FF";   
                               sm_state        := WAIT_SYNC_RESPONSE;
                               sync_req_pkt_seq_reg <= sync_req_pkt_seq_reg + 1;  
                               tlast <= '1'; 
                               hdr_valid <= '0';  
                        else
                            sm_state        := SEND_SYNC_REQUEST;
                            tdata <= X"FF";          
                           end   if; 
                                
                    if(m_time_sync_axis_tready = '1') then                                
                               byte_count := byte_count + 1;   
                    else
                        sm_state        := SEND_SYNC_REQUEST;
                        tdata <= tdata;                          
                    end if;
                              
                                     
                    when SEND_TMS_REQUEST =>    
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= '1';
                        tuser <= '0';
                        
                           
                           if( byte_count = 0) then
                               
                                   tdata <=    X"AA"; -- pkt type
                                   sm_state        := SEND_TMS_REQUEST;   
                            elsif( byte_count = 1) then 
                                   tdata <=   X"01";-- pkt src id will be made dynamic
                                   sm_state        := SEND_TMS_REQUEST;  
                           elsif( byte_count = 2) then
                               
                                   tdata <=    tms_request_magic_byte; 
                                   sm_state        := SEND_TMS_REQUEST;  
                             elsif( byte_count = 3) then 
                                   
                                   tdata <=   std_logic_vector(tms_req_pkt_seq_reg);-- sync_request_magic_byte; 
                                   sm_state        := SEND_TMS_REQUEST; 
                            elsif( byte_count = 4) then 
                                   tdata <=   std_logic_vector(sync_time_code(31 downto 24));-- sync_request_magic_byte; 
                                   sm_state        := SEND_TMS_REQUEST;  
                            elsif( byte_count = 5)
                               then 
                                   tdata <=  std_logic_vector(sync_time_code(23 downto 16));-- sync_request_magic_byte;
                                   sm_state        := SEND_TMS_REQUEST; 
                            elsif( byte_count = 6)
                               then 
                                   tdata <= std_logic_vector(sync_time_code(15 downto 8)); -- sync_request_magic_byte;
                                   sm_state        := SEND_TMS_REQUEST;    
                            elsif( byte_count = 7)
                               then
                                   tdata <= std_logic_vector(sync_time_code(7 downto 0));--    sync_request_magic_byte; 
                                   sm_state        := SEND_TMS_REQUEST;    
                            elsif( byte_count = 8)
                               then
                                   tdata <= tms_interval_count(31 downto 24);--    sync_request_magic_byte; 
                                   sm_state        := SEND_TMS_REQUEST;
                            elsif( byte_count = 9)
                               then
                                   tdata <= tms_interval_count(23 downto 16);--    sync_request_magic_byte; 
                                   sm_state        := SEND_TMS_REQUEST;  
                            elsif( byte_count = 10)
                               then
                                   tdata <= tms_interval_count(15 downto 8);--    sync_request_magic_byte; 
                                   sm_state        := SEND_TMS_REQUEST;
                            elsif( byte_count = 11)
                               then
                                   tdata <= tms_interval_count(7 downto 0);--    sync_request_magic_byte; 
                                   sm_state        := SEND_TMS_REQUEST;
                            elsif( byte_count = 12)
                               then 
                                   tdata <= X"FF";  
                                   sm_state        := SEND_TMS_REQUEST;      
                            elsif( byte_count >= m_time_sync_payload_length-1)
                               then 
                                   tdata <=  X"FF";   
                                   sm_state        := WAIT_TMS_RESPONSE;
                                     
                                   tlast <= '1';  
                                   hdr_valid <= '0'; 
                                   tms_req_pkt_seq_reg <= tms_req_pkt_seq_reg + 1;
                            else
                                sm_state        := SEND_TMS_REQUEST;
                                tdata <= tdata;          
                               end   if;  
                    if(m_time_sync_axis_tready = '1') then                                
                               byte_count := byte_count + 1;   
                    else
                        sm_state        := SEND_TMS_REQUEST;
                        tdata <= tdata;                          
                    end if;
                    
                    
                     when SEND_MOCK_REQUEST =>    
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= '1';
                        tuser <= '0';
                        initial_mock_tc_reg <= sync_time_code;
                        
                           if( byte_count = 0) then
                                   
                                   tdata <=    X"FF"; -- pkt type dummy just to punch firewall
                                   sm_state        := SEND_MOCK_REQUEST;   
                            elsif( byte_count = 1) then 
                                   tdata <=   X"FF";-- pkt src id will be made dynamic
                                   sm_state        := SEND_MOCK_REQUEST;  
                           elsif( byte_count = 2) then
                               
                                   tdata <=    X"FF"; 
                                   sm_state        := SEND_MOCK_REQUEST;   
                            elsif( byte_count = 3) then 
                                   tdata <=   X"FF"; --std_logic_vector(mock_req_pkt_seq_reg);-- sync_request_magic_byte; 
                                   sm_state        := SEND_MOCK_REQUEST; 
                            elsif( byte_count = 4) then 
                                   tdata <=   std_logic_vector(sync_time_code(31 downto 24));-- sync_request_magic_byte; 
                                   sm_state        := SEND_MOCK_REQUEST;  
                            elsif( byte_count = 5)
                               then 
                                   tdata <=  std_logic_vector(sync_time_code(23 downto 16));-- sync_request_magic_byte;
                                   sm_state        := SEND_MOCK_REQUEST; 
                            elsif( byte_count = 6)
                               then 
                                   tdata <= std_logic_vector(sync_time_code(15 downto 8)); -- sync_request_magic_byte;
                                   sm_state        := SEND_MOCK_REQUEST;    
                            elsif( byte_count = 7)
                               then
                                   tdata <= std_logic_vector(sync_time_code(7 downto 0));--    sync_request_magic_byte; 
                                   sm_state        := SEND_MOCK_REQUEST;    
                            elsif( byte_count = 8)
                               then
                                   tdata <= tms_interval_count(31 downto 24);--    sync_request_magic_byte; 
                                   sm_state        := SEND_MOCK_REQUEST;
                            elsif( byte_count = 9)
                               then
                                   tdata <= tms_interval_count(23 downto 16);--    sync_request_magic_byte; 
                                   sm_state        := SEND_MOCK_REQUEST;  
                            elsif( byte_count = 10)
                               then
                                   tdata <= tms_interval_count(15 downto 8);--    sync_request_magic_byte; 
                                   sm_state        := SEND_MOCK_REQUEST;
                            elsif( byte_count = 11)
                               then
                                   tdata <= tms_interval_count(7 downto 0);--    sync_request_magic_byte; 
                                   sm_state        := SEND_MOCK_REQUEST;
                            elsif( byte_count = 12)
                               then 
                                   tdata <= X"FF";  
                                   sm_state        := SEND_MOCK_REQUEST;      
                            elsif( byte_count >= m_time_sync_payload_length-1)
                               then 
                                   tdata <=  X"FF";   
--                                   sm_state        := IDLE;
                                   sm_state        := mock_return_state;
--                                   pkt_seq_reg <= pkt_seq_reg + 1;    
                                   tlast <= '1';
                                   hdr_valid <= '0';  
                            else
                                sm_state        := SEND_MOCK_REQUEST;
                                tdata <= tdata;          
                               end   if;  
                               
                   if(m_time_sync_axis_tready = '1') then                                 
                         byte_count := byte_count + 1;   
                    else
                        sm_state        := SEND_MOCK_REQUEST;
                        tdata <= tdata;                          
                    end if;    
                        
                    
                    when  SEND_SYNC_RESPONSE=>
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= '1';
                        tuser <= '0';
                        
                        
                           if( byte_count = 0) then
                               
                                   tdata <=    X"AA"; -- pkt type
                                   sm_state        := SEND_SYNC_RESPONSE;   
                            elsif( byte_count = 1) then 
                                   tdata <=   X"01";-- pkt src id will be made dynamic
                                   sm_state        := SEND_SYNC_RESPONSE;  
                           elsif( byte_count = 2) then
                                   tdata <=    sync_response_magic_byte; 
                                   sm_state        := SEND_SYNC_RESPONSE;   
                           elsif( byte_count = 3) then 
                                   tdata <=   rx_sync_req_pkt_seq_reg;
                                   sm_state        := SEND_SYNC_RESPONSE;
                            elsif( byte_count = 4)
                               then 
                                   tdata <=   std_logic_vector(sync_time_code(31 downto 24)); 
                                   sm_state        := SEND_SYNC_RESPONSE;  
                            elsif( byte_count = 5)
                               then 
                                   tdata <=  std_logic_vector(sync_time_code(23 downto 16)); 
                                   sm_state        := SEND_SYNC_RESPONSE; 
                            elsif( byte_count = 6)
                               then
                                   tdata <= std_logic_vector(sync_time_code(15 downto 8));  
                                   sm_state        := SEND_SYNC_RESPONSE;    
                            elsif( byte_count = 7)
                               then 
                                   tdata <=  std_logic_vector(sync_time_code(7 downto 0)); 
                                   sm_state        := SEND_SYNC_RESPONSE;   
                             elsif( byte_count = 8)
                               then 
                                   tdata <=   std_logic_vector(last_rx_req_packt_tc(31 downto 24)); 
                                   sm_state        := SEND_SYNC_RESPONSE;  
                            elsif( byte_count = 9)
                               then 
                                   tdata <=  std_logic_vector(last_rx_req_packt_tc(23 downto 16)); 
                                   sm_state        := SEND_SYNC_RESPONSE; 
                            elsif( byte_count = 10)
                               then
                                   tdata <= std_logic_vector(last_rx_req_packt_tc(15 downto 8));  
                                   sm_state        := SEND_SYNC_RESPONSE;    
                            elsif( byte_count = 11)
                               then 
                                   tdata <=  std_logic_vector(last_rx_req_packt_tc(7 downto 0)); 
                                   sm_state        := SEND_SYNC_RESPONSE;       
                             elsif( byte_count = 12)
                               then
                                   tdata <=    X"FF";  
                                   sm_state  := SEND_SYNC_RESPONSE;    
                            elsif( byte_count >= m_time_sync_payload_length-1) then 
                                   tdata <=    X"FF";   
                                   sm_state  := resp_return_state; 
                                   sync_response_done_reg <= '1';
                                   tlast <= '1';  
                                   hdr_valid <= '0';  
                            else
                                sm_state        := SEND_SYNC_RESPONSE;
                                tdata <= tdata;          
                            end  if;                                
                        if(m_time_sync_axis_tready = '1') then                             
                           byte_count := byte_count + 1; 
                        else
                            sm_state        := SEND_SYNC_RESPONSE;
                            tdata <= tdata;                                 
                        end if;
                    when  SEND_TMS_RESPONSE=>
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= '1';
                        tuser <= '0';
                        oneway_delay_accum_reg <= X"0000_0000";
                        
                           if( byte_count = 0) then
                               
                                   tdata <=    X"AA"; -- pkt type
                                   sm_state        := SEND_TMS_RESPONSE;   
                            elsif( byte_count = 1) then 
                                   tdata <=   X"01";-- pkt src id will be made dynamic
                                   sm_state        := SEND_TMS_RESPONSE;  
                           elsif( byte_count = 2) then
                                   tdata <=    tms_response_magic_byte; 
                                   sm_state        := SEND_TMS_RESPONSE;   
                            elsif( byte_count = 3) then 
                                    tdata <=    std_logic_vector(to_unsigned(pktcount, 8)); 
                                   sm_state        := SEND_TMS_RESPONSE;  
                            elsif( byte_count = 4)
                               then 
                                   tdata <=   std_logic_vector(sync_time_code(31 downto 24)); -- sync_response_magic_byte;
                                   sm_state        := SEND_TMS_RESPONSE;  
                            elsif( byte_count = 5)
                               then 
                                   tdata <=  std_logic_vector(sync_time_code(23 downto 16)); -- sync_response_magic_byte;
                                   sm_state        := SEND_TMS_RESPONSE; 
                            elsif( byte_count = 6)
                               then
                                   tdata <= std_logic_vector(sync_time_code(15 downto 8));  -- sync_response_magic_byte;
                                   sm_state        := SEND_TMS_RESPONSE;    
                            elsif( byte_count = 7)
                               then 
                                   tdata <=  std_logic_vector(sync_time_code(7 downto 0));  --   sync_response_magic_byte;
                                   sm_state        := SEND_TMS_RESPONSE;     
                             elsif( byte_count = 8)
                               then
                                   tdata <=    X"FF";  
                                   sm_state  := SEND_TMS_RESPONSE;    
                            elsif( byte_count >= m_time_sync_payload_length-1) then 
                                   tdata <=    X"FF";   
--                                   sm_state  := IDLE; 
                                   sm_state := WAIT_TMS_INTERVAL;
                                   tlast <= '1'; 
                                   hdr_valid <= '0';  
                                   pktcount := pktcount + 1;  
                            else
                                sm_state        := SEND_TMS_RESPONSE;
                                tdata <=   X"FF";          
                            end  if;                                
                       if(m_time_sync_axis_tready = '1') then                              
                           byte_count := byte_count + 1; 
                        else
                            sm_state        := SEND_TMS_RESPONSE;
                            tdata <= tdata;                                 
                        end if;
                    when WAIT_TMS_INTERVAL =>
                        sm_state := WAIT_TMS_INTERVAL;
                       -- pktcount := pktcount;
                        tvalid            <= '0';
                        tlast             <= '0';  
                        hdr_valid <= '0';
                        byte_count := 0;
                        if((oneway_delay_accum >= oneway_delay_count-1) or (pktcount >= 16)) then -- waits for a max of 1 second
                           sm_state  := IDLE;                           
                           pktcount := 0;
                           oneway_delay_accum_reg <= X"0000_0000";
                       else
                       
                          if(oneway_delay_accum >= unsigned(tms_interval_count)-1) then
                            sm_state        := SEND_TMS_RESPONSE;
                            tms_responded_reg <= '1';
                            hdr_valid <= '1';
                          else
                            sm_state := WAIT_TMS_INTERVAL;
--                            tms_responded_reg <= '1';
                          end if; 
                          
                           oneway_delay_accum_reg <= unsigned(oneway_delay_accum) + 1;   
                                
                                
                       end if;   
                        
                    when    WAIT_TMS_RESPONSE=>
                        tvalid            <= '0';
                        tlast             <= '0';
--                        initiate_tms_response_out <= '0';
                        hdr_valid <= '0';
                        tuser <= '0'; 
--                        initiate_tms_request_out <= '0';     
                       sm_state  := WAIT_TMS_RESPONSE;
                       byte_count := 0;
                       
                       
                       if(oneway_delay_accum >= oneway_delay_count-1) then -- waits for a max of 1 second
                           sm_state  := IDLE;
                           hdr_valid <= '0';
                           oneway_delay_accum_reg <= X"0000_0000";
                       else
                           
                           oneway_delay_accum_reg <= unsigned(oneway_delay_accum) + 1;   
                                        
                       end if;   
                       
                    when  WAIT_SYNC_RESPONSE=>
                        tvalid            <= '0';
                        tlast             <= '0';
                        initiate_sync_response_out <= '0';
                        hdr_valid <= '0';
                        tuser <= '0'; 
                        initiate_sync_request_out <= '0';
                        sync_request_initiated <= '0';        
                       sm_state  := WAIT_SYNC_RESPONSE;
                       resp_return_state := WAIT_SYNC_RESPONSE;
                       mock_return_state := WAIT_SYNC_RESPONSE;
                       byte_count := 0;
                       waiting_for_response <= '1'; 
                       sync_responded_reg <= '0';
                       if (sync_response_trigger = '1')  then   
                            sm_state        :=  SEND_SYNC_RESPONSE;                                                                              
                            hdr_valid <= '1';
                            sync_response_done_reg <= '0';
                            initiate_sync_response_out <= '1';
                            sync_responded_reg <= '1';   
                            corresp_pkt_seq_reg <= corresp_pkt_seq_reg;  
--                       elsif (tms_response_trigger = '1')  then   
--                            sm_state        :=  SEND_TMS_RESPONSE;                                                                              
--                            hdr_valid <= '1';
----                            initiate_sync_response_out <= '1';
--                            tms_responded_reg <= '1';   
--                            corresp_pkt_seq_reg <= corresp_pkt_seq_reg;   
                       elsif(round_trip_delay_accum >= round_trip_delay_count-1) then
                           sm_state  := IDLE;
                           hdr_valid <= '0'; 
                           round_trip_delay_accum_reg <= X"0000_0000";
                           waiting_for_response <= '0';
                       elsif(sync_done = '1') then
                       
                            sm_state  := IDLE;
                           hdr_valid <= '0'; 
                           round_trip_delay_accum_reg <= X"0000_0000";
                           waiting_for_response <= '0';
                       
                       else 
--                                round_trip_delay_accum_reg <= unsigned(round_trip_delay_accum) + 1;  
                            if(((unsigned(initial_mock_tc) = X"0000_0000") or (send_mock_pkt = '1')) and (media_pkt_tx_en_in = '0')) then
                                sm_state        := SEND_MOCK_REQUEST; 
    --                            initiate_sync_request_out <= '1';
                                initial_mock_tc_reg <= sync_time_code;                         
                                hdr_valid <= '1';
                                  
                            else
                                sm_state        := WAIT_SYNC_RESPONSE;  
                                hdr_valid <= '0';    
                            end if; 
                            
                       end if;   
                       
                       
                       
                       
                                                                                                    
                    when others =>                                                                   
                      sm_state := IDLE; 
                      add_seq         <= '1';
                      packet_len_cnt    <= packet_len_cnt;
                      packet_count_cnt <= packet_count_cnt;
--                      adcLeftDataTmp <= adcLeftDataTmp;
--                        adcRightDataTmp <= adcRightDataTmp;
                      hdr_valid <= hdr_valid; 
                      byte_count := 0;
                      tvalid            <= '0';
                        tlast           <= '0';
                        tuser <= '0'; 
                        tdata <= (others => '0');  
                        packet_count_cnt <= packet_count_cnt;                                                                                                                                                       
                  end case; 
                  
                  

                  
                  
                  if(tvalid = '1' and tlast = '1' and m_time_sync_axis_tready = '1') then
                    out_packet_count <= out_packet_count + 1;
                  else
                    out_packet_count <= out_packet_count;
                  end if;
              
              
--      else
      
--        sm_state :=  sm_state;
--        hdr_valid <= hdr_valid;
----        adcLeftDataTmp <= adcLeftDataTmp;
----        adcRightDataTmp <= adcRightDataTmp;
--        packet_len_cnt    <= packet_len_cnt;
--        packet_count_cnt <= packet_count_cnt;
--        tvalid            <= '0';
--        tlast           <= '0';
--        tuser <= '0'; 
--        tdata <= (others => '0'); 
      end if;
      
      out_state_val <= std_logic_vector(to_unsigned(state'POS(sm_state), out_state_val'length)) ; 
      
--      if (resetADCLeftFifo='1' or resetADCLeftFifo ='1') then
--            sm_state          := IDLE;
--              delay             <= reset_delay;
--              tvalid            <= '0';
--              tlast             <= '0';
--              tuser             <= '0';   
--              hdr_valid         <= '0';
----              adcLeftDataTmp    <=  (others => '0');
----              adcRightDataTmp   <= (others => '0');
----              leftTest24Bit     <= (others => '0');
----              rightTest24Bit    <= (others => '0');
--              tdata <= (others => '0'); 
--              packet_len_cnt    <= (others => '0');
--              packet_count_cnt    <= (others => '0');
--              add_seq <= '1';
--      end if;
                                                                                  
--    end if; 
                                                                               
  end process audio_to_eth;      
  
  
  
  round_trip_delay_counter: process(CLK_125, s00_axi_aresetn, sync_reset)
begin
    if s00_axi_aresetn = '0'  or sync_reset = '1' then
        round_trip_delay_accum_reg <=     (others=>'0');    
    elsif rising_edge (CLK_125) then
        if( waiting_for_response = '1') then 
            if(round_trip_delay_accum >= round_trip_delay_count-1) then
               round_trip_delay_accum_reg <= round_trip_delay_accum; -- wait for waiting_for_response to go to zero
           else
                round_trip_delay_accum_reg <= unsigned(round_trip_delay_accum) + 1;   
           end if;  
       else 
            round_trip_delay_accum_reg <= X"0000_0000";
       end if;
    end if;
end process;           



-- S AXIS Reader Process
    s_axis_reader: process(CLK_125, s00_axi_aresetn, sync_reset) is
        type state_type is (IDLE, DECODE_PKT_TYPE, PROC_TC_SYNC_REQUEST, PROC_TC_SYNC_RESPONSE, PROC_TC_TMS_REQUEST, PROC_TC_TMS_RESPONSE, DUMP_TC_SYNC_PKT);
    variable state : state_type := IDLE;
        variable bytecount : integer range 0 to 2000 := 0;
        variable hdrbytecount : integer range 0 to 32 := 0;
        variable tms_pkt_count : integer range 0 to 255 := 0;
        
        
    begin
    

            
            if s00_axi_aresetn = '0' or sync_reset = '1' then
                -- Reset
                state := IDLE;
                bytecount := 0;
                tms_pkt_count := 0;
                status2_out <= '0';
                status1_out <= '0';
--                hdrbytecount <= (others => '0');
                hdrbytecount := 0;
                s_time_sync_hdr_ready <= '0';
                sync_request_rx_out <= '0';
                  tc_adjust_reg <= '0';
                  sync_done_reg <= '0';
                  tms_done_reg <= '0';
                  s_tready <= '0';
                  round_path_delay_reg <=  (others => '0');
                  round_path_delay_2_high <= '0';
                sync_response_trigger_reg <= '0';--// causes TC response
                 tms_response_trigger_reg <= '0';
                 rx_sync_req_pkt_seq_reg <= X"00";    
                
                  clk_offset_dir <= '0';
                  in_packet_count <= x"0000_0000";
                  tc_count_rx_reg <= X"0000_0000";
                  orig_tc_count_rx_reg  <= X"0000_0000";
                  pkt_is_expected <= '0';
                   
                
            elsif rising_edge(CLK_125) then
                
                
                --tready <= '0';
                --hdr_ready <= '0';
                case state is
                    when IDLE =>                           
                      bytecount := 0;
                      tms_pkt_count := 0; 
                      pkt_is_expected <= '0';
                      s_time_sync_hdr_ready <= '1';
--                      s_tready <= '0';
                      tc_adjust_reg <= '0';
--                      if (s_time_sync_axis_tvalid = '1') then
                          state :=  DECODE_PKT_TYPE;
                          s_tready <= '1';
--                          s_time_sync_hdr_ready <= '1'; // must not depend to tvalid leads to a race condition (chicken and egg issue)
--                          sync_response_trigger_reg <= '1';
                          
--                      else
                       
--                          state :=  IDLE;
--                          s_tready <= '0';
--                          sync_response_trigger_reg <= '0';
                          
                          
--                        end if;    
                    when DECODE_PKT_TYPE =>
                        s_tready <= '1';
                        s_time_sync_hdr_ready <= '1';
                        status1_out <= '1';
                        pkt_is_expected <= '0';
                        bytecount := 0;
--                        status2_out <= '0';
                        if s_time_sync_axis_tvalid = '1' then
                            if(s_time_sync_axis_tdata = sync_request_magic_byte) then
                               state := PROC_TC_SYNC_REQUEST; 
                               sync_request_rx_out <= '1';                     
                               
                           
                           elsif(s_time_sync_axis_tdata = sync_response_magic_byte) then
                               state := PROC_TC_SYNC_RESPONSE;                          
--                               round_path_delay_reg <= sync_time_code - initial_tc;
                               
                               
                               
                                
                           elsif(s_time_sync_axis_tdata = tms_request_magic_byte) then
                               state := PROC_TC_TMS_REQUEST; 
                               --tms_request_rx_out <= '1';                     
                               tms_response_trigger_reg <= '1';--// causes TMS response packets to be sent
                           
                           elsif(s_time_sync_axis_tdata = tms_response_magic_byte) then
                               state := PROC_TC_TMS_RESPONSE;                          
                               oneway_path_delay_reg <= X"0000_0000";
                               
--                               if (sync_time_code < initial_tc) then
--                                  oneway_path_delay_reg <= TC_DEPTH - (initial_tc - sync_time_code);
--                                else
--                                  oneway_path_delay_reg <= sync_time_code - initial_tc;
--                                end if;
                          
                           else
                               state := DUMP_TC_SYNC_PKT;
                           end if;
                       else	
--                            if(decode_unblock_delay_accum >= decode_unblock_delay_count-1) then
--                               state  := IDLE;
--                                s_tready <= '0';
--                               decode_unblock_delay_accum_reg <= X"0000_0000";
--                           else
                                state := DECODE_PKT_TYPE;  
--                               decode_unblock_delay_accum_reg <= unsigned(decode_unblock_delay_accum) + 1;   
--                           end if;   
                       end if; 
                        
                   when PROC_TC_SYNC_REQUEST =>
                        s_tready <= '1';
                        s_time_sync_hdr_ready <= '1';
                        if s_time_sync_axis_tvalid = '1' then
                            
                            if( bytecount = 0) then 
                                    rx_sync_req_pkt_seq_reg <= s_time_sync_axis_tdata; 

                            elsif( bytecount = 1) then 
                                   last_rx_req_packt_tc(31 downto 24) <= s_time_sync_axis_tdata;        
                            elsif( bytecount = 2) then 
                                   last_rx_req_packt_tc(23 downto 16) <= s_time_sync_axis_tdata;                          
                            elsif( bytecount = 3) then
                                   last_rx_req_packt_tc(15 downto 8) <= s_time_sync_axis_tdata;   
                            elsif( bytecount = 4) then
                                   last_rx_req_packt_tc(7 downto 0) <= s_time_sync_axis_tdata;      
                            else
                                state  := PROC_TC_SYNC_REQUEST;   
--                                rx_sync_req_pkt_seq_reg <= rx_sync_req_pkt_seq_reg;    
                             end if;
                             
                             
                             if (s_time_sync_axis_tlast = '1') then
                                state := IDLE;	
                                s_time_sync_hdr_ready <= '0';  
                                s_tready <= '0';
                                rx_sync_req_pkt_seq_reg <= rx_sync_req_pkt_seq_reg;
                                sync_response_trigger_reg <= '1';--// causes TC response
                              end if;
                             
                             
                             bytecount := bytecount + 1;
                         else
                            state  := PROC_TC_SYNC_REQUEST; 
                            bytecount := bytecount;
                            rx_sync_req_pkt_seq_reg <= rx_sync_req_pkt_seq_reg; 
                         end if;
                         
                        

                        
                    when PROC_TC_SYNC_RESPONSE =>
                            s_tready <= '1';
                            s_time_sync_hdr_ready <= '1';
                            pkt_is_expected <= '1';
                            if (s_time_sync_axis_tlast = '1' and s_time_sync_axis_tvalid = '1')
                             then
                                state := IDLE;
                                s_tready <= '0';
                                s_time_sync_hdr_ready <= '0';
                                if(pkt_is_expected = '1' and round_path_delay_2_high = '0') then
--                                if(round_path_delay_2_high = '0') then
                                    sync_done_reg <= '1';
                                 else
                                    sync_done_reg <= '0';
                                 end if;
                                 tc_adjust_reg <= '0';   
                                 bytecount := 0;
                            else
                                state  := PROC_TC_SYNC_RESPONSE; 
                                if (s_time_sync_axis_tvalid = '1') then 
                                    if( bytecount = 0)
                                       then 
                                       
                                      if(s_time_sync_axis_tdata = corresp_pkt_seq_reg) then
                                      
                                             pkt_is_expected <= '1';
                                      else
                                            pkt_is_expected <= '1';
                                      
                                      end if;
                          
                                    elsif( bytecount = 1) then 
                                           tc_count_rx_reg(31 downto 24) <= s_time_sync_axis_tdata;        
                                    elsif( bytecount = 2) then 
                                           tc_count_rx_reg(23 downto 16) <= s_time_sync_axis_tdata;                          
                                    elsif( bytecount = 3) then
                                           tc_count_rx_reg(15 downto 8) <= s_time_sync_axis_tdata;   
                                    elsif( bytecount = 4) then
                                           tc_count_rx_reg(7 downto 0) <= s_time_sync_axis_tdata;    
                                    elsif( bytecount = 5) then 
                                           orig_tc_count_rx_reg(31 downto 24) <= s_time_sync_axis_tdata;        
                                    elsif( bytecount = 6) then 
                                           orig_tc_count_rx_reg(23 downto 16) <= s_time_sync_axis_tdata;                          
                                    elsif( bytecount = 7) then
                                           orig_tc_count_rx_reg(15 downto 8) <= s_time_sync_axis_tdata;   
                                    elsif( bytecount = 8) then
                                           orig_tc_count_rx_reg(7 downto 0) <= s_time_sync_axis_tdata;  
                                           
                                    elsif( bytecount = 9) then       
--                                           if (sync_time_code < initial_tc) then
--                                              round_path_delay_reg <= TC_DEPTH - (initial_tc - sync_time_code);
--                                            else
--                                              round_path_delay_reg <= sync_time_code - initial_tc;
--                                            end if; 
                                            
                                            
                                             if (sync_time_code < orig_tc_count_rx) then
                                              round_path_delay_reg <= TC_DEPTH - (orig_tc_count_rx - sync_time_code);
                                            else
                                              round_path_delay_reg <= sync_time_code - orig_tc_count_rx;
                                            end if; 
                                                     
                                    elsif( bytecount = 10) then    
                                    
                                            if (round_path_delay_reg < X"0000_12C0") then
--                                                if (((sync_time_code >= orig_tc_count_rx) and (sync_time_code - orig_tc_count_rx < X"0000_12C0")) ) then
                                                sync_time_code_adj <= unsigned(half_path_delay) + unsigned(tc_count_rx);
                                               if((unsigned(half_path_delay) + unsigned(tc_count_rx)) > sync_time_code) then
                                                    clk_offset_reg <= (unsigned(half_path_delay) + unsigned(tc_count_rx)) - sync_time_code;
                                                    clk_offset_dir <= '0';
                                               else
                                                    clk_offset_reg <= sync_time_code - (unsigned(half_path_delay) + unsigned(tc_count_rx));
                                                    clk_offset_dir <= '1';
                                               end if;
                                               tc_adjust_reg <= '1';
                                               round_path_delay_2_high <= '0';
                                            else
                                              tc_adjust_reg <= '0';
                                              sync_time_code_adj <= sync_time_code_adj;
                                               clk_offset_reg <=  clk_offset_reg;
                                               round_path_delay_2_high <= '1';
                                            end if;                        
                                                                     
                                   elsif( bytecount = 11) then 
                                            sync_time_code_adj <= sync_time_code_adj;
                                            tc_adjust_reg <= tc_adjust_reg;
                                   else
                                            sync_time_code_adj <= sync_time_code_adj;
                                            tc_adjust_reg <= tc_adjust_reg;
                                               
                                   end if;
                                
                                                      
                                    bytecount := bytecount + 1;  
                                else
                                    bytecount := bytecount;
                                end if;                         
                                                                   
                               
                              end if;
                    when PROC_TC_TMS_REQUEST =>
                        s_tready <= '1';
                        s_time_sync_hdr_ready <= '1';
                       if (s_time_sync_axis_tlast = '1') then
                            state := IDLE;	
                            s_time_sync_hdr_ready <= '0';  
                            s_tready <= '0';
                            bytecount := 0;          
                          
                        else
                         
                                state  := PROC_TC_TMS_REQUEST; 
                                bytecount := bytecount + 1;       
                         end if;

                        
                    when PROC_TC_TMS_RESPONSE =>
                            s_tready <= '1';
                            s_time_sync_hdr_ready <= '1';
                            avg_i_data_valid <= '0';
                            if (s_time_sync_axis_tlast = '1')  then
                                if (tms_pkt_count >= 15) then 
                                    state := IDLE;
                                    s_tready <= '0';
                                    s_time_sync_hdr_ready <= '0';
                                     tms_done_reg <= '1';
                                     --tc_adjust_reg <= '0';   
                                     bytecount := 0;
                                     tms_pkt_count := 0;
                                 else
                                    state := DECODE_PKT_TYPE;	
                                    s_time_sync_hdr_ready <= '0';                                
                                    s_tready <= '0';
                                    --tms_done_reg <= '0';
                                    bytecount := 0; 
                                    tms_pkt_count := tms_pkt_count + 1;   
                                 end if;
                            
                            else
                                state  := PROC_TC_TMS_RESPONSE; 
                                if (s_time_sync_axis_tvalid = '1') then 
                                    if( bytecount = 0) -- after removel of magic byte
                                       then 
                                           last_tms_pkt_seq <= tms_pkt_seq;
                                           tms_pkt_seq <= unsigned(s_time_sync_axis_tdata); 
                                     elsif( bytecount = 1) then 
                                           tc_count_rx_reg(31 downto 24) <= s_time_sync_axis_tdata;         
                                    elsif( bytecount = 2) then 
                                           tc_count_rx_reg(23 downto 16) <= s_time_sync_axis_tdata;                          
                                    elsif( bytecount = 3) then
                                       
                                           tc_count_rx_reg(15 downto 8) <= s_time_sync_axis_tdata;   
                                   
                                    elsif( bytecount = 4) then
                                           tc_count_rx_reg(7 downto 0) <= s_time_sync_axis_tdata;  
                                               
                                    elsif( bytecount = 5) then 
                                           tms_interval_count_rx_reg(31 downto 24) <= s_time_sync_axis_tdata; 
                                             
                                    elsif( bytecount = 6) then 
                                           tms_interval_count_rx_reg(23 downto 16) <= s_time_sync_axis_tdata;                          
                                    elsif( bytecount = 7) then
                                       
                                           tms_interval_count_rx_reg(15 downto 8) <= s_time_sync_axis_tdata;   
                                   
                                    elsif( bytecount = 8) then
                                           tms_interval_count_rx_reg(7 downto 0) <= s_time_sync_axis_tdata;  
                                               
                                    elsif( bytecount = 9) then                           
--                                           sync_time_code_adj <= unsigned(half_path_delay) + unsigned(tc_count_rx);   
                                           if (sync_time_code >= unsigned(tc_count_rx)) then
                                                oneway_path_delay_reg <= sync_time_code - unsigned(tc_count_rx);
                                           else -- this could be a problem due to assymetry -- we can reduce effect by using pod offset ...
                                                oneway_path_delay_reg <= TC_DEPTH - (unsigned(tc_count_rx)- sync_time_code);
                                           end if;
                                           
                                           avg_i_data_valid <= '1';
                                                                 
                                   elsif( bytecount = 10) then 
                                            sync_time_code_adj <= sync_time_code_adj;
                                            tc_adjust_reg <= tc_adjust_reg;
                                  
                                   else
                                            sync_time_code_adj <= sync_time_code_adj;
                                            tc_adjust_reg <= tc_adjust_reg;
                                               
                                   end if;
                                
                                                      
                                    bytecount := bytecount + 1;  
                                else
                                    bytecount := bytecount;
                                end if;                         
                                                                   
                               
                              end if;
                    
                    when DUMP_TC_SYNC_PKT =>
                        s_tready <= '1';
                        status2_out <= '1';
                        if (s_time_sync_axis_tlast = '1') then
                            state := IDLE;
                            s_tready <= '0';
                            bytecount := 0;
                          
                        else                                                   
                           state := DUMP_TC_SYNC_PKT;
                       end if;
                    
                       
                   when others =>
                        
                        state := IDLE;
                        s_tready <= '0';
                        
                end case;
                
--                 if(initiate_sync_request = '0') then
--                   sync_done_reg <= '0';
--                 end if;
                 
                 if(initiate_tms_request = '0') then
                   tms_done_reg <= '0';
                 end if;
                
                
                if(sync_responded = '1') then
                       sync_response_trigger_reg <= '0';	    
                end if;
                
                
                if(tms_responded = '1') then
                       tms_response_trigger_reg <= '0';	    
                end if;
                
                
                if(s_time_sync_axis_tvalid = '1' and s_time_sync_axis_tlast = '1' and s_tready = '1') then
                    in_packet_count <= in_packet_count + 1;
                  else
                    in_packet_count <= in_packet_count;
                  end if;
                
                
                in_state_val <= std_logic_vector(to_unsigned(state_type'POS(state), in_state_val'length)) ; 
                            
           
        end if;

            
end process;
    

    
   
-- This syncronises the newsample_in signal to the axis 125MHz clock
newsample_delay: process(CLK_125, s00_axi_aresetn)
begin
    if s00_axi_aresetn = '0' then
        newsample_reg <= '0';        
    elsif rising_edge (CLK_125) then
        newsample_reg <= newsample_in;
    end if;
end process;

    newsample_125 <= (newsample_in xor newsample_reg) when (newsample_in='1') else '0';
    
    
    
    tc_sync_count_process: process(CLK_125, s00_axi_aresetn)
    begin
        if s00_axi_aresetn = '0'  then
           sync_time_code <= (others=>'0');  
        elsif rising_edge (CLK_125) then
            if ((newsample_125 = '1') and (tc_sync_en = '1') and (tc_adjust = '0')) then
                sync_time_code <= sync_time_code + 1; 
            elsif (tc_adjust = '1') then
                sync_time_code <= sync_time_code_adj + 1;     
            elsif (tc_sync_en = '0') then
                sync_time_code <= (others=>'0');     
            end if; 
        end if;
    end process;
    
    
    
    
path_tc_process: process(CLK_125, s00_axi_aresetn)
    begin
        if s00_axi_aresetn = '0'  then
           path_data_valid <= '0';
           media_round_path_delay <= (others=>'0');  
           path_avg_sync_rst <= '0'; 
           path_m_counter <= (others=>'0');  
        elsif rising_edge (CLK_125) then
            
            
            
            if (path_tc_valid_in = '1' and media_pkt_tx_en_in = '1') then
--                media_round_path_delay <= sync_time_code - unsigned(path_tx_tc_code_in);
                if (sync_time_code >= unsigned(path_tx_tc_code_in)) then
                    media_round_path_delay <= sync_time_code - unsigned(path_tx_tc_code_in);
                    path_data_valid <= '1';
                    path_m_counter <= path_m_counter + 1;
                else -- this could be a problem due to assymetry -- we can reduce effect by using pod offset ...
--                    media_round_path_delay <= TC_DEPTH - (unsigned(path_tx_tc_code_in)- sync_time_code);
                    path_data_valid <= '0';
                end if;
--                path_data_valid <= '1';
            else
                media_round_path_delay <= media_round_path_delay;   
                path_data_valid <= '0';
                
            end if;
            
            
            
            
            
--            if((( unsigned(path_rx_tc_code_in) > sync_time_code - unsigned(half_media_path_delay_val)) or (sync_time_code  >  unsigned(path_rx_tc_code_in) - unsigned(half_media_path_delay_val)  - unsigned(half_media_path_delay_val))) and (tc_adjust = '0')) then
----            if( tc_adjust = '0')) then -- dont update every time it destroys monotonicity
--                sync_time_code <=  unsigned(path_rx_tc_code_in) + unsigned(half_media_path_delay_val);           
--            end if;

            if(path_m_counter >= 17) then
                path_avg_sync_rst <= '1';  
                path_m_counter <= (others => '0');              
            else
                path_avg_sync_rst <= '0';                
            end if;
              
        
        end if;
    end process;
    
    
    path_dly_mvn_avg_inst : moving_average
    generic map (
      G_NBIT                => TC_BIT_LENGTH ,
      G_AVG_LEN_LOG        => 4  
      )
    port map(
      i_clk                     => CLK_125,
      i_rstb                    => s00_axi_aresetn,
      i_sync_reset              => path_avg_sync_rst,
      -- input
      i_data_ena                => path_data_valid,
      i_data                    => std_logic_vector(media_half_path_delay),
--      i_data                    => std_logic_vector(media_round_path_delay),
      -- output
      o_data_valid             => avg_path_data_valid,
      o_data                   => media_half_path_delay_avg
      );

media_half_path_delay <= '0' & media_round_path_delay( media_round_path_delay'left downto 1 ) ; ---to arithmentic shift right

media_half_path_delay_val <= unsigned(media_half_path_delay_avg) when (avg_path_data_valid = '1' and path_m_counter >= 16) else media_half_path_delay_val;
--half_media_path_delay_val <= '0' & media_path_delay_val( media_path_delay_val'left downto 1 ) ; ---to arithmentic shift right

-- tc_sync_count_process: process(newsample_in, s00_axi_aresetn)
--begin
--    if s00_axi_aresetn = '0'  then
--       sync_time_code <= (others=>'0');  
--    elsif rising_edge (newsample_in) then
--        if ((tc_sync_en = '1') and (tc_adjust = '0')) then
--            sync_time_code <= sync_time_code + 1; 
--        elsif (tc_adjust = '1') then
--            sync_time_code <= sync_time_code_adj + 1;     
--        elsif (tc_sync_en = '0') then
--            sync_time_code <= (others=>'0');     
--        end if; 
          
    
--    end if;
--end process;

--    rDataValid_sig    <= '0' when ((adcLeftFIFOEmpty = '1' or adcRightFIFOEmpty = '1') and (rAdr="00001" or rAdr="00010"))  else '1'; -- Allow reading of status even when FIFO is empty
    -- Payload len used for packaging stream
    

    udp_payload_length <= payload_length;
    payload_length_mirror  <= unsigned(payload_length);
    packet_count_mirror <= unsigned(packet_count);
    

--    // I/O Connections assignments
	sync_response_trigger <= sync_response_trigger_reg;
	tms_response_trigger <= tms_response_trigger_reg;
--	sync_time_code_out <= std_logic_vector(sync_time_code_adj);
    sync_time_code_out <= std_logic_vector(sync_time_code);
    round_path_delay_out <= std_logic_vector(round_path_delay_reg);
    round_trip_delay_accum <= round_trip_delay_accum_reg;
    oneway_delay_accum <= oneway_delay_accum_reg;
    decode_unblock_delay_accum <= decode_unblock_delay_accum_reg;
--	half_path_delay <= round_path_delay_reg sla 1;
--	half_path_delay <= round_path_delay_reg( round_path_delay_reg'left-1 downto 0 ) & '0';---to shigft left with zero padding.
--	half_path_delay <= round_path_delay_reg(round_path_delay_reg'left ) & round_path_delay_reg( round_path_delay_reg'left downto 1 ) ; ---to arithmentic shift right
	half_path_delay <= '0' & round_path_delay_reg( round_path_delay_reg'left downto 1 ) ; ---to arithmentic shift right
	tc_count_rx <= unsigned(tc_count_rx_reg);
	
	sync_done_out <= sync_done_reg or tms_done_reg;
	sync_done <= sync_done_reg;
    sync_responded <= sync_responded_reg;
    
    oneway_path_delay <= oneway_path_delay_reg;
--    tms_done_out <= tms_done_reg;
	tms_done <= tms_done_reg;
    tms_responded <= tms_responded_reg;
    
    tc_adjust <= tc_adjust_reg;
    tc_adjust_out <= tc_adjust_reg;

    tc_sync_en_out <= tc_sync_en;-- make sure tc runs from the word go
    
    initial_tc <= initial_tc_reg;
    initial_mock_tc <=  initial_mock_tc_reg;
    sync_response_done <= sync_response_done_reg;
    initiate_mock_request <= initiate_mock_request_reg;
    orig_tc_count_rx <= unsigned(orig_tc_count_rx_reg);
    
    s_time_sync_axis_tready <= s_tready;
	-- User logic ends
	
	

end arch_imp;
