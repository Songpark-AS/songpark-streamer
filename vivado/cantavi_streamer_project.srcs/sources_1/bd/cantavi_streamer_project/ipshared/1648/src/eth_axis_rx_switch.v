

//// Language: Verilog 2001

//`timescale 1ns / 1ps

///*
// * AXI4-Stream ethernet frame receiver (AXI in, Ethernet frame out)
// * This is below the eth_axis_rx layer, all bytes flow through (to PS or to CS via AXIS) no header stripping
// */
//module eth_axis_rx_switch#(
//parameter C_S_AXIS_TDATA_WIDTH = 8,
//parameter S_COUNT = 2,
//parameter RX_FIFO_DEPTH = 2048,
////parameter FIFO_ADDR_WIDTH = 6, // this is only to hold up to the UDP HDR
//parameter FIFO_DEPTH = 128
////parameter FIFO_BANK_COUNT = 2
//)
//(
//    input  wire        clk,
//    input  wire        rst,

//    /*
//     * AXI input
//     */
//    input  wire [7:0]  s_axis_tdata,
//    input  wire        s_axis_tvalid,
//    output wire        s_axis_tready,
//    input  wire        s_axis_tlast,
//    input  wire        s_axis_tuser,

//    /*
//     * UDP ports for filtering 
//     */
    
//    input wire [15:0] udp_port_1,
//    input wire [15:0] udp_port_2,
//    input wire [15:0] udp_port_3,
//    input wire [15:0] udp_port_4,
//    input wire [15:0] udp_port_5,
//    input wire [15:0] udp_port_6,
//    input wire [15:0] udp_port_7,
//    input wire [15:0] udp_port_8,
    
//    /*
//     * Ethernet frame output
//     */
////    output wire        m_eth_hdr_valid,
////    input  wire        m_eth_hdr_ready,
////    output wire [47:0] m_eth_dest_mac,
////    output wire [47:0] m_eth_src_mac,
////    output wire [15:0] m_eth_type,
    
//    output wire [7:0]  m_to_ps_axis_tdata,
//    output wire        m_to_ps_axis_tvalid,
//    input  wire        m_to_ps_axis_tready,
//    output wire        m_to_ps_axis_tlast,
//    output wire        m_to_ps_axis_tuser,
    
    
    
//    output wire [7:0]  m_to_cs_axis_tdata,
//    output wire        m_to_cs_axis_tvalid,
//    input  wire        m_to_cs_axis_tready,
//    output wire        m_to_cs_axis_tlast,
//    output wire        m_to_cs_axis_tuser,
    
    
//    output wire [15:0]  ps_rx_pkt_count,
//    output wire [15:0]  cs_rx_pkt_count,
//    output wire [31:0]  rx_sw_state,
//    output wire [31:0]  bus_status,    
        
     
//    /*
//     * Status signals
//     */
//    output wire        sel_status,
//    output wire        busy,
//    output wire        error_header_early_termination
//);

///*

//UDP Frame

// Field                                      Length
// Destination MAC address                    6 octets
// Source MAC address                         6 octets
// Ethertype (IP=0x0800 ARP=0x0806)          2 octets
// Version (4)                                4 bits
// IHL (5-15)                  4 bits
// DSCP (0)                    6 bits
// ECN (0)                     2 bits
// length                      2 octets
// identification (0?)         2 octets
// flags (010)                 3 bits
// fragment offset (0)         13 bits
// time to live (64?)          1 octet
// protocol (0x11==UDP)        1 octet
// header checksum             2 octets
// source IP                   4 octets
// destination IP              4 octets
// options                     (IHL-5)*4 octets

// source port                 2 octets
// desination port             2 octets
// length                      2 octets
// checksum                    2 octets

// payload                     length octets

//This module receives an Eth frame with header fields and uses them for switching 

//*/

////Ethernet ETH_TYPES

//parameter IPv4 = 16'h0800;
//parameter IPv6 = 16'h86DD;
//parameter ARP = 16'h0806;
//parameter PTP = 16'h88F7;
	
////IP Protocol IDs
//parameter UDP_LITE_ID = 8'h88;
//parameter UDP_ID = 8'h11;


//parameter [2:0]
//    STATE_IDLE = 3'd0,
//    STATE_READ_ETH_HEADER = 3'd1,
//    STATE_PROCESS_ETH_HEADER = 3'd2,
//    STATE_READ_IP_HEADER = 3'd3,
//    STATE_READ_UDP_HEADER = 3'd4,
//    STATE_READ_PAYLOAD = 3'd5,
//    STATE_SWITCHING_WAIT_CLEAR  = 3'd6;

//parameter [1:0]
//	SW_IDLE = 2'd0,
//	SW_SEL = 2'd1,
//	SW_SEND = 2'd2,
//	SW_BUF_UNLOCK = 2'd3;

//wire is_udp;

////assign is_udp =  m_eth_type == UDP_ETH_ID ? 1 : 0;

//reg [2:0] state_reg = STATE_IDLE, state_after_switch_ready;
//reg [1:0] sw_state = SW_IDLE;
//wire status_overflow;



//// datapath control signals
//// ------------------------------------------- ETH HDR data -------------------------------------


//reg [7:0] eth_hdr_ptr_reg = 8'd0;
//reg [7:0] ip_hdr_ptr_reg = 8'd0;
//reg [7:0] udp_hdr_ptr_reg = 8'd0;

//reg fsm_s_axis_tready_reg = 1'b0;

//reg m_eth_hdr_valid_reg = 1'b0;
//reg [47:0] m_eth_dest_mac_reg = 48'd0;
//reg [47:0] m_eth_src_mac_reg = 48'd0;
//reg [15:0] m_eth_type_reg = 16'd0;

//wire m_eth_hdr_valid;
//wire [47:0] m_eth_dest_mac;
//wire [47:0] m_eth_src_mac;
//wire [15:0] m_eth_type;

////-----------------------------------IP HDR data----------------------------------------
////function [15:0] add1c16b;
////    input [15:0] a, b;
////    reg [16:0] t;
////    begin
////        t = a+b;
////        add1c16b = t[15:0] + t[16];
////    end
////endfunction
//// datapath control signals


//reg m_ip_hdr_valid_reg = 1'b0;


//reg [3:0] m_ip_version_reg = 4'd0;
//reg [3:0] m_ip_ihl_reg = 4'd0;
//reg [5:0] m_ip_dscp_reg = 6'd0;
//reg [1:0] m_ip_ecn_reg = 2'd0;
//reg [15:0] m_ip_length_reg = 16'd0;
//reg [15:0] m_ip_identification_reg = 16'd0;
//reg [2:0] m_ip_flags_reg = 3'd0;
//reg [12:0] m_ip_fragment_offset_reg = 13'd0;
//reg [7:0] m_ip_ttl_reg = 8'd0;
//reg [7:0] m_ip_protocol_reg = 8'd0;
//reg [15:0] m_ip_header_checksum_reg = 16'd0;
//reg [31:0] m_ip_source_ip_reg = 32'd0;
//reg [31:0] m_ip_dest_ip_reg = 32'd0;

//wire [7:0] m_ip_protocol;


////----------------------------------------UDP HDR data -------------------------------



//reg [15:0] m_udp_source_port_reg = 16'd0;
//reg [15:0] m_udp_dest_port_reg = 16'd0;
//reg [15:0] m_udp_length_reg = 16'd0;
//reg [15:0] m_udp_checksum_reg = 16'd0;

//wire [15:0] m_udp_dest_port;
////-------------------------------------------------------------------------


//reg busy_reg = 1'b0;





//wire fsm_s_axis_tready;

//assign m_udp_dest_port = m_udp_dest_port_reg;
//assign m_eth_hdr_valid = m_eth_hdr_valid_reg;
//assign m_eth_dest_mac = m_eth_dest_mac_reg;
//assign m_eth_src_mac = m_eth_src_mac_reg;
//assign m_eth_type = m_eth_type_reg;
//assign m_ip_protocol = m_ip_protocol_reg;

////assign busy = busy_reg;

//assign busy = state_reg != STATE_IDLE;


//wire [C_S_AXIS_TDATA_WIDTH-1:0] m_to_fifo_axis_tdata;
//wire  m_to_fifo_axis_tvalid;
//wire  m_to_fifo_axis_tready;
//wire  m_to_fifo_axis_tlast;
//wire  m_to_fifo_axis_tuser;


//wire [C_S_AXIS_TDATA_WIDTH-1:0]  m_from_fifo_axis_tdata;
//wire  m_from_fifo_axis_tvalid;
//wire  m_from_fifo_axis_tready;
//wire  m_from_fifo_axis_tlast;
//wire  m_from_fifo_axis_tuser;




//wire [7:0]  m_to_ps_fifo_axis_tdata;
//wire        m_to_ps_fifo_axis_tvalid;
//wire        m_to_ps_fifo_axis_tready;
//wire        m_to_ps_fifo_axis_tlast;
//wire        m_to_ps_fifo_axis_tuser;



//wire [7:0]  m_to_cs_fifo_axis_tdata;
//wire        m_to_cs_fifo_axis_tvalid;
// wire        m_to_cs_fifo_axis_tready;
//wire        m_to_cs_fifo_axis_tlast;
//wire        m_to_cs_fifo_axis_tuser;

