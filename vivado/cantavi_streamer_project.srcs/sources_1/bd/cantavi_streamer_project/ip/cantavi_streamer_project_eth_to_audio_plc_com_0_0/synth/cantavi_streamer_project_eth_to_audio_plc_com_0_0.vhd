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

-- IP VLNV: me:user:eth_to_audio_plc_combo_interface:2.0
-- IP Revision: 1054

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY cantavi_streamer_project_eth_to_audio_plc_com_0_0 IS
  PORT (
    rst_out : OUT STD_LOGIC;
    dpk_audio_l_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    dpk_audio_r_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    plc_audio_l_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    plc_audio_r_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    fifo_occ_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    play_out_ready_out : OUT STD_LOGIC;
    replace_pkt_out : OUT STD_LOGIC;
    newsample_in : IN STD_LOGIC;
    tc_sync_en_in : IN STD_LOGIC;
    new_pkt_ready_in : IN STD_LOGIC;
    dpk_pkt_end_out : OUT STD_LOGIC;
    plc_pkt_end_out : OUT STD_LOGIC;
    status1_out : OUT STD_LOGIC;
    status2_out : OUT STD_LOGIC;
    sync_time_code_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    rx_time_code_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    rx_packet_seq_cnt_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    irq_out : OUT STD_LOGIC;
    fifo_full_out : OUT STD_LOGIC;
    fifo_empty_out : OUT STD_LOGIC;
    replace_inprogress_in : IN STD_LOGIC;
    CLK_125 : IN STD_LOGIC;
    fade_dpk_enable_out : OUT STD_LOGIC;
    fade_plc_enable_out : OUT STD_LOGIC;
    fade_plc_direction_out : OUT STD_LOGIC;
    fade_dpkt_direction_out : OUT STD_LOGIC;
    fade_dpk_clear_out : OUT STD_LOGIC;
    fade_plc_clear_out : OUT STD_LOGIC;
    fade_dpk_max_out : OUT STD_LOGIC;
    fade_dpk_min_out : OUT STD_LOGIC;
    fade_plc_max_out : OUT STD_LOGIC;
    fade_plc_min_out : OUT STD_LOGIC;
    UP_STEP_PULSES_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    DOWN_STEP_PULSES_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    COEF_MIN_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    COEF_MAX_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    newsample_125_out : OUT STD_LOGIC;
    play_out_delay_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    next_play_out_time_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    current_sync_time_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    skip_slot_out : OUT STD_LOGIC;
    packet_available_in : IN STD_LOGIC;
    s_ch1_audio_payload_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_ch1_audio_payload_axis_tvalid : IN STD_LOGIC;
    s_ch1_audio_payload_axis_tready : OUT STD_LOGIC;
    s_ch1_audio_payload_axis_tlast : IN STD_LOGIC;
    s_ch1_audio_payload_axis_tuser : IN STD_LOGIC;
    s_ch1_audio_payload_axis_aresetn : IN STD_LOGIC;
    s_ch1_audio_payload_hdr_ready : OUT STD_LOGIC;
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
END cantavi_streamer_project_eth_to_audio_plc_com_0_0;

ARCHITECTURE cantavi_streamer_project_eth_to_audio_plc_com_0_0_arch OF cantavi_streamer_project_eth_to_audio_plc_com_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF cantavi_streamer_project_eth_to_audio_plc_com_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT eth_to_audio_plc_combo_interface_v2_0 IS
    GENERIC (
      C_S00_AXI_DATA_WIDTH : INTEGER; -- Width of S_AXI data bus
      C_S00_AXI_ADDR_WIDTH : INTEGER; -- Width of S_AXI address bus
      AXIS_UDP_DATA_WIDTH : INTEGER;
      PACKET_COUNT_W : INTEGER;
      BUF_COUNT_W : INTEGER;
      FIFO_ADDR_WIDTH : INTEGER;
      GLITCH_FILTER_LENGTH : INTEGER;
      TC_BIT_LENGTH : INTEGER;
      PACKET_SEQ_W : INTEGER;
      S_COUNT : INTEGER;
      STEP_WIDTH : INTEGER;
      INTBIT_WIDTH : INTEGER;
      FRACBIT_WIDTH : INTEGER;
      FIFO_DATA_WIDTH : INTEGER;
      LIFO_ADDR_WIDTH : INTEGER;
      CIC_SIG_OUT_WIDTH : INTEGER;
      CIC_SIG_IN_WIDTH : INTEGER;
      COMP_SIG_OUT_WIDTH : INTEGER;
      REL_PIPE_LENGTH : INTEGER;
      EXIT_FADE_LENGTH : INTEGER;
      ENTRY_FADE_LENGTH : INTEGER;
      SIM_PKT_LEN_WIDTH : INTEGER
    );
    PORT (
      rst_out : OUT STD_LOGIC;
      dpk_audio_l_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      dpk_audio_r_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      plc_audio_l_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      plc_audio_r_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      fifo_occ_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      play_out_ready_out : OUT STD_LOGIC;
      replace_pkt_out : OUT STD_LOGIC;
      newsample_in : IN STD_LOGIC;
      tc_sync_en_in : IN STD_LOGIC;
      new_pkt_ready_in : IN STD_LOGIC;
      dpk_pkt_end_out : OUT STD_LOGIC;
      plc_pkt_end_out : OUT STD_LOGIC;
      status1_out : OUT STD_LOGIC;
      status2_out : OUT STD_LOGIC;
      sync_time_code_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      rx_time_code_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      rx_packet_seq_cnt_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      irq_out : OUT STD_LOGIC;
      fifo_full_out : OUT STD_LOGIC;
      fifo_empty_out : OUT STD_LOGIC;
      replace_inprogress_in : IN STD_LOGIC;
      CLK_125 : IN STD_LOGIC;
      fade_dpk_enable_out : OUT STD_LOGIC;
      fade_plc_enable_out : OUT STD_LOGIC;
      fade_plc_direction_out : OUT STD_LOGIC;
      fade_dpkt_direction_out : OUT STD_LOGIC;
      fade_dpk_clear_out : OUT STD_LOGIC;
      fade_plc_clear_out : OUT STD_LOGIC;
      fade_dpk_max_out : OUT STD_LOGIC;
      fade_dpk_min_out : OUT STD_LOGIC;
      fade_plc_max_out : OUT STD_LOGIC;
      fade_plc_min_out : OUT STD_LOGIC;
      UP_STEP_PULSES_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      DOWN_STEP_PULSES_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      COEF_MIN_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      COEF_MAX_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      newsample_125_out : OUT STD_LOGIC;
      play_out_delay_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      next_play_out_time_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      current_sync_time_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      skip_slot_out : OUT STD_LOGIC;
      packet_available_in : IN STD_LOGIC;
      s_ch1_audio_payload_axis_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_ch1_audio_payload_axis_tvalid : IN STD_LOGIC;
      s_ch1_audio_payload_axis_tready : OUT STD_LOGIC;
      s_ch1_audio_payload_axis_tlast : IN STD_LOGIC;
      s_ch1_audio_payload_axis_tuser : IN STD_LOGIC;
      s_ch1_audio_payload_axis_aresetn : IN STD_LOGIC;
      s_ch1_audio_payload_hdr_ready : OUT STD_LOGIC;
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
  END COMPONENT eth_to_audio_plc_combo_interface_v2_0;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF cantavi_streamer_project_eth_to_audio_plc_com_0_0_arch: ARCHITECTURE IS "eth_to_audio_plc_combo_interface_v2_0,Vivado 2018.3";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF cantavi_streamer_project_eth_to_audio_plc_com_0_0_arch : ARCHITECTURE IS "cantavi_streamer_project_eth_to_audio_plc_com_0_0,eth_to_audio_plc_combo_interface_v2_0,{}";
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
  ATTRIBUTE X_INTERFACE_PARAMETER OF s00_axi_awaddr: SIGNAL IS "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 16, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 7, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN cantavi_streamer_proje" & 
"ct_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s00_axi_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s_ch1_audio_payload_axis_aresetn: SIGNAL IS "XIL_INTERFACENAME s_ch1_audio_payload_axis_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s_ch1_audio_payload_axis_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 s_ch1_audio_payload_axis_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF s_ch1_audio_payload_axis_tuser: SIGNAL IS "xilinx.com:interface:axis:1.0 s_ch1_audio_payload_axis TUSER";
  ATTRIBUTE X_INTERFACE_INFO OF s_ch1_audio_payload_axis_tlast: SIGNAL IS "xilinx.com:interface:axis:1.0 s_ch1_audio_payload_axis TLAST";
  ATTRIBUTE X_INTERFACE_INFO OF s_ch1_audio_payload_axis_tready: SIGNAL IS "xilinx.com:interface:axis:1.0 s_ch1_audio_payload_axis TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_ch1_audio_payload_axis_tvalid: SIGNAL IS "xilinx.com:interface:axis:1.0 s_ch1_audio_payload_axis TVALID";
  ATTRIBUTE X_INTERFACE_PARAMETER OF s_ch1_audio_payload_axis_tdata: SIGNAL IS "XIL_INTERFACENAME s_ch1_audio_payload_axis, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, LAYERED_METADATA undef, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF s_ch1_audio_payload_axis_tdata: SIGNAL IS "xilinx.com:interface:axis:1.0 s_ch1_audio_payload_axis TDATA";
  ATTRIBUTE X_INTERFACE_PARAMETER OF CLK_125: SIGNAL IS "XIL_INTERFACENAME CLK_125, ASSOCIATED_BUSIF s_ch1_audio_payload_axis, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN cantavi_streamer_project_user_cross_layer_swi_0_0_clk_125_out, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF CLK_125: SIGNAL IS "xilinx.com:signal:clock:1.0 CLK_125 CLK";
BEGIN
  U0 : eth_to_audio_plc_combo_interface_v2_0
    GENERIC MAP (
      C_S00_AXI_DATA_WIDTH => 32,
      C_S00_AXI_ADDR_WIDTH => 7,
      AXIS_UDP_DATA_WIDTH => 8,
      PACKET_COUNT_W => 32,
      BUF_COUNT_W => 32,
      FIFO_ADDR_WIDTH => 8,
      GLITCH_FILTER_LENGTH => 15,
      TC_BIT_LENGTH => 32,
      PACKET_SEQ_W => 16,
      S_COUNT => 32,
      STEP_WIDTH => 32,
      INTBIT_WIDTH => 24,
      FRACBIT_WIDTH => 8,
      FIFO_DATA_WIDTH => 24,
      LIFO_ADDR_WIDTH => 13,
      CIC_SIG_OUT_WIDTH => 28,
      CIC_SIG_IN_WIDTH => 24,
      COMP_SIG_OUT_WIDTH => 28,
      REL_PIPE_LENGTH => 12,
      EXIT_FADE_LENGTH => 96,
      ENTRY_FADE_LENGTH => 96,
      SIM_PKT_LEN_WIDTH => 4
    )
    PORT MAP (
      rst_out => rst_out,
      dpk_audio_l_out => dpk_audio_l_out,
      dpk_audio_r_out => dpk_audio_r_out,
      plc_audio_l_out => plc_audio_l_out,
      plc_audio_r_out => plc_audio_r_out,
      fifo_occ_out => fifo_occ_out,
      play_out_ready_out => play_out_ready_out,
      replace_pkt_out => replace_pkt_out,
      newsample_in => newsample_in,
      tc_sync_en_in => tc_sync_en_in,
      new_pkt_ready_in => new_pkt_ready_in,
      dpk_pkt_end_out => dpk_pkt_end_out,
      plc_pkt_end_out => plc_pkt_end_out,
      status1_out => status1_out,
      status2_out => status2_out,
      sync_time_code_in => sync_time_code_in,
      rx_time_code_out => rx_time_code_out,
      rx_packet_seq_cnt_out => rx_packet_seq_cnt_out,
      irq_out => irq_out,
      fifo_full_out => fifo_full_out,
      fifo_empty_out => fifo_empty_out,
      replace_inprogress_in => replace_inprogress_in,
      CLK_125 => CLK_125,
      fade_dpk_enable_out => fade_dpk_enable_out,
      fade_plc_enable_out => fade_plc_enable_out,
      fade_plc_direction_out => fade_plc_direction_out,
      fade_dpkt_direction_out => fade_dpkt_direction_out,
      fade_dpk_clear_out => fade_dpk_clear_out,
      fade_plc_clear_out => fade_plc_clear_out,
      fade_dpk_max_out => fade_dpk_max_out,
      fade_dpk_min_out => fade_dpk_min_out,
      fade_plc_max_out => fade_plc_max_out,
      fade_plc_min_out => fade_plc_min_out,
      UP_STEP_PULSES_OUT => UP_STEP_PULSES_OUT,
      DOWN_STEP_PULSES_OUT => DOWN_STEP_PULSES_OUT,
      COEF_MIN_OUT => COEF_MIN_OUT,
      COEF_MAX_OUT => COEF_MAX_OUT,
      newsample_125_out => newsample_125_out,
      play_out_delay_out => play_out_delay_out,
      next_play_out_time_out => next_play_out_time_out,
      current_sync_time_out => current_sync_time_out,
      skip_slot_out => skip_slot_out,
      packet_available_in => packet_available_in,
      s_ch1_audio_payload_axis_tdata => s_ch1_audio_payload_axis_tdata,
      s_ch1_audio_payload_axis_tvalid => s_ch1_audio_payload_axis_tvalid,
      s_ch1_audio_payload_axis_tready => s_ch1_audio_payload_axis_tready,
      s_ch1_audio_payload_axis_tlast => s_ch1_audio_payload_axis_tlast,
      s_ch1_audio_payload_axis_tuser => s_ch1_audio_payload_axis_tuser,
      s_ch1_audio_payload_axis_aresetn => s_ch1_audio_payload_axis_aresetn,
      s_ch1_audio_payload_hdr_ready => s_ch1_audio_payload_hdr_ready,
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
END cantavi_streamer_project_eth_to_audio_plc_com_0_0_arch;
