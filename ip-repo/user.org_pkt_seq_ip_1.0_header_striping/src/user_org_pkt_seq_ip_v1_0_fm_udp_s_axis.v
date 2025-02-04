
`timescale 1 ns / 1 ps

	module user_org_pkt_seq_ip_v1_0_fm_udp_s_axis #
	(
		// Users to add parameters here
        parameter integer RTP_HDR_DATA_WIDTH	= 8*20,
        parameter integer RTP_HDR_BCNT_WIDTH	= 5, // 20 bytes
        parameter integer RTP_HDR_SEQ_WIDTH	= 16,
	    parameter integer SHIFTS_PER_MILLISECOND = 17,
	    parameter integer DELAY_COUNT_WIDTH = 64,
        parameter S_COUNT = 16,
		// User parameters ends
		// Do not modify the parameters beyond this line

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
		input wire  [$clog2(S_COUNT)-1:0] cfg_seq_reset,
		input wire cfg_seq_rx_reset,
		input wire cfg_seq_disable,
		
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
                    DMUX_PKT = 3'b010,
	                WRITE_FIFO  = 3'b011; // In this state FIFO is written with the
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
	  //reg [RTP_HDR_SEQ_WIDTH-1:0] curr_hdr_seq_num_reg;
	  
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


reg [S_COUNT-1:0]    initial_fifo_pass_reg;
wire [S_COUNT-1:0]   initial_fifo_pass;

reg [S_COUNT-1:0]    initial_fifo_pass_done_reg;
wire [S_COUNT-1:0]   initial_fifo_pass_done;
wire [DELAY_COUNT_WIDTH-1:0] send_data_delay_count = cfg_tlast_count_to_drop_in << SHIFTS_PER_MILLISECOND;
reg [DELAY_COUNT_WIDTH-1:0] send_data_delay_accum_reg;
wire [DELAY_COUNT_WIDTH-1:0] send_data_delay_accum;
wire send_data_timeup;


wire [DELAY_COUNT_WIDTH-1:0] idle_delay_count = cfg_tlast_count_to_drop_in << SHIFTS_PER_MILLISECOND;
reg [DELAY_COUNT_WIDTH-1:0] idle_delay_accum_reg;
wire [DELAY_COUNT_WIDTH-1:0] idle_delay_accum;

initial idle_delay_accum_reg = 16'hFFFF_FFFF_FFFF_FFFF;
initial send_data_delay_accum_reg = 16'hFFFF_FFFF_FFFF_FFFF;
wire idle_timeup;

reg just_after_reset_reg;
wire just_after_reset;

reg update_mux_sel_reg;
wire update_mux_sel;


assign update_mux_sel = update_mux_sel_reg;

assign just_after_reset = just_after_reset_reg;

assign send_data_timeup = (send_data_delay_accum == 1);

assign send_data_delay_accum = send_data_delay_accum_reg;
assign idle_delay_accum = idle_delay_accum_reg;

assign idle_timeup = (idle_delay_accum == 1);

assign s_axis_tlast_count = s_axis_tlast_count_reg;

assign select_dmux = select_dmux_reg;

assign drop_dmux = drop_dmux_reg;

assign select_mux = select_mux_reg;




//assign curr_hdr_seq_num = curr_hdr_seq_num_reg;
assign s_axis_tready_local = s_axis_tready_local_reg;
	  
assign initial_fifo_pass = initial_fifo_pass_reg;
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
                            



//assign S_AXIS_TREADY = s_axis_tready_local || s_axis_tready_dmux;



//reg  M_AXIS_TVALID_REG;
//reg [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA_REG;
//reg M_AXIS_TLAST_REG;
//reg S_AXIS_TREADY_REG;

//reg [C_S_AXIS_TDATA_WIDTH-1:0]  to_dmux_ch_fifo_axis_tdata_reg;
//reg  to_dmux_ch_fifo_axis_tvalid_reg;
////wire to_dmux_ch_fifo_axis_tready;
//reg to_dmux_ch_fifo_axis_tlast_reg;

//reg from_mux_ch_fifo_axis_tready_reg; 


//assign M_AXIS_TDATA = M_AXIS_TDATA_REG;
//assign M_AXIS_TVALID = M_AXIS_TVALID_REG;
//assign M_AXIS_TLAST = M_AXIS_TLAST_REG;


//assign to_dmux_ch_fifo_axis_tdata = to_dmux_ch_fifo_axis_tdata_reg;
//assign to_dmux_ch_fifo_axis_tvalid = to_dmux_ch_fifo_axis_tvalid_reg;
//assign to_dmux_ch_fifo_axis_tlast = to_dmux_ch_fifo_axis_tlast_reg;
//assign from_mux_ch_fifo_axis_tready = from_mux_ch_fifo_axis_tready_reg;



reg [C_S_AXIS_TDATA_WIDTH-1:0]  m_patch_axis_tdata_reg;
reg  m_patch_axis_tvalid_reg;
reg m_patch_axis_tready_reg;
reg m_patch_axis_tlast_reg;

//reg m_patch_axis_reg;
//wire m_patch_axis;




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

//wire L_AXIS_TVALID;
//reg L_AXIS_TVALID_REG;


//reg [C_S_AXIS_TDATA_WIDTH-1:0] L_AXIS_TDATA_REG;
//wire [C_S_AXIS_TDATA_WIDTH-1:0] L_AXIS_TDATA;


//assign L_AXIS_TDATA = L_AXIS_TDATA_REG;
//assign L_AXIS_TVALID= L_AXIS_TVALID_REG;
//assign  m_patch_axis = m_patch_axis_reg;


assign to_dmux_ch_fifo_axis_tdata = cfg_seq_disable ?  0 : S_AXIS_TDATA;
assign to_dmux_ch_fifo_axis_tvalid = cfg_seq_disable ? 0 : S_AXIS_TVALID;
assign to_dmux_ch_fifo_axis_tlast = cfg_seq_disable ?  0 : S_AXIS_TLAST;



//assign M_AXIS_TDATA = cfg_seq_disable ?  (m_patch_axis ? S_AXIS_TDATA : 0) : from_mux_ch_fifo_axis_tdata;
//assign M_AXIS_TVALID =  cfg_seq_disable ?  (m_patch_axis ? S_AXIS_TVALID : 0) : from_mux_ch_fifo_axis_tvalid;
//assign M_AXIS_TLAST =  cfg_seq_disable ?  (m_patch_axis ? S_AXIS_TLAST : 0) : from_mux_ch_fifo_axis_tlast;

assign M_AXIS_TDATA = cfg_seq_disable ?  S_AXIS_TDATA : from_mux_ch_fifo_axis_tdata;
assign M_AXIS_TVALID =  cfg_seq_disable ?  (mst_exec_state == WRITE_FIFO ? S_AXIS_TVALID : 0) : from_mux_ch_fifo_axis_tvalid;
assign M_AXIS_TLAST =  cfg_seq_disable ?  S_AXIS_TLAST : from_mux_ch_fifo_axis_tlast;
assign S_AXIS_TREADY = cfg_seq_disable ? (mst_exec_state == WRITE_FIFO ? M_AXIS_TREADY : s_axis_tready_local) :(s_axis_tready_local || to_dmux_ch_fifo_axis_tready);



assign from_mux_ch_fifo_axis_tready = cfg_seq_disable ?  0 : M_AXIS_TREADY;

assign enable_mux = cfg_seq_disable ? 0 : enable_mux_reg;
assign enable_dmux = cfg_seq_disable ? 0 : enable_dmux_reg;

//assign s_axis_tready_dmux = s_axis_tready_dmux_reg;


//always @(*) begin


//    if(cfg_seq_rx_reset) begin
//        S_AXIS_TREADY_REG <= M_AXIS_TREADY;
//        M_AXIS_TDATA_REG  <= S_AXIS_TDATA;
//        M_AXIS_TVALID_REG <= S_AXIS_TVALID;
//        M_AXIS_TLAST_REG <= S_AXIS_TLAST;
    
//    end
//    else begin
//        to_dmux_ch_fifo_axis_tdata_reg <= S_AXIS_TDATA;
//        to_dmux_ch_fifo_axis_tvalid_reg <= S_AXIS_TVALID;
//        s_axis_tready_dmux_reg <=to_dmux_ch_fifo_axis_tready;
//        to_dmux_ch_fifo_axis_tlast_reg <= S_AXIS_TLAST;
        
        
        
//        M_AXIS_TDATA_REG  <= from_mux_ch_fifo_axis_tdata;
//        M_AXIS_TVALID_REG <= from_mux_ch_fifo_axis_tvalid;
//        from_mux_ch_fifo_axis_tready_reg <= M_AXIS_TREADY;
//        M_AXIS_TLAST_REG <= from_mux_ch_fifo_axis_tlast;
  
//    end
    
  
     
     

//end
	
	
	
		// Control tx state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (rst) 
	  // Synchronous reset (active low)
	    begin
	      out_exec_state <= IDLE;
	      enable_mux_reg <= 0;
	      initial_fifo_pass_done_reg <= 0;
	      s_axis_tlast_count_reg <= 0;
	      select_mux_reg <= 0;
	      send_data_delay_accum_reg <= send_data_delay_count;
	      idle_delay_accum_reg <= idle_delay_count;
	    end  
	  else
//	   if(cfg_seq_disable == 0) begin
	   
	   
	   
            case (out_exec_state)
            
            IDLE:begin
                       status1_out_reg <= 1;
                       
                       
                       
                       if((initial_fifo_pass[select_mux] == 1))begin
    //                       out_exec_state <= SEND_DATA;
                             out_exec_state <= SEL_FIFO;
                             initial_fifo_pass_done_reg[select_mux] <= 1;
                             idle_delay_accum_reg <= idle_delay_count;
    //                       enable_mux_reg <= 1;
                       end
                       else begin
                           if(just_after_reset == 0)   begin 
                                idle_delay_accum_reg <= (idle_timeup ? idle_delay_count : idle_delay_accum) - 1;
                          end 
                          
                          
                            if(idle_timeup == 1) begin
                               select_mux_reg <= select_mux + 1;
                            end 
                            
                            if(update_mux_sel==1) begin
                                select_mux_reg <= curr_hdr_seq_num[$clog2(S_COUNT)-1:0];
                            end
                        
                        end
                       
                   end
              SEL_FIFO:begin
    //	           select_mux_reg <= select_mux + 1;
                   status1_out_reg <= 0;
               
    //	           if(initial_fifo_pass[select_mux] == 0) begin
    ////                   out_exec_state <= SEND_DATA;
    //                   enable_mux_reg <= 1;
    //                   initial_fifo_pass_done_reg[select_mux] <= 0;
    //	           end	  
               
               //Wait to be cleared
                   if(initial_fifo_pass[select_mux] == 0 && from_mux_ch_fifo_axis_tlast == 0) begin
                       out_exec_state <= SEND_DATA;
                       enable_mux_reg <= 1;
                       initial_fifo_pass_done_reg[select_mux] <= 0;
                    end	                   
                   
                   
                   end
              SEND_DATA: begin
                idle_delay_accum_reg <= 0;
                if (from_mux_ch_fifo_axis_tlast == 1)
                  begin
                    out_exec_state <= IDLE;
                    initial_fifo_pass_done_reg[select_mux] <= 0;
                    status1_out_reg <= 0;
                    //s_axis_tlast_count_reg <= 0;
                    select_mux_reg <= select_mux + 1;
                    enable_mux_reg <= 1;
                    send_data_delay_accum_reg <= send_data_delay_count;
                  end
                else
                  begin
                    // The sink accepts and stores tdata 
                    // into FIFO
                    status1_out_reg <= 0;
                    send_data_delay_accum_reg <= (send_data_timeup ? send_data_delay_count : send_data_delay_accum) - 1;
                    if(send_data_timeup == 1) begin
                       out_exec_state <= IDLE;
                       initial_fifo_pass_done_reg[select_mux] <= 0;
                       enable_mux_reg <= 0;
                       select_mux_reg <= select_mux + 1;
                       send_data_delay_accum_reg <= send_data_delay_count;
                       idle_delay_accum_reg <= idle_delay_count;
                       //s_axis_tlast_count_reg <= 0;
                    end 
                    
                    
    
        
                    
            
            end
            end
            
            
            
            //STEAL_CLOCK:begin
            
            //if (M_AXIS_TLAST == 0)
                //  begin
                //select_mux_reg <= select_mux + 1;
                    //enable_mux_reg <= 0;
                
                //out_exec_state <= IDLE;
            //end
            
               //end
    
            endcase
//	    end
	    
//	    else begin
//            enable_mux_reg <= 0;
            
//            end
	    
	       
	    
	end
	
	
	// Control rx state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (rst) 
	  // Synchronous reset (active low)
	    begin
	      enable_dmux_reg <= 0;
	      drop_dmux_reg <= 0;
	      s_axis_tready_local_reg <= 0;
//	      S_AXIS_TREADY_REG  <= 0;
//	      to_dmux_ch_fifo_axis_tvalid_reg <= 0;
	      mst_exec_state <= IDLE;
	      initial_fifo_pass_reg <= 0;
	      hdr_byte_cnt_reg <= 0;
	      select_dmux_reg <= 0;
	      just_after_reset_reg <= 1;
//	      L_AXIS_TVALID_REG <= 0;
//	      L_AXIS_TDATA_REG <= 0;
	      
	    end  
	  else
//	  if(cfg_seq_disable == 0) begin
	  
	    	    case (mst_exec_state)
	      IDLE: begin
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
//	          if (S_AXIS_TVALID)
//	            begin
	              mst_exec_state <= GET_HDR;
	              s_axis_tready_local_reg <= 1;
	              //L_AXIS_TVALID_REG <= 0;
	              enable_dmux_reg <= 0;
	              status2_out_reg <= 0;
//	            end
//	          else
//	            begin
//	              mst_exec_state <= IDLE;
//	              s_axis_tready_local_reg <= 1;
//	              enable_dmux_reg <= 0;
//	            end
	           
	         
	        end
	      GET_HDR: begin
              if (S_AXIS_TVALID)
                    begin
                    
                       if (hdr_byte_cnt == 0) begin
                            enable_dmux_reg <= 0;
                           rtp_hdr_b0 <= S_AXIS_TDATA;
                           hdr_byte_cnt_reg <= hdr_byte_cnt + 1;
                           s_axis_tready_local_reg <= 1;
                       end else if(hdr_byte_cnt == 1) begin                       
                           rtp_hdr_b1 <= S_AXIS_TDATA;
                           hdr_byte_cnt_reg <= hdr_byte_cnt + 1;
                           s_axis_tready_local_reg <= 0;
                            mst_exec_state <= DMUX_PKT;
                            enable_dmux_reg <= 0;
                            if(just_after_reset == 1) begin
                               update_mux_sel_reg <= 1;
                               just_after_reset_reg <= 0;
                           end
                        end
	           end 
	           
	           
	           
	           
	           end
	      DMUX_PKT:
	      begin
	           
//               if(missing_pkt_reg == 0) begin    
////	               select_dmux_reg <= select_dmux_reg + 1 + (curr_hdr_seq_num - (prev_hdr_seq_num+1));
                    
                    if(cfg_seq_disable == 0) begin
                        select_dmux_reg <= curr_hdr_seq_num[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
                        initial_fifo_pass_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 1;
                    end
//                    select_dmux_reg <= rtp_hdr_b0[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
//                    initial_fifo_pass_reg[rtp_hdr_b0[$clog2(S_COUNT)-1:0]] = 1;

	               mst_exec_state <= WRITE_FIFO;
	               hdr_byte_cnt_reg <= 0;
	               //s_axis_tready_local_reg <= 0;//dmux takes over
	               enable_dmux_reg <= 1;
	               status2_out_reg <= 0;
	               s_axis_tready_local_reg <= 0;
//	               if(cfg_seq_disable == 0) begin
//                       s_axis_tready_local_reg <= 0;                       
//                    end
//                    else begin
//                       s_axis_tready_local_reg <= M_AXIS_TREADY;
////                       L_AXIS_TVALID_REG <= 0;     

//                    end
	               
	               
	               
//	           end else begin
	               
//	           end
	            
	      end      
	      WRITE_FIFO: begin
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if (S_AXIS_TLAST == 1)
	          begin
	            mst_exec_state <= IDLE;
	            enable_dmux_reg <= 0;
	            s_axis_tready_local_reg <= 0;
	            status2_out_reg <= 1;
	            //L_AXIS_TVALID_REG <=  0;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
	            enable_dmux_reg <= 1;
	            status2_out_reg <= 0;
	            mst_exec_state <= WRITE_FIFO;
	            
	            
	            
	          end
	          
	         update_mux_sel_reg <= 0;
	          
            end
	    endcase
	    
	    
	    if (initial_fifo_pass_done[select_mux] == 1)begin
             initial_fifo_pass_reg[select_mux] <= 0;
        end
	    
//	    end 
//	    else begin
           
               
////            s_axis_tready_dmux_reg <= 0;
////            to_dmux_ch_fifo_axis_tdata_reg <= 0;
////            to_dmux_ch_fifo_axis_tvalid_reg <= 0;
////            to_dmux_ch_fifo_axis_tlast_reg <= 0;
////            S_AXIS_TREADY_REG = 0;
            
            
//              case (mst_exec_state)
//              IDLE: begin
//                // The sink starts accepting tdata when 
//                // there tvalid is asserted to mark the
//                // presence of valid streaming data 
//    //	          if (S_AXIS_TVALID)
//    //	            begin
//                      mst_exec_state <= GET_HDR;
////                      s_axis_tready_local_reg <= 1;
//                      S_AXIS_TREADY_REG = 1;
////                      M_AXIS_TVALID_REG <= 0;
//                      enable_dmux_reg <= 0;
//                      status2_out_reg <= 0;
//                      hdr_byte_cnt_reg <= 0;
//    //	            end
//    //	          else
//    //	            begin
//    //	              mst_exec_state <= IDLE;
//    //	              s_axis_tready_local_reg <= 1;
//    //	              enable_dmux_reg <= 0;
//    //	            end
                   
                 
//                end
//              GET_HDR: begin
//                  if (S_AXIS_TVALID)
//                        begin
                        
//                           if (hdr_byte_cnt == 0) begin
//                                enable_dmux_reg <= 0;
//                               rtp_hdr_b0 <= S_AXIS_TDATA;
//                               hdr_byte_cnt_reg <= hdr_byte_cnt + 1;
////                               s_axis_tready_local_reg <= 1;
//                               S_AXIS_TREADY_REG = 1;
////                               M_AXIS_TVALID_REG <= 0;
//                               mst_exec_state <= GET_HDR;
//                           end else if(hdr_byte_cnt == 1) begin                       
//                               rtp_hdr_b1 <= S_AXIS_TDATA;
//                               hdr_byte_cnt_reg <= hdr_byte_cnt + 1;
////                               s_axis_tready_local_reg <= 0;
//                               S_AXIS_TREADY_REG = 0;
////                               M_AXIS_TVALID_REG <= 0;
//                                mst_exec_state <= DMUX_PKT;
//                                enable_dmux_reg <= 0;
//                                if(just_after_reset == 1) begin
////                                   update_mux_sel_reg <= 1;
//                                   just_after_reset_reg <= 0;
//                               end
                               
//                               //hdr_byte_cnt_reg <= 0;
//                               //     s_axis_tready_local_reg <= M_AXIS_TREADY;
//                               //     M_AXIS_TDATA_REG  <= S_AXIS_TDATA;
//                               //     M_AXIS_TVALID_REG <= S_AXIS_TVALID;
//                               //     M_AXIS_TLAST_REG <= S_AXIS_TLAST;
                                
                               
                               
//                            end
//                   end 
                   
                   
                   
                   
//                   end
                   
//              DMUX_PKT:
//          begin
           
////               if(missing_pkt_reg == 0) begin    
//////	               select_dmux_reg <= select_dmux_reg + 1 + (curr_hdr_seq_num - (prev_hdr_seq_num+1));
////                    select_dmux_reg <= curr_hdr_seq_num[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
//                    //initial_fifo_pass_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 1;
////                    select_dmux_reg <= rtp_hdr_b0[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
////                    initial_fifo_pass_reg[rtp_hdr_b0[$clog2(S_COUNT)-1:0]] = 1;

//                   mst_exec_state <= WRITE_FIFO;
//                   hdr_byte_cnt_reg <= 0;
////                   s_axis_tready_local_reg <= 0;//dmux takes over
////                   enable_dmux_reg <= 1;
//                   status2_out_reg <= 0;
                   
////                   s_axis_tready_local_reg <= M_AXIS_TREADY;
//                   S_AXIS_TREADY_REG <=  M_AXIS_TREADY;
////                    M_AXIS_TDATA_REG  <= S_AXIS_TDATA;
////                    M_AXIS_TVALID_REG <= S_AXIS_TVALID;
////                    M_AXIS_TLAST_REG <= S_AXIS_TLAST;
                   
////                   m_patch_axis_tdata_reg <= S_AXIS_TDATA;
////                   m_patch_axis_tvalid_reg <= S_AXIS_TVALID;
////                   m_patch_axis_tlast_reg  <= S_AXIS_TLAST;
////                   m_patch_axis_tready_reg             
//                   m_patch_axis_reg <= 1;
                   
                
          
////	           end else begin
                   
////	           end
                
//          end      
//              WRITE_FIFO: begin
//                // When the sink has accepted all the streaming input data,
//                // the interface swiches functionality to a streaming master
//                status2_out_reg <= 0;
//                hdr_byte_cnt_reg <= 0;
//                if (S_AXIS_TLAST == 1)
//                  begin
//                    mst_exec_state <= IDLE;
//                    enable_dmux_reg <= 0;
                    
//                    status2_out_reg <= 1;
                    
////                     s_axis_tready_local_reg <= 0;
//                     S_AXIS_TREADY_REG <=  0;
//                     m_patch_axis_reg <= 0;
                     
//    //                S_AXIS_TREADY_REG <= 0;
//    //                M_AXIS_TDATA_REG  <= 0;
//    //                M_AXIS_TVALID_REG <= 0;
    
////                    M_AXIS_TDATA_REG  <= S_AXIS_TDATA;
////                    M_AXIS_TVALID_REG <= S_AXIS_TVALID;
////                    M_AXIS_TLAST_REG <= S_AXIS_TLAST;
                    
                    
                   
                    
                    
//                  end
//                else
//                  begin
//                    // The sink accepts and stores tdata 
//                    // into FIFO
//                    enable_dmux_reg <= 0;
//                    status2_out_reg <= 0;
//                    mst_exec_state <= WRITE_FIFO;
////                    s_axis_tready_local_reg <= M_AXIS_TREADY;
//                    S_AXIS_TREADY_REG <=  M_AXIS_TREADY;
////                    M_AXIS_TDATA_REG  <= S_AXIS_TDATA;
////                    M_AXIS_TVALID_REG <= S_AXIS_TVALID;
////                    M_AXIS_TLAST_REG <= S_AXIS_TLAST;
//                  end
                  
//                 update_mux_sel_reg <= 0;
                  
//                end
                
                
//            endcase
	    
	    
//	    end
	    
	    
	    
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
//    .m_axis_tid(),
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
    .ADDR_WIDTH(12),
    .DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
    .KEEP_ENABLE(0),
    .ID_ENABLE(0),
    .DEST_ENABLE(0),
    .USER_ENABLE(1),
    .USER_WIDTH(1),
    .FRAME_FIFO(0)
) from_dmux_to_mux_payload_fifo (
    .clk(clk),
    .rst(rst),

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
	






//    assign S_AXIS_TREADY = M_AXIS_TREADY;
//	assign M_AXIS_TDATA  = S_AXIS_TDATA;
//	assign M_AXIS_TVALID = S_AXIS_TVALID;
//	assign M_AXIS_TLAST = S_AXIS_TLAST;

	// User logic ends

	endmodule

//`timescale 1 ns / 1 ps

