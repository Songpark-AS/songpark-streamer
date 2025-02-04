/*

ARP or IP SELECT is done in the IP layer

udp_complete is the entry point of udp packets from lower layers

UDP select is in udp_complete

We hd added UDP select in the UDP rx to block non UDP packets fron interferring with our UDP streams ...

NON UDP packets should be routed as IP packets to the software, the software will then handle all NON UDP IP packets

This happens in udp_complete 

If m_ip_hdr_valid && !m_udp_hdr_valid ===> then we know that the packet is not a UDP packet to it should go to the CPU packet FIFO as an IP packet

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * FPGA top-level module
 */
module user_eth_udp_stack_v1_0#(// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 8,
        parameter UDP_DATA_WIDTH = 8,
        parameter UDP_IP_WIDTH = 32,
        parameter UDP_MAC_WIDTH = 48,
        parameter UDP_LENGTH_WIDTH = 16,
        parameter UDP_PORT_WIDTH = 16,
        parameter SESSION_USERS_COUNT = 2,
        parameter SYNC_FIFO_ADDR_WIDTH = 6,
        parameter AUDIO_FIFO_ADDR_WIDTH = 12
		)
 (
    /*
     * Clock: 100MHz
     * Reset: Push button, active low
     */
    input  wire       clk_100_in,
//    input  wire       clk_90_in,
    input  wire       clk_125_in,
//    input  wire       clk_200_in,
//    output  wire       clk_125_out,
//    output  wire       clk_100_out,
//    input  wire       clk90_int,
//    input  wire       clk_200_int,
    input  wire       reset_n,
    input  wire       rst_in,
//    output wire rst_out,
//    input wire        mmcm_locked,

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
    * Time sync packets
    *
    */
    output wire [7:0]  m_time_sync_payload_axis_tdata,
    output wire        m_time_sync_payload_axis_tvalid,
    input  wire        m_time_sync_payload_axis_tready,
    output wire        m_time_sync_payload_axis_tlast,
    output wire        m_time_sync_payload_axis_tuser,
    output  wire        m_time_sync_payload_hdr_valid,
    input wire        m_time_sync_payload_hdr_ready,
    
    
    input  wire [7:0]  s_time_sync_payload_axis_tdata,
    input  wire        s_time_sync_payload_axis_tvalid,
    output wire        s_time_sync_payload_axis_tready,
    input  wire        s_time_sync_payload_axis_tlast,
    input  wire        s_time_sync_payload_axis_tuser,
    input  wire        s_time_sync_payload_hdr_valid,
    output wire        s_time_sync_payload_hdr_ready,
    input wire [UDP_LENGTH_WIDTH-1:0]  s_time_sync_payload_length,
    
    input wire initiate_sync_request_in,
    input wire sync_done_in,
    /*
    * AXIS AUDIO Stream Master (Sending out of the core)
    */
    
    output wire [7:0]  m_ch1_audio_payload_axis_tdata,
    output wire        m_ch1_audio_payload_axis_tvalid,
    input  wire        m_ch1_audio_payload_axis_tready,
    output wire        m_ch1_audio_payload_axis_tlast,
    output wire        m_ch1_audio_payload_axis_tuser,
    output wire        m_ch1_audio_payload_hdr_valid,
    input wire         m_ch1_audio_payload_hdr_ready,
    
//    output wire [7:0]  m_ch2_audio_payload_axis_tdata,
//    output wire        m_ch2_audio_payload_axis_tvalid,
//    input  wire        m_ch2_audio_payload_axis_tready,
//    output wire        m_ch2_audio_payload_axis_tlast,
//    output wire        m_ch2_audio_payload_axis_tuser,
//output wire        m_ch1_audio_payload_hdr_valid,
//input wire         m_ch1_audio_payload_hdr_ready,
    
//    output wire [7:0]  m_ch3_audio_payload_axis_tdata,
//    output wire        m_ch3_audio_payload_axis_tvalid,
//    input  wire        m_ch3_audio_payload_axis_tready,
//    output wire        m_ch3_audio_payload_axis_tlast,
//    output wire        m_ch3_audio_payload_axis_tuser,
//output wire        m_ch1_audio_payload_hdr_valid,
//input wire         m_ch1_audio_payload_hdr_ready,
    
//    output wire [7:0]  m_ch4_audio_payload_axis_tdata,
//    output wire        m_ch4_audio_payload_axis_tvalid,
//    input  wire        m_ch4_audio_payload_axis_tready,
//    output wire        m_ch4_audio_payload_axis_tlast,
//    output wire        m_ch4_audio_payload_axis_tuser,
//output wire        m_ch1_audio_payload_hdr_valid,
//input wire         m_ch1_audio_payload_hdr_ready,
    
//    output wire [7:0]  m_ch5_audio_payload_axis_tdata,
//    output wire        m_ch5_audio_payload_axis_tvalid,
//    input  wire        m_ch5_audio_payload_axis_tready,
//    output wire        m_ch5_audio_payload_axis_tlast,
//    output wire        m_ch5_audio_payload_axis_tuser,
//output wire        m_ch1_audio_payload_hdr_valid,
//input wire         m_ch1_audio_payload_hdr_ready,
    
    
//    output wire [7:0]  m_ch6_audio_payload_axis_tdata,
//    output wire        m_ch6_audio_payload_axis_tvalid,
//    input  wire        m_ch6_audio_payload_axis_tready,
//    output wire        m_ch6_audio_payload_axis_tlast,
//    output wire        m_ch6_audio_payload_axis_tuser,
//output wire        m_ch1_audio_payload_hdr_valid,
//input wire         m_ch1_audio_payload_hdr_ready,
    
    
    /*
    * AXIS AUDIO Stream Slave (Receiving into the core)
    */
    input  wire [7:0]  s_audio_payload_axis_tdata,
    input  wire        s_audio_payload_axis_tvalid,
    output wire        s_audio_payload_axis_tready,
    input  wire        s_audio_payload_axis_tlast,
    input  wire        s_audio_payload_axis_tuser,
    input  wire        s_audio_payload_hdr_valid,
    output wire        s_audio_payload_hdr_ready,
    
    input wire [UDP_LENGTH_WIDTH-1:0]   udp_payload_length,
    
    input  wire       fifo_full_in,
    input  wire       fifo_empty_in,
    
    input  wire       sync_request_rx_in,
    input wire          initiate_sync_response_in,

    input  wire       seq_status1_in,
    input  wire       seq_status2_in,
    
    input  wire       tsync_status1_in,
    input  wire       tsync_status2_in,
    
    output wire        stream_resetn_out,
    
    
    /*
     * UART: 500000 bps, 8N1
     */
    input  wire       uart_rxd,
    output wire       uart_txd,
    
    /*
    * AXI Slave port for control
    *    
    */
    

		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
    
);