////reg [$clog2(FIFO_BANK_COUNT)-1:0] fifo_wr_pointer;
////reg [$clog2(FIFO_BANK_COUNT)-1:0] fifo_rd_pointer; // not a switching variable
////reg  buffer_sw_ready;
//reg  buffer_lock;
//reg  buffer_unlock;
//reg  fifo_slot_reset;

//reg  sw_var_wr;        // 0 for send to PS, 1 for send to CS
//reg  sw_var_rd; 



//wire [S_COUNT*C_S_AXIS_TDATA_WIDTH-1:0] from_dmux_ch1_fifo_axis_tdata;
//wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tvalid;
//wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tready;
//wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tlast;
//wire [S_COUNT-1:0] from_dmux_ch1_fifo_axis_tuser;

//wire [C_S_AXIS_TDATA_WIDTH-1:0]  to_dmux_ch_fifo_axis_tdata;
//wire to_dmux_ch_fifo_axis_tvalid;
//wire to_dmux_ch_fifo_axis_tready;
//wire to_dmux_ch_fifo_axis_tlast;
//wire to_dmux_ch_fifo_axis_tuser;
////assign sel_status = ((state_reg == STATE_SWITCHING_WAIT_CLEAR) ) ? 1: 0;//sw_var_rd;
////assign sel_status = ((((m_eth_type == IPv4) || (m_eth_type == IPv6)) && (m_ip_protocol == UDP_ID)) && 
////                        ((m_udp_dest_port_reg == udp_port_1) || (m_udp_dest_port_reg == udp_port_2) || 
////                        (m_udp_dest_port_reg == udp_port_3) || (m_udp_dest_port_reg == udp_port_4) || 
////                        (m_udp_dest_port_reg == udp_port_5) || (m_udp_dest_port_reg == udp_port_6) || 
////                        (m_udp_dest_port_reg == udp_port_7) || (m_udp_dest_port_reg == udp_port_8) ));

////assign sel_status = (((m_eth_type == IPv4) || (m_eth_type == IPv6)) && (m_ip_protocol_reg == UDP_ID)) ? 1 : 0;

////assign sel_status = (  ((m_udp_dest_port == udp_port_1) || (m_udp_dest_port == udp_port_2) || 
////                        (m_udp_dest_port == udp_port_3) || (m_udp_dest_port == udp_port_4) || 
////                        (m_udp_dest_port == udp_port_5) || (m_udp_dest_port == udp_port_6) || 
////                        (m_udp_dest_port == udp_port_7) || (m_udp_dest_port == udp_port_8) ));


//reg [15:0]  ps_rx_pkt_count_reg;
//reg [15:0]  cs_rx_pkt_count_reg;


//assign  rx_sw_state ={1'b0,buffer_lock,buffer_unlock,sw_var_rd, 1'b0,state_reg,2'b00,sw_state};//LSB
////assign bus_status   = {1'b0,m_from_fifo_axis_tready,m_from_fifo_axis_tvalid,m_from_fifo_axis_tlast,2'b00,buffer_unlock,sw_var_rd};
//assign bus_status   = {fsm_s_axis_tready, 1'b0,s_axis_tready,s_axis_tvalid,s_axis_tlast,
//                                          1'b0,m_to_ps_axis_tready, m_to_ps_axis_tvalid, m_to_ps_axis_tlast,
//                                          1'b0,m_to_cs_axis_tready, m_to_cs_axis_tvalid, m_to_cs_axis_tlast, 
//                                          1'b0,m_to_fifo_axis_tready,m_to_fifo_axis_tvalid,m_to_fifo_axis_tlast,
//                                          1'b0,m_from_fifo_axis_tready,m_from_fifo_axis_tvalid,m_from_fifo_axis_tlast};
        
//assign cs_rx_pkt_count = cs_rx_pkt_count_reg;
//assign ps_rx_pkt_count = ps_rx_pkt_count_reg;

////assign m_to_cs_fifo_axis_tdata = ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_from_fifo_axis_tdata : 1'b0;
////assign m_to_cs_fifo_axis_tvalid = ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_from_fifo_axis_tvalid : 1'b0;
////assign m_to_cs_fifo_axis_tlast = ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_from_fifo_axis_tlast : 1'b0;
////assign m_to_cs_fifo_axis_tuser = ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_from_fifo_axis_tuser : 1'b0;

////assign m_to_ps_fifo_axis_tdata = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_from_fifo_axis_tdata : 1'b0;
////assign m_to_ps_fifo_axis_tvalid = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_from_fifo_axis_tvalid : 1'b0;
////assign m_to_ps_fifo_axis_tlast = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_from_fifo_axis_tlast : 1'b0;
////assign m_to_ps_fifo_axis_tuser = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_from_fifo_axis_tuser : 1'b0;


//assign {m_to_cs_fifo_axis_tdata, m_to_ps_fifo_axis_tdata} = from_dmux_ch1_fifo_axis_tdata;
//assign {m_to_cs_fifo_axis_tvalid, m_to_ps_fifo_axis_tvalid} = from_dmux_ch1_fifo_axis_tvalid;
//assign {m_to_cs_fifo_axis_tlast, m_to_ps_fifo_axis_tlast} = from_dmux_ch1_fifo_axis_tlast;
//assign {m_to_cs_fifo_axis_tuser, m_to_ps_fifo_axis_tuser} = from_dmux_ch1_fifo_axis_tuser;
//assign from_dmux_ch1_fifo_axis_tready = {m_to_cs_fifo_axis_tready, m_to_ps_fifo_axis_tready};

//assign to_dmux_ch_fifo_axis_tdata = m_from_fifo_axis_tdata;
//assign to_dmux_ch_fifo_axis_tvalid = (sw_state==SW_SEND) && m_from_fifo_axis_tvalid;
//assign to_dmux_ch_fifo_axis_tlast = m_from_fifo_axis_tlast;
//assign to_dmux_ch_fifo_axis_tuser = m_from_fifo_axis_tuser;
//assign m_from_fifo_axis_tready = (sw_state==SW_SEND) && to_dmux_ch_fifo_axis_tready;



////assign m_from_fifo_axis_tready = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_to_ps_fifo_axis_tready : ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_to_cs_fifo_axis_tready : 1'b0;




//assign fsm_s_axis_tready = fsm_s_axis_tready_reg;

//assign m_to_fifo_axis_tdata = s_axis_tdata;
////assign m_to_fifo_axis_tvalid = s_axis_tvalid && s_axis_tready;
//assign m_to_fifo_axis_tvalid = s_axis_tvalid && fsm_s_axis_tready;
//assign m_to_fifo_axis_tlast = s_axis_tlast;
//assign m_to_fifo_axis_tuser = s_axis_tuser;
//assign s_axis_tready = ((fsm_s_axis_tready == 1'b1) && (m_to_fifo_axis_tready == 1'b1)) ? 1'b1 : 1'b0;
////assign s_axis_tready = m_to_fifo_axis_tready;

////generate
////    for (n = 0; n < FIFO_BANK_COUNT; n = n + 1) begin
////        assign m_from_fifo_axis_tready[n] = ((fifo_rd_pointer==n) && (sw_state==SW_SEND) && (sw_var_rd == 1)) ? m_to_cs_axis_tready :0;

////    end
////endgenerate
//always @(posedge clk) begin
//    if (rst) begin
//        state_reg <= STATE_IDLE;
//        eth_hdr_ptr_reg <= 8'd0;
//        udp_hdr_ptr_reg <= 8'd0;
//        ip_hdr_ptr_reg <= 8'd0;
//        fsm_s_axis_tready_reg <= 1'b0;
//        m_eth_hdr_valid_reg <= 1'b0;
////        busy_reg <= 1'b0;        
////        buffer_sw_ready <= 0;
//        buffer_lock <= 0;
//        fifo_slot_reset <= 0;
//        sw_var_wr <= 0;
    
    
//        fsm_s_axis_tready_reg <= 1'b0;

	
//	end else begin
////		eth_hdr_ptr_reg <= eth_hdr_ptr_reg;
////		udp_hdr_ptr_reg <= udp_hdr_ptr_reg;
////	   state_after_switch_ready <= state_after_switch_ready;
	
////        busy_reg <= state_reg != STATE_IDLE;
//    case (state_reg)
//        STATE_IDLE: begin
//            // idle state - wait for data
//            eth_hdr_ptr_reg <= 8'd0;
//            ip_hdr_ptr_reg <= 8'd0;
//            udp_hdr_ptr_reg <= 8'd0;
            
//            m_ip_protocol_reg <= 0;
//            m_eth_type_reg <= 0;
//            m_udp_dest_port_reg <= 0;
            
//            sw_var_wr <= sw_var_wr;
            
//                eth_hdr_ptr_reg <= 8'b0;
            
            	

////            if (s_axis_tready && s_axis_tvalid) begin
//                // got first word of packet
////                if (s_axis_tlast) begin
//                    // tlast asserted on first word
////                    error_header_early_termination_reg <= 1'b1;
////                    state_reg <= STATE_IDLE;
////                end else begin
//                    // move to read header state
                    