//	module user_org_pkt_seq_ip_v1_0_fm_udp_s_axis #
//	(
//		// Users to add parameters here
//        parameter integer RTP_HDR_DATA_WIDTH	= 8*20,
//        parameter integer RTP_HDR_BCNT_WIDTH	= 5, // 20 bytes
//        parameter integer RTP_HDR_SEQ_WIDTH	= 16,
//	    parameter integer SHIFTS_PER_MILLISECOND = 17,
//	    parameter integer DELAY_COUNT_WIDTH = 64,
//        parameter S_COUNT = 16,
//		// User parameters ends
//		// Do not modify the parameters beyond this line

//		// AXI4Stream sink: Data Width
//		parameter integer C_S_AXIS_TDATA_WIDTH	= 8,
//		// Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
//		parameter integer C_M_AXIS_TDATA_WIDTH	= 8,
//		// Start count is the number of clock cycles the master will wait before initiating/issuing any transaction.
//		parameter integer C_M_START_COUNT	= 32
//	)
//	(
//		// Users to add ports here
//        input  wire       clk,
   
//        input  wire       rst,
//		// User ports ends
//		// Do not modify the ports beyond this line

//		// AXI4Stream sink: Clock
//		input wire  S_AXIS_ACLK,
//		// AXI4Stream sink: Reset
//		input wire  S_AXIS_ARESETN,
//		// Ready to accept data in
//		output wire  S_AXIS_TREADY,
//		// Data in
//		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
//		// Byte qualifier
////		input wire [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] S_AXIS_TSTRB,
//		// Indicates boundary of last packet
//		input wire  S_AXIS_TLAST,
//		// Data is in valid
//		input wire  S_AXIS_TVALID,
		
		
//		// Global ports to audio
//		input wire  M_AXIS_ACLK,
//		// 
//		input wire  M_AXIS_ARESETN,
//		// Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
//		output wire  M_AXIS_TVALID,
//		// TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
//		output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
//		// TSTRB is the byte qualifier that indicates whether the content of the associated byte of TDATA is processed as a data byte or a position byte.
////		output wire [(C_M_AXIS_TDATA_WIDTH/8)-1 : 0] M_AXIS_TSTRB,
//		// TLAST indicates the boundary of a packet.
//		output wire  M_AXIS_TLAST,
//		// TREADY indicates that the slave can accept a transfer in the current cycle.
//		input wire  M_AXIS_TREADY,
		
		
//		input wire  [S_COUNT-1:0] cfg_tlast_count_to_drop_in,// now ms
//		input wire  [$clog2(S_COUNT)-1:0] cfg_seq_reset,
//		input wire cfg_seq_disable,
		
