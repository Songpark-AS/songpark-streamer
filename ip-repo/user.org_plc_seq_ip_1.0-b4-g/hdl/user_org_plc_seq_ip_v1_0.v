
`timescale 1 ns / 1 ps

	module plc_seq_ip #
	(
		// Users to add parameters here
        parameter integer S_COUNT = 64, // timing problems come in when this is 128
        parameter SEQ_BANK_FIFO_ADDR_WIDTH = 12,
        parameter PACKET_SKIP_DEFAULT = 8,
        parameter integer SHIFTS_PER_MILLISECOND = 17,
        parameter integer DELAY_COUNT_WIDTH = 64,
        parameter SYNC_COUNT_WIDTH = 32,
        parameter integer FIFO_ADDR_WIDTH = 4,//Eth to audio
        parameter PACKET_LEN_WIDTH = 16,
        
		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 8,

		// Parameters of Axi Slave Bus Interface fm_udp_s_axis
		parameter integer C_fm_udp_s_axis_TDATA_WIDTH	= 8,

		// Parameters of Axi Slave Bus Interface fm_audio_s_axis
		parameter integer C_fm_audio_s_axis_TDATA_WIDTH	= 8,

		// Parameters of Axi Master Bus Interface to_udp_m_axis
		parameter integer C_to_udp_m_axis_TDATA_WIDTH	= 8,
		parameter integer C_to_udp_m_axis_START_COUNT	= 32,

		// Parameters of Axi Master Bus Interface to_audio_m_axis
		parameter integer C_to_audio_m_axis_TDATA_WIDTH	= 8,
		parameter integer C_to_audio_m_axis_START_COUNT	= 32
	)
	(
		// Users to add ports here
            input wire clk_125,
            input wire rst_in,
            input  wire [FIFO_ADDR_WIDTH -1: 0] fifo_occ_in,
            
            input wire play_out_ready_in,
            input wire  new_sample_in,
            
            input  wire       fifo_full_in,
            input  wire       fifo_empty_in,
            
            output  wire       fifo_full_out,
            output  wire       fifo_empty_out,
            
            output  wire       status1_out,
            output  wire       status2_out,	
            
            output wire replace_inprogress_out,
            output wire  new_pkt_ready_out,
		    input wire replace_pkt_end_in,
		    input wire replace_pkt_in,
//		    output wire rst_plc_out,
            
            input wire tsync_in,
        input wire  sync_en_in,
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

		// Ports of Axi Slave Bus Interface fm_udp_s_axis
		input wire  fm_udp_s_axis_aclk,
		input wire  fm_udp_s_axis_aresetn,
		output wire  fm_udp_s_axis_tready,
		input wire [C_fm_udp_s_axis_TDATA_WIDTH-1 : 0] fm_udp_s_axis_tdata,
		input wire  fm_udp_s_axis_tlast,
		input wire  fm_udp_s_axis_tvalid,

		// Ports of Axi Slave Bus Interface fm_audio_s_axis
		input wire  fm_audio_s_axis_aclk,
		input wire  fm_audio_s_axis_aresetn,
		output wire  fm_audio_s_axis_tready,
		input wire [C_fm_audio_s_axis_TDATA_WIDTH-1 : 0] fm_audio_s_axis_tdata,
		input wire  fm_audio_s_axis_tlast,
		input wire  fm_audio_s_axis_tvalid,
		input wire  fm_audio_hdr_valid,

		// Ports of Axi Master Bus Interface to_udp_m_axis
		input wire  to_udp_m_axis_aclk,
		input wire  to_udp_m_axis_aresetn,
		output wire  to_udp_m_axis_tvalid,
		output wire [C_to_udp_m_axis_TDATA_WIDTH-1 : 0] to_udp_m_axis_tdata,
		output wire  to_udp_m_axis_tlast,
		input wire  to_udp_m_axis_tready,
		output wire  to_udp_hdr_valid,

		// Ports of Axi Master Bus Interface to_audio_m_axis
		input wire  to_audio_m_axis_aclk,
		input wire  to_audio_m_axis_aresetn,
		output wire  to_audio_m_axis_tvalid,
		output wire [C_to_audio_m_axis_TDATA_WIDTH-1 : 0] to_audio_m_axis_tdata,
		output wire  to_audio_m_axis_tlast,
		input wire  to_audio_m_axis_tready
		
		
		
	);
	
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction
	
	wire       status1_out_int;
    wire       status2_out_int;	
     wire       cfg_seq_rx_reset;
     wire       cfg_seq_rx_reset_int;
	
	wire [S_COUNT-1:0] cfg_tlast_count_to_drop;
	
	wire cfg_seq_disable;
	wire cfg_pkt_wait_disable;
	
	wire cfg_pkt_send_delay_disable;
	
	
	wire cfg_seq_disable_sync;
	
	wire [SYNC_COUNT_WIDTH-1:0] cfg_pkt_wait_delay_count; 
	wire [DELAY_COUNT_WIDTH-1:0] cfg_pkt_send_delay_count;
	wire [DELAY_COUNT_WIDTH-1:0] cfg_replace_wait_delay_count;
	wire [DELAY_COUNT_WIDTH-1:0] cfg_replace_lock_delay_count;
	
	
	wire [FIFO_ADDR_WIDTH -1: 0] cfg_fifo_occ_lim;
	wire [FIFO_ADDR_WIDTH -1: 0] cfg_fifo_occ_lim_sync;
	
	wire [PACKET_LEN_WIDTH-1:0] cfg_pkt_payload_size;
	wire [PACKET_LEN_WIDTH-1:0] cfg_pkt_payload_size_sync;
	
	wire [C_S_AXI_DATA_WIDTH-1:0] dropped_pkt_counter;
	wire [C_S_AXI_DATA_WIDTH-1:0] replaced_pkt_counter;
	
	 wire [C_S_AXI_DATA_WIDTH-1:0] transmitted_pkt_counter;
     wire [C_S_AXI_DATA_WIDTH-1:0] received_pkt_counter;
     
     wire [C_S_AXI_DATA_WIDTH-1:0] overwrite_pkt_counter;
	
	wire replace_pkt_in_sync;
	
	wire [3:0] in_exec_state_out;
	wire [3:0] out_exec_state_out;
	wire replace_lock_timeout;
	
    
    
    wire rst_in_sync;

sync_signal #(
    .N(4),
    .WIDTH(1)
)
replace_pkt_in_inst (
    .clk(clk_125),
    .in(replace_pkt_in),
    .out(replace_pkt_in_sync)
);


sync_reset #(
    .N(4)
)
sync_rst_in_inst (
    .clk(clk_125),
    .rst(rst_in),
//.rst(~reset_n),
    .sync_reset_out(rst_in_sync)
);


sync_reset #(
    .N(4)
)
sync_reset_inst (
    .clk(clk_125),
    .rst(cfg_seq_rx_reset),
//.rst(~reset_n),
    .sync_reset_out(cfg_seq_rx_reset_int)
);



sync_signal #(
    .N(4),
    .WIDTH(1)
)
sync_cfg_disable_inst (
    .clk(clk_125),
    .in(cfg_seq_disable),
//.rst(~reset_n),
    .out(cfg_seq_disable_sync)
);

sync_signal #(
    .N(4),
    .WIDTH(PACKET_LEN_WIDTH)
)
cfg_pkt_payload_size_inst (
    .clk(clk_125),
    .in(cfg_pkt_payload_size),
    .out(cfg_pkt_payload_size_sync)
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

	
// Instantiation of Axi Bus Interface S00_AXI
	user_org_plc_seq_ip_v1_0_S00_AXI # ( 
	    .PACKET_SKIP_DEFAULT(PACKET_SKIP_DEFAULT),
	    .FIFO_ADDR_WIDTH(FIFO_ADDR_WIDTH),
	    .PACKET_LEN_WIDTH(PACKET_LEN_WIDTH),
	    .DELAY_COUNT_WIDTH(DELAY_COUNT_WIDTH),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) user_org_plc_seq_ip_v1_0_S00_AXI_inst (
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
		.dropped_pkt_counter(dropped_pkt_counter),
		.replaced_pkt_counter(replaced_pkt_counter),
		.transmitted_pkt_counter(transmitted_pkt_counter),
		.received_pkt_counter(received_pkt_counter),	
		.overwrite_pkt_counter(overwrite_pkt_counter),

		.general_status_in({replace_lock_timeout, replace_inprogress_out, new_pkt_ready_out, replace_pkt_end_in, replace_pkt_in, 1'b0, to_audio_m_axis_tlast, to_audio_m_axis_tready, to_audio_m_axis_tvalid, 1'b0, fm_udp_s_axis_tlast, fm_udp_s_axis_tready, fm_udp_s_axis_tvalid}),
		.cfg_tlast_count_to_drop_out(cfg_tlast_count_to_drop),
		.cfg_pkt_wait_delay_count_out(cfg_pkt_wait_delay_count),
		.cfg_replace_lock_delay_count_out(cfg_replace_lock_delay_count),
		.cfg_replace_wait_delay_count_out(cfg_replace_wait_delay_count),
		.cfg_pkt_send_delay_count_out(cfg_pkt_send_delay_count),
		.seq_rx_reset_out(cfg_seq_rx_reset),
		.seq_disable_out(cfg_seq_disable),
		.cfg_pkt_wait_disable(cfg_pkt_wait_disable),
		.cfg_fifo_occ_lim(cfg_fifo_occ_lim),
		.cfg_pkt_payload_size(cfg_pkt_payload_size),
		.cfg_pkt_send_delay_disable(cfg_pkt_send_delay_disable),
		.in_exec_state_out(in_exec_state_out),
		.out_exec_state_out(out_exec_state_out)
	);

// Instantiation of Axi Bus Interface fm_udp_s_axis
	user_org_plc_seq_ip_v1_0_fm_udp_s_axis # ( 
	    .S_COUNT(S_COUNT),
	    .SEQ_BANK_FIFO_ADDR_WIDTH(SEQ_BANK_FIFO_ADDR_WIDTH),
	    .PACKET_LEN_WIDTH(PACKET_LEN_WIDTH),
	    .FIFO_ADDR_WIDTH(FIFO_ADDR_WIDTH),
	    .DELAY_COUNT_WIDTH(DELAY_COUNT_WIDTH),
	    .SHIFTS_PER_MILLISECOND(SHIFTS_PER_MILLISECOND),
	    .SYNC_COUNT_WIDTH(SYNC_COUNT_WIDTH),
		.C_S_AXIS_TDATA_WIDTH(C_fm_udp_s_axis_TDATA_WIDTH)
	) user_org_plc_seq_ip_v1_0_fm_udp_s_axis_inst (
	    .clk(fm_udp_s_axis_aclk),
	    .rst(~fm_udp_s_axis_aresetn||cfg_seq_rx_reset_int||rst_in_sync),
	    
		.S_AXIS_ACLK(fm_udp_s_axis_aclk),
		.S_AXIS_ARESETN(fm_udp_s_axis_aresetn),
		.S_AXIS_TREADY(fm_udp_s_axis_tready),
		.S_AXIS_TDATA(fm_udp_s_axis_tdata),
//		.S_AXIS_TSTRB(fm_udp_s_axis_tstrb),
		.S_AXIS_TLAST(fm_udp_s_axis_tlast),
		.S_AXIS_TVALID(fm_udp_s_axis_tvalid),
		
		
		.M_AXIS_ACLK(to_audio_m_axis_aclk),
		.M_AXIS_ARESETN(to_audio_m_axis_aresetn),
		.M_AXIS_TVALID(to_audio_m_axis_tvalid),
		.M_AXIS_TDATA(to_audio_m_axis_tdata),
//		.M_AXIS_TSTRB(to_audio_m_axis_tstrb),
		.M_AXIS_TLAST(to_audio_m_axis_tlast),
		.M_AXIS_TREADY(to_audio_m_axis_tready),
		
		.dropped_pkt_counter(dropped_pkt_counter),
		.replaced_pkt_counter(replaced_pkt_counter),
		
		.transmitted_pkt_counter_out(transmitted_pkt_counter),
		.received_pkt_counter_out(received_pkt_counter),	
		.overwrite_pkt_counter_out(overwrite_pkt_counter),
		.replace_lock_timeout_out(replace_lock_timeout),
		
		
		.cfg_tlast_count_to_drop_in(cfg_tlast_count_to_drop),
		.cfg_pkt_wait_delay_count_in(cfg_pkt_wait_delay_count),
		.cfg_pkt_send_delay_count_in(cfg_pkt_send_delay_count),
		.cfg_replace_wait_delay_count_in(cfg_replace_wait_delay_count),
		.cfg_replace_lock_delay_count_in(cfg_replace_lock_delay_count),
		.cfg_seq_disable(cfg_seq_disable_sync),
		.cfg_pkt_wait_disable(cfg_pkt_wait_disable),
		.cfg_pkt_send_delay_disable(cfg_pkt_send_delay_disable),
		.cfg_fifo_occ_lim(cfg_fifo_occ_lim_sync ),
		.cfg_pkt_payload_size(cfg_pkt_payload_size_sync),
		
		.fifo_occ_in(fifo_occ_in),
		.replace_pkt_in(replace_pkt_in_sync),
		.play_out_ready_in(play_out_ready_in),
		.in_exec_state_out(in_exec_state_out),
		.out_exec_state_out(out_exec_state_out),
		
		.replace_inprogress_out(replace_inprogress_out),
		.new_sample_in(new_sample_in),
		.new_pkt_ready_out(new_pkt_ready_out),
		.replace_pkt_end_in(replace_pkt_end_in),
		
		.tsync_in(tsync_in),
        .sync_en_in(sync_en_in),
		
		.status1_out(status1_out_int),
		.status2_out(status2_out_int)
	);

// Instantiation of Axi Bus Interface fm_audio_s_axis
	user_org_plc_seq_ip_v1_0_fm_audio_s_axis # (
		.C_S_AXIS_TDATA_WIDTH(C_fm_audio_s_axis_TDATA_WIDTH)
	) user_org_pkt_seq_ip_v1_0_fm_audio_s_axis_inst (
		.S_AXIS_ACLK(fm_audio_s_axis_aclk),
		.S_AXIS_ARESETN(fm_audio_s_axis_aresetn),
		.S_AXIS_TREADY(fm_audio_s_axis_tready),
		.S_AXIS_TDATA(fm_audio_s_axis_tdata),
//		.S_AXIS_TSTRB(fm_audio_s_axis_tstrb),
		.S_AXIS_TLAST(fm_audio_s_axis_tlast),
		.S_AXIS_TVALID(fm_audio_s_axis_tvalid),
		
		.M_AXIS_ACLK(to_udp_m_axis_aclk),
		.M_AXIS_ARESETN(to_udp_m_axis_aresetn),
		.M_AXIS_TVALID(to_udp_m_axis_tvalid),
		.M_AXIS_TDATA(to_udp_m_axis_tdata),
//		.M_AXIS_TSTRB(to_udp_m_axis_tstrb),
		.M_AXIS_TLAST(to_udp_m_axis_tlast),
		.M_AXIS_TREADY(to_udp_m_axis_tready)
		
		
	);

// Instantiation of Axi Bus Interface to_udp_m_axis
//	user_org_pkt_seq_ip_v1_0_to_udp_m_axis # ( 
//		.C_M_AXIS_TDATA_WIDTH(C_to_udp_m_axis_TDATA_WIDTH),
//		.C_M_START_COUNT(C_to_udp_m_axis_START_COUNT)
//	) user_org_pkt_seq_ip_v1_0_to_udp_m_axis_inst (
//		.M_AXIS_ACLK(to_udp_m_axis_aclk),
//		.M_AXIS_ARESETN(to_udp_m_axis_aresetn),
//		.M_AXIS_TVALID(to_udp_m_axis_tvalid),
//		.M_AXIS_TDATA(to_udp_m_axis_tdata),
//		.M_AXIS_TSTRB(to_udp_m_axis_tstrb),
//		.M_AXIS_TLAST(to_udp_m_axis_tlast),
//		.M_AXIS_TREADY(to_udp_m_axis_tready)
//	);

// Instantiation of Axi Bus Interface to_audio_m_axis
//	user_org_pkt_seq_ip_v1_0_to_audio_m_axis # ( 
//		.C_M_AXIS_TDATA_WIDTH(C_to_audio_m_axis_TDATA_WIDTH),
//		.C_M_START_COUNT(C_to_audio_m_axis_START_COUNT)
//	) user_org_pkt_seq_ip_v1_0_to_audio_m_axis_inst (
//		.M_AXIS_ACLK(to_audio_m_axis_aclk),
//		.M_AXIS_ARESETN(to_audio_m_axis_aresetn),
//		.M_AXIS_TVALID(to_audio_m_axis_tvalid),
//		.M_AXIS_TDATA(to_audio_m_axis_tdata),
//		.M_AXIS_TSTRB(to_audio_m_axis_tstrb),
//		.M_AXIS_TLAST(to_audio_m_axis_tlast),
//		.M_AXIS_TREADY(to_audio_m_axis_tready)
//	);

	// Add user logic here

    assign to_udp_hdr_valid=fm_audio_hdr_valid;
    assign  fifo_full_out = fifo_full_in;
    assign  fifo_empty_out = fifo_empty_in;
    
    assign  status1_out = status1_out_int;
    assign  status2_out = status1_out_int;
     
//     assign rst_plc_out = cfg_seq_rx_reset_int;
	// User logic ends

	endmodule
