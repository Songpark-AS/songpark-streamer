// (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:user:eth_udp_axi_arp_stack:1.0
// IP Revision: 123

(* X_CORE_INFO = "user_eth_udp_axi_arp_stack_v1_0,Vivado 2018.3" *)
(* CHECK_LICENSE_TYPE = "cantavi_streamer_project_eth_udp_axi_arp_stack_0_0,user_eth_udp_axi_arp_stack_v1_0,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module cantavi_streamer_project_eth_udp_axi_arp_stack_0_0 (
  clk_100_in,
  clk_125_in,
  reset_n,
  rst_in,
  btnu,
  btnl,
  btnd,
  btnr,
  btnc,
  sw,
  led,
  from_sw_rx_axis_tdata,
  from_sw_rx_axis_tvalid,
  from_sw_rx_axis_tready,
  from_sw_rx_axis_tlast,
  from_sw_rx_axis_tuser,
  to_sw_tx_axis_tdata,
  to_sw_tx_axis_tvalid,
  to_sw_tx_axis_tready,
  to_sw_tx_axis_tlast,
  to_sw_tx_axis_tuser,
  to_sw_ifg_delay,
  from_sw_tx_fifo_overflow,
  from_sw_tx_fifo_bad_frame,
  from_sw_tx_fifo_good_frame,
  from_sw_rx_error_bad_frame,
  from_sw_rx_error_bad_fcs,
  from_sw_rx_fifo_overflow,
  from_sw_rx_fifo_bad_frame,
  from_sw_rx_fifo_good_frame,
  from_sw_speed,
  sw_sel_status,
  m_time_sync_payload_axis_tdata,
  m_time_sync_payload_axis_tvalid,
  m_time_sync_payload_axis_tready,
  m_time_sync_payload_axis_tlast,
  m_time_sync_payload_axis_tuser,
  m_time_sync_payload_hdr_valid,
  m_time_sync_payload_hdr_ready,
  s_time_sync_payload_axis_tdata,
  s_time_sync_payload_axis_tvalid,
  s_time_sync_payload_axis_tready,
  s_time_sync_payload_axis_tlast,
  s_time_sync_payload_axis_tuser,
  s_time_sync_payload_hdr_valid,
  s_time_sync_payload_hdr_ready,
  s_time_sync_payload_length,
  initiate_sync_request_in,
  sync_done_in,
  m_ch1_audio_payload_axis_tdata,
  m_ch1_audio_payload_axis_tvalid,
  m_ch1_audio_payload_axis_tready,
  m_ch1_audio_payload_axis_tlast,
  m_ch1_audio_payload_axis_tuser,
  m_ch1_audio_payload_hdr_valid,
  m_ch1_audio_payload_hdr_ready,
  s_audio_payload_axis_tdata,
  s_audio_payload_axis_tvalid,
  s_audio_payload_axis_tready,
  s_audio_payload_axis_tlast,
  s_audio_payload_axis_tuser,
  s_audio_payload_hdr_valid,
  s_audio_payload_hdr_ready,
  udp_payload_length,
  fifo_full_in,
  fifo_empty_in,
  sync_request_rx_in,
  initiate_sync_response_in,
  seq_status1_in,
  seq_status2_in,
  tsync_status1_in,
  tsync_status2_in,
  stream_resetn_out,
  media_pkt_tx_en_out,
  uart_rxd,
  uart_txd,
  s00_axi_awaddr,
  s00_axi_awprot,
  s00_axi_awvalid,
  s00_axi_awready,
  s00_axi_wdata,
  s00_axi_wstrb,
  s00_axi_wvalid,
  s00_axi_wready,
  s00_axi_bresp,
  s00_axi_bvalid,
  s00_axi_bready,
  s00_axi_araddr,
  s00_axi_arprot,
  s00_axi_arvalid,
  s00_axi_arready,
  s00_axi_rdata,
  s00_axi_rresp,
  s00_axi_rvalid,
  s00_axi_rready,
  s00_axi_aclk,
  s00_axi_aresetn
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk_100_in, ASSOCIATED_RESET rst_in, FREQ_HZ 100000000, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk_100_in CLK" *)
input wire clk_100_in;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk_125_in, FREQ_HZ 125000000, ASSOCIATED_BUSIF from_sw_rx_axis:s_time_sync_payload_axis:s_audio_payload_axis:m_time_sync_payload_axis:m_ch1_audio_payload_axis:to_sw_tx_axis, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk_125_in CLK" *)
input wire clk_125_in;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_n RST" *)
input wire reset_n;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_in, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_in RST" *)
input wire rst_in;
input wire btnu;
input wire btnl;
input wire btnd;
input wire btnr;
input wire btnc;
input wire [7 : 0] sw;
output wire [7 : 0] led;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 from_sw_rx_axis TDATA" *)
input wire [7 : 0] from_sw_rx_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 from_sw_rx_axis TVALID" *)
input wire from_sw_rx_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 from_sw_rx_axis TREADY" *)
output wire from_sw_rx_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 from_sw_rx_axis TLAST" *)
input wire from_sw_rx_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME from_sw_rx_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 from_sw_rx_axis TUSER" *)
input wire from_sw_rx_axis_tuser;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_sw_tx_axis TDATA" *)
output wire [7 : 0] to_sw_tx_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_sw_tx_axis TVALID" *)
output wire to_sw_tx_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_sw_tx_axis TREADY" *)
input wire to_sw_tx_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_sw_tx_axis TLAST" *)
output wire to_sw_tx_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME to_sw_tx_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_sw_tx_axis TUSER" *)
output wire to_sw_tx_axis_tuser;
output wire [7 : 0] to_sw_ifg_delay;
input wire from_sw_tx_fifo_overflow;
input wire from_sw_tx_fifo_bad_frame;
input wire from_sw_tx_fifo_good_frame;
input wire from_sw_rx_error_bad_frame;
input wire from_sw_rx_error_bad_fcs;
input wire from_sw_rx_fifo_overflow;
input wire from_sw_rx_fifo_bad_frame;
input wire from_sw_rx_fifo_good_frame;
input wire [1 : 0] from_sw_speed;
input wire sw_sel_status;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_time_sync_payload_axis TDATA" *)
output wire [7 : 0] m_time_sync_payload_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_time_sync_payload_axis TVALID" *)
output wire m_time_sync_payload_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_time_sync_payload_axis TREADY" *)
input wire m_time_sync_payload_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_time_sync_payload_axis TLAST" *)
output wire m_time_sync_payload_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_time_sync_payload_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_time_sync_payload_axis TUSER" *)
output wire m_time_sync_payload_axis_tuser;
output wire m_time_sync_payload_hdr_valid;
input wire m_time_sync_payload_hdr_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_time_sync_payload_axis TDATA" *)
input wire [7 : 0] s_time_sync_payload_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_time_sync_payload_axis TVALID" *)
input wire s_time_sync_payload_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_time_sync_payload_axis TREADY" *)
output wire s_time_sync_payload_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_time_sync_payload_axis TLAST" *)
input wire s_time_sync_payload_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_time_sync_payload_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_time_sync_payload_axis TUSER" *)
input wire s_time_sync_payload_axis_tuser;
input wire s_time_sync_payload_hdr_valid;
output wire s_time_sync_payload_hdr_ready;
input wire [15 : 0] s_time_sync_payload_length;
input wire initiate_sync_request_in;
input wire sync_done_in;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_ch1_audio_payload_axis TDATA" *)
output wire [7 : 0] m_ch1_audio_payload_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_ch1_audio_payload_axis TVALID" *)
output wire m_ch1_audio_payload_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_ch1_audio_payload_axis TREADY" *)
input wire m_ch1_audio_payload_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_ch1_audio_payload_axis TLAST" *)
output wire m_ch1_audio_payload_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_ch1_audio_payload_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_ch1_audio_payload_axis TUSER" *)
output wire m_ch1_audio_payload_axis_tuser;
output wire m_ch1_audio_payload_hdr_valid;
input wire m_ch1_audio_payload_hdr_ready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_audio_payload_axis TDATA" *)
input wire [7 : 0] s_audio_payload_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_audio_payload_axis TVALID" *)
input wire s_audio_payload_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_audio_payload_axis TREADY" *)
output wire s_audio_payload_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_audio_payload_axis TLAST" *)
input wire s_audio_payload_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_audio_payload_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_audio_payload_axis TUSER" *)
input wire s_audio_payload_axis_tuser;
input wire s_audio_payload_hdr_valid;
output wire s_audio_payload_hdr_ready;
input wire [15 : 0] udp_payload_length;
input wire fifo_full_in;
input wire fifo_empty_in;
input wire sync_request_rx_in;
input wire initiate_sync_response_in;
input wire seq_status1_in;
input wire seq_status2_in;
input wire tsync_status1_in;
input wire tsync_status2_in;
output wire stream_resetn_out;
output wire media_pkt_tx_en_out;
input wire uart_rxd;
output wire uart_txd;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR" *)
input wire [7 : 0] s00_axi_awaddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT" *)
input wire [2 : 0] s00_axi_awprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID" *)
input wire s00_axi_awvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY" *)
output wire s00_axi_awready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WDATA" *)
input wire [31 : 0] s00_axi_wdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB" *)
input wire [3 : 0] s00_axi_wstrb;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WVALID" *)
input wire s00_axi_wvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WREADY" *)
output wire s00_axi_wready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BRESP" *)
output wire [1 : 0] s00_axi_bresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BVALID" *)
output wire s00_axi_bvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BREADY" *)
input wire s00_axi_bready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR" *)
input wire [7 : 0] s00_axi_araddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT" *)
input wire [2 : 0] s00_axi_arprot;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID" *)
input wire s00_axi_arvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY" *)
output wire s00_axi_arready;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RDATA" *)
output wire [31 : 0] s00_axi_rdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RRESP" *)
output wire [1 : 0] s00_axi_rresp;
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RVALID" *)
output wire s00_axi_rvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 8, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN cantavi_streamer_projec\
t_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RREADY" *)
input wire s00_axi_rready;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK" *)
input wire s00_axi_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_AXI_RST RST" *)
input wire s00_axi_aresetn;

  user_eth_udp_axi_arp_stack_v1_0 #(
    .C_S00_AXI_DATA_WIDTH(32),  // Width of S_AXI data bus
    .C_S00_AXI_ADDR_WIDTH(8),  // Width of S_AXI address bus
    .UDP_DATA_WIDTH(8),
    .UDP_IP_WIDTH(32),
    .UDP_MAC_WIDTH(48),
    .UDP_LENGTH_WIDTH(16),
    .UDP_PORT_WIDTH(16),
    .SESSION_USERS_COUNT(2),
    .SYNC_FIFO_ADDR_WIDTH(6),
    .AUDIO_FIFO_ADDR_WIDTH(12),
    .TARGET("XILINX")
  ) inst (
    .clk_100_in(clk_100_in),
    .clk_125_in(clk_125_in),
    .reset_n(reset_n),
    .rst_in(rst_in),
    .btnu(btnu),
    .btnl(btnl),
    .btnd(btnd),
    .btnr(btnr),
    .btnc(btnc),
    .sw(sw),
    .led(led),
    .from_sw_rx_axis_tdata(from_sw_rx_axis_tdata),
    .from_sw_rx_axis_tvalid(from_sw_rx_axis_tvalid),
    .from_sw_rx_axis_tready(from_sw_rx_axis_tready),
    .from_sw_rx_axis_tlast(from_sw_rx_axis_tlast),
    .from_sw_rx_axis_tuser(from_sw_rx_axis_tuser),
    .to_sw_tx_axis_tdata(to_sw_tx_axis_tdata),
    .to_sw_tx_axis_tvalid(to_sw_tx_axis_tvalid),
    .to_sw_tx_axis_tready(to_sw_tx_axis_tready),
    .to_sw_tx_axis_tlast(to_sw_tx_axis_tlast),
    .to_sw_tx_axis_tuser(to_sw_tx_axis_tuser),
    .to_sw_ifg_delay(to_sw_ifg_delay),
    .from_sw_tx_fifo_overflow(from_sw_tx_fifo_overflow),
    .from_sw_tx_fifo_bad_frame(from_sw_tx_fifo_bad_frame),
    .from_sw_tx_fifo_good_frame(from_sw_tx_fifo_good_frame),
    .from_sw_rx_error_bad_frame(from_sw_rx_error_bad_frame),
    .from_sw_rx_error_bad_fcs(from_sw_rx_error_bad_fcs),
    .from_sw_rx_fifo_overflow(from_sw_rx_fifo_overflow),
    .from_sw_rx_fifo_bad_frame(from_sw_rx_fifo_bad_frame),
    .from_sw_rx_fifo_good_frame(from_sw_rx_fifo_good_frame),
    .from_sw_speed(from_sw_speed),
    .sw_sel_status(sw_sel_status),
    .m_time_sync_payload_axis_tdata(m_time_sync_payload_axis_tdata),
    .m_time_sync_payload_axis_tvalid(m_time_sync_payload_axis_tvalid),
    .m_time_sync_payload_axis_tready(m_time_sync_payload_axis_tready),
    .m_time_sync_payload_axis_tlast(m_time_sync_payload_axis_tlast),
    .m_time_sync_payload_axis_tuser(m_time_sync_payload_axis_tuser),
    .m_time_sync_payload_hdr_valid(m_time_sync_payload_hdr_valid),
    .m_time_sync_payload_hdr_ready(m_time_sync_payload_hdr_ready),
    .s_time_sync_payload_axis_tdata(s_time_sync_payload_axis_tdata),
    .s_time_sync_payload_axis_tvalid(s_time_sync_payload_axis_tvalid),
    .s_time_sync_payload_axis_tready(s_time_sync_payload_axis_tready),
    .s_time_sync_payload_axis_tlast(s_time_sync_payload_axis_tlast),
    .s_time_sync_payload_axis_tuser(s_time_sync_payload_axis_tuser),
    .s_time_sync_payload_hdr_valid(s_time_sync_payload_hdr_valid),
    .s_time_sync_payload_hdr_ready(s_time_sync_payload_hdr_ready),
    .s_time_sync_payload_length(s_time_sync_payload_length),
    .initiate_sync_request_in(initiate_sync_request_in),
    .sync_done_in(sync_done_in),
    .m_ch1_audio_payload_axis_tdata(m_ch1_audio_payload_axis_tdata),
    .m_ch1_audio_payload_axis_tvalid(m_ch1_audio_payload_axis_tvalid),
    .m_ch1_audio_payload_axis_tready(m_ch1_audio_payload_axis_tready),
    .m_ch1_audio_payload_axis_tlast(m_ch1_audio_payload_axis_tlast),
    .m_ch1_audio_payload_axis_tuser(m_ch1_audio_payload_axis_tuser),
    .m_ch1_audio_payload_hdr_valid(m_ch1_audio_payload_hdr_valid),
    .m_ch1_audio_payload_hdr_ready(m_ch1_audio_payload_hdr_ready),
    .s_audio_payload_axis_tdata(s_audio_payload_axis_tdata),
    .s_audio_payload_axis_tvalid(s_audio_payload_axis_tvalid),
    .s_audio_payload_axis_tready(s_audio_payload_axis_tready),
    .s_audio_payload_axis_tlast(s_audio_payload_axis_tlast),
    .s_audio_payload_axis_tuser(s_audio_payload_axis_tuser),
    .s_audio_payload_hdr_valid(s_audio_payload_hdr_valid),
    .s_audio_payload_hdr_ready(s_audio_payload_hdr_ready),
    .udp_payload_length(udp_payload_length),
    .fifo_full_in(fifo_full_in),
    .fifo_empty_in(fifo_empty_in),
    .sync_request_rx_in(sync_request_rx_in),
    .initiate_sync_response_in(initiate_sync_response_in),
    .seq_status1_in(seq_status1_in),
    .seq_status2_in(seq_status2_in),
    .tsync_status1_in(tsync_status1_in),
    .tsync_status2_in(tsync_status2_in),
    .stream_resetn_out(stream_resetn_out),
    .media_pkt_tx_en_out(media_pkt_tx_en_out),
    .uart_rxd(uart_rxd),
    .uart_txd(uart_txd),
    .s00_axi_awaddr(s00_axi_awaddr),
    .s00_axi_awprot(s00_axi_awprot),
    .s00_axi_awvalid(s00_axi_awvalid),
    .s00_axi_awready(s00_axi_awready),
    .s00_axi_wdata(s00_axi_wdata),
    .s00_axi_wstrb(s00_axi_wstrb),
    .s00_axi_wvalid(s00_axi_wvalid),
    .s00_axi_wready(s00_axi_wready),
    .s00_axi_bresp(s00_axi_bresp),
    .s00_axi_bvalid(s00_axi_bvalid),
    .s00_axi_bready(s00_axi_bready),
    .s00_axi_araddr(s00_axi_araddr),
    .s00_axi_arprot(s00_axi_arprot),
    .s00_axi_arvalid(s00_axi_arvalid),
    .s00_axi_arready(s00_axi_arready),
    .s00_axi_rdata(s00_axi_rdata),
    .s00_axi_rresp(s00_axi_rresp),
    .s00_axi_rvalid(s00_axi_rvalid),
    .s00_axi_rready(s00_axi_rready),
    .s00_axi_aclk(s00_axi_aclk),
    .s00_axi_aresetn(s00_axi_aresetn)
  );
endmodule