// Clock and reset

//wire clk_ibufg;
//wire clk_bufg;
//wire clk_mmcm_out;
wire uart_rxd_int;


wire [47:0] local_mac;
wire [31:0] local_ip ;
wire [31:0] gateway_ip;
wire [31:0] subnet_mask;

wire [31:0] dest_ip;
wire [15:0] dest_port;
wire [15:0] source_port;

wire [15:0] sync_dest_port;
wire [UDP_IP_WIDTH - 1:0] sync_dest_ip;
//wire [15:0] udp_ip_length;


wire udp_stream_tx_enable;
wire time_sync_udp_stream_tx_enable;
wire udp_stream_rx_enable;
wire rx_udp_hdr_valid;
wire tx_udp_hdr_ready;
wire rx_udp_hdr_ready;

wire [15:0] udp_packet_length;


wire [7:0]  tx_ch1_audio_payload_axis_tdata;
wire        tx_ch1_audio_payload_axis_tvalid;
wire        tx_ch1_audio_payload_axis_tready;
wire        tx_ch1_audio_payload_axis_tlast;
wire        tx_ch1_audio_payload_axis_tuser;


wire [7:0]  tx_ch2_audio_payload_axis_tdata;
wire        tx_ch2_audio_payload_axis_tvalid;
wire        tx_ch2_audio_payload_axis_tready;
wire        tx_ch2_audio_payload_axis_tlast;
wire        tx_ch2_audio_payload_axis_tuser;

//Add UDP Header
assign udp_packet_length = udp_payload_length + 16'd8;


assign m_ch1_audio_payload_axis_tdata = tx_ch1_audio_payload_axis_tdata;
assign m_ch1_audio_payload_axis_tvalid = tx_ch1_audio_payload_axis_tvalid;
assign tx_ch1_audio_payload_axis_tready = m_ch1_audio_payload_axis_tready;
assign m_ch1_audio_payload_axis_tlast = tx_ch1_audio_payload_axis_tlast;
assign m_ch1_audio_payload_axis_tuser = tx_ch1_audio_payload_axis_tuser;



