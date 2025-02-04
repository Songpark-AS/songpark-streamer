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


// IP VLNV: user.org:user:user_org_plc_seq_ip:1.0
// IP Revision: 455

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module cantavi_streamer_project_user_org_plc_seq_ip_0_0 (
  clk_125,
  rst_in,
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
  fm_udp_s_axis_aclk,
  fm_udp_s_axis_aresetn,
  fm_udp_s_axis_tready,
  fm_udp_s_axis_tdata,
  fm_udp_s_axis_tlast,
  fm_udp_s_axis_tvalid,
  fm_audio_s_axis_aclk,
  fm_audio_s_axis_aresetn,
  fm_audio_s_axis_tready,
  fm_audio_s_axis_tdata,
  fm_audio_s_axis_tlast,
  fm_audio_s_axis_tvalid,
  fm_audio_hdr_valid,
  to_udp_m_axis_aclk,
  to_udp_m_axis_aresetn,
  to_udp_m_axis_tvalid,
  to_udp_m_axis_tdata,
  to_udp_m_axis_tlast,
  to_udp_m_axis_tready,
  to_udp_hdr_valid,
  to_audio_m_axis_aclk,
  to_audio_m_axis_aresetn,
  to_audio_m_axis_tvalid,
  to_audio_m_axis_tdata,
  to_audio_m_axis_tlast,
  to_audio_m_axis_tready,
  fifo_occ_in,
  replace_pkt_in,
  play_out_ready_in,
  new_sample_in,
  fifo_full_in,
  fifo_empty_in,
  fifo_full_out,
  fifo_empty_out,
  status1_out,
  status2_out,
  replace_inprogress_out,
  new_pkt_ready_out,
  replace_pkt_end_in,
  tsync_in,
  sync_en_in,
  path_tc_valid_out,
  path_tx_tc_code_out,
  path_rx_tc_code_out,
  path_rx_seq_num_out,
  play_out_delay_in,
  next_play_out_time_in,
  current_sync_time_in,
  skip_slot_in,
  packet_available_out,
  s00_axi_aclk,
  s00_axi_aresetn
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk_125, ASSOCIATED_BUSIF fm_audio_s_axis, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk_125 CLK" *)
input wire clk_125;
input wire rst_in;
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
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fm_udp_s_axis_aclk, ASSOCIATED_RESET fm_udp_s_axis_aresetn, ASSOCIATED_BUSIF fm_udp_s_axis, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 fm_udp_s_axis_aclk CLK" *)
input wire fm_udp_s_axis_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fm_udp_s_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 fm_udp_s_axis_aresetn RST" *)
input wire fm_udp_s_axis_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 fm_udp_s_axis TREADY" *)
output wire fm_udp_s_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 fm_udp_s_axis TDATA" *)
input wire [7 : 0] fm_udp_s_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 fm_udp_s_axis TLAST" *)
input wire fm_udp_s_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fm_udp_s_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 fm_udp_s_axis TVALID" *)
input wire fm_udp_s_axis_tvalid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fm_audio_s_axis_aclk, ASSOCIATED_RESET fm_audio_s_axis_aresetn, ASSOCIATED_BUSIF fm_audio_s_axis, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 fm_audio_s_axis_aclk CLK" *)
input wire fm_audio_s_axis_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fm_audio_s_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 fm_audio_s_axis_aresetn RST" *)
input wire fm_audio_s_axis_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 fm_audio_s_axis TREADY" *)
output wire fm_audio_s_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 fm_audio_s_axis TDATA" *)
input wire [7 : 0] fm_audio_s_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 fm_audio_s_axis TLAST" *)
input wire fm_audio_s_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fm_audio_s_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 fm_audio_s_axis TVALID" *)
input wire fm_audio_s_axis_tvalid;
input wire fm_audio_hdr_valid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME to_udp_m_axis_aclk, ASSOCIATED_RESET to_udp_m_axis_aresetn, ASSOCIATED_BUSIF to_udp_m_axis, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 to_udp_m_axis_aclk CLK" *)
input wire to_udp_m_axis_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME to_udp_m_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 to_udp_m_axis_aresetn RST" *)
input wire to_udp_m_axis_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_udp_m_axis TVALID" *)
output wire to_udp_m_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_udp_m_axis TDATA" *)
output wire [7 : 0] to_udp_m_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_udp_m_axis TLAST" *)
output wire to_udp_m_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME to_udp_m_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_udp_m_axis TREADY" *)
input wire to_udp_m_axis_tready;
output wire to_udp_hdr_valid;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME to_audio_m_axis_aclk, ASSOCIATED_RESET to_audio_m_axis_aresetn, ASSOCIATED_BUSIF to_audio_m_axis, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 to_audio_m_axis_aclk CLK" *)
input wire to_audio_m_axis_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME to_audio_m_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 to_audio_m_axis_aresetn RST" *)
input wire to_audio_m_axis_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_audio_m_axis TVALID" *)
output wire to_audio_m_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_audio_m_axis TDATA" *)
output wire [7 : 0] to_audio_m_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_audio_m_axis TLAST" *)
output wire to_audio_m_axis_tlast;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME to_audio_m_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 to_audio_m_axis TREADY" *)
input wire to_audio_m_axis_tready;
input wire [9 : 0] fifo_occ_in;
input wire replace_pkt_in;
input wire play_out_ready_in;
input wire new_sample_in;
input wire fifo_full_in;
input wire fifo_empty_in;
output wire fifo_full_out;
output wire fifo_empty_out;
output wire status1_out;
output wire status2_out;
output wire replace_inprogress_out;
output wire new_pkt_ready_out;
input wire replace_pkt_end_in;
input wire tsync_in;
input wire sync_en_in;
output wire path_tc_valid_out;
output wire [31 : 0] path_tx_tc_code_out;
output wire [31 : 0] path_rx_tc_code_out;
output wire [15 : 0] path_rx_seq_num_out;
input wire [31 : 0] play_out_delay_in;
input wire [31 : 0] next_play_out_time_in;
input wire [31 : 0] current_sync_time_in;
input wire skip_slot_in;
output wire packet_available_out;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK" *)
input wire s00_axi_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_AXI_RST RST" *)
input wire s00_axi_aresetn;

  plc_seq_ip #(
    .C_S00_AXI_DATA_WIDTH(32),  // Width of S_AXI data bus
    .C_S00_AXI_ADDR_WIDTH(8),  // Width of S_AXI address bus
    .S_COUNT(64),
    .PACKET_SKIP_DEFAULT(8),
    .SHIFTS_PER_MILLISECOND(17),
    .DELAY_COUNT_WIDTH(64),
    .C_fm_udp_s_axis_TDATA_WIDTH(8),
    .C_fm_audio_s_axis_TDATA_WIDTH(8),
    .C_to_udp_m_axis_TDATA_WIDTH(8),
    .C_to_udp_m_axis_START_COUNT(32),
    .C_to_audio_m_axis_TDATA_WIDTH(8),
    .C_to_audio_m_axis_START_COUNT(32),
    .FIFO_ADDR_WIDTH(10),
    .PACKET_LEN_WIDTH(16),
    .C_S_AXI_DATA_WIDTH(32),
    .SEQ_BANK_FIFO_ADDR_WIDTH(9),
    .SYNC_COUNT_WIDTH(32),
    .CORE_VERSION(22),
    .RTP_HDR_SEQ_WIDTH(16),
    .TC_BIT_LENGTH(32)
  ) inst (
    .clk_125(clk_125),
    .rst_in(rst_in),
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
    .fm_udp_s_axis_aclk(fm_udp_s_axis_aclk),
    .fm_udp_s_axis_aresetn(fm_udp_s_axis_aresetn),
    .fm_udp_s_axis_tready(fm_udp_s_axis_tready),
    .fm_udp_s_axis_tdata(fm_udp_s_axis_tdata),
    .fm_udp_s_axis_tlast(fm_udp_s_axis_tlast),
    .fm_udp_s_axis_tvalid(fm_udp_s_axis_tvalid),
    .fm_audio_s_axis_aclk(fm_audio_s_axis_aclk),
    .fm_audio_s_axis_aresetn(fm_audio_s_axis_aresetn),
    .fm_audio_s_axis_tready(fm_audio_s_axis_tready),
    .fm_audio_s_axis_tdata(fm_audio_s_axis_tdata),
    .fm_audio_s_axis_tlast(fm_audio_s_axis_tlast),
    .fm_audio_s_axis_tvalid(fm_audio_s_axis_tvalid),
    .fm_audio_hdr_valid(fm_audio_hdr_valid),
    .to_udp_m_axis_aclk(to_udp_m_axis_aclk),
    .to_udp_m_axis_aresetn(to_udp_m_axis_aresetn),
    .to_udp_m_axis_tvalid(to_udp_m_axis_tvalid),
    .to_udp_m_axis_tdata(to_udp_m_axis_tdata),
    .to_udp_m_axis_tlast(to_udp_m_axis_tlast),
    .to_udp_m_axis_tready(to_udp_m_axis_tready),
    .to_udp_hdr_valid(to_udp_hdr_valid),
    .to_audio_m_axis_aclk(to_audio_m_axis_aclk),
    .to_audio_m_axis_aresetn(to_audio_m_axis_aresetn),
    .to_audio_m_axis_tvalid(to_audio_m_axis_tvalid),
    .to_audio_m_axis_tdata(to_audio_m_axis_tdata),
    .to_audio_m_axis_tlast(to_audio_m_axis_tlast),
    .to_audio_m_axis_tready(to_audio_m_axis_tready),
    .fifo_occ_in(fifo_occ_in),
    .replace_pkt_in(replace_pkt_in),
    .play_out_ready_in(play_out_ready_in),
    .new_sample_in(new_sample_in),
    .fifo_full_in(fifo_full_in),
    .fifo_empty_in(fifo_empty_in),
    .fifo_full_out(fifo_full_out),
    .fifo_empty_out(fifo_empty_out),
    .status1_out(status1_out),
    .status2_out(status2_out),
    .replace_inprogress_out(replace_inprogress_out),
    .new_pkt_ready_out(new_pkt_ready_out),
    .replace_pkt_end_in(replace_pkt_end_in),
    .tsync_in(tsync_in),
    .sync_en_in(sync_en_in),
    .path_tc_valid_out(path_tc_valid_out),
    .path_tx_tc_code_out(path_tx_tc_code_out),
    .path_rx_tc_code_out(path_rx_tc_code_out),
    .path_rx_seq_num_out(path_rx_seq_num_out),
    .play_out_delay_in(play_out_delay_in),
    .next_play_out_time_in(next_play_out_time_in),
    .current_sync_time_in(current_sync_time_in),
    .skip_slot_in(skip_slot_in),
    .packet_available_out(packet_available_out),
    .s00_axi_aclk(s00_axi_aclk),
    .s00_axi_aresetn(s00_axi_aresetn)
  );
endmodule
