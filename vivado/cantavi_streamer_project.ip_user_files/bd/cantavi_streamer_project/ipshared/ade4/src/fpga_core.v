/*

There is a streaming fifo for each stream

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * FPGA core logic
 */
module fpga_core #
(
    parameter TARGET = "XILINX",
    parameter UDP_DATA_WIDTH = 8,
    parameter UDP_PORT_WIDTH = 16,
    parameter UDP_LENGTH_WIDTH = 16,
    parameter UDP_IP_WIDTH = 32,
    parameter UDP_MAC_WIDTH = 48,
    parameter SESSION_USERS_COUNT = 2,
    parameter AUDIO_FIFO_ADDR_WIDTH = 12
)
(
    /*
     * Clock: 125MHz
     * Synchronous reset
     */
    input  wire       clk,
//    input  wire       clk90,
    input  wire       rst,

    /*
     * GPIO
     */
    input  wire       btnu,
    input  wire       btnl,
    input  wire       btnd,
    input  wire       btnr,
    input  wire       btnc,
    input  wire [7:0] sw,
    output wire [7:0] led,

    /*
     * Ethernet: 1000BASE-T RGMII
     */
//    input  wire       phy_rx_clk,
//    input  wire [3:0] phy_rxd,
//    input  wire       phy_rx_ctl,
//    output wire       phy_tx_clk,
//    output wire [3:0] phy_txd,
//    output wire       phy_tx_ctl,
//    output wire       phy_reset_n,
//    input  wire       phy_int_n,
//    input  wire       phy_pme_n,
    
    // AXI between MAC and Ethernet modules
    input wire [7:0] from_sw_rx_axis_tdata,
    input wire from_sw_rx_axis_tvalid,
    output wire from_sw_rx_axis_tready,
    input wire from_sw_rx_axis_tlast,
    input wire from_sw_rx_axis_tuser,
    
    output wire [7:0] to_sw_tx_axis_tdata,
    output wire to_sw_tx_axis_tvalid,
    input wire to_sw_tx_axis_tready,
    output wire to_sw_tx_axis_tlast,
    output wire to_sw_tx_axis_tuser,
    
    /*
     * ARP requests
     */
    output  wire        arp_request_valid,
    input wire        arp_request_ready,
    output  wire [31:0] arp_request_ip,
    
    input wire        arp_response_valid,
    output  wire        arp_response_ready,
    input wire        arp_response_error,
    input wire [47:0] arp_response_mac,
    
    
    /*
     * MAC Configuration
     */
    output  wire [7:0]  to_sw_ifg_delay,
    
    /*
     * MAC Status
     */
    input wire        from_sw_tx_fifo_overflow,
    input wire        from_sw_tx_fifo_bad_frame,
    input wire        from_sw_tx_fifo_good_frame,
    input wire        from_sw_rx_error_bad_frame,
    input wire        from_sw_rx_error_bad_fcs,
    input wire        from_sw_rx_fifo_overflow,
    input wire        from_sw_rx_fifo_bad_frame,
    input wire        from_sw_rx_fifo_good_frame,
    input wire [1:0]  from_sw_speed,
    
    /*
     * IP input
     */
    input  wire        s_ip_hdr_valid,
    output wire        s_ip_hdr_ready,
    input  wire [5:0]  s_ip_dscp,
    input  wire [1:0]  s_ip_ecn,
    input  wire [15:0] s_ip_length,
    input  wire [7:0]  s_ip_ttl,
    input  wire [7:0]  s_ip_protocol,
    input  wire [31:0] s_ip_source_ip,
    input  wire [31:0] s_ip_dest_ip,
    input  wire [7:0]  s_ip_payload_axis_tdata,
    input  wire        s_ip_payload_axis_tvalid,
    output wire        s_ip_payload_axis_tready,
    input  wire        s_ip_payload_axis_tlast,
    input  wire        s_ip_payload_axis_tuser,
    
    /*
     * IP output
     */
    output wire        m_ip_hdr_valid,
    input  wire        m_ip_hdr_ready,
    output wire [47:0] m_ip_eth_dest_mac,
    output wire [47:0] m_ip_eth_src_mac,
    output wire [15:0] m_ip_eth_type,
    output wire [3:0]  m_ip_version,
    output wire [3:0]  m_ip_ihl,
    output wire [5:0]  m_ip_dscp,
    output wire [1:0]  m_ip_ecn,
    output wire [15:0] m_ip_length,
    output wire [15:0] m_ip_identification,
    output wire [2:0]  m_ip_flags,
    output wire [12:0] m_ip_fragment_offset,
    output wire [7:0]  m_ip_ttl,
    output wire [7:0]  m_ip_protocol,
    output wire [15:0] m_ip_header_checksum,
    output wire [31:0] m_ip_source_ip,
    output wire [31:0] m_ip_dest_ip,
    output wire [7:0]  m_ip_payload_axis_tdata,
    output wire        m_ip_payload_axis_tvalid,
    input  wire        m_ip_payload_axis_tready,
    output wire        m_ip_payload_axis_tlast,
    output wire        m_ip_payload_axis_tuser,
    
        /*
     * UDP input
     */
    input  wire        s_udp_hdr_valid,
    output wire        s_udp_hdr_ready,
    input  wire [5:0]  s_udp_ip_dscp,
    input  wire [1:0]  s_udp_ip_ecn,
    input  wire [7:0]  s_udp_ip_ttl,
    input  wire [31:0] s_udp_ip_source_ip,
    input  wire [31:0] s_udp_ip_dest_ip,
    input  wire [15:0] s_udp_source_port,
    input  wire [15:0] s_udp_dest_port,
    input  wire [15:0] s_udp_length,
    input  wire [15:0] s_udp_checksum,
    input  wire [7:0]  s_udp_payload_axis_tdata,
    input  wire        s_udp_payload_axis_tvalid,
    output wire        s_udp_payload_axis_tready,
    input  wire        s_udp_payload_axis_tlast,
    input  wire        s_udp_payload_axis_tuser,
    
    /*
     * UDP output
     */
    output wire        m_udp_hdr_valid,
    input  wire        m_udp_hdr_ready,
    output wire [47:0] m_udp_eth_dest_mac,
    output wire [47:0] m_udp_eth_src_mac,
    output wire [15:0] m_udp_eth_type,
    output wire [3:0]  m_udp_ip_version,
    output wire [3:0]  m_udp_ip_ihl,
    output wire [5:0]  m_udp_ip_dscp,
    output wire [1:0]  m_udp_ip_ecn,
    output wire [15:0] m_udp_ip_length,
    output wire [15:0] m_udp_ip_identification,
    output wire [2:0]  m_udp_ip_flags,
    output wire [12:0] m_udp_ip_fragment_offset,
    output wire [7:0]  m_udp_ip_ttl,
    output wire [7:0]  m_udp_ip_protocol,
    output wire [15:0] m_udp_ip_header_checksum,
    output wire [31:0] m_udp_ip_source_ip,
    output wire [31:0] m_udp_ip_dest_ip,
    output wire [15:0] m_udp_source_port,
    output wire [15:0] m_udp_dest_port,
    output wire [15:0] m_udp_length,
    output wire [15:0] m_udp_checksum,
    output wire [7:0]  m_udp_payload_axis_tdata,
    output wire        m_udp_payload_axis_tvalid,
    input  wire        m_udp_payload_axis_tready,
    output wire        m_udp_payload_axis_tlast,
    output wire        m_udp_payload_axis_tuser,

    /*
     * Status
     */
    output wire        ip_rx_busy,
    output wire        ip_tx_busy,
    output wire        udp_rx_busy,
    output wire        udp_tx_busy,
    output wire        ip_rx_error_header_early_termination,
    output wire        ip_rx_error_payload_early_termination,
    output wire        ip_rx_error_invalid_header,
    output wire        ip_rx_error_invalid_checksum,
    output wire        ip_tx_error_payload_early_termination,
    output wire        ip_tx_error_arp_failed,
    output wire        udp_rx_error_header_early_termination,
    output wire        udp_rx_error_payload_early_termination,
    output wire        udp_tx_error_payload_early_termination,   
    
    
   
     /*
    * AXIS AUDIO Stream Master (Sending out of the core)
    */
    
    output wire [SESSION_USERS_COUNT*UDP_DATA_WIDTH-1:0]  m_ch_audio_payload_axis_tdata,
    output wire [SESSION_USERS_COUNT-1:0]       m_ch_audio_payload_axis_tvalid,
    input  wire [SESSION_USERS_COUNT-1:0]       m_ch_audio_payload_axis_tready,
    output wire [SESSION_USERS_COUNT-1:0]       m_ch_audio_payload_axis_tlast,
    output wire [SESSION_USERS_COUNT-1:0]       m_ch_audio_payload_axis_tuser,
    input  wire [SESSION_USERS_COUNT-1:0]       m_ch_audio_payload_hdr_ready,
    output wire [SESSION_USERS_COUNT-1:0]       m_ch_audio_payload_hdr_valid,
    
    
    /*
    * AXIS Stream Slave (Receive audio samples from codec core)
    */
    input  wire [SESSION_USERS_COUNT*UDP_DATA_WIDTH-1:0]  s_audio_payload_axis_tdata,
    input  wire [SESSION_USERS_COUNT-1:0]       s_audio_payload_axis_tvalid,
    output wire [SESSION_USERS_COUNT-1:0]       s_audio_payload_axis_tready,
    input  wire [SESSION_USERS_COUNT-1:0]       s_audio_payload_axis_tlast,
    input  wire [SESSION_USERS_COUNT-1:0]       s_audio_payload_axis_tuser,
    output wire [SESSION_USERS_COUNT-1:0]       s_audio_payload_hdr_ready,
    input  wire [SESSION_USERS_COUNT-1:0]       s_audio_payload_hdr_valid,
    
    input  wire [SESSION_USERS_COUNT-1:0]      fifo_full_in,
    input  wire [SESSION_USERS_COUNT-1:0]      fifo_empty_in,
    
    input  wire [SESSION_USERS_COUNT-1:0]      seq_status1_in,
    input  wire [SESSION_USERS_COUNT-1:0]      seq_status2_in,
    
    
    output wire [15:0]  sync_rx_pkt_count,
    output wire [15:0]  audio_rx_pkt_count,
    output wire [15:0]  mock_rx_pkt_count,
        
    output wire [15:0]  sync_tx_pkt_count,
    output wire [15:0]  audio_tx_pkt_count,
    
    output wire [31:0]  rx_stk_state,
    output wire [31:0]  bus_status,    
        
    
    input  wire       tsync_status1_in,
    input  wire       tsync_status2_in,
    
    input  wire       sync_done_in,
    
    input  wire       sync_request_rx_in,
    input wire          initiate_sync_response_in,
    
    input wire sw_sel_status,
    
    
    input  wire [SESSION_USERS_COUNT-1:0]      udp_stream_tx_enable,
    input wire [UDP_MAC_WIDTH-1:0] cfg_local_mac,
    input wire [UDP_IP_WIDTH-1:0] cfg_local_ip ,
    input wire [UDP_IP_WIDTH-1:0] cfg_gateway_ip,
    input wire [UDP_IP_WIDTH-1:0] cfg_subnet_mask,
    
//    input wire [UDP_PORT_WIDTH-1:0] cfg_source_port,
    input wire [SESSION_USERS_COUNT*UDP_PORT_WIDTH-1:0] cfg_source_port, 

    input wire [SESSION_USERS_COUNT*UDP_IP_WIDTH-1:0] cfg_dest_ip,
    input wire [SESSION_USERS_COUNT*UDP_PORT_WIDTH-1:0] cfg_dest_port,    
    input wire [SESSION_USERS_COUNT*UDP_LENGTH_WIDTH-1:0] cfg_udp_ip_length,
    //input wire cfg_tx_udp_hdr_valid,
    //output wire cfg_rx_udp_hdr_valid,
    //output wire cfg_tx_udp_hdr_ready,
    //input wire cfg_rx_udp_hdr_ready,
    output wire [1:0]  speed,

    /*
     * UART: 115200 bps, 8N1
     */
    input  wire       uart_rxd,
    output wire       uart_txd
);