wire [7:0]  rx_audio_payload_axis_tdata;
wire        rx_audio_payload_axis_tvalid;
wire        rx_audio_payload_axis_tready;
wire        rx_audio_payload_axis_tlast;
wire        rx_audio_payload_axis_tuser;



assign rx_audio_payload_axis_tdata = s_audio_payload_axis_tdata;
assign  rx_audio_payload_axis_tvalid = s_audio_payload_axis_tvalid;
assign s_audio_payload_axis_tready = rx_audio_payload_axis_tready;
assign rx_audio_payload_axis_tlast = s_audio_payload_axis_tlast;
assign rx_audio_payload_axis_tuser = s_audio_payload_axis_tuser;


wire loop_timer;
wire latency_timer;
wire sample_fifo_timer;
wire net_errors;
wire lost_packets;
wire tx_packets;
wire rx_packets;
wire misc;
wire ctrl;
wire [1:0]  speed;

// Internal 125 MHz clock
//wire clk_int;
wire rst_int;   

//wire mmcm_rst = ~reset_n;
//wire mmcm_locked;
//wire mmcm_clkfb;

//Control from AXI
wire reset;
    wire start;

//IBUFG
//clk_ibufg_inst(
//    .I(clk_100_in),
//    .O(clk_ibufg)
//);

//wire clk90_mmcm_out;
//wire clk_90_int;

//wire clk_200_mmcm_out;
//wire clk_200_int;

wire  effective_sync_tx_enable;

assign effective_sync_tx_enable = (initiate_sync_response_in|time_sync_udp_stream_tx_enable|initiate_sync_request_in);

assign stream_resetn_out =   ~rst_int;  
//assign rst_out =   ~rst_int;     
//assign clk_100_out =    clk_ibufg;     

// MMCM instance
// 100 MHz in, 125 MHz out
// PFD range: 10 MHz to 550 MHz
// VCO range: 600 MHz to 1200 MHz
// M = 10, D = 1 sets Fvco = 1000 MHz (in range)
// Divide by 8 to get output frequency of 125 MHz
// Need two 125 MHz outputs with 90 degree offset
// Also need 200 MHz out for IODELAY
// 1000 / 5 = 200 MHz
//MMCME2_BASE #(
//    .BANDWIDTH("OPTIMIZED"),
//    .CLKOUT0_DIVIDE_F(8),
//    .CLKOUT0_DUTY_CYCLE(0.5),
//    .CLKOUT0_PHASE(0),
//    .CLKOUT1_DIVIDE(8),
//    .CLKOUT1_DUTY_CYCLE(0.5),
//    .CLKOUT1_PHASE(90),
//    .CLKOUT2_DIVIDE(5),
//    .CLKOUT2_DUTY_CYCLE(0.5),
//    .CLKOUT2_PHASE(0),
//    .CLKOUT3_DIVIDE(1),
//    .CLKOUT3_DUTY_CYCLE(0.5),
//    .CLKOUT3_PHASE(0),
//    .CLKOUT4_DIVIDE(1),
//    .CLKOUT4_DUTY_CYCLE(0.5),
//    .CLKOUT4_PHASE(0),
//    .CLKOUT5_DIVIDE(1),
//    .CLKOUT5_DUTY_CYCLE(0.5),
//    .CLKOUT5_PHASE(0),
//    .CLKOUT6_DIVIDE(1),
//    .CLKOUT6_DUTY_CYCLE(0.5),
//    .CLKOUT6_PHASE(0),
//    .CLKFBOUT_MULT_F(10),
//    .CLKFBOUT_PHASE(0),
//    .DIVCLK_DIVIDE(1),
//    .REF_JITTER1(0.010),
//    .CLKIN1_PERIOD(10.0),
//    .STARTUP_WAIT("FALSE"),
//    .CLKOUT4_CASCADE("FALSE")
//)
//clk_mmcm_inst (
//    .CLKIN1(clk_ibufg),
//    .CLKFBIN(mmcm_clkfb),
//    .RST(mmcm_rst),
//    .PWRDWN(1'b0),
//    .CLKOUT0(clk_mmcm_out),
//    .CLKOUT0B(),
//    .CLKOUT1(clk90_mmcm_out),
//    .CLKOUT1B(),
//    .CLKOUT2(clk_200_mmcm_out),
//    .CLKOUT2B(),
//    .CLKOUT3(),
//    .CLKOUT3B(),
//    .CLKOUT4(),
//    .CLKOUT5(),
//    .CLKOUT6(),
//    .CLKFBOUT(mmcm_clkfb),
//    .CLKFBOUTB(),
//    .LOCKED(mmcm_locked)
//);