//		output  wire       status1_out,
//        output  wire       status2_out
        
//	);
//	// function called clogb2 that returns an integer which has the 
//	// value of the ceiling of the log base 2.
//	function integer clogb2 (input integer bit_depth);
//	  begin
//	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
//	      bit_depth = bit_depth >> 1;
//	  end
//	endfunction

//	// Total number of input data.
////	localparam NUMBER_OF_INPUT_WORDS  = 8;
//	// bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
////	localparam bit_num  = clogb2(NUMBER_OF_INPUT_WORDS-1);
//	// Define the states of state machine
//	// The control state machine oversees the writing of input streaming data to the FIFO,
//	// and outputs the streaming data from the FIFO
//	parameter [2:0] IDLE = 3'b000,        // This is the initial/idle state 
//                    GET_HDR = 3'b001,        // 
//                    DMUX_PKT = 3'b010,
//	                WRITE_FIFO  = 3'b011; // In this state FIFO is written with the
//	                                    // input stream data S_AXIS_TDATA 
	                                    
//	parameter [2:0] CHECK_OCC = 3'b001,        // 
//                    SEL_FIFO = 3'b010,
//	                SEND_DATA  = 3'b011,
//			STEAL_CLOCK = 3'b100;                                    
	                                    
//	wire  	s_axis_tready_dmux;
//	reg  	s_axis_tready_dmux_reg;
	