////                    store_eth_dest_mac_5 = 1'b1;
////                if(sw_state == SW_IDLE) begin
//                    fsm_s_axis_tready_reg <= 1'b1;
//                    state_reg <= STATE_READ_ETH_HEADER;
////                end else begin
////                    fsm_s_axis_tready_reg <= 1'b0;
////                    state_reg <= STATE_IDLE;
////                end
////                end 
////            end else begin
////                state_reg <= STATE_IDLE;
////            end
//        end
//        STATE_READ_ETH_HEADER: begin
//            // read header
//            fsm_s_axis_tready_reg <= 1'b1;
//            sw_var_wr <= sw_var_wr;
//            state_reg <= STATE_READ_ETH_HEADER;
//            if (s_axis_tready && m_to_fifo_axis_tvalid) begin
//                // word transfer in - store it
//                eth_hdr_ptr_reg <= eth_hdr_ptr_reg + 8'd1;
                
//                case (eth_hdr_ptr_reg)
//                    8'h00: m_eth_dest_mac_reg[47:40] <= s_axis_tdata;
//                    8'h01: m_eth_dest_mac_reg[39:32] <= s_axis_tdata;
//                    8'h02: m_eth_dest_mac_reg[31:24] <= s_axis_tdata;
//                    8'h03: m_eth_dest_mac_reg[23:16] <= s_axis_tdata;
//                    8'h04: m_eth_dest_mac_reg[15: 8] <= s_axis_tdata;
//                    8'h05: m_eth_dest_mac_reg[ 7: 0] <= s_axis_tdata;
//                    8'h06: m_eth_src_mac_reg[47:40] <= s_axis_tdata;
//                    8'h07: m_eth_src_mac_reg[39:32] <= s_axis_tdata;
//                    8'h08: m_eth_src_mac_reg[31:24] <= s_axis_tdata;
//                    8'h09: m_eth_src_mac_reg[23:16] <= s_axis_tdata;
//                    8'h0A: m_eth_src_mac_reg[15: 8] <= s_axis_tdata;
//                    8'h0B: m_eth_src_mac_reg[ 7: 0] <= s_axis_tdata;
//                    8'h0C: m_eth_type_reg[15: 8] <= s_axis_tdata;
//                    8'h0D: begin
//                        m_eth_type_reg[7: 0] <= s_axis_tdata;
//                        m_eth_hdr_valid_reg <= 1'b1;
//                        fsm_s_axis_tready_reg <= 1'b0;
                        
//                        state_reg <= STATE_PROCESS_ETH_HEADER;
                        
//                    end
                    
//                endcase
//                if (s_axis_tlast) begin
//                    //error_header_early_termination_next = 1'b1;
//                    //fsm_s_axis_tready_reg <= !m_eth_hdr_valid_reg;
//                    fsm_s_axis_tready_reg <= 1'b0;
//                    //decide_dir = 1'b1;
//                    state_after_switch_ready <= STATE_IDLE;
//                    state_reg <= STATE_SWITCHING_WAIT_CLEAR;
////                    state_reg <= STATE_IDLE;
//                    eth_hdr_ptr_reg <= 0;
//                end
//            end else begin
//                state_reg <= STATE_READ_ETH_HEADER;
//            end
//        end
//        STATE_PROCESS_ETH_HEADER: begin
			
//			sw_var_wr <= sw_var_wr;
//			if(m_eth_type == IPv4) begin
//				state_reg <= STATE_READ_IP_HEADER;
//				ip_hdr_ptr_reg <= 0;
//				fsm_s_axis_tready_reg <= 1'b1;	
//			end else begin
//				state_after_switch_ready <= STATE_READ_PAYLOAD;
//                state_reg <= STATE_SWITCHING_WAIT_CLEAR;	
//                fsm_s_axis_tready_reg <= 1'b0;
//				//decide_dir = 1'b1;									
//			end
//        end
//        STATE_READ_IP_HEADER: begin
//        	// read header
//        	fsm_s_axis_tready_reg <= 1'b1;
//            sw_var_wr <= sw_var_wr;
//            state_reg <= STATE_READ_IP_HEADER;
//        	if (s_axis_tready && m_to_fifo_axis_tvalid) begin
//        		// word transfer in - store it
//        		ip_hdr_ptr_reg <= ip_hdr_ptr_reg  + 8'd1;
        		

//        		case (ip_hdr_ptr_reg)
//        			8'h00: {m_ip_version_reg, m_ip_ihl_reg} <= s_axis_tdata;
//        			8'h01: {m_ip_dscp_reg, m_ip_ecn_reg} <= s_axis_tdata;
//        			8'h02: m_ip_length_reg[15: 8] <= s_axis_tdata;
//        			8'h03: m_ip_length_reg[ 7: 0] <= s_axis_tdata;
//        			8'h04: m_ip_identification_reg[15: 8] <= s_axis_tdata;
//        			8'h05: m_ip_identification_reg[ 7: 0] <= s_axis_tdata;
//        			8'h06: {m_ip_flags_reg, m_ip_fragment_offset_reg[12:8]} <= s_axis_tdata;
//        			8'h07: m_ip_fragment_offset_reg[ 7:0] <= s_axis_tdata;
//        			8'h08: m_ip_ttl_reg <= s_axis_tdata;
//        			8'h09: m_ip_protocol_reg <= s_axis_tdata;
//        			8'h0A: m_ip_header_checksum_reg[15: 8] <= s_axis_tdata;
//        			8'h0B: m_ip_header_checksum_reg[ 7: 0] <= s_axis_tdata;
//        			8'h0C: m_ip_source_ip_reg[31:24] <= s_axis_tdata;
//        			8'h0D: m_ip_source_ip_reg[23:16] <= s_axis_tdata;
//        			8'h0E: m_ip_source_ip_reg[15: 8] <= s_axis_tdata;
//        			8'h0F: m_ip_source_ip_reg[ 7: 0] <= s_axis_tdata;
//        			8'h10: m_ip_dest_ip_reg[31:24] <= s_axis_tdata;	
//        			8'h11: m_ip_dest_ip_reg[23:16] <= s_axis_tdata;
//        			8'h12: m_ip_dest_ip_reg[15: 8] <= s_axis_tdata;
//        			8'h13: begin
//        				m_ip_dest_ip_reg[ 7: 0] <= s_axis_tdata;
//        					m_ip_hdr_valid_reg <= 1'b1;
//        					ip_hdr_ptr_reg <= 0;
//        					if(m_ip_protocol != UDP_ID) begin
//        						state_after_switch_ready <= STATE_READ_PAYLOAD;
//                                state_reg <= STATE_SWITCHING_WAIT_CLEAR;	
//        						//decide_dir = 1'b1;
//        						fsm_s_axis_tready_reg <= 1'b0;
//        					end else begin
//        						state_reg <= STATE_READ_UDP_HEADER;
//        						fsm_s_axis_tready_reg <= 1'b1;
//        						udp_hdr_ptr_reg <= 0;
//        					end
	
////        				end
//        			end
//        		endcase

//        		if (s_axis_tlast) begin
//                    //decide_dir = 1'b1;
//        			fsm_s_axis_tready_reg <= 1'b0;
//        			ip_hdr_ptr_reg <= 0;
//        			state_after_switch_ready <= STATE_IDLE;
//                    state_reg <= STATE_SWITCHING_WAIT_CLEAR;
////                    state_reg <= STATE_IDLE;
//        		end

//        	end else begin
//        		state_reg <= STATE_READ_IP_HEADER;
//        	end
//        end
//        STATE_READ_UDP_HEADER: begin
//        	// read header state
//        	fsm_s_axis_tready_reg <= 1'b1;
//            sw_var_wr <= sw_var_wr;
//            state_reg <= STATE_READ_UDP_HEADER;
//        	if (s_axis_tready && m_to_fifo_axis_tvalid) begin
//        		// word transfer in - store it
//        		udp_hdr_ptr_reg <= udp_hdr_ptr_reg  + 8'd1;
        		

//        		case (udp_hdr_ptr_reg)
//        			8'h00: m_udp_source_port_reg[15: 8] <= s_axis_tdata;
//        			8'h01: m_udp_source_port_reg[ 7: 0] <= s_axis_tdata;
//        			8'h02: m_udp_dest_port_reg[15: 8] <= s_axis_tdata;
//        			8'h03: m_udp_dest_port_reg[ 7: 0] <= s_axis_tdata;
//        			8'h04: m_udp_length_reg[15: 8] <= s_axis_tdata;
//        			8'h05: m_udp_length_reg[ 7: 0] <= s_axis_tdata;
//        			8'h06: m_udp_checksum_reg[15: 8] <= s_axis_tdata;
//        			8'h07: begin
//        				m_udp_checksum_reg[ 7: 0] <= s_axis_tdata;
						
//						udp_hdr_ptr_reg <= 0;
//        				state_after_switch_ready <= STATE_READ_PAYLOAD;
//                        state_reg <= STATE_SWITCHING_WAIT_CLEAR;	
//                        //decide_dir = 1'b1;
//                        fsm_s_axis_tready_reg <= 1'b0;
//        			end
        			
        		
//        		endcase

//        		if (s_axis_tlast) begin
//        			//error_header_early_termination_next = 1'b1;
////        			m_udp_hdr_valid_next = 1'b0;
////        			s_ip_hdr_ready_next = !m_udp_hdr_valid_next;
//        			fsm_s_axis_tready_reg <= 1'b0;
//        			udp_hdr_ptr_reg <= 0;
//        			//decide_dir = 1'b1;
//        			state_after_switch_ready <= STATE_IDLE;
//                    state_reg <= STATE_SWITCHING_WAIT_CLEAR;
////                    state_reg <= STATE_IDLE;
//        		end

