
`timescale 1 ns / 1 ps

	module user_org_plc_seq_ip_v1_0_fm_udp_s_axis #
	(
		// Users to add parameters here
        parameter integer RTP_HDR_DATA_WIDTH	= 8*20,
        parameter integer RTP_HDR_BCNT_WIDTH	= 5, // 20 bytes
        parameter integer RTP_HDR_SEQ_WIDTH	= 16,
//        parameter integer PKT_DROP_SEQ_WIDTH	= 6,
	    parameter integer SHIFTS_PER_MILLISECOND = 17,
	    parameter integer DELAY_COUNT_WIDTH = 64,
	    parameter integer FIFO_ADDR_WIDTH = 4,
        parameter S_COUNT = 16,
        parameter SYNC_COUNT_WIDTH = 32,
        parameter PACKET_LEN_WIDTH = 16,
        parameter SEQ_BANK_FIFO_ADDR_WIDTH = 11,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_AXIS_TDATA_WIDTH	= 8,
		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 8,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer C_M_START_COUNT	= 32
	)
	(
		// Users to add ports here
        input  wire       clk,
   
        input  wire       rst,
		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output wire  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Byte qualifier
//		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// Indicates boundary of last packet
		input wire  S_AXIS_TLAST,
		// Data is in valid
		input wire  S_AXIS_TVALID,
		
		
		// Global ports to audio
		input wire  M_AXIS_ACLK,
		// 
		input wire  M_AXIS_ARESETN,
		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		output wire  M_AXIS_TVALID,
		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
//		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
		// TLAST indicates the boundary of a packet.
		output wire  M_AXIS_TLAST,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY,
		
		input wire  new_sample_in,
		input wire  [S_COUNT-1:0] cfg_tlast_count_to_drop_in,// now ms
		input wire [SYNC_COUNT_WIDTH-1:0] cfg_pkt_wait_delay_count_in,
		input wire [DELAY_COUNT_WIDTH-1:0] cfg_pkt_send_delay_count_in,
		input wire [DELAY_COUNT_WIDTH-1:0] cfg_replace_wait_delay_count_in,
		input wire  [$clog2(S_COUNT)-1:0] cfg_seq_reset,
		input wire cfg_seq_rx_reset,
		input wire cfg_seq_disable,
		input wire cfg_pkt_wait_disable,
		input wire cfg_pkt_send_delay_disable,
		
		input  wire [FIFO_ADDR_WIDTH -1: 0] fifo_occ_in,
		input wire play_out_ready_in,
		input wire replace_pkt_in,
		
		output wire  new_pkt_ready_out,
		    input wire replace_pkt_end_in,
		
		input wire [FIFO_ADDR_WIDTH -1: 0] cfg_fifo_occ_lim,
		input wire [PACKET_LEN_WIDTH-1:0] cfg_pkt_payload_size,
		output wire [C_S_AXI_DATA_WIDTH-1:0] dropped_pkt_counter,
		output wire [C_S_AXI_DATA_WIDTH-1:0] replaced_pkt_counter,
		
		output wire [3:0] in_exec_state_out, 
	   output wire [3:0] out_exec_state_out,
	   
	   output wire replace_inprogress_out,
	   
	   input wire tsync_in,
        input wire  sync_en_in,
		
		output  wire       status1_out,
        output  wire       status2_out
        
	);
	// function called clogb2 that returns an integer which has the 
	// value of the ceiling of the log base 2.
	function integer clogb2 (input integer bit_depth);
	  begin
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
	      bit_depth = bit_depth >> 1;
	  end
	endfunction
	
	parameter PKT_DROP_SEQ_WIDTH = $clog2(S_COUNT) + 1;

	// Total number of input data.
//	localparam NUMBER_OF_INPUT_WORDS  = 8;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
//	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [3:0] IN_IDLE =     4'b0001,        // This is the initial/idle state 
                    GET_HDR =     4'b0010,        // 
                    DMUX_PKT =    4'b0011,
                    WRITE_HDR0 =  4'b0100,
                    WRITE_HDR1 =  4'b0101,
                     DROP_PKT  =  4'b0110,
	                WRITE_FIFO  = 4'b0111; // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
	                                    
	parameter [3:0] OUT_IDLE =    4'b1000,
	                CHECK_OCC =   4'b1001,        // 
                    SEL_FIFO =    4'b1010,
	                SEND_DATA  =  4'b1011,
	                EXTRACT_HDR = 4'b1100,   
	                REPLACE_PKT = 4'b1101;                                   
	                                    
//	wire  	s_axis_tready_dmux;
//	reg  	s_axis_tready_dmux_reg;
	
	wire  	s_axis_tready_local;
	reg  	s_axis_tready_local_reg;
	
	wire  	s_axis_tvalid_local;
	reg  	s_axis_tvalid_local_reg;
	
	wire  	m_axis_tvalid_local;
	reg  	m_axis_tvalid_local_reg;
	
	
	wire  	m_axis_tlast_local;
	reg  	m_axis_tlast_local_reg;
	
	wire m_axis_tready_local;
	reg m_axis_tready_local_reg;
	
	
	
	reg       status1_out_reg;
    reg       status2_out_reg;
	
	// State variable
//	wire [2:0] in_exec_state; 
//	wire [2:0] out_exec_state;  
	
	reg [3:0] in_exec_state; 
	reg [3:0] out_exec_state; 
	

	// FIFO implementation signals
//	genvar byte_index;     
	// FIFO write enable
//	wire fifo_wren;
	// FIFO full flag
//	reg fifo_full_flag;
	// FIFO write pointer
//	reg [bit_num-1:0] write_pointer;
	// sink has accepted all the streaming data and stored in FIFO
//	  reg writes_done;

    reg [C_S_AXIS_TDATA_WIDTH-1:0] out_rtp_hdr_b0;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] out_rtp_hdr_b1;
	  
	  wire [RTP_HDR_DATA_WIDTH-1:0] rtp_header;
	  
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b0;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b1;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b2;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b3;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b4;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b5;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b6;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b7;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b8;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b9;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b10;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b11;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b12;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b13;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b14;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b15;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b16;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b17;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b18;
	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b19;
	  
	  
	  reg [RTP_HDR_BCNT_WIDTH-1:0] hdr_byte_cnt_reg;
	  wire [RTP_HDR_BCNT_WIDTH-1:0] hdr_byte_cnt;
	  
	  reg [RTP_HDR_BCNT_WIDTH-1:0] out_hdr_byte_cnt_reg;
	  wire [RTP_HDR_BCNT_WIDTH-1:0] out_hdr_byte_cnt;
	  
	  reg [PACKET_LEN_WIDTH-1:0] out_data_byte_cnt_reg;
	  wire [PACKET_LEN_WIDTH-1:0] out_data_byte_cnt;
	  
	  wire [RTP_HDR_SEQ_WIDTH-1:0] curr_hdr_seq_num;
	  wire [RTP_HDR_SEQ_WIDTH-1:0] out_curr_hdr_seq_num;
	   wire [RTP_HDR_SEQ_WIDTH-1:0] next_out_curr_hdr_seq_num;
	  reg [RTP_HDR_SEQ_WIDTH-1:0] out_curr_hdr_seq_num_reg;
	  
	  reg [C_S_AXI_DATA_WIDTH-1:0] dropped_pkt_counter_sig_reg;
	  wire [C_S_AXI_DATA_WIDTH-1:0] dropped_pkt_counter_sig;
        assign dropped_pkt_counter = dropped_pkt_counter_sig_reg;
        assign dropped_pkt_counter_sig = dropped_pkt_counter_sig_reg;
        
        
        reg [C_S_AXI_DATA_WIDTH-1:0] replaced_pkt_counter_sig_reg;
        wire [C_S_AXI_DATA_WIDTH-1:0] replaced_pkt_counter_sig;
        
	  //wire [RTP_HDR_SEQ_WIDTH-1:0] prev_hdr_seq_num;
	  //reg [RTP_HDR_SEQ_WIDTH-1:0] prev_hdr_seq_num_reg;

	  



wire                          enable_dmux;
reg                          enable_dmux_reg;

wire                          drop_dmux;
reg                          drop_dmux_reg;

wire [$clog2(S_COUNT)-1:0]    select_dmux, missing_packets;
reg [$clog2(S_COUNT)-1:0]    select_dmux_reg, missing_packets_reg;

wire                          enable_mux;
reg                          enable_mux_reg;


reg [$clog2(S_COUNT)-1:0]    select_mux_reg;
wire [$clog2(S_COUNT)-1:0]    select_mux;




reg [$clog2(S_COUNT)-1:0]    s_axis_tlast_count_reg;
wire [$clog2(S_COUNT)-1:0]    s_axis_tlast_count;


reg [S_COUNT-1:0]    fifo_slot_filled_reg;
wire [S_COUNT-1:0]   fifo_slot_filled;

reg [S_COUNT-1:0]    fifo_slot_processed_reg;
wire [S_COUNT-1:0]   fifo_slot_processed;

reg [S_COUNT-1:0]    fifo_slot_reset_reg;
wire [S_COUNT-1:0]   fifo_slot_reset;

assign fifo_slot_reset = fifo_slot_reset_reg;

wire [DELAY_COUNT_WIDTH-1:0] send_data_delay_count = cfg_tlast_count_to_drop_in << SHIFTS_PER_MILLISECOND;
reg [DELAY_COUNT_WIDTH-1:0] send_data_delay_accum_reg;
wire [DELAY_COUNT_WIDTH-1:0] send_data_delay_accum;
wire send_data_timeup;

reg [SYNC_COUNT_WIDTH-1:0] sync_tc_reg;
wire [SYNC_COUNT_WIDTH-1:0] sync_tc;

assign sync_tc = sync_tc_reg;


wire [DELAY_COUNT_WIDTH-1:0] idle_delay_count = cfg_tlast_count_to_drop_in << SHIFTS_PER_MILLISECOND;
reg [DELAY_COUNT_WIDTH-1:0] idle_delay_accum_reg;
wire [DELAY_COUNT_WIDTH-1:0] idle_delay_accum;



wire [DELAY_COUNT_WIDTH-1:0] write_delay_count = cfg_tlast_count_to_drop_in << (SHIFTS_PER_MILLISECOND);
reg [DELAY_COUNT_WIDTH-1:0] write_delay_accum_reg;
wire [DELAY_COUNT_WIDTH-1:0] write_delay_accum;

//initial idle_delay_accum_reg = 64'hFFFF_FFFF_FFFF_FFFF;
//initial send_data_delay_accum_reg = 64'hFFFF_FFFF_FFFF_FFFF;

reg [SYNC_COUNT_WIDTH-1:0] pkt_wait_delay_reg;
wire [SYNC_COUNT_WIDTH-1:0] pkt_wait_delay;

reg [DELAY_COUNT_WIDTH-1:0] pkt_send_delay_reg;
wire [DELAY_COUNT_WIDTH-1:0] pkt_send_delay;

wire idle_timeup;
wire write_timeup;
wire pkt_wait_timeup;
wire pkt_send_timeup;

reg just_after_reset_reg;
wire just_after_reset;

reg update_mux_sel_reg;
wire update_mux_sel;

reg tsync_reg;
wire tsync_125;

wire check_replace_timeup;

wire [DELAY_COUNT_WIDTH-1:0] replace_wait_delay;
reg [DELAY_COUNT_WIDTH-1:0] replace_wait_delay_reg;


wire [SYNC_COUNT_WIDTH-1:0] next_pkt_sync_boundary;
reg [SYNC_COUNT_WIDTH-1:0] next_pkt_sync_boundary_reg;

assign next_pkt_sync_boundary = next_pkt_sync_boundary_reg;

wire [(2**PKT_DROP_SEQ_WIDTH)-1:0] has_been_replaced;
reg [(2**PKT_DROP_SEQ_WIDTH)-1:0] has_been_replaced_reg;

wire [(2**PKT_DROP_SEQ_WIDTH)-1:0] has_been_dropped;
reg [(2**PKT_DROP_SEQ_WIDTH)-1:0] has_been_dropped_reg;

//wire [(PKT_DROP_SEQ_WIDTH*RTP_HDR_SEQ_WIDTH)-1:0] has_been_replaced;
//reg [(PKT_DROP_SEQ_WIDTH*RTP_HDR_SEQ_WIDTH)-1:0] has_been_replaced_reg;

//wire [(2**RTP_HDR_SEQ_WIDTH-1)-1:0] has_been_dropped;
//reg [(2**RTP_HDR_SEQ_WIDTH-1)-1:0] has_been_dropped_reg;



//assign has_been_dropped = has_been_dropped_reg;

wire [S_COUNT*C_S_AXIS_TDATA_WIDTH-1:0] from_dmux_ch1_fifo_axis_tdata;
wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tvalid;
wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tready;
wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tlast;
wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tuser;


wire [S_COUNT*C_S_AXIS_TDATA_WIDTH-1:0]  to_mux_ch1_fifo_axis_tdata;
wire [S_COUNT-1:0] to_mux_ch1_fifo_axis_tvalid;
wire [S_COUNT-1:0] to_mux_ch1_fifo_axis_tready;
wire [S_COUNT-1:0] to_mux_ch1_fifo_axis_tlast;
wire [S_COUNT-1:0] to_mux_ch1_fifo_axis_tuser;




wire [C_S_AXIS_TDATA_WIDTH-1:0]  from_mux_ch_fifo_axis_tdata;
wire from_mux_ch_fifo_axis_tvalid;
wire from_mux_ch_fifo_axis_tready;
wire from_mux_ch_fifo_axis_tlast;
wire from_mux_ch_fifo_axis_tuser;



wire [C_S_AXIS_TDATA_WIDTH-1:0]  to_dmux_ch_fifo_axis_tdata;
wire to_dmux_ch_fifo_axis_tvalid;
wire to_dmux_ch_fifo_axis_tready;
wire to_dmux_ch_fifo_axis_tlast;
wire to_dmux_ch_fifo_axis_tuser;

wire [PKT_DROP_SEQ_WIDTH-1:0] curr_seq_num_processed;
wire [PKT_DROP_SEQ_WIDTH-1:0] out_curr_seq_num_processed;
wire [PKT_DROP_SEQ_WIDTH-1:0] replaced_pkt_index;
wire which_half_is_seq;

wire replace_pkt;
wire sync_replace_pkt;
wire drop_this_pkt;
wire in_good_state;

//wire replace_inprogress_out;
reg replace_inprogress_reg;
reg new_pkt_ready_reg;


assign new_pkt_ready_out = new_pkt_ready_reg;

assign replace_inprogress_out = replace_inprogress_reg;


assign has_been_replaced = has_been_replaced_reg;
assign has_been_dropped = has_been_dropped_reg;

assign replaced_pkt_counter = replaced_pkt_counter_sig_reg;
assign replaced_pkt_counter_sig = replaced_pkt_counter_sig_reg;

//assign in_exec_state = in_exec_state;
//assign out_exec_state = out_exec_state;



assign out_data_byte_cnt = out_data_byte_cnt_reg;
assign out_hdr_byte_cnt = out_hdr_byte_cnt_reg;


assign in_exec_state_out = in_exec_state;
assign out_exec_state_out = out_exec_state;


assign s_axis_tlast_count = s_axis_tlast_count_reg;

assign select_dmux = select_dmux_reg;

assign drop_dmux = drop_dmux_reg;

assign select_mux = select_mux_reg;




//assign curr_hdr_seq_num = curr_hdr_seq_num_reg;
assign s_axis_tready_local = s_axis_tready_local_reg;
assign s_axis_tvalid_local = s_axis_tvalid_local_reg;
assign m_axis_tvalid_local = m_axis_tvalid_local_reg;
assign m_axis_tready_local = m_axis_tready_local_reg;
assign m_axis_tlast_local = m_axis_tlast_local_reg;
	  
assign fifo_slot_filled = fifo_slot_filled_reg;
assign fifo_slot_processed = fifo_slot_processed_reg;

assign status1_out = status1_out_reg;
assign status2_out = status2_out_reg;

assign hdr_byte_cnt = hdr_byte_cnt_reg; 

// I/O Connections assignments
assign rtp_header = {rtp_hdr_b0, rtp_hdr_b2, rtp_hdr_b3,
                        rtp_hdr_b4, rtp_hdr_b5, rtp_hdr_b6, 
                        rtp_hdr_b7, rtp_hdr_b8, rtp_hdr_b9,
                        rtp_hdr_b10, rtp_hdr_b11, rtp_hdr_b12,
                        rtp_hdr_b13, rtp_hdr_b14, rtp_hdr_b15,
                        rtp_hdr_b16, rtp_hdr_b17, rtp_hdr_b18,
                        rtp_hdr_b19};	
                        
assign curr_hdr_seq_num = {rtp_hdr_b1, rtp_hdr_b0};  
//assign out_curr_hdr_seq_num = {out_rtp_hdr_b1, out_rtp_hdr_b0};   
assign out_curr_hdr_seq_num = out_curr_hdr_seq_num_reg;              
                            


assign next_out_curr_hdr_seq_num = out_curr_hdr_seq_num + 1;

assign curr_seq_num_processed = curr_hdr_seq_num[PKT_DROP_SEQ_WIDTH-1:0];
assign out_curr_seq_num_processed = out_curr_hdr_seq_num[PKT_DROP_SEQ_WIDTH-1:0];
assign replaced_pkt_index = next_out_curr_hdr_seq_num[PKT_DROP_SEQ_WIDTH-1:0];

assign drop_this_pkt = cfg_seq_disable ? 0 :((has_been_replaced[curr_seq_num_processed] == 1) ? 1 : 0);


assign which_half_is_seq = (out_curr_seq_num_processed < (((2**PKT_DROP_SEQ_WIDTH))/2)) ? 1 :0;

//assign replace_pkt = ((play_out_ready_in==1)&&(fifo_occ_in <  cfg_fifo_occ_lim)) ? 1 : 0;
assign sync_replace_pkt = ((sync_en_in == 1) && (sync_tc > next_pkt_sync_boundary) && (cfg_pkt_wait_delay_count_in > 0)) ? 1: 0;

assign replace_pkt = cfg_seq_disable ? 0 :(replace_pkt_in);
//assign in_good_state = ((in_exec_state == IDLE)||(in_exec_state > DMUX_PKT)) ? 1 : 0;
//assign in_good_state = ((in_exec_state == IDLE)||(in_exec_state == WRITE_HDR0)||(in_exec_state == WRITE_HDR1)||(in_exec_state == DROP_PKT)||(in_exec_state == WRITE_FIFO)) ? 1 : 0;
assign in_good_state = ((in_exec_state == IN_IDLE) ? 1 : 0);


assign enable_mux = cfg_seq_disable ? 0 : enable_mux_reg;
assign enable_dmux = cfg_seq_disable ? 0 : enable_dmux_reg;



assign replace_wait_delay = replace_wait_delay_reg;
assign update_mux_sel = update_mux_sel_reg;

assign just_after_reset = just_after_reset_reg;
assign send_data_delay_accum = send_data_delay_accum_reg;
assign idle_delay_accum = idle_delay_accum_reg;
assign write_delay_accum = write_delay_accum_reg;
assign pkt_wait_delay = pkt_wait_delay_reg;
assign pkt_send_delay = pkt_send_delay_reg;

assign idle_timeup = (idle_delay_accum >= idle_delay_count ) ? 1 : 0;
//assign write_timeup = (write_delay_accum >= write_delay_count ) ? 1 : 0; bad cause pkt corruption
assign write_timeup = 0;
assign pkt_wait_timeup = ((pkt_wait_delay >= cfg_pkt_wait_delay_count_in) && (cfg_pkt_wait_disable==0)) ? 1 : 0;

assign check_replace_timeup = ((replace_wait_delay >= cfg_replace_wait_delay_count_in)) ? 1 : 0;
assign pkt_send_timeup = ((pkt_send_delay >= cfg_pkt_send_delay_count_in) && (cfg_pkt_send_delay_disable==0))?1:0;
assign send_data_timeup = (send_data_delay_accum >= send_data_delay_count) ? 1 : 0;



assign to_dmux_ch_fifo_axis_tdata = cfg_seq_disable ?  0 : ((in_exec_state == WRITE_HDR0) ? rtp_hdr_b0 : ((in_exec_state == WRITE_HDR1) ? rtp_hdr_b1:S_AXIS_TDATA));
assign to_dmux_ch_fifo_axis_tvalid = cfg_seq_disable ? 0 : ((in_exec_state == WRITE_FIFO) ? S_AXIS_TVALID : (in_exec_state==DROP_PKT) ? 0 : s_axis_tvalid_local);
assign to_dmux_ch_fifo_axis_tlast = cfg_seq_disable ?  0 : (in_exec_state == WRITE_FIFO) ? S_AXIS_TLAST:0;





//assign M_AXIS_TDATA = cfg_seq_disable ?  (in_exec_state == WRITE_HDR0 ? rtp_hdr_b0 : (in_exec_state == WRITE_HDR1 ? rtp_hdr_b1:S_AXIS_TDATA)) : (in_exec_state == WRITE_HDR0 ? rtp_hdr_b0 : (in_exec_state == WRITE_HDR1 ? rtp_hdr_b1:from_mux_ch_fifo_axis_tdata));
assign M_AXIS_TDATA = cfg_seq_disable ?  ((in_exec_state == GET_HDR || in_exec_state == WRITE_FIFO) ? S_AXIS_TDATA : 0)                    : ((out_exec_state == REPLACE_PKT) ? 0 : from_mux_ch_fifo_axis_tdata);
assign M_AXIS_TVALID =  cfg_seq_disable ?  ((in_exec_state == GET_HDR || in_exec_state == WRITE_FIFO) ? S_AXIS_TVALID : 0)                 : ((out_exec_state == EXTRACT_HDR || out_exec_state == SEND_DATA) ? from_mux_ch_fifo_axis_tvalid : m_axis_tvalid_local);
assign M_AXIS_TLAST =  cfg_seq_disable ?  ((in_exec_state == WRITE_FIFO) ? S_AXIS_TLAST : 0)                   : ((out_exec_state == EXTRACT_HDR || out_exec_state == SEND_DATA)? from_mux_ch_fifo_axis_tlast :m_axis_tlast_local);
//assign S_AXIS_TREADY = cfg_seq_disable ? (in_exec_state == WRITE_FIFO ? M_AXIS_TREADY : s_axis_tready_local) :(((in_exec_state == GET_HDR)||(in_exec_state == WRITE_HDR0)||(in_exec_state == WRITE_HDR1)||(in_exec_state == DROP_PKT)) ? s_axis_tready_local : to_dmux_ch_fifo_axis_tready);
assign S_AXIS_TREADY = cfg_seq_disable ? ((in_exec_state == GET_HDR) || in_exec_state == WRITE_FIFO ? M_AXIS_TREADY : s_axis_tready_local)   : ((in_exec_state == WRITE_FIFO) ? to_dmux_ch_fifo_axis_tready : s_axis_tready_local);
//assign S_AXIS_TREADY = cfg_seq_disable ? (in_exec_state == WRITE_FIFO ? M_AXIS_TREADY : s_axis_tready_local) :s_axis_tready_local;

//assign S_AXIS_TREADY = cfg_seq_disable ? (in_exec_state == WRITE_FIFO ? M_AXIS_TREADY : s_axis_tready_local) : s_axis_tready_local || to_dmux_ch_fifo_axis_tready;



assign from_mux_ch_fifo_axis_tready = cfg_seq_disable ?  0 : ((out_exec_state == EXTRACT_HDR || out_exec_state == SEND_DATA) ? M_AXIS_TREADY:m_axis_tready_local);


	
	
		// Control tx to audio state machine implementation
	always @(posedge M_AXIS_ACLK) 
	begin  
	  if (rst) 
	  // Synchronous reset (active low)
	    begin
	      out_exec_state <= OUT_IDLE;
	      enable_mux_reg <= 0;
	      fifo_slot_processed_reg <= 0;
	      s_axis_tlast_count_reg <= 0;
	      select_mux_reg <= 0;
	      new_pkt_ready_reg <= 0;
	      
          out_data_byte_cnt_reg <= 0;
          out_hdr_byte_cnt_reg <= 0;
          
           m_axis_tvalid_local_reg <= 0;
           m_axis_tlast_local_reg <= 0;
           m_axis_tready_local_reg <= 0;
           
           pkt_wait_delay_reg <= 0;
	       pkt_send_delay_reg <= 0;
           send_data_delay_accum_reg <= 0;
	       idle_delay_accum_reg <= 0;
	        
	       replace_wait_delay_reg <= 0;
	       replace_inprogress_reg <=0;
           replaced_pkt_counter_sig_reg <= 0;
           
	       m_axis_tready_local_reg <= 0;
	       has_been_replaced_reg <= 0;
	       next_pkt_sync_boundary_reg <= cfg_pkt_wait_delay_count_in;
	       out_curr_hdr_seq_num_reg <= 0;
	    end  
	  else
//	   if(cfg_seq_disable == 0) begin

            case (out_exec_state)
            
            OUT_IDLE:begin
            new_pkt_ready_reg <= 0;
                       status1_out_reg <= 0;
               enable_mux_reg <= 0;
               m_axis_tlast_local_reg <= 0; 
               m_axis_tvalid_local_reg <= 0;
               m_axis_tready_local_reg <= 0;
               replace_inprogress_reg <= replace_inprogress_reg;
               if(just_after_reset == 0)   begin 
                    idle_delay_accum_reg <= idle_delay_accum + 1;
//                    pkt_wait_delay_reg <= pkt_wait_delay + 1;
              end 
               
               if((cfg_seq_disable==0) && (fifo_slot_filled[select_mux] == 1))begin
//                       out_exec_state_reg <= SEND_DATA;
                     out_exec_state <= SEL_FIFO;
                     fifo_slot_processed_reg[select_mux] <= 1;
                     idle_delay_accum_reg <= 0;
                     replace_wait_delay_reg <= 0;
                     pkt_wait_delay_reg <= 0;
                     m_axis_tready_local_reg <= 0;   
                       m_axis_tvalid_local_reg <= 0;
                     next_pkt_sync_boundary_reg <= next_pkt_sync_boundary + cfg_pkt_wait_delay_count_in;
                     
               end
               else begin                   
                    
//                    if(((sync_replace_pkt == 1) || (replace_pkt == 1)) && (just_after_reset == 0)) begin  
                    if(((replace_pkt == 1)) && (just_after_reset == 0)) begin                           
                       
                       replace_wait_delay_reg <= replace_wait_delay + 1;
                       //if(check_replace_timeup && in_good_state) begin
                       if(check_replace_timeup) begin
//                                if(check_replace_timeup) begin not safe
                            out_exec_state <= REPLACE_PKT;
                            next_pkt_sync_boundary_reg <= next_pkt_sync_boundary + cfg_pkt_wait_delay_count_in;
                            replace_wait_delay_reg <= 0;
                            idle_delay_accum_reg <= 0;
                            pkt_wait_delay_reg <= 0;
                            m_axis_tvalid_local_reg <= 0;
//                            out_curr_hdr_seq_num_reg <= out_curr_hdr_seq_num + 1;
                            has_been_replaced_reg[replaced_pkt_index] <= 1; 
                            
                            if(which_half_is_seq == 1) begin
                                has_been_replaced_reg[replaced_pkt_index+(((2**PKT_DROP_SEQ_WIDTH))/2)] <= 0; //Clear packets marked for dropping a long time ago
                            end
                            else begin
                                has_been_replaced_reg[replaced_pkt_index-(((2**PKT_DROP_SEQ_WIDTH))/2)] <= 0; //Clear packets marked for dropping a long time ago
                            end
                            
                        end
                       
                    end 
                    else if(just_after_reset == 0) begin
                        replace_wait_delay_reg <= 0;   
                        
                        if((idle_timeup) || (pkt_wait_timeup))begin
                           select_mux_reg <= select_mux + 1;
                           idle_delay_accum_reg <= 0;
                           pkt_wait_delay_reg <= 0;
                        end 
                                             
                   end
                        
                //only at reset
                if(update_mux_sel==1) begin
                    select_mux_reg <= curr_hdr_seq_num[$clog2(S_COUNT)-1:0];
                    out_curr_hdr_seq_num_reg <= curr_hdr_seq_num;
                end
                
                end
               
           end
           SEL_FIFO:begin
    //	           select_mux_reg <= select_mux + 1;
                   status1_out_reg <= 0;
                   out_hdr_byte_cnt_reg <= 0;
                   m_axis_tvalid_local_reg <= 0;
                   replace_inprogress_reg <= replace_inprogress_reg;
//	               if((fifo_slot_filled[select_mux] == 0)&& (from_mux_ch_fifo_axis_tlast == 0)) begin
	               if(fifo_slot_filled[select_mux] == 0) begin
                       //out_exec_state <= EXTRACT_HDR;
                       out_exec_state <= SEND_DATA; 
                       enable_mux_reg <= 1;		               
                       m_axis_tready_local_reg <= 0;   
                       m_axis_tvalid_local_reg <= 0;;                    
                       fifo_slot_processed_reg[select_mux] <= 0;
                    end	                   
                   
                   
                   end
		     EXTRACT_HDR: begin
		              m_axis_tready_local_reg <= 1;
		              m_axis_tvalid_local_reg <= 0;
		              replace_inprogress_reg <= replace_inprogress_reg;
                    if (from_mux_ch_fifo_axis_tvalid)
                    begin
                    
                       if (out_hdr_byte_cnt == 0) begin
                            m_axis_tvalid_local_reg <= 0;
                           out_rtp_hdr_b0 <= from_mux_ch_fifo_axis_tdata;
                           out_hdr_byte_cnt_reg <= out_hdr_byte_cnt + 1;
                           out_exec_state <= EXTRACT_HDR;
                       end else if(out_hdr_byte_cnt == 1) begin                       
                           out_rtp_hdr_b1 <= from_mux_ch_fifo_axis_tdata;
                           out_hdr_byte_cnt_reg <= out_hdr_byte_cnt + 1;
                           out_exec_state <= SEND_DATA; 
                           m_axis_tvalid_local_reg <= 0;
                           m_axis_tready_local_reg <=0;
                        end
	               end 
               
               end
           SEND_DATA: begin
                m_axis_tvalid_local_reg <= 0;
                m_axis_tready_local_reg <=0;
                new_pkt_ready_reg <= 1;
                
                if (out_hdr_byte_cnt == 0) begin
                    m_axis_tvalid_local_reg <= 0;
                   out_rtp_hdr_b0 <= from_mux_ch_fifo_axis_tdata;
                   out_exec_state <= SEND_DATA;
                   if (from_mux_ch_fifo_axis_tvalid && from_mux_ch_fifo_axis_tready)
                        out_hdr_byte_cnt_reg <= out_hdr_byte_cnt + 1;
               end else if(out_hdr_byte_cnt == 1) begin                       
                   out_rtp_hdr_b1 <= from_mux_ch_fifo_axis_tdata;
                   if (from_mux_ch_fifo_axis_tvalid && from_mux_ch_fifo_axis_tready)
                        out_hdr_byte_cnt_reg <= out_hdr_byte_cnt + 1;
                   out_exec_state <= SEND_DATA; 
                   m_axis_tvalid_local_reg <= 0;
                   m_axis_tready_local_reg <=0;
                end else begin                
    
                    out_curr_hdr_seq_num_reg <= {out_rtp_hdr_b1, out_rtp_hdr_b0};
                    
                    if (from_mux_ch_fifo_axis_tlast == 1)
                      begin
                        out_exec_state <= OUT_IDLE;
                        fifo_slot_processed_reg[select_mux] <= 0;
                        status1_out_reg <= 0;
                        out_data_byte_cnt_reg <= 0;  
			             replace_inprogress_reg <=0;   // fixes ovelap requirement                  
                        //s_axis_tlast_count_reg <= 0;
                        select_mux_reg <= select_mux + 1;
                        enable_mux_reg <= 0;
                        if(which_half_is_seq == 1) begin
                            has_been_replaced_reg[out_curr_seq_num_processed+(((2**PKT_DROP_SEQ_WIDTH))/2)] = 0; //Clear packets marked for dropping a long time ago
                        end
                        else begin
                            has_been_replaced_reg[out_curr_seq_num_processed-(((2**PKT_DROP_SEQ_WIDTH))/2)] = 0; //Clear packets marked for dropping a long time ago
                        end
                        send_data_delay_accum_reg <= 0;
                        pkt_send_delay_reg <= 0;
                        idle_delay_accum_reg <= 0;
                      end
                    else
                      begin
                        // The sink accepts and stores tdata 
                        // into FIFO
                        
                        replace_inprogress_reg <= replace_inprogress_reg;
                        status1_out_reg <= 0;
    //                    send_data_delay_accum_reg <= send_data_delay_accum + 1;
    //                    pkt_send_delay_reg <= pkt_send_delay + 1;
    ////                    if((send_data_timeup == 1) || (pkt_send_timeup == 1))begin
    //                    if(send_data_timeup == 1) begin
    //                       out_exec_state <= OUT_IDLE;
                           
    //                       enable_mux_reg <= 0;
    //                       select_mux_reg <= select_mux + 1;
    //                       send_data_delay_accum_reg <= 0;                       
    //                       idle_delay_accum_reg <= 0;
    //                       pkt_send_delay_reg <= 0;
    //                       //s_axis_tlast_count_reg <= 0;
    //                    end 
     
                    end
                
                end
            end
            
         REPLACE_PKT:begin                
//            out_exec_state <= REPLACE_PKT;
            status1_out_reg <= 1;
            m_axis_tvalid_local_reg <= 0; 
            m_axis_tready_local_reg <= 0;
            enable_mux_reg <= 0;
            replace_inprogress_reg <=1;
           idle_delay_accum_reg <= 0;
           pkt_wait_delay_reg <= 0;
           m_axis_tlast_local_reg <= 0; 
           
            if (M_AXIS_TREADY) begin            
                out_data_byte_cnt_reg <= out_data_byte_cnt + 1;   //use as time measure     
            end
            
            
//            if(out_data_byte_cnt == cfg_pkt_payload_size-2) begin                       
                 
//                  m_axis_tlast_local_reg <= 0; 
//            end
    
            //if(out_data_byte_cnt == cfg_pkt_payload_size-1) begin 
            if(replace_pkt_end_in == 1) begin    
               out_exec_state <= OUT_IDLE; 
               replaced_pkt_counter_sig_reg <=replaced_pkt_counter_sig + 1;
               out_curr_hdr_seq_num_reg <= out_curr_hdr_seq_num + 1;
               
               out_data_byte_cnt_reg <= 0;
               m_axis_tvalid_local_reg <= 0;
               m_axis_tlast_local_reg <= 0; 
               //replace_inprogress_reg <=0;
               select_mux_reg <= select_mux + 1;
            end
            
            
        end
            
         
    
     endcase
    
    if(has_been_dropped[curr_seq_num_processed] == 1) begin
        has_been_replaced_reg[curr_seq_num_processed] = 0;
    end

    if (sync_en_in == 0) begin
        next_pkt_sync_boundary_reg <= cfg_pkt_wait_delay_count_in;
    end
end
	
	
	// Control udp rx state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (rst) 
	  // Synchronous reset (active low)
	    begin
	      enable_dmux_reg <= 0;
	      drop_dmux_reg <= 0;
	      s_axis_tready_local_reg <= 0;
	      s_axis_tvalid_local_reg <= 0;
//	      S_AXIS_TREADY_REG  <= 0;
//	      to_dmux_ch_fifo_axis_tvalid_reg <= 0;
	      in_exec_state <= IN_IDLE;
	      fifo_slot_filled_reg <= 0;
	      hdr_byte_cnt_reg <= 0;
	      select_dmux_reg <= 0;
	      just_after_reset_reg <= 1;
	      write_delay_accum_reg <= 0; 
	      dropped_pkt_counter_sig_reg <= 0;
	      update_mux_sel_reg <= 0;
	      fifo_slot_reset_reg <= 0;
//	      L_AXIS_TVALID_REG <= 0;
//	      L_AXIS_TDATA_REG <= 0;
	      
	    end  
	  else begin
//	  if(cfg_seq_disable == 0) begin
	  
	   case (in_exec_state)
	      IN_IDLE: begin
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	          status2_out_reg <= 0;
//	          if (cfg_seq_disable)
//	            begin
//	               in_exec_state <= WRITE_FIFO;
//	               s_axis_tvalid_local_reg <= 0;
//	            end
//	            else begin
	              in_exec_state <= GET_HDR;
	              s_axis_tready_local_reg <= 1;
	              s_axis_tvalid_local_reg <= 0;
	              //L_AXIS_TVALID_REG <= 0;
	              enable_dmux_reg <= 0;
	              
//	            end

	           
	         
	        end
	      GET_HDR: begin
	       s_axis_tvalid_local_reg <= 0;
	       s_axis_tready_local_reg <= 1;
	       enable_dmux_reg <= 0;
              if (S_AXIS_TVALID == 1)
                    begin
                    
                       if (hdr_byte_cnt == 0) begin                            
                           rtp_hdr_b0 <= S_AXIS_TDATA;
                           hdr_byte_cnt_reg <= 1;
                           s_axis_tready_local_reg <= 1;
                       end else if(hdr_byte_cnt == 1) begin                       
                           rtp_hdr_b1 <= S_AXIS_TDATA;
                           hdr_byte_cnt_reg <= 0;
                           s_axis_tready_local_reg <= 0;                
                            
                            if(just_after_reset == 1) begin
                               update_mux_sel_reg <= 1;                               
                           end
                           just_after_reset_reg <= 0;
                           
                            if (cfg_seq_disable) begin
                                in_exec_state <= WRITE_FIFO;
	                            s_axis_tvalid_local_reg <= 0;                            
                            end
                            else begin
                                in_exec_state <= DMUX_PKT;
                            end
                        end
	           end 
	             
	           
	           end
	      DMUX_PKT:
	      begin
	           
//               if(missing_pkt_reg == 0) begin    
////	               select_dmux_reg <= select_dmux_reg + 1 + (curr_hdr_seq_num - (prev_hdr_seq_num+1));
	               hdr_byte_cnt_reg <= 0;
	               s_axis_tvalid_local_reg <= 0;
//                    if((drop_this_pkt == 1) || (fifo_slot_filled[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] == 1)) begin 
                   if(fifo_slot_filled[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] == 1) begin 
                        fifo_slot_reset_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 1;
                        fifo_slot_filled_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 0;
                        in_exec_state <= DMUX_PKT;
                    end
                    else if(fifo_slot_reset_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] == 1) begin
                            fifo_slot_reset_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 0;
                            in_exec_state <= DMUX_PKT;
                        end 
                    else if(drop_this_pkt == 1) begin 
                        enable_dmux_reg <= 0;                  
                        in_exec_state <= DROP_PKT;
                        s_axis_tready_local_reg <= 1;
                        has_been_dropped_reg[curr_seq_num_processed] = 1;
                        //fifo_slot_filled_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 0;
                    end
                    else begin
                        s_axis_tready_local_reg <= 0;
//                    if(cfg_seq_disable == 0) begin
                        
                        select_dmux_reg <= curr_hdr_seq_num[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
                        fifo_slot_filled_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 1;
//                    end
//                    select_dmux_reg <= rtp_hdr_b0[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
//                    fifo_slot_filled_reg[rtp_hdr_b0[$clog2(S_COUNT)-1:0]] = 1;
		              s_axis_tvalid_local_reg <= 1;
                      in_exec_state <= WRITE_HDR0;
                      enable_dmux_reg <= 1;
                    end
                    
                    
                    

	      end   
	      WRITE_HDR0: begin
	           s_axis_tvalid_local_reg <= 1;
	           enable_dmux_reg <= 1;
               s_axis_tready_local_reg <= 0;//block slave
               status2_out_reg <= 0;
              if(to_dmux_ch_fifo_axis_tready==1) begin
                   in_exec_state <= WRITE_HDR1;                  
               end
	      end   
	      WRITE_HDR1: begin
	           s_axis_tvalid_local_reg <= 1;
	           enable_dmux_reg <= 1;
	           s_axis_tready_local_reg <= 0;//dmux takes over
              if(to_dmux_ch_fifo_axis_tready==1) begin
                   in_exec_state <= WRITE_FIFO;
                   s_axis_tvalid_local_reg <= 0;
                   status2_out_reg <= 0;                  
               end
	      end  
	     
	      
	      DROP_PKT : begin
              enable_dmux_reg <= 0;
              s_axis_tvalid_local_reg <= 0;              
              if (S_AXIS_TLAST == 1)
	          begin
	            in_exec_state <= IN_IDLE;
	            s_axis_tready_local_reg <= 0;
	            status2_out_reg <= 0;
	            dropped_pkt_counter_sig_reg <= dropped_pkt_counter_sig + 1;
	            has_been_dropped_reg[curr_seq_num_processed] = 0;
//	            has_been_dropped_reg[curr_hdr_seq_num] <= 1;//not necessary
	            //L_AXIS_TVALID_REG <=  0;
	          end
	        else
	          begin
	            // The sink accepts and drops tdata 
	            status2_out_reg <= 0;
	            in_exec_state <= DROP_PKT;
	            s_axis_tready_local_reg <= 1;
	            
	            
	          end
	      
	      end 
	      WRITE_FIFO: begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        
	        write_delay_accum_reg <= write_delay_accum + 1;
	        s_axis_tready_local_reg <= 0;
//	        if ((S_AXIS_TLAST == 1) || (write_timeup==1)) // bad causes errrors when eth2dac pauses for a long time due to large poutdly
	        if (S_AXIS_TLAST == 1)
	          begin
	            in_exec_state <= IN_IDLE;
	            enable_dmux_reg <= 0;
	            write_delay_accum_reg <= 0;
	            status2_out_reg <= 0;
	            //L_AXIS_TVALID_REG <=  0;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
	            status2_out_reg <= 0;
	            
	            in_exec_state <= WRITE_FIFO;
	            
//	            s_axis_tready_local_reg <= to_dmux_ch_fifo_axis_tready;
	            
	          end
	          
	          
	          
	          
	         update_mux_sel_reg <= 0;
	          
            end
	    endcase
	    end
	    
//	    if (cfg_seq_disable)
//        begin
//           in_exec_state <= WRITE_FIFO;
//        end
	    
	    if (fifo_slot_processed[select_mux] == 1)begin
             fifo_slot_filled_reg[select_mux] <= 0;
        end
	    
	    
	    
	    
	end
	
	




always @(posedge S_AXIS_ACLK or posedge rst) begin
    if (rst)
        sync_tc_reg <= 0;
    else
        tsync_reg <= tsync_in;
end	

assign tsync_125 = (tsync_in==1) ? (tsync_reg ^ tsync_in) : 0;



always @(posedge S_AXIS_ACLK or posedge rst) begin
    if (rst)
        sync_tc_reg <= 0;
    else begin
        if ((tsync_125 == 1) & (sync_en_in == 1)) begin
            sync_tc_reg <= sync_tc + 1;
           end
           
        if (sync_en_in == 0) begin
            sync_tc_reg <= 0;
        end
   end
end


	// Add user logic here




axis_demux #(
    .M_COUNT (S_COUNT),
    .DATA_WIDTH (C_S_AXIS_TDATA_WIDTH),
    .KEEP_ENABLE (0),
    .KEEP_WIDTH (1),
    .ID_ENABLE (0),
    .ID_WIDTH (1),
    .DEST_ENABLE (0),
    .DEST_WIDTH (1),
    .USER_ENABLE (1),
    .USER_WIDTH (1)
) packet_demux
(
    .clk(clk),
    .rst(rst),
    /*
     * AXI input
     */
    .s_axis_tdata(to_dmux_ch_fifo_axis_tdata),
    .s_axis_tkeep(0),
    .s_axis_tvalid(to_dmux_ch_fifo_axis_tvalid),
    .s_axis_tready(to_dmux_ch_fifo_axis_tready),
    .s_axis_tlast(to_dmux_ch_fifo_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(0),

    /*
     * AXI outputs
     */
    .m_axis_tdata(from_dmux_ch1_fifo_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(from_dmux_ch1_fifo_axis_tvalid),
    .m_axis_tready(from_dmux_ch1_fifo_axis_tready),
    .m_axis_tlast(from_dmux_ch1_fifo_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(from_dmux_ch1_fifo_axis_tuser),

    /*
     * Control
     */
    .enable(enable_dmux),
    .drop(drop_dmux),
    .select(select_dmux)
);

	
axis_mux #(
   .S_COUNT(S_COUNT),
    .DATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
    .KEEP_ENABLE(0),
    .KEEP_WIDTH (1),
    .ID_ENABLE(0),
    .ID_WIDTH(1),
    .DEST_ENABLE(0),
    .DEST_WIDTH(1),
    .USER_ENABLE(1),
    .USER_WIDTH(1)
)
packet_mux(
    .clk(clk),
    .rst(rst),

    /*
     * AXI inputs from the fifo masters
     */
    .s_axis_tdata(to_mux_ch1_fifo_axis_tdata),
    .s_axis_tkeep(0),
    .s_axis_tvalid(to_mux_ch1_fifo_axis_tvalid),
    .s_axis_tready(to_mux_ch1_fifo_axis_tready),
    .s_axis_tlast(to_mux_ch1_fifo_axis_tlast),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(0),

    /*
     * AXI output to audio core ch1
     */
    .m_axis_tdata(from_mux_ch_fifo_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tvalid(from_mux_ch_fifo_axis_tvalid),
    .m_axis_tready(from_mux_ch_fifo_axis_tready),
    .m_axis_tlast(from_mux_ch_fifo_axis_tlast),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(),

    /*
     * Control
     */
    .enable(enable_mux),
    .select(select_mux)  //must be occupied and pointed to
);

	
genvar i;
generate for (i=0; i<S_COUNT; i=i+1) begin:	ch1_fifo_bank
axis_fifo #(
    .ADDR_WIDTH(SEQ_BANK_FIFO_ADDR_WIDTH),
    .DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
    .KEEP_ENABLE(0),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .FRAME_FIFO(0)
) from_dmux_to_mux_payload_fifo (
    .clk(clk),
    .rst(rst || fifo_slot_reset[i]),

    // AXIS input from udp core
    .s_axis_tdata(from_dmux_ch1_fifo_axis_tdata[i*C_S_AXIS_TDATA_WIDTH +: C_S_AXIS_TDATA_WIDTH]),
    .s_axis_tkeep(0),//must default to high in docs but its very bad
    .s_axis_tvalid(from_dmux_ch1_fifo_axis_tvalid[i]),
    .s_axis_tready(from_dmux_ch1_fifo_axis_tready[i]),
    .s_axis_tlast(from_dmux_ch1_fifo_axis_tlast[i]),
    .s_axis_tid(0),
    .s_axis_tdest(0),
    .s_axis_tuser(from_dmux_ch1_fifo_axis_tuser[i]),

    // AXI output to audo core
    .m_axis_tdata(to_mux_ch1_fifo_axis_tdata[i*C_S_AXIS_TDATA_WIDTH +: C_S_AXIS_TDATA_WIDTH]),
    .m_axis_tkeep(),
    .m_axis_tvalid(to_mux_ch1_fifo_axis_tvalid[i]),
    .m_axis_tready(to_mux_ch1_fifo_axis_tready[i]),
    .m_axis_tlast(to_mux_ch1_fifo_axis_tlast[i]),
    .m_axis_tid(),
    .m_axis_tdest(),
    .m_axis_tuser(to_mux_ch1_fifo_axis_tuser[i]),

    // Status
    .status_overflow(),
    .status_bad_frame(),
    .status_good_frame()
);
end
endgenerate
	








endmodule