localparam [3:0]
    STATE_IDLE = 4'd0,
    STATE_GET_TYPE = 4'd1,
    STATE_GET_SRC_ID = 4'd2,
    STATE_SWITCH = 4'd3,
    STATE_SEND_PACKET = 4'd4,
    STATE_DUMP_PACKET = 4'd5;

// Ethernet frame between Ethernet modules and UDP stack
wire rx_eth_hdr_ready;
wire rx_eth_hdr_valid;
wire [47:0] rx_eth_dest_mac;
wire [47:0] rx_eth_src_mac;
wire [15:0] rx_eth_type;
wire [7:0] rx_eth_payload_axis_tdata;
wire rx_eth_payload_axis_tvalid;
wire rx_eth_payload_axis_tready;
wire rx_eth_payload_axis_tlast;
wire rx_eth_payload_axis_tuser;

wire tx_eth_hdr_ready;
wire tx_eth_hdr_valid;
wire [47:0] tx_eth_dest_mac;
wire [47:0] tx_eth_src_mac;
wire [15:0] tx_eth_type;
wire [7:0] tx_eth_payload_axis_tdata;
wire tx_eth_payload_axis_tvalid;
wire tx_eth_payload_axis_tready;
wire tx_eth_payload_axis_tlast;
wire tx_eth_payload_axis_tuser;

// IP frame connections
wire rx_ip_hdr_valid;
wire rx_ip_hdr_ready;
wire [47:0] rx_ip_eth_dest_mac;
wire [47:0] rx_ip_eth_src_mac;
wire [15:0] rx_ip_eth_type;
wire [3:0] rx_ip_version;
wire [3:0] rx_ip_ihl;
wire [5:0] rx_ip_dscp;
wire [1:0] rx_ip_ecn;
wire [15:0] rx_ip_length;
wire [15:0] rx_ip_identification;
wire [2:0] rx_ip_flags;
wire [12:0] rx_ip_fragment_offset;
wire [7:0] rx_ip_ttl;
wire [7:0] rx_ip_protocol;
wire [15:0] rx_ip_header_checksum;
wire [31:0] rx_ip_source_ip;
wire [31:0] rx_ip_dest_ip;
wire [7:0] rx_ip_payload_axis_tdata;
wire rx_ip_payload_axis_tvalid;
wire rx_ip_payload_axis_tready;
wire rx_ip_payload_axis_tlast;
wire rx_ip_payload_axis_tuser;

wire tx_ip_hdr_valid;
wire tx_ip_hdr_ready;
wire [5:0] tx_ip_dscp;
wire [1:0] tx_ip_ecn;
wire [15:0] tx_ip_length;
wire [7:0] tx_ip_ttl;
wire [7:0] tx_ip_protocol;
wire [31:0] tx_ip_source_ip;
wire [31:0] tx_ip_dest_ip;
wire [7:0] tx_ip_payload_axis_tdata;
wire tx_ip_payload_axis_tvalid;
wire tx_ip_payload_axis_tready;
wire tx_ip_payload_axis_tlast;
wire tx_ip_payload_axis_tuser;

// UDP frame connections
wire rx_udp_hdr_valid;
wire rx_udp_hdr_ready;
reg rx_udp_hdr_ready_reg;
wire [47:0] rx_udp_eth_dest_mac;
wire [47:0] rx_udp_eth_src_mac;
wire [15:0] rx_udp_eth_type;
wire [3:0] rx_udp_ip_version;
wire [3:0] rx_udp_ip_ihl;
wire [5:0] rx_udp_ip_dscp;
wire [1:0] rx_udp_ip_ecn;
wire [15:0] rx_udp_ip_length;
wire [15:0] rx_udp_ip_identification;
wire [2:0] rx_udp_ip_flags;
wire [12:0] rx_udp_ip_fragment_offset;
wire [7:0] rx_udp_ip_ttl;
wire [7:0] rx_udp_ip_protocol;
wire [15:0] rx_udp_ip_header_checksum;
wire [31:0] rx_udp_ip_source_ip;
wire [31:0] rx_udp_ip_dest_ip;
wire [15:0] rx_udp_source_port;
wire [15:0] rx_udp_dest_port;
wire [15:0] rx_udp_length;
wire [15:0] rx_udp_checksum;
wire [7:0] rx_udp_payload_axis_tdata;
wire rx_udp_payload_axis_tvalid;
wire rx_udp_payload_axis_tready;
reg rx_udp_payload_axis_tready_reg;
wire rx_udp_payload_axis_tlast;
wire rx_udp_payload_axis_tuser;

wire tx_udp_hdr_valid;
wire tx_udp_hdr_ready;
wire [5:0] tx_udp_ip_dscp;
wire [1:0] tx_udp_ip_ecn;
wire [7:0] tx_udp_ip_ttl;
wire [31:0] tx_udp_ip_source_ip;
wire [31:0] tx_udp_ip_dest_ip;
wire [15:0] tx_udp_source_port;
wire [15:0] tx_udp_dest_port;
wire [15:0] tx_udp_length;
wire [15:0] tx_udp_checksum;

wire [7:0] tx_udp_payload_axis_tdata;
wire tx_udp_payload_axis_tvalid;
wire tx_udp_payload_axis_tready;
wire tx_udp_payload_axis_tlast;
wire tx_udp_payload_axis_tuser;



           
//wire [7:0] rx_fifo_ch_udp_payload_axis_tdata;
//wire rx_fifo_ch_udp_payload_axis_tvalid;
//wire rx_fifo_ch_udp_payload_axis_tready;
//wire rx_fifo_ch_udp_payload_axis_tlast;
//wire rx_fifo_ch_udp_payload_axis_tuser;


wire [SESSION_USERS_COUNT*UDP_DATA_WIDTH-1:0] rx_fifo_ch_udp_payload_axis_tdata;
reg [SESSION_USERS_COUNT*UDP_DATA_WIDTH-1:0] rx_fifo_ch_udp_payload_axis_tdata_reg;
wire [SESSION_USERS_COUNT-1:0] rx_fifo_ch_udp_payload_axis_tvalid;
reg [SESSION_USERS_COUNT-1:0] rx_fifo_ch_udp_payload_axis_tvalid_reg;
wire [SESSION_USERS_COUNT-1:0] rx_fifo_ch_udp_payload_axis_tready;
//reg [SESSION_USERS_COUNT-1:0] rx_fifo_ch_udp_payload_axis_tready_reg; not used
wire [SESSION_USERS_COUNT-1:0] rx_fifo_ch_udp_payload_axis_tlast;
reg [SESSION_USERS_COUNT-1:0] rx_fifo_ch_udp_payload_axis_tlast_reg;
wire [SESSION_USERS_COUNT-1:0] rx_fifo_ch_udp_payload_axis_tuser;
reg [SESSION_USERS_COUNT-1:0] rx_fifo_ch_udp_payload_axis_tuser_reg;





//wire [7:0] tx_fifo_udp_payload_axis_tdata;
//wire tx_fifo_udp_payload_axis_tvalid;
//wire tx_fifo_udp_payload_axis_tready;
//wire tx_fifo_udp_payload_axis_tlast;
//wire tx_fifo_udp_payload_axis_tuser;


