/*

Copyright (c) 2014-2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * AXI4-Stream ethernet frame receiver (AXI in, Ethernet frame out)
 * This is below the eth_axis_rx layer, all bytes flow through (to PS or to CS via AXIS) no header stripping
 */
module pre_mac_switch#
(
parameter integer C_S00_AXI_DATA_WIDTH	= 32,
parameter integer C_S00_AXI_ADDR_WIDTH	= 8,
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
input  wire       clk_90_in,
input  wire       clk_125_in,
input  wire       clk_200_in,
output  wire       clk_125_out,
//    output  wire       clk_100_out,
//    input  wire       clk90_int,
//    input  wire       clk_200_int,
input  wire       reset_n,
output wire rst_out,
//    input wire        mmcm_locked,

/*
 * Ethernet: 1000BASE-T RGMII
 */
input  wire       phy_rx_clk,
input  wire [3:0] phy_rxd,
input  wire       phy_rx_ctl,
output wire       phy_tx_clk,
output wire [3:0] phy_txd,
output wire       phy_tx_ctl,
output wire       phy_reset_n,
input  wire       phy_int_n,
input  wire       phy_pme_n,


    //--------------------------------From Phy-----------------------------------------------
    /*
     * GMII input
     */
    input  wire [7:0]  gmii_rxd,
    input  wire        gmii_rx_dv,
    input  wire        gmii_rx_er,
    
    
    //--------------------------------From PS-----------------------------------------------
    /*
     * GMII input
     */
    input  wire [7:0]  ps_gmii_rxd,
    input  wire        ps_gmii_rx_dv,
    input  wire        ps_gmii_rx_er,
    
    
    /*
     * Ethernet frame output
     */
//    output wire        m_eth_hdr_valid,
//    input  wire        m_eth_hdr_ready,
//    output wire [47:0] m_eth_dest_mac,
//    output wire [47:0] m_eth_src_mac,
//    output wire [15:0] m_eth_type,
    
//    output wire [7:0]  m_to_ps_axis_tdata,
//    output wire        m_to_ps_axis_tvalid,
//    input  wire        m_to_ps_axis_tready,
//    output wire        m_to_ps_axis_tlast,
//    output wire        m_to_ps_axis_tuser,
    
    //-------------------------------------- To cs eth_axis_rx connected externally-------------------------
    
    output wire [7:0]  m_to_cs_axis_tdata,
    output wire        m_to_cs_axis_tvalid,
    input  wire        m_to_cs_axis_tready,
    output wire        m_to_cs_axis_tlast,
    output wire        m_to_cs_axis_tuser,
    
    
    //-------------------------------------- From cs eth_axis_tx -------------------------
    
    input wire [7:0]  s_from_cs_axis_tdata,
    input wire        s_from_cs_axis_tvalid,
    output  wire      s_from_cs_axis_tready,
    input wire        s_from_cs_axis_tlast,
    input wire        s_from_cs_axis_tuser,

    //-------------------------------------To Phy----------------------------
    
    /*
     * GMII output
     */
    output wire [7:0]  gmii_txd,
    output wire        gmii_tx_en,
    output wire        gmii_tx_er,
    
    //-------------------------------------To PS----------------------------
    
    /*
     * GMII output
     */
    output wire [7:0]  ps_gmii_txd,
    output wire        ps_gmii_tx_en,
    output wire        ps_gmii_tx_er,

    
    
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
    input wire  s00_axi_rready,
    
    /*
     * Control from MAC layer
     */
    input  wire        clk_enable,
    input  wire        mii_select,

    /*
     * Configuration
     */
    input  wire [7:0]  ifg_delay,
    
    //---------------------------------------------------------
    
    /*
     * Status signals
     */
    output wire        busy,
    output wire        error_header_early_termination
);

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
parameter ARB_TYPE = "PRIORITY";
parameter LSB_PRIORITY = "HIGH";


wire [7:0] from_arb_axis_tdata;
wire from_arb_axis_tvalid;
wire from_arb_axis_tlast;
wire from_arb_axis_tready;
wire from_arb_axis_tuser;


wire [7:0] from_ps_axis_tdata;
wire from_ps_axis_tvalid;
wire from_ps_axis_tlast;
wire from_ps_axis_tready;
wire from_ps_axis_tuser;

wire [7:0] from_phy_axis_tdata;
wire from_phy_axis_tvalid;
wire from_phy_axis_tlast;
wire from_phy_axis_tready;
wire from_phy_axis_tuser;