//	wire  	s_axis_tready_local;
//	reg  	s_axis_tready_local_reg;
	
//	reg       status1_out_reg;
//    reg       status2_out_reg;
	
//	// State variable
//	reg [2:0] mst_exec_state; 
//	reg [2:0] out_exec_state;  
//	// FIFO implementation signals
////	genvar byte_index;     
//	// FIFO write enable
////	wire fifo_wren;
//	// FIFO full flag
////	reg fifo_full_flag;
//	// FIFO write pointer
////	reg [bit_num-1:0] write_pointer;
//	// sink has accepted all the streaming data and stored in FIFO
////	  reg writes_done;
	  
//	  wire [RTP_HDR_DATA_WIDTH-1:0] rtp_header;
	  
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b0;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b1;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b2;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b3;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b4;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b5;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b6;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b7;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b8;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b9;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b10;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b11;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b12;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b13;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b14;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b15;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b16;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b17;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b18;
//	  reg [C_S_AXIS_TDATA_WIDTH-1:0] rtp_hdr_b19;
	  
	  
//	  reg [RTP_HDR_BCNT_WIDTH-1:0] hdr_byte_cnt_reg;
//	  wire [RTP_HDR_BCNT_WIDTH-1:0] hdr_byte_cnt;
	  
//	  wire [RTP_HDR_SEQ_WIDTH-1:0] curr_hdr_seq_num;
//	  //reg [RTP_HDR_SEQ_WIDTH-1:0] curr_hdr_seq_num_reg;
	  
