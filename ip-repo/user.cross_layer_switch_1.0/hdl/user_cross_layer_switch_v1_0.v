
`timescale 1 ns / 1 ps

module user_cross_layer_switch_v1_0 #(
parameter TARGET = "XILINX",
    parameter integer C_S00_AXI_DATA_WIDTH	= 32,
    parameter integer C_S00_AXI_ADDR_WIDTH	= 8,
    
    parameter C_S_AXIS_TDATA_WIDTH = 8,
    parameter UDP_DATA_WIDTH = 8,
    parameter UDP_IP_WIDTH = 32,
    parameter UDP_MAC_WIDTH = 48,
    parameter UDP_LENGTH_WIDTH = 16,
    parameter UDP_PORT_WIDTH = 16,
    parameter SYNC_FIFO_ADDR_WIDTH = 6,
//    parameter AUDIO_FIFO_ADDR_WIDTH = 12,
//    parameter RX_HDR_FIFO_ADDR_WIDTH = 6, 
    parameter RX_HDR_FIFO_DEPTH = 128,// this is only to hold up to the UDP HDR
    parameter RX_HDR_FIFO_BANK_COUNT = 2,
    parameter FROM_PS_FIFO_ADDR_WIDTH = 15,
    parameter FROM_CS_FIFO_ADDR_WIDTH = 12,
    parameter MIN_FRAME_LENGTH = 64,
    parameter TX_FIFO_ADDR_WIDTH = 12,
    parameter RX_FIFO_ADDR_WIDTH = 12,
    parameter IFG_DELAY = 12
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


//    //--------------------------------From Phy Now via Mac Fifo----------------------------------------
//    /*
//     * GMII input
//     */
//    input  wire [7:0]  gmii_rxd,
//    input  wire        gmii_rx_dv,
//    input  wire        gmii_rx_er,
    
    
    //--------------------------------From PS-----------------------------------------------
    /*
     * GMII input
     */
    input  wire [7:0]  from_ps_gmii_txd,
    input  wire        from_ps_gmii_tx_en,
    input  wire        from_ps_gmii_tx_er,
    
    
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

//    //-------------------------------------To Phy Now Via Mac Fifo----------------------------
    
//    /*
//     * PHY GMII output
//     */
//    output wire [7:0]  gmii_txd,
//    output wire        gmii_tx_en,
//    output wire        gmii_tx_er,

    
    
//    output wire       phy_reset_n,
//    input  wire       phy_int_n,
    inout  wire       phy_mdio,
    output wire       phy_mdc,
    
    //-------------------------------------To PS----------------------------
    output wire        ps_gmii_tx_clk,
    output wire        ps_gmii_rx_clk,
    
    /*
     * PS GMII output
     */
    output wire [7:0]  to_ps_gmii_rxd,
    output wire        to_ps_gmii_rx_dv,
    output wire        to_ps_gmii_rx_er,
    
    output wire        to_ps_gmii_col,
    output wire        to_ps_gmii_crs,

    /*
    *PS MDIO interface
    */
    input wire        mdc_o,
    output  wire        mdio_i,
    input wire        mdio_o,
    input wire        mdio_t,
    
    output wire inet_ext_int_out,
    
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
//    input  wire        clk_enable,
//    input  wire        mii_select,

    /*
     * Configuration
     */
//    input  wire [7:0]  ifg_delay,
    
    //---------------------------------------------------------
    
    /*
     * Status signals
     */
     output wire sel_status,
    output wire        busy,
    output wire        error_header_early_termination,
    output wire        from_ps_error_bad_frame,
    output wire        from_ps_error_bad_fcs,
    
    output wire mac_status_overflow,
    output wire mac_status_bad_frame,
    output wire mac_status_good_frame,
    
    output wire from_ps_fifo_status_overflow,
    output wire from_ps_fifo_status_bad_frame,
    output wire from_ps_fifo_status_good_frame,
    
    output wire from_cs_fifo_status_overflow,
    output wire from_cs_fifo_status_bad_frame,
    output wire from_cs_fifo_status_good_frame
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
parameter ARB_TYPE = "ROUND_ROBIN"; //"PRIORITY";
parameter LSB_PRIORITY = "HIGH";


// Clock and reset

wire clk_ibufg;
wire clk_bufg;
wire clk_mmcm_out;

wire [7:0] from_arb_axis_tdata;
wire from_arb_axis_tvalid;
wire from_arb_axis_tlast;
wire from_arb_axis_tready;
wire from_arb_axis_tuser;



wire [7:0] from_ps_axis_tdata;
wire from_ps_axis_tvalid;
wire from_ps_axis_tlast;
wire from_ps_axis_tready; //there is no way of telling the ARM that we are ready
wire from_ps_axis_tuser;


wire [7:0] from_ps_fifo_axis_tdata;
wire from_ps_fifo_axis_tvalid;
wire from_ps_fifo_axis_tlast;
wire from_ps_fifo_axis_tready;
wire from_ps_fifo_axis_tuser;


wire [7:0] from_cs_fifo_axis_tdata;
wire from_cs_fifo_axis_tvalid;
wire from_cs_fifo_axis_tlast;
wire from_cs_fifo_axis_tready;
wire from_cs_fifo_axis_tuser;




wire [7:0] from_phy_axis_tdata;
wire from_phy_axis_tvalid;
wire from_phy_axis_tlast;
wire from_phy_axis_tready;
wire from_phy_axis_tuser;


wire        from_phy_error_bad_frame;
wire        from_phy_error_bad_fcs;

//wire [47:0] local_mac;
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

wire [31:0] rx_sw_state;
wire [31:0] bus_status; 


wire sw_reset;

wire        sw_busy;
wire        sw_error_header_early_termination;
//-----------------------------------------------Orig Phy connection via FIFOs---------------------------------
wire misc;
wire ctrl;
wire [1:0]  speed;

// Internal 125 MHz clock
wire clk_int;
wire rst_int;   
wire        mii_select;

assign  m_to_cs_axis_tdata = from_phy_to_cs_axis_tdata;
assign  m_to_cs_axis_tvalid = from_phy_to_cs_axis_tvalid;
assign  from_phy_to_cs_axis_tready = m_to_cs_axis_tready;
assign   m_to_cs_axis_tlast = from_phy_to_cs_axis_tlast;
assign   m_to_cs_axis_tuser = from_phy_to_cs_axis_tuser;


/**
The CRS and COL signals are asynchronous to the receive clock, and are only meaningful in half-duplex mode. 
Carrier sense is high when transmitting, receiving, or the medium is otherwise sensed as being in use. 
If a collision is detected, COL also goes high while the collision persists.

In addition, the MAC may weakly pull-up the COL signal, allowing the combination of COL high with CRS low (which a PHY will never produce) 
to serve as indication of an absent/disconnected PHY.
**/


//assign to_ps_gmii_col = 1'b0;
//assign to_ps_gmii_col = from_ps_fifo_status_overflow||from_ps_fifo_status_bad_frame||from_ps_fifo_status_good_frame;
assign to_ps_gmii_col = from_ps_fifo_status_overflow||from_ps_fifo_status_bad_frame;
//assign to_ps_gmii_crs = from_ps_gmii_tx_en||to_ps_gmii_rx_dv;
assign to_ps_gmii_crs = 1'b0;

assign mii_select = (speed != 2'b10);


assign phy_mdc = mdc_o;
assign mdio_i = phy_mdio;
assign phy_mdio = mdio_t ? 1'bz : mdio_o;

assign inet_ext_int_out = ~phy_int_n;


wire mmcm_rst = ~reset_n;
wire mmcm_locked;
wire mmcm_clkfb;

//Control from AXI
wire reset;
    wire start;

IBUFG
clk_ibufg_inst(
    .I(clk_100_in),
    .O(clk_ibufg)
);

wire clk90_mmcm_out;
wire clk_90_int;

wire clk_200_mmcm_out;
wire clk_200_int;


 wire [15:0]  ps_rx_pkt_count;
 wire [15:0]  cs_rx_pkt_count;
        
        
 wire [15:0]  ps_tx_pkt_count;
 wire [15:0]  cs_tx_pkt_count;

//wire  effective_sync_tx_enable;


assign   ps_gmii_tx_clk = clk_int;
assign   ps_gmii_rx_clk = clk_int;

assign rst_out =   rst_int;     
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
MMCME2_BASE #(
    .BANDWIDTH("OPTIMIZED"),
    .CLKOUT0_DIVIDE_F(8),
    .CLKOUT0_DUTY_CYCLE(0.5),
    .CLKOUT0_PHASE(0),
    .CLKOUT1_DIVIDE(8),
    .CLKOUT1_DUTY_CYCLE(0.5),
    .CLKOUT1_PHASE(90),
    .CLKOUT2_DIVIDE(5),
    .CLKOUT2_DUTY_CYCLE(0.5),
    .CLKOUT2_PHASE(0),
    .CLKOUT3_DIVIDE(1),
    .CLKOUT3_DUTY_CYCLE(0.5),
    .CLKOUT3_PHASE(0),
    .CLKOUT4_DIVIDE(1),
    .CLKOUT4_DUTY_CYCLE(0.5),
    .CLKOUT4_PHASE(0),
    .CLKOUT5_DIVIDE(1),
    .CLKOUT5_DUTY_CYCLE(0.5),
    .CLKOUT5_PHASE(0),
    .CLKOUT6_DIVIDE(1),
    .CLKOUT6_DUTY_CYCLE(0.5),
    .CLKOUT6_PHASE(0),
    .CLKFBOUT_MULT_F(10),
    .CLKFBOUT_PHASE(0),
    .DIVCLK_DIVIDE(1),
    .REF_JITTER1(0.010),
    .CLKIN1_PERIOD(10.0),
    .STARTUP_WAIT("FALSE"),
    .CLKOUT4_CASCADE("FALSE")
)
clk_mmcm_inst (
    .CLKIN1(clk_ibufg),
    .CLKFBIN(mmcm_clkfb),
    .RST(mmcm_rst),
    .PWRDWN(1'b0),
    .CLKOUT0(clk_mmcm_out),
    .CLKOUT0B(),
    .CLKOUT1(clk90_mmcm_out),
    .CLKOUT1B(),
    .CLKOUT2(clk_200_mmcm_out),
    .CLKOUT2B(),
    .CLKOUT3(),
    .CLKOUT3B(),
    .CLKOUT4(),
    .CLKOUT5(),
    .CLKOUT6(),
    .CLKFBOUT(mmcm_clkfb),
    .CLKFBOUTB(),
    .LOCKED(mmcm_locked)
);

BUFG
clk_bufg_inst (
    .I(clk_mmcm_out),
    .O(clk_int)
);

assign clk_125_out = clk_int;

BUFG
clk90_bufg_inst (
    .I(clk90_mmcm_out),
    .O(clk_90_int)
);
 
BUFG
clk_200_bufg_inst (
    .I(clk_200_mmcm_out),
    .O(clk_200_int)
);

//assign clk_int = clk_125_in;
//assign clk_90_int = clk_90_in;
//assign clk_200_int = clk_200_in;


sync_reset #(
    .N(4)
)
sync_reset_inst (
    .clk(clk_int),
    .rst((~mmcm_locked) || sw_reset || (~reset_n)),
//    .rst(reset),
//.rst(~reset_n),
    .sync_reset_out(rst_int)
);






// IODELAY elements for RGMII interface to PHY
wire [3:0] phy_rxd_delay;
wire       phy_rx_ctl_delay;

IDELAYCTRL
idelayctrl_inst
(
    .REFCLK(clk_200_int),
    .RST(rst_int),
    .RDY()
);

IDELAYE2 #(
    .IDELAY_TYPE("FIXED")
)
phy_rxd_idelay_0
(
    .IDATAIN(phy_rxd[0]),
    .DATAOUT(phy_rxd_delay[0]),
    .DATAIN(1'b0),
    .C(1'b0),
    .CE(1'b0),
    .INC(1'b0),
    .CINVCTRL(1'b0),
    .CNTVALUEIN(5'd0),
    .CNTVALUEOUT(),
    .LD(1'b0),
    .LDPIPEEN(1'b0),
    .REGRST(1'b0)
);

IDELAYE2 #(
    .IDELAY_TYPE("FIXED")
)
phy_rxd_idelay_1
(
    .IDATAIN(phy_rxd[1]),
    .DATAOUT(phy_rxd_delay[1]),
    .DATAIN(1'b0),
    .C(1'b0),
    .CE(1'b0),
    .INC(1'b0),
    .CINVCTRL(1'b0),
    .CNTVALUEIN(5'd0),
    .CNTVALUEOUT(),
    .LD(1'b0),
    .LDPIPEEN(1'b0),
    .REGRST(1'b0)
);

IDELAYE2 #(
    .IDELAY_TYPE("FIXED")
)
phy_rxd_idelay_2
(
    .IDATAIN(phy_rxd[2]),
    .DATAOUT(phy_rxd_delay[2]),
    .DATAIN(1'b0),
    .C(1'b0),
    .CE(1'b0),
    .INC(1'b0),
    .CINVCTRL(1'b0),
    .CNTVALUEIN(5'd0),
    .CNTVALUEOUT(),
    .LD(1'b0),
    .LDPIPEEN(1'b0),
    .REGRST(1'b0)
);

IDELAYE2 #(
    .IDELAY_TYPE("FIXED")
)
phy_rxd_idelay_3
(
    .IDATAIN(phy_rxd[3]),
    .DATAOUT(phy_rxd_delay[3]),
    .DATAIN(1'b0),
    .C(1'b0),
    .CE(1'b0),
    .INC(1'b0),
    .CINVCTRL(1'b0),
    .CNTVALUEIN(5'd0),
    .CNTVALUEOUT(),
    .LD(1'b0),
    .LDPIPEEN(1'b0),
    .REGRST(1'b0)
);

IDELAYE2 #(
    .IDELAY_TYPE("FIXED")
)
phy_rx_ctl_idelay
(
    .IDATAIN(phy_rx_ctl),
    .DATAOUT(phy_rx_ctl_delay),
    .DATAIN(1'b0),
    .C(1'b0),
    .CE(1'b0),
    .INC(1'b0),
    .CINVCTRL(1'b0),
    .CNTVALUEIN(5'd0),
    .CNTVALUEOUT(),
    .LD(1'b0),
    .LDPIPEEN(1'b0),
    .REGRST(1'b0)
);

// ONLY this block connects dirrectly to our PHY --- the tuser signal is important for error reporting

eth_mac_1g_rgmii_fifo #(
    .TARGET(TARGET),
    .IODDR_STYLE("IODDR"),
//    .CLOCK_INPUT_STYLE("BUFR"),
    .CLOCK_INPUT_STYLE("BUFG"),
    .USE_CLK90("TRUE"),
    .ENABLE_PADDING(1),
    .MIN_FRAME_LENGTH(64),
    .TX_FIFO_ADDR_WIDTH(TX_FIFO_ADDR_WIDTH),
    .TX_FRAME_FIFO(1),
    .RX_FIFO_ADDR_WIDTH(RX_FIFO_ADDR_WIDTH),
    .RX_FRAME_FIFO(1)
)
eth_mac_inst (
    .gtx_clk(clk_int),
    .gtx_clk90(clk_90_int),
    .gtx_rst(rst_int),
    .logic_clk(clk_int),
    .logic_rst(rst_int),

    .tx_axis_tdata(from_arb_axis_tdata),
    .tx_axis_tvalid(from_arb_axis_tvalid),
    .tx_axis_tready(from_arb_axis_tready),
    .tx_axis_tlast(from_arb_axis_tlast),
    .tx_axis_tuser(from_arb_axis_tuser),

    .rx_axis_tdata(from_phy_axis_tdata),
    .rx_axis_tvalid(from_phy_axis_tvalid),
    .rx_axis_tready(from_phy_axis_tready),
    .rx_axis_tlast(from_phy_axis_tlast),
    .rx_axis_tuser(from_phy_axis_tuser),

    .rgmii_rx_clk(phy_rx_clk),
    .rgmii_rxd(phy_rxd),
    .rgmii_rx_ctl(phy_rx_ctl),
    .rgmii_tx_clk(phy_tx_clk),
    .rgmii_txd(phy_txd),
    .rgmii_tx_ctl(phy_tx_ctl),

    .tx_fifo_overflow(mac_status_overflow),
    .tx_fifo_bad_frame(mac_status_bad_frame),
    .tx_fifo_good_frame(mac_status_good_frame),
    .rx_error_bad_frame(),
    .rx_error_bad_fcs(),
    .rx_fifo_overflow(),
    .rx_fifo_bad_frame(),
    .rx_fifo_good_frame(),
    .speed(speed),

    .ifg_delay(IFG_DELAY)
);
//-------------------------------------------RX Switch Path From Phy-------------------------------------------
//HANDLED BY MAC
//axis_gmii_rx
//	from_phy_axis_gmii_rx_inst (
//		.clk(clk_int),
//		.rst(rst_int),
//		.gmii_rxd(gmii_rxd),
//		.gmii_rx_dv(gmii_rx_dv),
//		.gmii_rx_er(gmii_rx_er),
		
//		.m_axis_tdata(from_phy_axis_tdata),
//		.m_axis_tvalid(from_phy_axis_tvalid),
//		.m_axis_tready(from_phy_axis_tready),
//		.m_axis_tlast(from_phy_axis_tlast),
//		.m_axis_tuser(from_phy_axis_tuser),
		
//		.clk_enable(clk_enable),//generated locally
//		.mii_select(mii_select),//generated locally this is speed
//		.error_bad_frame(from_phy_error_bad_frame),
//		.error_bad_fcs(from_phy_error_bad_fcs)
//	);

	
axis_gmii_tx #(
    .ENABLE_PADDING(1),
    .MIN_FRAME_LENGTH(16)
)
to_ps_axis_gmii_tx_inst (
    .clk(clk_int),
    .rst(rst_int),
    .s_axis_tdata(from_phy_to_ps_axis_tdata),
    .s_axis_tvalid(from_phy_to_ps_axis_tvalid),
    .s_axis_tready(from_phy_to_ps_axis_tready),
    .s_axis_tlast(from_phy_to_ps_axis_tlast),
    .s_axis_tuser(from_phy_to_ps_axis_tuser),
    
    .gmii_txd(to_ps_gmii_rxd),
    .gmii_tx_en(to_ps_gmii_rx_dv),
    .gmii_tx_er(to_ps_gmii_rx_er),
    .clk_enable(1'b1),//generated locally
    .mii_select(mii_select),//generated locally
    .ifg_delay(IFG_DELAY)
);

eth_axis_rx_switch#(
//.FIFO_ADDR_WIDTH(RX_HDR_FIFO_ADDR_WIDTH), // this is only to hold up to the UDP HDR
//.FIFO_BANK_COUNT(RX_HDR_FIFO_BANK_COUNT),
.FIFO_DEPTH(RX_HDR_FIFO_DEPTH)
)
	eth_axis_rx_switch_inst
		(
		.clk(clk_int),
		.rst(rst_int),

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
		 
		 .ps_rx_pkt_count(ps_rx_pkt_count),
        .cs_rx_pkt_count(cs_rx_pkt_count),
        .rx_sw_state(rx_sw_state),
        .bus_status(bus_status),  
        
		 
		 
		.sel_status(sel_status),
		.busy(sw_busy),
		.error_header_early_termination(sw_error_header_early_termination)
		);

//------------------------------------------ TX ARB to PHY path --------------------------------------
reg [15:0]  ps_tx_pkt_count_reg;
reg [15:0]  cs_tx_pkt_count_reg;
        
assign cs_tx_pkt_count = cs_tx_pkt_count_reg;
assign ps_tx_pkt_count = ps_tx_pkt_count_reg;

always @(posedge (from_ps_axis_tlast && from_ps_axis_tvalid) or posedge rst_int)
begin

    if (rst_int) begin
        ps_tx_pkt_count_reg <= 0;
    end else begin
        ps_tx_pkt_count_reg <= ps_tx_pkt_count + 1;
    end

end


always @(posedge (s_from_cs_axis_tlast && s_from_cs_axis_tvalid) or posedge rst_int)
begin
     if (rst_int) begin
        cs_tx_pkt_count_reg <= 0;
     end else begin
        cs_tx_pkt_count_reg <= cs_tx_pkt_count + 1; 
     end

end



axis_gmii_rx
	from_ps_axis_gmii_rx_inst (
		.clk(clk_int),
		.rst(rst_int),
		.gmii_rxd(from_ps_gmii_txd),
		.gmii_rx_dv(from_ps_gmii_tx_en),
		.gmii_rx_er(from_ps_gmii_tx_er),
		
		.m_axis_tdata(from_ps_axis_tdata),
		.m_axis_tvalid(from_ps_axis_tvalid),
        //.m_axis_tready(from_ps_axis_tready), no tready signal here
		.m_axis_tlast(from_ps_axis_tlast),
		.m_axis_tuser(from_ps_axis_tuser),
		.clk_enable(1'b1),//generated locally
		.mii_select(mii_select),//generated locally depends on selected speed
		.error_bad_frame(from_ps_error_bad_frame),
		.error_bad_fcs(from_ps_error_bad_fcs)
	);


axis_async_fifo #(
    .ADDR_WIDTH(FROM_CS_FIFO_ADDR_WIDTH),
    .DATA_WIDTH(8),
    .KEEP_ENABLE(0),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .FRAME_FIFO(1),
    .USER_BAD_FRAME_VALUE(1'b1),
    .USER_BAD_FRAME_MASK(1'b1),
    .DROP_BAD_FRAME(1'b1),
    .DROP_WHEN_FULL(0)
)
from_cs_rx_fifo_inst (
    // Common reset
    .async_rst(rst_int),
    // AXI input
    .s_clk(clk_int),
    .s_axis_tdata(s_from_cs_axis_tdata),
    .s_axis_tkeep(0),//must default to high in docs but its very bad
    .s_axis_tvalid(s_from_cs_axis_tvalid),
    .s_axis_tready(s_from_cs_axis_tready),
    .s_axis_tlast(s_from_cs_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(s_from_cs_axis_tuser),
    // AXI output
    .m_clk(clk_int),
    .m_axis_tdata(from_cs_fifo_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(from_cs_fifo_axis_tvalid),
    .m_axis_tready(from_cs_fifo_axis_tready),
    .m_axis_tlast(from_cs_fifo_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(from_cs_fifo_axis_tuser),
    // Status
    .s_status_overflow(from_cs_fifo_status_overflow),
    .s_status_bad_frame(from_cs_fifo_status_bad_frame),
    .s_status_good_frame(from_cs_fifo_status_good_frame),
    .m_status_overflow(),
    .m_status_bad_frame(),
    .m_status_good_frame()
);



axis_async_fifo #(
    .ADDR_WIDTH(FROM_PS_FIFO_ADDR_WIDTH),
    .DATA_WIDTH(8),
    .KEEP_ENABLE(0),
    .LAST_ENABLE(1),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .FRAME_FIFO(1),
    .USER_BAD_FRAME_VALUE(1'b1),
    .USER_BAD_FRAME_MASK(1'b1),
    .DROP_BAD_FRAME(1'b1),
    .DROP_WHEN_FULL(0)
)
from_ps_rx_fifo_inst (
    // Common reset
    .async_rst(rst_int),
    // AXI input
    .s_clk(clk_int),
    .s_axis_tdata(from_ps_axis_tdata),
    .s_axis_tkeep(0),//must default to high in docs but its very bad
    .s_axis_tvalid(from_ps_axis_tvalid),
    .s_axis_tready(from_ps_axis_tready),
    .s_axis_tlast(from_ps_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(from_ps_axis_tuser),
    // AXI output
    .m_clk(clk_int),
    .m_axis_tdata(from_ps_fifo_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(from_ps_fifo_axis_tvalid),
    .m_axis_tready(from_ps_fifo_axis_tready),
    .m_axis_tlast(from_ps_fifo_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(from_ps_fifo_axis_tuser),
    // Status
    .s_status_overflow(from_ps_fifo_status_overflow),
    .s_status_bad_frame(from_ps_fifo_status_bad_frame),
    .s_status_good_frame(from_ps_fifo_status_good_frame),
    .m_status_overflow(),
    .m_status_bad_frame(),
    .m_status_good_frame()
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
		.clk(clk_int),
		.rst(rst_int),
		// AXI inputs
		.s_axis_tdata({from_cs_fifo_axis_tdata, from_ps_fifo_axis_tdata}),
//		.s_axis_tkeep(s_axis_tkeep, from_ps_axis_tkeep),
		.s_axis_tvalid({from_cs_fifo_axis_tvalid, from_ps_fifo_axis_tvalid}),
		.s_axis_tready({from_cs_fifo_axis_tready, from_ps_fifo_axis_tready}),
		.s_axis_tlast({from_cs_fifo_axis_tlast, from_ps_fifo_axis_tlast}),
//		.s_axis_tid({s_from_cs_axis_tid, 0}),
//		.s_axis_tdest({s_from_cs_axis_tdest, 0}),
		.s_axis_tuser({from_cs_fifo_axis_tuser, from_ps_fifo_axis_tuser}),
		// AXI output
		.m_axis_tdata(from_arb_axis_tdata),
//		.m_axis_tkeep(from_arb_axis_tkeep),
		.m_axis_tvalid(from_arb_axis_tvalid),
		.m_axis_tready(from_arb_axis_tready),
		.m_axis_tlast(from_arb_axis_tlast),
//		.m_axis_tid(s_axis_tid),
//		.m_axis_tdest(s_axis_tdest),
		.m_axis_tuser(from_arb_axis_tuser)
	);


//HANDLED BY THE MAC
//axis_gmii_tx #(
//		.ENABLE_PADDING(1),
//		.MIN_FRAME_LENGTH(16)
//	)
//	to_phy_axis_gmii_tx_inst (
//		.clk(clk_int),
//		.rst(rst_int),
//		.s_axis_tdata(from_arb_axis_tdata),
//		.s_axis_tvalid(from_arb_axis_tvalid),
//		.s_axis_tready(from_arb_axis_tready),
//		.s_axis_tlast(from_arb_axis_tlast),
//		.s_axis_tuser(from_arb_axis_tuser),
//		.gmii_txd(gmii_txd),
//		.gmii_tx_en(gmii_tx_en),
//		.gmii_tx_er(gmii_tx_er),
//		.clk_enable(clk_enable),
//		.mii_select(mii_select),
//		.ifg_delay(ifg_delay)
//	);
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
user_cross_layer_switch_v1_0_S00_AXI # (
		.UDP_DATA_WIDTH(UDP_DATA_WIDTH),
		.UDP_IP_WIDTH(UDP_IP_WIDTH),
		.UDP_LENGTH_WIDTH(UDP_LENGTH_WIDTH),
		.UDP_PORT_WIDTH(UDP_PORT_WIDTH),
		.UDP_MAC_WIDTH(UDP_MAC_WIDTH),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) user_cross_layer_switch_v1_0_S00_AXI_inst (
		.reset(sw_reset),
//		.start(start),
		.read(read),
		.nbytes(nbytes),
		.address(address),
		.write_data(write_data),
		.busy(busy),
		.read_data(read_data),
        
		/*
		 * UDP ports for filtering 
		 */
		//.local_mac(local_mac),
		.udp_port_1(udp_port_1),
		.udp_port_2(udp_port_2),
		.udp_port_3(udp_port_3),
		.udp_port_4(udp_port_4),
		.udp_port_5(udp_port_5),
		.udp_port_6(udp_port_6),
		.udp_port_7(udp_port_7),
		.udp_port_8(udp_port_8),
		
		
		.ps_rx_pkt_count(ps_rx_pkt_count),
        .cs_rx_pkt_count(cs_rx_pkt_count),
        
        
        .ps_tx_pkt_count(ps_tx_pkt_count),
        .cs_tx_pkt_count(cs_tx_pkt_count),
        .rx_sw_state(rx_sw_state),
        .bus_status(bus_status),  
        

        
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
