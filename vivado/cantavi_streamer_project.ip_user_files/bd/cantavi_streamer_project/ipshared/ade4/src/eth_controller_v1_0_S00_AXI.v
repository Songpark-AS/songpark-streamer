
`timescale 1 ns / 1 ps

	module eth_controller_v1_0_S00_AXI #
	(
		// Users to add parameters here
		parameter UDP_DATA_WIDTH = 8,
        parameter UDP_IP_WIDTH = 32,
        parameter UDP_MAC_WIDTH = 48,
        parameter UDP_PORT_WIDTH = 16,
        parameter UDP_LENGTH_WIDTH = 16,
        parameter SESSION_USERS_COUNT = 5,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 8
	)
	(
		// Users to add ports here
		input wire clk_125,
        output wire reset,
        output wire [SESSION_USERS_COUNT-1:0] start,
        output wire read,
        output wire [2:0] nbytes,
        output wire [15:0] address,
        output wire [63:0] write_data,
        input wire busy,
        input wire [63:0] read_data,
        //ethernet core
        output wire [UDP_MAC_WIDTH-1:0] local_mac,
        output wire [UDP_IP_WIDTH-1:0] local_ip ,
        output wire [UDP_IP_WIDTH-1:0] gateway_ip,
        output wire [UDP_IP_WIDTH-1:0] subnet_mask,
        output wire [UDP_PORT_WIDTH-1:0] source_port,
        
        
        output wire [SESSION_USERS_COUNT*UDP_IP_WIDTH-1:0] dest_ip,
        output wire [SESSION_USERS_COUNT*UDP_PORT_WIDTH-1:0] dest_port,
        output wire [UDP_PORT_WIDTH-1:0] sync_dest_port,
        output wire [UDP_IP_WIDTH-1:0] sync_dest_ip ,
        //output wire [UDP_LENGTH_WIDTH-1:0] udp_length,
        
        
        
//        input wire [SESSION_USERS_COUNT-1:0] loop_timer,
//        input wire [SESSION_USERS_COUNT-1:0] latency_timer,
//        input wire [SESSION_USERS_COUNT-1:0] sample_fifo_timer,
//        input wire [SESSION_USERS_COUNT-1:0] net_errors,
//        input wire [SESSION_USERS_COUNT-1:0] lost_packets,
//        input wire [SESSION_USERS_COUNT-1:0] tx_packets,
//        input wire [SESSION_USERS_COUNT-1:0] rx_packets,
        input wire [1:0]  speed,
        
        output wire ctrl,
        output wire [SESSION_USERS_COUNT-1:0] udp_stream_tx_enable,
        output wire time_sync_udp_stream_tx_enable,
        output wire [SESSION_USERS_COUNT-1:0] udp_stream_rx_enable,
        input wire [SESSION_USERS_COUNT-1:0] tx_udp_hdr_ready,
        input wire [SESSION_USERS_COUNT-1:0] rx_udp_hdr_ready,
        
        //ARP Realted signals
        
        input  wire        in_arp_request_valid,
        output wire        out_arp_request_ready,
        input  wire [31:0] in_arp_request_ip,
    
        output wire        out_arp_response_valid,
        input  wire        in_arp_response_ready,
        output wire        out_arp_response_error,
        output wire [47:0] out_arp_response_mac,
        
        
        
        
        input wire [15:0]  sync_rx_pkt_count,
        input wire [15:0]  audio_rx_pkt_count,
        input wire [15:0]  mock_rx_pkt_count,
        
        input wire [15:0]  sync_tx_pkt_count,
        input wire [15:0]  audio_tx_pkt_count,
        
        input wire [31:0]  rx_stk_state,
        input wire [31:0]  bus_status, 
		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
//	localparam integer OPT_MEM_ADDR_BITS = 2;
    localparam integer OPT_MEM_ADDR_BITS = 5;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 16
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0_mac;//
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1_mac;//
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2_local_ip;//
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3_gateway_ip;//
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4_subnet_mask;//
	
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5_dest_ip;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6_dest_port;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7_dest_ip;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8_source_port;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9_dest_ip;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regA_dest_port;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regB_dest_ip;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regC_dest_port;	
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regD_dest_ip;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regE_dest_port;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10_sync_dest_ip;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11_sync_dest_port;
	
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7_loop_timer;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8_latency_timer;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9_sample_fifo_timer;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regA_net_errors;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regB_lost_packets;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regC_tx_packets;
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regD_rx_packets;	
//	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regE_length;
	
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_regF_ctrl;
	
	
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12_arp_ip1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13_arp_ip2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg14_arp_ip3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg15_arp_ip4;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg16_arp_ip5;
	
	
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg17_arp_mac1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg18_arp_mac1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg19_arp_mac2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1A_arp_mac2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1B_arp_mac3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1C_arp_mac3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1D_arp_mac4;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1E_arp_mac4;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1F_arp_mac5;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg20_arp_mac5;
	
	
	
	
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;
	reg	 aw_en;
	
	
	
	// Add user logic here
	localparam [2:0] ARPS_IDLE = 0, ARPS_SEARCH = 1, ARPS_WAIT = 2;
	   reg [1:0] arps_state;
	    reg       out_arp_request_ready_reg;
    
        reg        out_arp_response_valid_reg;
        reg        out_arp_response_error_reg;
        reg [47:0] out_arp_response_mac_reg;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	      aw_en <= 1'b1;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	          aw_en <= 1'b0;
	        end
	        else if (S_AXI_BREADY && axi_bvalid)
	            begin
	              aw_en <= 1'b1;
	              axi_awready <= 1'b0;
	            end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin //00 0a 35 00 00 01
	      slv_reg0_mac <= 24'h00_0a_35;
          slv_reg1_mac <= 24'h00_00_01;
          slv_reg2_local_ip <= {8'd192, 8'd168, 8'd1,   8'd5};
          slv_reg3_gateway_ip <= {8'd192, 8'd168, 8'd1,   8'd1};
          slv_reg4_subnet_mask<= {8'd255, 8'd255, 8'd255, 8'd0};
          slv_reg5_dest_ip <= {8'd192, 8'd168, 8'd1,   8'd2};
          slv_reg6_dest_port <= 16'd7809;
          slv_reg7_dest_ip <= {8'd192, 8'd168, 8'd1,   8'd2};
          slv_reg8_source_port <= 16'd7809;
          slv_reg9_dest_ip <= {8'd192, 8'd168, 8'd1,   8'd2};
          slv_regA_dest_port <= 16'd7809;
          slv_regB_dest_ip <= {8'd192, 8'd168, 8'd1,   8'd2};
          slv_regC_dest_port <= 16'd7809;
          slv_regD_dest_ip <= {8'd192, 8'd168, 8'd1,   8'd2};
          slv_regE_dest_port <= 16'd7809;
          slv_regF_ctrl <= 32'h7FFF_FFE1; // make sure bit [31] is 0
          slv_reg10_sync_dest_ip <= {8'd192, 8'd168, 8'd1,   8'd2};
          slv_reg11_sync_dest_port <= 16'd7809; // we use the dest port only now
         
          
//          slv_regE_length <= {SESSION_USERS_COUNT{16'd768}};

            slv_reg12_arp_ip1  <= {8'd192, 8'd168, 8'd1,   8'd2};
            slv_reg13_arp_ip2 <= {8'd192, 8'd168, 8'd1,   8'd2};
            slv_reg14_arp_ip3 <= {8'd192, 8'd168, 8'd1,   8'd2};
            slv_reg15_arp_ip4 <= {8'd192, 8'd168, 8'd1,   8'd2};
            slv_reg16_arp_ip5 <= {8'd192, 8'd168, 8'd1,   8'd2};
                
                
            slv_reg17_arp_mac1 <= 24'h00_0a_35;
            slv_reg18_arp_mac1 <= 24'h00_00_01;
            slv_reg19_arp_mac2 <= 24'h00_0a_35; 
            slv_reg1A_arp_mac2 <= 24'h00_00_02;
            slv_reg1B_arp_mac3 <= 24'h00_0a_35; 
            slv_reg1C_arp_mac3 <= 24'h00_00_03;
            slv_reg1D_arp_mac4 <= 24'h00_0a_35; 
            slv_reg1E_arp_mac4 <= 24'h00_00_04;
            slv_reg1F_arp_mac5 <= 24'h00_0a_35; 
            slv_reg20_arp_mac5 <= 24'h00_00_05;
          
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          6'h0:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 0
	                slv_reg0_mac[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end 
	          6'h1:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 1
	                slv_reg1_mac[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end 
	          6'h2:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 2
	                slv_reg2_local_ip[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h3:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 3
	                slv_reg3_gateway_ip[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h4:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 4
	                slv_reg4_subnet_mask[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h5:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_reg5_dest_ip[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h6:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg6_dest_port[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h7:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_reg7_dest_ip[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h8:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg8_source_port[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h9:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_reg9_dest_ip[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'hA:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_regA_dest_port[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'hB:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_regB_dest_ip[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'hC:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_regC_dest_port[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'hD:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_regD_dest_ip[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'hE:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_regE_dest_port[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'hF:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_regF_ctrl[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h10:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg10_sync_dest_ip[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          6'h11:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg11_sync_dest_port[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	              
	              
	           6'h12:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg12_arp_ip1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end
	              
	            6'h13:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg13_arp_ip2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end
	              
	             6'h14:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg14_arp_ip3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end
	              
	              
	              
	           6'h15:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg15_arp_ip4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end
	          6'h16:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg16_arp_ip5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end
	              
	              
	              
	           6'h17:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg17_arp_mac1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end
	              
	              
	            6'h18:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg18_arp_mac1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end    
	            6'h19:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg19_arp_mac2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end    
	              
	            6'h1A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg1A_arp_mac2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end    
	              
	            6'h1B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg1B_arp_mac3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end    
	              
	            6'h1C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg1C_arp_mac3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	              
	           6'h1D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg1D_arp_mac4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end    
	              
	              
	           6'h1E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg1E_arp_mac4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end    
	              
	              
	         6'h1F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg1F_arp_mac5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end    
	              
	         6'h20:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg20_arp_mac5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	                  
	              
	          default : begin
	                      slv_reg0_mac <= slv_reg0_mac;
	                      slv_reg1_mac <= slv_reg1_mac;
	                      slv_reg2_local_ip <= slv_reg2_local_ip;
	                      slv_reg3_gateway_ip <= slv_reg3_gateway_ip;
	                      slv_reg4_subnet_mask<=slv_reg4_subnet_mask;
	                      
	                      slv_reg5_dest_ip <= slv_reg5_dest_ip;
	                      slv_reg6_dest_port <= slv_reg6_dest_port;
	                      slv_reg7_dest_ip <= slv_reg7_dest_ip;
	                      slv_reg8_source_port <= slv_reg8_source_port;
	                      slv_reg9_dest_ip <= slv_reg9_dest_ip;
	                      slv_regA_dest_port <= slv_regA_dest_port;
	                      slv_regB_dest_ip <= slv_regB_dest_ip;
	                      slv_regC_dest_port <= slv_regC_dest_port;
	                      slv_regD_dest_ip <= slv_regD_dest_ip;
	                      slv_regE_dest_port <= slv_regE_dest_port;
//	                      slv_regE_length <= slv_regE_length;
                            slv_reg10_sync_dest_ip <= slv_reg10_sync_dest_ip;
	                           slv_reg11_sync_dest_port <= slv_reg11_sync_dest_port;
	                      
	                      slv_regF_ctrl <= slv_regF_ctrl;
	                      
	                      
	                      slv_reg12_arp_ip1 <= slv_reg12_arp_ip1;
	                      slv_reg13_arp_ip2 <= slv_reg13_arp_ip2;
	                      slv_reg14_arp_ip3 <= slv_reg14_arp_ip3;
	                      slv_reg15_arp_ip4 <= slv_reg15_arp_ip4;
	                      slv_reg16_arp_ip5 <= slv_reg16_arp_ip5;
	                      
	                      
	                      slv_reg17_arp_mac1 <= slv_reg17_arp_mac1;
	                      slv_reg18_arp_mac1 <= slv_reg18_arp_mac1;
	                      
	                      slv_reg19_arp_mac2 <= slv_reg19_arp_mac2;
	                      slv_reg1A_arp_mac2 <= slv_reg1A_arp_mac2;
	                      
	                      slv_reg1B_arp_mac3 <= slv_reg1B_arp_mac3;
	                      slv_reg1C_arp_mac3 <= slv_reg1C_arp_mac3;
	                      
	                      slv_reg1D_arp_mac4 <= slv_reg1D_arp_mac4;
	                      slv_reg1E_arp_mac4 <= slv_reg1E_arp_mac4;
	                      
	                      slv_reg1F_arp_mac5 <= slv_reg1F_arp_mac5;
	                      slv_reg20_arp_mac5 <= slv_reg20_arp_mac5;
	                      
	                    end
	        endcase
	        
	        
	        
	      end
	      
//	      slv_regE_dest_port[31]= out_arp_response_error_reg;
//	      slv_regE_dest_port[30] <= (out_arp_response_mac_reg == {slv_reg17_arp_mac1[23:0],slv_reg18_arp_mac1[23:0]}) ? 1 : 0;
//	      slv_regE_dest_port[29] <= (((in_arp_request_ip ^ gateway_ip) & subnet_mask) == 0) ? 1 : 0;
//	      slv_regE_dest_port[28] <= (~(in_arp_request_ip | subnet_mask) == 0) ? 1 : 0;
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        6'h0   : reg_data_out <= slv_reg0_mac;
	        6'h1   : reg_data_out <= slv_reg1_mac;
	        6'h2   : reg_data_out <= slv_reg2_local_ip;
	        6'h3   : reg_data_out <= slv_reg3_gateway_ip;
	        6'h4   : reg_data_out <= slv_reg4_subnet_mask;
	        
	        6'h5   : reg_data_out <= slv_reg5_dest_ip;
	        6'h6   : reg_data_out <= slv_reg6_dest_port;
	        6'h7   : reg_data_out <= slv_reg7_dest_ip;
	        6'h8   : reg_data_out <= slv_reg8_source_port;
	        6'h9   : reg_data_out <= slv_reg9_dest_ip;
	        6'hA   : reg_data_out <= slv_regA_dest_port;
	        6'hB   : reg_data_out <= slv_regB_dest_ip;
	        6'hC   : reg_data_out <= slv_regC_dest_port;
	        6'hD   : reg_data_out <= slv_regD_dest_ip;
	        6'hE   : reg_data_out <= { out_arp_response_error_reg,
	        (out_arp_response_mac_reg == {slv_reg17_arp_mac1[23:0],slv_reg18_arp_mac1[23:0]}) ? 1 : 0,
	      (((in_arp_request_ip ^ gateway_ip) & subnet_mask) == 0) ? 1 : 0,
	      (~(in_arp_request_ip | subnet_mask) == 0) ? 1 : 0, 
	      out_arp_response_valid_reg,
	      slv_regE_dest_port[32-5-1:0] };//slv_regE_dest_port;

//             6'hE   : reg_data_out <= 32'hFF_FF_FF_FF;//slv_regE_dest_port;
	        

	        6'hF   : reg_data_out <= slv_regF_ctrl;
	        
	        6'h10   : reg_data_out <= slv_reg10_sync_dest_ip;
	        6'h11   : reg_data_out <= slv_reg11_sync_dest_port;
	        
	        
	        6'h12   : reg_data_out <= slv_reg12_arp_ip1;
	        6'h13   : reg_data_out <= slv_reg13_arp_ip2;
	        6'h14   : reg_data_out <= slv_reg14_arp_ip3;
	        6'h15   : reg_data_out <= slv_reg15_arp_ip4;
	        6'h16   : reg_data_out <= slv_reg16_arp_ip5;
	        6'h17   : reg_data_out <= slv_reg17_arp_mac1;
	        6'h18   : reg_data_out <= slv_reg18_arp_mac1;
	        6'h19   : reg_data_out <= slv_reg19_arp_mac2;
	        6'h1A   : reg_data_out <= slv_reg1A_arp_mac2;
	        6'h1B   : reg_data_out <= slv_reg1B_arp_mac3;
	        6'h1C   : reg_data_out <= slv_reg1C_arp_mac3;
	        6'h1D   : reg_data_out <= slv_reg1D_arp_mac4;
	        6'h1E   : reg_data_out <= slv_reg1E_arp_mac4;
	        6'h1F   : reg_data_out <= slv_reg1F_arp_mac5;
	        6'h20   : reg_data_out <= slv_reg20_arp_mac5;//bad add additional registers when time comes 
	        6'h21   : reg_data_out <= out_arp_response_mac_reg[23:0];
	        6'h22   : reg_data_out <= out_arp_response_mac_reg[47:24];
	        6'h23   : reg_data_out <= sync_rx_pkt_count;
            6'h24   : reg_data_out <= audio_rx_pkt_count;
                
            6'h25   : reg_data_out <= sync_tx_pkt_count;
            6'h26   : reg_data_out <= audio_tx_pkt_count;
            6'h27   : reg_data_out <= mock_rx_pkt_count;
            6'h28   : reg_data_out <= rx_stk_state;
            6'h29   : reg_data_out <= bus_status;  
	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

	
        
        
        assign out_arp_response_mac = out_arp_response_mac_reg;
        assign out_arp_response_error = out_arp_response_error_reg;
        assign out_arp_response_valid = out_arp_response_valid_reg;
        assign out_arp_request_ready = out_arp_request_ready_reg;
        
        
	always @( posedge clk_125 )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      out_arp_request_ready_reg <= 0;
	      out_arp_response_error_reg <= 0;
	      out_arp_response_valid_reg <= 0;
	      arps_state <= ARPS_IDLE;
	      out_arp_response_mac_reg <= 0;
	    end 
	  else
	    begin  
	    case ( arps_state )  
	      ARPS_IDLE: begin
	           out_arp_request_ready_reg <= 1;
              if (in_arp_request_valid)
                begin
                    out_arp_request_ready_reg <= 0;
                  arps_state <= ARPS_SEARCH;     // register read data
                end 
	        end
	      ARPS_SEARCH: begin
	      
//              if(in_arp_request_valid) begin
                   out_arp_request_ready_reg <= 0;
                   out_arp_response_valid_reg <= 1;
                   out_arp_response_error_reg <= 0;
                   
                   if(in_arp_response_ready) begin
                        arps_state <= ARPS_WAIT;
                   end else begin 
                        arps_state <= ARPS_SEARCH;   
                   end
               
               
               
                    if (~(in_arp_request_ip | subnet_mask) == 0) begin
                        // broadcast address
                        // (all bits in request IP set where subnet mask is clear)
//                            out_arp_response_valid_reg <= 1'b1;
//                            out_arp_response_error_reg <= 1'b0;
                        out_arp_response_mac_reg <= 48'hffffffffffff;
                    end else if (((in_arp_request_ip ^ gateway_ip) & subnet_mask) == 0) begin
                        // within subnet, look up IP directly (we have already called run_arp() in Linux layer)
                        // (no bits differ between request IP and gateway IP where subnet mask is set)
//                            cache_query_request_valid_next <= 1'b1;
//                            cache_query_request_ip_next <= arp_request_ip;
//                            arp_request_ip_next <= arp_request_ip;
//                            out_arp_response_valid_reg <= 1'b1;
//                            out_arp_response_error_reg <= 1'b0;
                        
                        if(in_arp_request_ip == slv_reg12_arp_ip1) begin
                           out_arp_response_mac_reg <= {slv_reg17_arp_mac1[23:0],slv_reg18_arp_mac1[23:0]};//gateway MAC
                       end else if(in_arp_request_ip == slv_reg13_arp_ip2) begin
                            out_arp_response_mac_reg <= {slv_reg19_arp_mac2[23:0],slv_reg1A_arp_mac2[23:0]};
                       end else if(in_arp_request_ip == slv_reg14_arp_ip3) begin
                           out_arp_response_mac_reg <= {slv_reg1B_arp_mac3[23:0],slv_reg1C_arp_mac3[23:0]};
                       end else if(in_arp_request_ip == slv_reg15_arp_ip4) begin
                           out_arp_response_mac_reg <= {slv_reg1D_arp_mac4[23:0],slv_reg1E_arp_mac4[23:0]};
                       end else if(in_arp_request_ip == slv_reg16_arp_ip5) begin
                           out_arp_response_mac_reg <= {slv_reg1F_arp_mac5[23:0],slv_reg20_arp_mac5[23:0]};
                       end else begin
                           out_arp_response_error_reg <= 1;
                       end 

                    end else begin
                        // outside of subnet, so look up gateway address
//                            cache_query_request_valid_next <= 1'b1;
//                            cache_query_request_ip_next <= gateway_ip;
//                            arp_request_ip_next <= gateway_ip;
//                                out_arp_response_valid_reg <= 1'b1;
//                                out_arp_response_error_reg <= 1'b0;
                        
                            out_arp_response_mac_reg <= {slv_reg17_arp_mac1[23:0],slv_reg18_arp_mac1[23:0]};
                    end
                  
                   
                   
              
//              end else begin 
//                   arps_state <= ARPS_SEARCH;   
//              end
	      
	      end
	      
	      ARPS_WAIT: begin
               
//               if(in_arp_response_ready) begin
                arps_state <= ARPS_IDLE;
                out_arp_response_valid_reg <= 0;
                out_arp_request_ready_reg <= 1;
//               end
	      
	      end
	        endcase  
	        
//	         out_arp_response_error_reg <= 0;
//	        out_arp_response_valid_reg <= 1;
//	        out_arp_response_mac_reg <= {slv_reg17_arp_mac1[23:0],slv_reg18_arp_mac1[23:0]};
	        
	    end
	end    
	
	
	
	
	
	
	
    assign local_mac = {slv_reg0_mac[23:0],slv_reg1_mac[23:0]};
    assign local_ip = slv_reg2_local_ip;
    assign gateway_ip = slv_reg3_gateway_ip;
    assign subnet_mask = slv_reg4_subnet_mask;
    
    
//    assign dest_ip = {slv_reg5_dest_ip,slv_reg7_dest_ip,slv_reg9_dest_ip,slv_regB_dest_ip,slv_regD_dest_ip};
//    assign dest_port = {slv_reg6_dest_port[UDP_PORT_WIDTH-1:0], slv_reg8_source_port[UDP_PORT_WIDTH-1:0], 
//                        slv_regA_dest_port[UDP_PORT_WIDTH-1:0], slv_regC_dest_port[UDP_PORT_WIDTH-1:0], slv_regE_dest_port[UDP_PORT_WIDTH-1:0]};

    assign dest_ip = {slv_regD_dest_ip,slv_regB_dest_ip,slv_reg9_dest_ip,slv_reg7_dest_ip,slv_reg5_dest_ip};
    
    assign dest_port = { slv_regE_dest_port[UDP_PORT_WIDTH-1:0], slv_regC_dest_port[UDP_PORT_WIDTH-1:0],
                        slv_regA_dest_port[UDP_PORT_WIDTH-1:0], slv_reg6_dest_port[UDP_PORT_WIDTH-1:0]};
                        
    assign sync_dest_port = slv_reg6_dest_port[UDP_PORT_WIDTH-1:0]; // We use the same port now
    assign sync_dest_ip = slv_reg5_dest_ip; //slv_reg10_sync_dest_ip;
     
    
    assign source_port = slv_reg8_source_port[UDP_PORT_WIDTH-1:0];
    //assign udp_length =slv_regE_length; payload comes from eth_audio
    
    
    assign time_sync_udp_stream_tx_enable  = slv_regF_ctrl[0];
    assign start = slv_regF_ctrl[(1*SESSION_USERS_COUNT):1];
    assign reset = slv_regF_ctrl[31]; 
     
    assign udp_stream_tx_enable = slv_regF_ctrl[SESSION_USERS_COUNT:1];
    
    
    assign udp_stream_rx_enable  = slv_regF_ctrl[(2*SESSION_USERS_COUNT)-1:SESSION_USERS_COUNT];
    
//    assign address = slv_reg0_mac[15:0];
//    assign nbytes = slv_reg0_mac[18:16];
//    assign read = slv_reg0_mac[19];

//    assign net_speed = slv_regF_ctrl[2:1];
    
//    assign loop_timer =slv_reg7_loop_timer;
//	assign latency_timer=slv_reg8_latency_timer;
//	assign sample_fifo_timer =slv_reg9_sample_fifo_timer;
//	assign net_errors=slv_regA_net_errors;
//	assign lost_packets=slv_regB_lost_packets;
//	assign tx_packets=slv_regC_tx_packets;
//	assign rx_packets=slv_regD_rx_packets;
	
	assign ctrl=slv_regF_ctrl;
    
//    assign slv_reg1_mac = {{C_S_AXI_DATA_WIDTH-1{1'b0}}, busy};
//    assign write_data[31:0] = slv_reg2_local_ip;
//    assign write_data[63:32] = slv_reg3_gateway_ip;
//    assign slv_reg4_subnet_mask = read_data[31:0];
//    assign slv_reg5_dest_ip = read_data[63:32];
	// User logic ends

	endmodule