//BUFG
//clk_bufg_inst (
//    .I(clk_mmcm_out),
//    .O(clk_int)
//);

//assign clk_125_out = clk_int;

//BUFG
//clk90_bufg_inst (
//    .I(clk90_mmcm_out),
//    .O(clk_90_int)
//);
 
//BUFG
//clk_200_bufg_inst (
//    .I(clk_200_mmcm_out),
//    .O(clk_200_int)
//);

//assign clk_int = clk_125_in;
//assign clk_90_int = clk_90_in;
//assign clk_200_int = clk_200_in;


//sync_reset #(
//    .N(4)
//)
//sync_reset_inst (
//    .clk(clk_int),
//    .rst((~mmcm_locked)|reset),
////    .rst(reset),
////.rst(~reset_n),
//    .sync_reset_out(rst_int)
//);

// GPIO
wire btnu_int;
wire btnl_int;
wire btnd_int;
wire btnr_int;
wire btnc_int;
wire [7:0] sw_int;

debounce_switch #(
    .WIDTH(13),
    .N(4),
    .RATE(125000)
)
debounce_switch_inst (
    .clk(clk_125_in),
    .rst(rst_in),
    .in({btnu,
        btnl,
        btnd,
        btnr,
        btnc,
        sw}),
    .out({btnu_int,
        btnl_int,
        btnd_int,
        btnr_int,
        btnc_int,
        sw_int})
);

sync_signal #(
    .WIDTH(1),
    .N(2)
)
sync_signal_inst (
    .clk(clk_125_in),
    .in({uart_rxd}),
    .out({uart_rxd_int})
);

// IODELAY elements for RGMII interface to PHY
//wire [3:0] phy_rxd_delay;
//wire       phy_rx_ctl_delay;

//IDELAYCTRL
//idelayctrl_inst
//(
//    .REFCLK(clk_200_int),
//    .RST(rst_int),
//    .RDY()
//);

//IDELAYE2 #(
//    .IDELAY_TYPE("FIXED")
//)
//phy_rxd_idelay_0
//(
//    .IDATAIN(phy_rxd[0]),
//    .DATAOUT(phy_rxd_delay[0]),
//    .DATAIN(1'b0),
//    .C(1'b0),
//    .CE(1'b0),
//    .INC(1'b0),
//    .CINVCTRL(1'b0),
//    .CNTVALUEIN(5'd0),
//    .CNTVALUEOUT(),
//    .LD(1'b0),
//    .LDPIPEEN(1'b0),
//    .REGRST(1'b0)
//);

//IDELAYE2 #(
//    .IDELAY_TYPE("FIXED")
//)
//phy_rxd_idelay_1
//(
//    .IDATAIN(phy_rxd[1]),
//    .DATAOUT(phy_rxd_delay[1]),
//    .DATAIN(1'b0),
//    .C(1'b0),
//    .CE(1'b0),
//    .INC(1'b0),
//    .CINVCTRL(1'b0),
//    .CNTVALUEIN(5'd0),
//    .CNTVALUEOUT(),
//    .LD(1'b0),
//    .LDPIPEEN(1'b0),
//    .REGRST(1'b0)
//);

//IDELAYE2 #(
//    .IDELAY_TYPE("FIXED")
//)
//phy_rxd_idelay_2
//(
//    .IDATAIN(phy_rxd[2]),
//    .DATAOUT(phy_rxd_delay[2]),
//    .DATAIN(1'b0),
//    .C(1'b0),
//    .CE(1'b0),
//    .INC(1'b0),
//    .CINVCTRL(1'b0),
//    .CNTVALUEIN(5'd0),
//    .CNTVALUEOUT(),
//    .LD(1'b0),
//    .LDPIPEEN(1'b0),
//    .REGRST(1'b0)
//);