//	  //wire [RTP_HDR_SEQ_WIDTH-1:0] prev_hdr_seq_num;
//	  //reg [RTP_HDR_SEQ_WIDTH-1:0] prev_hdr_seq_num_reg;

	  
	  

	  
	  
//wire [S_COUNT*C_S_AXIS_TDATA_WIDTH-1:0] from_dmux_ch1_fifo_axis_tdata;
//wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tvalid;
//wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tready;
//wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tlast;
//wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tuser;


//wire [S_COUNT*C_S_AXIS_TDATA_WIDTH-1:0]  to_mux_ch1_fifo_axis_tdata;
//wire [S_COUNT-1:0] to_mux_ch1_fifo_axis_tvalid;
//wire [S_COUNT-1:0] to_mux_ch1_fifo_axis_tready;
//wire [S_COUNT-1:0] to_mux_ch1_fifo_axis_tlast;
//wire [S_COUNT-1:0] to_mux_ch1_fifo_axis_tuser;


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




//reg [$clog2(S_COUNT)-1:0]    s_axis_tlast_count_reg;
//wire [$clog2(S_COUNT)-1:0]    s_axis_tlast_count;


//reg [S_COUNT-1:0]    initial_fifo_pass_reg;
//wire [S_COUNT-1:0]   initial_fifo_pass;