//        	end else begin
//        		state_reg <= STATE_READ_UDP_HEADER;
//        	end
//        end
        
        
//        STATE_READ_PAYLOAD: begin
//            // read payload
//        	fsm_s_axis_tready_reg <= 1'b1;
//        	sw_var_wr <= sw_var_wr;
////			decide_dir = 1'b0;
//            if (s_axis_tready && m_to_fifo_axis_tvalid) begin
//                // word transfer through
//                if (m_to_fifo_axis_tlast) begin
//                    fsm_s_axis_tready_reg <= 1'b0;
//                    state_reg <= STATE_IDLE;
//                end else begin
//                    state_reg <= STATE_READ_PAYLOAD;
//                    fsm_s_axis_tready_reg <= 1'b1;
//                end
//            end else begin
//                state_reg <= STATE_READ_PAYLOAD;
//                fsm_s_axis_tready_reg <= 1'b1;
//            end
//        end
        
//        STATE_SWITCHING_WAIT_CLEAR: begin
            
////            if(SW_IDLE == sw_state) begin  
//            state_after_switch_ready <= state_after_switch_ready;  
//             fsm_s_axis_tready_reg <= 1'b0;
             
//            if(buffer_lock == 1'b0) begin     
////                decide_dir = 1'b1;
////                if(decide_dir) begin 
//                    //Decide here
//                    buffer_lock <= 1'b1;
//                    if(((m_eth_type == IPv4) && (m_ip_protocol == UDP_ID)) && 
//                        ((m_udp_dest_port == udp_port_1) || (m_udp_dest_port == udp_port_2) || 
//                        (m_udp_dest_port == udp_port_3) || (m_udp_dest_port == udp_port_4) || 
//                        (m_udp_dest_port == udp_port_5) || (m_udp_dest_port == udp_port_6) || 
//                        (m_udp_dest_port == udp_port_7) || (m_udp_dest_port == udp_port_8) )) begin
//                            //Set current buffer switch/select pointer to CS and lock it for writting after tlast
                        
//                        sw_var_wr <= 1'b1;
//                    end else begin
                        
//                        sw_var_wr <= 1'b0;
//                    end
////                end

////                    if(state_after_switch_ready == STATE_IDLE) begin
////                        fsm_s_axis_tready_reg <=1'b0; 
////                    end else begin 
////                        fsm_s_axis_tready_reg <= 1'b1; 
////                    end
                    
//                    state_reg <= state_after_switch_ready;

                               
                                
//            end else begin
//                fsm_s_axis_tready_reg <= 1'b0;
//                state_reg <= STATE_SWITCHING_WAIT_CLEAR;
//                sw_var_wr <= sw_var_wr;
//            end
            
            
//        end
//    endcase
    
    
    
    
//    end
    
    
//    if(buffer_unlock == 1'b1) begin
//    	buffer_lock <= 1'b0;
//    end
    
//end



////Fifos are to buffer before switching point, for UDP packets switching point is after dest port

//wire                          enable_dmux;
//reg                          enable_dmux_reg;

//wire                          drop_dmux;
//reg                          drop_dmux_reg;

//wire [$clog2(S_COUNT)-1:0]    select_dmux;
////reg [$clog2(S_COUNT)-1:0]    select_dmux_reg;

//assign select_dmux = sw_var_rd;
//assign enable_dmux = enable_dmux_reg;
//assign drop_dmux = drop_dmux_reg;

////Out put SWitching state machine
//always @(posedge clk) begin
//	if (rst) begin
//		sw_state <= SW_IDLE;
//		buffer_unlock <= 1'b0;
//		sw_var_rd <= 1'b0;
//		cs_rx_pkt_count_reg <= 0;
//		ps_rx_pkt_count_reg <= 0;
//		drop_dmux_reg <= 0;
//		enable_dmux_reg <= 0;
//	end else begin
//		case (sw_state)
//			SW_IDLE: begin
//				enable_dmux_reg <= 0;
//				buffer_unlock <= 1'b0;// we only need one clock cycle
//				if(buffer_lock == 1'b1) begin
//					//fifo_rd_pointer <= fifo_rd_pointer + 1; not here
//					sw_state <= SW_SEL;
//					sw_var_rd <= sw_var_wr;
////					sw_state <= SW_SEND;
//				end else begin
//				    sw_state <= SW_IDLE;
//				    sw_var_rd <= 1'b0;
//				end
				
////				if(m_from_fifo_axis_tlast) begin
////					sw_state <= SW_BUF_UNLOCK;
////					buffer_unlock <= 1'b1;
					
////				end
				
//			end
//			SW_SEL: begin				
//				sw_var_rd <= sw_var_wr;
////				buffer_unlock <= 1'b1;//after switching buffer can be written again even if the current packet is not yet out
////				if(buffer_lock == 0) begin
//					sw_state <= SW_SEND;
//					enable_dmux_reg <= 1;
////				end else begin
////				    sw_state <= SW_SEL;
////				end


//                if(m_from_fifo_axis_tlast) begin
//					sw_state <= SW_BUF_UNLOCK;
//					buffer_unlock <= 1'b1;
					
//				end
				
//			end
//			SW_SEND: begin
				
//				sw_var_rd <= sw_var_rd;
//				enable_dmux_reg <= 1;
				
//				if(|(from_dmux_ch1_fifo_axis_tlast & from_dmux_ch1_fifo_axis_tvalid & from_dmux_ch1_fifo_axis_tready)) begin
//					sw_state <= SW_BUF_UNLOCK;
//					buffer_unlock <= 1'b1;
//					enable_dmux_reg <= 0;
////					sw_state <= SW_IDLE;
//					if(sw_var_rd == 1'b1) begin
//					   cs_rx_pkt_count_reg <= cs_rx_pkt_count + 1;
//					end else begin
//					   ps_rx_pkt_count_reg <= ps_rx_pkt_count + 1;
//					end
//				end else begin
//				    sw_state <= SW_SEND;
//				    buffer_unlock <= 1'b0;// we only need one clock cycle
//				end
//			end
			
//			SW_BUF_UNLOCK: begin
//			     enable_dmux_reg <= 0;
//                 if(buffer_lock == 1'b1) begin
//                     buffer_unlock <= 1'b1;
//                     sw_state <= SW_BUF_UNLOCK;
//                 end else begin
//                     buffer_unlock <= 1'b0;// we only need one clock cycle
//                     sw_state <= SW_IDLE;
//                 end
//			end
			
//			default: begin
//			     sw_var_rd <= 1'b0;
//			     enable_dmux_reg <= 0;
//			     buffer_unlock <= 1'b1;
//			    sw_state <= SW_IDLE;
//			end
			
//		endcase
		
		
		
//	end
//end






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
//    .s_axis_tdata(to_dmux_ch_fifo_axis_tdata),
//    .s_axis_tkeep(0),
//    .s_axis_tvalid(to_dmux_ch_fifo_axis_tvalid),
//    .s_axis_tready(to_dmux_ch_fifo_axis_tready),
//    .s_axis_tlast(to_dmux_ch_fifo_axis_tlast),
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



//		axis_fifo #(
//				.DEPTH(FIFO_DEPTH),
//				.DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
//				.KEEP_ENABLE(0),
//				.ID_ENABLE(0),
//				.DEST_ENABLE(0),
//				.USER_ENABLE(1),
//				.USER_WIDTH(1),
//				.FRAME_FIFO(0)
//			) from_phy_to_upper_payload_fifo (
//				.clk(clk),
//				.rst(rst),

//				// AXIS input from udp core
//				.s_axis_tdata(m_to_fifo_axis_tdata),
//				.s_axis_tkeep(0),//must default to high in docs but its very bad
//				.s_axis_tvalid(m_to_fifo_axis_tvalid),
//				.s_axis_tready(m_to_fifo_axis_tready),
//				.s_axis_tlast(m_to_fifo_axis_tlast),
//				.s_axis_tid(0),
//				.s_axis_tdest(0),
//				.s_axis_tuser(m_to_fifo_axis_tuser),

//				// AXI output to audo core
//				.m_axis_tdata(m_from_fifo_axis_tdata),
//				.m_axis_tkeep(),
//				.m_axis_tvalid(m_from_fifo_axis_tvalid),
//				.m_axis_tready(m_from_fifo_axis_tready),
//				.m_axis_tlast(m_from_fifo_axis_tlast),
//				.m_axis_tid(),
//				.m_axis_tdest(),
//				.m_axis_tuser(m_from_fifo_axis_tuser),

//				// Status
//				.status_overflow(status_overflow),
//				.status_bad_frame(),
//				.status_good_frame()
//			);
			
			
//			axis_fifo #(
//				.DEPTH(RX_FIFO_DEPTH),
//				.DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
//				.KEEP_ENABLE(0),
//				.ID_ENABLE(0),
//				.DEST_ENABLE(0),
//				.USER_ENABLE(1),
//				.USER_WIDTH(1),
//				.FRAME_FIFO(0)
//			) from_phy_to_cs_fifo (
//				.clk(clk),
//				.rst(rst),

