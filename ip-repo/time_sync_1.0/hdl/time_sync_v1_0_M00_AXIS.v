
`timescale 1 ns / 1 ps

	module time_sync_v1_0_M00_AXIS #
	(
		// Users to add parameters here
        parameter integer TC_COUNT_WIDTH = 32,
        parameter UDP_LENGTH_WIDTH = 16,
        parameter integer SHIFTS_PER_MILLISECOND = 17,
        parameter integer DELAY_COUNT_WIDTH = 32,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		parameter integer C_M_AXIS_TDATA_WIDTH	= 8,
		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
		parameter integer MIN_UDP_PKT_SIZE	= 256
	)
	(
		// Users to add ports here
        input wire  initiate_sync_request,
        input wire  sync_response_trigger,
        input wire [C_M_AXIS_TDATA_WIDTH-1 : 0] sync_response_magic_byte,    
        input wire [C_M_AXIS_TDATA_WIDTH-1 : 0] sync_request_magic_byte,    
        input wire [TC_COUNT_WIDTH-1 : 0] tc_count_in,
        output wire  tc_start_out,  
        input wire  sync_done_in,      
        output  wire       m_hdr_valid,
        output wire sync_responded_out,
        input wire [UDP_LENGTH_WIDTH-1:0]  m_time_sync_payload_length,
        input wire [DELAY_COUNT_WIDTH-1:0] cfg_round_trip_wait_delay,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global ports
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
		output wire  M_AXIS_TUSER,
		// TREADY indicates that the slave can accept a transfer in the current cycle.
		input wire  M_AXIS_TREADY
	);
	// Total number of output data                                                 
	localparam NUMBER_OF_OUTPUT_WORDS = 8;                                               
	                                                                                     
	// function called clogb2 that returns an integer which has the                      
	// value of the ceiling of the log base 2.                                           
	function integer clogb2 (input integer bit_depth);                                   
	  begin                                                                              
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                                      
	      bit_depth = bit_depth >> 1;                                                    
	  end                                                                                
	endfunction                                                                          
	                                                                                     
	// MIN_UDP_PKT_SIZE_WIDTH is the width of the wait counter.                                 
	localparam integer MIN_UDP_PKT_SIZE_WIDTH = clogb2(MIN_UDP_PKT_SIZE-1);                      
	                                                                                     
	// bit_num gives the minimum number of bits needed to address 'depth' size of FIFO.  
	localparam bit_num  = clogb2(NUMBER_OF_OUTPUT_WORDS);                                
	                                                                                     
	// Define the states of state machine                                                
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO                                      
	parameter [1:0] IDLE = 2'b00,        // This is the initial/idle state               
	                                                                                     
	                SEND_TC_SYNC_REQUEST  = 2'b01,
	                SEND_SYNC_RESPONSE  = 2'b10,
	                WAIT_SYNC_RESPONSE  = 2'b11; // In this state the                          
	                                     // stream data is output through M_AXIS_TDATA   
	// State variable                                                                    
	reg [1:0] mst_exec_state_reg;     
	wire [1:0] mst_exec_state;                                                       
	// Example design FIFO read pointer                                                  
	reg [bit_num-1:0] read_pointer;                                                      

	// AXI Stream internal signals
	//wait counter. The master waits for the user defined number of clock cycles before initiating a transfer.
	reg [MIN_UDP_PKT_SIZE_WIDTH-1 : 0] 	byte_count_reg;
	wire [MIN_UDP_PKT_SIZE_WIDTH-1 : 0] 	byte_count;
	//streaming data valid
//	wire  	axis_tvalid;
	//streaming data valid delayed by one clock cycle
//	reg  	axis_tvalid_delay;
	//Last of the streaming data 
//	wire  	axis_tlast;
	//Last of the streaming data delayed by one clock cycle
//	reg  	axis_tlast_delay;
	//FIFO implementation signals
	reg [C_M_AXIS_TDATA_WIDTH-1 : 0] 	stream_data_out_reg;
	wire  	tx_en;
	//The master has issued all the streaming data stored in FIFO
	reg  	tx_done;
    reg     tc_start_reg;
    
    reg     local_tlast_reg;
    
    reg     sync_inprogress_reg;
    wire     sync_inprogress;
    
    wire [DELAY_COUNT_WIDTH-1:0] round_trip_delay_count = cfg_round_trip_wait_delay << SHIFTS_PER_MILLISECOND;
    reg [DELAY_COUNT_WIDTH-1:0] round_trip_delay_accum_reg;
    wire [DELAY_COUNT_WIDTH-1:0] round_trip_delay_accum;
    
    wire sync_responded;
    reg sync_responded_reg;
    
    assign sync_responded = sync_responded_reg;
    assign sync_responded_out = sync_responded_reg;
    
    
    assign round_trip_delay_accum = round_trip_delay_accum_reg;         
    
    
    reg m_hdr_valid_reg;
    
    assign m_hdr_valid = m_hdr_valid_reg;
    

    // I/O Connections assignments

    assign M_AXIS_TVALID	= (mst_exec_state == SEND_TC_SYNC_REQUEST) || (mst_exec_state == SEND_SYNC_RESPONSE) ? 1 : 0;
    assign M_AXIS_TDATA	= stream_data_out_reg;
    assign M_AXIS_TLAST	= local_tlast_reg;
    assign M_AXIS_TUSER = 0;
    
    
//	assign M_AXIS_TSTRB	= {(C_M_AXIS_TDATA_WIDTH/8){1'b1}};
    assign  tc_start_out =  tc_start_reg;
    assign  sync_inprogress = sync_inprogress_reg;
    
    
    
    assign byte_count = byte_count_reg;
    
    assign mst_exec_state = mst_exec_state_reg;
        //tvalid generation
	//axis_tvalid is asserted when the control state machine's state is SEND_STREAM and
	//number of output streaming data is less than the NUMBER_OF_OUTPUT_WORDS.
//	assign axis_tvalid = (mst_exec_state == SEND_TC_SYNC_REQUEST) || (mst_exec_state == SEND_SYNC_RESPONSE) ? 1 : 0;
	                                                                                               
	// AXI tlast generation                                                                        
	// axis_tlast is asserted number of output streaming data is NUMBER_OF_OUTPUT_WORDS-1          
	// (0 to NUMBER_OF_OUTPUT_WORDS-1)                                                             
//	assign axis_tlast = local_tlast_reg;   
	
	
	
	// Delay the axis_tvalid and axis_tlast signal by one clock cycle                              
	// to match the latency of M_AXIS_TDATA                                                        
//	always @(posedge M_AXIS_ACLK)                                                                  
//	begin                                                                                          
//	  if (!M_AXIS_ARESETN)                                                                         
//	    begin                                                                                      
//	      axis_tvalid_delay <= 1'b0;                                                               
//	      axis_tlast_delay <= 1'b0;                                                                
//	    end                                                                                        
//	  else                                                                                         
//	    begin                                                                                      
//	      axis_tvalid_delay <= axis_tvalid;                                                        
//	      axis_tlast_delay <= axis_tlast;                                                          
//	    end                                                                                        
//	end                                                                                            
                             
	                                              
    

	// Control state machine implementation                             
	always @(posedge M_AXIS_ACLK)                                             
	begin                                                                     
	  if (!M_AXIS_ARESETN)                                                    
	  // Synchronous reset (active low)                                       
	    begin                                                                 
	      mst_exec_state_reg <= IDLE;                                             
	      byte_count_reg    <= 0;     
	       tc_start_reg <= 0;   
	       local_tlast_reg = 0;  
	       m_hdr_valid_reg <= 0;    
	       round_trip_delay_accum_reg <= 0;     
	       sync_responded_reg <= 0; 
	       stream_data_out_reg <=  0;                                           
	    end                                                                   
	  else                                                                    
	    case (mst_exec_state)                                                 
	      IDLE:       begin                                                        
	        // The slave starts accepting tdata when                          
	        // there tvalid is asserted to mark the                           
	        // presence of valid streaming data  
	        local_tlast_reg = 0; 
	        byte_count_reg <= 0; 
	        sync_responded_reg <= 0; 
		  
	        round_trip_delay_accum_reg <= 0;                                            
	        if ( initiate_sync_request == 1 && sync_done_in == 0)                                                 
	          begin                                                           
	            mst_exec_state_reg  <= SEND_TC_SYNC_REQUEST; 
	            
	            tc_start_reg <= 1;                           
	          end 
	        else if(sync_response_trigger == 1 && sync_responded == 0) begin
	           mst_exec_state_reg  <= SEND_SYNC_RESPONSE;   
	           
	        end                                                            
	        else                                                              
	          begin                                                           
	            mst_exec_state_reg  <= IDLE;  
	            m_hdr_valid_reg <= 0;                                      
	          end                                                             
	       end                                                                   
	      SEND_TC_SYNC_REQUEST:   begin                                                    
	        // The slave starts accepting tdata when                          
	        // there tvalid is asserted to mark the                           
	        // presence of valid streaming data                               
	           m_hdr_valid_reg <= 1;  
	           if(M_AXIS_TREADY == 1) begin
                   if( byte_count == 0)
                       begin 
                           stream_data_out_reg <=    sync_request_magic_byte; 
                           mst_exec_state_reg  <= SEND_TC_SYNC_REQUEST;   
                       end
                    else if( byte_count == 1)
                       begin 
                           stream_data_out_reg <=    byte_count_reg; //tc_count_in[31:24]; 
                           mst_exec_state_reg  <= SEND_TC_SYNC_REQUEST;  
                       end
                    else if( byte_count == 2)
                       begin 
                           stream_data_out_reg <=   byte_count_reg;// tc_count_in[23:16];
                           mst_exec_state_reg  <= SEND_TC_SYNC_REQUEST; 
                       end 
                    else if( byte_count == 3)
                       begin 
                           stream_data_out_reg <=  byte_count_reg;//  tc_count_in[15:8];
                           mst_exec_state_reg  <= SEND_TC_SYNC_REQUEST;   
                       end 
                    else if( byte_count == 4)
                       begin 
                           stream_data_out_reg <=  byte_count_reg;//  tc_count_in[7:0];   
                           mst_exec_state_reg  <= SEND_TC_SYNC_REQUEST;      
                       end 
                    else if( byte_count == 5)
                       begin 
                           stream_data_out_reg <= byte_count_reg;//   8'hFF;  
                           mst_exec_state_reg  <= SEND_TC_SYNC_REQUEST;      
                       end 
                    else if( byte_count >= m_time_sync_payload_length-1)
                       begin 
                           stream_data_out_reg <=  byte_count_reg;//  8'hFF;   
                           mst_exec_state_reg  <= WAIT_SYNC_RESPONSE;
                             
                           local_tlast_reg = 1;  
                            
                       end     
                                            
                       byte_count_reg <= byte_count_reg + 1;                                 
                    end
	         end                                                     
	     SEND_SYNC_RESPONSE: begin
	       m_hdr_valid_reg <= 1;
	       if(M_AXIS_TREADY == 1) begin  
               if( byte_count == 0)
                       begin 
                           stream_data_out_reg <=    sync_response_magic_byte; 
                           mst_exec_state_reg  <= SEND_SYNC_RESPONSE;   
                       end
                    else if( byte_count == 1)
                       begin 
                           stream_data_out_reg <=    tc_count_in[31:24]; 
                           mst_exec_state_reg  <= SEND_SYNC_RESPONSE;  
                       end
                    else if( byte_count == 2)
                       begin 
                           stream_data_out_reg <=    tc_count_in[23:16];
                           mst_exec_state_reg  <= SEND_SYNC_RESPONSE; 
                       end 
                    else if( byte_count == 3)
                       begin 
                           stream_data_out_reg <=    tc_count_in[15:8];
                           mst_exec_state_reg  <= SEND_SYNC_RESPONSE;   
                       end 
                    else if( byte_count == 4)
                       begin 
                           stream_data_out_reg <=    tc_count_in[7:0];   
                           mst_exec_state_reg  <= SEND_SYNC_RESPONSE;    
                       end 
                     else if( byte_count == 5)
                       begin 
                           stream_data_out_reg <=    8'hFF;  
                           mst_exec_state_reg  <= SEND_SYNC_RESPONSE;    
                       end 
                    else if( byte_count >= m_time_sync_payload_length-1)
                       begin 
                           stream_data_out_reg <=    8'hFF;   
                           mst_exec_state_reg  <= IDLE; 
                           sync_responded_reg <= 1;
                           local_tlast_reg = 1;  
                           m_hdr_valid_reg <= 0;  
                            
                       end                                    
	                                     
	               byte_count_reg <= byte_count_reg + 1;                                 
	            end
	     end 
	     
	    WAIT_SYNC_RESPONSE: begin
		local_tlast_reg = 0;  
	       round_trip_delay_accum_reg <= round_trip_delay_accum + 1;        
	       mst_exec_state_reg  <= WAIT_SYNC_RESPONSE;
	       byte_count_reg <= 0;
	       if(round_trip_delay_accum >= round_trip_delay_count) begin
	           mst_exec_state_reg  <= IDLE;
	           m_hdr_valid_reg <= 0; 
	           round_trip_delay_accum_reg <= 0;
	       end
	    end                                                                                                                
	    endcase                                                               
	end                                                                       


	                                                 
	                                                                                               
	

	
	// Add user logic here

	// User logic ends

	endmodule