//wire [7:0]  tx_fifo_ch_audio_payload_axis_tdata;
//wire        tx_fifo_ch_audio_payload_axis_tvalid;
//wire        tx_fifo_ch_audio_payload_axis_tready;
//wire        tx_fifo_ch_audio_payload_axis_tlast;
//wire        tx_fifo_ch_audio_payload_axis_tuser;


wire [SESSION_USERS_COUNT*UDP_DATA_WIDTH-1:0]  tx_fifo_ch_audio_payload_axis_tdata;
wire [SESSION_USERS_COUNT-1:0] tx_fifo_ch_audio_payload_axis_tvalid;
wire [SESSION_USERS_COUNT-1:0] tx_fifo_ch_audio_payload_axis_tready;
wire [SESSION_USERS_COUNT-1:0] tx_fifo_ch_audio_payload_axis_tlast;
wire [SESSION_USERS_COUNT-1:0] tx_fifo_ch_audio_payload_axis_tuser;




wire [UDP_DATA_WIDTH-1:0]   tx_stream_fifo_udp_payload_axis_tdata;
wire tx_stream_fifo_udp_payload_axis_tvalid;
wire tx_stream_fifo_udp_payload_axis_tready;
wire tx_stream_fifo_udp_payload_axis_tlast;
wire tx_stream_fifo_udp_payload_axis_tuser;



wire [SESSION_USERS_COUNT*UDP_DATA_WIDTH-1:0]   tx_to_arb_payload_axis_tdata;
wire [SESSION_USERS_COUNT-1:0]  tx_to_arb_payload_axis_tvalid;
wire [SESSION_USERS_COUNT-1:0] tx_to_arb_payload_axis_tready;
wire [SESSION_USERS_COUNT-1:0] tx_to_arb_payload_axis_tlast;
wire [SESSION_USERS_COUNT-1:0] tx_to_arb_payload_axis_tuser;


wire [SESSION_USERS_COUNT*UDP_DATA_WIDTH-1:0]    rx_fifo_audio_payload_axis_tdata;
wire [SESSION_USERS_COUNT-1:0]       rx_fifo_audio_payload_axis_tvalid;
wire [SESSION_USERS_COUNT-1:0]       rx_fifo_audio_payload_axis_tready;
wire [SESSION_USERS_COUNT-1:0]       rx_fifo_audio_payload_axis_tlast;
wire [SESSION_USERS_COUNT-1:0]       rx_fifo_audio_payload_axis_tuser;





wire [SESSION_USERS_COUNT-1:0] from_a_status_overflow;
wire [SESSION_USERS_COUNT-1:0] from_a_status_bad_frame;
wire [SESSION_USERS_COUNT-1:0] from_a_status_good_frame;

wire [SESSION_USERS_COUNT-1:0] to_a_status_overflow;
wire [SESSION_USERS_COUNT-1:0] to_a_status_bad_frame;
wire [SESSION_USERS_COUNT-1:0] to_a_status_good_frame;


wire udp_status_overflow;
wire udp_status_bad_frame;
wire udp_status_good_frame;
wire udp_tx_error_payload_early_termination_w;

// Configuration
//wire [47:0] local_mac   = 48'h02_00_00_00_00_00;
//wire [31:0] local_ip    = {8'd192, 8'd168, 8'd1,   8'd128};
//wire [31:0] gateway_ip  = {8'd192, 8'd168, 8'd1,   8'd1};
//wire [31:0] subnet_mask = {8'd255, 8'd255, 8'd255, 8'd0};

wire [47:0] local_mac;
wire [31:0] local_ip;
wire [31:0] gateway_ip;
wire [31:0] subnet_mask;


assign local_mac = cfg_local_mac;
assign local_ip = cfg_local_ip;
assign gateway_ip = cfg_gateway_ip;
assign subnet_mask = cfg_subnet_mask;

// IP ports not used
assign rx_ip_hdr_ready = 1;
assign rx_ip_payload_axis_tready = 1;

assign tx_ip_hdr_valid = 0;
assign tx_ip_dscp = 0;
assign tx_ip_ecn = 0;
assign tx_ip_length = 0;
assign tx_ip_ttl = 0;
assign tx_ip_protocol = 0;
assign tx_ip_source_ip = 0;
assign tx_ip_dest_ip = 0;
assign tx_ip_payload_axis_tdata = 0;
assign tx_ip_payload_axis_tvalid = 0;
assign tx_ip_payload_axis_tlast = 0;
assign tx_ip_payload_axis_tuser = 0;


assign udp_status_overflow = from_sw_tx_fifo_overflow;
assign udp_status_bad_frame = from_sw_tx_fifo_bad_frame;
assign udp_status_good_frame = from_sw_tx_fifo_good_frame;
//    from_sw_rx_error_bad_frame(),
//    from_sw_rx_error_bad_fcs(),
//    from_sw_rx_fifo_overflow(),
//    from_sw_rx_fifo_bad_frame(),
//    from_sw_rx_fifo_good_frame(),
assign speed = from_sw_speed;

assign to_sw_ifg_delay = 12;


reg [15:0]  sync_rx_pkt_count_reg;
reg [15:0]  audio_rx_pkt_count_reg;
reg [15:0]  mock_rx_pkt_count_reg;
        
reg [15:0]  sync_tx_pkt_count_reg;
reg [15:0]  audio_tx_pkt_count_reg;


assign sync_rx_pkt_count = sync_rx_pkt_count_reg;
assign audio_rx_pkt_count = audio_rx_pkt_count_reg;
assign mock_rx_pkt_count = mock_rx_pkt_count_reg;
        
assign sync_tx_pkt_count = sync_tx_pkt_count_reg;
assign audio_tx_pkt_count = audio_tx_pkt_count_reg;




wire s_arb_to_udp_hdr_valid;
wire s_arb_to_udp_hdr_ready;
wire [UDP_IP_WIDTH-1:0] s_arb_to_udp_source_ip;
wire [UDP_IP_WIDTH-1:0] s_arb_to_udp_dest_ip;
wire [UDP_PORT_WIDTH-1:0] s_arb_to_udp_length;
wire [UDP_PORT_WIDTH-1:0] s_arb_to_udp_dest_port;
wire [UDP_PORT_WIDTH-1:0] s_arb_to_udp_source_port;


// Loop back UDP//We will use port numbers to identify services// eg 12345==streaming port
// match_cond to match_cond_reg only for audio rx 
wire [SESSION_USERS_COUNT-1:0] match_cond;
wire [SESSION_USERS_COUNT-1:0] no_match;


reg [3:0] state_reg = STATE_IDLE;
reg fsm_ready_ctrl_reg;
reg in_send_state_reg;
wire in_send_state;

reg [7:0] packet_type_reg;
reg [7:0] packet_src_id_reg;

wire [7:0] packet_type;
wire [7:0] packet_src_id;

wire [SESSION_USERS_COUNT-1:0] switch_bit_mask;
reg [SESSION_USERS_COUNT-1:0] switch_bit_mask_reg;

wire sw_in_idle_state;
reg sw_in_idle_state_reg;

assign sw_in_idle_state = sw_in_idle_state_reg;

assign switch_bit_mask = switch_bit_mask_reg;

assign packet_type = packet_type_reg;
assign packet_src_id = packet_src_id_reg;

assign in_send_state = in_send_state_reg;

generate
    genvar n;
    for (n = 0; n < SESSION_USERS_COUNT; n = n + 1) begin
        assign match_cond[n] = (rx_udp_dest_port == cfg_dest_port[n*UDP_PORT_WIDTH+:UDP_PORT_WIDTH]) && (cfg_dest_port[n*UDP_PORT_WIDTH+:UDP_PORT_WIDTH] != 0);
        assign no_match[n] = !match_cond[n];
        assign m_ch_audio_payload_hdr_valid[n] =  rx_udp_hdr_valid && match_cond[n];
        
    end
endgenerate

//assign s_audio_payload_hdr_ready = tx_udp_hdr_ready;
assign s_arb_to_udp_hdr_ready = tx_udp_hdr_ready;
//assign tx_udp_hdr_valid = rx_udp_hdr_valid && match_cond;
//assign m_ch_audio_payload_hdr_valid = {rx_udp_hdr_valid && match_cond[0],rx_udp_hdr_valid && match_cond[1],
//                                        rx_udp_hdr_valid && match_cond[2],rx_udp_hdr_valid && match_cond[3],
//                                        rx_udp_hdr_valid && match_cond[4]};
//assign tx_udp_hdr_valid = cfg_tx_udp_hdr_valid;
//assign tx_udp_hdr_valid = s_audio_payload_hdr_valid;
assign tx_udp_hdr_valid = s_arb_to_udp_hdr_valid;
//assign rx_udp_hdr_ready = (tx_eth_hdr_ready && match_cond) ;
//assign rx_udp_hdr_ready = (m_ch1_audio_payload_hdr_ready && match_cond)|| no_match;
assign tx_udp_ip_dscp = 0;
assign tx_udp_ip_ecn = 0;
assign tx_udp_ip_ttl = 64;
assign tx_udp_ip_source_ip = cfg_local_ip; 
//assign tx_udp_ip_source_ip = s_arb_to_udp_source_ip; 
//assign tx_udp_ip_dest_ip = rx_udp_ip_source_ip; //now set from linux
//assign tx_udp_source_port = rx_udp_dest_port; //now conditional
//assign tx_udp_dest_port = rx_udp_source_port; //now conditional

//assign tx_udp_ip_dest_ip = cfg_dest_ip;
//assign tx_udp_dest_port = cfg_dest_port;
assign tx_udp_ip_dest_ip = s_arb_to_udp_dest_ip;
assign tx_udp_dest_port = s_arb_to_udp_dest_port;

