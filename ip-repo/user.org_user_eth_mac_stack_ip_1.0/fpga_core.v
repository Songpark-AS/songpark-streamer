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
 * FPGA core logic
 */
module fpga_core #
(
    parameter TARGET = "XILINX"
)
(
    /*
     * Clock: 125MHz
     * Synchronous reset
     */
    input  wire       clk,
    input  wire       clk90,
    input  wire       rst,

    /*
     * Ethernet: 1000BASE-T RGMII
     */
    input  wire       phy_rx_clk,
    input  wire [3:0] phy_rxd,
    input  wire       phy_rx_ctl,
    output wire       phy_tx_clk,
    output wire [3:0] phy_txd,
    output wire       phy_tx_ctl,
    output wire       phy_reset_n,
    input  wire       phy_int_n,
    input  wire       phy_pme_n,  
    
    /*
     * AXIS input
     */
    input  wire [7:0]  s_tx_axis_tdata,
    input  wire        s_tx_axis_tvalid,
    output wire        s_tx_axis_tready,
    input  wire        s_tx_axis_tlast,
    input  wire        s_tx_axis_tuser,

    /*
     * AXIS output
     */
    output wire [7:0]  m_rx_axis_tdata,
    output wire        m_rx_axis_tvalid,
    input  wire        m_rx_axis_tready,
    output wire        m_rx_axis_tlast,
    output wire        m_rx_axis_tuser,
    
    

    /*
     * Status
     */
    output wire        tx_fifo_overflow,
    output wire        tx_fifo_bad_frame,
    output wire        tx_fifo_good_frame,
    output wire        rx_error_bad_frame,
    output wire        rx_error_bad_fcs,
    output wire        rx_fifo_overflow,
    output wire        rx_fifo_bad_frame,
    output wire        rx_fifo_good_frame,
    output wire [1:0]  speed,

    /*
     * Configuration
     */
    input  wire [7:0]  ifg_delay
);

// AXI between MAC and Ethernet modules
//wire [7:0] rx_axis_tdata;
//wire rx_axis_tvalid;
//wire rx_axis_tready;
//wire rx_axis_tlast;
//wire rx_axis_tuser;

//wire [7:0] tx_axis_tdata;
//wire tx_axis_tvalid;
//wire tx_axis_tready;
//wire tx_axis_tlast;
//wire tx_axis_tuser;

// Ethernet frame between Ethernet modules and UDP stack
//wire rx_eth_hdr_ready;
//wire rx_eth_hdr_valid;
//wire [47:0] rx_eth_dest_mac;
//wire [47:0] rx_eth_src_mac;
//wire [15:0] rx_eth_type;
//wire [7:0] rx_eth_payload_axis_tdata;
//wire rx_eth_payload_axis_tvalid;
//wire rx_eth_payload_axis_tready;
//wire rx_eth_payload_axis_tlast;
//wire rx_eth_payload_axis_tuser;

//wire tx_eth_hdr_ready;
//wire tx_eth_hdr_valid;
//wire [47:0] tx_eth_dest_mac;
//wire [47:0] tx_eth_src_mac;
//wire [15:0] tx_eth_type;
//wire [7:0] tx_eth_payload_axis_tdata;
//wire tx_eth_payload_axis_tvalid;
//wire tx_eth_payload_axis_tready;
//wire tx_eth_payload_axis_tlast;
//wire tx_eth_payload_axis_tuser;


// Configuration
//wire [47:0] local_mac   = 48'h02_00_00_00_00_00;
//wire [31:0] local_ip    = {8'd192, 8'd168, 8'd1,   8'd128};
//wire [31:0] gateway_ip  = {8'd192, 8'd168, 8'd1,   8'd1};
//wire [31:0] subnet_mask = {8'd255, 8'd255, 8'd255, 8'd0};

// IP ports not used




assign phy_reset_n = !rst;


eth_mac_1g_rgmii_fifo #(
    .TARGET(TARGET),
    .IODDR_STYLE("IODDR"),
    .CLOCK_INPUT_STYLE("BUFR"),
    .USE_CLK90("TRUE"),
    .ENABLE_PADDING(1),
    .MIN_FRAME_LENGTH(64),
    .TX_FIFO_ADDR_WIDTH(12),
    .TX_FRAME_FIFO(1),
    .RX_FIFO_ADDR_WIDTH(12),
    .RX_FRAME_FIFO(1)
)
eth_mac_inst (
    .gtx_clk(clk),
    .gtx_clk90(clk90),
    .gtx_rst(rst),
    .logic_clk(clk),
    .logic_rst(rst),

    .tx_axis_tdata(s_tx_axis_tdata),
    .tx_axis_tvalid(s_tx_axis_tvalid),
    .tx_axis_tready(s_tx_axis_tready),
    .tx_axis_tlast(s_tx_axis_tlast),
    .tx_axis_tuser(s_tx_axis_tuser),

    .rx_axis_tdata(m_rx_axis_tdata),
    .rx_axis_tvalid(m_rx_axis_tvalid),
    .rx_axis_tready(m_rx_axis_tready),
    .rx_axis_tlast(m_rx_axis_tlast),
    .rx_axis_tuser(m_rx_axis_tuser),

    .rgmii_rx_clk(phy_rx_clk),
    .rgmii_rxd(phy_rxd),
    .rgmii_rx_ctl(phy_rx_ctl),
    .rgmii_tx_clk(phy_tx_clk),
    .rgmii_txd(phy_txd),
    .rgmii_tx_ctl(phy_tx_ctl),

    .tx_fifo_overflow(),
    .tx_fifo_bad_frame(),
    .tx_fifo_good_frame(),
    .rx_error_bad_frame(),
    .rx_error_bad_fcs(),
    .rx_fifo_overflow(),
    .rx_fifo_bad_frame(),
    .rx_fifo_good_frame(),
    .speed(),

    .ifg_delay(12)
);




endmodule
