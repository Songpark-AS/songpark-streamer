`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2019 03:48:57 PM
// Design Name: 
// Module Name: PLC_FRM_UDP_S_AXIS
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PLC_FRM_UDP_S_AXIS#(
		// Users to add parameters here
        parameter integer RTP_HDR_DATA_WIDTH	= 8*20,
        parameter integer RTP_HDR_BCNT_WIDTH	= 5, // 20 bytes
        parameter integer RTP_HDR_SEQ_WIDTH	= 16,
	    parameter integer SHIFTS_PER_MILLISECOND = 17,
	    parameter integer DELAY_COUNT_WIDTH = 64,
        parameter S_COUNT = 16,
        parameter MAX_FRAME_SIZE = 256,
        parameter integer FIFO_ADDR_WIDTH = 16,
		// User parameters ends
		// Do not modify the parameters beyond this line
        parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// AXI4Stream sink: Data Width
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
        
        input wire  new_sample,
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
		
		
		input wire  [S_COUNT-1:0] cfg_tlast_count_to_drop_in,// now ms
		input wire  cfg_enf_reset,
		input wire cfg_enf_rx_reset,
		input wire cfg_enf_disable,
		input wire cfg_enf_accum_enable,
		input wire cfg_enf_diff_enable,
		input wire cfg_enf_spkt_to_pkt_lock_enable,
		input wire [C_S_AXI_DATA_WIDTH-1:0] cfg_network_base_delay,
		input wire [C_S_AXI_DATA_WIDTH-1:0] cfg_pkt_build_delay,
		input wire [FIFO_ADDR_WIDTH -1: 0] cfg_fifo_occ_lim,
		
		input wire [DELAY_COUNT_WIDTH-1:0] cfg_spkt_to_pkt_delay_limit,
		input wire [DELAY_COUNT_WIDTH-1:0] cfg_spkt_to_pkt_locked_delay_limit,
		input wire  [DELAY_COUNT_WIDTH-1:0] cfg_accum_spkt_to_pkt_delay_limit,
		input wire  [DELAY_COUNT_WIDTH-1:0] cfg_diff_spkt_to_pkt_delay_limit,
		output wire [C_S_AXI_DATA_WIDTH-1:0] dropped_pkt_counter,
		
		output wire  [DELAY_COUNT_WIDTH-1:0] accum_spkt_to_pkt_delay_out,
		output wire [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_delay_out,
		output wire signed [DELAY_COUNT_WIDTH-1:0] diff_spkt_to_pkt_delay_out,
		
		input wire cfg_rx_lock,
		
		input  wire [FIFO_ADDR_WIDTH -1: 0] fifo_occ_in,//this is the value to watch do not worry about the inter packet delays when its close to empty invoke PLC and replace one packet then wait again etc keep track of replaced packets
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

	// Total number of input data.
//	localparam NUMBER_OF_INPUT_WORDS  = 8;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
//	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [2:0] IDLE = 3'b000,        // This is the initial/idle state 
                    GET_HDR = 3'b001,        // 
                    DECIDE_ON_PKT = 3'b010,
                    DROP_PKT = 3'b011,
	                WRITE_PLC = 3'b100,
	                WRITE_FIFO  = 3'b101; // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
	                                    
	parameter [2:0] CHECK_OCC = 3'b001,        // 
                    SEL_FIFO = 3'b010,
	                SEND_DATA  = 3'b011,
			STEAL_CLOCK = 3'b100;                                    
	                                    
//	wire  	s_axis_tready_dmux;
//	reg  	s_axis_tready_dmux_reg;
	
	wire  	s_axis_tready_local;
	reg  	s_axis_tready_local_reg;
	
	reg       status1_out_reg;
    reg       status2_out_reg;
	
	// State variable
	reg [2:0] mst_exec_state; 
	reg [2:0] out_exec_state;  
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
	  
	  wire [RTP_HDR_SEQ_WIDTH-1:0] curr_hdr_seq_num;
	  //reg [RTP_HDR__ENF__WIDTH-1:0] curr_hdr_seq_num_reg;
	  
	  //wire [RTP_HDR__ENF__WIDTH-1:0] prev_hdr_seq_num;
	  //reg [RTP_HDR__ENF__WIDTH-1:0] prev_hdr_seq_num_reg;

	  
	  

	  
	  





//wire                          enable_dmux;
//reg                          enable_dmux_reg;

//wire                          drop_dmux;
//reg                          drop_dmux_reg;

//wire [$clog2(S_COUNT)-1:0]    select_dmux, missing_packets;
//reg [$clog2(S_COUNT)-1:0]    select_dmux_reg, missing_packets_reg;

//wire                          enable_mux;
//reg                          enable_mux_reg;


//reg [$clog2(S_COUNT)-1:0]    select_mux_reg;
//wire [$clog2(S_COUNT)-1:0]    select_mux;




reg [$clog2(S_COUNT)-1:0]    s_axis_tlast_count_reg;
wire [$clog2(S_COUNT)-1:0]    s_axis_tlast_count;


//reg [S_COUNT-1:0]    initial_fifo_pass_reg;
//wire [S_COUNT-1:0]   initial_fifo_pass;

reg [S_COUNT-1:0]    initial_fifo_pass_done_reg;
wire [S_COUNT-1:0]   initial_fifo_pass_done;
wire [DELAY_COUNT_WIDTH-1:0] send_data_delay_count = cfg_tlast_count_to_drop_in << SHIFTS_PER_MILLISECOND;
reg [DELAY_COUNT_WIDTH-1:0] send_data_delay_accum_reg;
wire [DELAY_COUNT_WIDTH-1:0] send_data_delay_accum;
wire send_data_timeup;


wire [DELAY_COUNT_WIDTH-1:0] idle_delay_count = cfg_tlast_count_to_drop_in << SHIFTS_PER_MILLISECOND;
reg [DELAY_COUNT_WIDTH-1:0] idle_delay_accum_reg;
wire [DELAY_COUNT_WIDTH-1:0] idle_delay_accum;

initial idle_delay_accum_reg = 32'hFFFF_FFFF_FFFF_FFFF;
initial send_data_delay_accum_reg = 32'hFFFF_FFFF_FFFF_FFFF;
wire idle_timeup;

reg just_after_reset_reg;
wire just_after_reset;

//reg update_mux_sel_reg;
//wire update_mux_sel;

reg newsample_reg;
wire newsample_req;

//set after replacing to mark for dropping
reg [MAX_FRAME_SIZE-1:0] pkt_replaced_to_drop_reg;//clr after droping or time out one at a time
wire [MAX_FRAME_SIZE-1:0] pkt_replaced_to_drop;

assign pkt_replaced_to_drop = pkt_replaced_to_drop_reg;


reg [C_S_AXI_DATA_WIDTH-1:0] dropped_pkt_counter_reg;
assign dropped_pkt_counter = dropped_pkt_counter_reg;


//assign update_mux_sel = update_mux_sel_reg;

assign just_after_reset = just_after_reset_reg;

assign send_data_timeup = (send_data_delay_accum == 1);

assign send_data_delay_accum = send_data_delay_accum_reg;
assign idle_delay_accum = idle_delay_accum_reg;

assign idle_timeup = (idle_delay_accum == 1);

assign s_axis_tlast_count = s_axis_tlast_count_reg;

//assign select_dmux = select_dmux_reg;

//assign drop_dmux = drop_dmux_reg;

//assign select_mux = select_mux_reg;




//assign curr_hdr_seq_num = curr_hdr_seq_num_reg;
assign s_axis_tready_local = s_axis_tready_local_reg;
	  
//assign initial_fifo_pass = initial_fifo_pass_reg;
assign initial_fifo_pass_done = initial_fifo_pass_done_reg;

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




//reg [C_S_AXIS_TDATA_WIDTH-1:0]  m_patch_axis_tdata_reg;
//reg  m_patch_axis_tvalid_reg;
//reg m_patch_axis_tready_reg;
//reg m_patch_axis_tlast_reg;

wire [C_S_AXIS_TDATA_WIDTH-1:0] patch_axis_tdata;
reg [C_S_AXIS_TDATA_WIDTH-1:0]  patch_axis_tdata_reg;



assign patch_axis_tdata = patch_axis_tdata_reg;

assign M_AXIS_TDATA = patch_axis_tdata;
assign M_AXIS_TVALID =  mst_exec_state == WRITE_FIFO ? S_AXIS_TVALID : 0;
assign M_AXIS_TLAST =  S_AXIS_TLAST;
assign S_AXIS_TREADY = mst_exec_state == WRITE_FIFO ? M_AXIS_TREADY : s_axis_tready_local;



reg [DELAY_COUNT_WIDTH-1:0] pkt_to_pkt_delay_reg;
wire [DELAY_COUNT_WIDTH-1:0] pkt_to_pkt_delay;

reg [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_delay_reg;
wire [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_delay;

reg [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_drop_lock_reg;
wire [DELAY_COUNT_WIDTH-1:0] spkt_to_pkt_drop_lock;

reg [DELAY_COUNT_WIDTH-1:0] last_spkt_to_pkt_delay_reg;
wire [DELAY_COUNT_WIDTH-1:0] last_spkt_to_pkt_delay;


reg [RTP_HDR_SEQ_WIDTH-1:0] next_pkt_seq_to_drop_reg;
wire [RTP_HDR_SEQ_WIDTH-1:0] next_pkt_seq_to_drop;

//reg pkt_to_drop_flag_reg;
wire pkt_to_drop_flag;
wire pkt_to_drop_flag1;
wire pkt_to_drop_flag2;
wire pkt_to_drop_flag3;
wire pkt_to_drop_flag4;

reg [RTP_HDR_SEQ_WIDTH-1:0] num_pkts_to_drop_reg;
wire [RTP_HDR_SEQ_WIDTH-1:0] num_pkts_to_drop;


reg [RTP_HDR_SEQ_WIDTH-1:0] last_pkt_seq_rx_reg;
wire [RTP_HDR_SEQ_WIDTH-1:0] last_pkt_seq_rx;

reg [RTP_HDR_SEQ_WIDTH-1:0] last_pkt_seq_dropped_reg;
wire [RTP_HDR_SEQ_WIDTH-1:0] last_pkt_seq_dropped;


reg [DELAY_COUNT_WIDTH-1:0] accum_spkt_to_pkt_delay_reg;
wire [DELAY_COUNT_WIDTH-1:0] accum_spkt_to_pkt_delay;


reg [DELAY_COUNT_WIDTH-1:0] accum_spkt_to_pkt_neg_delay_reg;
wire [DELAY_COUNT_WIDTH-1:0] accum_spkt_to_pkt_neg_delay;

reg signed [DELAY_COUNT_WIDTH-1:0] diff_spkt_to_pkt_delay_reg;
wire signed [DELAY_COUNT_WIDTH-1:0] diff_spkt_to_pkt_delay;
//wire signed [DELAY_COUNT_WIDTH-1:0] diff_spkt_to_pkt_delay_out;

wire drop_check_before_lock;
wire drop_check_after_lock;
wire drop_check_accum;
wire accum_handler_cond;
wire accum_handler_inc;
wire accum_handler_dec;

assign accum_handler_inc = ((accum_handler_cond == 1) && ( spkt_to_pkt_delay > (cfg_network_base_delay+cfg_pkt_build_delay)));
assign accum_handler_dec = ((accum_handler_cond == 1) && ( spkt_to_pkt_delay < (cfg_network_base_delay+cfg_pkt_build_delay)));
assign drop_check_before_lock = (((spkt_to_pkt_drop_lock == 0)||(cfg_enf_spkt_to_pkt_lock_enable==0)) && ((spkt_to_pkt_delay>cfg_pkt_build_delay) && ((spkt_to_pkt_delay-cfg_pkt_build_delay) > cfg_spkt_to_pkt_delay_limit)));
assign drop_check_after_lock = (((spkt_to_pkt_drop_lock == 1)&&(cfg_enf_spkt_to_pkt_lock_enable==1)) && (spkt_to_pkt_delay>cfg_pkt_build_delay) && ((spkt_to_pkt_delay-cfg_pkt_build_delay) > cfg_spkt_to_pkt_locked_delay_limit));
assign accum_handler_cond = (((spkt_to_pkt_delay>cfg_pkt_build_delay) && ((spkt_to_pkt_delay-cfg_pkt_build_delay) < cfg_spkt_to_pkt_delay_limit)));

assign diff_spkt_to_pkt_delay = diff_spkt_to_pkt_delay_reg;
assign drop_check_accum = ((accum_spkt_to_pkt_delay > accum_spkt_to_pkt_neg_delay) && ((accum_spkt_to_pkt_delay-accum_spkt_to_pkt_neg_delay) > cfg_accum_spkt_to_pkt_delay_limit) && (cfg_enf_accum_enable==1));



assign diff_spkt_to_pkt_delay_out = diff_spkt_to_pkt_delay_reg;

assign pkt_to_drop_flag = pkt_to_drop_flag1 || pkt_to_drop_flag2 || pkt_to_drop_flag3 || pkt_to_drop_flag4;


assign pkt_to_drop_flag1 = (curr_hdr_seq_num == next_pkt_seq_to_drop); //requires a shift of drop range lower value
assign pkt_to_drop_flag2 = (next_pkt_seq_to_drop+num_pkts_to_drop<((2<<(RTP_HDR_SEQ_WIDTH-1))-1))? (curr_hdr_seq_num<(next_pkt_seq_to_drop+num_pkts_to_drop)?1:0):0;
assign pkt_to_drop_flag3 = (next_pkt_seq_to_drop+num_pkts_to_drop>((2<<(RTP_HDR_SEQ_WIDTH-1))-1))? (curr_hdr_seq_num<((((2<<(RTP_HDR_SEQ_WIDTH-1))-1)-(next_pkt_seq_to_drop+num_pkts_to_drop)))?1:0):0;
assign pkt_to_drop_flag4 = (curr_hdr_seq_num != next_pkt_seq_to_drop) && (num_pkts_to_drop > 0); //requires a shift of drop range lower value


assign accum_spkt_to_pkt_delay = accum_spkt_to_pkt_delay_reg;
assign accum_spkt_to_pkt_neg_delay = accum_spkt_to_pkt_neg_delay_reg;
assign pkt_to_pkt_delay = pkt_to_pkt_delay_reg;
assign spkt_to_pkt_delay = spkt_to_pkt_delay_reg;
assign spkt_to_pkt_drop_lock = spkt_to_pkt_drop_lock_reg;
assign last_spkt_to_pkt_delay = last_spkt_to_pkt_delay_reg;
assign next_pkt_seq_to_drop = next_pkt_seq_to_drop_reg;

assign num_pkts_to_drop = num_pkts_to_drop_reg;
assign last_pkt_seq_dropped = last_pkt_seq_dropped_reg;
assign last_pkt_seq_rx = last_pkt_seq_rx_reg;

assign accum_spkt_to_pkt_delay_out = accum_spkt_to_pkt_delay; 
assign spkt_to_pkt_delay_out = spkt_to_pkt_delay;

	
	// Control rx state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (rst || cfg_enf_rx_reset||(num_pkts_to_drop>16'h1800)) //6 seconds
	  // Synchronous reset (active low)
	    begin
//	      enable_dmux_reg <= 0;
//	      drop_dmux_reg <= 0;
	      s_axis_tready_local_reg <= 0;
	      mst_exec_state <= IDLE;
//	      initial_fifo_pass_reg <= 0;
	      hdr_byte_cnt_reg <= 0;
	      dropped_pkt_counter_reg <= 0;
//	      select_dmux_reg <= 0;
	      just_after_reset_reg <= 1;
	      rtp_hdr_b1 <= 0;
	      rtp_hdr_b2 <= 0;
	      
	      spkt_to_pkt_delay_reg <= 0;
	      spkt_to_pkt_drop_lock_reg <= 0;
	      accum_spkt_to_pkt_delay_reg <= 0;
	      accum_spkt_to_pkt_neg_delay_reg <= 0;
	      next_pkt_seq_to_drop_reg <= 0;
	      num_pkts_to_drop_reg <= 0;
	      last_spkt_to_pkt_delay_reg <= 0;
	      diff_spkt_to_pkt_delay_reg <= 0;
	      
	    end  
	  else	begin
	  if ((just_after_reset == 0) && (cfg_rx_lock==0)) begin
	      if (newsample_req == 1 && (cfg_enf_disable==0)) begin
            pkt_to_pkt_delay_reg = pkt_to_pkt_delay + 1; 
            spkt_to_pkt_delay_reg = spkt_to_pkt_delay + 1;       
	      end
	      
	      if (drop_check_before_lock == 1) begin
		      spkt_to_pkt_delay_reg <= 0;
		      spkt_to_pkt_drop_lock_reg <= 1;
               if (num_pkts_to_drop == 0) begin
                    next_pkt_seq_to_drop_reg <= curr_hdr_seq_num+1;
               end	
		       num_pkts_to_drop_reg <= num_pkts_to_drop + 1;  
	      end
	      
	      if (drop_check_after_lock == 1) begin
		      spkt_to_pkt_delay_reg <= 0;
               if (num_pkts_to_drop == 0) begin
                    next_pkt_seq_to_drop_reg <= curr_hdr_seq_num+1;
               end	
		       num_pkts_to_drop_reg <= num_pkts_to_drop + 1;  
	      end
	      
	     
	      
	      if (drop_check_accum == 1) begin
			 //accum_spkt_to_pkt_delay_reg <= spkt_to_pkt_delay;
			 accum_spkt_to_pkt_delay_reg <= 0;
			 accum_spkt_to_pkt_neg_delay_reg <= 0;
			//To allow immediate correction since spkt delay limit may never happen
			if (num_pkts_to_drop == 0) begin
				next_pkt_seq_to_drop_reg <= curr_hdr_seq_num+1;
			end        
			//we will adjust on the next spkt_to_pkt_delay
			num_pkts_to_drop_reg <= num_pkts_to_drop + 1;  
	      end
	      
	      
	      if ((diff_spkt_to_pkt_delay > cfg_diff_spkt_to_pkt_delay_limit) && (cfg_enf_diff_enable==1)) begin
			 //accum_spkt_to_pkt_delay_reg <= spkt_to_pkt_delay;
			 diff_spkt_to_pkt_delay_reg <= 0;
			//To allow immediate correction since spkt delay limit may never happen
			if (num_pkts_to_drop == 0) begin
				next_pkt_seq_to_drop_reg <= curr_hdr_seq_num+1;
			end        
			//we will adjust on the next spkt_to_pkt_delay
			num_pkts_to_drop_reg <= num_pkts_to_drop + 1;  
	      end
	      
	      
	   end
	  
	   case (mst_exec_state)
	      IDLE: begin
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	        s_axis_tready_local_reg <= 0;
	        if(S_AXIS_TVALID) begin
	              mst_exec_state <= GET_HDR;
	              s_axis_tready_local_reg <= 1;
	              //L_AXIS_TVALID_REG <= 0;
//	              enable_dmux_reg <= 0;
                    status2_out_reg <= 0;
	         end     
	         else begin
	         
	         if(fifo_occ_in <= cfg_fifo_occ_lim) begin
	         
	         mst_exec_state <= WRITE_PLC;
	         
	         end
	         
	         end

	        end
	      GET_HDR: begin//waits for pkt here
              if (S_AXIS_TVALID)
                begin
                
                   if (hdr_byte_cnt == 0) begin
                       rtp_hdr_b0 <= S_AXIS_TDATA;
                       hdr_byte_cnt_reg <= hdr_byte_cnt + 1;
                       s_axis_tready_local_reg <= 1;
                   end else if(hdr_byte_cnt == 1) begin                       
                       rtp_hdr_b1 <= S_AXIS_TDATA;
                       hdr_byte_cnt_reg <= hdr_byte_cnt + 1;
                       s_axis_tready_local_reg <= 0;
                       mst_exec_state <= DECIDE_ON_PKT;                            
                       just_after_reset_reg <= 0;     
                       
                       if(accum_handler_inc == 1) begin                      
                            //accum_spkt_to_pkt_delay_reg <= accum_spkt_to_pkt_delay + spkt_to_pkt_delay-cfg_network_base_delay-cfg_pkt_build_delay;
                            accum_spkt_to_pkt_delay_reg <= accum_spkt_to_pkt_delay + (spkt_to_pkt_delay - (cfg_network_base_delay + cfg_pkt_build_delay));
                            
                       end 
                        
                       if (accum_handler_dec == 1)
                       begin
                            accum_spkt_to_pkt_neg_delay_reg <= accum_spkt_to_pkt_neg_delay + ( (cfg_network_base_delay + cfg_pkt_build_delay) - spkt_to_pkt_delay);
                       end  

                    diff_spkt_to_pkt_delay_reg  <= diff_spkt_to_pkt_delay + spkt_to_pkt_delay - last_spkt_to_pkt_delay;
               
//                           else if(accum_spkt_to_pkt_delay > cfg_network_base_delay+cfg_pkt_build_delay) begin
               
//                           end
                    last_spkt_to_pkt_delay_reg <= spkt_to_pkt_delay;
                    end
                        
	           end
	           
	           
	      end
	      DECIDE_ON_PKT:
	      begin
	            spkt_to_pkt_delay_reg <= 0;
	            hdr_byte_cnt_reg <= 0;
	            
                if(pkt_replaced_to_drop[rtp_hdr_b0] == 1) begin                                   
                    
                 
                    
                    mst_exec_state <= DROP_PKT;
                    pkt_replaced_to_drop_reg[rtp_hdr_b0] = 0;
                    dropped_pkt_counter_reg <= dropped_pkt_counter + 1;
		              
                end
                else begin
//                    if(cfg_enf_disable == 0) begin
//                        select_dmux_reg <= curr_hdr_seq_num[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
//                        initial_fifo_pass_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 1;
//                    end

                   mst_exec_state <= WRITE_FIFO;
                   patch_axis_tdata_reg = S_AXIS_TDATA;
                   //s_axis_tready_local_reg <= 0;//dmux takes over
//                   enable_dmux_reg <= 1;
                   status2_out_reg <= 0;
                   s_axis_tready_local_reg <= 0;
                end
	            
	      end    
	      
	      DROP_PKT: begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        spkt_to_pkt_drop_lock_reg <= 0;
	        spkt_to_pkt_delay_reg <= 0;
	        pkt_replaced_to_drop_reg[rtp_hdr_b0] = 0;
	        if (S_AXIS_TLAST == 1)
	          begin
	            mst_exec_state <= IDLE;
//	            enable_dmux_reg <= 0;
	            s_axis_tready_local_reg <= 0;
	            status2_out_reg <= 1;
	            last_pkt_seq_dropped_reg = curr_hdr_seq_num;
	            //L_AXIS_TVALID_REG <=  0;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
//	            enable_dmux_reg <= 0;
	            status2_out_reg <= 0;
	            mst_exec_state <= DROP_PKT;
	            s_axis_tready_local_reg <= 1;//so that we drop
	            
	            
	          end
	          
//	         update_mux_sel_reg <= 0;
	          
            end
	      
	      WRITE_PLC: begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        pkt_to_pkt_delay_reg = 0;
	        patch_axis_tdata_reg = 0;
	        pkt_replaced_to_drop_reg[rtp_hdr_b0] = 1;
	        if (S_AXIS_TLAST == 1)
	          begin
	            mst_exec_state <= IDLE;
//	            enable_dmux_reg <= 0;
	            s_axis_tready_local_reg <= 0;
	            status2_out_reg <= 1;
	            last_pkt_seq_rx_reg <= curr_hdr_seq_num;
	            //L_AXIS_TVALID_REG <=  0;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
//	            enable_dmux_reg <= 1;
	            status2_out_reg <= 0;
	            mst_exec_state <= WRITE_FIFO;
	            
	            
	            
	          end
	          
//	         update_mux_sel_reg <= 0;
	          
            end  
	      WRITE_FIFO: begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        pkt_to_pkt_delay_reg = 0;
	        patch_axis_tdata_reg = S_AXIS_TDATA;
	        if (S_AXIS_TLAST == 1)
	          begin
	            mst_exec_state <= IDLE;
//	            enable_dmux_reg <= 0;
	            s_axis_tready_local_reg <= 0;
	            status2_out_reg <= 1;
	            last_pkt_seq_rx_reg <= curr_hdr_seq_num;
	            //L_AXIS_TVALID_REG <=  0;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
//	            enable_dmux_reg <= 1;
	            status2_out_reg <= 0;
	            mst_exec_state <= WRITE_FIFO;
	            
	            
	            
	          end
	          
//	         update_mux_sel_reg <= 0;
	          
            end
	    endcase
	    
	    
//	    if (initial_fifo_pass_done[select_mux] == 1)begin
//             initial_fifo_pass_reg[select_mux] <= 0;
//        end
	    

	end    
	    
	    
	end
	
	



    always@(posedge S_AXIS_ACLK) 
    begin
        if ( rst == 1) begin
            newsample_reg <= 0;  
            end      
        else begin
            newsample_reg <= new_sample;
        end
    end
    
    assign newsample_req = (new_sample == 1 ) ? (new_sample ^ newsample_reg) : 0;
        
    
    
    // Add user logic here
    
    
    
    // User logic ends

endmodule