//				// AXIS input from udp core
//				.s_axis_tdata(m_to_cs_fifo_axis_tdata),
//				.s_axis_tkeep(0),//must default to high in docs but its very bad
//				.s_axis_tvalid(m_to_cs_fifo_axis_tvalid),
//				.s_axis_tready(m_to_cs_fifo_axis_tready),
//				.s_axis_tlast(m_to_cs_fifo_axis_tlast),
//				.s_axis_tid(0),
//				.s_axis_tdest(0),
//				.s_axis_tuser(m_to_cs_fifo_axis_tuser),

//				// AXI output to audo core
//				.m_axis_tdata(m_to_cs_axis_tdata),
//				.m_axis_tkeep(),
//				.m_axis_tvalid(m_to_cs_axis_tvalid),
//				.m_axis_tready(m_to_cs_axis_tready),
//				.m_axis_tlast(m_to_cs_axis_tlast),
//				.m_axis_tid(),
//				.m_axis_tdest(),
//				.m_axis_tuser(m_to_cs_axis_tuser),

//				// Status
//				.status_overflow(status_overflow),
//				.status_bad_frame(),
//				.status_good_frame()
//			);
			
			
//			axis_fifo #(
//				.DEPTH(RX_FIFO_DEPTH),
//				.DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
//				.KEEP_ENABLE(0),
//				.ID_ENABLE(0),
//				.DEST_ENABLE(0),
//				.USER_ENABLE(1),
//				.USER_WIDTH(1),
//				.FRAME_FIFO(0)
//			) from_phy_to_ps_fifo (
//				.clk(clk),
//				.rst(rst),

//				// AXIS input from udp core
//				.s_axis_tdata(m_to_ps_fifo_axis_tdata),
//				.s_axis_tkeep(0),//must default to high in docs but its very bad
//				.s_axis_tvalid(m_to_ps_fifo_axis_tvalid),
//				.s_axis_tready(m_to_ps_fifo_axis_tready),
//				.s_axis_tlast(m_to_ps_fifo_axis_tlast),
//				.s_axis_tid(0),
//				.s_axis_tdest(0),
//				.s_axis_tuser(m_to_ps_fifo_axis_tuser),

//				// AXI output to audo core
//				.m_axis_tdata(m_to_ps_axis_tdata),
//				.m_axis_tkeep(),
//				.m_axis_tvalid(m_to_ps_axis_tvalid),
//				.m_axis_tready(m_to_ps_axis_tready),
//				.m_axis_tlast(m_to_ps_axis_tlast),
//				.m_axis_tid(),
//				.m_axis_tdest(),
//				.m_axis_tuser(m_to_ps_axis_tuser),

//				// Status
//				.status_overflow(status_overflow),
//				.status_bad_frame(),
//				.status_good_frame()
//			);


//endmodule


/*

Copyright (c) 2014-2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * AXI4-Stream ethernet frame receiver (AXI in, Ethernet frame out)
 * This is below the eth_axis_rx layer, all bytes flow through (to PS or to CS via AXIS) no header stripping
 */
module eth_axis_rx_switch#(
parameter C_S_AXIS_TDATA_WIDTH = 8,
parameter RX_OUT_FIFO_DEPTH = 2048,
//parameter FIFO_ADDR_WIDTH = 6, // this is only to hold up to the UDP HDR
parameter FIFO_DEPTH = 64
//parameter FIFO_BANK_COUNT = 2
)
(
    input  wire        clk,
    input  wire        rst,

    /*
     * AXI input
     */
    input  wire [7:0]  s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire        s_axis_tlast,
    input  wire        s_axis_tuser,

    /*
     * UDP ports for filtering 
     */
    
    input wire [15:0] udp_port_1,
    input wire [15:0] udp_port_2,
    input wire [15:0] udp_port_3,
    input wire [15:0] udp_port_4,
    input wire [15:0] udp_port_5,
    input wire [15:0] udp_port_6,
    input wire [15:0] udp_port_7,
    input wire [15:0] udp_port_8,
    
    /*
     * Ethernet frame output
     */
//    output wire        m_eth_hdr_valid,
//    input  wire        m_eth_hdr_ready,
//    output wire [47:0] m_eth_dest_mac,
//    output wire [47:0] m_eth_src_mac,
//    output wire [15:0] m_eth_type,
    
    output wire [7:0]  m_to_ps_axis_tdata,
    output wire        m_to_ps_axis_tvalid,
    input  wire        m_to_ps_axis_tready,
    output wire        m_to_ps_axis_tlast,
    output wire        m_to_ps_axis_tuser,
    
    
    
    output wire [7:0]  m_to_cs_axis_tdata,
    output wire        m_to_cs_axis_tvalid,
    input  wire        m_to_cs_axis_tready,
    output wire        m_to_cs_axis_tlast,
    output wire        m_to_cs_axis_tuser,
    
    
    output wire [15:0]  ps_rx_pkt_count,
    output wire [15:0]  cs_rx_pkt_count,
    output wire [31:0]  rx_sw_state,
    output wire [31:0]  bus_status,    
        
     
    /*
     * Status signals
     */
    output wire        sel_status,
    output wire        busy,
    output wire        error_header_early_termination
);

/*

UDP Frame

 Field                                      Length
 Destination MAC address                    6 octets
 Source MAC address                         6 octets
 Ethertype (IP=0x0800 ARP=0x0806)          2 octets
 Version (4)                                4 bits
 IHL (5-15)                  4 bits
 DSCP (0)                    6 bits
 ECN (0)                     2 bits
 length                      2 octets
 identification (0?)         2 octets
 flags (010)                 3 bits
 fragment offset (0)         13 bits
 time to live (64?)          1 octet
 protocol (0x11==UDP)        1 octet
 header checksum             2 octets
 source IP                   4 octets
 destination IP              4 octets
 options                     (IHL-5)*4 octets

 source port                 2 octets
 desination port             2 octets
 length                      2 octets
 checksum                    2 octets

 payload                     length octets

This module receives an Eth frame with header fields and uses them for switching 

*/

//Ethernet ETH_TYPES

parameter IPv4 = 16'h0800;
parameter IPv6 = 16'h86DD;
parameter ARP = 16'h0806;
parameter PTP = 16'h88F7;
	
//IP Protocol IDs
parameter UDP_LITE_ID = 8'h88;
parameter UDP_ID = 8'h11;


parameter [2:0]
    STATE_IDLE = 3'd0,
    STATE_READ_ETH_HEADER = 3'd1,
    STATE_PROCESS_ETH_HEADER = 3'd2,
    STATE_READ_IP_HEADER = 3'd3,
    STATE_READ_UDP_HEADER = 3'd4,
    STATE_READ_PAYLOAD = 3'd5,
    STATE_SWITCHING_WAIT_CLEAR  = 3'd6;

parameter [1:0]
	SW_IDLE = 2'd0,
	SW_SEL = 2'd1,
	SW_SEND = 2'd2,
	SW_BUF_UNLOCK = 2'd3;

wire is_udp;

//assign is_udp =  m_eth_type == UDP_ETH_ID ? 1 : 0;

reg [2:0] state_reg = STATE_IDLE, state_after_switch_ready;
reg [1:0] sw_state = SW_IDLE;
wire status_overflow;



// datapath control signals
// ------------------------------------------- ETH HDR data -------------------------------------


reg [7:0] eth_hdr_ptr_reg = 8'd0;
reg [7:0] ip_hdr_ptr_reg = 8'd0;
reg [7:0] udp_hdr_ptr_reg = 8'd0;

reg fsm_s_axis_tready_reg = 1'b0;

reg m_eth_hdr_valid_reg = 1'b0;
reg [47:0] m_eth_dest_mac_reg = 48'd0;
reg [47:0] m_eth_src_mac_reg = 48'd0;
reg [15:0] m_eth_type_reg = 16'd0;

wire m_eth_hdr_valid;
wire [47:0] m_eth_dest_mac;
wire [47:0] m_eth_src_mac;
wire [15:0] m_eth_type;

//-----------------------------------IP HDR data----------------------------------------
//function [15:0] add1c16b;
//    input [15:0] a, b;
//    reg [16:0] t;
//    begin
//        t = a+b;
//        add1c16b = t[15:0] + t[16];
//    end
//endfunction
// datapath control signals


reg m_ip_hdr_valid_reg = 1'b0;


reg [3:0] m_ip_version_reg = 4'd0;
reg [3:0] m_ip_ihl_reg = 4'd0;
reg [5:0] m_ip_dscp_reg = 6'd0;
reg [1:0] m_ip_ecn_reg = 2'd0;
reg [15:0] m_ip_length_reg = 16'd0;
reg [15:0] m_ip_identification_reg = 16'd0;
reg [2:0] m_ip_flags_reg = 3'd0;
reg [12:0] m_ip_fragment_offset_reg = 13'd0;
reg [7:0] m_ip_ttl_reg = 8'd0;
reg [7:0] m_ip_protocol_reg = 8'd0;
reg [15:0] m_ip_header_checksum_reg = 16'd0;
reg [31:0] m_ip_source_ip_reg = 32'd0;
reg [31:0] m_ip_dest_ip_reg = 32'd0;

wire [7:0] m_ip_protocol;

assign m_ip_protocol = m_ip_protocol_reg;
//----------------------------------------UDP HDR data -------------------------------