assign tx_udp_source_port = s_arb_to_udp_source_port;
/*
UDP Lenth
This field that specifies the length in bytes of the UDP header and UDP data. 
The minimum length is 8 bytes, the length of the header. 
The field size sets a theoretical limit of 65,535 bytes (8 byte header + 65,527 bytes of data) 
for a UDP datagram. However the actual limit for the data length, which is imposed by the underlying IPv4 protocol, 
is 65,507 bytes (65,535 - 8 byte UDP header - 20 byte IP header).[4]
*/
//assign tx_udp_length = cfg_udp_ip_length; //now conditional 8 added in fpga.v
assign tx_udp_length = s_arb_to_udp_length;
assign tx_udp_checksum = 0;




assign rx_udp_hdr_ready = rx_udp_hdr_ready_reg;
assign rx_fifo_ch_udp_payload_axis_tvalid = rx_fifo_ch_udp_payload_axis_tvalid_reg;
assign rx_fifo_ch_udp_payload_axis_tlast = rx_fifo_ch_udp_payload_axis_tlast_reg;
assign rx_fifo_ch_udp_payload_axis_tdata = rx_fifo_ch_udp_payload_axis_tdata_reg;


assign rx_udp_payload_axis_tready = rx_udp_payload_axis_tready_reg;


// AXIS input from udp core to fifo
//assign rx_fifo_ch_udp_payload_axis_tdata = rx_udp_payload_axis_tdata;
//assign rx_fifo_ch_udp_payload_axis_tvalid = rx_udp_payload_axis_tvalid && match_cond_reg;
//assign rx_udp_payload_axis_tready  = (rx_fifo_ch_udp_payload_axis_tready && match_cond_reg) || no_match_reg;
//assign rx_fifo_ch_udp_payload_axis_tlast = rx_udp_payload_axis_tlast;
//assign rx_fifo_ch_udp_payload_axis_tuser = rx_udp_payload_axis_tuser;
    
// AXIS fifo output to udp core
assign tx_udp_payload_axis_tdata = tx_stream_fifo_udp_payload_axis_tdata;
assign tx_udp_payload_axis_tvalid = tx_stream_fifo_udp_payload_axis_tvalid;
assign tx_stream_fifo_udp_payload_axis_tready = tx_udp_payload_axis_tready;
assign tx_udp_payload_axis_tlast = tx_stream_fifo_udp_payload_axis_tlast;
assign tx_udp_payload_axis_tuser = tx_stream_fifo_udp_payload_axis_tuser;


//Connect UDP FIFO to the output to all channels of audio core
assign m_ch_audio_payload_axis_tdata = tx_fifo_ch_audio_payload_axis_tdata;
assign m_ch_audio_payload_axis_tvalid = tx_fifo_ch_audio_payload_axis_tvalid; 
assign tx_fifo_ch_audio_payload_axis_tready = m_ch_audio_payload_axis_tready;
assign m_ch_audio_payload_axis_tlast = tx_fifo_ch_audio_payload_axis_tlast;
assign m_ch_audio_payload_axis_tuser = tx_fifo_ch_audio_payload_axis_tuser;

//Connect input from Audio FIFO to UDP fifo
assign rx_fifo_audio_payload_axis_tdata = s_audio_payload_axis_tdata;
assign rx_fifo_audio_payload_axis_tvalid = s_audio_payload_axis_tvalid;
assign s_audio_payload_axis_tready = rx_fifo_audio_payload_axis_tready;
assign rx_fifo_audio_payload_axis_tlast = s_audio_payload_axis_tlast;
assign rx_fifo_audio_payload_axis_tuser = s_audio_payload_axis_tuser;


//assign tx_udp_payload_axis_tdata = tx_fifo_udp_payload_axis_tdata;
//assign tx_udp_payload_axis_tvalid = tx_fifo_udp_payload_axis_tvalid;
//assign tx_fifo_udp_payload_axis_tready = tx_udp_payload_axis_tready;
//assign tx_udp_payload_axis_tlast = tx_fifo_udp_payload_axis_tlast;
//assign tx_udp_payload_axis_tuser = tx_fifo_udp_payload_axis_tuser;

//assign rx_fifo_udp_payload_axis_tdata = rx_udp_payload_axis_tdata;
//assign rx_fifo_udp_payload_axis_tvalid = rx_udp_payload_axis_tvalid && match_cond_reg;
//assign rx_udp_payload_axis_tready = (rx_fifo_udp_payload_axis_tready && match_cond_reg) || no_match_reg;
//assign rx_fifo_udp_payload_axis_tlast = rx_udp_payload_axis_tlast;
//assign rx_fifo_udp_payload_axis_tuser = rx_udp_payload_axis_tuser;

    

assign  rx_stk_state ={1'b0,tx_to_arb_payload_axis_tready[1], tx_to_arb_payload_axis_tvalid[1], tx_to_arb_payload_axis_tlast[1],
                      1'b0,tx_fifo_ch_audio_payload_axis_tready[1], tx_fifo_ch_audio_payload_axis_tvalid[1], tx_fifo_ch_audio_payload_axis_tlast[1], 
                      1'b0, arp_response_error, arp_response_valid, arp_response_ready, 
                       1'b0, udp_rx_error_header_early_termination,udp_rx_error_payload_early_termination, udp_tx_error_payload_early_termination, 
                       3'b000,in_send_state_reg, 
                       state_reg,
                       1'b0,switch_bit_mask, fsm_ready_ctrl_reg,
                       rx_eth_hdr_ready, rx_eth_hdr_valid, rx_udp_hdr_ready, rx_udp_hdr_valid};//LSB