wire        from_phy_error_bad_frame;
wire        from_phy_error_bad_fcs;

wire [15:0] udp_port_1;
wire [15:0] udp_port_2;
wire [15:0] udp_port_3;
wire [15:0] udp_port_4;
wire [15:0] udp_port_5;
wire [15:0] udp_port_6;
wire [15:0] udp_port_7;
wire [15:0] udp_port_8;


wire [7:0] from_phy_to_ps_axis_tdata;
wire        from_phy_to_ps_axis_tvalid;
wire        from_phy_to_ps_axis_tready;
wire        from_phy_to_ps_axis_tlast;
wire        from_phy_to_ps_axis_tuser;


wire [7:0] from_phy_to_cs_axis_tdata;
wire        from_phy_to_cs_axis_tvalid;
wire        from_phy_to_cs_axis_tready;
wire        from_phy_to_cs_axis_tlast;
wire        from_phy_to_cs_axis_tuser;


assign  m_to_cs_axis_tdata = from_phy_to_cs_axis_tdata;
assign  m_to_cs_axis_tvalid = from_phy_to_cs_axis_tvalid;
assign  from_phy_to_cs_axis_tready = m_to_cs_axis_tready;
assign   m_to_cs_axis_tlast = from_phy_to_cs_axis_tlast;
assign   m_to_cs_axis_tuser = from_phy_to_cs_axis_tuser;


wire        sw_busy;
wire        sw_error_header_early_termination;

//-------------------------------------------RX Switch Path From Phy-------------------------------------------
axis_gmii_rx
	from_phy_axis_gmii_rx_inst (
		.clk(clk),
		.rst(rst),
		.gmii_rxd(gmii_rxd),
		.gmii_rx_dv(gmii_rx_dv),
		.gmii_rx_er(gmii_rx_er),
		
		.m_axis_tdata(from_phy_axis_tdata),
		.m_axis_tvalid(from_phy_axis_tvalid),
		.m_axis_tready(from_phy_axis_tready),
		.m_axis_tlast(from_phy_axis_tlast),
		.m_axis_tuser(from_phy_axis_tuser),
		
		.clk_enable(clk_enable),//generated locally
		.mii_select(mii_select),//generated locally this is speed
		.error_bad_frame(from_phy_error_bad_frame),
		.error_bad_fcs(from_phy_error_bad_fcs)
	);

	
	axis_gmii_tx #(
			.ENABLE_PADDING(ENABLE_PADDING),
			.MIN_FRAME_LENGTH(MIN_FRAME_LENGTH)
		)
		to_ps_axis_gmii_tx_inst (
			.clk(clk),
			.rst(rst),
			.s_axis_tdata(from_phy_to_ps_axis_tdata),
			.s_axis_tvalid(from_phy_to_ps_axis_tvalid),
			.s_axis_tready(from_phy_to_ps_axis_tready),
			.s_axis_tlast(from_phy_to_ps_axis_tlast),
			.s_axis_tuser(from_phy_to_ps_axis_tuser),
			
			.gmii_txd(ps_gmii_txd),
			.gmii_tx_en(ps_gmii_tx_en),
			.gmii_tx_er(ps_gmii_tx_er),
			.clk_enable(clk_enable),//generated locally
			.mii_select(mii_select),//generated locally
			.ifg_delay(ifg_delay)
		);

eth_axis_rx_switch
	eth_axis_rx_switch_inst
		(
		.clk(clk),
		.rst(rst),

		/*
		 * AXI input from Phy axis_gmii_rx
		 */
		.s_axis_tdata(from_phy_axis_tdata),
		.s_axis_tvalid(from_phy_axis_tvalid),
		.s_axis_tready(from_phy_axis_tready),
		.s_axis_tlast(from_phy_axis_tlast),
		.s_axis_tuser(from_phy_axis_tuser),

		/*
		 * UDP ports for filtering from AXI block
		 */
    
		.udp_port_1(udp_port_1),
		.udp_port_2(udp_port_2),
		.udp_port_3(udp_port_3),
		.udp_port_4(udp_port_4),
		.udp_port_5(udp_port_5),
		.udp_port_6(udp_port_6),
		.udp_port_7(udp_port_7),
		.udp_port_8(udp_port_8),
    
    
		.m_to_ps_axis_tdata(from_phy_to_ps_axis_tdata),
		.m_to_ps_axis_tvalid(from_phy_to_ps_axis_tvalid),
		.m_to_ps_axis_tready(from_phy_to_ps_axis_tready),
		.m_to_ps_axis_tlast(from_phy_to_ps_axis_tlast),
		.m_to_ps_axis_tuser(from_phy_to_ps_axis_tuser),
    
    
    
		.m_to_cs_axis_tdata(from_phy_to_cs_axis_tdata),
		.m_to_cs_axis_tvalid(from_phy_to_cs_axis_tvalid),
		.m_to_cs_axis_tready(from_phy_to_cs_axis_tready),
		.m_to_cs_axis_tlast(from_phy_to_cs_axis_tlast),
		.m_to_cs_axis_tuser(from_phy_to_cs_axis_tuser),

		/*
		 * Status signals
		 */
		.busy(sw_busy),
		.error_header_early_termination(sw_error_header_early_termination)
		);