reg [15:0] m_udp_source_port_reg = 16'd0;
reg [15:0] m_udp_dest_port_reg = 16'd0;
reg [15:0] m_udp_length_reg = 16'd0;
reg [15:0] m_udp_checksum_reg = 16'd0;

wire [15:0] m_udp_dest_port;
//-------------------------------------------------------------------------


reg busy_reg = 1'b0;





wire fsm_s_axis_tready;

assign m_udp_dest_port = m_udp_dest_port_reg;
assign m_eth_hdr_valid = m_eth_hdr_valid_reg;
assign m_eth_dest_mac = m_eth_dest_mac_reg;
assign m_eth_src_mac = m_eth_src_mac_reg;
assign m_eth_type = m_eth_type_reg;

assign busy = busy_reg;




wire [C_S_AXIS_TDATA_WIDTH-1:0] m_to_fifo_axis_tdata;
wire  m_to_fifo_axis_tvalid;
wire  m_to_fifo_axis_tready;
wire  m_to_fifo_axis_tlast;
wire  m_to_fifo_axis_tuser;


wire [C_S_AXIS_TDATA_WIDTH-1:0]  m_from_fifo_axis_tdata;
wire  m_from_fifo_axis_tvalid;
wire  m_from_fifo_axis_tready;
wire  m_from_fifo_axis_tlast;
wire  m_from_fifo_axis_tuser;




wire [7:0]  m_to_ps_fifo_axis_tdata;
wire        m_to_ps_fifo_axis_tvalid;
wire        m_to_ps_fifo_axis_tready;
wire        m_to_ps_fifo_axis_tlast;
wire        m_to_ps_fifo_axis_tuser;



wire [7:0]  m_to_cs_fifo_axis_tdata;
wire        m_to_cs_fifo_axis_tvalid;
 wire        m_to_cs_fifo_axis_tready;
wire        m_to_cs_fifo_axis_tlast;
wire        m_to_cs_fifo_axis_tuser;

//reg [$clog2(FIFO_BANK_COUNT)-1:0] fifo_wr_pointer;
//reg [$clog2(FIFO_BANK_COUNT)-1:0] fifo_rd_pointer; // not a switching variable
reg  buffer_sw_ready;
reg  buffer_lock;
reg  buffer_unlock;
reg  fifo_slot_reset;

reg  sw_var_wr;        // 0 for send to PS, 1 for send to CS
reg  sw_var_rd; 

//assign sel_status = ((state_reg == STATE_SWITCHING_WAIT_CLEAR) ) ? 1: 0;//sw_var_rd;
//assign sel_status = ((((m_eth_type == IPv4) || (m_eth_type == IPv6)) && (m_ip_protocol == UDP_ID)) && 
//                        ((m_udp_dest_port_reg == udp_port_1) || (m_udp_dest_port_reg == udp_port_2) || 
//                        (m_udp_dest_port_reg == udp_port_3) || (m_udp_dest_port_reg == udp_port_4) || 
//                        (m_udp_dest_port_reg == udp_port_5) || (m_udp_dest_port_reg == udp_port_6) || 
//                        (m_udp_dest_port_reg == udp_port_7) || (m_udp_dest_port_reg == udp_port_8) ));

//assign sel_status = (((m_eth_type == IPv4) || (m_eth_type == IPv6)) && (m_ip_protocol_reg == UDP_ID)) ? 1 : 0;

//assign sel_status = (  ((m_udp_dest_port == udp_port_1) || (m_udp_dest_port == udp_port_2) || 
//                        (m_udp_dest_port == udp_port_3) || (m_udp_dest_port == udp_port_4) || 
//                        (m_udp_dest_port == udp_port_5) || (m_udp_dest_port == udp_port_6) || 
//                        (m_udp_dest_port == udp_port_7) || (m_udp_dest_port == udp_port_8) ));


reg [15:0]  ps_rx_pkt_count_reg;
reg [15:0]  cs_rx_pkt_count_reg;