//assign bus_status   = {1'b0,m_from_fifo_axis_tready,m_from_fifo_axis_tvalid,m_from_fifo_axis_tlast,2'b00,buffer_unlock,sw_var_rd};
assign bus_status   = {  1'b0,tx_stream_fifo_udp_payload_axis_tready,tx_stream_fifo_udp_payload_axis_tvalid,tx_stream_fifo_udp_payload_axis_tlast,                      
                      1'b0,tx_to_arb_payload_axis_tready[0], tx_to_arb_payload_axis_tvalid[0], tx_to_arb_payload_axis_tlast[0],
                      1'b0,tx_fifo_ch_audio_payload_axis_tready[0], tx_fifo_ch_audio_payload_axis_tvalid[0], tx_fifo_ch_audio_payload_axis_tlast[0], 
                      1'b0,rx_udp_payload_axis_tready,rx_udp_payload_axis_tvalid,rx_udp_payload_axis_tlast,
                      1'b0,tx_eth_payload_axis_tready, tx_eth_payload_axis_tvalid, tx_eth_payload_axis_tlast,
                      1'b0,to_sw_tx_axis_tready, to_sw_tx_axis_tvalid, to_sw_tx_axis_tlast, 
                      1'b0,rx_eth_payload_axis_tready, rx_eth_payload_axis_tvalid, rx_eth_payload_axis_tlast,
                      1'b0,from_sw_rx_axis_tready,from_sw_rx_axis_tvalid,from_sw_rx_axis_tlast};



reg [SESSION_USERS_COUNT-1:0] match_cond_reg = 0;
reg [SESSION_USERS_COUNT-1:0] no_match_reg = 0;
// match_cond to match_cond_reg

//always @(posedge clk) begin
//    if (rst) begin
//        match_cond_reg <= 0;
//        no_match_reg <= 0;
//    end else begin
//        if (rx_udp_payload_axis_tvalid) begin
        
//            if (|((~match_cond_reg) & (~no_match_reg)) ||
//                (|(rx_udp_payload_axis_tvalid & rx_udp_payload_axis_tready & rx_udp_payload_axis_tlast))) begin
//                match_cond_reg <= match_cond;
//                no_match_reg <= no_match;
//            end
            
//        end else begin
//            match_cond_reg <= 0;
//            no_match_reg <= 0;
//        end
//    end
//end

generate
    genvar x;

    for (x = 0; x < SESSION_USERS_COUNT; x = x + 1) begin

always @(posedge clk) begin
    if (rst) begin
        match_cond_reg[x] <= 0;
        no_match_reg[x] <= 0;
    end else begin
        if (rx_udp_payload_axis_tvalid) begin
            if ((!match_cond_reg[x] && !no_match_reg[x]) ||
                (rx_udp_payload_axis_tvalid && rx_udp_payload_axis_tready && rx_udp_payload_axis_tlast)) begin
                match_cond_reg[x] <= match_cond[x];
                no_match_reg[x] <= no_match[x];
            end else begin
                    match_cond_reg[x] <= match_cond_reg[x];
                    no_match_reg[x] <= no_match_reg[x];
            end
        end else begin
            match_cond_reg[x] <= 0;
            no_match_reg[x] <= 0;
        end
    end
end


    end
endgenerate


//generate
//    genvar y;

//    for (y = 0; y < SESSION_USERS_COUNT; y = y + 1) begin
//    always @* begin
////        rx_fifo_ch_udp_payload_axis_tdata_reg[(y+1)*UDP_DATA_WIDTH - 1:y*UDP_DATA_WIDTH] = rx_udp_payload_axis_tdata;
//        rx_fifo_ch_udp_payload_axis_tdata_reg[y*UDP_DATA_WIDTH+:UDP_DATA_WIDTH] <= rx_udp_payload_axis_tdata;
        
//        rx_fifo_ch_udp_payload_axis_tuser_reg[y] <= rx_udp_payload_axis_tuser;
//        end
//     end
//endgenerate






// Place first payload byte onto LEDs//change this to our packet ID for our switch
reg valid_last = 0;
reg [7:0] led_reg = 0;




always  @(posedge clk) begin 
    if (rst) begin
        led_reg[7] <= 1;
        led_reg[6] <= 1;
        led_reg[5] <= 1;
        led_reg[4] <= 1;
        led_reg[3] <= 1;
//        led_reg[2] <= 0;
//        led_reg[1] <= 0;
    end else begin
        led_reg[7] <= sync_done_in;
//        led_reg[6] <= ~(|rx_fifo_audio_payload_axis_tready);
//            led_reg[6] <= initiate_sync_response_in;
//         led_reg[6] <= arp_response_ready;
        led_reg[6] <= udp_stream_tx_enable[1];
//        led_reg[5] <= ~(|rx_fifo_ch_udp_payload_axis_tready);
        led_reg[5] <= rx_udp_payload_axis_tready;
//        led_reg[5] <=  udp_stream_tx_enable[0];
//        led_reg[4] <= sync_request_rx_in;
            led_reg[4] <= arp_response_error;
        //led_reg[3] <= subnet_mask == {8'd255, 8'd255, 8'd255, 8'd0};
        //led_reg[2] <= tx_udp_dest_port == 16'd1234;
        //led_reg[1] <= tx_udp_source_port == 16'd1234;
        //led_reg[7] <= udp_tx_error_payload_early_termination_w;
        //led_reg[6] <= status_overflow;
//        led_reg[5] <= status_bad_frame;
//        led_reg[4] <= |m_ch_audio_payload_hdr_ready;
        //led_reg[3] <= rx_fifo_ch_udp_payload_axis_tvalid;
//        led_reg[4] <=  tx_to_arb_payload_axis_tvalid[0];
//       led_reg[4] <=  |fifo_full_in;
//        led_reg[3] <=  rx_fifo_audio_payload_axis_tready[0];
//led_reg[3] <=  |fifo_empty_in;
//            led_reg[3] <=  tsync_status2_in; // dump pkt
            led_reg[3] <=  arp_response_valid;
//          led_reg[3] <= |m_ch_audio_payload_hdr_valid;
//        led_reg[2] <= udp_status_bad_frame;
//        led_reg[1] <= udp_status_good_frame;
//        if (rx_fifo_audio_payload_axis_tlast) begin
//            if (!valid_last) begin
//                //led_reg <= tx_udp_payload_axis_tdata;
                
//                valid_last <= 1'b1;
                
//            end else begin
//                //led_reg[0] <= 1'b0;
//                valid_last <= 1'b0;
//            end
//        end
    end
end


reg [31:0] counter;
reg pulse_reset;

//// async edge latch
//always @(posedge sw_sel_status or 
//         posedge pulse_reset)
//begin
//	if(pulse_reset == 1) begin
//		led_reg[5] <= 0;
//	end else begin
//	   if(sw_sel_status) begin
//		  led_reg[5] <= 1'b1;
//	   end	   
//	end
//end


// async edge latch
always @(posedge |rx_fifo_audio_payload_axis_tlast or 
         posedge pulse_reset)
begin
	if(pulse_reset == 1) begin
		led_reg[0] <= 0;
	end else begin
	   if(|rx_fifo_audio_payload_axis_tlast) begin
		  led_reg[0] <= 1'b1;
	   end	   
	end
end





always @(
         posedge pulse_reset or 
         posedge rx_udp_payload_axis_tlast)
begin
	if(pulse_reset == 1) begin
		led_reg[2] <= 0;
	end else begin
	   	   
	   if(rx_udp_payload_axis_tlast) begin
		  led_reg[2] <= 1'b1;
	   end
	end
end



always @(posedge pulse_reset or
         posedge (tx_udp_payload_axis_tlast))
begin
	if(pulse_reset == 1) begin
		led_reg[1] <= 0;

	end else begin	  
	   
	   if(tx_udp_payload_axis_tlast) begin
		  led_reg[1] <= 1'b1;
	   end	   
	   
	end
end




// One shot counter
always @(posedge clk)
begin
	if(rst == 1) begin
		counter <= 32'd0;
		pulse_reset <= 0;
	end else begin
		
			if(counter < 32'h08FF_FFFF) begin // is delay
				counter <= counter + 1;
			end else begin
				counter <= 0;
				pulse_reset <= ~pulse_reset;
			end
		
	end
end




always @* begin

    rx_udp_hdr_ready_reg = 1;//(|((((|(m_ch_audio_payload_hdr_ready & switch_bit_mask)) && match_cond)| no_match)))||sw_in_idle_state;
  
  rx_fifo_ch_udp_payload_axis_tdata_reg = {SESSION_USERS_COUNT{rx_udp_payload_axis_tdata}};
    //rx_fifo_ch_udp_payload_axis_tvalid_reg = rx_udp_payload_axis_tvalid && match_cond_reg;
    rx_fifo_ch_udp_payload_axis_tvalid_reg = ({SESSION_USERS_COUNT{rx_udp_payload_axis_tvalid}} & switch_bit_mask);  
    rx_fifo_ch_udp_payload_axis_tlast_reg = ({SESSION_USERS_COUNT{rx_udp_payload_axis_tlast}}  & switch_bit_mask);
    
    rx_fifo_ch_udp_payload_axis_tuser_reg = {SESSION_USERS_COUNT{rx_udp_payload_axis_tuser}};

    
      //rx_udp_payload_axis_tready_reg  = (|((((rx_fifo_ch_udp_payload_axis_tready & switch_bit_mask) && (|match_cond_reg)) | no_match_reg)))&&fsm_ready_ctrl_reg;
      
      rx_udp_payload_axis_tready_reg  = ((|(rx_fifo_ch_udp_payload_axis_tready & switch_bit_mask))&& in_send_state) || fsm_ready_ctrl_reg;
    
    
end


wire sync_tx_tlast;
wire audio_tx_tlast;
assign sync_tx_tlast = rx_fifo_audio_payload_axis_tlast[0];
assign audio_tx_tlast = rx_fifo_audio_payload_axis_tlast[1];

always @(posedge sync_tx_tlast or posedge rst)
begin

    if (rst) begin
        sync_tx_pkt_count_reg <= 0;
    end else begin
        if(sync_tx_tlast) begin
            sync_tx_pkt_count_reg <= sync_tx_pkt_count + 1;
        end else begin
            sync_tx_pkt_count_reg <= sync_tx_pkt_count;
        end
    end

end


always @(posedge audio_tx_tlast or posedge rst)
begin
     if (rst) begin
        audio_tx_pkt_count_reg <= 0;
     end else begin
        if(audio_tx_tlast) begin
            audio_tx_pkt_count_reg <= audio_tx_pkt_count + 1; 
        end else begin 
            audio_tx_pkt_count_reg <= audio_tx_pkt_count; 
        end
     end

end



always  @(posedge clk) begin 
    if (rst) begin
        in_send_state_reg <= 0;
        fsm_ready_ctrl_reg <= 0;
        state_reg <= STATE_IDLE;
        packet_type_reg <= 0;
        packet_src_id_reg <= 0;
        sync_rx_pkt_count_reg <= 0;
        audio_rx_pkt_count_reg <= 0;
        sw_in_idle_state_reg <= 0;
        
//reg [15:0]  sync_tx_pkt_count_reg;
//reg [15:0]  audio_tx_pkt_count_reg;
    end else begin
        case (state_reg)
        STATE_IDLE: begin
            // wait for outgoing packet
            fsm_ready_ctrl_reg <= 0;
            in_send_state_reg <= 0;
            sw_in_idle_state_reg <= 1;
            if (((|match_cond_reg)||(|no_match)) && rx_udp_payload_axis_tvalid) begin
                // read pkt type
                state_reg <= STATE_GET_TYPE;
                fsm_ready_ctrl_reg  <= 1;
                sw_in_idle_state_reg <= 0;
            end else begin
                state_reg <= STATE_IDLE;
                fsm_ready_ctrl_reg  <= 0;
            end
            
            
            if(rx_udp_payload_axis_tlast == 1) begin
                state_reg <= STATE_IDLE;
                fsm_ready_ctrl_reg <= 0;
                in_send_state_reg <= 0;
                switch_bit_mask_reg <= 8'b00;
            end
            
        end
        STATE_GET_TYPE: begin
            fsm_ready_ctrl_reg  <= 1;
            packet_type_reg <=  rx_udp_payload_axis_tdata;
           if(rx_udp_payload_axis_tvalid == 1) begin              
                state_reg <= STATE_GET_SRC_ID;
            end else begin
                state_reg <= STATE_GET_TYPE;
            end
            
            
            if(rx_udp_payload_axis_tlast == 1) begin
                state_reg <= STATE_IDLE;
                fsm_ready_ctrl_reg <= 0;
                in_send_state_reg <= 0;
                switch_bit_mask_reg <= 8'b00;
            end
           
        end
        STATE_GET_SRC_ID: begin
            packet_src_id_reg <=  rx_udp_payload_axis_tdata; 
               fsm_ready_ctrl_reg  <= 1;
           if(rx_udp_payload_axis_tvalid == 1) begin               
                state_reg <= STATE_SWITCH;
                fsm_ready_ctrl_reg <= 0;
            end else begin
                state_reg <= STATE_GET_TYPE;
            end
            
            
            if(rx_udp_payload_axis_tlast == 1) begin
                state_reg <= STATE_IDLE;
                fsm_ready_ctrl_reg <= 0;
                in_send_state_reg <= 0;
                switch_bit_mask_reg <= 8'b00;
            end
           
        end
        STATE_SWITCH: begin
            state_reg <= STATE_SEND_PACKET;
//            fsm_ready_ctrl_reg <= 0;
            in_send_state_reg <= 1;
            //This is the correct way either board can be 00 or 01
//            if(packet_src_id == 8'h00 && packet_type == 8'hAA) begin
//                switch_bit_mask_reg <= 8'b01;
//                fsm_ready_ctrl_reg <= 0;
//             end
//             else if(packet_src_id == 8'h00 && packet_type == 8'h55) begin
//                switch_bit_mask_reg <= 8'b10;
//                fsm_ready_ctrl_reg <= 0;
//             end 
//             else if(packet_src_id == 8'h01 && packet_type == 8'hAA) begin
//                switch_bit_mask_reg <= 8'b01;
//                fsm_ready_ctrl_reg <= 0;
//             end 
//             else if(packet_src_id == 8'h01 && packet_type == 8'h55) begin
//                switch_bit_mask_reg <= 8'b10;
//                fsm_ready_ctrl_reg <= 0;
//             end else begin
//                switch_bit_mask_reg <= 8'b00;
//                fsm_ready_ctrl_reg <= 1;
//             end

//Just type for now
             if((packet_type == 8'hAA) && (|match_cond_reg)) begin //time packet
                switch_bit_mask_reg <= 8'b01;
                fsm_ready_ctrl_reg <= 0;
                sync_rx_pkt_count_reg <= sync_rx_pkt_count + 1;
//                state_reg <= STATE_DUMP_PACKET;
             end
             else if((packet_type == 8'h55) && (|match_cond_reg)) begin //audio
                switch_bit_mask_reg <= 8'b10;
                fsm_ready_ctrl_reg <= 0;
                audio_rx_pkt_count_reg <= audio_rx_pkt_count + 1;
//                state_reg <= STATE_DUMP_PACKET;
             end 
             else begin
                switch_bit_mask_reg <= 8'b00;
                fsm_ready_ctrl_reg <= 1;
                mock_rx_pkt_count_reg <= mock_rx_pkt_count + 1;
                state_reg <= STATE_DUMP_PACKET;
             end
             
             
             
             if(rx_udp_payload_axis_tlast == 1) begin
                state_reg <= STATE_IDLE;
                fsm_ready_ctrl_reg <= 0;
                in_send_state_reg <= 0;
                switch_bit_mask_reg <= 8'b00;
            end
             
        end
        
        STATE_SEND_PACKET: begin
            //fsm_ready_ctrl_reg <= 1;
            in_send_state_reg <= 1;
            if((rx_udp_payload_axis_tlast == 1) && (rx_udp_payload_axis_tvalid == 1) && ((rx_udp_payload_axis_tready == 1)||(fsm_ready_ctrl_reg == 1))) begin
                state_reg <= STATE_IDLE;
                fsm_ready_ctrl_reg <= 0;
                in_send_state_reg <= 0;
                switch_bit_mask_reg <= 8'b00;
            end else begin
                state_reg <= STATE_SEND_PACKET;
            end
        end
        
        STATE_DUMP_PACKET: begin
            fsm_ready_ctrl_reg <= 1;
            in_send_state_reg <= 0;
            if((rx_udp_payload_axis_tlast == 1) && (rx_udp_payload_axis_tvalid == 1) && ((rx_udp_payload_axis_tready == 1)||(fsm_ready_ctrl_reg == 1))) begin
                state_reg <= STATE_IDLE;
                fsm_ready_ctrl_reg <= 0;
                in_send_state_reg <= 0;
                switch_bit_mask_reg <= 8'b00;
            end else begin
                state_reg <= STATE_DUMP_PACKET;
            end
        end
        
    endcase
    end
    
    
    
    
end




//Create the FIFO banks for the channels

genvar i;
generate for (i=0; i<SESSION_USERS_COUNT; i=i+1) begin:	from_udp_to_audio_fifo_bank
//From UDP to audio
axis_fifo #(
//    .ADDR_WIDTH(AUDIO_FIFO_ADDR_WIDTH + (i*3)),
    .ADDR_WIDTH(9 + (i*6)),
    .DATA_WIDTH(UDP_DATA_WIDTH),
    .KEEP_ENABLE(0),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .ID_WIDTH(1),
    .DEST_WIDTH(1),
    .FRAME_FIFO(0)
) from_udp_switch_to_audio (
    .clk(clk),
    .rst(rst),

    // AXIS input from udp core
    .s_axis_tdata(rx_fifo_ch_udp_payload_axis_tdata[i*UDP_DATA_WIDTH +: UDP_DATA_WIDTH]),
    .s_axis_tkeep(0),//must default to high in docs but its very bad
    .s_axis_tvalid(rx_fifo_ch_udp_payload_axis_tvalid[i]),
    .s_axis_tready(rx_fifo_ch_udp_payload_axis_tready[i]),
    .s_axis_tlast(rx_fifo_ch_udp_payload_axis_tlast[i]),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(rx_fifo_ch_udp_payload_axis_tuser[i]),

    // AXI output to audo core
    .m_axis_tdata(tx_fifo_ch_audio_payload_axis_tdata[i*UDP_DATA_WIDTH +: UDP_DATA_WIDTH]),
    .m_axis_tkeep(),
    .m_axis_tvalid(tx_fifo_ch_audio_payload_axis_tvalid[i]),
    .m_axis_tready(tx_fifo_ch_audio_payload_axis_tready[i]),
    .m_axis_tlast(tx_fifo_ch_audio_payload_axis_tlast[i]),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(tx_fifo_ch_audio_payload_axis_tuser[i]),

    // Status
    .status_overflow(to_a_status_overflow[i]),
    .status_bad_frame(to_a_status_bad_frame[i]),
    .status_good_frame(to_a_status_good_frame[i])
);

end
endgenerate

//Must be read many times for all other receivers
genvar k;
generate for (k=0; k<SESSION_USERS_COUNT; k=k+1) begin:	from_audio_to_udp_fifo_bank
//From audio to UDP
axis_fifo #(
    .ADDR_WIDTH(AUDIO_FIFO_ADDR_WIDTH),
    .DATA_WIDTH(UDP_DATA_WIDTH),
    .KEEP_ENABLE(0),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .ID_WIDTH(1),
    .DEST_WIDTH(1),
    .FRAME_FIFO(0)
)
audio_payload_fifo (
    .clk(clk),
    .rst(rst),

    // AXIS input from audio core
    .s_axis_tdata(rx_fifo_audio_payload_axis_tdata[k*UDP_DATA_WIDTH +: UDP_DATA_WIDTH]),
    .s_axis_tkeep(0), //must default to high in docs but its very bad
    .s_axis_tvalid(rx_fifo_audio_payload_axis_tvalid[k]),
    .s_axis_tready(rx_fifo_audio_payload_axis_tready[k]),
    .s_axis_tlast(rx_fifo_audio_payload_axis_tlast[k]),
    .s_axis_tid(0), //must default to low
    .s_axis_tdest(0), //must default to low
    .s_axis_tuser(rx_fifo_audio_payload_axis_tuser[k]),

    // AXIS output to udp core
    .m_axis_tdata(tx_to_arb_payload_axis_tdata[k*UDP_DATA_WIDTH +: UDP_DATA_WIDTH]),
    .m_axis_tkeep(),
    .m_axis_tvalid(tx_to_arb_payload_axis_tvalid[k]),
    .m_axis_tready(tx_to_arb_payload_axis_tready[k]),
    .m_axis_tlast(tx_to_arb_payload_axis_tlast[k]),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(tx_to_arb_payload_axis_tuser[k]),

    // Status
    .status_overflow(from_a_status_overflow[k]),
    .status_bad_frame(from_a_status_bad_frame[k]),
    .status_good_frame(from_a_status_good_frame[k])
);

end
endgenerate


// Parameters
parameter S_COUNT = 2;
parameter DATA_WIDTH = 8;
parameter KEEP_ENABLE = (DATA_WIDTH>8);
parameter KEEP_WIDTH = (DATA_WIDTH/8);
parameter ID_ENABLE = 0;
parameter ID_WIDTH = 8;
parameter DEST_ENABLE = 0;
parameter DEST_WIDTH = 8;
parameter USER_ENABLE = 0;
parameter USER_WIDTH = 1;
//parameter ARB_TYPE = "PRIORITY";
parameter ARB_TYPE = "ROUND_ROBIN";
parameter LSB_PRIORITY = "LOW";

/*
 * Audio AXIS FIFO to UDP arbiter
 */
udp_packet_axis_arb_mux #(
		.S_COUNT(S_COUNT),
		.DATA_WIDTH(DATA_WIDTH),
		.KEEP_ENABLE(KEEP_ENABLE),
		.KEEP_WIDTH(KEEP_WIDTH),
		.ID_ENABLE(ID_ENABLE),
		.ID_WIDTH(ID_WIDTH),
		.DEST_ENABLE(DEST_ENABLE),
		.DEST_WIDTH(DEST_WIDTH),
		.USER_ENABLE(USER_ENABLE),
		.USER_WIDTH(USER_WIDTH),
		.ARB_TYPE(ARB_TYPE),
		.LSB_PRIORITY(LSB_PRIORITY)
	)
	pkt_in_axis_arb_mux_inst (
	.clk(clk),
    .rst(rst),
    // Audio frame inputs from codec
//    .s_udp_hdr_valid(s_audio_payload_hdr_valid),
    .s_udp_hdr_valid(tx_to_arb_payload_axis_tvalid), //hdr valid and  valid are src aligned
    .s_udp_hdr_ready(s_audio_payload_hdr_ready),
    .s_udp_length(cfg_udp_ip_length),
    .s_udp_dest_port(cfg_dest_port),
    .s_udp_source_port(cfg_source_port),
    .s_udp_source_ip({SESSION_USERS_COUNT{cfg_local_ip}}),
    .s_udp_dest_ip(cfg_dest_ip),    
    .s_udp_payload_axis_tdata(tx_to_arb_payload_axis_tdata),
    .s_udp_payload_axis_tkeep(0),
    .s_udp_payload_axis_tvalid(tx_to_arb_payload_axis_tvalid),
    .s_udp_payload_axis_tready(tx_to_arb_payload_axis_tready),
    .s_udp_payload_axis_tlast(tx_to_arb_payload_axis_tlast),
    .s_udp_payload_axis_tid(0),
    .s_udp_payload_axis_tdest(0),
    .s_udp_payload_axis_tuser(tx_to_arb_payload_axis_tuser),
    // UDP frame output
    .m_udp_hdr_valid(s_arb_to_udp_hdr_valid),
    .m_udp_hdr_ready(s_arb_to_udp_hdr_ready),
    .m_udp_length(s_arb_to_udp_length),
    .m_udp_dest_port(s_arb_to_udp_dest_port),
    .m_udp_source_port(s_arb_to_udp_source_port),
    .m_udp_source_ip(s_arb_to_udp_source_ip),
    .m_udp_dest_ip(s_arb_to_udp_dest_ip),
    .m_udp_payload_axis_tdata(tx_stream_fifo_udp_payload_axis_tdata),
    .m_udp_payload_axis_tkeep(),
    .m_udp_payload_axis_tvalid(tx_stream_fifo_udp_payload_axis_tvalid),
    .m_udp_payload_axis_tready(tx_stream_fifo_udp_payload_axis_tready),
    .m_udp_payload_axis_tlast(tx_stream_fifo_udp_payload_axis_tlast),
    .m_udp_payload_axis_tid(),
    .m_udp_payload_axis_tdest(),
    .m_udp_payload_axis_tuser(tx_stream_fifo_udp_payload_axis_tuser)
);
/*
 * Audio AXIS FIFO to UDP arbiter
 */
//multi_slave_single_master_arb_mux #(
//    .S_COUNT(SESSION_USERS_COUNT),
//    .DATA_WIDTH(8),
//    .KEEP_ENABLE(0),
//    .ID_ENABLE(0),
//    .DEST_ENABLE(0),
//    .USER_ENABLE(1),
//    .USER_WIDTH(1),
//    .ID_WIDTH(1),
//    .DEST_WIDTH(1),
//    .BLOCK("ACKNOWLEDGE"),
//    .ARB_TYPE("ROUND_ROBIN"),
//    .LSB_PRIORITY("LOW")
//)
//audio_in_ch_arb_mux_inst (
//    .clk(clk),
//    .rst(rst),
//    // Audio frame inputs from codec
//    .s_udp_hdr_valid(s_audio_payload_hdr_valid),
//    .s_udp_hdr_ready(s_audio_payload_hdr_ready),
//    .s_udp_length(cfg_udp_ip_length),
//    .s_udp_dest_port(cfg_dest_port),
//    .s_udp_source_port(cfg_source_port),
//    .s_udp_source_ip({SESSION_USERS_COUNT{cfg_local_ip}}),
//    .s_udp_dest_ip(cfg_dest_ip),    
//    .s_udp_payload_axis_tdata(tx_to_arb_payload_axis_tdata),
//    .s_udp_payload_axis_tkeep(0),
//    .s_udp_payload_axis_tvalid(tx_to_arb_payload_axis_tvalid),
//    .s_udp_payload_axis_tready(tx_to_arb_payload_axis_tready),
//    .s_udp_payload_axis_tlast(tx_to_arb_payload_axis_tlast),
//    .s_udp_payload_axis_tid(0),
//    .s_udp_payload_axis_tdest(0),
//    .s_udp_payload_axis_tuser(tx_to_arb_payload_axis_tuser),
//    // UDP frame output
//    .m_udp_hdr_valid(s_arb_to_udp_hdr_valid),
//    .m_udp_hdr_ready(s_arb_to_udp_hdr_ready),
//    .m_udp_length(s_arb_to_udp_length),
//    .m_udp_dest_port(s_arb_to_udp_dest_port),
//    .m_udp_source_port(s_arb_to_udp_source_port),
//    .m_udp_source_ip(s_arb_to_udp_source_ip),
//    .m_udp_dest_ip(s_arb_to_udp_dest_ip),
//    .m_udp_payload_axis_tdata(tx_stream_fifo_udp_payload_axis_tdata),
//    .m_udp_payload_axis_tkeep(),
//    .m_udp_payload_axis_tvalid(tx_stream_fifo_udp_payload_axis_tvalid),
//    .m_udp_payload_axis_tready(tx_stream_fifo_udp_payload_axis_tready),
//    .m_udp_payload_axis_tlast(tx_stream_fifo_udp_payload_axis_tlast),
//    .m_udp_payload_axis_tid(),
//    .m_udp_payload_axis_tdest(),
//    .m_udp_payload_axis_tuser(tx_stream_fifo_udp_payload_axis_tuser)
//);


//axis_fifo #(
//    .ADDR_WIDTH(AUDIO_FIFO_ADDR_WIDTH),
//    .DATA_WIDTH(UDP_DATA_WIDTH),
//    .KEEP_ENABLE(0),
//    .ID_ENABLE(0),
//    .DEST_ENABLE(0),
//    .USER_ENABLE(1),
//    .USER_WIDTH(1),
//    .FRAME_FIFO(0)
//)
//udp_rx_ch1_payload_fifo (
//    .clk(clk),
//    .rst(rst),

//    // AXIS input from udp core
//    .s_axis_tdata(rx_fifo_ch_udp_payload_axis_tdata),
//    .s_axis_tkeep(0),//must default to high in docs but its very bad
//    .s_axis_tvalid(rx_fifo_ch_udp_payload_axis_tvalid),
//    .s_axis_tready(rx_fifo_ch_udp_payload_axis_tready),
//    .s_axis_tlast(rx_fifo_ch_udp_payload_axis_tlast),
//    .s_axis_tid(0),
//    .s_axis_tdest(0),
//    .s_axis_tuser(rx_fifo_ch_udp_payload_axis_tuser),

//    // AXI output to audo core
//    .m_axis_tdata(tx_fifo_ch_audio_payload_axis_tdata),
//    .m_axis_tkeep(),
//    .m_axis_tvalid(tx_fifo_ch_audio_payload_axis_tvalid),
//    .m_axis_tready(tx_fifo_ch_audio_payload_axis_tready),
//    .m_axis_tlast(tx_fifo_ch_audio_payload_axis_tlast),
//    .m_axis_tid(),
//    .m_axis_tdest(),
//    .m_axis_tuser(tx_fifo_ch_audio_payload_axis_tuser),

//    // Status
//    .status_overflow(),
//    .status_bad_frame(),
//    .status_good_frame()
//);


//assign led = sw;
assign led = led_reg;
//assign phy_reset_n = !rst;

assign uart_txd = 0;

//eth_mac_1g_rgmii_fifo #(
//    .TARGET(TARGET),
//    .IODDR_STYLE("IODDR"),
////    .CLOCK_INPUT_STYLE("BUFR"),
//    .CLOCK_INPUT_STYLE("BUFG"),
//    .USE_CLK90("TRUE"),
//    .ENABLE_PADDING(1),
//    .MIN_FRAME_LENGTH(64),
//    .TX_FIFO_ADDR_WIDTH(12),
//    .TX_FRAME_FIFO(1),
//    .RX_FIFO_ADDR_WIDTH(12),
//    .RX_FRAME_FIFO(1)
//)
//eth_mac_inst (
//    .gtx_clk(clk),
//    .gtx_clk90(clk90),
//    .gtx_rst(rst),
//    .logic_clk(clk),
//    .logic_rst(rst),

//    .tx_axis_tdata(tx_axis_tdata),
//    .tx_axis_tvalid(tx_axis_tvalid),
//    .tx_axis_tready(tx_axis_tready),
//    .tx_axis_tlast(tx_axis_tlast),
//    .tx_axis_tuser(tx_axis_tuser),

//    .rx_axis_tdata(rx_axis_tdata),
//    .rx_axis_tvalid(rx_axis_tvalid),
//    .rx_axis_tready(rx_axis_tready),
//    .rx_axis_tlast(rx_axis_tlast),
//    .rx_axis_tuser(rx_axis_tuser),

//    .rgmii_rx_clk(phy_rx_clk),
//    .rgmii_rxd(phy_rxd),
//    .rgmii_rx_ctl(phy_rx_ctl),
//    .rgmii_tx_clk(phy_tx_clk),
//    .rgmii_txd(phy_txd),
//    .rgmii_tx_ctl(phy_tx_ctl),

//    .tx_fifo_overflow(udp_status_overflow),
//    .tx_fifo_bad_frame(udp_status_bad_frame),
//    .tx_fifo_good_frame(udp_status_good_frame),
//    .rx_error_bad_frame(),
//    .rx_error_bad_fcs(),
//    .rx_fifo_overflow(),
//    .rx_fifo_bad_frame(),
//    .rx_fifo_good_frame(),
//    .speed(speed),

//    .ifg_delay(12)
//);

eth_axis_rx
eth_axis_rx_inst (
    .clk(clk),
    .rst(rst),
    // AXI input
    .s_axis_tdata(from_sw_rx_axis_tdata),
    .s_axis_tvalid(from_sw_rx_axis_tvalid),
    .s_axis_tready(from_sw_rx_axis_tready),
    .s_axis_tlast(from_sw_rx_axis_tlast),
    .s_axis_tuser(from_sw_rx_axis_tuser),
    // Ethernet frame output
    .m_eth_hdr_valid(rx_eth_hdr_valid),
    .m_eth_hdr_ready(rx_eth_hdr_ready),
    .m_eth_dest_mac(rx_eth_dest_mac),
    .m_eth_src_mac(rx_eth_src_mac),
    .m_eth_type(rx_eth_type),
    .m_eth_payload_axis_tdata(rx_eth_payload_axis_tdata),
    .m_eth_payload_axis_tvalid(rx_eth_payload_axis_tvalid),
    .m_eth_payload_axis_tready(rx_eth_payload_axis_tready),
    .m_eth_payload_axis_tlast(rx_eth_payload_axis_tlast),
    .m_eth_payload_axis_tuser(rx_eth_payload_axis_tuser),
    // Status signals
    .busy(),
    .error_header_early_termination()
);

eth_axis_tx
eth_axis_tx_inst (
    .clk(clk),
    .rst(rst),
    // Ethernet frame input
    .s_eth_hdr_valid(tx_eth_hdr_valid),
    .s_eth_hdr_ready(tx_eth_hdr_ready),
    .s_eth_dest_mac(tx_eth_dest_mac),
    .s_eth_src_mac(tx_eth_src_mac),
    .s_eth_type(tx_eth_type),
    .s_eth_payload_axis_tdata(tx_eth_payload_axis_tdata),
    .s_eth_payload_axis_tvalid(tx_eth_payload_axis_tvalid),
    .s_eth_payload_axis_tready(tx_eth_payload_axis_tready),
    .s_eth_payload_axis_tlast(tx_eth_payload_axis_tlast),
    .s_eth_payload_axis_tuser(tx_eth_payload_axis_tuser),
    // AXI output
    .m_axis_tdata(to_sw_tx_axis_tdata),
    .m_axis_tvalid(to_sw_tx_axis_tvalid),
    .m_axis_tready(to_sw_tx_axis_tready),
    .m_axis_tlast(to_sw_tx_axis_tlast),
    .m_axis_tuser(to_sw_tx_axis_tuser),
    // Status signals
    .busy()
);

udp_complete
udp_complete_inst (
    .clk(clk),
    .rst(rst),
    // Ethernet frame input
    .s_eth_hdr_valid(rx_eth_hdr_valid),
    .s_eth_hdr_ready(rx_eth_hdr_ready),
    .s_eth_dest_mac(rx_eth_dest_mac),
    .s_eth_src_mac(rx_eth_src_mac),
    .s_eth_type(rx_eth_type),
    .s_eth_payload_axis_tdata(rx_eth_payload_axis_tdata),
    .s_eth_payload_axis_tvalid(rx_eth_payload_axis_tvalid),
    .s_eth_payload_axis_tready(rx_eth_payload_axis_tready),
    .s_eth_payload_axis_tlast(rx_eth_payload_axis_tlast),
    .s_eth_payload_axis_tuser(rx_eth_payload_axis_tuser),
    // Ethernet frame output
    .m_eth_hdr_valid(tx_eth_hdr_valid),
    .m_eth_hdr_ready(tx_eth_hdr_ready),
    .m_eth_dest_mac(tx_eth_dest_mac),
    .m_eth_src_mac(tx_eth_src_mac),
    .m_eth_type(tx_eth_type),
    .m_eth_payload_axis_tdata(tx_eth_payload_axis_tdata),
    .m_eth_payload_axis_tvalid(tx_eth_payload_axis_tvalid),
    .m_eth_payload_axis_tready(tx_eth_payload_axis_tready),
    .m_eth_payload_axis_tlast(tx_eth_payload_axis_tlast),
    .m_eth_payload_axis_tuser(tx_eth_payload_axis_tuser),
    // IP frame input
    .s_ip_hdr_valid(tx_ip_hdr_valid),
    .s_ip_hdr_ready(tx_ip_hdr_ready),
    .s_ip_dscp(tx_ip_dscp),
    .s_ip_ecn(tx_ip_ecn),
    .s_ip_length(tx_ip_length),
    .s_ip_ttl(tx_ip_ttl),
    .s_ip_protocol(tx_ip_protocol),
    .s_ip_source_ip(tx_ip_source_ip),
    .s_ip_dest_ip(tx_ip_dest_ip),
    .s_ip_payload_axis_tdata(tx_ip_payload_axis_tdata),
    .s_ip_payload_axis_tvalid(tx_ip_payload_axis_tvalid),
    .s_ip_payload_axis_tready(tx_ip_payload_axis_tready),
    .s_ip_payload_axis_tlast(tx_ip_payload_axis_tlast),
    .s_ip_payload_axis_tuser(tx_ip_payload_axis_tuser),
    // IP frame output
    .m_ip_hdr_valid(rx_ip_hdr_valid),
    .m_ip_hdr_ready(rx_ip_hdr_ready),
    .m_ip_eth_dest_mac(rx_ip_eth_dest_mac),
    .m_ip_eth_src_mac(rx_ip_eth_src_mac),
    .m_ip_eth_type(rx_ip_eth_type),
    .m_ip_version(rx_ip_version),
    .m_ip_ihl(rx_ip_ihl),
    .m_ip_dscp(rx_ip_dscp),
    .m_ip_ecn(rx_ip_ecn),
    .m_ip_length(rx_ip_length),
    .m_ip_identification(rx_ip_identification),
    .m_ip_flags(rx_ip_flags),
    .m_ip_fragment_offset(rx_ip_fragment_offset),
    .m_ip_ttl(rx_ip_ttl),
    .m_ip_protocol(rx_ip_protocol),
    .m_ip_header_checksum(rx_ip_header_checksum),
    .m_ip_source_ip(rx_ip_source_ip),
    .m_ip_dest_ip(rx_ip_dest_ip),
    .m_ip_payload_axis_tdata(rx_ip_payload_axis_tdata),
    .m_ip_payload_axis_tvalid(rx_ip_payload_axis_tvalid),
    .m_ip_payload_axis_tready(rx_ip_payload_axis_tready),
    .m_ip_payload_axis_tlast(rx_ip_payload_axis_tlast),
    .m_ip_payload_axis_tuser(rx_ip_payload_axis_tuser),
    // UDP frame input
    .s_udp_hdr_valid(tx_udp_hdr_valid),
    .s_udp_hdr_ready(tx_udp_hdr_ready),
    .s_udp_ip_dscp(tx_udp_ip_dscp),
    .s_udp_ip_ecn(tx_udp_ip_ecn),
    .s_udp_ip_ttl(tx_udp_ip_ttl),
    .s_udp_ip_source_ip(tx_udp_ip_source_ip),
    .s_udp_ip_dest_ip(tx_udp_ip_dest_ip),
    .s_udp_source_port(tx_udp_source_port),
    .s_udp_dest_port(tx_udp_dest_port),
    .s_udp_length(tx_udp_length),
    .s_udp_checksum(tx_udp_checksum),
    .s_udp_payload_axis_tdata(tx_udp_payload_axis_tdata),
    .s_udp_payload_axis_tvalid(tx_udp_payload_axis_tvalid),
    .s_udp_payload_axis_tready(tx_udp_payload_axis_tready),
    .s_udp_payload_axis_tlast(tx_udp_payload_axis_tlast),
    .s_udp_payload_axis_tuser(tx_udp_payload_axis_tuser),
    // UDP frame output
    .m_udp_hdr_valid(rx_udp_hdr_valid),
    .m_udp_hdr_ready(rx_udp_hdr_ready),
    .m_udp_eth_dest_mac(rx_udp_eth_dest_mac),
    .m_udp_eth_src_mac(rx_udp_eth_src_mac),
    .m_udp_eth_type(rx_udp_eth_type),
    .m_udp_ip_version(rx_udp_ip_version),
    .m_udp_ip_ihl(rx_udp_ip_ihl),
    .m_udp_ip_dscp(rx_udp_ip_dscp),
    .m_udp_ip_ecn(rx_udp_ip_ecn),
    .m_udp_ip_length(rx_udp_ip_length),
    .m_udp_ip_identification(rx_udp_ip_identification),
    .m_udp_ip_flags(rx_udp_ip_flags),
    .m_udp_ip_fragment_offset(rx_udp_ip_fragment_offset),
    .m_udp_ip_ttl(rx_udp_ip_ttl),
    .m_udp_ip_protocol(rx_udp_ip_protocol),
    .m_udp_ip_header_checksum(rx_udp_ip_header_checksum),
    .m_udp_ip_source_ip(rx_udp_ip_source_ip),
    .m_udp_ip_dest_ip(rx_udp_ip_dest_ip),
    .m_udp_source_port(rx_udp_source_port),
    .m_udp_dest_port(rx_udp_dest_port),
    .m_udp_length(rx_udp_length),
    .m_udp_checksum(rx_udp_checksum),
    .m_udp_payload_axis_tdata(rx_udp_payload_axis_tdata),
    .m_udp_payload_axis_tvalid(rx_udp_payload_axis_tvalid),
    .m_udp_payload_axis_tready(rx_udp_payload_axis_tready),
    .m_udp_payload_axis_tlast(rx_udp_payload_axis_tlast),
    .m_udp_payload_axis_tuser(rx_udp_payload_axis_tuser),
    
    // ARP requests
    .arp_request_valid(arp_request_valid),
    .arp_request_ready(arp_request_ready),
    .arp_request_ip(arp_request_ip),
    .arp_response_valid(arp_response_valid),
    .arp_response_ready(arp_response_ready),
    .arp_response_error(arp_response_error),
    .arp_response_mac(arp_response_mac),
    
    // Status signals
    .ip_rx_busy(),
    .ip_tx_busy(),
    .udp_rx_busy(),
    .udp_tx_busy(),
    .ip_rx_error_header_early_termination(),
    .ip_rx_error_payload_early_termination(),
    .ip_rx_error_invalid_header(),
    .ip_rx_error_invalid_checksum(),
    .ip_tx_error_payload_early_termination(),
    .ip_tx_error_arp_failed(),
    .udp_rx_error_header_early_termination(),
    .udp_rx_error_payload_early_termination(),
    .udp_tx_error_payload_early_termination(udp_tx_error_payload_early_termination_w),
    // Configuration
    .local_mac(local_mac),
    .local_ip(local_ip),
    .gateway_ip(gateway_ip),
    .subnet_mask(subnet_mask),
    .clear_arp_cache(0)
);









endmodule