//reg [S_COUNT-1:0]    initial_fifo_pass_done_reg;
//wire [S_COUNT-1:0]   initial_fifo_pass_done;
//wire [DELAY_COUNT_WIDTH-1:0] send_data_delay_count = cfg_tlast_count_to_drop_in << SHIFTS_PER_MILLISECOND;
//reg [DELAY_COUNT_WIDTH-1:0] send_data_delay_accum_reg;
//wire [DELAY_COUNT_WIDTH-1:0] send_data_delay_accum;
//wire send_data_timeup;


//wire [DELAY_COUNT_WIDTH-1:0] idle_delay_count = cfg_tlast_count_to_drop_in << SHIFTS_PER_MILLISECOND;
//reg [DELAY_COUNT_WIDTH-1:0] idle_delay_accum_reg;
//wire [DELAY_COUNT_WIDTH-1:0] idle_delay_accum;

//initial idle_delay_accum_reg = 16'hFFFF_FFFF_FFFF_FFFF;
//initial send_data_delay_accum_reg = 16'hFFFF_FFFF_FFFF_FFFF;
//wire idle_timeup;

//reg just_after_reset_reg;
//wire just_after_reset;

//reg update_mux_sel_reg;
//wire update_mux_sel;


//assign update_mux_sel = update_mux_sel_reg;

//assign just_after_reset = just_after_reset_reg;

//assign send_data_timeup = (send_data_delay_accum == 1);

//assign send_data_delay_accum = send_data_delay_accum_reg;
//assign idle_delay_accum = idle_delay_accum_reg;

//assign idle_timeup = (idle_delay_accum == 1);

//assign s_axis_tlast_count = s_axis_tlast_count_reg;

//assign select_dmux = select_dmux_reg;
//assign enable_dmux = enable_dmux_reg;
//assign drop_dmux = drop_dmux_reg;

//assign select_mux = select_mux_reg;
//assign enable_mux = enable_mux_reg;


////assign curr_hdr_seq_num = curr_hdr_seq_num_reg;
//assign s_axis_tready_local = s_axis_tready_local_reg;
	  
//assign initial_fifo_pass = initial_fifo_pass_reg;
//assign initial_fifo_pass_done = initial_fifo_pass_done_reg;

//assign status1_out = status1_out_reg;
//assign status2_out = status2_out_reg;

//assign hdr_byte_cnt = hdr_byte_cnt_reg; 

//// I/O Connections assignments
//assign rtp_header = {rtp_hdr_b0, rtp_hdr_b2, rtp_hdr_b3,
//                        rtp_hdr_b4, rtp_hdr_b5, rtp_hdr_b6, 
//                        rtp_hdr_b7, rtp_hdr_b8, rtp_hdr_b9,
//                        rtp_hdr_b10, rtp_hdr_b11, rtp_hdr_b12,
//                        rtp_hdr_b13, rtp_hdr_b14, rtp_hdr_b15,
//                        rtp_hdr_b16, rtp_hdr_b17, rtp_hdr_b18,
//                        rtp_hdr_b19};	
                        
//assign curr_hdr_seq_num = {rtp_hdr_b1, rtp_hdr_b0};                   
                            



//assign S_AXIS_TREADY = s_axis_tready_local || s_axis_tready_dmux;

	
	
	
//		// Control tx state machine implementation
//	always @(posedge S_AXIS_ACLK) 
//	begin  
//	  if (rst) 
//	  // Synchronous reset (active low)
//	    begin
//	      out_exec_state <= IDLE;
//	      enable_mux_reg <= 0;
//	      initial_fifo_pass_done_reg <= 0;
//	      s_axis_tlast_count_reg <= 0;
//	      select_mux_reg <= 0;
//	      send_data_delay_accum_reg <= send_data_delay_count;
//	      idle_delay_accum_reg <= idle_delay_count;
//	    end  
//	  else
	  
//	  if(cfg_seq_disable) begin
	  
//	  end
	  
//	    case (out_exec_state)
	    
//	    IDLE:begin
//	               status1_out_reg <= 1;
	               
	               
	               
//                   if((initial_fifo_pass[select_mux] == 1))begin
////                       out_exec_state <= SEND_DATA;
//                         out_exec_state <= SEL_FIFO;
//                         initial_fifo_pass_done_reg[select_mux] <= 1;
//			             idle_delay_accum_reg <= idle_delay_count;
////                       enable_mux_reg <= 1;
//                   end
//                   else begin
                           
//                       idle_delay_accum_reg <= (idle_timeup ? idle_delay_count : idle_delay_accum) - 1;
                      
//                        if(idle_timeup == 1) begin
//                           select_mux_reg <= select_mux + 1;
//                        end 
                        
//                        if(update_mux_sel==1) begin
//                            select_mux_reg <= curr_hdr_seq_num[$clog2(S_COUNT)-1:0];
//                        end
                    
//                    end
                   
//	           end
//	      SEL_FIFO:begin
////	           select_mux_reg <= select_mux + 1;
//	           status1_out_reg <= 0;
		   
