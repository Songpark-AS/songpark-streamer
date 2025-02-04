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


ARP or IP SELECT is done in the IP layer

udp_complete is the entry point of udp packets from lower layers

UDP select is in udp_complete

We hd added UDP select in the UDP rx to block non UDP packets fron interferring with our UDP streams ...

NON UDP packets should be routed as IP packets to the software, the software will then handle all NON UDP IP packets

This happens in udp_complete 

If m_ip_hdr_valid && !m_udp_hdr_valid ===> then we know that the packet is not a UDP packet to it should go to the CPU packet FIFO as an IP packet

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * FPGA top-level module
 */
module eth_eth_stack_ip (
    /*
     * Clock: 100MHz
     * Reset: Push button, active low
     */
    input  wire       clk,
    input  wire       reset_n,


    /*
     * AXI input
     */
    input  wire [7:0]  s_rx_axis_tdata,
    input  wire        s_rx_axis_tvalid,
    output wire        s_rx_axis_tready,
    input  wire        s_rx_axis_tlast,
    input  wire        s_rx_axis_tuser,

    /*
     * Ethernet frame output
     */
    output wire        m_eth_hdr_valid,
    input  wire        m_eth_hdr_ready,
    output wire [47:0] m_eth_dest_mac,
    output wire [47:0] m_eth_src_mac,
    output wire [15:0] m_eth_type,
    output wire [7:0]  m_eth_payload_axis_tdata,
    output wire        m_eth_payload_axis_tvalid,
    input  wire        m_eth_payload_axis_tready,
    output wire        m_eth_payload_axis_tlast,
    output wire        m_eth_payload_axis_tuser,

    /*
     * RX Status signals
     */
    output wire        rx_busy,
    output wire        error_header_early_termination,
    
    
    
    
    
    /*AXIS TX
     * Ethernet frame input
     */
    input  wire        s_eth_hdr_valid,
    output wire        s_eth_hdr_ready,
    input  wire [47:0] s_eth_dest_mac,
    input  wire [47:0] s_eth_src_mac,
    input  wire [15:0] s_eth_type,
    input  wire [7:0]  s_eth_payload_axis_tdata,
    input  wire        s_eth_payload_axis_tvalid,
    output wire        s_eth_payload_axis_tready,
    input  wire        s_eth_payload_axis_tlast,
    input  wire        s_eth_payload_axis_tuser,

    /*
     * AXI output
     */
    output wire [7:0]  m_tx_axis_tdata,
    output wire        m_tx_axis_tvalid,
    input  wire        m_tx_axis_tready,
    output wire        m_tx_axis_tlast,
    output wire        m_tx_axis_tuser,

    /*
     * TX Status signals
     */
    output wire        tx_busy
);





fpga_core
core_inst (
    /*
     * Clock: 125MHz
     * Synchronous reset
     */
    .clk(clk),
    .rst(reset_n),
    
    
    
    /*
     * AXI input
     */
    .s_rx_axis_tdata(s_rx_axis_tdata),
    .s_rx_axis_tvalid(s_rx_axis_tvalid),
    .s_rx_axis_tready(s_rx_axis_tready),
    .s_rx_axis_tlast(s_rx_axis_tlast),
    .s_rx_axis_tuser(s_rx_axis_tuser),

    /*
     * Ethernet frame output
     */
    .m_eth_hdr_valid(m_eth_hdr_valid),
    .m_eth_hdr_ready(m_eth_hdr_ready),
    .m_eth_dest_mac(m_eth_dest_mac),
    .m_eth_src_mac(m_eth_src_mac),
    .m_eth_type(m_eth_type),
    .m_eth_payload_axis_tdata(m_eth_payload_axis_tdata),
    .m_eth_payload_axis_tvalid(m_eth_payload_axis_tvalid),
    .m_eth_payload_axis_tready(m_eth_payload_axis_tready),
    .m_eth_payload_axis_tlast(m_eth_payload_axis_tlast),
    .m_eth_payload_axis_tuser(m_eth_payload_axis_tuser),

    /*
     * RX Status signals
     */
    .rx_busy(rx_busy),
    .error_header_early_termination(error_header_early_termination),
    
    
    
    
    
    /*AXIS TX
     * Ethernet frame input
     */
    .s_eth_hdr_valid(s_eth_hdr_valid),
    .s_eth_hdr_ready(s_eth_hdr_ready),
    .s_eth_dest_mac(s_eth_dest_mac),
    .s_eth_src_mac(s_eth_src_mac),
    .s_eth_type(s_eth_type),
    .s_eth_payload_axis_tdata(s_eth_payload_axis_tdata),
    .s_eth_payload_axis_tvalid(s_eth_payload_axis_tvalid),
    .s_eth_payload_axis_tready(s_eth_payload_axis_tready),
    .s_eth_payload_axis_tlast(s_eth_payload_axis_tlast),
    .s_eth_payload_axis_tuser(s_eth_payload_axis_tuser),

    /*
     * AXI output
     */
    .m_tx_axis_tdata(m_tx_axis_tdata),
    .m_tx_axis_tvalid(m_tx_axis_tvalid),
    .m_tx_axis_tready(m_tx_axis_tready),
    .m_tx_axis_tlast(m_tx_axis_tlast),
    .m_tx_axis_tuser(m_tx_axis_tuser),

    /*
     * TX Status signals
     */
    .tx_busy(tx_busy)
    
    
);

endmodule
