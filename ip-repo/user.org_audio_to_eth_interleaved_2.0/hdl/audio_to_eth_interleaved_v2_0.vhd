library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library xil_defaultlib;
use xil_defaultlib.sine_package.all;

entity audio_to_eth_interleaved_v2_0 is
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
		PACKET_SEQ_W: natural   :=  16
	);
	port (
		-- Users to add ports here
        line_in_l_in            : in STD_LOGIC_VECTOR(23 downto 0);
        line_in_r_in            : in STD_LOGIC_VECTOR(23 downto 0);
        newsample_in            : in    STD_LOGIC;
--        sample_48k_in           : in    STD_LOGIC;
        irq_out                 : out    STD_LOGIC; 
        tsync_out                : out    STD_LOGIC; 
        sync_en_out             : out    STD_LOGIC; 
        
        tc_sync_en_int_in           : in    STD_LOGIC;
        
        tc_adjust_in : in    STD_LOGIC;
        tc_count_adjust : in STD_LOGIC_VECTOR(TC_BIT_LENGTH-1 downto 0);
--		clk_48                  :  in    STD_LOGIC;
--		-- PS Side
--        IRQ                   : out   STD_LOGIC;
        
        -- Board Side
--          CLK_100               : in    STD_LOGIC;
          CLK_125               : in    STD_LOGIC;  --- AXIS clock
          signal    tx_time_code_out      : out std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
          
          signal    rx_time_code_in      : in std_logic_vector(TC_BIT_LENGTH  -1 downto 0);
          signal    rx_packet_seq_cnt_in : in unsigned(PACKET_SEQ_W-1 downto 0);

		-- User ports ends
		-- Do not modify the ports beyond this line
--         /*
--    * AXIS AUDIO Stream Master (Sending out of the core)
--    */
    
    m_audio_payload_axis_tdata	: out std_logic_vector(AXIS_UDP_DATA_WIDTH-1 downto 0);
    m_audio_payload_axis_tvalid	: out std_logic;
    m_audio_payload_axis_tready	: in std_logic;
    m_audio_payload_axis_tlast	: out std_logic;
    m_audio_payload_axis_tuser	: out std_logic;
    
    m_audio_payload_hdr_valid   : out std_logic;
    m_audio_payload_hdr_ready   : in std_logic;
    
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
end audio_to_eth_interleaved_v2_0;

architecture arch_imp of audio_to_eth_interleaved_v2_0 is

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
	component audio_to_eth_interleaved_v2_0_S00_AXI is
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
	end component audio_to_eth_interleaved_v2_0_S00_AXI;
	
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
    
    component  sine_wave is
  port( clock, resetn, enable: in std_logic;
        wave_out: out sine_vector_type);
end component;


component BUFG is 
port (
    I: in std_logic;
    O: out std_logic
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
    signal writeReg        : std_logic;
    signal wValue          : std_logic_vector(31 downto 0);
    signal wAdr            : std_logic_vector( C_S00_AXI_ADDR_WIDTH-1 downto 2);
    signal wLane           : std_logic_vector( 3 downto 0);
    signal readReg         : std_logic;
    signal rAdr            : std_logic_vector( C_S00_AXI_ADDR_WIDTH-1 downto 2);
    signal rValue          : std_logic_vector(31 downto 0);
    signal rDataValid_sig  : std_logic;
    -- Physical Registers
    signal resetADCLeftFifo     : std_logic;
    signal resetADCRightFifo    : std_logic;
    
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
    
    
    signal leftTest24Bit,rightTest24Bit : unsigned(23 downto 0) := (others => '0');
    
    
    signal packet_seq_cnt : unsigned(PACKET_SEQ_W-1 downto 0):=  x"0000";
    signal add_seq : std_logic := '1';
    
    
    signal tvalid : std_logic := '0';
    signal tdata  : std_logic_vector(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
    
    -- FIFO, Clock Connection
    signal newsample_125, tc_div_125 : std_logic;
--    signal leftIn24Bit,rightIn24Bit : std_logic_vector(23 downto 0);
--    signal adcLeftFIFOData, adcRightFIFOData, adcLeftFIFOReadData, adcRightFIFOReadData  : std_logic_vector(23 downto 0);
    signal adcLeftData, adcRightData : std_logic_vector(23 downto 0);
    signal testLeftData, testRightData : std_logic_vector(23 downto 0);
    signal ethLeftData, ethRightData : std_logic_vector(23 downto 0);
    
    signal adcLeftFIFOEmpty, adcLeftFIFOFull : std_logic;
    signal adcRightFIFOEmpty, adcRightFIFOFull : std_logic;

    signal readADCLeftFifo, readADCRightFifo : std_logic;
    signal readADCLeftFifoEth, readADCRightFifoEth : std_logic;
    
--    signal m_audio_payload_hdr_valid_next : std_logic := '0';
--    signal m_audio_payload_hdr_valid_reg : std_logic  := '0';
    signal tc_div_reg1, tc_div_reg2, tc_div_reg3, tc_div_reg4: std_logic;
    signal tsync_div_gen, tsync_int : std_logic  := '0';
    signal stream_send : std_logic  := '1';
    signal stream_send_final : std_logic  := '1';
    signal test_mode : std_logic := '0';
    signal test_pattern : std_logic_vector(2 downto 0):= b"100";
    signal test_mode_final : std_logic := '0';
    
    signal bytecount : unsigned(3 downto 0) := (others => '0');
    
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
    -- NB take care to avoid off-by-1 error!
    signal delay : delay_type;
    
    
    ---Test code
--    constant PACKET_LEN : natural :=  16;
  
  
  -- Define the states of state machine                                             
--  type    state is (IDLE, SEND_STREAM);          
type    state is (IDLE, GET_NEXT,ADD_TX_SEQ_HDR , ADD_RX_SEQ_HDR , ADD_TX_TC_HDR, ADD_RX_TC_HDR, SEND_LB1,SEND_LB2,SEND_LB3,SEND_RB1, SEND_RB2, SEND_RB3);      
  signal  sm_state : state := IDLE;
--  signal  sm_state_next : state := IDLE;                                                   
signal    tx_time_code      : unsigned(TC_BIT_LENGTH  -1 downto 0);
  -- AXI Stream internal signals
--  signal tvalid         : std_logic := '0';
  signal tlast, tuser         : std_logic := '0';  
  signal hdr_valid     : std_logic := '0';
  
--  signal sample_48k : std_logic := '0';
  signal newsample_reg, newsample_change, newsample_rdy, tc_gen_reg : std_logic := '0';
--  signal hdr_valid_next     : std_logic := '0';  
--  signal data           : unsigned(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
--  signal data_out           : unsigned(AXIS_UDP_DATA_WIDTH-1 downto 0) := (others => '0');
  
  
  signal sine_clock,  sine_enable: std_logic;
  signal wave_out: sine_vector_type;
  signal sine_div_cnt         : unsigned(SINE_DIV_WIDTH  -1 downto 0)  := (others => '0');
  signal sine_div         : std_logic_vector(SINE_DIV_WIDTH  -1 downto 0)  := X"0000_0001";
  signal sine_div_mirror         : unsigned(SINE_DIV_WIDTH  -1 downto 0)  := (others => '0');
  
  
  constant TEST_PULSE_WIDTH :natural := 3125000;--20Hz @ 125MHz base
    signal testWave24Bit : std_logic_vector(23 downto 0) := X"00FFFF";
    signal testWaveTimer : unsigned(32 downto 0);
    
    signal tsync , sync_en    : std_logic := '0';
  

begin

    -- Instantiation of Axi Bus Interface S00_AXI
    audio_to_eth_interleaved_v2_0_S00_AXI_inst : audio_to_eth_interleaved_v2_0_S00_AXI
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
	
	
	sine_source: sine_wave 
	port map ( 
	clock => sine_clock, 
     resetn => s00_axi_aresetn, 
     enable => sine_enable, 
     wave_out => wave_out );
	                         
	                         
	

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
    process(readReg,rAdr,
            adcLeftFIFOEmpty,adcRightFIFOEmpty,adcLeftFIFOFull,adcRightFIFOFull)
    begin
        rValue <= (others => '0');
        if (readReg='1') then
            case rAdr is
            when "00000" =>  
		-- Offset 0
                rValue(2) <= adcLeftFIFOEmpty;
                rValue(3) <= adcRightFIFOEmpty;
                rValue(4) <= adcLeftFIFOFull;
                rValue(5) <= adcRightFIFOFull;
                rValue(6) <= enablePacketCount;
                rValue(7) <= test_mode;
                rValue(8) <= stream_send;
                rValue(11 downto 9) <= test_pattern;
                rValue(12) <= sine_enable;
--            when others =>
            when "00001" =>
                -- OFSET 4 -- See problem (1)
--                rValue    <= adcLeftFIFOReadData;
                if(adcLeftFIFOEmpty = '1') then
                    rValue    <= b"1111_1111_0000_0000_0000_0000_0000_0000" ;
                else 
                    rValue    <= x"0000_0000";
                end if;
            when "00010" =>
                --OFFSET 8 -- See problem (1)
--                rValue    <= adcRightFIFOReadData;
                if(adcRightFIFOEmpty = '1') then
                    rValue    <= b"1111_1111_0000_0000_0000_0000_0000_0000" ;
                else 
                    rValue    <= x"0000_0000";
                end if;
             when "00011" =>  
		          -- Offset 12
                rValue <=    b"0000_0000_0000_0000"&payload_length;
             when "00100" =>  
		          -- Offset 16
                rValue <=    packet_count(31 downto  0);
             when "00101" =>  
		          -- Offset 16
                rValue <=    sine_div(31 downto  0);
            when "00110" =>  
		          -- Offset 16
                rValue <=    x"0000_000"&b"000"&sync_en;
            when others =>  
                rValue <=    rAdr&b"111_1111_1111"&X"FFFF";  
            end case;
        end if;
    end process;
    
    
    -- Register Write Process
    process(s00_axi_aclk,packet_len_cnt, s00_axi_aresetn,wAdr,writeReg,wValue)
    begin
        if rising_edge(s00_axi_aclk) then
            resetADCLeftFifo <= '0';
            resetADCRightFifo <= '0';
            
            if s00_axi_aresetn = '0' then
                -- Reset
                resetADCLeftFifo <= '1';
                resetADCRightFifo <= '1';
                stream_send <= '1';
                test_mode <= '0';
                sync_en <= '0';
                test_pattern <= b"100";
                packet_count<= x"0000_0240"; 
                payload_length <= x"024C";-- formula == 6*N + 12 even
                
            else
                if (writeReg = '1') then
                    case wAdr is
                    when "00000" =>  
                        resetADCLeftFifo <= wValue(0);                
                        resetADCRightFifo <= wValue(1);
                        enablePacketCount <= wValue(6);
                        test_mode <= wValue(7);                                                 
                        stream_send <= wValue(8);   
                        test_pattern <= wValue(11 downto 9); 
                        sine_enable <= wValue(12) ;  
                    when "00011" =>
                        payload_length <= wValue(15 downto  0);
                    when "00100" =>
                        packet_count <= wValue(31 downto  0);
                    when "00101" =>  
		          -- Offset 16
                       sine_div  <=    wValue ;
                       when "00110" =>  
                        sync_en <= wValue(0);
                    when others =>
                        resetADCLeftFifo <= resetADCLeftFifo;                
                        resetADCRightFifo <= resetADCRightFifo;
                        test_mode <= test_mode;
                        enablePacketCount <= enablePacketCount;                        
                        stream_send <= stream_send;  
                        test_pattern <= test_pattern;
                        sine_div <= sine_div;
                        sine_enable <= sine_enable ; 
                        payload_length <= payload_length; 
                        packet_count <= packet_count;
                        sync_en <= sync_en;
                    end case;
                end if;
                
                if ((packet_count_cnt_final >= (packet_count_mirror-1)) and  (enablePacketCount_final ='1')) then        
                    stream_send <= '0';
                else                           
                    stream_send <= stream_send;
                end if;  
                
                
            end if;
        end if;
    end process;
    
    



-- I/O Connections assignments
--  m_axis_tstrb   <= (others => '1');     -- byte enables always high
  m_audio_payload_axis_tvalid  <= tvalid;
  m_audio_payload_axis_tlast   <= tlast;
--  data(PACKET_W-1 downto 0)  <= packet_len_cnt; 
  m_audio_payload_axis_tuser <= tuser; 
  m_audio_payload_axis_tdata   <= tdata;
  m_audio_payload_hdr_valid <= hdr_valid;
  
--  adcLeftData <= adcLeftDataTmp;
--  adcRightData <= adcRightDataTmp;
  
  
  stream_send_final <= stream_send;
  test_mode_final <= test_mode;  
  packet_len_cnt_final <= packet_len_cnt;
  packet_count_cnt_final <= packet_count_cnt;
  enablePacketCount_final <= enablePacketCount;
  

audio_to_eth : process(CLK_125, s00_axi_aresetn)    --is
--variable bytecount : integer range 0 to 31 := 0;                                                                
  begin                                                                                       
    if s00_axi_aresetn = '0' then
      sm_state          <= IDLE;
      delay             <= reset_delay;
      tvalid            <= '0';
      tlast             <= '0';
      tuser             <= '0';   
      hdr_valid         <= '0';
      bytecount <= (others => '0');
--      adcLeftDataTmp    <=  (others => '0');
--      adcRightDataTmp   <= (others => '0');
--      leftTest24Bit     <= (others => '0');
--      rightTest24Bit    <= (others => '0');
      tdata <= (others => '0'); 
      packet_len_cnt    <= (others => '0');
      packet_count_cnt    <= (others => '0');
      add_seq <= '1';
      
   elsif  (rising_edge (CLK_125))  then
    
          -- default actions such as default outputs first
          -- operate the delay counter
          
              if delay > 0 then 
                 delay <= delay - 1;
              end if;
         
    --------------------------------------------------- RUN MODE ------------------------------------------------------------
--        if(stream_send_final = '1') then                                          
                  case (sm_state) is                                                              
                    when IDLE =>
                      tvalid            <= '0';
                      tlast             <= '0';
                      tuser <= '0'; 
                      tdata <= (others => '0'); 
                      sm_state <=  sm_state;
                      sm_state        <= IDLE;
        --                m_audio_payload_hdr_valid <= '0';
                      hdr_valid <= '0';
                      packet_len_cnt    <= (others => '0');
                      packet_count_cnt <= packet_count_cnt;
                      
                        -- start sending  newsample_in is on the 100MHz clock domain
                        if ( (newsample_125= '1') and (delay = 0)) then
                            delay <= hdr_valid_delay;
                            hdr_valid <= '1';
                            if ((stream_send_final = '1') and (add_seq = '1')) then --only do new packet if necesssary
                                sm_state <= ADD_TX_SEQ_HDR; 
                                bytecount <= (others => '0');
                                add_seq <= '0'; 
                            elsif(add_seq = '0') then --makes sure we complete pkts to keep axis happy
                                sm_state <= SEND_LB1; 
                            else
                                sm_state        <= IDLE;
                            end if;
                             
                        end if; 
                        
                    when  ADD_TX_SEQ_HDR=>
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= hdr_valid;
                        tuser <= '0';
                        add_seq <= '0'; 
                        sm_state <=  sm_state;
                         if(m_audio_payload_axis_tready = '1') and (bytecount = 0) then   
                            tdata <= std_logic_vector(packet_seq_cnt(7 downto 0));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_TX_SEQ_HDR; 
                            bytecount <= X"1";
                        elsif (m_audio_payload_axis_tready = '1') and (bytecount = 1) then
                            tdata <= std_logic_vector(packet_seq_cnt(15 downto 8));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_TX_TC_HDR; 
                            bytecount <= (others => '0');
                        else
                                sm_state        <= ADD_TX_SEQ_HDR; 
                            
                        end if;
                        
                    when  ADD_TX_TC_HDR=>
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= hdr_valid;
                        tuser <= '0';
                        add_seq <= '0'; 
                        sm_state <=  sm_state;
                        -- TC LSB first
                         if(m_audio_payload_axis_tready = '1') and (bytecount = 0) then   
                            tdata <= std_logic_vector(tx_time_code(7 downto 0));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_TX_TC_HDR; 
                            bytecount <= X"1";
                        elsif (m_audio_payload_axis_tready = '1') and (bytecount = 1) then
                            tdata <= std_logic_vector(tx_time_code(15 downto 8));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_TX_TC_HDR; 
                            bytecount <= X"2";
                        elsif (m_audio_payload_axis_tready = '1') and (bytecount = 2) then
                            tdata <= std_logic_vector(tx_time_code(23 downto 16));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_TX_TC_HDR; 
                            bytecount <= X"3";
                        elsif (m_audio_payload_axis_tready = '1') and (bytecount = 3) then
                            tdata <= std_logic_vector(tx_time_code(31 downto 24));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_RX_SEQ_HDR; 
                            bytecount <= (others => '0');
                        else
                                sm_state        <= ADD_TX_TC_HDR; 
                                tvalid            <= '0';
                        end if;
                        
                    when  ADD_RX_SEQ_HDR=>
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= hdr_valid;
                        tuser <= '0';
                        add_seq <= '0'; 
                        sm_state <=  sm_state;
                         if(m_audio_payload_axis_tready = '1') and (bytecount = 0) then   
                            tdata <= std_logic_vector(rx_packet_seq_cnt_in(7 downto 0));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_RX_SEQ_HDR; 
                            bytecount <= X"1";
                        elsif (m_audio_payload_axis_tready = '1') and (bytecount = 1) then
                            tdata <= std_logic_vector(rx_packet_seq_cnt_in(15 downto 8));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_RX_TC_HDR; 
                            bytecount <= (others => '0');
                        else
                                sm_state        <= ADD_RX_SEQ_HDR; 
                            
                        end if;
                        
                    when  ADD_RX_TC_HDR=>
                        tvalid            <= '1';
                        tlast             <= '0';
                        hdr_valid <= hdr_valid;
                        tuser <= '0';
                        add_seq <= '0'; 
                        sm_state <=  sm_state;
                         if(m_audio_payload_axis_tready = '1') and (bytecount = 0) then   
                            tdata <= std_logic_vector(rx_time_code_in(7 downto 0));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_RX_TC_HDR; 
                            bytecount <= X"1";
                        elsif (m_audio_payload_axis_tready = '1') and (bytecount = 1) then
                            tdata <= std_logic_vector(rx_time_code_in(15 downto 8));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_RX_TC_HDR; 
                            bytecount <= X"2";
                        elsif (m_audio_payload_axis_tready = '1') and (bytecount = 2) then
                            tdata <= std_logic_vector(rx_time_code_in(23 downto 16));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= ADD_RX_TC_HDR; 
                            bytecount <= X"3";
                        elsif (m_audio_payload_axis_tready = '1') and (bytecount = 3) then
                            tdata <= std_logic_vector(rx_time_code_in(31 downto 24));
                            packet_len_cnt    <= packet_len_cnt + 1;
                            sm_state <= SEND_LB1; 
                            bytecount <= (others => '0');
                        else
                                sm_state        <= ADD_RX_TC_HDR; 
                                tvalid            <= '0';
                        end if; 
                        
                    when GET_NEXT =>
                       tvalid            <= '0';
                       tlast             <= '0';
                       tuser <= '0'; 
                       
                       sm_state <=  sm_state; 
                       tdata <= tdata;
--                       if delay = 0 then 
--                         hdr_valid <= '0';
--                       else 
                       hdr_valid <= hdr_valid;
                         
--                       end if; 
                       
                       packet_len_cnt    <= packet_len_cnt;
                       packet_count_cnt <= packet_count_cnt;
                        -- start sending  newsample_125 is on the 100MHz clock domain
                        if (newsample_125= '1') then
                            sm_state <= SEND_LB1;  
                        end if;                                                                                                        
                    when SEND_LB1 =>   
            --        if (adcRightFIFOEmpty= '0') then
                          tvalid            <= '1'; 
                          sm_state <=  sm_state;
                            tlast             <= '0';
                            tuser <= '0';
--                       if delay = 0 then 
--                         hdr_valid <= '0';
--                       else 
                         hdr_valid <= hdr_valid;
--                         adcLeftDataTmp <= adcLeftDataTmp;
--                         adcRightDataTmp <= adcRightDataTmp;
--                       end if; 
                            packet_len_cnt    <= packet_len_cnt; 
                            packet_count_cnt <= packet_count_cnt;         
                          tdata <= tdata;
                          if(m_audio_payload_axis_tready = '1') then                  
                              tdata <= ethLeftData(23 downto 16);
                              packet_len_cnt    <= packet_len_cnt + 1;
--                              if (packet_len_cnt_final= (payload_length_mirror-1) ) then
--                                tlast           <= '1';
--                                sm_state        <= IDLE;
--                                packet_len_cnt    <= (others => '0');
--                              else
                                    sm_state        <= SEND_LB2;
--                              end if; 
                          end if; 
            --          end if;  
                    when SEND_LB2 =>   
            --        if (adcRightFIFOEmpty= '0') then
                          tvalid            <= '1';    
                          tlast             <= '0';
                          tuser <= '0'; 
                          sm_state <=  sm_state; 
--                       if delay = 0 then 
--                         hdr_valid <= '0';
--                       else 
                         hdr_valid <= hdr_valid;
--                         adcLeftDataTmp <= adcLeftDataTmp;
--                         adcRightDataTmp <= adcRightDataTmp;
--                       end if; 
                          packet_len_cnt    <= packet_len_cnt; 
                          packet_count_cnt <= packet_count_cnt;          
                          tdata <= tdata;
                          if(m_audio_payload_axis_tready = '1') then                  
                              tdata <= ethLeftData(15 downto 8);
                              packet_len_cnt    <= packet_len_cnt + 1;
--                              if (packet_len_cnt_final= (payload_length_mirror-1) ) then
--                                tlast           <= '1';
--                                sm_state        <= IDLE;
--                                packet_len_cnt    <= (others => '0');
--                              else
                                    sm_state        <= SEND_LB3;
--                              end if; 
                          end if; 
            --          end if;    
                    when SEND_LB3 =>   
            --        if (adcRightFIFOEmpty= '0') then
                          tvalid            <= '1';  
                          tlast             <= '0';
                          tuser <= '0';   
                          sm_state <=  sm_state;       
--                       if delay = 0 then 
--                         hdr_valid <= '0';
--                       else 
                         hdr_valid <= hdr_valid;
--                         adcLeftDataTmp <= adcLeftDataTmp;
--                         adcRightDataTmp <= adcRightDataTmp;
--                       end if; 
                         packet_len_cnt    <= packet_len_cnt;   
                         packet_count_cnt <= packet_count_cnt;  
                          tdata <= tdata;
                          if(m_audio_payload_axis_tready = '1') then                  
                              tdata <= ethLeftData(7 downto 0);
                              packet_len_cnt    <= packet_len_cnt + 1;
--                              if (packet_len_cnt_final= (payload_length_mirror-1) ) then
--                                tlast           <= '1';
--                                sm_state        <= IDLE;
--                                packet_len_cnt    <= (others => '0');
--                                else
                                    sm_state        <= SEND_RB1;
--                              end if; 
                          end if; 
            --          end if;              
                    when SEND_RB1 =>   
            --        if (adcRightFIFOEmpty= '0') then
                          tvalid            <= '1'; 
                          tlast             <= '0';
                          tuser <= '0'; 
                          sm_state <=  sm_state;
--                       if delay = 0 then 
--                         hdr_valid <= '0';
--                       else 
                         hdr_valid <= hdr_valid;
--                         adcLeftDataTmp <= adcLeftDataTmp;
--                         adcRightDataTmp <= adcRightDataTmp;
--                       end if; 
                          packet_len_cnt    <= packet_len_cnt; 
                          packet_count_cnt <= packet_count_cnt;              
                          tdata <= tdata;
                          if(m_audio_payload_axis_tready = '1') then                  
                              tdata <= ethRightData(23 downto 16);
                              packet_len_cnt    <= packet_len_cnt + 1;
--                              if (packet_len_cnt_final= (payload_length_mirror-1) ) then
--                                tlast           <= '1';
--                                sm_state        <= IDLE;
--                                packet_len_cnt    <= (others => '0');
--                                else
                                    sm_state        <= SEND_RB2;
--                              end if; 
                          end if; 
            --          end if;        
                    when SEND_RB2 =>   
            --        if (adcRightFIFOEmpty= '0') then
                          tvalid            <= '1';  
                          tlast             <= '0';
                          tuser <= '0'; 
                          sm_state <=  sm_state;        
--                       if delay = 0 then 
--                         hdr_valid <= '0';
--                       else 
                         hdr_valid <= hdr_valid;
--                         adcLeftDataTmp <= adcLeftDataTmp;
--                         adcRightDataTmp <= adcRightDataTmp;
--                       end if; 
                       packet_len_cnt    <= packet_len_cnt;    
                       packet_count_cnt <= packet_count_cnt;  
                          tdata <= tdata;
                          if(m_audio_payload_axis_tready = '1') then                  
                              tdata <= ethRightData(15 downto 8);
                              packet_len_cnt    <= packet_len_cnt + 1;
--                              if (packet_len_cnt_final= (payload_length_mirror-1) ) then
--                                tlast           <= '1';
--                                sm_state        <= IDLE;
--                                packet_len_cnt    <= (others => '0');
--                                else
                                    sm_state        <= SEND_RB3;
--                              end if; 
                          end if; 
            --          end if;   
                    when SEND_RB3 =>   
            --        if (adcRightFIFOEmpty= '0') then
                          tvalid            <= '1';   
                          tlast             <= '0';
                          tuser <= '0';  
                          sm_state <=  sm_state; 
--                       if delay = 0 then 
--                         hdr_valid <= '0';
--                       else 
                         hdr_valid <= hdr_valid;
--                         adcLeftDataTmp <= adcLeftDataTmp;
--                         adcRightDataTmp <= adcRightDataTmp;
                         packet_count_cnt <= packet_count_cnt;
--                       end if; 
                       packet_len_cnt    <= packet_len_cnt; 
                       packet_count_cnt <= packet_count_cnt;          
                          tdata <= tdata;
                          if(m_audio_payload_axis_tready = '1') then                  
                              tdata <= ethRightData(7 downto 0);
                              packet_len_cnt    <= packet_len_cnt + 1;
                              if (packet_len_cnt_final >= (payload_length_mirror-1) ) then
                                    tlast           <= '1';
                                    add_seq         <= '1';
                                    packet_seq_cnt <= packet_seq_cnt + 1;
                                    packet_len_cnt    <= (others => '0');
                                    if enablePacketCount_final  = '1' then
                                        packet_count_cnt <= packet_count_cnt + 1;
                                        
                                        if (packet_count_cnt_final >= (packet_count_mirror-1) ) then        
                                            packet_count_cnt    <= (others => '0');
                                        end if;  
                                    end if;
                                    sm_state        <= IDLE;
                                    hdr_valid         <= '0';
                             else                           
                                    sm_state <= GET_NEXT;
                             end if; 
                              
                              
                              
                          end if; 
            --          end if;                                                                                             
                    when others =>                                                                   
                      sm_state <= IDLE; 
                      add_seq         <= '1';
                      packet_len_cnt    <= packet_len_cnt;
                      packet_count_cnt <= packet_count_cnt;
--                      adcLeftDataTmp <= adcLeftDataTmp;
--                        adcRightDataTmp <= adcRightDataTmp;
                      hdr_valid <= hdr_valid; 
                      tvalid            <= '0';
                        tlast           <= '0';
                        tuser <= '0'; 
                        tdata <= (others => '0');  
                        packet_count_cnt <= packet_count_cnt;                                                                                                                                                       
                  end case; 
              
              
      else
      
        sm_state <=  sm_state;
        hdr_valid <= hdr_valid;
--        adcLeftDataTmp <= adcLeftDataTmp;
--        adcRightDataTmp <= adcRightDataTmp;
        packet_len_cnt    <= packet_len_cnt;
        packet_count_cnt <= packet_count_cnt;
        tvalid            <= '0';
        tlast           <= '0';
        tuser <= '0'; 
        tdata <= (others => '0'); 
      end if;
      
      
      if (resetADCLeftFifo='1' or resetADCLeftFifo ='1') then
            sm_state          <= IDLE;
              delay             <= reset_delay;
              tvalid            <= '0';
              tlast             <= '0';
              tuser             <= '0';   
              hdr_valid         <= '0';
--              adcLeftDataTmp    <=  (others => '0');
--              adcRightDataTmp   <= (others => '0');
--              leftTest24Bit     <= (others => '0');
--              rightTest24Bit    <= (others => '0');
              tdata <= (others => '0'); 
              packet_len_cnt    <= (others => '0');
              packet_count_cnt    <= (others => '0');
              add_seq <= '1';
      end if;
                                                                                  
--    end if;                                                                                
  end process audio_to_eth;             
    
   -- Control state machine implementation   
   --    m_audio_payload_hdr_ready does not go to zero before m_audio_payload_hdr_valid goes up                                       
--  sm_hdr_valid : process(s00_axi_aclk,s00_axi_aresetn)                                                                        
--  begin                                                                                       
--    if (rising_edge (s00_axi_aclk)) then    
----        m_audio_payload_hdr_valid_reg <= m_audio_payload_hdr_valid_next;
----        m_audio_payload_hdr_valid <= m_audio_payload_hdr_valid_reg and (not m_audio_payload_hdr_ready); 
--        if (m_audio_payload_hdr_ready = '1') then
--              m_audio_payload_hdr_valid <= m_audio_payload_hdr_valid_next;
--        end if;
        
----        if (m_audio_payload_hdr_ready = '0' and m_audio_payload_hdr_valid_next = '0') then
----              m_audio_payload_hdr_valid <= m_audio_payload_hdr_valid_next;
----        end if;
        
        
        
--  end if;                                                                                
--  end process sm_hdr_valid;  


--  sm_stat_advance : process(s00_axi_aclk,s00_axi_aresetn)                                                                        
--  begin   
--    if s00_axi_aresetn = '0' then
--        sm_state <= IDLE;
--    else                                                                                   
--        if (rising_edge (s00_axi_aclk)) then    
--            sm_state <= sm_state_next;
--            hdr_valid <= hdr_valid_next;
--        end if;   
--    end if;                                                                              
--  end process sm_stat_advance; 

-- This syncronises the newsample_in signal to the axis 125MHz clock
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
--newsample_delay: process(CLK_125, s00_axi_aresetn)
--begin
--    if s00_axi_aresetn = '0' then
--        newsample_reg <= '0';        
--    elsif rising_edge (CLK_125) then
----        newsample_reg <= newsample_in;
--        tc_div_reg1 <= newsample_in;
--        tc_div_reg2 <= tc_div_reg1;
--        tc_div_reg3 <= tc_div_reg2;
--        tc_div_reg4 <= tc_div_reg3;
--    end if;
--end process;


newsample_div: process(newsample_in, s00_axi_aresetn)
begin
    if s00_axi_aresetn = '0' then
        tsync_div_gen <= '0';        
    elsif rising_edge (newsample_in) then
--        newsample_reg <= newsample_in;
        tsync_div_gen <= not tsync_div_gen;
        tc_div_reg1 <= tsync_div_gen;
        tc_div_reg2 <= tc_div_reg1;
        tc_div_reg3 <= tc_div_reg2;
        tc_div_reg4 <= tc_div_reg3;
    end if;
end process;

tsync_int <= newsample_in when (sync_en = '1' or tc_sync_en_int_in = '1') else '0'; 
--tsync_out <= tc_div_reg4 when sync_en = '1' else '0'; 
  sync_en_out <= (sync_en or tc_sync_en_int_in);
  
clk_bufg_inst :  BUFG
port map (
    I => (tsync_int),
    O => (tsync_out)
);

-- This syncronises the newsample_in signal to the axis 125MHz clock
tc_gen: process(CLK_125, s00_axi_aresetn)
begin
    if s00_axi_aresetn = '0' then
        tc_gen_reg <= '0';        
    elsif rising_edge (CLK_125) then
        tc_gen_reg <= tc_div_reg4;
    end if;
end process;

--tc_div_125 <= (tc_div_reg4 xor tc_gen_reg) when (tc_div_reg4='1') else '0';
--  tsync_out <= newsample_in when sync_en = '1' else '0'; 
  

  sm_tc_gen : process(CLK_125,s00_axi_aresetn)                                                                        
  begin   
    if s00_axi_aresetn = '0' then
        tx_time_code <= (others => '0');
    else                                                                                   
        if (rising_edge (CLK_125)) then   
            if ((newsample_125 = '1') and (sync_en = '1' or tc_sync_en_int_in = '1'))  and (tc_adjust_in = '0') then 
                tx_time_code <=  tx_time_code + 1;
--                tsync  <= tsync  xor '1';
            elsif (tc_adjust_in = '1') then
                tx_time_code <= unsigned(tc_count_adjust) + 1;                
            elsif ((sync_en = '0') and tc_sync_en_int_in = '0') then
                tsync  <= '0';
                tx_time_code <= (others => '0');
            end if;
            
        end if;  
        
--        if (resetADCLeftFifo='1' or resetADCRightFifo ='1') then
--            tsync  <= '0';
--            tx_time_code <= (others => '0');
--        end if;
        
        
        
         
    end if;                                                                              
  end process sm_tc_gen; 
  
tx_time_code_out <= std_logic_vector(tx_time_code);

  test_pattern_gen : process(CLK_125, s00_axi_aresetn)                                                                        
  begin   
    if s00_axi_aresetn = '0' then
--        adcLeftData <= (others => '0'); 
--        adcRightData <= (others => '0'); 
        leftTest24Bit <= (others => '0');
        rightTest24Bit <= (others => '0');
        
    elsif (rising_edge (CLK_125)) then  
--            newsample_125 <= newsample_change; --one reg delay to avoid quick read 

                testWaveTimer <= testWaveTimer+1;
                 if (testWaveTimer = TEST_PULSE_WIDTH) then 
                    testWaveTimer <= (others => '0');
                    testWave24Bit(23) <= testWave24Bit(23) xor '1';
                end if;
           
                if (newsample_125 = '1') then
                       
                    case test_mode_final & test_pattern is
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
--                            leftTest24Bit  <= X"000"&unsigned(wave_out)&X"0";  
--                            rightTest24Bit <= X"000"&unsigned(wave_out)&X"0"; 
                            leftTest24Bit  <= unsigned(testWave24Bit);     --b"0000_0000_0000_0000";  
                            rightTest24Bit <= unsigned(testWave24Bit); --b"0000_0000_0000_0000"; 
                        when others =>
                            leftTest24Bit <= leftTest24Bit;
                            rightTest24Bit <= rightTest24Bit;
                        end case;
                 
                end if; 
                
        end if; 
        
        if (resetADCLeftFifo='1' or resetADCRightFifo ='1') then
--            adcLeftData <= (others => '0'); 
--            adcRightData <= (others => '0'); 
            leftTest24Bit <= (others => '0');
            rightTest24Bit <= (others => '0');
      end if;
                                                                            
  end process test_pattern_gen; 
  
  
  testLeftData <= std_logic_vector(leftTest24Bit);
  testRightData <= std_logic_vector(rightTest24Bit);
  adcLeftData <= line_in_l_in;
  adcRightData <= line_in_r_in;
  
  ethLeftData <= adcLeftData when (test_mode_final = '0') else testLeftData;
  ethRightData <=  adcRightData when (test_mode_final = '0') else testRightData;



sine_sample: process(newsample_125, s00_axi_aresetn)
begin
    if s00_axi_aresetn = '0' then
        sine_div_cnt <= (others => '0');    
--    elsif rising_edge (newsample_125) then bad idea not buffered
elsif (newsample_125 = '1') then
        if sine_div_cnt = sine_div_mirror then
            sine_clock <= '1';
            sine_div_cnt <= (others => '0');
        else 
            sine_clock <= '0';
            sine_div_cnt <= sine_div_cnt + 1;
        end if;
    end if;
end process;


  
  
  
  
--    writeDACFifo <= '1' when (writeReg = '1' and wAdr="0001") else '0'; 
--rAdr="0010" --- OFFSET=>8
    readADCLeftFifo   <= '1' when (readReg  = '1' and rAdr="00001") else readADCLeftFifoEth; 
    readADCRightFifo  <= '1' when (readReg  = '1' and rAdr="00010") else readADCRightFifoEth; 
    rDataValid_sig    <= '0' when ((adcLeftFIFOEmpty = '1' or adcRightFIFOEmpty = '1') and (rAdr="00001" or rAdr="00010"))  else '1'; -- Allow reading of status even when FIFO is empty
    -- Payload len used for packaging stream
    
   

    

    -- IRQ Generation.
    -- TODO (2), make sure we generate ONE pulse ? Assert until... ?
    irq_out <= '0';
    
--    leftIn24Bit <= line_in_l_in;
--    rightIn24Bit <= line_in_r_in;
--    needNewSample <= newsample_in;
--    sample_48k <= sample_48k_in;
    udp_payload_length <= payload_length;
    payload_length_mirror  <= unsigned(payload_length);
    packet_count_mirror <= unsigned(packet_count);
    
--    packet_seq_mirror <= unsigned(packet_seq);
    
    
    sine_div_mirror <= unsigned(sine_div);
    
    --m_audio_payload_axis_tvalid <= tvalid;
    --m_audio_payload_axis_tdata <= tdata;
    
	-- User logic ends

end arch_imp;