//IDELAYE2 #(
//    .IDELAY_TYPE("FIXED")
//)
//phy_rxd_idelay_3
//(
//    .IDATAIN(phy_rxd[3]),
//    .DATAOUT(phy_rxd_delay[3]),
//    .DATAIN(1'b0),
//    .C(1'b0),
//    .CE(1'b0),
//    .INC(1'b0),
//    .CINVCTRL(1'b0),
//    .CNTVALUEIN(5'd0),
//    .CNTVALUEOUT(),
//    .LD(1'b0),
//    .LDPIPEEN(1'b0),
//    .REGRST(1'b0)
//);

//IDELAYE2 #(
//    .IDELAY_TYPE("FIXED")
//)
//phy_rx_ctl_idelay
//(
//    .IDATAIN(phy_rx_ctl),
//    .DATAOUT(phy_rx_ctl_delay),
//    .DATAIN(1'b0),
//    .C(1'b0),
//    .CE(1'b0),
//    .INC(1'b0),
//    .CINVCTRL(1'b0),
//    .CNTVALUEIN(5'd0),
//    .CNTVALUEOUT(),
//    .LD(1'b0),
//    .LDPIPEEN(1'b0),
//    .REGRST(1'b0)
//);

fpga_core#(
.UDP_DATA_WIDTH(UDP_DATA_WIDTH),
.UDP_IP_WIDTH(UDP_IP_WIDTH),
.UDP_LENGTH_WIDTH(UDP_LENGTH_WIDTH),
.UDP_PORT_WIDTH(UDP_PORT_WIDTH),
.UDP_MAC_WIDTH(UDP_MAC_WIDTH),
.SESSION_USERS_COUNT(SESSION_USERS_COUNT),
//.SYNC_FIFO_ADDR_WIDTH(SYNC_FIFO_ADDR_WIDTH),
.AUDIO_FIFO_ADDR_WIDTH(AUDIO_FIFO_ADDR_WIDTH)
)
core_inst (
    /*
     * Clock: 125MHz
     * Synchronous reset
     */
//    .clk(clk_int),
//    .clk90(clk_90_int),
//    .rst(rst_int),
.clk(clk_125_in),
.rst(rst_in),
    /*
     * GPIO
     */
    .btnu(btnu_int),
    .btnl(btnl_int),
    .btnd(btnd_int),
    .btnr(btnr_int),
    .btnc(btnc_int),
    .sw(sw_int),
    .led(led),
    /*
     * Ethernet: 1000BASE-T RGMII
     */
//    .phy_rx_clk(phy_rx_clk),
//    .phy_rxd(phy_rxd_delay),
//    .phy_rx_ctl(phy_rx_ctl_delay),
//    .phy_tx_clk(phy_tx_clk),
//    .phy_txd(phy_txd),
//    .phy_tx_ctl(phy_tx_ctl),
//    .phy_reset_n(phy_reset_n),
//    .phy_int_n(phy_int_n),
//    .phy_pme_n(phy_pme_n),

// AXI between MAC and Ethernet modules
    .from_sw_rx_axis_tdata(from_sw_rx_axis_tdata),
    .from_sw_rx_axis_tvalid(from_sw_rx_axis_tvalid),
    .from_sw_rx_axis_tready(from_sw_rx_axis_tready),
    .from_sw_rx_axis_tlast(from_sw_rx_axis_tlast),
    .from_sw_rx_axis_tuser(from_sw_rx_axis_tuser),
    
    .to_sw_tx_axis_tdata(to_sw_tx_axis_tdata),
    .to_sw_tx_axis_tvalid(to_sw_tx_axis_tvalid),
    .to_sw_tx_axis_tready(to_sw_tx_axis_tready),
    .to_sw_tx_axis_tlast(to_sw_tx_axis_tlast),
    .to_sw_tx_axis_tuser(to_sw_tx_axis_tuser),
    
    /*
     * MAC Configuration
     */
    .to_sw_ifg_delay(to_sw_ifg_delay),
    
    /*
     * MAC Status
     */
    .from_sw_tx_fifo_overflow(from_sw_tx_fifo_overflow),
    .from_sw_tx_fifo_bad_frame(from_sw_tx_fifo_bad_frame),
    .from_sw_tx_fifo_good_frame(from_sw_tx_fifo_good_frame),
    .from_sw_rx_error_bad_frame(from_sw_rx_error_bad_frame),
    .from_sw_rx_error_bad_fcs(from_sw_rx_error_bad_fcs),
    .from_sw_rx_fifo_overflow(from_sw_rx_fifo_overflow),
    .from_sw_rx_fifo_bad_frame(from_sw_rx_fifo_bad_frame),
    .from_sw_rx_fifo_good_frame(from_sw_rx_fifo_good_frame),
    .from_sw_speed(from_sw_speed),
    
    
     /*
    * AXIS AUDIO Stream Master (Sending out of the udp core)
    */
    
    .m_ch_audio_payload_axis_tdata({tx_ch1_audio_payload_axis_tdata, m_time_sync_payload_axis_tdata}),
    .m_ch_audio_payload_axis_tvalid({tx_ch1_audio_payload_axis_tvalid, m_time_sync_payload_axis_tvalid}),
    .m_ch_audio_payload_axis_tready({tx_ch1_audio_payload_axis_tready, m_time_sync_payload_axis_tready}),
    .m_ch_audio_payload_axis_tlast({tx_ch1_audio_payload_axis_tlast, m_time_sync_payload_axis_tlast}),
    .m_ch_audio_payload_axis_tuser({tx_ch1_audio_payload_axis_tuser, m_time_sync_payload_axis_tuser}),
    
    .m_ch_audio_payload_hdr_ready({m_ch1_audio_payload_hdr_ready, m_time_sync_payload_hdr_ready}),
    .m_ch_audio_payload_hdr_valid({m_ch1_audio_payload_hdr_valid, m_time_sync_payload_hdr_valid}),
    
    
    
     /*
    * AXIS AUDIO Stream Slave (Receiving into the udp core)
    */
    
    .s_audio_payload_axis_tdata({rx_audio_payload_axis_tdata,s_time_sync_payload_axis_tdata}),
    .s_audio_payload_axis_tvalid({rx_audio_payload_axis_tvalid, s_time_sync_payload_axis_tvalid}),
    .s_audio_payload_axis_tready({rx_audio_payload_axis_tready, s_time_sync_payload_axis_tready}),
    .s_audio_payload_axis_tlast({rx_audio_payload_axis_tlast, s_time_sync_payload_axis_tlast}),
    .s_audio_payload_axis_tuser({rx_audio_payload_axis_tuser, s_time_sync_payload_axis_tuser}),
    .s_audio_payload_hdr_ready({s_audio_payload_hdr_ready, s_time_sync_payload_hdr_ready}),
    .s_audio_payload_hdr_valid({s_audio_payload_hdr_valid&udp_stream_tx_enable, s_time_sync_payload_hdr_valid & effective_sync_tx_enable }),
    
    
    /*
    * Time sync packets
    *
    */
//    .m_time_sync_payload_axis_tdata(m_time_sync_payload_axis_tdata),
//    .m_time_sync_payload_axis_tvalid(m_time_sync_payload_axis_tvalid),
//    .m_time_sync_payload_axis_tready(m_time_sync_payload_axis_tready),
//    .m_time_sync_payload_axis_tlast(m_time_sync_payload_axis_tlast),
//    .m_time_sync_payload_axis_tuser(m_time_sync_payload_axis_tuser),
//    .m_time_sync_payload_hdr_valid(m_time_sync_payload_hdr_valid),
//    .m_time_sync_payload_hdr_ready(m_time_sync_payload_hdr_ready),
    
    
//    .s_time_sync_payload_axis_tdata(s_time_sync_payload_axis_tdata),
//    .s_time_sync_payload_axis_tvalid(s_time_sync_payload_axis_tvalid),
//    .s_time_sync_payload_axis_tready(s_time_sync_payload_axis_tready),
//    .s_time_sync_payload_axis_tlast(s_time_sync_payload_axis_tlast),
//    .s_time_sync_payload_axis_tuser(s_time_sync_payload_axis_tuser),
//    .s_time_sync_payload_hdr_valid(s_time_sync_payload_hdr_valid),
//    .s_time_sync_payload_hdr_ready(s_time_sync_payload_hdr_ready),
    
//    .time_sync_udp_stream_tx_enable(time_sync_udp_stream_tx_enable),
    
//    .initiate_sync_request_in(initiate_sync_request_in),
//    .sync_done_in(sync_done_in),
    //Eth config from AXI lite reg
    .cfg_local_mac(local_mac),
        .cfg_local_ip (local_ip),
        .cfg_gateway_ip(gateway_ip),
        .cfg_subnet_mask(subnet_mask),
        .cfg_source_port({source_port, sync_dest_port}),
        
        .cfg_dest_ip({dest_ip, sync_dest_ip}),
        .cfg_dest_port({dest_port, sync_dest_port}),
        
    
    .cfg_udp_ip_length({udp_packet_length, s_time_sync_payload_length}),
    
    .udp_stream_tx_enable({udp_stream_tx_enable, effective_sync_tx_enable}),
//    .cfg_time_sync_dest_ip(sync_dest_ip),

//    .cfg_time_sync_dest_ip(dest_ip),
//    .cfg_time_sync_dest_port(sync_dest_port),
//    .cfg_time_sync_udp_ip_length(s_time_sync_payload_length),
    
    //.cfg_tx_udp_hdr_valid(tx_udp_hdr_valid),
    //.cfg_tx_udp_hdr_valid(s_audio_payload_hdr_valid),
    //.cfg_rx_udp_hdr_valid(rx_udp_hdr_valid),
    //.cfg_tx_udp_hdr_ready(tx_udp_hdr_ready),
    //.cfg_rx_udp_hdr_ready(rx_udp_hdr_ready),
    
    .speed(speed),
    
    .fifo_full_in(fifo_full_in),
    .fifo_empty_in(fifo_empty_in),
    
    .seq_status1_in(seq_status1_in),
    .seq_status2_in(seq_status2_in),
    
    .tsync_status1_in(tsync_status1_in),
    .tsync_status2_in(tsync_status2_in),
    
    .sync_request_rx_in(sync_request_rx_in),
    .initiate_sync_response_in(initiate_sync_response_in),
    
    .sync_done_in(sync_done_in),
    /*
     * UART: 115200 bps, 8N1
     */
    .uart_rxd(uart_rxd_int),
    .uart_txd(uart_txd)
    
    
    
);