//	           if(initial_fifo_pass[select_mux] == 0) begin
//		       //out_exec_state <= SEND_DATA;
//		       enable_mux_reg <= 1;
//		       initial_fifo_pass_done_reg[select_mux] <= 0;
//	           end	  
		   
		   
//		   if(initial_fifo_pass[select_mux] == 0 && M_AXIS_TLAST == 0) begin
//		       out_exec_state <= SEND_DATA;
//		       enable_mux_reg <= 1;
//		       initial_fifo_pass_done_reg[select_mux] <= 0;
//	           end	                   
	           
	           
//	           end
//	      SEND_DATA: begin
//	        idle_delay_accum_reg <= 0;
//	        if (M_AXIS_TLAST == 1)
//	          begin
//	            out_exec_state <= IDLE;
//	            initial_fifo_pass_done_reg[select_mux] <= 0;
//	            status1_out_reg <= 0;
//	            //s_axis_tlast_count_reg <= 0;
//	            select_mux_reg <= select_mux + 1;
//	            enable_mux_reg <= 1;
//	          end
//	        else
//	          begin
//	            // The sink accepts and stores tdata 
//	            // into FIFO
//	            status1_out_reg <= 0;
//	            if(send_data_timeup == 1) begin
//	               out_exec_state <= IDLE;
//	               initial_fifo_pass_done_reg[select_mux] <= 0;
//	               enable_mux_reg <= 0;
//	               select_mux_reg <= select_mux + 1;
//		       send_data_delay_accum_reg <= send_data_delay_count;
//		       idle_delay_accum_reg <= idle_delay_count;
//	               //s_axis_tlast_count_reg <= 0;
//	            end 
	            
//	            send_data_delay_accum_reg <= (send_data_timeup ? send_data_delay_count : send_data_delay_accum) - 1;

    
	            
		
//		end
//		end
		
//		//STEAL_CLOCK:begin
		
//		//if (M_AXIS_TLAST == 0)
//	        //  begin
//		    //select_mux_reg <= select_mux + 1;
//	            //enable_mux_reg <= 0;
		    
//		    //out_exec_state <= IDLE;
//		//end
		
//	       //end

//	    endcase
	    
	    
	       
	    
//	end
	
	
//	// Control rx state machine implementation
//	always @(posedge S_AXIS_ACLK) 
//	begin  
//	  if (rst) 
//	  // Synchronous reset (active low)
//	    begin
//	      enable_dmux_reg <= 0;
//	      drop_dmux_reg <= 0;
//	      s_axis_tready_local_reg <= 0;
//	      mst_exec_state <= IDLE;
//	      initial_fifo_pass_reg <= 0;
//	      hdr_byte_cnt_reg <= 0;
//	      select_dmux_reg <= 0;
//	      just_after_reset_reg <= 1;
//	    end  
//	  else
	  
	  
	        
//	    case (mst_exec_state)
//	      IDLE: begin
//	        // The sink starts accepting tdata when 
//	        // there tvalid is asserted to mark the
//	        // presence of valid streaming data 
////	          if (S_AXIS_TVALID)
////	            begin
//	              mst_exec_state <= GET_HDR;
//	              s_axis_tready_local_reg <= 1;
//	              enable_dmux_reg <= 0;
//	              status2_out_reg <= 0;
////	            end
////	          else
////	            begin
////	              mst_exec_state <= IDLE;
////	              s_axis_tready_local_reg <= 1;
////	              enable_dmux_reg <= 0;
////	            end
	           
	         
//	        end
//	      GET_HDR: begin
//              if (S_AXIS_TVALID)
//                    begin
                    
//                       if (hdr_byte_cnt == 0) begin
//                            enable_dmux_reg <= 0;
//                           rtp_hdr_b0 <= S_AXIS_TDATA;
//                           hdr_byte_cnt_reg <= hdr_byte_cnt + 1;
//                           s_axis_tready_local_reg <= 1;
//                       end else if(hdr_byte_cnt == 1) begin                       
//                           rtp_hdr_b1 <= S_AXIS_TDATA;
//                           hdr_byte_cnt_reg <= hdr_byte_cnt + 1;
//                           s_axis_tready_local_reg <= 0;
//                            mst_exec_state <= DMUX_PKT;
//                            enable_dmux_reg <= 0;
//                            if(just_after_reset == 1) begin
//                               update_mux_sel_reg <= 1;
//                               just_after_reset_reg <= 0;
//                           end
//                        end
//	           end 
	           
	           
	           
	           
//	           end
//	      DMUX_PKT:
//	      begin
	           
////               if(missing_pkt_reg == 0) begin    
//////	               select_dmux_reg <= select_dmux_reg + 1 + (curr_hdr_seq_num - (prev_hdr_seq_num+1));
//                    select_dmux_reg <= curr_hdr_seq_num[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
//                    initial_fifo_pass_reg[curr_hdr_seq_num[$clog2(S_COUNT)-1:0]] <= 1;
////                    select_dmux_reg <= rtp_hdr_b0[$clog2(S_COUNT)-1:0];//Packets buffer aligned always
////                    initial_fifo_pass_reg[rtp_hdr_b0[$clog2(S_COUNT)-1:0]] = 1;

//	               mst_exec_state <= WRITE_FIFO;
//	               hdr_byte_cnt_reg <= 0;
//	               s_axis_tready_local_reg <= 0;//dmux takes over
//	               enable_dmux_reg <= 1;
//	               status2_out_reg <= 0;
	               
	               
////	           end else begin
	               
////	           end
	            
//	      end      
//	      WRITE_FIFO: begin
//	        // When the sink has accepted all the streaming input data,
//	        // the interface swiches functionality to a streaming master
//	        if (S_AXIS_TLAST == 1)
//	          begin
//	            mst_exec_state <= IDLE;
//	            enable_dmux_reg <= 0;
//	            s_axis_tready_local_reg <= 0;
//	            status2_out_reg <= 1;
//	          end
//	        else
//	          begin
//	            // The sink accepts and stores tdata 
//	            // into FIFO
//	            enable_dmux_reg <= 1;
//	            status2_out_reg <= 0;
//	            mst_exec_state <= WRITE_FIFO;
//	          end
	          
//	         update_mux_sel_reg <= 0;
	          
