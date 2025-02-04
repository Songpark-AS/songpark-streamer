
`timescale 1 ns / 1 ps

	module time_sync_v1_0 #
	(
		// Users to add parameters here
         parameter integer TC_COUNT_WIDTH = 32,
         parameter integer MIN_UDP_PKT_SIZE	= 256,
         parameter UDP_LENGTH_WIDTH = 16,
         parameter integer SHIFTS_PER_MILLISECOND = 17,
        parameter integer DELAY_COUNT_WIDTH = 32,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 7,

		// Parameters of Axi Slave Bus Interface S00_AXIS
		parameter integer C_S_AXIS_TDATA_WIDTH	= 8,

		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer C_M00_AXIS_TDATA_WIDTH	= 8
	)
	(
		// Users to add ports here
		output wire  tc_start_out,
        input wire [TC_COUNT_WIDTH-1 : 0] tc_count_in,
        output wire [TC_COUNT_WIDTH-1 : 0] tc_count_adjusted_out,    
        
        output wire  tc_adjust_out,
        output wire initiate_sync_request_out,
        output wire sync_done_out,
        
        output  wire       m_hdr_valid,
        input  wire       s_hdr_valid,
        input wire        s_hdr_ready,
        output wire [UDP_LENGTH_WIDTH-1:0]  m_time_sync_payload_length,
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

		// Ports of Axi Slave Bus Interface S00_AXIS
		input wire  s00_axis_aclk,
		input wire  s00_axis_aresetn,
		output wire  s00_axis_tready,
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
//		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] s00_axis_tstrb,
		input wire  s00_axis_tlast,
		input wire  s00_axis_tvalid,

		// Ports of Axi Master Bus Interface M00_AXIS
		input wire  m00_axis_aclk,
		input wire  m00_axis_aresetn,
		output wire  m00_axis_tvalid,
		output wire [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
//		output wire [(C_M00_AXIS_TDATA_WIDTH/8)-1 : 0] m00_axis_tstrb,
		output wire  m00_axis_tlast,
		output wire  m00_axis_tuser,
		input wire  m00_axis_tready
	);
	
	wire  sync_response_received;
	wire  sync_responce_received;
    wire  sync_response_trigger;
    wire  initiate_sync_request;
    wire  responce_received;
    wire sync_request_received;
    wire sync_done;
    wire sync_responded;
    
    wire sync_reset;
    
    wire [TC_COUNT_WIDTH-1 : 0] round_path_delay;
    wire [C_S_AXIS_TDATA_WIDTH-1 : 0] sync_request_magic_byte;
    wire [C_S_AXIS_TDATA_WIDTH-1 : 0] sync_response_magic_byte;
    wire [15:0] cfg_time_sync_payload_length;
    
    assign m_time_sync_payload_length = cfg_time_sync_payload_length;
    assign initiate_sync_request_out = initiate_sync_request;
    
    assign sync_done_out = sync_done;
	
// Instantiation of Axi Bus Interface S00_AXI
	time_sync_v1_0_S00_AXI # ( 
	   .DELAY_COUNT_WIDTH(DELAY_COUNT_WIDTH),	
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) time_sync_v1_0_S00_AXI_inst (
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
		
		.sync_response_magic_byte_out(sync_response_magic_byte),    
        .sync_request_magic_byte_out(sync_request_magic_byte),  
        .round_path_delay_in(round_path_delay), 
        .sync_done_in(sync_done),
        .sync_reset_out(sync_reset),
        .cfg_time_sync_payload_length(cfg_time_sync_payload_length),
		.initiate_sync_request_out(initiate_sync_request)
	);

// Instantiation of Axi Bus Interface S00_AXIS
	time_sync_v1_0_S00_AXIS # ( 
		.C_S_AXIS_TDATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
		.MIN_UDP_PKT_SIZE(MIN_UDP_PKT_SIZE)
	) time_sync_v1_0_S00_AXIS_inst (
		.S_AXIS_ACLK(s00_axis_aclk),
		.S_AXIS_ARESETN(s00_axis_aresetn & (~sync_reset)),
		.S_AXIS_TREADY(s00_axis_tready),
		.S_AXIS_TDATA(s00_axis_tdata),
//		.S_AXIS_TSTRB(s00_axis_tstrb),
		.S_AXIS_TLAST(s00_axis_tlast),
		.S_AXIS_TVALID(s00_axis_tvalid),
		
		
		.tc_count_in(tc_count_in),
		.sync_done_out(sync_done),
		.sync_responded_in(sync_responded),
		.initiate_sync_request(initiate_sync_request),
		.s_hdr_ready(s_hdr_ready),
//        .tc_count_out(tc_count_out),
        .tc_count_adjusted_out(tc_count_adjusted_out),
        .sync_request_magic_byte(sync_request_magic_byte), 
        .sync_response_magic_byte(sync_response_magic_byte),      
        .sync_response_received(sync_response_received),
        .sync_request_received(sync_request_received),
        .sync_response_trigger(sync_response_trigger),
        .round_path_delay_out(round_path_delay)
	);

// Instantiation of Axi Bus Interface M00_AXIS
	time_sync_v1_0_M00_AXIS # ( 
		.C_M_AXIS_TDATA_WIDTH(C_M00_AXIS_TDATA_WIDTH),
		.TC_COUNT_WIDTH(TC_COUNT_WIDTH),
		.SHIFTS_PER_MILLISECOND(SHIFTS_PER_MILLISECOND),
		.DELAY_COUNT_WIDTH(DELAY_COUNT_WIDTH),
		.MIN_UDP_PKT_SIZE(MIN_UDP_PKT_SIZE)
	) time_sync_v1_0_M00_AXIS_inst (
		.M_AXIS_ACLK(m00_axis_aclk),
		.M_AXIS_ARESETN(m00_axis_aresetn & (~sync_reset)),
		.M_AXIS_TVALID(m00_axis_tvalid),
		.M_AXIS_TDATA(m00_axis_tdata),
//		.M_AXIS_TSTRB(m00_axis_tstrb),
		.M_AXIS_TLAST(m00_axis_tlast),
		.M_AXIS_TUSER(m00_axis_tuser),
		.M_AXIS_TREADY(m00_axis_tready),
		
		.initiate_sync_request(initiate_sync_request),
        .sync_response_trigger(sync_response_trigger),
        .sync_response_magic_byte(sync_response_magic_byte),    
        .sync_request_magic_byte(sync_request_magic_byte),    
        .tc_count_in(tc_count_in),
        .tc_start_out(tc_start_out),
        .sync_done_in(sync_done),
        .sync_responded_out(sync_responded),
        .m_time_sync_payload_length(cfg_time_sync_payload_length),
        .m_hdr_valid(m_hdr_valid)  
	);

	// Add user logic here

	// User logic ends

	endmodule