//------------------------------------------ TX ARB to PHY path --------------------------------------

axis_gmii_rx
	from_ps_axis_gmii_rx_inst (
		.clk(clk),
		.rst(rst),
		.gmii_rxd(ps_gmii_rxd),
		.gmii_rx_dv(ps_gmii_rx_dv),
		.gmii_rx_er(ps_gmii_rx_er),
		.m_axis_tdata(from_ps_axis_tdata),
		.m_axis_tvalid(from_ps_axis_tvalid),
		.m_axis_tready(from_ps_axis_tready),
		.m_axis_tlast(from_ps_axis_tlast),
		.m_axis_tuser(from_ps_axis_tuser),
		.clk_enable(clk_enable),//generated locally
		.mii_select(mii_select),//generated locally this is speed
		.error_bad_frame(error_bad_frame),
		.error_bad_fcs(error_bad_fcs)
	);

axis_arb_mux #(
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
	axis_arb_mux_inst (
		.clk(clk),
		.rst(rst),
		// AXI inputs
		.s_axis_tdata({s_from_cs_axis_tdata, from_ps_axis_tdata}),
//		.s_axis_tkeep(s_axis_tkeep, from_ps_axis_tkeep),
		.s_axis_tvalid({s_from_cs_axis_tvalid, from_ps_axis_tvalid}),
		.s_axis_tready({s_from_cs_axis_tready, from_ps_axis_tready}),
		.s_axis_tlast({s_from_cs_axis_tlast, from_ps_axis_tlast}),
//		.s_axis_tid({s_from_cs_axis_tid, 0}),
//		.s_axis_tdest({s_from_cs_axis_tdest, 0}),
		.s_axis_tuser({s_from_cs_axis_tuser, from_ps_axis_tuser}),
		// AXI output
		.m_axis_tdata(from_arb_axis_tdata),
		.m_axis_tkeep(from_arb_axis_tkeep),
		.m_axis_tvalid(from_arb_axis_tvalid),
		.m_axis_tready(from_arb_axis_tready),
		.m_axis_tlast(from_arb_axis_tlast),
//		.m_axis_tid(s_axis_tid),
//		.m_axis_tdest(s_axis_tdest),
		.m_axis_tuser(from_arb_axis_tuser)
	);

axis_gmii_tx #(
		.ENABLE_PADDING(ENABLE_PADDING),
		.MIN_FRAME_LENGTH(MIN_FRAME_LENGTH)
	)
	to_phy_axis_gmii_tx_inst (
		.clk(clk),
		.rst(rst),
		.s_axis_tdata(from_arb_axis_tdata),
		.s_axis_tvalid(from_arb_axis_tvalid),
		.s_axis_tready(from_arb_axis_tready),
		.s_axis_tlast(from_arb_axis_tlast),
		.s_axis_tuser(from_arb_axis_tuser),
		.gmii_txd(gmii_txd),
		.gmii_tx_en(gmii_tx_en),
		.gmii_tx_er(gmii_tx_er),
		.clk_enable(clk_enable),
		.mii_select(mii_select),
		.ifg_delay(ifg_delay)
	);
//-----------------------------------------------AXI Bridge-----------------------------------------------
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
        
		/*
		 * UDP ports for filtering 
		 */
		
		.udp_port_1(udp_port_1),
		.udp_port_2(udp_port_2),
		.udp_port_3(udp_port_3),
		.udp_port_4(udp_port_4),
		.udp_port_5(udp_port_5),
		.udp_port_6(udp_port_6),
		.udp_port_7(udp_port_7),
		.udp_port_8(udp_port_8),
        

        
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
