-- (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: me:user:time_sync_block:2.0
-- IP Revision: 408

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cantavi_streamer_project_time_sync_block_0_0 IS
  PORT (
    newsample_in : IN STD_LOGIC;
    tc_running_in : IN STD_LOGIC;
    sync_request_rx_out : OUT STD_LOGIC;
    initiate_sync_request_out : OUT STD_LOGIC;
    initiate_sync_response_out : OUT STD_LOGIC;
    sync_response_done : OUT STD_LOGIC;
    sync_done_out : OUT STD_LOGIC;
    status1_out : OUT STD_LOGIC;
    status2_out : OUT STD_LOGIC;
    tc_sync_en_out : OUT STD_LOGIC;
    tc_adjust_out : OUT STD_LOGIC;
    sync_time_code_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    media_pkt_tx_en_in : IN STD_LOGIC;
    path_tc_valid_in : IN STD_LOGIC;
    path_tx_tc_code_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    path_rx_tc_code_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    CLK_125 : IN STD_LOGIC;
    round_path_delay_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rx_packet_seq_cnt_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_time_sync_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_time_sync_axis_tvalid : OUT STD_LOGIC;
    m_time_sync_axis_tready : IN STD_LOGIC;
    m_time_sync_axis_tlast : OUT STD_LOGIC;
    m_time_sync_axis_tuser : OUT STD_LOGIC;
    m_time_sync_hdr_valid : OUT STD_LOGIC;
    m_time_sync_hdr_ready : IN STD_LOGIC;
    s_time_sync_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_time_sync_axis_tvalid : IN STD_LOGIC;
    s_time_sync_axis_tready : OUT STD_LOGIC;
    s_time_sync_axis_tlast : IN STD_LOGIC;
    s_time_sync_axis_tuser : IN STD_LOGIC;
    s_time_sync_hdr_ready : OUT STD_LOGIC;
    udp_payload_length : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    s00_axi_awaddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    s00_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s00_axi_awvalid : IN STD_LOGIC;
    s00_axi_awready : OUT STD_LOGIC;
    s00_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s00_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s00_axi_wvalid : IN STD_LOGIC;
    s00_axi_wready : OUT STD_LOGIC;
    s00_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s00_axi_bvalid : OUT STD_LOGIC;
    s00_axi_bready : IN STD_LOGIC;
    s00_axi_araddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    s00_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s00_axi_arvalid : IN STD_LOGIC;
    s00_axi_arready : OUT STD_LOGIC;
    s00_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s00_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s00_axi_rvalid : OUT STD_LOGIC;
    s00_axi_rready : IN STD_LOGIC;
    s00_axi_aclk : IN STD_LOGIC;
    s00_axi_aresetn : IN STD_LOGIC
  );
END cantavi_streamer_project_time_sync_block_0_0;

ARCHITECTURE cantavi_streamer_project_time_sync_block_0_0_arch OF cantavi_streamer_project_time_sync_block_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF cantavi_streamer_project_time_sync_block_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT time_sync_block_v2_0 IS
    GENERIC (
      C_S00_AXI_DATA_WIDTH : INTEGER; -- Width of S_AXI data bus
      C_S00_AXI_ADDR_WIDTH : INTEGER; -- Width of S_AXI address bus
      AXIS_UDP_DATA_WIDTH : INTEGER;
      SINE_DIV_WIDTH : INTEGER;
      PACKET_SEQ_W : INTEGER;
      PACKET_LEN_WIDTH : INTEGER;
      SEQ_NUM_LENGTH : INTEGER;
      TC_LENGTH : INTEGER;
      TC_BIT_LENGTH : INTEGER;
      TC_COUNT_WIDTH : INTEGER;
      MIN_UDP_PKT_SIZE : INTEGER;
      UDP_LENGTH_WIDTH : INTEGER
    );
    PORT (
      newsample_in : IN STD_LOGIC;
      tc_running_in : IN STD_LOGIC;
      sync_request_rx_out : OUT STD_LOGIC;
      initiate_sync_request_out : OUT STD_LOGIC;
      initiate_sync_response_out : OUT STD_LOGIC;
      sync_response_done : OUT STD_LOGIC;
      sync_done_out : OUT STD_LOGIC;
      status1_out : OUT STD_LOGIC;
      status2_out : OUT STD_LOGIC;
      tc_sync_en_out : OUT STD_LOGIC;
      tc_adjust_out : OUT STD_LOGIC;
      sync_time_code_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      media_pkt_tx_en_in : IN STD_LOGIC;
      path_tc_valid_in : IN STD_LOGIC;
      path_tx_tc_code_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      path_rx_tc_code_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      CLK_125 : IN STD_LOGIC;
      round_path_delay_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rx_packet_seq_cnt_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      m_time_sync_axis_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_time_sync_axis_tvalid : OUT STD_LOGIC;
      m_time_sync_axis_tready : IN STD_LOGIC;
      m_time_sync_axis_tlast : OUT STD_LOGIC;
      m_time_sync_axis_tuser : OUT STD_LOGIC;
      m_time_sync_hdr_valid : OUT STD_LOGIC;
      m_time_sync_hdr_ready : IN STD_LOGIC;
      s_time_sync_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_time_sync_axis_tvalid : IN STD_LOGIC;
      s_time_sync_axis_tready : OUT STD_LOGIC;
      s_time_sync_axis_tlast : IN STD_LOGIC;
      s_time_sync_axis_tuser : IN STD_LOGIC;
      s_time_sync_hdr_ready : OUT STD_LOGIC;
      udp_payload_length : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      s00_axi_awaddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      s00_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s00_axi_awvalid : IN STD_LOGIC;
      s00_axi_awready : OUT STD_LOGIC;
      s00_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s00_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s00_axi_wvalid : IN STD_LOGIC;
      s00_axi_wready : OUT STD_LOGIC;
      s00_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s00_axi_bvalid : OUT STD_LOGIC;
      s00_axi_bready : IN STD_LOGIC;
      s00_axi_araddr : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      s00_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s00_axi_arvalid : IN STD_LOGIC;
      s00_axi_arready : OUT STD_LOGIC;
      s00_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s00_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s00_axi_rvalid : OUT STD_LOGIC;
      s00_axi_rready : IN STD_LOGIC;
      s00_axi_aclk : IN STD_LOGIC;
      s00_axi_aresetn : IN STD_LOGIC
    );
  END COMPONENT time_sync_block_v2_0;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER OF s00_axi_aresetn: SIGNAL IS "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0, XIL_INTERFACENAME s00_axi_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 S00_AXI_RST RST, xilinx.com:signal:reset:1.0 s00_axi_aresetn RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s00_axi_aclk: SIGNAL IS "XIL_INTERFACENAME s00_axi_aclk, ASSOCIATED_RESET s00_axi_aresetn, ASSOCIATED_BUSIF S00_AXI, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 s00_axi_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s00_axi_awaddr: SIGNAL IS "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 16, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 7, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN cantavi_streamer_proje" & 
"ct_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF s_time_sync_axis_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 s_time_sync_axis TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF s_time_sync_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 s_time_sync_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF s_time_sync_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 s_time_sync_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_time_sync_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 s_time_sync_axis TVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s_time_sync_axis_tdata: SIGNAL IS "XIL_INTERFACENAME s_time_sync_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s_time_sync_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 s_time_sync_axis TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF m_time_sync_axis_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 m_time_sync_axis TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF m_time_sync_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 m_time_sync_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF m_time_sync_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 m_time_sync_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF m_time_sync_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 m_time_sync_axis TVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF m_time_sync_axis_tdata: SIGNAL IS "XIL_INTERFACENAME m_time_sync_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF m_time_sync_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 m_time_sync_axis TDATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF CLK_125: SIGNAL IS "XIL_INTERFACENAME CLK_125, FREQ_HZ 125000000, ASSOCIATED_BUSIF m_audio_payload_axis:s_time_sync_axis:m_time_sync_axis, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF CLK_125: SIGNAL IS "xilinx.com:signal:clock:1.0 CLK_125 CLK";
BEGIN
  U0 : time_sync_block_v2_0
    GENERIC MAP (
      C_S00_AXI_DATA_WIDTH => 32,
      C_S00_AXI_ADDR_WIDTH => 7,
      AXIS_UDP_DATA_WIDTH => 8,
      SINE_DIV_WIDTH => 32,
      PACKET_SEQ_W => 16,
      PACKET_LEN_WIDTH => 32,
      SEQ_NUM_LENGTH => 2,
      TC_LENGTH => 4,
      TC_BIT_LENGTH => 32,
      TC_COUNT_WIDTH => 32,
      MIN_UDP_PKT_SIZE => 32,
      UDP_LENGTH_WIDTH => 16
    )
    PORT MAP (
      newsample_in => newsample_in,
      tc_running_in => tc_running_in,
      sync_request_rx_out => sync_request_rx_out,
      initiate_sync_request_out => initiate_sync_request_out,
      initiate_sync_response_out => initiate_sync_response_out,
      sync_response_done => sync_response_done,
      sync_done_out => sync_done_out,
      status1_out => status1_out,
      status2_out => status2_out,
      tc_sync_en_out => tc_sync_en_out,
      tc_adjust_out => tc_adjust_out,
      sync_time_code_out => sync_time_code_out,
      media_pkt_tx_en_in => media_pkt_tx_en_in,
      path_tc_valid_in => path_tc_valid_in,
      path_tx_tc_code_in => path_tx_tc_code_in,
      path_rx_tc_code_in => path_rx_tc_code_in,
      CLK_125 => CLK_125,
      round_path_delay_out => round_path_delay_out,
      rx_packet_seq_cnt_in => rx_packet_seq_cnt_in,
      m_time_sync_axis_tdata => m_time_sync_axis_tdata,
      m_time_sync_axis_tvalid => m_time_sync_axis_tvalid,
      m_time_sync_axis_tready => m_time_sync_axis_tready,
      m_time_sync_axis_tlast => m_time_sync_axis_tlast,
      m_time_sync_axis_tuser => m_time_sync_axis_tuser,
      m_time_sync_hdr_valid => m_time_sync_hdr_valid,
      m_time_sync_hdr_ready => m_time_sync_hdr_ready,
      s_time_sync_axis_tdata => s_time_sync_axis_tdata,
      s_time_sync_axis_tvalid => s_time_sync_axis_tvalid,
      s_time_sync_axis_tready => s_time_sync_axis_tready,
      s_time_sync_axis_tlast => s_time_sync_axis_tlast,
      s_time_sync_axis_tuser => s_time_sync_axis_tuser,
      s_time_sync_hdr_ready => s_time_sync_hdr_ready,
      udp_payload_length => udp_payload_length,
      s00_axi_awaddr => s00_axi_awaddr,
      s00_axi_awprot => s00_axi_awprot,
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_awready => s00_axi_awready,
      s00_axi_wdata => s00_axi_wdata,
      s00_axi_wstrb => s00_axi_wstrb,
      s00_axi_wvalid => s00_axi_wvalid,
      s00_axi_wready => s00_axi_wready,
      s00_axi_bresp => s00_axi_bresp,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_araddr => s00_axi_araddr,
      s00_axi_arprot => s00_axi_arprot,
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_arready => s00_axi_arready,
      s00_axi_rdata => s00_axi_rdata,
      s00_axi_rresp => s00_axi_rresp,
      s00_axi_rvalid => s00_axi_rvalid,
      s00_axi_rready => s00_axi_rready,
      s00_axi_aclk => s00_axi_aclk,
      s00_axi_aresetn => s00_axi_aresetn
    );
END cantavi_streamer_project_time_sync_block_0_0_arch;