/////---------------------------------------------------------------
//    (* mark_debug = "true" *) wire reset;
//    (* mark_debug = "true" *) wire start;
    
    (* mark_debug = "true" *) wire read;
    (* mark_debug = "true" *) wire [15:0] address;
    (* mark_debug = "true" *) wire [2:0] nbytes;
    (* mark_debug = "true" *) wire [63:0] write_data;
    (* mark_debug = "true" *) wire busy;
    (* mark_debug = "true" *) wire [63:0] read_data;
    
// Instantiation of Axi Bus Interface S00_AXI
	eth_controller_v1_0_S00_AXI # (
	   .UDP_DATA_WIDTH(UDP_DATA_WIDTH),
        .UDP_IP_WIDTH(UDP_IP_WIDTH),
        .UDP_LENGTH_WIDTH(UDP_LENGTH_WIDTH),
        .UDP_PORT_WIDTH(UDP_PORT_WIDTH),
        .UDP_MAC_WIDTH(UDP_MAC_WIDTH),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH),
		.SESSION_USERS_COUNT(SESSION_USERS_COUNT)
	) eth_controller_v1_0_S00_AXI_inst (
        .reset(reset),
        .start(start),
        .read(read),
        .nbytes(nbytes),
        .address(address),
        .write_data(write_data),
        .busy(busy),
        .read_data(read_data),
        
        .local_mac(local_mac),
        .local_ip (local_ip),
        .gateway_ip(gateway_ip),
        .subnet_mask(subnet_mask),

        .dest_ip(dest_ip),
        .dest_port(dest_port),
        .source_port(source_port),
        .sync_dest_port(sync_dest_port),
        .sync_dest_ip(sync_dest_ip),
        
//        .loop_timer(loop_timer),
//        .latency_timer(latency_timer),
//        .sample_fifo_timer(sample_fifo_timer),
//        .net_errors(net_errors),
//        .lost_packets(lost_packets),
//        .tx_packets(tx_packets),
//        .rx_packets(rx_packets),
        //.udp_length(udp_ip_length),
        .speed(speed),
        .ctrl(ctrl),
        
        .udp_stream_tx_enable(udp_stream_tx_enable),
        .time_sync_udp_stream_tx_enable(time_sync_udp_stream_tx_enable),
        .udp_stream_rx_enable(udp_stream_rx_enable),
        .tx_udp_hdr_ready(tx_udp_hdr_ready),
        .rx_udp_hdr_ready(rx_udp_hdr_ready),
        
        .S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);



endmodule