//            end
//	    endcase
	    
	    
//	    if (initial_fifo_pass_done[select_mux_reg] == 1)begin
//             initial_fifo_pass_reg[select_mux_reg] <= 0;
//        end
//	end
	
	



//	// Add user logic here




//axis_demux #(
//    .M_COUNT (S_COUNT),
//    .DATA_WIDTH (C_S_AXIS_TDATA_WIDTH),
//    .KEEP_ENABLE (0),
//    .KEEP_WIDTH (1),
//    .ID_ENABLE (0),
//    .ID_WIDTH (1),
//    .DEST_ENABLE (0),
//    .DEST_WIDTH (1),
//    .USER_ENABLE (1),
//    .USER_WIDTH (1)
//) packet_demux
//(
//    .clk(clk),
//    .rst(rst),
//    /*
//     * AXI input
//     */
//    .s_axis_tdata(S_AXIS_TDATA),
//    .s_axis_tkeep(0),
//    .s_axis_tvalid(S_AXIS_TVALID),
//    .s_axis_tready(s_axis_tready_dmux),
//    .s_axis_tlast(S_AXIS_TLAST),
//    .s_axis_tid(0),
//    .s_axis_tdest(0),
//    .s_axis_tuser(0),

//    /*
//     * AXI outputs
//     */
//    .m_axis_tdata(from_dmux_ch1_fifo_axis_tdata),
//    .m_axis_tkeep(),
//    .m_axis_tvalid(from_dmux_ch1_fifo_axis_tvalid),
//    .m_axis_tready(from_dmux_ch1_fifo_axis_tready),
//    .m_axis_tlast(from_dmux_ch1_fifo_axis_tlast),
//    .m_axis_tid(),
//    .m_axis_tdest(),
//    .m_axis_tuser(from_dmux_ch1_fifo_axis_tuser),

//    /*
//     * Control
//     */
//    .enable(enable_dmux),
//    .drop(drop_dmux),
//    .select(select_dmux)
//);

	
//axis_mux #(
//   .S_COUNT(S_COUNT),
//    .DATA_WIDTH(C_M_AXIS_TDATA_WIDTH),
//    .KEEP_ENABLE(0),
//    .KEEP_WIDTH (1),
//    .ID_ENABLE(0),
//    .ID_WIDTH(1),
//    .DEST_ENABLE(0),
//    .DEST_WIDTH(1),
//    .USER_ENABLE(1),
//    .USER_WIDTH(1)
//)
//packet_mux(
//    .clk(clk),
//    .rst(rst),

//    /*
//     * AXI inputs from the fifo masters
//     */
//    .s_axis_tdata(to_mux_ch1_fifo_axis_tdata),
//    .s_axis_tkeep(0),
//    .s_axis_tvalid(to_mux_ch1_fifo_axis_tvalid),
//    .s_axis_tready(to_mux_ch1_fifo_axis_tready),
//    .s_axis_tlast(to_mux_ch1_fifo_axis_tlast),
//    .s_axis_tid(0),
//    .s_axis_tdest(0),
//    .s_axis_tuser(0),

//    /*
//     * AXI output to audio core ch1
//     */
//    .m_axis_tdata(M_AXIS_TDATA),
//    .m_axis_tkeep(),
//    .m_axis_tvalid(M_AXIS_TVALID),
//    .m_axis_tready(M_AXIS_TREADY),
//    .m_axis_tlast(M_AXIS_TLAST),
////    .m_axis_tid(),
//    .m_axis_tdest(),
//    .m_axis_tuser(),

//    /*
//     * Control
//     */
//    .enable(enable_mux),
//    .select(select_mux)  //must be occupied and pointed to
//);

	
//genvar i;
//generate for (i=0; i<S_COUNT; i=i+1) begin:	ch1_fifo_bank
//axis_fifo #(
//    .ADDR_WIDTH(12),
//    .DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
//    .KEEP_ENABLE(0),
//    .ID_ENABLE(0),
//    .DEST_ENABLE(0),
//    .USER_ENABLE(1),
//    .USER_WIDTH(1),
//    .FRAME_FIFO(0)
//) from_dmux_to_mux_payload_fifo (
//    .clk(clk),
//    .rst(rst),

//    // AXIS input from udp core
//    .s_axis_tdata(from_dmux_ch1_fifo_axis_tdata[i*C_S_AXIS_TDATA_WIDTH +: C_S_AXIS_TDATA_WIDTH]),
//    .s_axis_tkeep(0),//must default to high in docs but its very bad
//    .s_axis_tvalid(from_dmux_ch1_fifo_axis_tvalid[i]),
//    .s_axis_tready(from_dmux_ch1_fifo_axis_tready[i]),
//    .s_axis_tlast(from_dmux_ch1_fifo_axis_tlast[i]),
//    .s_axis_tid(0),
//    .s_axis_tdest(0),
//    .s_axis_tuser(from_dmux_ch1_fifo_axis_tuser[i]),

//    // AXI output to audo core
//    .m_axis_tdata(to_mux_ch1_fifo_axis_tdata[i*C_S_AXIS_TDATA_WIDTH +: C_S_AXIS_TDATA_WIDTH]),
//    .m_axis_tkeep(),
//    .m_axis_tvalid(to_mux_ch1_fifo_axis_tvalid[i]),
//    .m_axis_tready(to_mux_ch1_fifo_axis_tready[i]),
//    .m_axis_tlast(to_mux_ch1_fifo_axis_tlast[i]),
//    .m_axis_tid(),
//    .m_axis_tdest(),
//    .m_axis_tuser(to_mux_ch1_fifo_axis_tuser[i]),

//    // Status
//    .status_overflow(),
//    .status_bad_frame(),
//    .status_good_frame()
//);
//end
//endgenerate
	






////    assign S_AXIS_TREADY = M_AXIS_TREADY;
////	assign M_AXIS_TDATA  = S_AXIS_TDATA;
//	assign M_AXIS_TVALID = S_AXIS_TVALID;
//	assign M_AXIS_TLAST = S_AXIS_TLAST;

	// User logic ends

//	endmodule
