
`timescale 1 ns / 1 ps

	module time_sync_v1_0_S00_AXIS #
	(
		// Users to add parameters here
        parameter integer TC_COUNT_WIDTH = 32,
        parameter integer MIN_UDP_PKT_SIZE	= 32,
        parameter UDP_LENGTH_WIDTH = 16,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 8
	)
	(
		// Users to add ports here
		input wire [TC_COUNT_WIDTH-1 : 0] tc_count_in,
        output wire [TC_COUNT_WIDTH-1 : 0] tc_count_adjusted_out,
        output wire [TC_COUNT_WIDTH-1 : 0] round_path_delay_out,
        input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] sync_request_magic_byte, 
        input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] sync_response_magic_byte,
        input wire  initiate_sync_request,
        output wire  sync_response_received,
        output wire  sync_request_received,
        output wire  sync_response_trigger,
        output wire  tc_adjust,
        output wire  sync_done_out,
        input wire        s_hdr_ready,
        input wire sync_responded_in,
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
		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
		// Indicates boundary of last packet
		input wire  S_AXIS_TLAST,
		// Data is in valid
		input wire  S_AXIS_TVALID
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
	localparam NUMBER_OF_INPUT_WORDS  = 8;
	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
	
	localparam integer MIN_UDP_PKT_SIZE_WIDTH = clogb2(MIN_UDP_PKT_SIZE-1);    
	// Define the states of state machine
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0] IDLE = 3'b000,        // This is the initial/idle state 
	                DECODE_PKT_TYPE = 3'b001,
	                PROC_TC_SYNC_REQUEST  = 3'b010,
	                PROC_TC_SYNC_RESPONSE  = 3'b011,
	                DUMP_TC_SYNC_PKT = 3'b100; // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
	                                    
	reg [MIN_UDP_PKT_SIZE_WIDTH-1 : 0] 	byte_count_reg;
	wire  	axis_tready;
	// State variable
	reg mst_exec_state;  
	// FIFO implementation signals  
	// FIFO write enable
	wire fifo_wren;
	// FIFO full flag
	reg fifo_full_flag;
	
	wire sync_response_pkt;
	wire sync_request_pkt;
	
	// FIFO write pointer
	reg [bit_num-1:0] write_pointer;
	// sink has accepted all the streaming data and stored in FIFO
	  reg writes_done;
	  
	  
	wire [TC_COUNT_WIDTH-1 : 0] half_path_delay;
    wire [TC_COUNT_WIDTH-1 : 0] tc_count_rx;
	  
	reg sync_response_received_reg;
	reg sync_request_received_reg;
	reg sync_response_pkt_reg;
	reg sync_request_pkt_reg;
	reg sync_response_trigger_reg;
	reg [TC_COUNT_WIDTH-1 : 0] tc_count_rx_reg;
	reg [TC_COUNT_WIDTH-1 : 0] tc_count_adjusted_out_reg;
	reg [TC_COUNT_WIDTH-1 : 0] round_path_delay_reg;
	reg tc_adjust_reg;
	
	reg sync_done_reg;
	// I/O Connections assignments
    assign  sync_response_received = sync_response_received_reg;
    assign  sync_request_received = sync_request_received_reg;
	assign  sync_response_pkt = sync_response_pkt_reg;
	assign  sync_request_pkt = sync_request_pkt_reg;
	assign  sync_response_trigger = sync_response_trigger_reg;
	assign  tc_count_adjusted_out = tc_count_adjusted_out_reg;
	assign round_path_delay_out = round_path_delay_reg;
	assign half_path_delay = round_path_delay_reg << 1;
	assign tc_count_rx = tc_count_rx_reg;
	
	assign sync_done_out = sync_done_reg;
	
	assign S_AXIS_TREADY	= axis_tready;
	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (!S_AXIS_ARESETN) 
	  // Synchronous reset (active low)
	    begin
	      mst_exec_state <= IDLE;
	      sync_response_received_reg = 0;
	      tc_adjust_reg <= 0;
	      sync_done_reg <= 0;
	      sync_response_pkt_reg <= 0;	
	    end  
	  else
	    case (mst_exec_state)
	      IDLE: 
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	          if (S_AXIS_TVALID)
	            begin
	              mst_exec_state <= DECODE_PKT_TYPE;
	              sync_response_trigger_reg <= 0;
	              sync_response_pkt_reg <= 0;	
	            end
	          else
	            begin
	              mst_exec_state <= IDLE;
	              sync_response_received_reg <= 0;
	              sync_response_trigger_reg <= 0;
	              sync_response_pkt_reg <= 0;	
	              tc_adjust_reg <= 0;
	            end
	      DECODE_PKT_TYPE: begin
	          
                   if(S_AXIS_TDATA == sync_request_magic_byte) begin
                       mst_exec_state  <= PROC_TC_SYNC_REQUEST;   
                       sync_request_pkt_reg <= 1;	                       
                       sync_response_trigger_reg <= 1;// causes TC response
                   end
                   else if(S_AXIS_TDATA == sync_response_magic_byte) begin
                       mst_exec_state  <= PROC_TC_SYNC_RESPONSE;   
                       sync_response_pkt_reg <= 1;	                       
                       round_path_delay_reg <= tc_count_in;
                   end
                   else begin
                       mst_exec_state <= DUMP_TC_SYNC_PKT;
                       sync_response_received_reg <= 0;
                   end
	               
	          end 
	      PROC_TC_SYNC_REQUEST: begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (S_AXIS_TLAST)
	          begin
	            mst_exec_state <= IDLE;	  
	            byte_count_reg <= 0;          
	          end
	        else
	          begin
	                mst_exec_state  <= PROC_TC_SYNC_REQUEST;
	                       
	               end 
	            sync_request_received_reg <= 1;                      
	            byte_count_reg <= byte_count_reg + 1;                                 
	                                               
	            mst_exec_state <= PROC_TC_SYNC_REQUEST;
	          end
            PROC_TC_SYNC_RESPONSE:  begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
                if (S_AXIS_TLAST)
                  begin
                    mst_exec_state <= IDLE;
                    sync_response_received_reg <= 1; // causes TC correction
                     sync_done_reg <= 1;
                     byte_count_reg <= 0;
                  end
                else
                  begin
                    if( byte_count_reg == 0)
                       begin 
                           tc_count_rx_reg[31:24] <= S_AXIS_TDATA; 
                           mst_exec_state  <= PROC_TC_SYNC_RESPONSE;  
                       end
                    else if( byte_count_reg == 1)
                       begin 
                           tc_count_rx_reg[23:16] <= S_AXIS_TDATA; 
                           mst_exec_state  <= PROC_TC_SYNC_RESPONSE; 
                       end 
                    else if( byte_count_reg == 2)
                       begin 
                           tc_count_rx_reg[15:8] <= S_AXIS_TDATA; 
                           mst_exec_state  <= PROC_TC_SYNC_RESPONSE;   
                       end 
                    else if( byte_count_reg == 3)
                       begin 
                           tc_count_rx_reg[7:0] <= S_AXIS_TDATA;  
                           mst_exec_state  <= PROC_TC_SYNC_RESPONSE;
                               
                       end 
                    else if( byte_count_reg == 4)
                       begin                            
                           tc_count_adjusted_out_reg <= half_path_delay + tc_count_rx;
                           tc_adjust_reg <= 1;                          
                           mst_exec_state  <= PROC_TC_SYNC_RESPONSE;
                               
                       end 
                   else if( byte_count_reg == 5)
                       begin                            
                           tc_count_adjusted_out_reg <= half_path_delay + tc_count_rx;
                           tc_adjust_reg <= 1;                          
                           mst_exec_state  <= PROC_TC_SYNC_RESPONSE;
                               
                       end 
                    else if( byte_count_reg == 6)
                       begin                            
                           tc_count_adjusted_out_reg <= half_path_delay + tc_count_rx;
                           tc_adjust_reg <= 0;                          
                           mst_exec_state  <= PROC_TC_SYNC_RESPONSE;
                               
                       end 
                    
                    if (S_AXIS_TVALID)
	                begin                         
                        byte_count_reg <= byte_count_reg + 1;   
                    end                              
                                                       
                    mst_exec_state <= PROC_TC_SYNC_RESPONSE;
                  end
	        end  
	       DUMP_TC_SYNC_PKT: begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (S_AXIS_TLAST)
	          begin
	            mst_exec_state <= IDLE;
	            sync_response_received_reg <= 0; // causes TC correction
	            byte_count_reg <= 0;
	          end
	        else
	          begin
	            	                                    
	            if (S_AXIS_TVALID)
	                begin                         
                        byte_count_reg <= byte_count_reg + 1;   
                    end                                     
	                                               
	            mst_exec_state <= DUMP_TC_SYNC_PKT;
	          end
	       end
	    endcase
	    
	    if(initiate_sync_request == 0) begin
	           sync_done_reg <= 0;
	    end
	    
	    
	    if(sync_responded_in == 1 ) begin
	           sync_response_trigger_reg <= 0;	    end
	end
	// AXI Streaming Sink 
	// 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	assign axis_tready = (mst_exec_state == DECODE_PKT_TYPE || mst_exec_state == PROC_TC_SYNC_REQUEST || mst_exec_state == PROC_TC_SYNC_RESPONSE );

	

	// Add user logic here

	// User logic ends

	endmodule