assign  rx_sw_state ={1'b0,buffer_lock,buffer_unlock,sw_var_rd, 1'b0,state_reg,2'b00,sw_state};//LSB
//assign bus_status   = {1'b0,m_from_fifo_axis_tready,m_from_fifo_axis_tvalid,m_from_fifo_axis_tlast,2'b00,buffer_unlock,sw_var_rd};
assign bus_status   = {fsm_s_axis_tready, 1'b0,s_axis_tready,s_axis_tvalid,s_axis_tlast,
                                          1'b0,m_to_ps_axis_tready, m_to_ps_axis_tvalid, m_to_ps_axis_tlast,
                                          1'b0,m_to_cs_axis_tready, m_to_cs_axis_tvalid, m_to_cs_axis_tlast, 
                                          1'b0,m_to_fifo_axis_tready,m_to_fifo_axis_tvalid,m_to_fifo_axis_tlast,
                                          1'b0,m_from_fifo_axis_tready,m_from_fifo_axis_tvalid,m_from_fifo_axis_tlast};
        
assign cs_rx_pkt_count = cs_rx_pkt_count_reg;
assign ps_rx_pkt_count = ps_rx_pkt_count_reg;

assign m_to_cs_fifo_axis_tdata = ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_from_fifo_axis_tdata :0;
assign m_to_cs_fifo_axis_tvalid = ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_from_fifo_axis_tvalid :0;
assign m_to_cs_fifo_axis_tlast = ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_from_fifo_axis_tlast :0;
assign m_to_cs_fifo_axis_tuser = ((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_from_fifo_axis_tuser :0;

assign m_to_ps_fifo_axis_tdata = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_from_fifo_axis_tdata :0;
assign m_to_ps_fifo_axis_tvalid = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_from_fifo_axis_tvalid :0;
assign m_to_ps_fifo_axis_tlast = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_from_fifo_axis_tlast :0;
assign m_to_ps_fifo_axis_tuser = ((sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_from_fifo_axis_tuser :0;


//assign m_to_ps_axis_tdata = s_axis_tdata;
//assign m_to_ps_axis_tvalid = s_axis_tvalid;
//assign m_to_ps_axis_tlast = s_axis_tlast;
//assign s_axis_tready = m_to_ps_axis_tready;

//assign m_to_ps_axis_tdata = m_from_fifo_axis_tdata;
//assign m_to_ps_axis_tvalid = m_from_fifo_axis_tvalid;
//assign m_to_ps_axis_tlast = m_from_fifo_axis_tlast;
//assign m_to_ps_axis_tuser = m_from_fifo_axis_tuser;
//assign m_from_fifo_axis_tready = m_to_ps_axis_tready;



assign m_from_fifo_axis_tready = ( (sw_state==SW_SEND) && (sw_var_rd == 1'b0)) ? m_to_ps_fifo_axis_tready :((sw_state==SW_SEND) && (sw_var_rd == 1'b1)) ? m_to_cs_fifo_axis_tready :0;




assign fsm_s_axis_tready = fsm_s_axis_tready_reg;

assign m_to_fifo_axis_tdata = s_axis_tdata;
//assign m_to_fifo_axis_tvalid = s_axis_tvalid && s_axis_tready;
assign m_to_fifo_axis_tvalid = s_axis_tvalid && fsm_s_axis_tready;
assign m_to_fifo_axis_tlast = s_axis_tlast;
assign m_to_fifo_axis_tuser = s_axis_tuser;
assign s_axis_tready = ((fsm_s_axis_tready == 1) && (m_to_fifo_axis_tready == 1)) ? 1 : 0;
//assign s_axis_tready = m_to_fifo_axis_tready;

//generate
//    for (n = 0; n < FIFO_BANK_COUNT; n = n + 1) begin
//        assign m_from_fifo_axis_tready[n] = ((fifo_rd_pointer==n) && (sw_state==SW_SEND) && (sw_var_rd == 1)) ? m_to_cs_axis_tready :0;

//    end
//endgenerate
always @(posedge clk) begin
if (rst) begin
        state_reg <= STATE_IDLE;
        eth_hdr_ptr_reg <= 8'd0;
        udp_hdr_ptr_reg <= 8'd0;
        ip_hdr_ptr_reg <= 8'd0;
        fsm_s_axis_tready_reg <= 1'b0;
        m_eth_hdr_valid_reg <= 1'b0;
        busy_reg <= 1'b0;        
        buffer_sw_ready <= 0;
        buffer_lock <= 0;
        fifo_slot_reset <= 0;
        sw_var_wr <= 1;
    
    
        fsm_s_axis_tready_reg <= 1'b0;

	
	end else begin
		eth_hdr_ptr_reg <= eth_hdr_ptr_reg;
		udp_hdr_ptr_reg <= udp_hdr_ptr_reg;
	   state_after_switch_ready <= state_after_switch_ready;
	
    busy_reg <= state_reg != STATE_IDLE;
    case (state_reg)
        STATE_IDLE: begin
            // idle state - wait for data
            eth_hdr_ptr_reg <= 8'd0;
            ip_hdr_ptr_reg <= 8'd0;
            udp_hdr_ptr_reg <= 8'd0;
            
            m_ip_protocol_reg <= 0;
            m_eth_type_reg <= 0;
            m_udp_dest_port_reg <= 0;
            sw_var_wr <= sw_var_wr;
            
                eth_hdr_ptr_reg <= 8'b0;

            	fsm_s_axis_tready_reg <= 1'b1;

//            if (s_axis_tready && s_axis_tvalid) begin
                // got first word of packet
//                if (s_axis_tlast) begin
                    // tlast asserted on first word
//                    error_header_early_termination_reg <= 1'b1;
//                    state_reg <= STATE_IDLE;
//                end else begin
                    // move to read header state
                    
//                    store_eth_dest_mac_5 = 1'b1;
                    state_reg <= STATE_READ_ETH_HEADER;
//                end
//            end else begin
//                state_reg <= STATE_IDLE;
//            end
        end
        STATE_READ_ETH_HEADER: begin
            // read header
            fsm_s_axis_tready_reg <= 1'b1;
            sw_var_wr <= sw_var_wr;
            state_reg <= STATE_READ_ETH_HEADER;
            if (s_axis_tready && s_axis_tvalid) begin
                // word transfer in - store it
                eth_hdr_ptr_reg <= eth_hdr_ptr_reg + 8'd1;
                
                case (eth_hdr_ptr_reg)
                    8'h00: m_eth_dest_mac_reg[47:40] <= s_axis_tdata;
                    8'h01: m_eth_dest_mac_reg[39:32] <= s_axis_tdata;
                    8'h02: m_eth_dest_mac_reg[31:24] <= s_axis_tdata;
                    8'h03: m_eth_dest_mac_reg[23:16] <= s_axis_tdata;
                    8'h04: m_eth_dest_mac_reg[15: 8] <= s_axis_tdata;
                    8'h05: m_eth_dest_mac_reg[ 7: 0] <= s_axis_tdata;
                    8'h06: m_eth_src_mac_reg[47:40] <= s_axis_tdata;
                    8'h07: m_eth_src_mac_reg[39:32] <= s_axis_tdata;
                    8'h08: m_eth_src_mac_reg[31:24] <= s_axis_tdata;
                    8'h09: m_eth_src_mac_reg[23:16] <= s_axis_tdata;
                    8'h0A: m_eth_src_mac_reg[15: 8] <= s_axis_tdata;
                    8'h0B: m_eth_src_mac_reg[ 7: 0] <= s_axis_tdata;
                    8'h0C: m_eth_type_reg[15: 8] <= s_axis_tdata;
                    8'h0D: begin
                        m_eth_type_reg[7: 0] <= s_axis_tdata;
                        m_eth_hdr_valid_reg <= 1'b1;
                        fsm_s_axis_tready_reg <= 1'b0;
                        
                        state_reg <= STATE_PROCESS_ETH_HEADER;
                        
                    end
                    
                endcase
                if (s_axis_tlast) begin
                    //error_header_early_termination_next = 1'b1;
                    //fsm_s_axis_tready_reg <= !m_eth_hdr_valid_reg;
                    fsm_s_axis_tready_reg <= 1'b0;
                    //decide_dir = 1'b1;
                    state_after_switch_ready <= STATE_IDLE;
                    state_reg <= STATE_SWITCHING_WAIT_CLEAR;
                end
            end else begin
                state_reg <= STATE_READ_ETH_HEADER;
            end
        end
        STATE_PROCESS_ETH_HEADER: begin
			
			sw_var_wr <= sw_var_wr;
			if((m_eth_type == IPv4) || (m_eth_type == IPv6)) begin
				state_reg <= STATE_READ_IP_HEADER;
				fsm_s_axis_tready_reg <= 1'b1;	
			end else begin
				state_after_switch_ready <= STATE_READ_PAYLOAD;
                state_reg <= STATE_SWITCHING_WAIT_CLEAR;	
                fsm_s_axis_tready_reg <= 1'b0;
				//decide_dir = 1'b1;									
			end
        end
        STATE_READ_IP_HEADER: begin
        	// read header
        	fsm_s_axis_tready_reg <= 1'b1;
            sw_var_wr <= sw_var_wr;
            state_reg <= STATE_READ_IP_HEADER;
        	if (s_axis_tready && s_axis_tvalid) begin
        		// word transfer in - store it
        		ip_hdr_ptr_reg <= ip_hdr_ptr_reg  + 8'd1;
        		

        		case (ip_hdr_ptr_reg)
        			8'h00: {m_ip_version_reg, m_ip_ihl_reg} <= s_axis_tdata;
        			8'h01: {m_ip_dscp_reg, m_ip_ecn_reg} <= s_axis_tdata;
        			8'h02: m_ip_length_reg[15: 8] <= s_axis_tdata;
        			8'h03: m_ip_length_reg[ 7: 0] <= s_axis_tdata;
        			8'h04: m_ip_identification_reg[15: 8] <= s_axis_tdata;
        			8'h05: m_ip_identification_reg[ 7: 0] <= s_axis_tdata;
        			8'h06: {m_ip_flags_reg, m_ip_fragment_offset_reg[12:8]} <= s_axis_tdata;
        			8'h07: m_ip_fragment_offset_reg[ 7:0] <= s_axis_tdata;
        			8'h08: m_ip_ttl_reg <= s_axis_tdata;
        			8'h09: m_ip_protocol_reg <= s_axis_tdata;
        			8'h0A: m_ip_header_checksum_reg[15: 8] <= s_axis_tdata;
        			8'h0B: m_ip_header_checksum_reg[ 7: 0] <= s_axis_tdata;
        			8'h0C: m_ip_source_ip_reg[31:24] <= s_axis_tdata;
        			8'h0D: m_ip_source_ip_reg[23:16] <= s_axis_tdata;
        			8'h0E: m_ip_source_ip_reg[15: 8] <= s_axis_tdata;
        			8'h0F: m_ip_source_ip_reg[ 7: 0] <= s_axis_tdata;
        			8'h10: m_ip_dest_ip_reg[31:24] <= s_axis_tdata;	
        			8'h11: m_ip_dest_ip_reg[23:16] <= s_axis_tdata;
        			8'h12: m_ip_dest_ip_reg[15: 8] <= s_axis_tdata;
        			8'h13: begin
        				m_ip_dest_ip_reg[ 7: 0] <= s_axis_tdata;
        					m_ip_hdr_valid_reg <= 1'b1;
        					ip_hdr_ptr_reg <= 0;
        					if(m_ip_protocol != UDP_ID) begin
        						state_after_switch_ready <= STATE_READ_PAYLOAD;
                                state_reg <= STATE_SWITCHING_WAIT_CLEAR;	
        						//decide_dir = 1'b1;
        						fsm_s_axis_tready_reg <= 0;
        					end else begin
        						state_reg <= STATE_READ_UDP_HEADER;
        					end
	
//        				end
        			end
        		endcase

        		if (s_axis_tlast) begin
                    //decide_dir = 1'b1;
        			fsm_s_axis_tready_reg <= 1'b0;
        			ip_hdr_ptr_reg <= 0;
        			state_after_switch_ready <= STATE_IDLE;
                    state_reg <= STATE_SWITCHING_WAIT_CLEAR;
        		end

        	end else begin
        		state_reg <= STATE_READ_IP_HEADER;
        	end
        end
        STATE_READ_UDP_HEADER: begin
        	// read header state
        	fsm_s_axis_tready_reg <= 1'b1;
            sw_var_wr <= sw_var_wr;
            state_reg <= STATE_READ_UDP_HEADER;
        	if (s_axis_tready && s_axis_tvalid) begin
        		// word transfer in - store it
        		udp_hdr_ptr_reg <= udp_hdr_ptr_reg  + 8'd1;
        		

        		case (udp_hdr_ptr_reg)
        			8'h00: m_udp_source_port_reg[15: 8] <= s_axis_tdata;
        			8'h01: m_udp_source_port_reg[ 7: 0] <= s_axis_tdata;
        			8'h02: m_udp_dest_port_reg[15: 8] <= s_axis_tdata;
        			8'h03: m_udp_dest_port_reg[ 7: 0] <= s_axis_tdata;
        			8'h04: m_udp_length_reg[15: 8] <= s_axis_tdata;
        			8'h05: m_udp_length_reg[ 7: 0] <= s_axis_tdata;
        			8'h06: m_udp_checksum_reg[15: 8] <= s_axis_tdata;
        			8'h07: begin
        				m_udp_checksum_reg[ 7: 0] <= s_axis_tdata;
						
						udp_hdr_ptr_reg <= 0;
        				state_after_switch_ready <= STATE_READ_PAYLOAD;
                        state_reg <= STATE_SWITCHING_WAIT_CLEAR;	
                        //decide_dir = 1'b1;
                        fsm_s_axis_tready_reg <= 1'b0;
        			end
        			
        		
        		endcase

        		if (s_axis_tlast) begin
        			//error_header_early_termination_next = 1'b1;
//        			m_udp_hdr_valid_next = 1'b0;
//        			s_ip_hdr_ready_next = !m_udp_hdr_valid_next;
        			fsm_s_axis_tready_reg <= 1'b0;
        			udp_hdr_ptr_reg <= 0;
        			//decide_dir = 1'b1;
        			state_after_switch_ready <= STATE_IDLE;
                    state_reg <= STATE_SWITCHING_WAIT_CLEAR;
        		end

        	end else begin
        		state_reg <= STATE_READ_UDP_HEADER;
        	end
        end
        
        
        STATE_READ_PAYLOAD: begin
            // read payload
        	fsm_s_axis_tready_reg <= 1'b1;
        	sw_var_wr <= sw_var_wr;
//			decide_dir = 1'b0;
            if (s_axis_tready && s_axis_tvalid) begin
                // word transfer through
                if (s_axis_tlast) begin
                    fsm_s_axis_tready_reg <= 1'b0;
                    state_reg <= STATE_IDLE;
                end else begin
                    state_reg <= STATE_READ_PAYLOAD;
                end
            end else begin
                state_reg <= STATE_READ_PAYLOAD;
            end
        end
        
        STATE_SWITCHING_WAIT_CLEAR: begin
            
//            if(SW_IDLE == sw_state) begin  
            state_after_switch_ready <= state_after_switch_ready;   
            if(buffer_lock == 1'b0) begin     
//                decide_dir = 1'b1;
//                if(decide_dir) begin 
                    //Decide here
                    if((((m_eth_type == IPv4) || (m_eth_type == IPv6)) && (m_ip_protocol == UDP_ID)) && 
                        ((m_udp_dest_port == udp_port_1) || (m_udp_dest_port == udp_port_2) || 
                        (m_udp_dest_port == udp_port_3) || (m_udp_dest_port == udp_port_4) || 
                        (m_udp_dest_port == udp_port_5) || (m_udp_dest_port == udp_port_6) || 
                        (m_udp_dest_port == udp_port_7) || (m_udp_dest_port == udp_port_8) )) begin
                            //Set current buffer switch/select pointer to CS and lock it for writting after tlast
                        buffer_lock <= 1'b1;
                        sw_var_wr <= 1'b1;
                    end else begin
                        buffer_lock <= 1'b1;
                        sw_var_wr <= 1'b0;
                    end
//                end

                    if(state_after_switch_ready == STATE_IDLE) begin
                        fsm_s_axis_tready_reg <=1'b0; 
                    end else begin 
                        fsm_s_axis_tready_reg <= 1'b1; 
                    end


                               
                state_reg <= state_after_switch_ready;                
            end else begin
                fsm_s_axis_tready_reg <= 1'b0;
                state_reg <= STATE_SWITCHING_WAIT_CLEAR;
                sw_var_wr <= sw_var_wr;
            end
            
            
        end
    endcase
    
    
    if(buffer_unlock == 1) begin
    	buffer_lock <= 0;
    end
    
    end
    
end



//Fifos are to buffer before switching point, for UDP packets switching point is after dest port


//Out put SWitching state machine
always @(posedge clk) begin
	if (rst) begin
		sw_state <= SW_IDLE;
		buffer_unlock <= 1'b1;
		sw_var_rd <= 1'b0;
		cs_rx_pkt_count_reg <= 0;
		ps_rx_pkt_count_reg <= 0;
	end else begin
		case (sw_state)
			SW_IDLE: begin
				sw_var_rd <= sw_var_wr;
				buffer_unlock <= 1'b0;// we only need one clock cycle
				if(buffer_lock == 1'b1) begin
					//fifo_rd_pointer <= fifo_rd_pointer + 1; not here
//					sw_state <= SW_SEL;
					sw_state <= SW_SEND;
					
				end else begin
				    sw_state <= SW_IDLE;
				end
				
				if(m_from_fifo_axis_tlast) begin
					sw_state <= SW_BUF_UNLOCK;
					buffer_unlock <= 1'b1;
					
				end
				
			end
//			SW_SEL: begin				
//				sw_var_rd <= sw_var_wr;
////				buffer_unlock <= 1'b1;//after switching buffer can be written again even if the current packet is not yet out
////				if(buffer_lock == 0) begin
//					sw_state <= SW_SEND;
////				end else begin
////				    sw_state <= SW_SEL;
////				end


//                if(m_from_fifo_axis_tlast) begin
//					sw_state <= SW_BUF_UNLOCK;
//					buffer_unlock <= 1'b1;
					
//				end
				
//			end
			SW_SEND: begin
				buffer_unlock <= 1'b0;// we only need one clock cycle
				sw_var_rd <= sw_var_rd;
				
				
				if(m_from_fifo_axis_tlast && m_from_fifo_axis_tvalid && m_from_fifo_axis_tready) begin
					sw_state <= SW_BUF_UNLOCK;
					buffer_unlock <= 1'b1;
					if(sw_var_rd == 1) begin
					   cs_rx_pkt_count_reg <= cs_rx_pkt_count + 1;
					end else begin
					   ps_rx_pkt_count_reg <= ps_rx_pkt_count + 1;
					end
				end else begin
				    sw_state <= SW_SEND;
				end
			end
			
			SW_BUF_UNLOCK: begin
			
			 buffer_unlock <= 1'b0;// we only need one clock cycle
			 sw_state <= SW_IDLE;
			end
			
			default: begin
			     sw_var_rd <= sw_var_rd;
			    sw_state <= SW_IDLE;
			end
			
		endcase
		
		
		
	end
end


		axis_fifo #(
				.DEPTH(FIFO_DEPTH),
				.DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
				.KEEP_ENABLE(0),
				.ID_ENABLE(0),
				.DEST_ENABLE(0),
				.USER_ENABLE(1),
				.USER_WIDTH(1),
				.FRAME_FIFO(0)
			) from_phy_to_upper_payload_fifo (
				.clk(clk),
				.rst(rst || fifo_slot_reset),

				// AXIS input from udp core
				.s_axis_tdata(m_to_fifo_axis_tdata),
				.s_axis_tkeep(0),//must default to high in docs but its very bad
				.s_axis_tvalid(m_to_fifo_axis_tvalid),
				.s_axis_tready(m_to_fifo_axis_tready),
				.s_axis_tlast(m_to_fifo_axis_tlast),
				.s_axis_tid(0),
				.s_axis_tdest(0),
				.s_axis_tuser(m_to_fifo_axis_tuser),

				// AXI output to audo core
				.m_axis_tdata(m_from_fifo_axis_tdata),
				.m_axis_tkeep(),
				.m_axis_tvalid(m_from_fifo_axis_tvalid),
				.m_axis_tready(m_from_fifo_axis_tready),
				.m_axis_tlast(m_from_fifo_axis_tlast),
				.m_axis_tid(),
				.m_axis_tdest(),
				.m_axis_tuser(m_from_fifo_axis_tuser),

				// Status
				.status_overflow(status_overflow),
				.status_bad_frame(),
				.status_good_frame()
			);
			
			
			axis_fifo #(
				.DEPTH(RX_OUT_FIFO_DEPTH),
				.DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
				.KEEP_ENABLE(0),
				.ID_ENABLE(0),
				.DEST_ENABLE(0),
				.USER_ENABLE(1),
				.USER_WIDTH(1),
				.FRAME_FIFO(0)
			) from_phy_to_cs_fifo (
				.clk(clk),
				.rst(rst || fifo_slot_reset),

				// AXIS input from udp core
				.s_axis_tdata(m_to_cs_fifo_axis_tdata),
				.s_axis_tkeep(0),//must default to high in docs but its very bad
				.s_axis_tvalid(m_to_cs_fifo_axis_tvalid),
				.s_axis_tready(m_to_cs_fifo_axis_tready),
				.s_axis_tlast(m_to_cs_fifo_axis_tlast),
				.s_axis_tid(0),
				.s_axis_tdest(0),
				.s_axis_tuser(m_to_cs_fifo_axis_tuser),

				// AXI output to audo core
				.m_axis_tdata(m_to_cs_axis_tdata),
				.m_axis_tkeep(),
				.m_axis_tvalid(m_to_cs_axis_tvalid),
				.m_axis_tready(m_to_cs_axis_tready),
				.m_axis_tlast(m_to_cs_axis_tlast),
				.m_axis_tid(),
				.m_axis_tdest(),
				.m_axis_tuser(m_to_cs_axis_tuser),

				// Status
				.status_overflow(status_overflow),
				.status_bad_frame(),
				.status_good_frame()
			);
			
			
			axis_fifo #(
				.DEPTH(RX_OUT_FIFO_DEPTH),
				.DATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
				.KEEP_ENABLE(0),
				.ID_ENABLE(0),
				.DEST_ENABLE(0),
				.USER_ENABLE(1),
				.USER_WIDTH(1),
				.FRAME_FIFO(0)
			) from_phy_to_ps_fifo (
				.clk(clk),
				.rst(rst || fifo_slot_reset),

				// AXIS input from udp core
				.s_axis_tdata(m_to_ps_fifo_axis_tdata),
				.s_axis_tkeep(0),//must default to high in docs but its very bad
				.s_axis_tvalid(m_to_ps_fifo_axis_tvalid),
				.s_axis_tready(m_to_ps_fifo_axis_tready),
				.s_axis_tlast(m_to_ps_fifo_axis_tlast),
				.s_axis_tid(0),
				.s_axis_tdest(0),
				.s_axis_tuser(m_to_ps_fifo_axis_tuser),

				// AXI output to audo core
				.m_axis_tdata(m_to_ps_axis_tdata),
				.m_axis_tkeep(),
				.m_axis_tvalid(m_to_ps_axis_tvalid),
				.m_axis_tready(m_to_ps_axis_tready),
				.m_axis_tlast(m_to_ps_axis_tlast),
				.m_axis_tid(),
				.m_axis_tdest(),
				.m_axis_tuser(m_to_ps_axis_tuser),

				// Status
				.status_overflow(status_overflow),
				.status_bad_frame(),
				.status_good_frame()
			);


endmodule

