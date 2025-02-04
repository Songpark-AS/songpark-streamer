
`timescale 1 ns / 1 ps

	module PLC_v1_0 #
	(
		// Users to add parameters here
        parameter integer RTP_HDR_SEQ_WIDTH	= 16,
	    parameter integer SHIFTS_PER_MILLISECOND = 17,
	    parameter integer DELAY_COUNT_WIDTH = 64,
	    parameter integer FIFO_ADDR_WIDTH = 16,
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 8,

		// Parameters of Axi Slave Bus Interface FRM_SEQ_S_AXIS
		parameter integer C_FRM_SEQ_S_AXIS_TDATA_WIDTH	= 8,

		// Parameters of Axi Master Bus Interface TO_AUD_M_AXI
		parameter integer C_TO_AUD_M_AXI_TDATA_WIDTH	= 8,
		parameter integer C_S_AXI_DATA_WIDTH = 32,
		parameter integer C_TO_AUD_M_AXI_START_COUNT	= 32
	)
	(
		// Users to add ports here
        input wire  new_sample_in,
        output  wire       status1_out,
        output  wire       status2_out,
        input  wire       fifo_full_in,
        input  wire       fifo_empty_in,
        
        output  wire       fifo_full_out,
        output  wire       fifo_empty_out,
        
        input  wire [FIFO_ADDR_WIDTH -1: 0] fifo_occ_in,
        
        input wire clk_125,
		// User ports ends
		// Do not modify the ports beyond this line
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

		// Ports of Axi Slave Bus Interface FRM_SEQ_S_AXIS
		input wire  frm_seq_s_axis_aclk,
		input wire  frm_seq_s_axis_aresetn,
		output wire  frm_seq_s_axis_tready,
		input wire [C_FRM_SEQ_S_AXIS_TDATA_WIDTH-1 : 0] frm_seq_s_axis_tdata,
		//input wire [(C_FRM_SEQ_S_AXIS_TDATA_WIDTH/8)-1 : 0] frm_seq_s_axis_tstrb,
		input wire  frm_seq_s_axis_tlast,
		input wire  frm_seq_s_axis_tvalid,

		// Ports of Axi Master Bus Interface TO_AUD_M_AXI
		input wire  to_aud_m_axis_aclk,
		input wire  to_aud_m_axis_aresetn,
		output wire  to_aud_m_axis_tvalid,
		output wire [C_TO_AUD_M_AXI_TDATA_WIDTH-1 : 0] to_aud_m_axis_tdata,
		output wire  to_aud_m_axis_tlast,
		input wire  to_aud_m_axis_tready
	);
	
	
	wire cfg_enf_reset;
	wire cfg_enf_rx_reset;
	wire cfg_enf_disable;
	wire cfg_rx_lock;
	wire [C_S_AXI_DATA_WIDTH-1:0] cfg_network_base_delay;
	wire [C_S_AXI_DATA_WIDTH-1:0] cfg_pkt_build_delay;
	
	
	wire [C_S_AXI_DATA_WIDTH-1:0] cfg_network_base_delay_sync;
	wire [C_S_AXI_DATA_WIDTH-1:0] cfg_pkt_build_delay_sync;
	
	
	wire cfg_rx_lock_sync;
	wire new_sample_in_sync;
	
	wire [FIFO_ADDR_WIDTH -1: 0] cfg_fifo_occ_lim;
	wire [FIFO_ADDR_WIDTH -1: 0] cfg_fifo_occ_lim_sync;
	
	wire cfg_enf_accum_enable;
	wire cfg_enf_accum_enable_sync;
	
	wire cfg_enf_diff_enable;
	wire cfg_enf_diff_enable_sync;
		
	wire [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_delay_limit;
	wire  [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_locked_delay_limit;
	wire  [DELAY_COUNT_WIDTH-1:0] accum_spkt_to_pkt_delay_limit;
	
	
	
	wire  [DELAY_COUNT_WIDTH-1:0] diff_spkt_to_pkt_delay_limit;
	wire  signed [DELAY_COUNT_WIDTH-1:0] diff_spkt_to_pkt_delay;
	
	
	wire cfg_enf_reset_sync;
	wire cfg_enf_rx_reset_sync;
	wire cfg_enf_disable_sync;
	wire cfg_enf_spkt_to_pkt_lock_enable;
	wire cfg_enf_spkt_to_pkt_lock_enable_sync;
		
	wire [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_delay_limit_sync;
	wire  [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_locked_delay_limit_sync;
	wire  [DELAY_COUNT_WIDTH-1:0] accum_spkt_to_pkt_delay_limit_sync;
	wire  [DELAY_COUNT_WIDTH-1:0] diff_spkt_to_pkt_delay_limit_sync;
		
    wire [C_S_AXI_DATA_WIDTH-1:0] dropped_pkt_counter;
    
    wire [DELAY_COUNT_WIDTH-1:0]  accum_spkt_to_pkt_delay;
	wire [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_delay;
	
	


sync_reset #(
    .N(4)
)
sync_reset_inst (
    .clk(clk_125),
    .rst(cfg_enf_reset),
//.rst(~reset_n),
    .sync_reset_out(cfg_enf_reset_sync)
);


sync_reset #(
    .N(4)
)
cfg_enf_rx_reset_inst (
    .clk(clk_125),
    .rst(cfg_enf_rx_reset),
//.rst(~reset_n),
    .sync_reset_out(cfg_enf_rx_reset_sync)
);



sync_signal #(
    .N(4),
    .WIDTH(C_S_AXI_DATA_WIDTH)
)
cfg_network_base_delay_inst (
    .clk(clk_125),
    .in(cfg_network_base_delay),
    .out(cfg_network_base_delay_sync)
);


sync_signal #(
    .N(4),
    .WIDTH(C_S_AXI_DATA_WIDTH)
)
cfg_pkt_build_delay_inst (
    .clk(clk_125),
    .in(cfg_pkt_build_delay),
    .out(cfg_pkt_build_delay_sync)
);


sync_signal #(
    .N(4),
    .WIDTH(1)
)
new_sample_in_inst (
    .clk(clk_125),
    .in(new_sample_in),
    .out(new_sample_in_sync)
);



sync_signal #(
    .N(4),
    .WIDTH(1)
)
cfg_enf_diff_enable_inst (
    .clk(clk_125),
    .in(cfg_enf_diff_enable),
    .out(cfg_enf_diff_enable_sync)
);


sync_signal #(
    .N(4),
    .WIDTH(1)
)
sync_cfg_enf_spkt_to_pkt_lock_enable_inst (
    .clk(clk_125),
    .in(cfg_enf_spkt_to_pkt_lock_enable),
    .out(cfg_enf_spkt_to_pkt_lock_enable_sync)
);



sync_signal #(
    .N(4),
    .WIDTH(1)
)
sync_cfg_disable_inst (
    .clk(clk_125),
    .in(cfg_enf_disable),
    .out(cfg_enf_disable_sync)
);


sync_signal #(
    .N(4),
    .WIDTH(1)
)
cfg_rx_lock_inst (
    .clk(clk_125),
    .in(cfg_rx_lock),
    .out(cfg_rx_lock_sync)
);

sync_signal #(
    .N(4),
    .WIDTH(1)
)
cfg_enf_accum_enable_inst (
    .clk(clk_125),
    .in(cfg_enf_accum_enable),
    .out(cfg_enf_accum_enable_sync)
);



sync_signal #(
    .N(4),
    .WIDTH(DELAY_COUNT_WIDTH)
)
spkt_to_pkt_delay_limit_inst (
    .clk(clk_125),
    .in(spkt_to_pkt_delay_limit),
    .out(spkt_to_pkt_delay_limit_sync)
);

sync_signal #(
    .N(4),
    .WIDTH(FIFO_ADDR_WIDTH)
)
cfg_fifo_occ_lim_inst (
    .clk(clk_125),
    .in(cfg_fifo_occ_lim),
    .out(cfg_fifo_occ_lim_sync)
);



sync_signal #(
    .N(4),
    .WIDTH(DELAY_COUNT_WIDTH)
)
spkt_to_pkt_locked_delay_limit_inst (
    .clk(clk_125),
    .in(spkt_to_pkt_locked_delay_limit),
    .out(spkt_to_pkt_locked_delay_limit_sync)
);

sync_signal #(
    .N(4),
    .WIDTH(DELAY_COUNT_WIDTH)
)
accum_spkt_to_pkt_delay_limit_inst (
    .clk(clk_125),
    .in(accum_spkt_to_pkt_delay_limit),
    .out(accum_spkt_to_pkt_delay_limit_sync)
);

sync_signal #(
    .N(4),
    .WIDTH(DELAY_COUNT_WIDTH)
)
diff_spkt_to_pkt_delay_limit_inst (
    .clk(clk_125),
    .in(diff_spkt_to_pkt_delay_limit),
    .out(diff_spkt_to_pkt_delay_limit_sync)
);


    
	
// Instantiation of Axi Bus Interface S00_AXI
	PLC_S00_AXI # ( 
	   .FIFO_ADDR_WIDTH(FIFO_ADDR_WIDTH),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) PLC_S00_AXI_inst (
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
		.S_AXI_RREADY(s00_axi_rready),
		
		
		.cfg_enf_reset(cfg_enf_reset),
		.cfg_enf_rx_reset(cfg_enf_rx_reset),
		.cfg_enf_disable(cfg_enf_disable),
		.cfg_rx_lock(cfg_rx_lock),
		.cfg_enf_accum_enable(cfg_enf_accum_enable),
		.cfg_enf_diff_enable(cfg_enf_diff_enable),
		.cfg_enf_spkt_to_pkt_lock_enable(cfg_enf_spkt_to_pkt_lock_enable),
		.cfg_fifo_occ_lim(cfg_fifo_occ_lim),
		
		.cfg_network_base_delay(cfg_network_base_delay),
	    .cfg_pkt_build_delay(cfg_pkt_build_delay),
		
		.dropped_pkt_counter(dropped_pkt_counter),
		
		
		.spkt_to_pkt_delay_limit(spkt_to_pkt_delay_limit),
		.spkt_to_pkt_locked_delay_limit(spkt_to_pkt_locked_delay_limit),
		.accum_spkt_to_pkt_delay_limit(accum_spkt_to_pkt_delay_limit),
		.diff_spkt_to_pkt_delay_limit(diff_spkt_to_pkt_delay_limit),
		
		.accum_spkt_to_pkt_delay_in(accum_spkt_to_pkt_delay),
		.diff_spkt_to_pkt_delay_in(diff_spkt_to_pkt_delay),
		.spkt_to_pkt_delay_in(spkt_to_pkt_delay)
	);

// Instantiation of Axi Bus Interface FRM_SEQ_S_AXIS
	PLC_FRM_UDP_S_AXIS # ( 
		.C_S_AXIS_TDATA_WIDTH(C_FRM_SEQ_S_AXIS_TDATA_WIDTH),
		.FIFO_ADDR_WIDTH(FIFO_ADDR_WIDTH),
		.SHIFTS_PER_MILLISECOND(SHIFTS_PER_MILLISECOND),
		.RTP_HDR_SEQ_WIDTH(RTP_HDR_SEQ_WIDTH),
		.DELAY_COUNT_WIDTH(DELAY_COUNT_WIDTH)
	) PLC_FRM_UDP_S_AXIS_inst (
	    .clk(clk_125),
	    .rst(~frm_seq_s_axis_aresetn|cfg_enf_reset_sync),
	
		.S_AXIS_ACLK(frm_seq_s_axis_aclk),
		.S_AXIS_ARESETN(frm_seq_s_axis_aresetn),
		.S_AXIS_TREADY(frm_seq_s_axis_tready),
		.S_AXIS_TDATA(frm_seq_s_axis_tdata),
		.S_AXIS_TLAST(frm_seq_s_axis_tlast),
		.S_AXIS_TVALID(frm_seq_s_axis_tvalid),
		
		.M_AXIS_ACLK(to_aud_m_axis_aclk),
		.M_AXIS_ARESETN(to_aud_m_axis_aresetn),
		.M_AXIS_TREADY(to_aud_m_axis_tready),
		.M_AXIS_TDATA(to_aud_m_axis_tdata),
		.M_AXIS_TLAST(to_aud_m_axis_tlast),
		.M_AXIS_TVALID(to_aud_m_axis_tvalid),
		
		
		.new_sample(new_sample_in_sync),
		.cfg_enf_reset(cfg_enf_reset_sync),
		.cfg_enf_rx_reset(cfg_enf_rx_reset_sync),
		.cfg_enf_disable(cfg_enf_disable_sync),
		.cfg_rx_lock(cfg_rx_lock_sync),
		.cfg_enf_accum_enable(cfg_enf_accum_enable_sync),
		.cfg_enf_diff_enable(cfg_enf_diff_enable_sync),
		.cfg_enf_spkt_to_pkt_lock_enable(cfg_enf_spkt_to_pkt_lock_enable_sync),
		
		.cfg_network_base_delay(cfg_network_base_delay_sync),
	    .cfg_pkt_build_delay(cfg_pkt_build_delay_sync),
		
		
		.cfg_spkt_to_pkt_delay_limit(spkt_to_pkt_delay_limit_sync),
		.cfg_spkt_to_pkt_locked_delay_limit(spkt_to_pkt_locked_delay_limit_sync),
		.cfg_accum_spkt_to_pkt_delay_limit(accum_spkt_to_pkt_delay_limit_sync),
		.cfg_diff_spkt_to_pkt_delay_limit(diff_spkt_to_pkt_delay_limit_sync),
		.cfg_fifo_occ_lim(cfg_fifo_occ_lim_sync ),
		
		.accum_spkt_to_pkt_delay_out(accum_spkt_to_pkt_delay),
		.spkt_to_pkt_delay_out(spkt_to_pkt_delay),
		.diff_spkt_to_pkt_delay_out(diff_spkt_to_pkt_delay),
		
		.fifo_occ_in(fifo_occ_in),
		.dropped_pkt_counter(dropped_pkt_counter),
		.status1_out(status1_out),
        .status2_out(status2_out)
	);

	

	// Add user logic here
	
	assign  fifo_full_out = fifo_full_in;
    assign  fifo_empty_out = fifo_empty_in;

	// User logic ends

	endmodule
