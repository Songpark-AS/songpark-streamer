--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
--Date        : Sat Oct 26 22:21:58 2019
--Host        : JAIRE running 64-bit Arch Linux
--Command     : generate_target cantavi_streamer_project.bd
--Design      : cantavi_streamer_project
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ZedCodec_imp_DC5242 is
  port (
    S00_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_arready : out STD_LOGIC;
    S00_AXI_arvalid : in STD_LOGIC;
    S00_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_awready : out STD_LOGIC;
    S00_AXI_awvalid : in STD_LOGIC;
    S00_AXI_bready : in STD_LOGIC;
    S00_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_bvalid : out STD_LOGIC;
    S00_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_rready : in STD_LOGIC;
    S00_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_rvalid : out STD_LOGIC;
    S00_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_wready : out STD_LOGIC;
    S00_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_wvalid : in STD_LOGIC;
    adau1761_adc_sdata_0 : in STD_LOGIC;
    adau1761_bclk_0 : in STD_LOGIC;
    adau1761_cclk_0 : out STD_LOGIC;
    adau1761_cdata_0 : out STD_LOGIC;
    adau1761_clatchn_0 : out STD_LOGIC;
    adau1761_cout_0 : in STD_LOGIC;
    adau1761_dac_sdata_0 : out STD_LOGIC;
    adau1761_lrclk_0 : in STD_LOGIC;
    clk_125 : in STD_LOGIC;
    hphone_l : in STD_LOGIC_VECTOR ( 23 downto 0 );
    hphone_r : in STD_LOGIC_VECTOR ( 23 downto 0 );
    line_in_l_125 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    line_in_r_125 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    next_adc_sample : out STD_LOGIC;
    next_dac_sample : out STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
end ZedCodec_imp_DC5242;

architecture STRUCTURE of ZedCodec_imp_DC5242 is
  component cantavi_streamer_project_adau1761_controller_0_0 is
  port (
    adau1761_cclk : out STD_LOGIC;
    adau1761_clatchn : out STD_LOGIC;
    adau1761_cdata : out STD_LOGIC;
    adau1761_cout : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_adau1761_controller_0_0;
  component cantavi_streamer_project_i2s_transmitter_0_0 is
  port (
    S_AXIS_ARESETN : in STD_LOGIC;
    clk_125 : in STD_LOGIC;
    hphone_l : in STD_LOGIC;
    hphone_l_valid : in STD_LOGIC;
    hphone_r : in STD_LOGIC_VECTOR ( 23 downto 0 );
    hphone_r_valid : in STD_LOGIC;
    next_dac_sample : out STD_LOGIC;
    sck : in STD_LOGIC;
    ws : in STD_LOGIC;
    sd : out STD_LOGIC
  );
  end component cantavi_streamer_project_i2s_transmitter_0_0;
  component cantavi_streamer_project_i2s_receiver_0_0 is
  port (
    clk_125 : in STD_LOGIC;
    line_in_l_125 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    line_in_r_125 : out STD_LOGIC_VECTOR ( 23 downto 0 );
    next_adc_sample : out STD_LOGIC;
    sck : in STD_LOGIC;
    ws : in STD_LOGIC;
    sd : in STD_LOGIC
  );
  end component cantavi_streamer_project_i2s_receiver_0_0;
  signal Conn1_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn1_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal Conn1_ARREADY : STD_LOGIC;
  signal Conn1_ARVALID : STD_LOGIC;
  signal Conn1_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn1_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal Conn1_AWREADY : STD_LOGIC;
  signal Conn1_AWVALID : STD_LOGIC;
  signal Conn1_BREADY : STD_LOGIC;
  signal Conn1_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn1_BVALID : STD_LOGIC;
  signal Conn1_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn1_RREADY : STD_LOGIC;
  signal Conn1_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal Conn1_RVALID : STD_LOGIC;
  signal Conn1_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal Conn1_WREADY : STD_LOGIC;
  signal Conn1_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal Conn1_WVALID : STD_LOGIC;
  signal adau1761_controller_0_adau1761_cclk : STD_LOGIC;
  signal adau1761_controller_0_adau1761_cdata : STD_LOGIC;
  signal adau1761_controller_0_adau1761_clatchn : STD_LOGIC;
  signal adau1761_cout_0_1 : STD_LOGIC;
  signal clk_125_1 : STD_LOGIC;
  signal hphone_l_1 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal hphone_r_1 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal i2s_receiver_from_codec_adc_0_line_in_l_125 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal i2s_receiver_from_codec_adc_0_line_in_r_125 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal i2s_receiver_from_codec_adc_0_next_adc_sample : STD_LOGIC;
  signal i2s_transmitter_0_sd : STD_LOGIC;
  signal i2s_transmitter_to_codec_dac_0_next_dac_sample : STD_LOGIC;
  signal s00_axi_aclk_1 : STD_LOGIC;
  signal s00_axi_aresetn_1 : STD_LOGIC;
begin
  Conn1_ARADDR(31 downto 0) <= S00_AXI_araddr(31 downto 0);
  Conn1_ARPROT(2 downto 0) <= S00_AXI_arprot(2 downto 0);
  Conn1_ARVALID <= S00_AXI_arvalid;
  Conn1_AWADDR(31 downto 0) <= S00_AXI_awaddr(31 downto 0);
  Conn1_AWPROT(2 downto 0) <= S00_AXI_awprot(2 downto 0);
  Conn1_AWVALID <= S00_AXI_awvalid;
  Conn1_BREADY <= S00_AXI_bready;
  Conn1_RREADY <= S00_AXI_rready;
  Conn1_WDATA(31 downto 0) <= S00_AXI_wdata(31 downto 0);
  Conn1_WSTRB(3 downto 0) <= S00_AXI_wstrb(3 downto 0);
  Conn1_WVALID <= S00_AXI_wvalid;
  S00_AXI_arready <= Conn1_ARREADY;
  S00_AXI_awready <= Conn1_AWREADY;
  S00_AXI_bresp(1 downto 0) <= Conn1_BRESP(1 downto 0);
  S00_AXI_bvalid <= Conn1_BVALID;
  S00_AXI_rdata(31 downto 0) <= Conn1_RDATA(31 downto 0);
  S00_AXI_rresp(1 downto 0) <= Conn1_RRESP(1 downto 0);
  S00_AXI_rvalid <= Conn1_RVALID;
  S00_AXI_wready <= Conn1_WREADY;
  adau1761_cclk_0 <= adau1761_controller_0_adau1761_cclk;
  adau1761_cdata_0 <= adau1761_controller_0_adau1761_cdata;
  adau1761_clatchn_0 <= adau1761_controller_0_adau1761_clatchn;
  adau1761_cout_0_1 <= adau1761_cout_0;
  adau1761_dac_sdata_0 <= i2s_transmitter_0_sd;
  clk_125_1 <= clk_125;
  hphone_l_1(23 downto 0) <= hphone_l(23 downto 0);
  hphone_r_1(23 downto 0) <= hphone_r(23 downto 0);
  line_in_l_125(23 downto 0) <= i2s_receiver_from_codec_adc_0_line_in_l_125(23 downto 0);
  line_in_r_125(23 downto 0) <= i2s_receiver_from_codec_adc_0_line_in_r_125(23 downto 0);
  next_adc_sample <= i2s_receiver_from_codec_adc_0_next_adc_sample;
  next_dac_sample <= i2s_transmitter_to_codec_dac_0_next_dac_sample;
  s00_axi_aclk_1 <= s00_axi_aclk;
  s00_axi_aresetn_1 <= s00_axi_aresetn;
adau1761_controller_0: component cantavi_streamer_project_adau1761_controller_0_0
     port map (
      adau1761_cclk => adau1761_controller_0_adau1761_cclk,
      adau1761_cdata => adau1761_controller_0_adau1761_cdata,
      adau1761_clatchn => adau1761_controller_0_adau1761_clatchn,
      adau1761_cout => adau1761_cout_0_1,
      s00_axi_aclk => s00_axi_aclk_1,
      s00_axi_araddr(4 downto 0) => Conn1_ARADDR(4 downto 0),
      s00_axi_aresetn => s00_axi_aresetn_1,
      s00_axi_arprot(2 downto 0) => Conn1_ARPROT(2 downto 0),
      s00_axi_arready => Conn1_ARREADY,
      s00_axi_arvalid => Conn1_ARVALID,
      s00_axi_awaddr(4 downto 0) => Conn1_AWADDR(4 downto 0),
      s00_axi_awprot(2 downto 0) => Conn1_AWPROT(2 downto 0),
      s00_axi_awready => Conn1_AWREADY,
      s00_axi_awvalid => Conn1_AWVALID,
      s00_axi_bready => Conn1_BREADY,
      s00_axi_bresp(1 downto 0) => Conn1_BRESP(1 downto 0),
      s00_axi_bvalid => Conn1_BVALID,
      s00_axi_rdata(31 downto 0) => Conn1_RDATA(31 downto 0),
      s00_axi_rready => Conn1_RREADY,
      s00_axi_rresp(1 downto 0) => Conn1_RRESP(1 downto 0),
      s00_axi_rvalid => Conn1_RVALID,
      s00_axi_wdata(31 downto 0) => Conn1_WDATA(31 downto 0),
      s00_axi_wready => Conn1_WREADY,
      s00_axi_wstrb(3 downto 0) => Conn1_WSTRB(3 downto 0),
      s00_axi_wvalid => Conn1_WVALID
    );
i2s_receiver_from_codec_adc_0: component cantavi_streamer_project_i2s_receiver_0_0
     port map (
      clk_125 => clk_125_1,
      line_in_l_125(23 downto 0) => i2s_receiver_from_codec_adc_0_line_in_l_125(23 downto 0),
      line_in_r_125(23 downto 0) => i2s_receiver_from_codec_adc_0_line_in_r_125(23 downto 0),
      next_adc_sample => i2s_receiver_from_codec_adc_0_next_adc_sample,
      sck => adau1761_bclk_0,
      sd => adau1761_adc_sdata_0,
      ws => adau1761_lrclk_0
    );
i2s_transmitter_to_codec_dac_0: component cantavi_streamer_project_i2s_transmitter_0_0
     port map (
      S_AXIS_ARESETN => s00_axi_aresetn_1,
      clk_125 => clk_125_1,
      hphone_l => hphone_l_1(0),
      hphone_l_valid => '0',
      hphone_r(23 downto 0) => hphone_r_1(23 downto 0),
      hphone_r_valid => '0',
      next_dac_sample => i2s_transmitter_to_codec_dac_0_next_dac_sample,
      sck => adau1761_bclk_0,
      sd => i2s_transmitter_0_sd,
      ws => adau1761_lrclk_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m00_couplers_imp_12W17VD is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m00_couplers_imp_12W17VD;

architecture STRUCTURE of m00_couplers_imp_12W17VD is
  signal m00_couplers_to_m00_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_m00_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_m00_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m00_couplers_to_m00_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_m00_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m00_couplers_to_m00_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_m00_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_m00_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m00_couplers_to_m00_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(31 downto 0) <= m00_couplers_to_m00_couplers_ARADDR(31 downto 0);
  M_AXI_arvalid(0) <= m00_couplers_to_m00_couplers_ARVALID(0);
  M_AXI_awaddr(31 downto 0) <= m00_couplers_to_m00_couplers_AWADDR(31 downto 0);
  M_AXI_awvalid(0) <= m00_couplers_to_m00_couplers_AWVALID(0);
  M_AXI_bready(0) <= m00_couplers_to_m00_couplers_BREADY(0);
  M_AXI_rready(0) <= m00_couplers_to_m00_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m00_couplers_to_m00_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m00_couplers_to_m00_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m00_couplers_to_m00_couplers_WVALID(0);
  S_AXI_arready(0) <= m00_couplers_to_m00_couplers_ARREADY(0);
  S_AXI_awready(0) <= m00_couplers_to_m00_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m00_couplers_to_m00_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m00_couplers_to_m00_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m00_couplers_to_m00_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m00_couplers_to_m00_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m00_couplers_to_m00_couplers_RVALID(0);
  S_AXI_wready(0) <= m00_couplers_to_m00_couplers_WREADY(0);
  m00_couplers_to_m00_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m00_couplers_to_m00_couplers_ARREADY(0) <= M_AXI_arready(0);
  m00_couplers_to_m00_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m00_couplers_to_m00_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m00_couplers_to_m00_couplers_AWREADY(0) <= M_AXI_awready(0);
  m00_couplers_to_m00_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m00_couplers_to_m00_couplers_BREADY(0) <= S_AXI_bready(0);
  m00_couplers_to_m00_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m00_couplers_to_m00_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m00_couplers_to_m00_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m00_couplers_to_m00_couplers_RREADY(0) <= S_AXI_rready(0);
  m00_couplers_to_m00_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m00_couplers_to_m00_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m00_couplers_to_m00_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m00_couplers_to_m00_couplers_WREADY(0) <= M_AXI_wready(0);
  m00_couplers_to_m00_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m00_couplers_to_m00_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m01_couplers_imp_1ASS0TR is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m01_couplers_imp_1ASS0TR;

architecture STRUCTURE of m01_couplers_imp_1ASS0TR is
  signal m01_couplers_to_m01_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_m01_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m01_couplers_to_m01_couplers_ARREADY : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_ARVALID : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_m01_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m01_couplers_to_m01_couplers_AWREADY : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_AWVALID : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_BREADY : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m01_couplers_to_m01_couplers_BVALID : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_m01_couplers_RREADY : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m01_couplers_to_m01_couplers_RVALID : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_m01_couplers_WREADY : STD_LOGIC;
  signal m01_couplers_to_m01_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m01_couplers_to_m01_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m01_couplers_to_m01_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m01_couplers_to_m01_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m01_couplers_to_m01_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m01_couplers_to_m01_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m01_couplers_to_m01_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m01_couplers_to_m01_couplers_AWVALID;
  M_AXI_bready <= m01_couplers_to_m01_couplers_BREADY;
  M_AXI_rready <= m01_couplers_to_m01_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m01_couplers_to_m01_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m01_couplers_to_m01_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m01_couplers_to_m01_couplers_WVALID;
  S_AXI_arready <= m01_couplers_to_m01_couplers_ARREADY;
  S_AXI_awready <= m01_couplers_to_m01_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m01_couplers_to_m01_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m01_couplers_to_m01_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m01_couplers_to_m01_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m01_couplers_to_m01_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m01_couplers_to_m01_couplers_RVALID;
  S_AXI_wready <= m01_couplers_to_m01_couplers_WREADY;
  m01_couplers_to_m01_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m01_couplers_to_m01_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m01_couplers_to_m01_couplers_ARREADY <= M_AXI_arready;
  m01_couplers_to_m01_couplers_ARVALID <= S_AXI_arvalid;
  m01_couplers_to_m01_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m01_couplers_to_m01_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m01_couplers_to_m01_couplers_AWREADY <= M_AXI_awready;
  m01_couplers_to_m01_couplers_AWVALID <= S_AXI_awvalid;
  m01_couplers_to_m01_couplers_BREADY <= S_AXI_bready;
  m01_couplers_to_m01_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m01_couplers_to_m01_couplers_BVALID <= M_AXI_bvalid;
  m01_couplers_to_m01_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m01_couplers_to_m01_couplers_RREADY <= S_AXI_rready;
  m01_couplers_to_m01_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m01_couplers_to_m01_couplers_RVALID <= M_AXI_rvalid;
  m01_couplers_to_m01_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m01_couplers_to_m01_couplers_WREADY <= M_AXI_wready;
  m01_couplers_to_m01_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m01_couplers_to_m01_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m02_couplers_imp_1IPKK8L is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m02_couplers_imp_1IPKK8L;

architecture STRUCTURE of m02_couplers_imp_1IPKK8L is
  signal m02_couplers_to_m02_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_m02_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m02_couplers_to_m02_couplers_ARREADY : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_ARVALID : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_m02_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m02_couplers_to_m02_couplers_AWREADY : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_AWVALID : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_BREADY : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m02_couplers_to_m02_couplers_BVALID : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_m02_couplers_RREADY : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m02_couplers_to_m02_couplers_RVALID : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_m02_couplers_WREADY : STD_LOGIC;
  signal m02_couplers_to_m02_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m02_couplers_to_m02_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m02_couplers_to_m02_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m02_couplers_to_m02_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m02_couplers_to_m02_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m02_couplers_to_m02_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m02_couplers_to_m02_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m02_couplers_to_m02_couplers_AWVALID;
  M_AXI_bready <= m02_couplers_to_m02_couplers_BREADY;
  M_AXI_rready <= m02_couplers_to_m02_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m02_couplers_to_m02_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m02_couplers_to_m02_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m02_couplers_to_m02_couplers_WVALID;
  S_AXI_arready <= m02_couplers_to_m02_couplers_ARREADY;
  S_AXI_awready <= m02_couplers_to_m02_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m02_couplers_to_m02_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m02_couplers_to_m02_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m02_couplers_to_m02_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m02_couplers_to_m02_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m02_couplers_to_m02_couplers_RVALID;
  S_AXI_wready <= m02_couplers_to_m02_couplers_WREADY;
  m02_couplers_to_m02_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m02_couplers_to_m02_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m02_couplers_to_m02_couplers_ARREADY <= M_AXI_arready;
  m02_couplers_to_m02_couplers_ARVALID <= S_AXI_arvalid;
  m02_couplers_to_m02_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m02_couplers_to_m02_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m02_couplers_to_m02_couplers_AWREADY <= M_AXI_awready;
  m02_couplers_to_m02_couplers_AWVALID <= S_AXI_awvalid;
  m02_couplers_to_m02_couplers_BREADY <= S_AXI_bready;
  m02_couplers_to_m02_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m02_couplers_to_m02_couplers_BVALID <= M_AXI_bvalid;
  m02_couplers_to_m02_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m02_couplers_to_m02_couplers_RREADY <= S_AXI_rready;
  m02_couplers_to_m02_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m02_couplers_to_m02_couplers_RVALID <= M_AXI_rvalid;
  m02_couplers_to_m02_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m02_couplers_to_m02_couplers_WREADY <= M_AXI_wready;
  m02_couplers_to_m02_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m02_couplers_to_m02_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m03_couplers_imp_1QMBD4Z is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m03_couplers_imp_1QMBD4Z;

architecture STRUCTURE of m03_couplers_imp_1QMBD4Z is
  signal m03_couplers_to_m03_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_m03_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m03_couplers_to_m03_couplers_ARREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_ARVALID : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_m03_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m03_couplers_to_m03_couplers_AWREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_AWVALID : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_BREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m03_couplers_to_m03_couplers_BVALID : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_m03_couplers_RREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m03_couplers_to_m03_couplers_RVALID : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_m03_couplers_WREADY : STD_LOGIC;
  signal m03_couplers_to_m03_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m03_couplers_to_m03_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m03_couplers_to_m03_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m03_couplers_to_m03_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m03_couplers_to_m03_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m03_couplers_to_m03_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m03_couplers_to_m03_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m03_couplers_to_m03_couplers_AWVALID;
  M_AXI_bready <= m03_couplers_to_m03_couplers_BREADY;
  M_AXI_rready <= m03_couplers_to_m03_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m03_couplers_to_m03_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m03_couplers_to_m03_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m03_couplers_to_m03_couplers_WVALID;
  S_AXI_arready <= m03_couplers_to_m03_couplers_ARREADY;
  S_AXI_awready <= m03_couplers_to_m03_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m03_couplers_to_m03_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m03_couplers_to_m03_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m03_couplers_to_m03_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m03_couplers_to_m03_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m03_couplers_to_m03_couplers_RVALID;
  S_AXI_wready <= m03_couplers_to_m03_couplers_WREADY;
  m03_couplers_to_m03_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m03_couplers_to_m03_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m03_couplers_to_m03_couplers_ARREADY <= M_AXI_arready;
  m03_couplers_to_m03_couplers_ARVALID <= S_AXI_arvalid;
  m03_couplers_to_m03_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m03_couplers_to_m03_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m03_couplers_to_m03_couplers_AWREADY <= M_AXI_awready;
  m03_couplers_to_m03_couplers_AWVALID <= S_AXI_awvalid;
  m03_couplers_to_m03_couplers_BREADY <= S_AXI_bready;
  m03_couplers_to_m03_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m03_couplers_to_m03_couplers_BVALID <= M_AXI_bvalid;
  m03_couplers_to_m03_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m03_couplers_to_m03_couplers_RREADY <= S_AXI_rready;
  m03_couplers_to_m03_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m03_couplers_to_m03_couplers_RVALID <= M_AXI_rvalid;
  m03_couplers_to_m03_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m03_couplers_to_m03_couplers_WREADY <= M_AXI_wready;
  m03_couplers_to_m03_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m03_couplers_to_m03_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m04_couplers_imp_8CWVCX is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m04_couplers_imp_8CWVCX;

architecture STRUCTURE of m04_couplers_imp_8CWVCX is
  signal m04_couplers_to_m04_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_m04_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m04_couplers_to_m04_couplers_ARREADY : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_ARVALID : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_m04_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m04_couplers_to_m04_couplers_AWREADY : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_AWVALID : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_BREADY : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m04_couplers_to_m04_couplers_BVALID : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_m04_couplers_RREADY : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m04_couplers_to_m04_couplers_RVALID : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_m04_couplers_WREADY : STD_LOGIC;
  signal m04_couplers_to_m04_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m04_couplers_to_m04_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m04_couplers_to_m04_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m04_couplers_to_m04_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m04_couplers_to_m04_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m04_couplers_to_m04_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m04_couplers_to_m04_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m04_couplers_to_m04_couplers_AWVALID;
  M_AXI_bready <= m04_couplers_to_m04_couplers_BREADY;
  M_AXI_rready <= m04_couplers_to_m04_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m04_couplers_to_m04_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m04_couplers_to_m04_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m04_couplers_to_m04_couplers_WVALID;
  S_AXI_arready <= m04_couplers_to_m04_couplers_ARREADY;
  S_AXI_awready <= m04_couplers_to_m04_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m04_couplers_to_m04_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m04_couplers_to_m04_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m04_couplers_to_m04_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m04_couplers_to_m04_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m04_couplers_to_m04_couplers_RVALID;
  S_AXI_wready <= m04_couplers_to_m04_couplers_WREADY;
  m04_couplers_to_m04_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m04_couplers_to_m04_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m04_couplers_to_m04_couplers_ARREADY <= M_AXI_arready;
  m04_couplers_to_m04_couplers_ARVALID <= S_AXI_arvalid;
  m04_couplers_to_m04_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m04_couplers_to_m04_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m04_couplers_to_m04_couplers_AWREADY <= M_AXI_awready;
  m04_couplers_to_m04_couplers_AWVALID <= S_AXI_awvalid;
  m04_couplers_to_m04_couplers_BREADY <= S_AXI_bready;
  m04_couplers_to_m04_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m04_couplers_to_m04_couplers_BVALID <= M_AXI_bvalid;
  m04_couplers_to_m04_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m04_couplers_to_m04_couplers_RREADY <= S_AXI_rready;
  m04_couplers_to_m04_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m04_couplers_to_m04_couplers_RVALID <= M_AXI_rvalid;
  m04_couplers_to_m04_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m04_couplers_to_m04_couplers_WREADY <= M_AXI_wready;
  m04_couplers_to_m04_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m04_couplers_to_m04_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m05_couplers_imp_G9ODMF is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m05_couplers_imp_G9ODMF;

architecture STRUCTURE of m05_couplers_imp_G9ODMF is
  signal m05_couplers_to_m05_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_m05_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m05_couplers_to_m05_couplers_ARREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_ARVALID : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_m05_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m05_couplers_to_m05_couplers_AWREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_AWVALID : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_BREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m05_couplers_to_m05_couplers_BVALID : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_m05_couplers_RREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m05_couplers_to_m05_couplers_RVALID : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_m05_couplers_WREADY : STD_LOGIC;
  signal m05_couplers_to_m05_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m05_couplers_to_m05_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m05_couplers_to_m05_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m05_couplers_to_m05_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m05_couplers_to_m05_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m05_couplers_to_m05_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m05_couplers_to_m05_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m05_couplers_to_m05_couplers_AWVALID;
  M_AXI_bready <= m05_couplers_to_m05_couplers_BREADY;
  M_AXI_rready <= m05_couplers_to_m05_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m05_couplers_to_m05_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m05_couplers_to_m05_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m05_couplers_to_m05_couplers_WVALID;
  S_AXI_arready <= m05_couplers_to_m05_couplers_ARREADY;
  S_AXI_awready <= m05_couplers_to_m05_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m05_couplers_to_m05_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m05_couplers_to_m05_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m05_couplers_to_m05_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m05_couplers_to_m05_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m05_couplers_to_m05_couplers_RVALID;
  S_AXI_wready <= m05_couplers_to_m05_couplers_WREADY;
  m05_couplers_to_m05_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m05_couplers_to_m05_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m05_couplers_to_m05_couplers_ARREADY <= M_AXI_arready;
  m05_couplers_to_m05_couplers_ARVALID <= S_AXI_arvalid;
  m05_couplers_to_m05_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m05_couplers_to_m05_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m05_couplers_to_m05_couplers_AWREADY <= M_AXI_awready;
  m05_couplers_to_m05_couplers_AWVALID <= S_AXI_awvalid;
  m05_couplers_to_m05_couplers_BREADY <= S_AXI_bready;
  m05_couplers_to_m05_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m05_couplers_to_m05_couplers_BVALID <= M_AXI_bvalid;
  m05_couplers_to_m05_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m05_couplers_to_m05_couplers_RREADY <= S_AXI_rready;
  m05_couplers_to_m05_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m05_couplers_to_m05_couplers_RVALID <= M_AXI_rvalid;
  m05_couplers_to_m05_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m05_couplers_to_m05_couplers_WREADY <= M_AXI_wready;
  m05_couplers_to_m05_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m05_couplers_to_m05_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m06_couplers_imp_O6G7N1 is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m06_couplers_imp_O6G7N1;

architecture STRUCTURE of m06_couplers_imp_O6G7N1 is
  signal m06_couplers_to_m06_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_m06_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m06_couplers_to_m06_couplers_ARREADY : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_ARVALID : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_m06_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m06_couplers_to_m06_couplers_AWREADY : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_AWVALID : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_BREADY : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m06_couplers_to_m06_couplers_BVALID : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_m06_couplers_RREADY : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m06_couplers_to_m06_couplers_RVALID : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_m06_couplers_WREADY : STD_LOGIC;
  signal m06_couplers_to_m06_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m06_couplers_to_m06_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m06_couplers_to_m06_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m06_couplers_to_m06_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m06_couplers_to_m06_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m06_couplers_to_m06_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m06_couplers_to_m06_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m06_couplers_to_m06_couplers_AWVALID;
  M_AXI_bready <= m06_couplers_to_m06_couplers_BREADY;
  M_AXI_rready <= m06_couplers_to_m06_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m06_couplers_to_m06_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m06_couplers_to_m06_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m06_couplers_to_m06_couplers_WVALID;
  S_AXI_arready <= m06_couplers_to_m06_couplers_ARREADY;
  S_AXI_awready <= m06_couplers_to_m06_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m06_couplers_to_m06_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m06_couplers_to_m06_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m06_couplers_to_m06_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m06_couplers_to_m06_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m06_couplers_to_m06_couplers_RVALID;
  S_AXI_wready <= m06_couplers_to_m06_couplers_WREADY;
  m06_couplers_to_m06_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m06_couplers_to_m06_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m06_couplers_to_m06_couplers_ARREADY <= M_AXI_arready;
  m06_couplers_to_m06_couplers_ARVALID <= S_AXI_arvalid;
  m06_couplers_to_m06_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m06_couplers_to_m06_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m06_couplers_to_m06_couplers_AWREADY <= M_AXI_awready;
  m06_couplers_to_m06_couplers_AWVALID <= S_AXI_awvalid;
  m06_couplers_to_m06_couplers_BREADY <= S_AXI_bready;
  m06_couplers_to_m06_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m06_couplers_to_m06_couplers_BVALID <= M_AXI_bvalid;
  m06_couplers_to_m06_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m06_couplers_to_m06_couplers_RREADY <= S_AXI_rready;
  m06_couplers_to_m06_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m06_couplers_to_m06_couplers_RVALID <= M_AXI_rvalid;
  m06_couplers_to_m06_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m06_couplers_to_m06_couplers_WREADY <= M_AXI_wready;
  m06_couplers_to_m06_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m06_couplers_to_m06_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m07_couplers_imp_W37PUJ is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m07_couplers_imp_W37PUJ;

architecture STRUCTURE of m07_couplers_imp_W37PUJ is
  signal m07_couplers_to_m07_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_m07_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m07_couplers_to_m07_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_m07_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m07_couplers_to_m07_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m07_couplers_to_m07_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_m07_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m07_couplers_to_m07_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_m07_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_m07_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m07_couplers_to_m07_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(31 downto 0) <= m07_couplers_to_m07_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m07_couplers_to_m07_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid(0) <= m07_couplers_to_m07_couplers_ARVALID(0);
  M_AXI_awaddr(31 downto 0) <= m07_couplers_to_m07_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m07_couplers_to_m07_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid(0) <= m07_couplers_to_m07_couplers_AWVALID(0);
  M_AXI_bready(0) <= m07_couplers_to_m07_couplers_BREADY(0);
  M_AXI_rready(0) <= m07_couplers_to_m07_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m07_couplers_to_m07_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m07_couplers_to_m07_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m07_couplers_to_m07_couplers_WVALID(0);
  S_AXI_arready(0) <= m07_couplers_to_m07_couplers_ARREADY(0);
  S_AXI_awready(0) <= m07_couplers_to_m07_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m07_couplers_to_m07_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m07_couplers_to_m07_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m07_couplers_to_m07_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m07_couplers_to_m07_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m07_couplers_to_m07_couplers_RVALID(0);
  S_AXI_wready(0) <= m07_couplers_to_m07_couplers_WREADY(0);
  m07_couplers_to_m07_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m07_couplers_to_m07_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m07_couplers_to_m07_couplers_ARREADY(0) <= M_AXI_arready(0);
  m07_couplers_to_m07_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m07_couplers_to_m07_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m07_couplers_to_m07_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m07_couplers_to_m07_couplers_AWREADY(0) <= M_AXI_awready(0);
  m07_couplers_to_m07_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m07_couplers_to_m07_couplers_BREADY(0) <= S_AXI_bready(0);
  m07_couplers_to_m07_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m07_couplers_to_m07_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m07_couplers_to_m07_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m07_couplers_to_m07_couplers_RREADY(0) <= S_AXI_rready(0);
  m07_couplers_to_m07_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m07_couplers_to_m07_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m07_couplers_to_m07_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m07_couplers_to_m07_couplers_WREADY(0) <= M_AXI_wready(0);
  m07_couplers_to_m07_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m07_couplers_to_m07_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m08_couplers_imp_VZMG2W is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m08_couplers_imp_VZMG2W;

architecture STRUCTURE of m08_couplers_imp_VZMG2W is
  signal m08_couplers_to_m08_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_m08_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_m08_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m08_couplers_to_m08_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_m08_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m08_couplers_to_m08_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_m08_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_m08_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m08_couplers_to_m08_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(31 downto 0) <= m08_couplers_to_m08_couplers_ARADDR(31 downto 0);
  M_AXI_arvalid(0) <= m08_couplers_to_m08_couplers_ARVALID(0);
  M_AXI_awaddr(31 downto 0) <= m08_couplers_to_m08_couplers_AWADDR(31 downto 0);
  M_AXI_awvalid(0) <= m08_couplers_to_m08_couplers_AWVALID(0);
  M_AXI_bready(0) <= m08_couplers_to_m08_couplers_BREADY(0);
  M_AXI_rready(0) <= m08_couplers_to_m08_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m08_couplers_to_m08_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m08_couplers_to_m08_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m08_couplers_to_m08_couplers_WVALID(0);
  S_AXI_arready(0) <= m08_couplers_to_m08_couplers_ARREADY(0);
  S_AXI_awready(0) <= m08_couplers_to_m08_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m08_couplers_to_m08_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m08_couplers_to_m08_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m08_couplers_to_m08_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m08_couplers_to_m08_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m08_couplers_to_m08_couplers_RVALID(0);
  S_AXI_wready(0) <= m08_couplers_to_m08_couplers_WREADY(0);
  m08_couplers_to_m08_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m08_couplers_to_m08_couplers_ARREADY(0) <= M_AXI_arready(0);
  m08_couplers_to_m08_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m08_couplers_to_m08_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m08_couplers_to_m08_couplers_AWREADY(0) <= M_AXI_awready(0);
  m08_couplers_to_m08_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m08_couplers_to_m08_couplers_BREADY(0) <= S_AXI_bready(0);
  m08_couplers_to_m08_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m08_couplers_to_m08_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m08_couplers_to_m08_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m08_couplers_to_m08_couplers_RREADY(0) <= S_AXI_rready(0);
  m08_couplers_to_m08_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m08_couplers_to_m08_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m08_couplers_to_m08_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m08_couplers_to_m08_couplers_WREADY(0) <= M_AXI_wready(0);
  m08_couplers_to_m08_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m08_couplers_to_m08_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m09_couplers_imp_OCUCWU is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end m09_couplers_imp_OCUCWU;

architecture STRUCTURE of m09_couplers_imp_OCUCWU is
  signal m09_couplers_to_m09_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_m09_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_m09_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m09_couplers_to_m09_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_m09_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m09_couplers_to_m09_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_m09_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_m09_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m09_couplers_to_m09_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
begin
  M_AXI_araddr(31 downto 0) <= m09_couplers_to_m09_couplers_ARADDR(31 downto 0);
  M_AXI_arvalid(0) <= m09_couplers_to_m09_couplers_ARVALID(0);
  M_AXI_awaddr(31 downto 0) <= m09_couplers_to_m09_couplers_AWADDR(31 downto 0);
  M_AXI_awvalid(0) <= m09_couplers_to_m09_couplers_AWVALID(0);
  M_AXI_bready(0) <= m09_couplers_to_m09_couplers_BREADY(0);
  M_AXI_rready(0) <= m09_couplers_to_m09_couplers_RREADY(0);
  M_AXI_wdata(31 downto 0) <= m09_couplers_to_m09_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m09_couplers_to_m09_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid(0) <= m09_couplers_to_m09_couplers_WVALID(0);
  S_AXI_arready(0) <= m09_couplers_to_m09_couplers_ARREADY(0);
  S_AXI_awready(0) <= m09_couplers_to_m09_couplers_AWREADY(0);
  S_AXI_bresp(1 downto 0) <= m09_couplers_to_m09_couplers_BRESP(1 downto 0);
  S_AXI_bvalid(0) <= m09_couplers_to_m09_couplers_BVALID(0);
  S_AXI_rdata(31 downto 0) <= m09_couplers_to_m09_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m09_couplers_to_m09_couplers_RRESP(1 downto 0);
  S_AXI_rvalid(0) <= m09_couplers_to_m09_couplers_RVALID(0);
  S_AXI_wready(0) <= m09_couplers_to_m09_couplers_WREADY(0);
  m09_couplers_to_m09_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m09_couplers_to_m09_couplers_ARREADY(0) <= M_AXI_arready(0);
  m09_couplers_to_m09_couplers_ARVALID(0) <= S_AXI_arvalid(0);
  m09_couplers_to_m09_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m09_couplers_to_m09_couplers_AWREADY(0) <= M_AXI_awready(0);
  m09_couplers_to_m09_couplers_AWVALID(0) <= S_AXI_awvalid(0);
  m09_couplers_to_m09_couplers_BREADY(0) <= S_AXI_bready(0);
  m09_couplers_to_m09_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m09_couplers_to_m09_couplers_BVALID(0) <= M_AXI_bvalid(0);
  m09_couplers_to_m09_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m09_couplers_to_m09_couplers_RREADY(0) <= S_AXI_rready(0);
  m09_couplers_to_m09_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m09_couplers_to_m09_couplers_RVALID(0) <= M_AXI_rvalid(0);
  m09_couplers_to_m09_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m09_couplers_to_m09_couplers_WREADY(0) <= M_AXI_wready(0);
  m09_couplers_to_m09_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m09_couplers_to_m09_couplers_WVALID(0) <= S_AXI_wvalid(0);
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m10_couplers_imp_ISE7KH is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m10_couplers_imp_ISE7KH;

architecture STRUCTURE of m10_couplers_imp_ISE7KH is
  signal m10_couplers_to_m10_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m10_couplers_to_m10_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m10_couplers_to_m10_couplers_ARREADY : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_ARVALID : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m10_couplers_to_m10_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m10_couplers_to_m10_couplers_AWREADY : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_AWVALID : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_BREADY : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m10_couplers_to_m10_couplers_BVALID : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m10_couplers_to_m10_couplers_RREADY : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m10_couplers_to_m10_couplers_RVALID : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m10_couplers_to_m10_couplers_WREADY : STD_LOGIC;
  signal m10_couplers_to_m10_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m10_couplers_to_m10_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m10_couplers_to_m10_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m10_couplers_to_m10_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m10_couplers_to_m10_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m10_couplers_to_m10_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m10_couplers_to_m10_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m10_couplers_to_m10_couplers_AWVALID;
  M_AXI_bready <= m10_couplers_to_m10_couplers_BREADY;
  M_AXI_rready <= m10_couplers_to_m10_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m10_couplers_to_m10_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m10_couplers_to_m10_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m10_couplers_to_m10_couplers_WVALID;
  S_AXI_arready <= m10_couplers_to_m10_couplers_ARREADY;
  S_AXI_awready <= m10_couplers_to_m10_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m10_couplers_to_m10_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m10_couplers_to_m10_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m10_couplers_to_m10_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m10_couplers_to_m10_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m10_couplers_to_m10_couplers_RVALID;
  S_AXI_wready <= m10_couplers_to_m10_couplers_WREADY;
  m10_couplers_to_m10_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m10_couplers_to_m10_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m10_couplers_to_m10_couplers_ARREADY <= M_AXI_arready;
  m10_couplers_to_m10_couplers_ARVALID <= S_AXI_arvalid;
  m10_couplers_to_m10_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m10_couplers_to_m10_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m10_couplers_to_m10_couplers_AWREADY <= M_AXI_awready;
  m10_couplers_to_m10_couplers_AWVALID <= S_AXI_awvalid;
  m10_couplers_to_m10_couplers_BREADY <= S_AXI_bready;
  m10_couplers_to_m10_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m10_couplers_to_m10_couplers_BVALID <= M_AXI_bvalid;
  m10_couplers_to_m10_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m10_couplers_to_m10_couplers_RREADY <= S_AXI_rready;
  m10_couplers_to_m10_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m10_couplers_to_m10_couplers_RVALID <= M_AXI_rvalid;
  m10_couplers_to_m10_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m10_couplers_to_m10_couplers_WREADY <= M_AXI_wready;
  m10_couplers_to_m10_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m10_couplers_to_m10_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m11_couplers_imp_SMWPUV is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m11_couplers_imp_SMWPUV;

architecture STRUCTURE of m11_couplers_imp_SMWPUV is
  signal m11_couplers_to_m11_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m11_couplers_to_m11_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m11_couplers_to_m11_couplers_ARREADY : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_ARVALID : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m11_couplers_to_m11_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m11_couplers_to_m11_couplers_AWREADY : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_AWVALID : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_BREADY : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m11_couplers_to_m11_couplers_BVALID : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m11_couplers_to_m11_couplers_RREADY : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m11_couplers_to_m11_couplers_RVALID : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m11_couplers_to_m11_couplers_WREADY : STD_LOGIC;
  signal m11_couplers_to_m11_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m11_couplers_to_m11_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m11_couplers_to_m11_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m11_couplers_to_m11_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m11_couplers_to_m11_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m11_couplers_to_m11_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m11_couplers_to_m11_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m11_couplers_to_m11_couplers_AWVALID;
  M_AXI_bready <= m11_couplers_to_m11_couplers_BREADY;
  M_AXI_rready <= m11_couplers_to_m11_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m11_couplers_to_m11_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m11_couplers_to_m11_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m11_couplers_to_m11_couplers_WVALID;
  S_AXI_arready <= m11_couplers_to_m11_couplers_ARREADY;
  S_AXI_awready <= m11_couplers_to_m11_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m11_couplers_to_m11_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m11_couplers_to_m11_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m11_couplers_to_m11_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m11_couplers_to_m11_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m11_couplers_to_m11_couplers_RVALID;
  S_AXI_wready <= m11_couplers_to_m11_couplers_WREADY;
  m11_couplers_to_m11_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m11_couplers_to_m11_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m11_couplers_to_m11_couplers_ARREADY <= M_AXI_arready;
  m11_couplers_to_m11_couplers_ARVALID <= S_AXI_arvalid;
  m11_couplers_to_m11_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m11_couplers_to_m11_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m11_couplers_to_m11_couplers_AWREADY <= M_AXI_awready;
  m11_couplers_to_m11_couplers_AWVALID <= S_AXI_awvalid;
  m11_couplers_to_m11_couplers_BREADY <= S_AXI_bready;
  m11_couplers_to_m11_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m11_couplers_to_m11_couplers_BVALID <= M_AXI_bvalid;
  m11_couplers_to_m11_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m11_couplers_to_m11_couplers_RREADY <= S_AXI_rready;
  m11_couplers_to_m11_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m11_couplers_to_m11_couplers_RVALID <= M_AXI_rvalid;
  m11_couplers_to_m11_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m11_couplers_to_m11_couplers_WREADY <= M_AXI_wready;
  m11_couplers_to_m11_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m11_couplers_to_m11_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m12_couplers_imp_2YWMGT is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m12_couplers_imp_2YWMGT;

architecture STRUCTURE of m12_couplers_imp_2YWMGT is
  signal m12_couplers_to_m12_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m12_couplers_to_m12_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m12_couplers_to_m12_couplers_ARREADY : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_ARVALID : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m12_couplers_to_m12_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m12_couplers_to_m12_couplers_AWREADY : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_AWVALID : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_BREADY : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m12_couplers_to_m12_couplers_BVALID : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m12_couplers_to_m12_couplers_RREADY : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m12_couplers_to_m12_couplers_RVALID : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m12_couplers_to_m12_couplers_WREADY : STD_LOGIC;
  signal m12_couplers_to_m12_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m12_couplers_to_m12_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m12_couplers_to_m12_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m12_couplers_to_m12_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m12_couplers_to_m12_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m12_couplers_to_m12_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m12_couplers_to_m12_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m12_couplers_to_m12_couplers_AWVALID;
  M_AXI_bready <= m12_couplers_to_m12_couplers_BREADY;
  M_AXI_rready <= m12_couplers_to_m12_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m12_couplers_to_m12_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m12_couplers_to_m12_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m12_couplers_to_m12_couplers_WVALID;
  S_AXI_arready <= m12_couplers_to_m12_couplers_ARREADY;
  S_AXI_awready <= m12_couplers_to_m12_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m12_couplers_to_m12_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m12_couplers_to_m12_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m12_couplers_to_m12_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m12_couplers_to_m12_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m12_couplers_to_m12_couplers_RVALID;
  S_AXI_wready <= m12_couplers_to_m12_couplers_WREADY;
  m12_couplers_to_m12_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m12_couplers_to_m12_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m12_couplers_to_m12_couplers_ARREADY <= M_AXI_arready;
  m12_couplers_to_m12_couplers_ARVALID <= S_AXI_arvalid;
  m12_couplers_to_m12_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m12_couplers_to_m12_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m12_couplers_to_m12_couplers_AWREADY <= M_AXI_awready;
  m12_couplers_to_m12_couplers_AWVALID <= S_AXI_awvalid;
  m12_couplers_to_m12_couplers_BREADY <= S_AXI_bready;
  m12_couplers_to_m12_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m12_couplers_to_m12_couplers_BVALID <= M_AXI_bvalid;
  m12_couplers_to_m12_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m12_couplers_to_m12_couplers_RREADY <= S_AXI_rready;
  m12_couplers_to_m12_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m12_couplers_to_m12_couplers_RVALID <= M_AXI_rvalid;
  m12_couplers_to_m12_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m12_couplers_to_m12_couplers_WREADY <= M_AXI_wready;
  m12_couplers_to_m12_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m12_couplers_to_m12_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity m13_couplers_imp_CTF4P7 is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end m13_couplers_imp_CTF4P7;

architecture STRUCTURE of m13_couplers_imp_CTF4P7 is
  signal m13_couplers_to_m13_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m13_couplers_to_m13_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m13_couplers_to_m13_couplers_ARREADY : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_ARVALID : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m13_couplers_to_m13_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m13_couplers_to_m13_couplers_AWREADY : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_AWVALID : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_BREADY : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m13_couplers_to_m13_couplers_BVALID : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m13_couplers_to_m13_couplers_RREADY : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m13_couplers_to_m13_couplers_RVALID : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m13_couplers_to_m13_couplers_WREADY : STD_LOGIC;
  signal m13_couplers_to_m13_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m13_couplers_to_m13_couplers_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= m13_couplers_to_m13_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= m13_couplers_to_m13_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= m13_couplers_to_m13_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= m13_couplers_to_m13_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= m13_couplers_to_m13_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= m13_couplers_to_m13_couplers_AWVALID;
  M_AXI_bready <= m13_couplers_to_m13_couplers_BREADY;
  M_AXI_rready <= m13_couplers_to_m13_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= m13_couplers_to_m13_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= m13_couplers_to_m13_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= m13_couplers_to_m13_couplers_WVALID;
  S_AXI_arready <= m13_couplers_to_m13_couplers_ARREADY;
  S_AXI_awready <= m13_couplers_to_m13_couplers_AWREADY;
  S_AXI_bresp(1 downto 0) <= m13_couplers_to_m13_couplers_BRESP(1 downto 0);
  S_AXI_bvalid <= m13_couplers_to_m13_couplers_BVALID;
  S_AXI_rdata(31 downto 0) <= m13_couplers_to_m13_couplers_RDATA(31 downto 0);
  S_AXI_rresp(1 downto 0) <= m13_couplers_to_m13_couplers_RRESP(1 downto 0);
  S_AXI_rvalid <= m13_couplers_to_m13_couplers_RVALID;
  S_AXI_wready <= m13_couplers_to_m13_couplers_WREADY;
  m13_couplers_to_m13_couplers_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  m13_couplers_to_m13_couplers_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  m13_couplers_to_m13_couplers_ARREADY <= M_AXI_arready;
  m13_couplers_to_m13_couplers_ARVALID <= S_AXI_arvalid;
  m13_couplers_to_m13_couplers_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  m13_couplers_to_m13_couplers_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  m13_couplers_to_m13_couplers_AWREADY <= M_AXI_awready;
  m13_couplers_to_m13_couplers_AWVALID <= S_AXI_awvalid;
  m13_couplers_to_m13_couplers_BREADY <= S_AXI_bready;
  m13_couplers_to_m13_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  m13_couplers_to_m13_couplers_BVALID <= M_AXI_bvalid;
  m13_couplers_to_m13_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  m13_couplers_to_m13_couplers_RREADY <= S_AXI_rready;
  m13_couplers_to_m13_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  m13_couplers_to_m13_couplers_RVALID <= M_AXI_rvalid;
  m13_couplers_to_m13_couplers_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  m13_couplers_to_m13_couplers_WREADY <= M_AXI_wready;
  m13_couplers_to_m13_couplers_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  m13_couplers_to_m13_couplers_WVALID <= S_AXI_wvalid;
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity s00_couplers_imp_1MTXSBB is
  port (
    M_ACLK : in STD_LOGIC;
    M_ARESETN : in STD_LOGIC;
    M_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_arready : in STD_LOGIC;
    M_AXI_arvalid : out STD_LOGIC;
    M_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_awready : in STD_LOGIC;
    M_AXI_awvalid : out STD_LOGIC;
    M_AXI_bready : out STD_LOGIC;
    M_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_bvalid : in STD_LOGIC;
    M_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_rready : out STD_LOGIC;
    M_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_rvalid : in STD_LOGIC;
    M_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_wready : in STD_LOGIC;
    M_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_wvalid : out STD_LOGIC;
    S_ACLK : in STD_LOGIC;
    S_ARESETN : in STD_LOGIC;
    S_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_arid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_arready : out STD_LOGIC;
    S_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_arvalid : in STD_LOGIC;
    S_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_awid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_awready : out STD_LOGIC;
    S_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_awvalid : in STD_LOGIC;
    S_AXI_bid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_bready : in STD_LOGIC;
    S_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_bvalid : out STD_LOGIC;
    S_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_rid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_rlast : out STD_LOGIC;
    S_AXI_rready : in STD_LOGIC;
    S_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_rvalid : out STD_LOGIC;
    S_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_wid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S_AXI_wlast : in STD_LOGIC;
    S_AXI_wready : out STD_LOGIC;
    S_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_wvalid : in STD_LOGIC
  );
end s00_couplers_imp_1MTXSBB;

architecture STRUCTURE of s00_couplers_imp_1MTXSBB is
  component cantavi_streamer_project_auto_pc_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC
  );
  end component cantavi_streamer_project_auto_pc_0;
  signal S_ACLK_1 : STD_LOGIC;
  signal S_ARESETN_1 : STD_LOGIC;
  signal auto_pc_to_s00_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_pc_to_s00_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_pc_to_s00_couplers_ARREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_ARVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_pc_to_s00_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal auto_pc_to_s00_couplers_AWREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_AWVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_BREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_pc_to_s00_couplers_BVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_pc_to_s00_couplers_RREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal auto_pc_to_s00_couplers_RVALID : STD_LOGIC;
  signal auto_pc_to_s00_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal auto_pc_to_s00_couplers_WREADY : STD_LOGIC;
  signal auto_pc_to_s00_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal auto_pc_to_s00_couplers_WVALID : STD_LOGIC;
  signal s00_couplers_to_auto_pc_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_auto_pc_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_pc_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_pc_ARID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal s00_couplers_to_auto_pc_ARLEN : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_pc_ARLOCK : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_pc_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_auto_pc_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_pc_ARREADY : STD_LOGIC;
  signal s00_couplers_to_auto_pc_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_auto_pc_ARVALID : STD_LOGIC;
  signal s00_couplers_to_auto_pc_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_auto_pc_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_pc_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_pc_AWID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal s00_couplers_to_auto_pc_AWLEN : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_pc_AWLOCK : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_pc_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_auto_pc_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_pc_AWREADY : STD_LOGIC;
  signal s00_couplers_to_auto_pc_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_auto_pc_AWVALID : STD_LOGIC;
  signal s00_couplers_to_auto_pc_BID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal s00_couplers_to_auto_pc_BREADY : STD_LOGIC;
  signal s00_couplers_to_auto_pc_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_pc_BVALID : STD_LOGIC;
  signal s00_couplers_to_auto_pc_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_auto_pc_RID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal s00_couplers_to_auto_pc_RLAST : STD_LOGIC;
  signal s00_couplers_to_auto_pc_RREADY : STD_LOGIC;
  signal s00_couplers_to_auto_pc_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_auto_pc_RVALID : STD_LOGIC;
  signal s00_couplers_to_auto_pc_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_auto_pc_WID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal s00_couplers_to_auto_pc_WLAST : STD_LOGIC;
  signal s00_couplers_to_auto_pc_WREADY : STD_LOGIC;
  signal s00_couplers_to_auto_pc_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_auto_pc_WVALID : STD_LOGIC;
begin
  M_AXI_araddr(31 downto 0) <= auto_pc_to_s00_couplers_ARADDR(31 downto 0);
  M_AXI_arprot(2 downto 0) <= auto_pc_to_s00_couplers_ARPROT(2 downto 0);
  M_AXI_arvalid <= auto_pc_to_s00_couplers_ARVALID;
  M_AXI_awaddr(31 downto 0) <= auto_pc_to_s00_couplers_AWADDR(31 downto 0);
  M_AXI_awprot(2 downto 0) <= auto_pc_to_s00_couplers_AWPROT(2 downto 0);
  M_AXI_awvalid <= auto_pc_to_s00_couplers_AWVALID;
  M_AXI_bready <= auto_pc_to_s00_couplers_BREADY;
  M_AXI_rready <= auto_pc_to_s00_couplers_RREADY;
  M_AXI_wdata(31 downto 0) <= auto_pc_to_s00_couplers_WDATA(31 downto 0);
  M_AXI_wstrb(3 downto 0) <= auto_pc_to_s00_couplers_WSTRB(3 downto 0);
  M_AXI_wvalid <= auto_pc_to_s00_couplers_WVALID;
  S_ACLK_1 <= S_ACLK;
  S_ARESETN_1 <= S_ARESETN;
  S_AXI_arready <= s00_couplers_to_auto_pc_ARREADY;
  S_AXI_awready <= s00_couplers_to_auto_pc_AWREADY;
  S_AXI_bid(11 downto 0) <= s00_couplers_to_auto_pc_BID(11 downto 0);
  S_AXI_bresp(1 downto 0) <= s00_couplers_to_auto_pc_BRESP(1 downto 0);
  S_AXI_bvalid <= s00_couplers_to_auto_pc_BVALID;
  S_AXI_rdata(31 downto 0) <= s00_couplers_to_auto_pc_RDATA(31 downto 0);
  S_AXI_rid(11 downto 0) <= s00_couplers_to_auto_pc_RID(11 downto 0);
  S_AXI_rlast <= s00_couplers_to_auto_pc_RLAST;
  S_AXI_rresp(1 downto 0) <= s00_couplers_to_auto_pc_RRESP(1 downto 0);
  S_AXI_rvalid <= s00_couplers_to_auto_pc_RVALID;
  S_AXI_wready <= s00_couplers_to_auto_pc_WREADY;
  auto_pc_to_s00_couplers_ARREADY <= M_AXI_arready;
  auto_pc_to_s00_couplers_AWREADY <= M_AXI_awready;
  auto_pc_to_s00_couplers_BRESP(1 downto 0) <= M_AXI_bresp(1 downto 0);
  auto_pc_to_s00_couplers_BVALID <= M_AXI_bvalid;
  auto_pc_to_s00_couplers_RDATA(31 downto 0) <= M_AXI_rdata(31 downto 0);
  auto_pc_to_s00_couplers_RRESP(1 downto 0) <= M_AXI_rresp(1 downto 0);
  auto_pc_to_s00_couplers_RVALID <= M_AXI_rvalid;
  auto_pc_to_s00_couplers_WREADY <= M_AXI_wready;
  s00_couplers_to_auto_pc_ARADDR(31 downto 0) <= S_AXI_araddr(31 downto 0);
  s00_couplers_to_auto_pc_ARBURST(1 downto 0) <= S_AXI_arburst(1 downto 0);
  s00_couplers_to_auto_pc_ARCACHE(3 downto 0) <= S_AXI_arcache(3 downto 0);
  s00_couplers_to_auto_pc_ARID(11 downto 0) <= S_AXI_arid(11 downto 0);
  s00_couplers_to_auto_pc_ARLEN(3 downto 0) <= S_AXI_arlen(3 downto 0);
  s00_couplers_to_auto_pc_ARLOCK(1 downto 0) <= S_AXI_arlock(1 downto 0);
  s00_couplers_to_auto_pc_ARPROT(2 downto 0) <= S_AXI_arprot(2 downto 0);
  s00_couplers_to_auto_pc_ARQOS(3 downto 0) <= S_AXI_arqos(3 downto 0);
  s00_couplers_to_auto_pc_ARSIZE(2 downto 0) <= S_AXI_arsize(2 downto 0);
  s00_couplers_to_auto_pc_ARVALID <= S_AXI_arvalid;
  s00_couplers_to_auto_pc_AWADDR(31 downto 0) <= S_AXI_awaddr(31 downto 0);
  s00_couplers_to_auto_pc_AWBURST(1 downto 0) <= S_AXI_awburst(1 downto 0);
  s00_couplers_to_auto_pc_AWCACHE(3 downto 0) <= S_AXI_awcache(3 downto 0);
  s00_couplers_to_auto_pc_AWID(11 downto 0) <= S_AXI_awid(11 downto 0);
  s00_couplers_to_auto_pc_AWLEN(3 downto 0) <= S_AXI_awlen(3 downto 0);
  s00_couplers_to_auto_pc_AWLOCK(1 downto 0) <= S_AXI_awlock(1 downto 0);
  s00_couplers_to_auto_pc_AWPROT(2 downto 0) <= S_AXI_awprot(2 downto 0);
  s00_couplers_to_auto_pc_AWQOS(3 downto 0) <= S_AXI_awqos(3 downto 0);
  s00_couplers_to_auto_pc_AWSIZE(2 downto 0) <= S_AXI_awsize(2 downto 0);
  s00_couplers_to_auto_pc_AWVALID <= S_AXI_awvalid;
  s00_couplers_to_auto_pc_BREADY <= S_AXI_bready;
  s00_couplers_to_auto_pc_RREADY <= S_AXI_rready;
  s00_couplers_to_auto_pc_WDATA(31 downto 0) <= S_AXI_wdata(31 downto 0);
  s00_couplers_to_auto_pc_WID(11 downto 0) <= S_AXI_wid(11 downto 0);
  s00_couplers_to_auto_pc_WLAST <= S_AXI_wlast;
  s00_couplers_to_auto_pc_WSTRB(3 downto 0) <= S_AXI_wstrb(3 downto 0);
  s00_couplers_to_auto_pc_WVALID <= S_AXI_wvalid;
auto_pc: component cantavi_streamer_project_auto_pc_0
     port map (
      aclk => S_ACLK_1,
      aresetn => S_ARESETN_1,
      m_axi_araddr(31 downto 0) => auto_pc_to_s00_couplers_ARADDR(31 downto 0),
      m_axi_arprot(2 downto 0) => auto_pc_to_s00_couplers_ARPROT(2 downto 0),
      m_axi_arready => auto_pc_to_s00_couplers_ARREADY,
      m_axi_arvalid => auto_pc_to_s00_couplers_ARVALID,
      m_axi_awaddr(31 downto 0) => auto_pc_to_s00_couplers_AWADDR(31 downto 0),
      m_axi_awprot(2 downto 0) => auto_pc_to_s00_couplers_AWPROT(2 downto 0),
      m_axi_awready => auto_pc_to_s00_couplers_AWREADY,
      m_axi_awvalid => auto_pc_to_s00_couplers_AWVALID,
      m_axi_bready => auto_pc_to_s00_couplers_BREADY,
      m_axi_bresp(1 downto 0) => auto_pc_to_s00_couplers_BRESP(1 downto 0),
      m_axi_bvalid => auto_pc_to_s00_couplers_BVALID,
      m_axi_rdata(31 downto 0) => auto_pc_to_s00_couplers_RDATA(31 downto 0),
      m_axi_rready => auto_pc_to_s00_couplers_RREADY,
      m_axi_rresp(1 downto 0) => auto_pc_to_s00_couplers_RRESP(1 downto 0),
      m_axi_rvalid => auto_pc_to_s00_couplers_RVALID,
      m_axi_wdata(31 downto 0) => auto_pc_to_s00_couplers_WDATA(31 downto 0),
      m_axi_wready => auto_pc_to_s00_couplers_WREADY,
      m_axi_wstrb(3 downto 0) => auto_pc_to_s00_couplers_WSTRB(3 downto 0),
      m_axi_wvalid => auto_pc_to_s00_couplers_WVALID,
      s_axi_araddr(31 downto 0) => s00_couplers_to_auto_pc_ARADDR(31 downto 0),
      s_axi_arburst(1 downto 0) => s00_couplers_to_auto_pc_ARBURST(1 downto 0),
      s_axi_arcache(3 downto 0) => s00_couplers_to_auto_pc_ARCACHE(3 downto 0),
      s_axi_arid(11 downto 0) => s00_couplers_to_auto_pc_ARID(11 downto 0),
      s_axi_arlen(3 downto 0) => s00_couplers_to_auto_pc_ARLEN(3 downto 0),
      s_axi_arlock(1 downto 0) => s00_couplers_to_auto_pc_ARLOCK(1 downto 0),
      s_axi_arprot(2 downto 0) => s00_couplers_to_auto_pc_ARPROT(2 downto 0),
      s_axi_arqos(3 downto 0) => s00_couplers_to_auto_pc_ARQOS(3 downto 0),
      s_axi_arready => s00_couplers_to_auto_pc_ARREADY,
      s_axi_arsize(2 downto 0) => s00_couplers_to_auto_pc_ARSIZE(2 downto 0),
      s_axi_arvalid => s00_couplers_to_auto_pc_ARVALID,
      s_axi_awaddr(31 downto 0) => s00_couplers_to_auto_pc_AWADDR(31 downto 0),
      s_axi_awburst(1 downto 0) => s00_couplers_to_auto_pc_AWBURST(1 downto 0),
      s_axi_awcache(3 downto 0) => s00_couplers_to_auto_pc_AWCACHE(3 downto 0),
      s_axi_awid(11 downto 0) => s00_couplers_to_auto_pc_AWID(11 downto 0),
      s_axi_awlen(3 downto 0) => s00_couplers_to_auto_pc_AWLEN(3 downto 0),
      s_axi_awlock(1 downto 0) => s00_couplers_to_auto_pc_AWLOCK(1 downto 0),
      s_axi_awprot(2 downto 0) => s00_couplers_to_auto_pc_AWPROT(2 downto 0),
      s_axi_awqos(3 downto 0) => s00_couplers_to_auto_pc_AWQOS(3 downto 0),
      s_axi_awready => s00_couplers_to_auto_pc_AWREADY,
      s_axi_awsize(2 downto 0) => s00_couplers_to_auto_pc_AWSIZE(2 downto 0),
      s_axi_awvalid => s00_couplers_to_auto_pc_AWVALID,
      s_axi_bid(11 downto 0) => s00_couplers_to_auto_pc_BID(11 downto 0),
      s_axi_bready => s00_couplers_to_auto_pc_BREADY,
      s_axi_bresp(1 downto 0) => s00_couplers_to_auto_pc_BRESP(1 downto 0),
      s_axi_bvalid => s00_couplers_to_auto_pc_BVALID,
      s_axi_rdata(31 downto 0) => s00_couplers_to_auto_pc_RDATA(31 downto 0),
      s_axi_rid(11 downto 0) => s00_couplers_to_auto_pc_RID(11 downto 0),
      s_axi_rlast => s00_couplers_to_auto_pc_RLAST,
      s_axi_rready => s00_couplers_to_auto_pc_RREADY,
      s_axi_rresp(1 downto 0) => s00_couplers_to_auto_pc_RRESP(1 downto 0),
      s_axi_rvalid => s00_couplers_to_auto_pc_RVALID,
      s_axi_wdata(31 downto 0) => s00_couplers_to_auto_pc_WDATA(31 downto 0),
      s_axi_wid(11 downto 0) => s00_couplers_to_auto_pc_WID(11 downto 0),
      s_axi_wlast => s00_couplers_to_auto_pc_WLAST,
      s_axi_wready => s00_couplers_to_auto_pc_WREADY,
      s_axi_wstrb(3 downto 0) => s00_couplers_to_auto_pc_WSTRB(3 downto 0),
      s_axi_wvalid => s00_couplers_to_auto_pc_WVALID
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity cantavi_streamer_project_ps7_0_axi_periph_0 is
  port (
    ACLK : in STD_LOGIC;
    ARESETN : in STD_LOGIC;
    M00_ACLK : in STD_LOGIC;
    M00_ARESETN : in STD_LOGIC;
    M00_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_ACLK : in STD_LOGIC;
    M01_ARESETN : in STD_LOGIC;
    M01_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M01_AXI_arready : in STD_LOGIC;
    M01_AXI_arvalid : out STD_LOGIC;
    M01_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M01_AXI_awready : in STD_LOGIC;
    M01_AXI_awvalid : out STD_LOGIC;
    M01_AXI_bready : out STD_LOGIC;
    M01_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_bvalid : in STD_LOGIC;
    M01_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_rready : out STD_LOGIC;
    M01_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_rvalid : in STD_LOGIC;
    M01_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_wready : in STD_LOGIC;
    M01_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M01_AXI_wvalid : out STD_LOGIC;
    M02_ACLK : in STD_LOGIC;
    M02_ARESETN : in STD_LOGIC;
    M02_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M02_AXI_arready : in STD_LOGIC;
    M02_AXI_arvalid : out STD_LOGIC;
    M02_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M02_AXI_awready : in STD_LOGIC;
    M02_AXI_awvalid : out STD_LOGIC;
    M02_AXI_bready : out STD_LOGIC;
    M02_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_bvalid : in STD_LOGIC;
    M02_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_rready : out STD_LOGIC;
    M02_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_rvalid : in STD_LOGIC;
    M02_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_wready : in STD_LOGIC;
    M02_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M02_AXI_wvalid : out STD_LOGIC;
    M03_ACLK : in STD_LOGIC;
    M03_ARESETN : in STD_LOGIC;
    M03_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M03_AXI_arready : in STD_LOGIC;
    M03_AXI_arvalid : out STD_LOGIC;
    M03_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M03_AXI_awready : in STD_LOGIC;
    M03_AXI_awvalid : out STD_LOGIC;
    M03_AXI_bready : out STD_LOGIC;
    M03_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_bvalid : in STD_LOGIC;
    M03_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_rready : out STD_LOGIC;
    M03_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_rvalid : in STD_LOGIC;
    M03_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_wready : in STD_LOGIC;
    M03_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M03_AXI_wvalid : out STD_LOGIC;
    M04_ACLK : in STD_LOGIC;
    M04_ARESETN : in STD_LOGIC;
    M04_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M04_AXI_arready : in STD_LOGIC;
    M04_AXI_arvalid : out STD_LOGIC;
    M04_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M04_AXI_awready : in STD_LOGIC;
    M04_AXI_awvalid : out STD_LOGIC;
    M04_AXI_bready : out STD_LOGIC;
    M04_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M04_AXI_bvalid : in STD_LOGIC;
    M04_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_rready : out STD_LOGIC;
    M04_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M04_AXI_rvalid : in STD_LOGIC;
    M04_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_wready : in STD_LOGIC;
    M04_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M04_AXI_wvalid : out STD_LOGIC;
    M05_ACLK : in STD_LOGIC;
    M05_ARESETN : in STD_LOGIC;
    M05_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_arready : in STD_LOGIC;
    M05_AXI_arvalid : out STD_LOGIC;
    M05_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_awready : in STD_LOGIC;
    M05_AXI_awvalid : out STD_LOGIC;
    M05_AXI_bready : out STD_LOGIC;
    M05_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_bvalid : in STD_LOGIC;
    M05_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_rready : out STD_LOGIC;
    M05_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_rvalid : in STD_LOGIC;
    M05_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_wready : in STD_LOGIC;
    M05_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_wvalid : out STD_LOGIC;
    M06_ACLK : in STD_LOGIC;
    M06_ARESETN : in STD_LOGIC;
    M06_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M06_AXI_arready : in STD_LOGIC;
    M06_AXI_arvalid : out STD_LOGIC;
    M06_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M06_AXI_awready : in STD_LOGIC;
    M06_AXI_awvalid : out STD_LOGIC;
    M06_AXI_bready : out STD_LOGIC;
    M06_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_bvalid : in STD_LOGIC;
    M06_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_rready : out STD_LOGIC;
    M06_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_rvalid : in STD_LOGIC;
    M06_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_wready : in STD_LOGIC;
    M06_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M06_AXI_wvalid : out STD_LOGIC;
    M07_ACLK : in STD_LOGIC;
    M07_ARESETN : in STD_LOGIC;
    M07_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M07_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_ACLK : in STD_LOGIC;
    M08_ARESETN : in STD_LOGIC;
    M08_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M08_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M08_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M08_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M08_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M08_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M08_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M08_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M08_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M09_ACLK : in STD_LOGIC;
    M09_ARESETN : in STD_LOGIC;
    M09_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M09_AXI_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M09_AXI_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M09_AXI_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M09_AXI_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M09_AXI_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M09_AXI_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M09_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M09_AXI_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M10_ACLK : in STD_LOGIC;
    M10_ARESETN : in STD_LOGIC;
    M10_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M10_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M10_AXI_arready : in STD_LOGIC;
    M10_AXI_arvalid : out STD_LOGIC;
    M10_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M10_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M10_AXI_awready : in STD_LOGIC;
    M10_AXI_awvalid : out STD_LOGIC;
    M10_AXI_bready : out STD_LOGIC;
    M10_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M10_AXI_bvalid : in STD_LOGIC;
    M10_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M10_AXI_rready : out STD_LOGIC;
    M10_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M10_AXI_rvalid : in STD_LOGIC;
    M10_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M10_AXI_wready : in STD_LOGIC;
    M10_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M10_AXI_wvalid : out STD_LOGIC;
    M11_ACLK : in STD_LOGIC;
    M11_ARESETN : in STD_LOGIC;
    M11_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M11_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M11_AXI_arready : in STD_LOGIC;
    M11_AXI_arvalid : out STD_LOGIC;
    M11_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M11_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M11_AXI_awready : in STD_LOGIC;
    M11_AXI_awvalid : out STD_LOGIC;
    M11_AXI_bready : out STD_LOGIC;
    M11_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M11_AXI_bvalid : in STD_LOGIC;
    M11_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M11_AXI_rready : out STD_LOGIC;
    M11_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M11_AXI_rvalid : in STD_LOGIC;
    M11_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M11_AXI_wready : in STD_LOGIC;
    M11_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M11_AXI_wvalid : out STD_LOGIC;
    M12_ACLK : in STD_LOGIC;
    M12_ARESETN : in STD_LOGIC;
    M12_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M12_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M12_AXI_arready : in STD_LOGIC;
    M12_AXI_arvalid : out STD_LOGIC;
    M12_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M12_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M12_AXI_awready : in STD_LOGIC;
    M12_AXI_awvalid : out STD_LOGIC;
    M12_AXI_bready : out STD_LOGIC;
    M12_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M12_AXI_bvalid : in STD_LOGIC;
    M12_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M12_AXI_rready : out STD_LOGIC;
    M12_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M12_AXI_rvalid : in STD_LOGIC;
    M12_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M12_AXI_wready : in STD_LOGIC;
    M12_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M12_AXI_wvalid : out STD_LOGIC;
    M13_ACLK : in STD_LOGIC;
    M13_ARESETN : in STD_LOGIC;
    M13_AXI_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M13_AXI_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M13_AXI_arready : in STD_LOGIC;
    M13_AXI_arvalid : out STD_LOGIC;
    M13_AXI_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M13_AXI_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M13_AXI_awready : in STD_LOGIC;
    M13_AXI_awvalid : out STD_LOGIC;
    M13_AXI_bready : out STD_LOGIC;
    M13_AXI_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M13_AXI_bvalid : in STD_LOGIC;
    M13_AXI_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M13_AXI_rready : out STD_LOGIC;
    M13_AXI_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M13_AXI_rvalid : in STD_LOGIC;
    M13_AXI_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M13_AXI_wready : in STD_LOGIC;
    M13_AXI_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M13_AXI_wvalid : out STD_LOGIC;
    S00_ACLK : in STD_LOGIC;
    S00_ARESETN : in STD_LOGIC;
    S00_AXI_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_arid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S00_AXI_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_arready : out STD_LOGIC;
    S00_AXI_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_arvalid : in STD_LOGIC;
    S00_AXI_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_awid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S00_AXI_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_awready : out STD_LOGIC;
    S00_AXI_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_awvalid : in STD_LOGIC;
    S00_AXI_bid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    S00_AXI_bready : in STD_LOGIC;
    S00_AXI_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_bvalid : out STD_LOGIC;
    S00_AXI_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_rid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    S00_AXI_rlast : out STD_LOGIC;
    S00_AXI_rready : in STD_LOGIC;
    S00_AXI_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_rvalid : out STD_LOGIC;
    S00_AXI_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_wid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    S00_AXI_wlast : in STD_LOGIC;
    S00_AXI_wready : out STD_LOGIC;
    S00_AXI_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_wvalid : in STD_LOGIC
  );
end cantavi_streamer_project_ps7_0_axi_periph_0;

architecture STRUCTURE of cantavi_streamer_project_ps7_0_axi_periph_0 is
  component cantavi_streamer_project_xbar_0 is
  port (
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    s_axi_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 447 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 41 downto 0 );
    m_axi_awvalid : out STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_awready : in STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_wdata : out STD_LOGIC_VECTOR ( 447 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 55 downto 0 );
    m_axi_wvalid : out STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_wready : in STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_bresp : in STD_LOGIC_VECTOR ( 27 downto 0 );
    m_axi_bvalid : in STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_bready : out STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_araddr : out STD_LOGIC_VECTOR ( 447 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 41 downto 0 );
    m_axi_arvalid : out STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_arready : in STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_rdata : in STD_LOGIC_VECTOR ( 447 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 27 downto 0 );
    m_axi_rvalid : in STD_LOGIC_VECTOR ( 13 downto 0 );
    m_axi_rready : out STD_LOGIC_VECTOR ( 13 downto 0 )
  );
  end component cantavi_streamer_project_xbar_0;
  signal M00_ACLK_1 : STD_LOGIC;
  signal M00_ARESETN_1 : STD_LOGIC;
  signal M01_ACLK_1 : STD_LOGIC;
  signal M01_ARESETN_1 : STD_LOGIC;
  signal M02_ACLK_1 : STD_LOGIC;
  signal M02_ARESETN_1 : STD_LOGIC;
  signal M03_ACLK_1 : STD_LOGIC;
  signal M03_ARESETN_1 : STD_LOGIC;
  signal M04_ACLK_1 : STD_LOGIC;
  signal M04_ARESETN_1 : STD_LOGIC;
  signal M05_ACLK_1 : STD_LOGIC;
  signal M05_ARESETN_1 : STD_LOGIC;
  signal M06_ACLK_1 : STD_LOGIC;
  signal M06_ARESETN_1 : STD_LOGIC;
  signal M07_ACLK_1 : STD_LOGIC;
  signal M07_ARESETN_1 : STD_LOGIC;
  signal M08_ACLK_1 : STD_LOGIC;
  signal M08_ARESETN_1 : STD_LOGIC;
  signal M09_ACLK_1 : STD_LOGIC;
  signal M09_ARESETN_1 : STD_LOGIC;
  signal M10_ACLK_1 : STD_LOGIC;
  signal M10_ARESETN_1 : STD_LOGIC;
  signal M11_ACLK_1 : STD_LOGIC;
  signal M11_ARESETN_1 : STD_LOGIC;
  signal M12_ACLK_1 : STD_LOGIC;
  signal M12_ARESETN_1 : STD_LOGIC;
  signal M13_ACLK_1 : STD_LOGIC;
  signal M13_ARESETN_1 : STD_LOGIC;
  signal S00_ACLK_1 : STD_LOGIC;
  signal S00_ARESETN_1 : STD_LOGIC;
  signal m00_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m00_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m00_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m00_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m00_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m00_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m01_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m01_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m01_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m02_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m02_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m03_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m03_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m04_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m04_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m05_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m05_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m06_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m06_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m07_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m07_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m07_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m08_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m08_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m08_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m08_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m08_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m09_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m09_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m09_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m09_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m09_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal m10_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m10_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m10_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m11_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m11_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m12_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m12_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_ARREADY : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_ARVALID : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_AWREADY : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_AWVALID : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_BREADY : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_BVALID : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_RREADY : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_RVALID : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_WREADY : STD_LOGIC;
  signal m13_couplers_to_ps7_0_axi_periph_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal m13_couplers_to_ps7_0_axi_periph_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_ACLK_net : STD_LOGIC;
  signal ps7_0_axi_periph_ARESETN_net : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARLEN : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARLOCK : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWLEN : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWLOCK : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_BID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_RID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_RLAST : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_WID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_WLAST : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_to_s00_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_to_s00_couplers_WVALID : STD_LOGIC;
  signal s00_couplers_to_xbar_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_xbar_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_xbar_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_ARVALID : STD_LOGIC;
  signal s00_couplers_to_xbar_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_xbar_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal s00_couplers_to_xbar_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_AWVALID : STD_LOGIC;
  signal s00_couplers_to_xbar_BREADY : STD_LOGIC;
  signal s00_couplers_to_xbar_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_xbar_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_xbar_RREADY : STD_LOGIC;
  signal s00_couplers_to_xbar_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal s00_couplers_to_xbar_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s00_couplers_to_xbar_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal s00_couplers_to_xbar_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal s00_couplers_to_xbar_WVALID : STD_LOGIC;
  signal xbar_to_m00_couplers_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m00_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m00_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m00_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m00_couplers_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m00_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m00_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m00_couplers_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal xbar_to_m00_couplers_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m01_couplers_ARADDR : STD_LOGIC_VECTOR ( 63 downto 32 );
  signal xbar_to_m01_couplers_ARPROT : STD_LOGIC_VECTOR ( 5 downto 3 );
  signal xbar_to_m01_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m01_couplers_ARVALID : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m01_couplers_AWADDR : STD_LOGIC_VECTOR ( 63 downto 32 );
  signal xbar_to_m01_couplers_AWPROT : STD_LOGIC_VECTOR ( 5 downto 3 );
  signal xbar_to_m01_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m01_couplers_AWVALID : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m01_couplers_BREADY : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m01_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m01_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m01_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m01_couplers_RREADY : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m01_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m01_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m01_couplers_WDATA : STD_LOGIC_VECTOR ( 63 downto 32 );
  signal xbar_to_m01_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m01_couplers_WSTRB : STD_LOGIC_VECTOR ( 7 downto 4 );
  signal xbar_to_m01_couplers_WVALID : STD_LOGIC_VECTOR ( 1 to 1 );
  signal xbar_to_m02_couplers_ARADDR : STD_LOGIC_VECTOR ( 95 downto 64 );
  signal xbar_to_m02_couplers_ARPROT : STD_LOGIC_VECTOR ( 8 downto 6 );
  signal xbar_to_m02_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m02_couplers_ARVALID : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m02_couplers_AWADDR : STD_LOGIC_VECTOR ( 95 downto 64 );
  signal xbar_to_m02_couplers_AWPROT : STD_LOGIC_VECTOR ( 8 downto 6 );
  signal xbar_to_m02_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m02_couplers_AWVALID : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m02_couplers_BREADY : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m02_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m02_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m02_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m02_couplers_RREADY : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m02_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m02_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m02_couplers_WDATA : STD_LOGIC_VECTOR ( 95 downto 64 );
  signal xbar_to_m02_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m02_couplers_WSTRB : STD_LOGIC_VECTOR ( 11 downto 8 );
  signal xbar_to_m02_couplers_WVALID : STD_LOGIC_VECTOR ( 2 to 2 );
  signal xbar_to_m03_couplers_ARADDR : STD_LOGIC_VECTOR ( 127 downto 96 );
  signal xbar_to_m03_couplers_ARPROT : STD_LOGIC_VECTOR ( 11 downto 9 );
  signal xbar_to_m03_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m03_couplers_ARVALID : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m03_couplers_AWADDR : STD_LOGIC_VECTOR ( 127 downto 96 );
  signal xbar_to_m03_couplers_AWPROT : STD_LOGIC_VECTOR ( 11 downto 9 );
  signal xbar_to_m03_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m03_couplers_AWVALID : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m03_couplers_BREADY : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m03_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m03_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m03_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m03_couplers_RREADY : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m03_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m03_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m03_couplers_WDATA : STD_LOGIC_VECTOR ( 127 downto 96 );
  signal xbar_to_m03_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m03_couplers_WSTRB : STD_LOGIC_VECTOR ( 15 downto 12 );
  signal xbar_to_m03_couplers_WVALID : STD_LOGIC_VECTOR ( 3 to 3 );
  signal xbar_to_m04_couplers_ARADDR : STD_LOGIC_VECTOR ( 159 downto 128 );
  signal xbar_to_m04_couplers_ARPROT : STD_LOGIC_VECTOR ( 14 downto 12 );
  signal xbar_to_m04_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m04_couplers_ARVALID : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m04_couplers_AWADDR : STD_LOGIC_VECTOR ( 159 downto 128 );
  signal xbar_to_m04_couplers_AWPROT : STD_LOGIC_VECTOR ( 14 downto 12 );
  signal xbar_to_m04_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m04_couplers_AWVALID : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m04_couplers_BREADY : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m04_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m04_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m04_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m04_couplers_RREADY : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m04_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m04_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m04_couplers_WDATA : STD_LOGIC_VECTOR ( 159 downto 128 );
  signal xbar_to_m04_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m04_couplers_WSTRB : STD_LOGIC_VECTOR ( 19 downto 16 );
  signal xbar_to_m04_couplers_WVALID : STD_LOGIC_VECTOR ( 4 to 4 );
  signal xbar_to_m05_couplers_ARADDR : STD_LOGIC_VECTOR ( 191 downto 160 );
  signal xbar_to_m05_couplers_ARPROT : STD_LOGIC_VECTOR ( 17 downto 15 );
  signal xbar_to_m05_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m05_couplers_ARVALID : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m05_couplers_AWADDR : STD_LOGIC_VECTOR ( 191 downto 160 );
  signal xbar_to_m05_couplers_AWPROT : STD_LOGIC_VECTOR ( 17 downto 15 );
  signal xbar_to_m05_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m05_couplers_AWVALID : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m05_couplers_BREADY : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m05_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m05_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m05_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m05_couplers_RREADY : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m05_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m05_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m05_couplers_WDATA : STD_LOGIC_VECTOR ( 191 downto 160 );
  signal xbar_to_m05_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m05_couplers_WSTRB : STD_LOGIC_VECTOR ( 23 downto 20 );
  signal xbar_to_m05_couplers_WVALID : STD_LOGIC_VECTOR ( 5 to 5 );
  signal xbar_to_m06_couplers_ARADDR : STD_LOGIC_VECTOR ( 223 downto 192 );
  signal xbar_to_m06_couplers_ARPROT : STD_LOGIC_VECTOR ( 20 downto 18 );
  signal xbar_to_m06_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m06_couplers_ARVALID : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m06_couplers_AWADDR : STD_LOGIC_VECTOR ( 223 downto 192 );
  signal xbar_to_m06_couplers_AWPROT : STD_LOGIC_VECTOR ( 20 downto 18 );
  signal xbar_to_m06_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m06_couplers_AWVALID : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m06_couplers_BREADY : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m06_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m06_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m06_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m06_couplers_RREADY : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m06_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m06_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m06_couplers_WDATA : STD_LOGIC_VECTOR ( 223 downto 192 );
  signal xbar_to_m06_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m06_couplers_WSTRB : STD_LOGIC_VECTOR ( 27 downto 24 );
  signal xbar_to_m06_couplers_WVALID : STD_LOGIC_VECTOR ( 6 to 6 );
  signal xbar_to_m07_couplers_ARADDR : STD_LOGIC_VECTOR ( 255 downto 224 );
  signal xbar_to_m07_couplers_ARPROT : STD_LOGIC_VECTOR ( 23 downto 21 );
  signal xbar_to_m07_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_ARVALID : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m07_couplers_AWADDR : STD_LOGIC_VECTOR ( 255 downto 224 );
  signal xbar_to_m07_couplers_AWPROT : STD_LOGIC_VECTOR ( 23 downto 21 );
  signal xbar_to_m07_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_AWVALID : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m07_couplers_BREADY : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m07_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m07_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m07_couplers_RREADY : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m07_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m07_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_WDATA : STD_LOGIC_VECTOR ( 255 downto 224 );
  signal xbar_to_m07_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m07_couplers_WSTRB : STD_LOGIC_VECTOR ( 31 downto 28 );
  signal xbar_to_m07_couplers_WVALID : STD_LOGIC_VECTOR ( 7 to 7 );
  signal xbar_to_m08_couplers_ARADDR : STD_LOGIC_VECTOR ( 287 downto 256 );
  signal xbar_to_m08_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_ARVALID : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m08_couplers_AWADDR : STD_LOGIC_VECTOR ( 287 downto 256 );
  signal xbar_to_m08_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_AWVALID : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m08_couplers_BREADY : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m08_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m08_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m08_couplers_RREADY : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m08_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m08_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_WDATA : STD_LOGIC_VECTOR ( 287 downto 256 );
  signal xbar_to_m08_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m08_couplers_WSTRB : STD_LOGIC_VECTOR ( 35 downto 32 );
  signal xbar_to_m08_couplers_WVALID : STD_LOGIC_VECTOR ( 8 to 8 );
  signal xbar_to_m09_couplers_ARADDR : STD_LOGIC_VECTOR ( 319 downto 288 );
  signal xbar_to_m09_couplers_ARREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m09_couplers_ARVALID : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m09_couplers_AWADDR : STD_LOGIC_VECTOR ( 319 downto 288 );
  signal xbar_to_m09_couplers_AWREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m09_couplers_AWVALID : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m09_couplers_BREADY : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m09_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m09_couplers_BVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m09_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m09_couplers_RREADY : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m09_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m09_couplers_RVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m09_couplers_WDATA : STD_LOGIC_VECTOR ( 319 downto 288 );
  signal xbar_to_m09_couplers_WREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal xbar_to_m09_couplers_WSTRB : STD_LOGIC_VECTOR ( 39 downto 36 );
  signal xbar_to_m09_couplers_WVALID : STD_LOGIC_VECTOR ( 9 to 9 );
  signal xbar_to_m10_couplers_ARADDR : STD_LOGIC_VECTOR ( 351 downto 320 );
  signal xbar_to_m10_couplers_ARPROT : STD_LOGIC_VECTOR ( 32 downto 30 );
  signal xbar_to_m10_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m10_couplers_ARVALID : STD_LOGIC_VECTOR ( 10 to 10 );
  signal xbar_to_m10_couplers_AWADDR : STD_LOGIC_VECTOR ( 351 downto 320 );
  signal xbar_to_m10_couplers_AWPROT : STD_LOGIC_VECTOR ( 32 downto 30 );
  signal xbar_to_m10_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m10_couplers_AWVALID : STD_LOGIC_VECTOR ( 10 to 10 );
  signal xbar_to_m10_couplers_BREADY : STD_LOGIC_VECTOR ( 10 to 10 );
  signal xbar_to_m10_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m10_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m10_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m10_couplers_RREADY : STD_LOGIC_VECTOR ( 10 to 10 );
  signal xbar_to_m10_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m10_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m10_couplers_WDATA : STD_LOGIC_VECTOR ( 351 downto 320 );
  signal xbar_to_m10_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m10_couplers_WSTRB : STD_LOGIC_VECTOR ( 43 downto 40 );
  signal xbar_to_m10_couplers_WVALID : STD_LOGIC_VECTOR ( 10 to 10 );
  signal xbar_to_m11_couplers_ARADDR : STD_LOGIC_VECTOR ( 383 downto 352 );
  signal xbar_to_m11_couplers_ARPROT : STD_LOGIC_VECTOR ( 35 downto 33 );
  signal xbar_to_m11_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m11_couplers_ARVALID : STD_LOGIC_VECTOR ( 11 to 11 );
  signal xbar_to_m11_couplers_AWADDR : STD_LOGIC_VECTOR ( 383 downto 352 );
  signal xbar_to_m11_couplers_AWPROT : STD_LOGIC_VECTOR ( 35 downto 33 );
  signal xbar_to_m11_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m11_couplers_AWVALID : STD_LOGIC_VECTOR ( 11 to 11 );
  signal xbar_to_m11_couplers_BREADY : STD_LOGIC_VECTOR ( 11 to 11 );
  signal xbar_to_m11_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m11_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m11_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m11_couplers_RREADY : STD_LOGIC_VECTOR ( 11 to 11 );
  signal xbar_to_m11_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m11_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m11_couplers_WDATA : STD_LOGIC_VECTOR ( 383 downto 352 );
  signal xbar_to_m11_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m11_couplers_WSTRB : STD_LOGIC_VECTOR ( 47 downto 44 );
  signal xbar_to_m11_couplers_WVALID : STD_LOGIC_VECTOR ( 11 to 11 );
  signal xbar_to_m12_couplers_ARADDR : STD_LOGIC_VECTOR ( 415 downto 384 );
  signal xbar_to_m12_couplers_ARPROT : STD_LOGIC_VECTOR ( 38 downto 36 );
  signal xbar_to_m12_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m12_couplers_ARVALID : STD_LOGIC_VECTOR ( 12 to 12 );
  signal xbar_to_m12_couplers_AWADDR : STD_LOGIC_VECTOR ( 415 downto 384 );
  signal xbar_to_m12_couplers_AWPROT : STD_LOGIC_VECTOR ( 38 downto 36 );
  signal xbar_to_m12_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m12_couplers_AWVALID : STD_LOGIC_VECTOR ( 12 to 12 );
  signal xbar_to_m12_couplers_BREADY : STD_LOGIC_VECTOR ( 12 to 12 );
  signal xbar_to_m12_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m12_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m12_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m12_couplers_RREADY : STD_LOGIC_VECTOR ( 12 to 12 );
  signal xbar_to_m12_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m12_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m12_couplers_WDATA : STD_LOGIC_VECTOR ( 415 downto 384 );
  signal xbar_to_m12_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m12_couplers_WSTRB : STD_LOGIC_VECTOR ( 51 downto 48 );
  signal xbar_to_m12_couplers_WVALID : STD_LOGIC_VECTOR ( 12 to 12 );
  signal xbar_to_m13_couplers_ARADDR : STD_LOGIC_VECTOR ( 447 downto 416 );
  signal xbar_to_m13_couplers_ARPROT : STD_LOGIC_VECTOR ( 41 downto 39 );
  signal xbar_to_m13_couplers_ARREADY : STD_LOGIC;
  signal xbar_to_m13_couplers_ARVALID : STD_LOGIC_VECTOR ( 13 to 13 );
  signal xbar_to_m13_couplers_AWADDR : STD_LOGIC_VECTOR ( 447 downto 416 );
  signal xbar_to_m13_couplers_AWPROT : STD_LOGIC_VECTOR ( 41 downto 39 );
  signal xbar_to_m13_couplers_AWREADY : STD_LOGIC;
  signal xbar_to_m13_couplers_AWVALID : STD_LOGIC_VECTOR ( 13 to 13 );
  signal xbar_to_m13_couplers_BREADY : STD_LOGIC_VECTOR ( 13 to 13 );
  signal xbar_to_m13_couplers_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m13_couplers_BVALID : STD_LOGIC;
  signal xbar_to_m13_couplers_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal xbar_to_m13_couplers_RREADY : STD_LOGIC_VECTOR ( 13 to 13 );
  signal xbar_to_m13_couplers_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal xbar_to_m13_couplers_RVALID : STD_LOGIC;
  signal xbar_to_m13_couplers_WDATA : STD_LOGIC_VECTOR ( 447 downto 416 );
  signal xbar_to_m13_couplers_WREADY : STD_LOGIC;
  signal xbar_to_m13_couplers_WSTRB : STD_LOGIC_VECTOR ( 55 downto 52 );
  signal xbar_to_m13_couplers_WVALID : STD_LOGIC_VECTOR ( 13 to 13 );
  signal NLW_xbar_m_axi_arprot_UNCONNECTED : STD_LOGIC_VECTOR ( 29 downto 0 );
  signal NLW_xbar_m_axi_awprot_UNCONNECTED : STD_LOGIC_VECTOR ( 29 downto 0 );
begin
  M00_ACLK_1 <= M00_ACLK;
  M00_ARESETN_1 <= M00_ARESETN;
  M00_AXI_araddr(31 downto 0) <= m00_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M00_AXI_arvalid(0) <= m00_couplers_to_ps7_0_axi_periph_ARVALID(0);
  M00_AXI_awaddr(31 downto 0) <= m00_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M00_AXI_awvalid(0) <= m00_couplers_to_ps7_0_axi_periph_AWVALID(0);
  M00_AXI_bready(0) <= m00_couplers_to_ps7_0_axi_periph_BREADY(0);
  M00_AXI_rready(0) <= m00_couplers_to_ps7_0_axi_periph_RREADY(0);
  M00_AXI_wdata(31 downto 0) <= m00_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M00_AXI_wstrb(3 downto 0) <= m00_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M00_AXI_wvalid(0) <= m00_couplers_to_ps7_0_axi_periph_WVALID(0);
  M01_ACLK_1 <= M01_ACLK;
  M01_ARESETN_1 <= M01_ARESETN;
  M01_AXI_araddr(31 downto 0) <= m01_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M01_AXI_arprot(2 downto 0) <= m01_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M01_AXI_arvalid <= m01_couplers_to_ps7_0_axi_periph_ARVALID;
  M01_AXI_awaddr(31 downto 0) <= m01_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M01_AXI_awprot(2 downto 0) <= m01_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M01_AXI_awvalid <= m01_couplers_to_ps7_0_axi_periph_AWVALID;
  M01_AXI_bready <= m01_couplers_to_ps7_0_axi_periph_BREADY;
  M01_AXI_rready <= m01_couplers_to_ps7_0_axi_periph_RREADY;
  M01_AXI_wdata(31 downto 0) <= m01_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M01_AXI_wstrb(3 downto 0) <= m01_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M01_AXI_wvalid <= m01_couplers_to_ps7_0_axi_periph_WVALID;
  M02_ACLK_1 <= M02_ACLK;
  M02_ARESETN_1 <= M02_ARESETN;
  M02_AXI_araddr(31 downto 0) <= m02_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M02_AXI_arprot(2 downto 0) <= m02_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M02_AXI_arvalid <= m02_couplers_to_ps7_0_axi_periph_ARVALID;
  M02_AXI_awaddr(31 downto 0) <= m02_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M02_AXI_awprot(2 downto 0) <= m02_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M02_AXI_awvalid <= m02_couplers_to_ps7_0_axi_periph_AWVALID;
  M02_AXI_bready <= m02_couplers_to_ps7_0_axi_periph_BREADY;
  M02_AXI_rready <= m02_couplers_to_ps7_0_axi_periph_RREADY;
  M02_AXI_wdata(31 downto 0) <= m02_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M02_AXI_wstrb(3 downto 0) <= m02_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M02_AXI_wvalid <= m02_couplers_to_ps7_0_axi_periph_WVALID;
  M03_ACLK_1 <= M03_ACLK;
  M03_ARESETN_1 <= M03_ARESETN;
  M03_AXI_araddr(31 downto 0) <= m03_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M03_AXI_arprot(2 downto 0) <= m03_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M03_AXI_arvalid <= m03_couplers_to_ps7_0_axi_periph_ARVALID;
  M03_AXI_awaddr(31 downto 0) <= m03_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M03_AXI_awprot(2 downto 0) <= m03_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M03_AXI_awvalid <= m03_couplers_to_ps7_0_axi_periph_AWVALID;
  M03_AXI_bready <= m03_couplers_to_ps7_0_axi_periph_BREADY;
  M03_AXI_rready <= m03_couplers_to_ps7_0_axi_periph_RREADY;
  M03_AXI_wdata(31 downto 0) <= m03_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M03_AXI_wstrb(3 downto 0) <= m03_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M03_AXI_wvalid <= m03_couplers_to_ps7_0_axi_periph_WVALID;
  M04_ACLK_1 <= M04_ACLK;
  M04_ARESETN_1 <= M04_ARESETN;
  M04_AXI_araddr(31 downto 0) <= m04_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M04_AXI_arprot(2 downto 0) <= m04_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M04_AXI_arvalid <= m04_couplers_to_ps7_0_axi_periph_ARVALID;
  M04_AXI_awaddr(31 downto 0) <= m04_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M04_AXI_awprot(2 downto 0) <= m04_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M04_AXI_awvalid <= m04_couplers_to_ps7_0_axi_periph_AWVALID;
  M04_AXI_bready <= m04_couplers_to_ps7_0_axi_periph_BREADY;
  M04_AXI_rready <= m04_couplers_to_ps7_0_axi_periph_RREADY;
  M04_AXI_wdata(31 downto 0) <= m04_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M04_AXI_wstrb(3 downto 0) <= m04_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M04_AXI_wvalid <= m04_couplers_to_ps7_0_axi_periph_WVALID;
  M05_ACLK_1 <= M05_ACLK;
  M05_ARESETN_1 <= M05_ARESETN;
  M05_AXI_araddr(31 downto 0) <= m05_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M05_AXI_arprot(2 downto 0) <= m05_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M05_AXI_arvalid <= m05_couplers_to_ps7_0_axi_periph_ARVALID;
  M05_AXI_awaddr(31 downto 0) <= m05_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M05_AXI_awprot(2 downto 0) <= m05_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M05_AXI_awvalid <= m05_couplers_to_ps7_0_axi_periph_AWVALID;
  M05_AXI_bready <= m05_couplers_to_ps7_0_axi_periph_BREADY;
  M05_AXI_rready <= m05_couplers_to_ps7_0_axi_periph_RREADY;
  M05_AXI_wdata(31 downto 0) <= m05_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M05_AXI_wstrb(3 downto 0) <= m05_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M05_AXI_wvalid <= m05_couplers_to_ps7_0_axi_periph_WVALID;
  M06_ACLK_1 <= M06_ACLK;
  M06_ARESETN_1 <= M06_ARESETN;
  M06_AXI_araddr(31 downto 0) <= m06_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M06_AXI_arprot(2 downto 0) <= m06_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M06_AXI_arvalid <= m06_couplers_to_ps7_0_axi_periph_ARVALID;
  M06_AXI_awaddr(31 downto 0) <= m06_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M06_AXI_awprot(2 downto 0) <= m06_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M06_AXI_awvalid <= m06_couplers_to_ps7_0_axi_periph_AWVALID;
  M06_AXI_bready <= m06_couplers_to_ps7_0_axi_periph_BREADY;
  M06_AXI_rready <= m06_couplers_to_ps7_0_axi_periph_RREADY;
  M06_AXI_wdata(31 downto 0) <= m06_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M06_AXI_wstrb(3 downto 0) <= m06_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M06_AXI_wvalid <= m06_couplers_to_ps7_0_axi_periph_WVALID;
  M07_ACLK_1 <= M07_ACLK;
  M07_ARESETN_1 <= M07_ARESETN;
  M07_AXI_araddr(31 downto 0) <= m07_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M07_AXI_arprot(2 downto 0) <= m07_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M07_AXI_arvalid(0) <= m07_couplers_to_ps7_0_axi_periph_ARVALID(0);
  M07_AXI_awaddr(31 downto 0) <= m07_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M07_AXI_awprot(2 downto 0) <= m07_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M07_AXI_awvalid(0) <= m07_couplers_to_ps7_0_axi_periph_AWVALID(0);
  M07_AXI_bready(0) <= m07_couplers_to_ps7_0_axi_periph_BREADY(0);
  M07_AXI_rready(0) <= m07_couplers_to_ps7_0_axi_periph_RREADY(0);
  M07_AXI_wdata(31 downto 0) <= m07_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M07_AXI_wstrb(3 downto 0) <= m07_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M07_AXI_wvalid(0) <= m07_couplers_to_ps7_0_axi_periph_WVALID(0);
  M08_ACLK_1 <= M08_ACLK;
  M08_ARESETN_1 <= M08_ARESETN;
  M08_AXI_araddr(31 downto 0) <= m08_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M08_AXI_arvalid(0) <= m08_couplers_to_ps7_0_axi_periph_ARVALID(0);
  M08_AXI_awaddr(31 downto 0) <= m08_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M08_AXI_awvalid(0) <= m08_couplers_to_ps7_0_axi_periph_AWVALID(0);
  M08_AXI_bready(0) <= m08_couplers_to_ps7_0_axi_periph_BREADY(0);
  M08_AXI_rready(0) <= m08_couplers_to_ps7_0_axi_periph_RREADY(0);
  M08_AXI_wdata(31 downto 0) <= m08_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M08_AXI_wstrb(3 downto 0) <= m08_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M08_AXI_wvalid(0) <= m08_couplers_to_ps7_0_axi_periph_WVALID(0);
  M09_ACLK_1 <= M09_ACLK;
  M09_ARESETN_1 <= M09_ARESETN;
  M09_AXI_araddr(31 downto 0) <= m09_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M09_AXI_arvalid(0) <= m09_couplers_to_ps7_0_axi_periph_ARVALID(0);
  M09_AXI_awaddr(31 downto 0) <= m09_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M09_AXI_awvalid(0) <= m09_couplers_to_ps7_0_axi_periph_AWVALID(0);
  M09_AXI_bready(0) <= m09_couplers_to_ps7_0_axi_periph_BREADY(0);
  M09_AXI_rready(0) <= m09_couplers_to_ps7_0_axi_periph_RREADY(0);
  M09_AXI_wdata(31 downto 0) <= m09_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M09_AXI_wstrb(3 downto 0) <= m09_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M09_AXI_wvalid(0) <= m09_couplers_to_ps7_0_axi_periph_WVALID(0);
  M10_ACLK_1 <= M10_ACLK;
  M10_ARESETN_1 <= M10_ARESETN;
  M10_AXI_araddr(31 downto 0) <= m10_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M10_AXI_arprot(2 downto 0) <= m10_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M10_AXI_arvalid <= m10_couplers_to_ps7_0_axi_periph_ARVALID;
  M10_AXI_awaddr(31 downto 0) <= m10_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M10_AXI_awprot(2 downto 0) <= m10_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M10_AXI_awvalid <= m10_couplers_to_ps7_0_axi_periph_AWVALID;
  M10_AXI_bready <= m10_couplers_to_ps7_0_axi_periph_BREADY;
  M10_AXI_rready <= m10_couplers_to_ps7_0_axi_periph_RREADY;
  M10_AXI_wdata(31 downto 0) <= m10_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M10_AXI_wstrb(3 downto 0) <= m10_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M10_AXI_wvalid <= m10_couplers_to_ps7_0_axi_periph_WVALID;
  M11_ACLK_1 <= M11_ACLK;
  M11_ARESETN_1 <= M11_ARESETN;
  M11_AXI_araddr(31 downto 0) <= m11_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M11_AXI_arprot(2 downto 0) <= m11_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M11_AXI_arvalid <= m11_couplers_to_ps7_0_axi_periph_ARVALID;
  M11_AXI_awaddr(31 downto 0) <= m11_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M11_AXI_awprot(2 downto 0) <= m11_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M11_AXI_awvalid <= m11_couplers_to_ps7_0_axi_periph_AWVALID;
  M11_AXI_bready <= m11_couplers_to_ps7_0_axi_periph_BREADY;
  M11_AXI_rready <= m11_couplers_to_ps7_0_axi_periph_RREADY;
  M11_AXI_wdata(31 downto 0) <= m11_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M11_AXI_wstrb(3 downto 0) <= m11_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M11_AXI_wvalid <= m11_couplers_to_ps7_0_axi_periph_WVALID;
  M12_ACLK_1 <= M12_ACLK;
  M12_ARESETN_1 <= M12_ARESETN;
  M12_AXI_araddr(31 downto 0) <= m12_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M12_AXI_arprot(2 downto 0) <= m12_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M12_AXI_arvalid <= m12_couplers_to_ps7_0_axi_periph_ARVALID;
  M12_AXI_awaddr(31 downto 0) <= m12_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M12_AXI_awprot(2 downto 0) <= m12_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M12_AXI_awvalid <= m12_couplers_to_ps7_0_axi_periph_AWVALID;
  M12_AXI_bready <= m12_couplers_to_ps7_0_axi_periph_BREADY;
  M12_AXI_rready <= m12_couplers_to_ps7_0_axi_periph_RREADY;
  M12_AXI_wdata(31 downto 0) <= m12_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M12_AXI_wstrb(3 downto 0) <= m12_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M12_AXI_wvalid <= m12_couplers_to_ps7_0_axi_periph_WVALID;
  M13_ACLK_1 <= M13_ACLK;
  M13_ARESETN_1 <= M13_ARESETN;
  M13_AXI_araddr(31 downto 0) <= m13_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0);
  M13_AXI_arprot(2 downto 0) <= m13_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0);
  M13_AXI_arvalid <= m13_couplers_to_ps7_0_axi_periph_ARVALID;
  M13_AXI_awaddr(31 downto 0) <= m13_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0);
  M13_AXI_awprot(2 downto 0) <= m13_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0);
  M13_AXI_awvalid <= m13_couplers_to_ps7_0_axi_periph_AWVALID;
  M13_AXI_bready <= m13_couplers_to_ps7_0_axi_periph_BREADY;
  M13_AXI_rready <= m13_couplers_to_ps7_0_axi_periph_RREADY;
  M13_AXI_wdata(31 downto 0) <= m13_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0);
  M13_AXI_wstrb(3 downto 0) <= m13_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0);
  M13_AXI_wvalid <= m13_couplers_to_ps7_0_axi_periph_WVALID;
  S00_ACLK_1 <= S00_ACLK;
  S00_ARESETN_1 <= S00_ARESETN;
  S00_AXI_arready <= ps7_0_axi_periph_to_s00_couplers_ARREADY;
  S00_AXI_awready <= ps7_0_axi_periph_to_s00_couplers_AWREADY;
  S00_AXI_bid(11 downto 0) <= ps7_0_axi_periph_to_s00_couplers_BID(11 downto 0);
  S00_AXI_bresp(1 downto 0) <= ps7_0_axi_periph_to_s00_couplers_BRESP(1 downto 0);
  S00_AXI_bvalid <= ps7_0_axi_periph_to_s00_couplers_BVALID;
  S00_AXI_rdata(31 downto 0) <= ps7_0_axi_periph_to_s00_couplers_RDATA(31 downto 0);
  S00_AXI_rid(11 downto 0) <= ps7_0_axi_periph_to_s00_couplers_RID(11 downto 0);
  S00_AXI_rlast <= ps7_0_axi_periph_to_s00_couplers_RLAST;
  S00_AXI_rresp(1 downto 0) <= ps7_0_axi_periph_to_s00_couplers_RRESP(1 downto 0);
  S00_AXI_rvalid <= ps7_0_axi_periph_to_s00_couplers_RVALID;
  S00_AXI_wready <= ps7_0_axi_periph_to_s00_couplers_WREADY;
  m00_couplers_to_ps7_0_axi_periph_ARREADY(0) <= M00_AXI_arready(0);
  m00_couplers_to_ps7_0_axi_periph_AWREADY(0) <= M00_AXI_awready(0);
  m00_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M00_AXI_bresp(1 downto 0);
  m00_couplers_to_ps7_0_axi_periph_BVALID(0) <= M00_AXI_bvalid(0);
  m00_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M00_AXI_rdata(31 downto 0);
  m00_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M00_AXI_rresp(1 downto 0);
  m00_couplers_to_ps7_0_axi_periph_RVALID(0) <= M00_AXI_rvalid(0);
  m00_couplers_to_ps7_0_axi_periph_WREADY(0) <= M00_AXI_wready(0);
  m01_couplers_to_ps7_0_axi_periph_ARREADY <= M01_AXI_arready;
  m01_couplers_to_ps7_0_axi_periph_AWREADY <= M01_AXI_awready;
  m01_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M01_AXI_bresp(1 downto 0);
  m01_couplers_to_ps7_0_axi_periph_BVALID <= M01_AXI_bvalid;
  m01_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M01_AXI_rdata(31 downto 0);
  m01_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M01_AXI_rresp(1 downto 0);
  m01_couplers_to_ps7_0_axi_periph_RVALID <= M01_AXI_rvalid;
  m01_couplers_to_ps7_0_axi_periph_WREADY <= M01_AXI_wready;
  m02_couplers_to_ps7_0_axi_periph_ARREADY <= M02_AXI_arready;
  m02_couplers_to_ps7_0_axi_periph_AWREADY <= M02_AXI_awready;
  m02_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M02_AXI_bresp(1 downto 0);
  m02_couplers_to_ps7_0_axi_periph_BVALID <= M02_AXI_bvalid;
  m02_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M02_AXI_rdata(31 downto 0);
  m02_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M02_AXI_rresp(1 downto 0);
  m02_couplers_to_ps7_0_axi_periph_RVALID <= M02_AXI_rvalid;
  m02_couplers_to_ps7_0_axi_periph_WREADY <= M02_AXI_wready;
  m03_couplers_to_ps7_0_axi_periph_ARREADY <= M03_AXI_arready;
  m03_couplers_to_ps7_0_axi_periph_AWREADY <= M03_AXI_awready;
  m03_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M03_AXI_bresp(1 downto 0);
  m03_couplers_to_ps7_0_axi_periph_BVALID <= M03_AXI_bvalid;
  m03_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M03_AXI_rdata(31 downto 0);
  m03_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M03_AXI_rresp(1 downto 0);
  m03_couplers_to_ps7_0_axi_periph_RVALID <= M03_AXI_rvalid;
  m03_couplers_to_ps7_0_axi_periph_WREADY <= M03_AXI_wready;
  m04_couplers_to_ps7_0_axi_periph_ARREADY <= M04_AXI_arready;
  m04_couplers_to_ps7_0_axi_periph_AWREADY <= M04_AXI_awready;
  m04_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M04_AXI_bresp(1 downto 0);
  m04_couplers_to_ps7_0_axi_periph_BVALID <= M04_AXI_bvalid;
  m04_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M04_AXI_rdata(31 downto 0);
  m04_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M04_AXI_rresp(1 downto 0);
  m04_couplers_to_ps7_0_axi_periph_RVALID <= M04_AXI_rvalid;
  m04_couplers_to_ps7_0_axi_periph_WREADY <= M04_AXI_wready;
  m05_couplers_to_ps7_0_axi_periph_ARREADY <= M05_AXI_arready;
  m05_couplers_to_ps7_0_axi_periph_AWREADY <= M05_AXI_awready;
  m05_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M05_AXI_bresp(1 downto 0);
  m05_couplers_to_ps7_0_axi_periph_BVALID <= M05_AXI_bvalid;
  m05_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M05_AXI_rdata(31 downto 0);
  m05_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M05_AXI_rresp(1 downto 0);
  m05_couplers_to_ps7_0_axi_periph_RVALID <= M05_AXI_rvalid;
  m05_couplers_to_ps7_0_axi_periph_WREADY <= M05_AXI_wready;
  m06_couplers_to_ps7_0_axi_periph_ARREADY <= M06_AXI_arready;
  m06_couplers_to_ps7_0_axi_periph_AWREADY <= M06_AXI_awready;
  m06_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M06_AXI_bresp(1 downto 0);
  m06_couplers_to_ps7_0_axi_periph_BVALID <= M06_AXI_bvalid;
  m06_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M06_AXI_rdata(31 downto 0);
  m06_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M06_AXI_rresp(1 downto 0);
  m06_couplers_to_ps7_0_axi_periph_RVALID <= M06_AXI_rvalid;
  m06_couplers_to_ps7_0_axi_periph_WREADY <= M06_AXI_wready;
  m07_couplers_to_ps7_0_axi_periph_ARREADY(0) <= M07_AXI_arready(0);
  m07_couplers_to_ps7_0_axi_periph_AWREADY(0) <= M07_AXI_awready(0);
  m07_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M07_AXI_bresp(1 downto 0);
  m07_couplers_to_ps7_0_axi_periph_BVALID(0) <= M07_AXI_bvalid(0);
  m07_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M07_AXI_rdata(31 downto 0);
  m07_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M07_AXI_rresp(1 downto 0);
  m07_couplers_to_ps7_0_axi_periph_RVALID(0) <= M07_AXI_rvalid(0);
  m07_couplers_to_ps7_0_axi_periph_WREADY(0) <= M07_AXI_wready(0);
  m08_couplers_to_ps7_0_axi_periph_ARREADY(0) <= M08_AXI_arready(0);
  m08_couplers_to_ps7_0_axi_periph_AWREADY(0) <= M08_AXI_awready(0);
  m08_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M08_AXI_bresp(1 downto 0);
  m08_couplers_to_ps7_0_axi_periph_BVALID(0) <= M08_AXI_bvalid(0);
  m08_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M08_AXI_rdata(31 downto 0);
  m08_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M08_AXI_rresp(1 downto 0);
  m08_couplers_to_ps7_0_axi_periph_RVALID(0) <= M08_AXI_rvalid(0);
  m08_couplers_to_ps7_0_axi_periph_WREADY(0) <= M08_AXI_wready(0);
  m09_couplers_to_ps7_0_axi_periph_ARREADY(0) <= M09_AXI_arready(0);
  m09_couplers_to_ps7_0_axi_periph_AWREADY(0) <= M09_AXI_awready(0);
  m09_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M09_AXI_bresp(1 downto 0);
  m09_couplers_to_ps7_0_axi_periph_BVALID(0) <= M09_AXI_bvalid(0);
  m09_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M09_AXI_rdata(31 downto 0);
  m09_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M09_AXI_rresp(1 downto 0);
  m09_couplers_to_ps7_0_axi_periph_RVALID(0) <= M09_AXI_rvalid(0);
  m09_couplers_to_ps7_0_axi_periph_WREADY(0) <= M09_AXI_wready(0);
  m10_couplers_to_ps7_0_axi_periph_ARREADY <= M10_AXI_arready;
  m10_couplers_to_ps7_0_axi_periph_AWREADY <= M10_AXI_awready;
  m10_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M10_AXI_bresp(1 downto 0);
  m10_couplers_to_ps7_0_axi_periph_BVALID <= M10_AXI_bvalid;
  m10_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M10_AXI_rdata(31 downto 0);
  m10_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M10_AXI_rresp(1 downto 0);
  m10_couplers_to_ps7_0_axi_periph_RVALID <= M10_AXI_rvalid;
  m10_couplers_to_ps7_0_axi_periph_WREADY <= M10_AXI_wready;
  m11_couplers_to_ps7_0_axi_periph_ARREADY <= M11_AXI_arready;
  m11_couplers_to_ps7_0_axi_periph_AWREADY <= M11_AXI_awready;
  m11_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M11_AXI_bresp(1 downto 0);
  m11_couplers_to_ps7_0_axi_periph_BVALID <= M11_AXI_bvalid;
  m11_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M11_AXI_rdata(31 downto 0);
  m11_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M11_AXI_rresp(1 downto 0);
  m11_couplers_to_ps7_0_axi_periph_RVALID <= M11_AXI_rvalid;
  m11_couplers_to_ps7_0_axi_periph_WREADY <= M11_AXI_wready;
  m12_couplers_to_ps7_0_axi_periph_ARREADY <= M12_AXI_arready;
  m12_couplers_to_ps7_0_axi_periph_AWREADY <= M12_AXI_awready;
  m12_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M12_AXI_bresp(1 downto 0);
  m12_couplers_to_ps7_0_axi_periph_BVALID <= M12_AXI_bvalid;
  m12_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M12_AXI_rdata(31 downto 0);
  m12_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M12_AXI_rresp(1 downto 0);
  m12_couplers_to_ps7_0_axi_periph_RVALID <= M12_AXI_rvalid;
  m12_couplers_to_ps7_0_axi_periph_WREADY <= M12_AXI_wready;
  m13_couplers_to_ps7_0_axi_periph_ARREADY <= M13_AXI_arready;
  m13_couplers_to_ps7_0_axi_periph_AWREADY <= M13_AXI_awready;
  m13_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0) <= M13_AXI_bresp(1 downto 0);
  m13_couplers_to_ps7_0_axi_periph_BVALID <= M13_AXI_bvalid;
  m13_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0) <= M13_AXI_rdata(31 downto 0);
  m13_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0) <= M13_AXI_rresp(1 downto 0);
  m13_couplers_to_ps7_0_axi_periph_RVALID <= M13_AXI_rvalid;
  m13_couplers_to_ps7_0_axi_periph_WREADY <= M13_AXI_wready;
  ps7_0_axi_periph_ACLK_net <= ACLK;
  ps7_0_axi_periph_ARESETN_net <= ARESETN;
  ps7_0_axi_periph_to_s00_couplers_ARADDR(31 downto 0) <= S00_AXI_araddr(31 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARBURST(1 downto 0) <= S00_AXI_arburst(1 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARCACHE(3 downto 0) <= S00_AXI_arcache(3 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARID(11 downto 0) <= S00_AXI_arid(11 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARLEN(3 downto 0) <= S00_AXI_arlen(3 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARLOCK(1 downto 0) <= S00_AXI_arlock(1 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARPROT(2 downto 0) <= S00_AXI_arprot(2 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARQOS(3 downto 0) <= S00_AXI_arqos(3 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARSIZE(2 downto 0) <= S00_AXI_arsize(2 downto 0);
  ps7_0_axi_periph_to_s00_couplers_ARVALID <= S00_AXI_arvalid;
  ps7_0_axi_periph_to_s00_couplers_AWADDR(31 downto 0) <= S00_AXI_awaddr(31 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWBURST(1 downto 0) <= S00_AXI_awburst(1 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWCACHE(3 downto 0) <= S00_AXI_awcache(3 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWID(11 downto 0) <= S00_AXI_awid(11 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWLEN(3 downto 0) <= S00_AXI_awlen(3 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWLOCK(1 downto 0) <= S00_AXI_awlock(1 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWPROT(2 downto 0) <= S00_AXI_awprot(2 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWQOS(3 downto 0) <= S00_AXI_awqos(3 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWSIZE(2 downto 0) <= S00_AXI_awsize(2 downto 0);
  ps7_0_axi_periph_to_s00_couplers_AWVALID <= S00_AXI_awvalid;
  ps7_0_axi_periph_to_s00_couplers_BREADY <= S00_AXI_bready;
  ps7_0_axi_periph_to_s00_couplers_RREADY <= S00_AXI_rready;
  ps7_0_axi_periph_to_s00_couplers_WDATA(31 downto 0) <= S00_AXI_wdata(31 downto 0);
  ps7_0_axi_periph_to_s00_couplers_WID(11 downto 0) <= S00_AXI_wid(11 downto 0);
  ps7_0_axi_periph_to_s00_couplers_WLAST <= S00_AXI_wlast;
  ps7_0_axi_periph_to_s00_couplers_WSTRB(3 downto 0) <= S00_AXI_wstrb(3 downto 0);
  ps7_0_axi_periph_to_s00_couplers_WVALID <= S00_AXI_wvalid;
m00_couplers: entity work.m00_couplers_imp_12W17VD
     port map (
      M_ACLK => M00_ACLK_1,
      M_ARESETN => M00_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m00_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arready(0) => m00_couplers_to_ps7_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m00_couplers_to_ps7_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(31 downto 0) => m00_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awready(0) => m00_couplers_to_ps7_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m00_couplers_to_ps7_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m00_couplers_to_ps7_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m00_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m00_couplers_to_ps7_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m00_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m00_couplers_to_ps7_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m00_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m00_couplers_to_ps7_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m00_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m00_couplers_to_ps7_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m00_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m00_couplers_to_ps7_0_axi_periph_WVALID(0),
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m00_couplers_ARADDR(31 downto 0),
      S_AXI_arready(0) => xbar_to_m00_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m00_couplers_ARVALID(0),
      S_AXI_awaddr(31 downto 0) => xbar_to_m00_couplers_AWADDR(31 downto 0),
      S_AXI_awready(0) => xbar_to_m00_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m00_couplers_AWVALID(0),
      S_AXI_bready(0) => xbar_to_m00_couplers_BREADY(0),
      S_AXI_bresp(1 downto 0) => xbar_to_m00_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m00_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m00_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m00_couplers_RREADY(0),
      S_AXI_rresp(1 downto 0) => xbar_to_m00_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m00_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m00_couplers_WDATA(31 downto 0),
      S_AXI_wready(0) => xbar_to_m00_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m00_couplers_WSTRB(3 downto 0),
      S_AXI_wvalid(0) => xbar_to_m00_couplers_WVALID(0)
    );
m01_couplers: entity work.m01_couplers_imp_1ASS0TR
     port map (
      M_ACLK => M01_ACLK_1,
      M_ARESETN => M01_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m01_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m01_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m01_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m01_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m01_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m01_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m01_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m01_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m01_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m01_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m01_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m01_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m01_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m01_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m01_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m01_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m01_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m01_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m01_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m01_couplers_ARADDR(63 downto 32),
      S_AXI_arprot(2 downto 0) => xbar_to_m01_couplers_ARPROT(5 downto 3),
      S_AXI_arready => xbar_to_m01_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m01_couplers_ARVALID(1),
      S_AXI_awaddr(31 downto 0) => xbar_to_m01_couplers_AWADDR(63 downto 32),
      S_AXI_awprot(2 downto 0) => xbar_to_m01_couplers_AWPROT(5 downto 3),
      S_AXI_awready => xbar_to_m01_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m01_couplers_AWVALID(1),
      S_AXI_bready => xbar_to_m01_couplers_BREADY(1),
      S_AXI_bresp(1 downto 0) => xbar_to_m01_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m01_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m01_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m01_couplers_RREADY(1),
      S_AXI_rresp(1 downto 0) => xbar_to_m01_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m01_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m01_couplers_WDATA(63 downto 32),
      S_AXI_wready => xbar_to_m01_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m01_couplers_WSTRB(7 downto 4),
      S_AXI_wvalid => xbar_to_m01_couplers_WVALID(1)
    );
m02_couplers: entity work.m02_couplers_imp_1IPKK8L
     port map (
      M_ACLK => M02_ACLK_1,
      M_ARESETN => M02_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m02_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m02_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m02_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m02_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m02_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m02_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m02_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m02_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m02_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m02_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m02_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m02_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m02_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m02_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m02_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m02_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m02_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m02_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m02_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m02_couplers_ARADDR(95 downto 64),
      S_AXI_arprot(2 downto 0) => xbar_to_m02_couplers_ARPROT(8 downto 6),
      S_AXI_arready => xbar_to_m02_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m02_couplers_ARVALID(2),
      S_AXI_awaddr(31 downto 0) => xbar_to_m02_couplers_AWADDR(95 downto 64),
      S_AXI_awprot(2 downto 0) => xbar_to_m02_couplers_AWPROT(8 downto 6),
      S_AXI_awready => xbar_to_m02_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m02_couplers_AWVALID(2),
      S_AXI_bready => xbar_to_m02_couplers_BREADY(2),
      S_AXI_bresp(1 downto 0) => xbar_to_m02_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m02_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m02_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m02_couplers_RREADY(2),
      S_AXI_rresp(1 downto 0) => xbar_to_m02_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m02_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m02_couplers_WDATA(95 downto 64),
      S_AXI_wready => xbar_to_m02_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m02_couplers_WSTRB(11 downto 8),
      S_AXI_wvalid => xbar_to_m02_couplers_WVALID(2)
    );
m03_couplers: entity work.m03_couplers_imp_1QMBD4Z
     port map (
      M_ACLK => M03_ACLK_1,
      M_ARESETN => M03_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m03_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m03_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m03_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m03_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m03_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m03_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m03_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m03_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m03_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m03_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m03_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m03_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m03_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m03_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m03_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m03_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m03_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m03_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m03_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m03_couplers_ARADDR(127 downto 96),
      S_AXI_arprot(2 downto 0) => xbar_to_m03_couplers_ARPROT(11 downto 9),
      S_AXI_arready => xbar_to_m03_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m03_couplers_ARVALID(3),
      S_AXI_awaddr(31 downto 0) => xbar_to_m03_couplers_AWADDR(127 downto 96),
      S_AXI_awprot(2 downto 0) => xbar_to_m03_couplers_AWPROT(11 downto 9),
      S_AXI_awready => xbar_to_m03_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m03_couplers_AWVALID(3),
      S_AXI_bready => xbar_to_m03_couplers_BREADY(3),
      S_AXI_bresp(1 downto 0) => xbar_to_m03_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m03_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m03_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m03_couplers_RREADY(3),
      S_AXI_rresp(1 downto 0) => xbar_to_m03_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m03_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m03_couplers_WDATA(127 downto 96),
      S_AXI_wready => xbar_to_m03_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m03_couplers_WSTRB(15 downto 12),
      S_AXI_wvalid => xbar_to_m03_couplers_WVALID(3)
    );
m04_couplers: entity work.m04_couplers_imp_8CWVCX
     port map (
      M_ACLK => M04_ACLK_1,
      M_ARESETN => M04_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m04_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m04_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m04_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m04_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m04_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m04_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m04_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m04_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m04_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m04_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m04_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m04_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m04_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m04_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m04_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m04_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m04_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m04_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m04_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m04_couplers_ARADDR(159 downto 128),
      S_AXI_arprot(2 downto 0) => xbar_to_m04_couplers_ARPROT(14 downto 12),
      S_AXI_arready => xbar_to_m04_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m04_couplers_ARVALID(4),
      S_AXI_awaddr(31 downto 0) => xbar_to_m04_couplers_AWADDR(159 downto 128),
      S_AXI_awprot(2 downto 0) => xbar_to_m04_couplers_AWPROT(14 downto 12),
      S_AXI_awready => xbar_to_m04_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m04_couplers_AWVALID(4),
      S_AXI_bready => xbar_to_m04_couplers_BREADY(4),
      S_AXI_bresp(1 downto 0) => xbar_to_m04_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m04_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m04_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m04_couplers_RREADY(4),
      S_AXI_rresp(1 downto 0) => xbar_to_m04_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m04_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m04_couplers_WDATA(159 downto 128),
      S_AXI_wready => xbar_to_m04_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m04_couplers_WSTRB(19 downto 16),
      S_AXI_wvalid => xbar_to_m04_couplers_WVALID(4)
    );
m05_couplers: entity work.m05_couplers_imp_G9ODMF
     port map (
      M_ACLK => M05_ACLK_1,
      M_ARESETN => M05_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m05_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m05_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m05_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m05_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m05_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m05_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m05_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m05_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m05_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m05_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m05_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m05_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m05_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m05_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m05_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m05_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m05_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m05_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m05_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m05_couplers_ARADDR(191 downto 160),
      S_AXI_arprot(2 downto 0) => xbar_to_m05_couplers_ARPROT(17 downto 15),
      S_AXI_arready => xbar_to_m05_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m05_couplers_ARVALID(5),
      S_AXI_awaddr(31 downto 0) => xbar_to_m05_couplers_AWADDR(191 downto 160),
      S_AXI_awprot(2 downto 0) => xbar_to_m05_couplers_AWPROT(17 downto 15),
      S_AXI_awready => xbar_to_m05_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m05_couplers_AWVALID(5),
      S_AXI_bready => xbar_to_m05_couplers_BREADY(5),
      S_AXI_bresp(1 downto 0) => xbar_to_m05_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m05_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m05_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m05_couplers_RREADY(5),
      S_AXI_rresp(1 downto 0) => xbar_to_m05_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m05_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m05_couplers_WDATA(191 downto 160),
      S_AXI_wready => xbar_to_m05_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m05_couplers_WSTRB(23 downto 20),
      S_AXI_wvalid => xbar_to_m05_couplers_WVALID(5)
    );
m06_couplers: entity work.m06_couplers_imp_O6G7N1
     port map (
      M_ACLK => M06_ACLK_1,
      M_ARESETN => M06_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m06_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m06_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m06_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m06_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m06_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m06_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m06_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m06_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m06_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m06_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m06_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m06_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m06_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m06_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m06_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m06_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m06_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m06_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m06_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m06_couplers_ARADDR(223 downto 192),
      S_AXI_arprot(2 downto 0) => xbar_to_m06_couplers_ARPROT(20 downto 18),
      S_AXI_arready => xbar_to_m06_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m06_couplers_ARVALID(6),
      S_AXI_awaddr(31 downto 0) => xbar_to_m06_couplers_AWADDR(223 downto 192),
      S_AXI_awprot(2 downto 0) => xbar_to_m06_couplers_AWPROT(20 downto 18),
      S_AXI_awready => xbar_to_m06_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m06_couplers_AWVALID(6),
      S_AXI_bready => xbar_to_m06_couplers_BREADY(6),
      S_AXI_bresp(1 downto 0) => xbar_to_m06_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m06_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m06_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m06_couplers_RREADY(6),
      S_AXI_rresp(1 downto 0) => xbar_to_m06_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m06_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m06_couplers_WDATA(223 downto 192),
      S_AXI_wready => xbar_to_m06_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m06_couplers_WSTRB(27 downto 24),
      S_AXI_wvalid => xbar_to_m06_couplers_WVALID(6)
    );
m07_couplers: entity work.m07_couplers_imp_W37PUJ
     port map (
      M_ACLK => M07_ACLK_1,
      M_ARESETN => M07_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m07_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m07_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready(0) => m07_couplers_to_ps7_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m07_couplers_to_ps7_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(31 downto 0) => m07_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m07_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready(0) => m07_couplers_to_ps7_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m07_couplers_to_ps7_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m07_couplers_to_ps7_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m07_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m07_couplers_to_ps7_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m07_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m07_couplers_to_ps7_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m07_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m07_couplers_to_ps7_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m07_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m07_couplers_to_ps7_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m07_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m07_couplers_to_ps7_0_axi_periph_WVALID(0),
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m07_couplers_ARADDR(255 downto 224),
      S_AXI_arprot(2 downto 0) => xbar_to_m07_couplers_ARPROT(23 downto 21),
      S_AXI_arready(0) => xbar_to_m07_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m07_couplers_ARVALID(7),
      S_AXI_awaddr(31 downto 0) => xbar_to_m07_couplers_AWADDR(255 downto 224),
      S_AXI_awprot(2 downto 0) => xbar_to_m07_couplers_AWPROT(23 downto 21),
      S_AXI_awready(0) => xbar_to_m07_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m07_couplers_AWVALID(7),
      S_AXI_bready(0) => xbar_to_m07_couplers_BREADY(7),
      S_AXI_bresp(1 downto 0) => xbar_to_m07_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m07_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m07_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m07_couplers_RREADY(7),
      S_AXI_rresp(1 downto 0) => xbar_to_m07_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m07_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m07_couplers_WDATA(255 downto 224),
      S_AXI_wready(0) => xbar_to_m07_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m07_couplers_WSTRB(31 downto 28),
      S_AXI_wvalid(0) => xbar_to_m07_couplers_WVALID(7)
    );
m08_couplers: entity work.m08_couplers_imp_VZMG2W
     port map (
      M_ACLK => M08_ACLK_1,
      M_ARESETN => M08_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m08_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arready(0) => m08_couplers_to_ps7_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m08_couplers_to_ps7_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(31 downto 0) => m08_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awready(0) => m08_couplers_to_ps7_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m08_couplers_to_ps7_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m08_couplers_to_ps7_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m08_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m08_couplers_to_ps7_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m08_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m08_couplers_to_ps7_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m08_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m08_couplers_to_ps7_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m08_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m08_couplers_to_ps7_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m08_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m08_couplers_to_ps7_0_axi_periph_WVALID(0),
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m08_couplers_ARADDR(287 downto 256),
      S_AXI_arready(0) => xbar_to_m08_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m08_couplers_ARVALID(8),
      S_AXI_awaddr(31 downto 0) => xbar_to_m08_couplers_AWADDR(287 downto 256),
      S_AXI_awready(0) => xbar_to_m08_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m08_couplers_AWVALID(8),
      S_AXI_bready(0) => xbar_to_m08_couplers_BREADY(8),
      S_AXI_bresp(1 downto 0) => xbar_to_m08_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m08_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m08_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m08_couplers_RREADY(8),
      S_AXI_rresp(1 downto 0) => xbar_to_m08_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m08_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m08_couplers_WDATA(287 downto 256),
      S_AXI_wready(0) => xbar_to_m08_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m08_couplers_WSTRB(35 downto 32),
      S_AXI_wvalid(0) => xbar_to_m08_couplers_WVALID(8)
    );
m09_couplers: entity work.m09_couplers_imp_OCUCWU
     port map (
      M_ACLK => M09_ACLK_1,
      M_ARESETN => M09_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m09_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arready(0) => m09_couplers_to_ps7_0_axi_periph_ARREADY(0),
      M_AXI_arvalid(0) => m09_couplers_to_ps7_0_axi_periph_ARVALID(0),
      M_AXI_awaddr(31 downto 0) => m09_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awready(0) => m09_couplers_to_ps7_0_axi_periph_AWREADY(0),
      M_AXI_awvalid(0) => m09_couplers_to_ps7_0_axi_periph_AWVALID(0),
      M_AXI_bready(0) => m09_couplers_to_ps7_0_axi_periph_BREADY(0),
      M_AXI_bresp(1 downto 0) => m09_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid(0) => m09_couplers_to_ps7_0_axi_periph_BVALID(0),
      M_AXI_rdata(31 downto 0) => m09_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready(0) => m09_couplers_to_ps7_0_axi_periph_RREADY(0),
      M_AXI_rresp(1 downto 0) => m09_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid(0) => m09_couplers_to_ps7_0_axi_periph_RVALID(0),
      M_AXI_wdata(31 downto 0) => m09_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready(0) => m09_couplers_to_ps7_0_axi_periph_WREADY(0),
      M_AXI_wstrb(3 downto 0) => m09_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid(0) => m09_couplers_to_ps7_0_axi_periph_WVALID(0),
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m09_couplers_ARADDR(319 downto 288),
      S_AXI_arready(0) => xbar_to_m09_couplers_ARREADY(0),
      S_AXI_arvalid(0) => xbar_to_m09_couplers_ARVALID(9),
      S_AXI_awaddr(31 downto 0) => xbar_to_m09_couplers_AWADDR(319 downto 288),
      S_AXI_awready(0) => xbar_to_m09_couplers_AWREADY(0),
      S_AXI_awvalid(0) => xbar_to_m09_couplers_AWVALID(9),
      S_AXI_bready(0) => xbar_to_m09_couplers_BREADY(9),
      S_AXI_bresp(1 downto 0) => xbar_to_m09_couplers_BRESP(1 downto 0),
      S_AXI_bvalid(0) => xbar_to_m09_couplers_BVALID(0),
      S_AXI_rdata(31 downto 0) => xbar_to_m09_couplers_RDATA(31 downto 0),
      S_AXI_rready(0) => xbar_to_m09_couplers_RREADY(9),
      S_AXI_rresp(1 downto 0) => xbar_to_m09_couplers_RRESP(1 downto 0),
      S_AXI_rvalid(0) => xbar_to_m09_couplers_RVALID(0),
      S_AXI_wdata(31 downto 0) => xbar_to_m09_couplers_WDATA(319 downto 288),
      S_AXI_wready(0) => xbar_to_m09_couplers_WREADY(0),
      S_AXI_wstrb(3 downto 0) => xbar_to_m09_couplers_WSTRB(39 downto 36),
      S_AXI_wvalid(0) => xbar_to_m09_couplers_WVALID(9)
    );
m10_couplers: entity work.m10_couplers_imp_ISE7KH
     port map (
      M_ACLK => M10_ACLK_1,
      M_ARESETN => M10_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m10_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m10_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m10_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m10_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m10_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m10_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m10_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m10_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m10_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m10_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m10_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m10_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m10_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m10_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m10_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m10_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m10_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m10_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m10_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m10_couplers_ARADDR(351 downto 320),
      S_AXI_arprot(2 downto 0) => xbar_to_m10_couplers_ARPROT(32 downto 30),
      S_AXI_arready => xbar_to_m10_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m10_couplers_ARVALID(10),
      S_AXI_awaddr(31 downto 0) => xbar_to_m10_couplers_AWADDR(351 downto 320),
      S_AXI_awprot(2 downto 0) => xbar_to_m10_couplers_AWPROT(32 downto 30),
      S_AXI_awready => xbar_to_m10_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m10_couplers_AWVALID(10),
      S_AXI_bready => xbar_to_m10_couplers_BREADY(10),
      S_AXI_bresp(1 downto 0) => xbar_to_m10_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m10_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m10_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m10_couplers_RREADY(10),
      S_AXI_rresp(1 downto 0) => xbar_to_m10_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m10_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m10_couplers_WDATA(351 downto 320),
      S_AXI_wready => xbar_to_m10_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m10_couplers_WSTRB(43 downto 40),
      S_AXI_wvalid => xbar_to_m10_couplers_WVALID(10)
    );
m11_couplers: entity work.m11_couplers_imp_SMWPUV
     port map (
      M_ACLK => M11_ACLK_1,
      M_ARESETN => M11_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m11_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m11_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m11_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m11_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m11_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m11_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m11_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m11_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m11_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m11_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m11_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m11_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m11_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m11_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m11_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m11_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m11_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m11_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m11_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m11_couplers_ARADDR(383 downto 352),
      S_AXI_arprot(2 downto 0) => xbar_to_m11_couplers_ARPROT(35 downto 33),
      S_AXI_arready => xbar_to_m11_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m11_couplers_ARVALID(11),
      S_AXI_awaddr(31 downto 0) => xbar_to_m11_couplers_AWADDR(383 downto 352),
      S_AXI_awprot(2 downto 0) => xbar_to_m11_couplers_AWPROT(35 downto 33),
      S_AXI_awready => xbar_to_m11_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m11_couplers_AWVALID(11),
      S_AXI_bready => xbar_to_m11_couplers_BREADY(11),
      S_AXI_bresp(1 downto 0) => xbar_to_m11_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m11_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m11_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m11_couplers_RREADY(11),
      S_AXI_rresp(1 downto 0) => xbar_to_m11_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m11_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m11_couplers_WDATA(383 downto 352),
      S_AXI_wready => xbar_to_m11_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m11_couplers_WSTRB(47 downto 44),
      S_AXI_wvalid => xbar_to_m11_couplers_WVALID(11)
    );
m12_couplers: entity work.m12_couplers_imp_2YWMGT
     port map (
      M_ACLK => M12_ACLK_1,
      M_ARESETN => M12_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m12_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m12_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m12_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m12_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m12_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m12_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m12_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m12_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m12_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m12_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m12_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m12_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m12_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m12_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m12_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m12_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m12_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m12_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m12_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m12_couplers_ARADDR(415 downto 384),
      S_AXI_arprot(2 downto 0) => xbar_to_m12_couplers_ARPROT(38 downto 36),
      S_AXI_arready => xbar_to_m12_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m12_couplers_ARVALID(12),
      S_AXI_awaddr(31 downto 0) => xbar_to_m12_couplers_AWADDR(415 downto 384),
      S_AXI_awprot(2 downto 0) => xbar_to_m12_couplers_AWPROT(38 downto 36),
      S_AXI_awready => xbar_to_m12_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m12_couplers_AWVALID(12),
      S_AXI_bready => xbar_to_m12_couplers_BREADY(12),
      S_AXI_bresp(1 downto 0) => xbar_to_m12_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m12_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m12_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m12_couplers_RREADY(12),
      S_AXI_rresp(1 downto 0) => xbar_to_m12_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m12_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m12_couplers_WDATA(415 downto 384),
      S_AXI_wready => xbar_to_m12_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m12_couplers_WSTRB(51 downto 48),
      S_AXI_wvalid => xbar_to_m12_couplers_WVALID(12)
    );
m13_couplers: entity work.m13_couplers_imp_CTF4P7
     port map (
      M_ACLK => M13_ACLK_1,
      M_ARESETN => M13_ARESETN_1,
      M_AXI_araddr(31 downto 0) => m13_couplers_to_ps7_0_axi_periph_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => m13_couplers_to_ps7_0_axi_periph_ARPROT(2 downto 0),
      M_AXI_arready => m13_couplers_to_ps7_0_axi_periph_ARREADY,
      M_AXI_arvalid => m13_couplers_to_ps7_0_axi_periph_ARVALID,
      M_AXI_awaddr(31 downto 0) => m13_couplers_to_ps7_0_axi_periph_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => m13_couplers_to_ps7_0_axi_periph_AWPROT(2 downto 0),
      M_AXI_awready => m13_couplers_to_ps7_0_axi_periph_AWREADY,
      M_AXI_awvalid => m13_couplers_to_ps7_0_axi_periph_AWVALID,
      M_AXI_bready => m13_couplers_to_ps7_0_axi_periph_BREADY,
      M_AXI_bresp(1 downto 0) => m13_couplers_to_ps7_0_axi_periph_BRESP(1 downto 0),
      M_AXI_bvalid => m13_couplers_to_ps7_0_axi_periph_BVALID,
      M_AXI_rdata(31 downto 0) => m13_couplers_to_ps7_0_axi_periph_RDATA(31 downto 0),
      M_AXI_rready => m13_couplers_to_ps7_0_axi_periph_RREADY,
      M_AXI_rresp(1 downto 0) => m13_couplers_to_ps7_0_axi_periph_RRESP(1 downto 0),
      M_AXI_rvalid => m13_couplers_to_ps7_0_axi_periph_RVALID,
      M_AXI_wdata(31 downto 0) => m13_couplers_to_ps7_0_axi_periph_WDATA(31 downto 0),
      M_AXI_wready => m13_couplers_to_ps7_0_axi_periph_WREADY,
      M_AXI_wstrb(3 downto 0) => m13_couplers_to_ps7_0_axi_periph_WSTRB(3 downto 0),
      M_AXI_wvalid => m13_couplers_to_ps7_0_axi_periph_WVALID,
      S_ACLK => ps7_0_axi_periph_ACLK_net,
      S_ARESETN => ps7_0_axi_periph_ARESETN_net,
      S_AXI_araddr(31 downto 0) => xbar_to_m13_couplers_ARADDR(447 downto 416),
      S_AXI_arprot(2 downto 0) => xbar_to_m13_couplers_ARPROT(41 downto 39),
      S_AXI_arready => xbar_to_m13_couplers_ARREADY,
      S_AXI_arvalid => xbar_to_m13_couplers_ARVALID(13),
      S_AXI_awaddr(31 downto 0) => xbar_to_m13_couplers_AWADDR(447 downto 416),
      S_AXI_awprot(2 downto 0) => xbar_to_m13_couplers_AWPROT(41 downto 39),
      S_AXI_awready => xbar_to_m13_couplers_AWREADY,
      S_AXI_awvalid => xbar_to_m13_couplers_AWVALID(13),
      S_AXI_bready => xbar_to_m13_couplers_BREADY(13),
      S_AXI_bresp(1 downto 0) => xbar_to_m13_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => xbar_to_m13_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => xbar_to_m13_couplers_RDATA(31 downto 0),
      S_AXI_rready => xbar_to_m13_couplers_RREADY(13),
      S_AXI_rresp(1 downto 0) => xbar_to_m13_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => xbar_to_m13_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => xbar_to_m13_couplers_WDATA(447 downto 416),
      S_AXI_wready => xbar_to_m13_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => xbar_to_m13_couplers_WSTRB(55 downto 52),
      S_AXI_wvalid => xbar_to_m13_couplers_WVALID(13)
    );
s00_couplers: entity work.s00_couplers_imp_1MTXSBB
     port map (
      M_ACLK => ps7_0_axi_periph_ACLK_net,
      M_ARESETN => ps7_0_axi_periph_ARESETN_net,
      M_AXI_araddr(31 downto 0) => s00_couplers_to_xbar_ARADDR(31 downto 0),
      M_AXI_arprot(2 downto 0) => s00_couplers_to_xbar_ARPROT(2 downto 0),
      M_AXI_arready => s00_couplers_to_xbar_ARREADY(0),
      M_AXI_arvalid => s00_couplers_to_xbar_ARVALID,
      M_AXI_awaddr(31 downto 0) => s00_couplers_to_xbar_AWADDR(31 downto 0),
      M_AXI_awprot(2 downto 0) => s00_couplers_to_xbar_AWPROT(2 downto 0),
      M_AXI_awready => s00_couplers_to_xbar_AWREADY(0),
      M_AXI_awvalid => s00_couplers_to_xbar_AWVALID,
      M_AXI_bready => s00_couplers_to_xbar_BREADY,
      M_AXI_bresp(1 downto 0) => s00_couplers_to_xbar_BRESP(1 downto 0),
      M_AXI_bvalid => s00_couplers_to_xbar_BVALID(0),
      M_AXI_rdata(31 downto 0) => s00_couplers_to_xbar_RDATA(31 downto 0),
      M_AXI_rready => s00_couplers_to_xbar_RREADY,
      M_AXI_rresp(1 downto 0) => s00_couplers_to_xbar_RRESP(1 downto 0),
      M_AXI_rvalid => s00_couplers_to_xbar_RVALID(0),
      M_AXI_wdata(31 downto 0) => s00_couplers_to_xbar_WDATA(31 downto 0),
      M_AXI_wready => s00_couplers_to_xbar_WREADY(0),
      M_AXI_wstrb(3 downto 0) => s00_couplers_to_xbar_WSTRB(3 downto 0),
      M_AXI_wvalid => s00_couplers_to_xbar_WVALID,
      S_ACLK => S00_ACLK_1,
      S_ARESETN => S00_ARESETN_1,
      S_AXI_araddr(31 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARADDR(31 downto 0),
      S_AXI_arburst(1 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARBURST(1 downto 0),
      S_AXI_arcache(3 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARCACHE(3 downto 0),
      S_AXI_arid(11 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARID(11 downto 0),
      S_AXI_arlen(3 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARLEN(3 downto 0),
      S_AXI_arlock(1 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARLOCK(1 downto 0),
      S_AXI_arprot(2 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARPROT(2 downto 0),
      S_AXI_arqos(3 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARQOS(3 downto 0),
      S_AXI_arready => ps7_0_axi_periph_to_s00_couplers_ARREADY,
      S_AXI_arsize(2 downto 0) => ps7_0_axi_periph_to_s00_couplers_ARSIZE(2 downto 0),
      S_AXI_arvalid => ps7_0_axi_periph_to_s00_couplers_ARVALID,
      S_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWADDR(31 downto 0),
      S_AXI_awburst(1 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWBURST(1 downto 0),
      S_AXI_awcache(3 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWCACHE(3 downto 0),
      S_AXI_awid(11 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWID(11 downto 0),
      S_AXI_awlen(3 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWLEN(3 downto 0),
      S_AXI_awlock(1 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWLOCK(1 downto 0),
      S_AXI_awprot(2 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWPROT(2 downto 0),
      S_AXI_awqos(3 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWQOS(3 downto 0),
      S_AXI_awready => ps7_0_axi_periph_to_s00_couplers_AWREADY,
      S_AXI_awsize(2 downto 0) => ps7_0_axi_periph_to_s00_couplers_AWSIZE(2 downto 0),
      S_AXI_awvalid => ps7_0_axi_periph_to_s00_couplers_AWVALID,
      S_AXI_bid(11 downto 0) => ps7_0_axi_periph_to_s00_couplers_BID(11 downto 0),
      S_AXI_bready => ps7_0_axi_periph_to_s00_couplers_BREADY,
      S_AXI_bresp(1 downto 0) => ps7_0_axi_periph_to_s00_couplers_BRESP(1 downto 0),
      S_AXI_bvalid => ps7_0_axi_periph_to_s00_couplers_BVALID,
      S_AXI_rdata(31 downto 0) => ps7_0_axi_periph_to_s00_couplers_RDATA(31 downto 0),
      S_AXI_rid(11 downto 0) => ps7_0_axi_periph_to_s00_couplers_RID(11 downto 0),
      S_AXI_rlast => ps7_0_axi_periph_to_s00_couplers_RLAST,
      S_AXI_rready => ps7_0_axi_periph_to_s00_couplers_RREADY,
      S_AXI_rresp(1 downto 0) => ps7_0_axi_periph_to_s00_couplers_RRESP(1 downto 0),
      S_AXI_rvalid => ps7_0_axi_periph_to_s00_couplers_RVALID,
      S_AXI_wdata(31 downto 0) => ps7_0_axi_periph_to_s00_couplers_WDATA(31 downto 0),
      S_AXI_wid(11 downto 0) => ps7_0_axi_periph_to_s00_couplers_WID(11 downto 0),
      S_AXI_wlast => ps7_0_axi_periph_to_s00_couplers_WLAST,
      S_AXI_wready => ps7_0_axi_periph_to_s00_couplers_WREADY,
      S_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_to_s00_couplers_WSTRB(3 downto 0),
      S_AXI_wvalid => ps7_0_axi_periph_to_s00_couplers_WVALID
    );
xbar: component cantavi_streamer_project_xbar_0
     port map (
      aclk => ps7_0_axi_periph_ACLK_net,
      aresetn => ps7_0_axi_periph_ARESETN_net,
      m_axi_araddr(447 downto 416) => xbar_to_m13_couplers_ARADDR(447 downto 416),
      m_axi_araddr(415 downto 384) => xbar_to_m12_couplers_ARADDR(415 downto 384),
      m_axi_araddr(383 downto 352) => xbar_to_m11_couplers_ARADDR(383 downto 352),
      m_axi_araddr(351 downto 320) => xbar_to_m10_couplers_ARADDR(351 downto 320),
      m_axi_araddr(319 downto 288) => xbar_to_m09_couplers_ARADDR(319 downto 288),
      m_axi_araddr(287 downto 256) => xbar_to_m08_couplers_ARADDR(287 downto 256),
      m_axi_araddr(255 downto 224) => xbar_to_m07_couplers_ARADDR(255 downto 224),
      m_axi_araddr(223 downto 192) => xbar_to_m06_couplers_ARADDR(223 downto 192),
      m_axi_araddr(191 downto 160) => xbar_to_m05_couplers_ARADDR(191 downto 160),
      m_axi_araddr(159 downto 128) => xbar_to_m04_couplers_ARADDR(159 downto 128),
      m_axi_araddr(127 downto 96) => xbar_to_m03_couplers_ARADDR(127 downto 96),
      m_axi_araddr(95 downto 64) => xbar_to_m02_couplers_ARADDR(95 downto 64),
      m_axi_araddr(63 downto 32) => xbar_to_m01_couplers_ARADDR(63 downto 32),
      m_axi_araddr(31 downto 0) => xbar_to_m00_couplers_ARADDR(31 downto 0),
      m_axi_arprot(41 downto 39) => xbar_to_m13_couplers_ARPROT(41 downto 39),
      m_axi_arprot(38 downto 36) => xbar_to_m12_couplers_ARPROT(38 downto 36),
      m_axi_arprot(35 downto 33) => xbar_to_m11_couplers_ARPROT(35 downto 33),
      m_axi_arprot(32 downto 30) => xbar_to_m10_couplers_ARPROT(32 downto 30),
      m_axi_arprot(29 downto 24) => NLW_xbar_m_axi_arprot_UNCONNECTED(29 downto 24),
      m_axi_arprot(23 downto 21) => xbar_to_m07_couplers_ARPROT(23 downto 21),
      m_axi_arprot(20 downto 18) => xbar_to_m06_couplers_ARPROT(20 downto 18),
      m_axi_arprot(17 downto 15) => xbar_to_m05_couplers_ARPROT(17 downto 15),
      m_axi_arprot(14 downto 12) => xbar_to_m04_couplers_ARPROT(14 downto 12),
      m_axi_arprot(11 downto 9) => xbar_to_m03_couplers_ARPROT(11 downto 9),
      m_axi_arprot(8 downto 6) => xbar_to_m02_couplers_ARPROT(8 downto 6),
      m_axi_arprot(5 downto 3) => xbar_to_m01_couplers_ARPROT(5 downto 3),
      m_axi_arprot(2 downto 0) => NLW_xbar_m_axi_arprot_UNCONNECTED(2 downto 0),
      m_axi_arready(13) => xbar_to_m13_couplers_ARREADY,
      m_axi_arready(12) => xbar_to_m12_couplers_ARREADY,
      m_axi_arready(11) => xbar_to_m11_couplers_ARREADY,
      m_axi_arready(10) => xbar_to_m10_couplers_ARREADY,
      m_axi_arready(9) => xbar_to_m09_couplers_ARREADY(0),
      m_axi_arready(8) => xbar_to_m08_couplers_ARREADY(0),
      m_axi_arready(7) => xbar_to_m07_couplers_ARREADY(0),
      m_axi_arready(6) => xbar_to_m06_couplers_ARREADY,
      m_axi_arready(5) => xbar_to_m05_couplers_ARREADY,
      m_axi_arready(4) => xbar_to_m04_couplers_ARREADY,
      m_axi_arready(3) => xbar_to_m03_couplers_ARREADY,
      m_axi_arready(2) => xbar_to_m02_couplers_ARREADY,
      m_axi_arready(1) => xbar_to_m01_couplers_ARREADY,
      m_axi_arready(0) => xbar_to_m00_couplers_ARREADY(0),
      m_axi_arvalid(13) => xbar_to_m13_couplers_ARVALID(13),
      m_axi_arvalid(12) => xbar_to_m12_couplers_ARVALID(12),
      m_axi_arvalid(11) => xbar_to_m11_couplers_ARVALID(11),
      m_axi_arvalid(10) => xbar_to_m10_couplers_ARVALID(10),
      m_axi_arvalid(9) => xbar_to_m09_couplers_ARVALID(9),
      m_axi_arvalid(8) => xbar_to_m08_couplers_ARVALID(8),
      m_axi_arvalid(7) => xbar_to_m07_couplers_ARVALID(7),
      m_axi_arvalid(6) => xbar_to_m06_couplers_ARVALID(6),
      m_axi_arvalid(5) => xbar_to_m05_couplers_ARVALID(5),
      m_axi_arvalid(4) => xbar_to_m04_couplers_ARVALID(4),
      m_axi_arvalid(3) => xbar_to_m03_couplers_ARVALID(3),
      m_axi_arvalid(2) => xbar_to_m02_couplers_ARVALID(2),
      m_axi_arvalid(1) => xbar_to_m01_couplers_ARVALID(1),
      m_axi_arvalid(0) => xbar_to_m00_couplers_ARVALID(0),
      m_axi_awaddr(447 downto 416) => xbar_to_m13_couplers_AWADDR(447 downto 416),
      m_axi_awaddr(415 downto 384) => xbar_to_m12_couplers_AWADDR(415 downto 384),
      m_axi_awaddr(383 downto 352) => xbar_to_m11_couplers_AWADDR(383 downto 352),
      m_axi_awaddr(351 downto 320) => xbar_to_m10_couplers_AWADDR(351 downto 320),
      m_axi_awaddr(319 downto 288) => xbar_to_m09_couplers_AWADDR(319 downto 288),
      m_axi_awaddr(287 downto 256) => xbar_to_m08_couplers_AWADDR(287 downto 256),
      m_axi_awaddr(255 downto 224) => xbar_to_m07_couplers_AWADDR(255 downto 224),
      m_axi_awaddr(223 downto 192) => xbar_to_m06_couplers_AWADDR(223 downto 192),
      m_axi_awaddr(191 downto 160) => xbar_to_m05_couplers_AWADDR(191 downto 160),
      m_axi_awaddr(159 downto 128) => xbar_to_m04_couplers_AWADDR(159 downto 128),
      m_axi_awaddr(127 downto 96) => xbar_to_m03_couplers_AWADDR(127 downto 96),
      m_axi_awaddr(95 downto 64) => xbar_to_m02_couplers_AWADDR(95 downto 64),
      m_axi_awaddr(63 downto 32) => xbar_to_m01_couplers_AWADDR(63 downto 32),
      m_axi_awaddr(31 downto 0) => xbar_to_m00_couplers_AWADDR(31 downto 0),
      m_axi_awprot(41 downto 39) => xbar_to_m13_couplers_AWPROT(41 downto 39),
      m_axi_awprot(38 downto 36) => xbar_to_m12_couplers_AWPROT(38 downto 36),
      m_axi_awprot(35 downto 33) => xbar_to_m11_couplers_AWPROT(35 downto 33),
      m_axi_awprot(32 downto 30) => xbar_to_m10_couplers_AWPROT(32 downto 30),
      m_axi_awprot(29 downto 24) => NLW_xbar_m_axi_awprot_UNCONNECTED(29 downto 24),
      m_axi_awprot(23 downto 21) => xbar_to_m07_couplers_AWPROT(23 downto 21),
      m_axi_awprot(20 downto 18) => xbar_to_m06_couplers_AWPROT(20 downto 18),
      m_axi_awprot(17 downto 15) => xbar_to_m05_couplers_AWPROT(17 downto 15),
      m_axi_awprot(14 downto 12) => xbar_to_m04_couplers_AWPROT(14 downto 12),
      m_axi_awprot(11 downto 9) => xbar_to_m03_couplers_AWPROT(11 downto 9),
      m_axi_awprot(8 downto 6) => xbar_to_m02_couplers_AWPROT(8 downto 6),
      m_axi_awprot(5 downto 3) => xbar_to_m01_couplers_AWPROT(5 downto 3),
      m_axi_awprot(2 downto 0) => NLW_xbar_m_axi_awprot_UNCONNECTED(2 downto 0),
      m_axi_awready(13) => xbar_to_m13_couplers_AWREADY,
      m_axi_awready(12) => xbar_to_m12_couplers_AWREADY,
      m_axi_awready(11) => xbar_to_m11_couplers_AWREADY,
      m_axi_awready(10) => xbar_to_m10_couplers_AWREADY,
      m_axi_awready(9) => xbar_to_m09_couplers_AWREADY(0),
      m_axi_awready(8) => xbar_to_m08_couplers_AWREADY(0),
      m_axi_awready(7) => xbar_to_m07_couplers_AWREADY(0),
      m_axi_awready(6) => xbar_to_m06_couplers_AWREADY,
      m_axi_awready(5) => xbar_to_m05_couplers_AWREADY,
      m_axi_awready(4) => xbar_to_m04_couplers_AWREADY,
      m_axi_awready(3) => xbar_to_m03_couplers_AWREADY,
      m_axi_awready(2) => xbar_to_m02_couplers_AWREADY,
      m_axi_awready(1) => xbar_to_m01_couplers_AWREADY,
      m_axi_awready(0) => xbar_to_m00_couplers_AWREADY(0),
      m_axi_awvalid(13) => xbar_to_m13_couplers_AWVALID(13),
      m_axi_awvalid(12) => xbar_to_m12_couplers_AWVALID(12),
      m_axi_awvalid(11) => xbar_to_m11_couplers_AWVALID(11),
      m_axi_awvalid(10) => xbar_to_m10_couplers_AWVALID(10),
      m_axi_awvalid(9) => xbar_to_m09_couplers_AWVALID(9),
      m_axi_awvalid(8) => xbar_to_m08_couplers_AWVALID(8),
      m_axi_awvalid(7) => xbar_to_m07_couplers_AWVALID(7),
      m_axi_awvalid(6) => xbar_to_m06_couplers_AWVALID(6),
      m_axi_awvalid(5) => xbar_to_m05_couplers_AWVALID(5),
      m_axi_awvalid(4) => xbar_to_m04_couplers_AWVALID(4),
      m_axi_awvalid(3) => xbar_to_m03_couplers_AWVALID(3),
      m_axi_awvalid(2) => xbar_to_m02_couplers_AWVALID(2),
      m_axi_awvalid(1) => xbar_to_m01_couplers_AWVALID(1),
      m_axi_awvalid(0) => xbar_to_m00_couplers_AWVALID(0),
      m_axi_bready(13) => xbar_to_m13_couplers_BREADY(13),
      m_axi_bready(12) => xbar_to_m12_couplers_BREADY(12),
      m_axi_bready(11) => xbar_to_m11_couplers_BREADY(11),
      m_axi_bready(10) => xbar_to_m10_couplers_BREADY(10),
      m_axi_bready(9) => xbar_to_m09_couplers_BREADY(9),
      m_axi_bready(8) => xbar_to_m08_couplers_BREADY(8),
      m_axi_bready(7) => xbar_to_m07_couplers_BREADY(7),
      m_axi_bready(6) => xbar_to_m06_couplers_BREADY(6),
      m_axi_bready(5) => xbar_to_m05_couplers_BREADY(5),
      m_axi_bready(4) => xbar_to_m04_couplers_BREADY(4),
      m_axi_bready(3) => xbar_to_m03_couplers_BREADY(3),
      m_axi_bready(2) => xbar_to_m02_couplers_BREADY(2),
      m_axi_bready(1) => xbar_to_m01_couplers_BREADY(1),
      m_axi_bready(0) => xbar_to_m00_couplers_BREADY(0),
      m_axi_bresp(27 downto 26) => xbar_to_m13_couplers_BRESP(1 downto 0),
      m_axi_bresp(25 downto 24) => xbar_to_m12_couplers_BRESP(1 downto 0),
      m_axi_bresp(23 downto 22) => xbar_to_m11_couplers_BRESP(1 downto 0),
      m_axi_bresp(21 downto 20) => xbar_to_m10_couplers_BRESP(1 downto 0),
      m_axi_bresp(19 downto 18) => xbar_to_m09_couplers_BRESP(1 downto 0),
      m_axi_bresp(17 downto 16) => xbar_to_m08_couplers_BRESP(1 downto 0),
      m_axi_bresp(15 downto 14) => xbar_to_m07_couplers_BRESP(1 downto 0),
      m_axi_bresp(13 downto 12) => xbar_to_m06_couplers_BRESP(1 downto 0),
      m_axi_bresp(11 downto 10) => xbar_to_m05_couplers_BRESP(1 downto 0),
      m_axi_bresp(9 downto 8) => xbar_to_m04_couplers_BRESP(1 downto 0),
      m_axi_bresp(7 downto 6) => xbar_to_m03_couplers_BRESP(1 downto 0),
      m_axi_bresp(5 downto 4) => xbar_to_m02_couplers_BRESP(1 downto 0),
      m_axi_bresp(3 downto 2) => xbar_to_m01_couplers_BRESP(1 downto 0),
      m_axi_bresp(1 downto 0) => xbar_to_m00_couplers_BRESP(1 downto 0),
      m_axi_bvalid(13) => xbar_to_m13_couplers_BVALID,
      m_axi_bvalid(12) => xbar_to_m12_couplers_BVALID,
      m_axi_bvalid(11) => xbar_to_m11_couplers_BVALID,
      m_axi_bvalid(10) => xbar_to_m10_couplers_BVALID,
      m_axi_bvalid(9) => xbar_to_m09_couplers_BVALID(0),
      m_axi_bvalid(8) => xbar_to_m08_couplers_BVALID(0),
      m_axi_bvalid(7) => xbar_to_m07_couplers_BVALID(0),
      m_axi_bvalid(6) => xbar_to_m06_couplers_BVALID,
      m_axi_bvalid(5) => xbar_to_m05_couplers_BVALID,
      m_axi_bvalid(4) => xbar_to_m04_couplers_BVALID,
      m_axi_bvalid(3) => xbar_to_m03_couplers_BVALID,
      m_axi_bvalid(2) => xbar_to_m02_couplers_BVALID,
      m_axi_bvalid(1) => xbar_to_m01_couplers_BVALID,
      m_axi_bvalid(0) => xbar_to_m00_couplers_BVALID(0),
      m_axi_rdata(447 downto 416) => xbar_to_m13_couplers_RDATA(31 downto 0),
      m_axi_rdata(415 downto 384) => xbar_to_m12_couplers_RDATA(31 downto 0),
      m_axi_rdata(383 downto 352) => xbar_to_m11_couplers_RDATA(31 downto 0),
      m_axi_rdata(351 downto 320) => xbar_to_m10_couplers_RDATA(31 downto 0),
      m_axi_rdata(319 downto 288) => xbar_to_m09_couplers_RDATA(31 downto 0),
      m_axi_rdata(287 downto 256) => xbar_to_m08_couplers_RDATA(31 downto 0),
      m_axi_rdata(255 downto 224) => xbar_to_m07_couplers_RDATA(31 downto 0),
      m_axi_rdata(223 downto 192) => xbar_to_m06_couplers_RDATA(31 downto 0),
      m_axi_rdata(191 downto 160) => xbar_to_m05_couplers_RDATA(31 downto 0),
      m_axi_rdata(159 downto 128) => xbar_to_m04_couplers_RDATA(31 downto 0),
      m_axi_rdata(127 downto 96) => xbar_to_m03_couplers_RDATA(31 downto 0),
      m_axi_rdata(95 downto 64) => xbar_to_m02_couplers_RDATA(31 downto 0),
      m_axi_rdata(63 downto 32) => xbar_to_m01_couplers_RDATA(31 downto 0),
      m_axi_rdata(31 downto 0) => xbar_to_m00_couplers_RDATA(31 downto 0),
      m_axi_rready(13) => xbar_to_m13_couplers_RREADY(13),
      m_axi_rready(12) => xbar_to_m12_couplers_RREADY(12),
      m_axi_rready(11) => xbar_to_m11_couplers_RREADY(11),
      m_axi_rready(10) => xbar_to_m10_couplers_RREADY(10),
      m_axi_rready(9) => xbar_to_m09_couplers_RREADY(9),
      m_axi_rready(8) => xbar_to_m08_couplers_RREADY(8),
      m_axi_rready(7) => xbar_to_m07_couplers_RREADY(7),
      m_axi_rready(6) => xbar_to_m06_couplers_RREADY(6),
      m_axi_rready(5) => xbar_to_m05_couplers_RREADY(5),
      m_axi_rready(4) => xbar_to_m04_couplers_RREADY(4),
      m_axi_rready(3) => xbar_to_m03_couplers_RREADY(3),
      m_axi_rready(2) => xbar_to_m02_couplers_RREADY(2),
      m_axi_rready(1) => xbar_to_m01_couplers_RREADY(1),
      m_axi_rready(0) => xbar_to_m00_couplers_RREADY(0),
      m_axi_rresp(27 downto 26) => xbar_to_m13_couplers_RRESP(1 downto 0),
      m_axi_rresp(25 downto 24) => xbar_to_m12_couplers_RRESP(1 downto 0),
      m_axi_rresp(23 downto 22) => xbar_to_m11_couplers_RRESP(1 downto 0),
      m_axi_rresp(21 downto 20) => xbar_to_m10_couplers_RRESP(1 downto 0),
      m_axi_rresp(19 downto 18) => xbar_to_m09_couplers_RRESP(1 downto 0),
      m_axi_rresp(17 downto 16) => xbar_to_m08_couplers_RRESP(1 downto 0),
      m_axi_rresp(15 downto 14) => xbar_to_m07_couplers_RRESP(1 downto 0),
      m_axi_rresp(13 downto 12) => xbar_to_m06_couplers_RRESP(1 downto 0),
      m_axi_rresp(11 downto 10) => xbar_to_m05_couplers_RRESP(1 downto 0),
      m_axi_rresp(9 downto 8) => xbar_to_m04_couplers_RRESP(1 downto 0),
      m_axi_rresp(7 downto 6) => xbar_to_m03_couplers_RRESP(1 downto 0),
      m_axi_rresp(5 downto 4) => xbar_to_m02_couplers_RRESP(1 downto 0),
      m_axi_rresp(3 downto 2) => xbar_to_m01_couplers_RRESP(1 downto 0),
      m_axi_rresp(1 downto 0) => xbar_to_m00_couplers_RRESP(1 downto 0),
      m_axi_rvalid(13) => xbar_to_m13_couplers_RVALID,
      m_axi_rvalid(12) => xbar_to_m12_couplers_RVALID,
      m_axi_rvalid(11) => xbar_to_m11_couplers_RVALID,
      m_axi_rvalid(10) => xbar_to_m10_couplers_RVALID,
      m_axi_rvalid(9) => xbar_to_m09_couplers_RVALID(0),
      m_axi_rvalid(8) => xbar_to_m08_couplers_RVALID(0),
      m_axi_rvalid(7) => xbar_to_m07_couplers_RVALID(0),
      m_axi_rvalid(6) => xbar_to_m06_couplers_RVALID,
      m_axi_rvalid(5) => xbar_to_m05_couplers_RVALID,
      m_axi_rvalid(4) => xbar_to_m04_couplers_RVALID,
      m_axi_rvalid(3) => xbar_to_m03_couplers_RVALID,
      m_axi_rvalid(2) => xbar_to_m02_couplers_RVALID,
      m_axi_rvalid(1) => xbar_to_m01_couplers_RVALID,
      m_axi_rvalid(0) => xbar_to_m00_couplers_RVALID(0),
      m_axi_wdata(447 downto 416) => xbar_to_m13_couplers_WDATA(447 downto 416),
      m_axi_wdata(415 downto 384) => xbar_to_m12_couplers_WDATA(415 downto 384),
      m_axi_wdata(383 downto 352) => xbar_to_m11_couplers_WDATA(383 downto 352),
      m_axi_wdata(351 downto 320) => xbar_to_m10_couplers_WDATA(351 downto 320),
      m_axi_wdata(319 downto 288) => xbar_to_m09_couplers_WDATA(319 downto 288),
      m_axi_wdata(287 downto 256) => xbar_to_m08_couplers_WDATA(287 downto 256),
      m_axi_wdata(255 downto 224) => xbar_to_m07_couplers_WDATA(255 downto 224),
      m_axi_wdata(223 downto 192) => xbar_to_m06_couplers_WDATA(223 downto 192),
      m_axi_wdata(191 downto 160) => xbar_to_m05_couplers_WDATA(191 downto 160),
      m_axi_wdata(159 downto 128) => xbar_to_m04_couplers_WDATA(159 downto 128),
      m_axi_wdata(127 downto 96) => xbar_to_m03_couplers_WDATA(127 downto 96),
      m_axi_wdata(95 downto 64) => xbar_to_m02_couplers_WDATA(95 downto 64),
      m_axi_wdata(63 downto 32) => xbar_to_m01_couplers_WDATA(63 downto 32),
      m_axi_wdata(31 downto 0) => xbar_to_m00_couplers_WDATA(31 downto 0),
      m_axi_wready(13) => xbar_to_m13_couplers_WREADY,
      m_axi_wready(12) => xbar_to_m12_couplers_WREADY,
      m_axi_wready(11) => xbar_to_m11_couplers_WREADY,
      m_axi_wready(10) => xbar_to_m10_couplers_WREADY,
      m_axi_wready(9) => xbar_to_m09_couplers_WREADY(0),
      m_axi_wready(8) => xbar_to_m08_couplers_WREADY(0),
      m_axi_wready(7) => xbar_to_m07_couplers_WREADY(0),
      m_axi_wready(6) => xbar_to_m06_couplers_WREADY,
      m_axi_wready(5) => xbar_to_m05_couplers_WREADY,
      m_axi_wready(4) => xbar_to_m04_couplers_WREADY,
      m_axi_wready(3) => xbar_to_m03_couplers_WREADY,
      m_axi_wready(2) => xbar_to_m02_couplers_WREADY,
      m_axi_wready(1) => xbar_to_m01_couplers_WREADY,
      m_axi_wready(0) => xbar_to_m00_couplers_WREADY(0),
      m_axi_wstrb(55 downto 52) => xbar_to_m13_couplers_WSTRB(55 downto 52),
      m_axi_wstrb(51 downto 48) => xbar_to_m12_couplers_WSTRB(51 downto 48),
      m_axi_wstrb(47 downto 44) => xbar_to_m11_couplers_WSTRB(47 downto 44),
      m_axi_wstrb(43 downto 40) => xbar_to_m10_couplers_WSTRB(43 downto 40),
      m_axi_wstrb(39 downto 36) => xbar_to_m09_couplers_WSTRB(39 downto 36),
      m_axi_wstrb(35 downto 32) => xbar_to_m08_couplers_WSTRB(35 downto 32),
      m_axi_wstrb(31 downto 28) => xbar_to_m07_couplers_WSTRB(31 downto 28),
      m_axi_wstrb(27 downto 24) => xbar_to_m06_couplers_WSTRB(27 downto 24),
      m_axi_wstrb(23 downto 20) => xbar_to_m05_couplers_WSTRB(23 downto 20),
      m_axi_wstrb(19 downto 16) => xbar_to_m04_couplers_WSTRB(19 downto 16),
      m_axi_wstrb(15 downto 12) => xbar_to_m03_couplers_WSTRB(15 downto 12),
      m_axi_wstrb(11 downto 8) => xbar_to_m02_couplers_WSTRB(11 downto 8),
      m_axi_wstrb(7 downto 4) => xbar_to_m01_couplers_WSTRB(7 downto 4),
      m_axi_wstrb(3 downto 0) => xbar_to_m00_couplers_WSTRB(3 downto 0),
      m_axi_wvalid(13) => xbar_to_m13_couplers_WVALID(13),
      m_axi_wvalid(12) => xbar_to_m12_couplers_WVALID(12),
      m_axi_wvalid(11) => xbar_to_m11_couplers_WVALID(11),
      m_axi_wvalid(10) => xbar_to_m10_couplers_WVALID(10),
      m_axi_wvalid(9) => xbar_to_m09_couplers_WVALID(9),
      m_axi_wvalid(8) => xbar_to_m08_couplers_WVALID(8),
      m_axi_wvalid(7) => xbar_to_m07_couplers_WVALID(7),
      m_axi_wvalid(6) => xbar_to_m06_couplers_WVALID(6),
      m_axi_wvalid(5) => xbar_to_m05_couplers_WVALID(5),
      m_axi_wvalid(4) => xbar_to_m04_couplers_WVALID(4),
      m_axi_wvalid(3) => xbar_to_m03_couplers_WVALID(3),
      m_axi_wvalid(2) => xbar_to_m02_couplers_WVALID(2),
      m_axi_wvalid(1) => xbar_to_m01_couplers_WVALID(1),
      m_axi_wvalid(0) => xbar_to_m00_couplers_WVALID(0),
      s_axi_araddr(31 downto 0) => s00_couplers_to_xbar_ARADDR(31 downto 0),
      s_axi_arprot(2 downto 0) => s00_couplers_to_xbar_ARPROT(2 downto 0),
      s_axi_arready(0) => s00_couplers_to_xbar_ARREADY(0),
      s_axi_arvalid(0) => s00_couplers_to_xbar_ARVALID,
      s_axi_awaddr(31 downto 0) => s00_couplers_to_xbar_AWADDR(31 downto 0),
      s_axi_awprot(2 downto 0) => s00_couplers_to_xbar_AWPROT(2 downto 0),
      s_axi_awready(0) => s00_couplers_to_xbar_AWREADY(0),
      s_axi_awvalid(0) => s00_couplers_to_xbar_AWVALID,
      s_axi_bready(0) => s00_couplers_to_xbar_BREADY,
      s_axi_bresp(1 downto 0) => s00_couplers_to_xbar_BRESP(1 downto 0),
      s_axi_bvalid(0) => s00_couplers_to_xbar_BVALID(0),
      s_axi_rdata(31 downto 0) => s00_couplers_to_xbar_RDATA(31 downto 0),
      s_axi_rready(0) => s00_couplers_to_xbar_RREADY,
      s_axi_rresp(1 downto 0) => s00_couplers_to_xbar_RRESP(1 downto 0),
      s_axi_rvalid(0) => s00_couplers_to_xbar_RVALID(0),
      s_axi_wdata(31 downto 0) => s00_couplers_to_xbar_WDATA(31 downto 0),
      s_axi_wready(0) => s00_couplers_to_xbar_WREADY(0),
      s_axi_wstrb(3 downto 0) => s00_couplers_to_xbar_WSTRB(3 downto 0),
      s_axi_wvalid(0) => s00_couplers_to_xbar_WVALID
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity cantavi_streamer_project is
  port (
    Button : in STD_LOGIC;
    DC : out STD_LOGIC;
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    RES : out STD_LOGIC;
    Rotary_a : in STD_LOGIC;
    Rotary_b : in STD_LOGIC;
    SCLK : out STD_LOGIC;
    SDIN : out STD_LOGIC;
    Switch : in STD_LOGIC;
    VBAT : out STD_LOGIC;
    VDD : out STD_LOGIC;
    adau1761_adc_sdata_0 : in STD_LOGIC;
    adau1761_bclk_0 : in STD_LOGIC;
    adau1761_cclk_0 : out STD_LOGIC;
    adau1761_cdata_0 : out STD_LOGIC;
    adau1761_clatchn_0 : out STD_LOGIC;
    adau1761_cout_0 : in STD_LOGIC;
    adau1761_dac_sdata_0 : out STD_LOGIC;
    adau1761_lrclk_0 : in STD_LOGIC;
    btnc_0 : in STD_LOGIC;
    btnd_0 : in STD_LOGIC;
    btnl_0 : in STD_LOGIC;
    btnr_0 : in STD_LOGIC;
    btnu_0 : in STD_LOGIC;
    clk_100_in : in STD_LOGIC;
    led_0 : out STD_LOGIC_VECTOR ( 7 downto 0 );
    phy_int_n_0 : in STD_LOGIC;
    phy_pme_n_0 : in STD_LOGIC;
    phy_reset_n_0 : out STD_LOGIC;
    phy_rx_clk_0 : in STD_LOGIC;
    phy_rx_ctl_0 : in STD_LOGIC;
    phy_rxd_0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    phy_tx_clk_0 : out STD_LOGIC;
    phy_tx_ctl_0 : out STD_LOGIC;
    phy_txd_0 : out STD_LOGIC_VECTOR ( 3 downto 0 );
    sws_8bits_tri_i : in STD_LOGIC_VECTOR ( 7 downto 0 );
    uart_rxd_0 : in STD_LOGIC;
    uart_txd_0 : out STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of cantavi_streamer_project : entity is "cantavi_streamer_project,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=cantavi_streamer_project,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=39,numReposBlks=22,numNonXlnxBlks=14,numHierBlks=17,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=2,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of cantavi_streamer_project : entity is "cantavi_streamer_project.hwdef";
end cantavi_streamer_project;

architecture STRUCTURE of cantavi_streamer_project is
  component cantavi_streamer_project_xlconcat_0_0 is
  port (
    In0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In3 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In4 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    In9 : in STD_LOGIC_VECTOR ( 0 to 0 );
    dout : out STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  end component cantavi_streamer_project_xlconcat_0_0;
  component cantavi_streamer_project_pmod_controller_0_1 is
  port (
    Rotary_a : in STD_LOGIC;
    Rotary_b : in STD_LOGIC;
    Button : in STD_LOGIC;
    Switch : in STD_LOGIC;
    Rotary_event : out STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_pmod_controller_0_1;
  component cantavi_streamer_project_axi_gpio_0_2 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    ip2intc_irpt : out STD_LOGIC;
    gpio_io_i : in STD_LOGIC_VECTOR ( 4 downto 0 )
  );
  end component cantavi_streamer_project_axi_gpio_0_2;
  component cantavi_streamer_project_axi_gpio_1_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    ip2intc_irpt : out STD_LOGIC;
    gpio_io_i : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component cantavi_streamer_project_axi_gpio_1_0;
  component cantavi_streamer_project_axi_gpio_2_0 is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 8 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    ip2intc_irpt : out STD_LOGIC;
    gpio_io_o : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component cantavi_streamer_project_axi_gpio_2_0;
  component cantavi_streamer_project_processing_system7_0_0 is
  port (
    TTC0_WAVE0_OUT : out STD_LOGIC;
    TTC0_WAVE1_OUT : out STD_LOGIC;
    TTC0_WAVE2_OUT : out STD_LOGIC;
    USB0_PORT_INDCTL : out STD_LOGIC_VECTOR ( 1 downto 0 );
    USB0_VBUS_PWRSELECT : out STD_LOGIC;
    USB0_VBUS_PWRFAULT : in STD_LOGIC;
    M_AXI_GP0_ARVALID : out STD_LOGIC;
    M_AXI_GP0_AWVALID : out STD_LOGIC;
    M_AXI_GP0_BREADY : out STD_LOGIC;
    M_AXI_GP0_RREADY : out STD_LOGIC;
    M_AXI_GP0_WLAST : out STD_LOGIC;
    M_AXI_GP0_WVALID : out STD_LOGIC;
    M_AXI_GP0_ARID : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_AWID : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_WID : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_ARBURST : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_ARLOCK : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_ARSIZE : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_AWBURST : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_AWLOCK : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_AWSIZE : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_ARPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_AWPROT : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_ARADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_AWADDR : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_WDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_ARCACHE : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_ARLEN : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_ARQOS : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_AWCACHE : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_AWLEN : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_AWQOS : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_WSTRB : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_ACLK : in STD_LOGIC;
    M_AXI_GP0_ARREADY : in STD_LOGIC;
    M_AXI_GP0_AWREADY : in STD_LOGIC;
    M_AXI_GP0_BVALID : in STD_LOGIC;
    M_AXI_GP0_RLAST : in STD_LOGIC;
    M_AXI_GP0_RVALID : in STD_LOGIC;
    M_AXI_GP0_WREADY : in STD_LOGIC;
    M_AXI_GP0_BID : in STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_RID : in STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_BRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_RRESP : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_RDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    IRQ_F2P : in STD_LOGIC_VECTOR ( 9 downto 0 );
    FCLK_CLK0 : out STD_LOGIC;
    FCLK_CLK1 : out STD_LOGIC;
    FCLK_CLK2 : out STD_LOGIC;
    FCLK_CLK3 : out STD_LOGIC;
    FCLK_RESET0_N : out STD_LOGIC;
    MIO : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    DDR_CAS_n : inout STD_LOGIC;
    DDR_CKE : inout STD_LOGIC;
    DDR_Clk_n : inout STD_LOGIC;
    DDR_Clk : inout STD_LOGIC;
    DDR_CS_n : inout STD_LOGIC;
    DDR_DRSTB : inout STD_LOGIC;
    DDR_ODT : inout STD_LOGIC;
    DDR_RAS_n : inout STD_LOGIC;
    DDR_WEB : inout STD_LOGIC;
    DDR_BankAddr : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_Addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_VRN : inout STD_LOGIC;
    DDR_VRP : inout STD_LOGIC;
    DDR_DM : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_DQ : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_DQS_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_DQS : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    PS_SRSTB : inout STD_LOGIC;
    PS_CLK : inout STD_LOGIC;
    PS_PORB : inout STD_LOGIC
  );
  end component cantavi_streamer_project_processing_system7_0_0;
  component cantavi_streamer_project_rst_ps7_0_100M_0 is
  port (
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component cantavi_streamer_project_rst_ps7_0_100M_0;
  component cantavi_streamer_project_mixer_0_0 is
  port (
    audio_mixed_a_b_left_out : out STD_LOGIC_VECTOR ( 23 downto 0 );
    audio_mixed_a_b_right_out : out STD_LOGIC_VECTOR ( 23 downto 0 );
    audio_channel_a_left_in : in STD_LOGIC_VECTOR ( 23 downto 0 );
    audio_channel_a_right_in : in STD_LOGIC_VECTOR ( 23 downto 0 );
    audio_channel_b_left_in : in STD_LOGIC_VECTOR ( 23 downto 0 );
    audio_channel_b_right_in : in STD_LOGIC_VECTOR ( 23 downto 0 )
  );
  end component cantavi_streamer_project_mixer_0_0;
  component cantavi_streamer_project_ZedboardOLED_0_0 is
  port (
    SDIN : out STD_LOGIC;
    SCLK : out STD_LOGIC;
    DC : out STD_LOGIC;
    RES : out STD_LOGIC;
    VBAT : out STD_LOGIC;
    VDD : out STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
  end component cantavi_streamer_project_ZedboardOLED_0_0;
  component cantavi_streamer_project_Volume_Pregain_0_0 is
  port (
    OUT_VOLCTRL_L : out STD_LOGIC_VECTOR ( 23 downto 0 );
    OUT_VOLCTRL_R : out STD_LOGIC_VECTOR ( 23 downto 0 );
    OUT_RDY : out STD_LOGIC;
    IN_SIG_L : in STD_LOGIC_VECTOR ( 23 downto 0 );
    IN_SIG_R : in STD_LOGIC_VECTOR ( 23 downto 0 );
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_Volume_Pregain_0_0;
  component cantavi_streamer_project_Volume_Pregain_1_1 is
  port (
    OUT_VOLCTRL_L : out STD_LOGIC_VECTOR ( 23 downto 0 );
    OUT_VOLCTRL_R : out STD_LOGIC_VECTOR ( 23 downto 0 );
    OUT_RDY : out STD_LOGIC;
    IN_SIG_L : in STD_LOGIC_VECTOR ( 23 downto 0 );
    IN_SIG_R : in STD_LOGIC_VECTOR ( 23 downto 0 );
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_Volume_Pregain_1_1;
  component cantavi_streamer_project_FILTER_IIR_0_0 is
  port (
    AUDIO_OUT_L : out STD_LOGIC_VECTOR ( 23 downto 0 );
    AUDIO_OUT_R : out STD_LOGIC_VECTOR ( 23 downto 0 );
    FILTER_DONE : out STD_LOGIC;
    SAMPLE_TRIG : in STD_LOGIC;
    AUDIO_IN_L : in STD_LOGIC_VECTOR ( 23 downto 0 );
    AUDIO_IN_R : in STD_LOGIC_VECTOR ( 23 downto 0 );
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_FILTER_IIR_0_0;
  component cantavi_streamer_project_FILTER_IIR_1_0 is
  port (
    AUDIO_OUT_L : out STD_LOGIC_VECTOR ( 23 downto 0 );
    AUDIO_OUT_R : out STD_LOGIC_VECTOR ( 23 downto 0 );
    FILTER_DONE : out STD_LOGIC;
    SAMPLE_TRIG : in STD_LOGIC;
    AUDIO_IN_L : in STD_LOGIC_VECTOR ( 23 downto 0 );
    AUDIO_IN_R : in STD_LOGIC_VECTOR ( 23 downto 0 );
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_FILTER_IIR_1_0;
  component cantavi_streamer_project_user_org_plc_seq_ip_0_0 is
  port (
    clk_125 : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    fm_udp_s_axis_aclk : in STD_LOGIC;
    fm_udp_s_axis_aresetn : in STD_LOGIC;
    fm_udp_s_axis_tready : out STD_LOGIC;
    fm_udp_s_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    fm_udp_s_axis_tlast : in STD_LOGIC;
    fm_udp_s_axis_tvalid : in STD_LOGIC;
    fm_audio_s_axis_aclk : in STD_LOGIC;
    fm_audio_s_axis_aresetn : in STD_LOGIC;
    fm_audio_s_axis_tready : out STD_LOGIC;
    fm_audio_s_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    fm_audio_s_axis_tlast : in STD_LOGIC;
    fm_audio_s_axis_tvalid : in STD_LOGIC;
    fm_audio_hdr_valid : in STD_LOGIC;
    to_udp_m_axis_aclk : in STD_LOGIC;
    to_udp_m_axis_aresetn : in STD_LOGIC;
    to_udp_m_axis_tvalid : out STD_LOGIC;
    to_udp_m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    to_udp_m_axis_tlast : out STD_LOGIC;
    to_udp_m_axis_tready : in STD_LOGIC;
    to_udp_hdr_valid : out STD_LOGIC;
    to_audio_m_axis_aclk : in STD_LOGIC;
    to_audio_m_axis_aresetn : in STD_LOGIC;
    to_audio_m_axis_tvalid : out STD_LOGIC;
    to_audio_m_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    to_audio_m_axis_tlast : out STD_LOGIC;
    to_audio_m_axis_tready : in STD_LOGIC;
    fifo_occ_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
    replace_pkt_in : in STD_LOGIC;
    play_out_ready_in : in STD_LOGIC;
    new_sample_in : in STD_LOGIC;
    fifo_full_in : in STD_LOGIC;
    fifo_empty_in : in STD_LOGIC;
    fifo_full_out : out STD_LOGIC;
    fifo_empty_out : out STD_LOGIC;
    status1_out : out STD_LOGIC;
    status2_out : out STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_user_org_plc_seq_ip_0_0;
  component cantavi_streamer_project_full_udp_stack_ip_0_0 is
  port (
    clk_100_in : in STD_LOGIC;
    clk_90_in : in STD_LOGIC;
    clk_125_in : in STD_LOGIC;
    clk_200_in : in STD_LOGIC;
    clk_125_out : out STD_LOGIC;
    clk_100_out : out STD_LOGIC;
    reset_n : in STD_LOGIC;
    btnu : in STD_LOGIC;
    btnl : in STD_LOGIC;
    btnd : in STD_LOGIC;
    btnr : in STD_LOGIC;
    btnc : in STD_LOGIC;
    sw : in STD_LOGIC_VECTOR ( 7 downto 0 );
    led : out STD_LOGIC_VECTOR ( 7 downto 0 );
    phy_rx_clk : in STD_LOGIC;
    phy_rxd : in STD_LOGIC_VECTOR ( 3 downto 0 );
    phy_rx_ctl : in STD_LOGIC;
    phy_tx_clk : out STD_LOGIC;
    phy_txd : out STD_LOGIC_VECTOR ( 3 downto 0 );
    phy_tx_ctl : out STD_LOGIC;
    phy_reset_n : out STD_LOGIC;
    phy_int_n : in STD_LOGIC;
    phy_pme_n : in STD_LOGIC;
    s_ip_hdr_valid : in STD_LOGIC;
    s_ip_hdr_ready : out STD_LOGIC;
    s_ip_dscp : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_ip_ecn : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_ip_length : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_ip_ttl : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_ip_protocol : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_ip_source_ip : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_ip_dest_ip : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_ip_payload_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_ip_payload_axis_tvalid : in STD_LOGIC;
    s_ip_payload_axis_tready : out STD_LOGIC;
    s_ip_payload_axis_tlast : in STD_LOGIC;
    s_ip_payload_axis_tuser : in STD_LOGIC;
    m_ip_hdr_valid : out STD_LOGIC;
    m_ip_hdr_ready : in STD_LOGIC;
    m_ip_eth_dest_mac : out STD_LOGIC_VECTOR ( 47 downto 0 );
    m_ip_eth_src_mac : out STD_LOGIC_VECTOR ( 47 downto 0 );
    m_ip_eth_type : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_ip_version : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_ip_ihl : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_ip_dscp : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_ip_ecn : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_ip_length : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_ip_identification : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_ip_flags : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_ip_fragment_offset : out STD_LOGIC_VECTOR ( 12 downto 0 );
    m_ip_ttl : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_ip_protocol : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_ip_header_checksum : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_ip_source_ip : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_ip_dest_ip : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_ip_payload_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_ip_payload_axis_tvalid : out STD_LOGIC;
    m_ip_payload_axis_tready : in STD_LOGIC;
    m_ip_payload_axis_tlast : out STD_LOGIC;
    m_ip_payload_axis_tuser : out STD_LOGIC;
    s_udp_hdr_valid : in STD_LOGIC;
    s_udp_hdr_ready : out STD_LOGIC;
    s_udp_ip_dscp : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s_udp_ip_ecn : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_udp_ip_ttl : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_udp_ip_source_ip : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_udp_ip_dest_ip : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_udp_source_port : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_udp_dest_port : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_udp_length : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_udp_checksum : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_udp_payload_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_udp_payload_axis_tvalid : in STD_LOGIC;
    s_udp_payload_axis_tready : out STD_LOGIC;
    s_udp_payload_axis_tlast : in STD_LOGIC;
    s_udp_payload_axis_tuser : in STD_LOGIC;
    m_udp_hdr_valid : out STD_LOGIC;
    m_udp_hdr_ready : in STD_LOGIC;
    m_udp_eth_dest_mac : out STD_LOGIC_VECTOR ( 47 downto 0 );
    m_udp_eth_src_mac : out STD_LOGIC_VECTOR ( 47 downto 0 );
    m_udp_eth_type : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_udp_ip_version : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_udp_ip_ihl : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_udp_ip_dscp : out STD_LOGIC_VECTOR ( 5 downto 0 );
    m_udp_ip_ecn : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m_udp_ip_length : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_udp_ip_identification : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_udp_ip_flags : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_udp_ip_fragment_offset : out STD_LOGIC_VECTOR ( 12 downto 0 );
    m_udp_ip_ttl : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_udp_ip_protocol : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_udp_ip_header_checksum : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_udp_ip_source_ip : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_udp_ip_dest_ip : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_udp_source_port : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_udp_dest_port : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_udp_length : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_udp_checksum : out STD_LOGIC_VECTOR ( 15 downto 0 );
    m_udp_payload_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_udp_payload_axis_tvalid : out STD_LOGIC;
    m_udp_payload_axis_tready : in STD_LOGIC;
    m_udp_payload_axis_tlast : out STD_LOGIC;
    m_udp_payload_axis_tuser : out STD_LOGIC;
    ip_rx_busy : out STD_LOGIC;
    ip_tx_busy : out STD_LOGIC;
    udp_rx_busy : out STD_LOGIC;
    udp_tx_busy : out STD_LOGIC;
    ip_rx_error_header_early_termination : out STD_LOGIC;
    ip_rx_error_payload_early_termination : out STD_LOGIC;
    ip_rx_error_invalid_header : out STD_LOGIC;
    ip_rx_error_invalid_checksum : out STD_LOGIC;
    ip_tx_error_payload_early_termination : out STD_LOGIC;
    ip_tx_error_arp_failed : out STD_LOGIC;
    udp_rx_error_header_early_termination : out STD_LOGIC;
    udp_rx_error_payload_early_termination : out STD_LOGIC;
    udp_tx_error_payload_early_termination : out STD_LOGIC;
    m_ch1_audio_payload_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_ch1_audio_payload_axis_tvalid : out STD_LOGIC;
    m_ch1_audio_payload_axis_tready : in STD_LOGIC;
    m_ch1_audio_payload_axis_tlast : out STD_LOGIC;
    m_ch1_audio_payload_axis_tuser : out STD_LOGIC;
    m_ch1_audio_payload_hdr_valid : out STD_LOGIC;
    m_ch1_audio_payload_hdr_ready : in STD_LOGIC;
    s_audio_payload_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_audio_payload_axis_tvalid : in STD_LOGIC;
    s_audio_payload_axis_tready : out STD_LOGIC;
    s_audio_payload_axis_tlast : in STD_LOGIC;
    s_audio_payload_axis_tuser : in STD_LOGIC;
    udp_payload_length : in STD_LOGIC_VECTOR ( 15 downto 0 );
    fifo_full_in : in STD_LOGIC;
    fifo_empty_in : in STD_LOGIC;
    seq_status1_in : in STD_LOGIC;
    seq_status2_in : in STD_LOGIC;
    stream_reset_out : out STD_LOGIC;
    s_audio_payload_hdr_valid : in STD_LOGIC;
    s_audio_payload_hdr_ready : out STD_LOGIC;
    uart_rxd : in STD_LOGIC;
    uart_txd : out STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
  end component cantavi_streamer_project_full_udp_stack_ip_0_0;
  component cantavi_streamer_project_eth_to_audio_interfa_0_0 is
  port (
    audio_l_out : out STD_LOGIC_VECTOR ( 23 downto 0 );
    audio_r_out : out STD_LOGIC_VECTOR ( 23 downto 0 );
    fifo_occ_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    play_out_ready_out : out STD_LOGIC;
    replace_pkt_out : out STD_LOGIC;
    newsample_in : in STD_LOGIC;
    irq_out : out STD_LOGIC;
    fifo_full_out : out STD_LOGIC;
    fifo_empty_out : out STD_LOGIC;
    CLK_100 : in STD_LOGIC;
    CLK_125 : in STD_LOGIC;
    s_ch1_audio_payload_axis_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_ch1_audio_payload_axis_tvalid : in STD_LOGIC;
    s_ch1_audio_payload_axis_tready : out STD_LOGIC;
    s_ch1_audio_payload_axis_tlast : in STD_LOGIC;
    s_ch1_audio_payload_axis_tuser : in STD_LOGIC;
    s_ch1_audio_payload_hdr_ready : out STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_eth_to_audio_interfa_0_0;
  component cantavi_streamer_project_audio_to_eth_interfa_0_0 is
  port (
    line_in_l_in : in STD_LOGIC_VECTOR ( 23 downto 0 );
    line_in_r_in : in STD_LOGIC_VECTOR ( 23 downto 0 );
    newsample_in : in STD_LOGIC;
    irq_out : out STD_LOGIC;
    CLK_125 : in STD_LOGIC;
    m_audio_payload_axis_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_audio_payload_axis_tvalid : out STD_LOGIC;
    m_audio_payload_axis_tready : in STD_LOGIC;
    m_audio_payload_axis_tlast : out STD_LOGIC;
    m_audio_payload_axis_tuser : out STD_LOGIC;
    m_audio_payload_hdr_valid : out STD_LOGIC;
    m_audio_payload_hdr_ready : in STD_LOGIC;
    udp_payload_length : out STD_LOGIC_VECTOR ( 15 downto 0 );
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 6 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  end component cantavi_streamer_project_audio_to_eth_interfa_0_0;
  signal Button_1 : STD_LOGIC;
  signal FILTER_IIR_0_FILTER_DONE : STD_LOGIC;
  signal FILTER_IIR_1_FILTER_DONE : STD_LOGIC;
  signal Net1 : STD_LOGIC;
  signal Rotary_a_1 : STD_LOGIC;
  signal Switch_1 : STD_LOGIC;
  signal Volume_Pregain_0_OUT_RDY : STD_LOGIC;
  signal Volume_Pregain_0_OUT_VOLCTRL_L : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal Volume_Pregain_0_OUT_VOLCTRL_R : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal Volume_Pregain_1_OUT_RDY : STD_LOGIC;
  signal Volume_Pregain_1_OUT_VOLCTRL_L : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal Volume_Pregain_1_OUT_VOLCTRL_R : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal ZedCodec_line_in_l_125 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal ZedCodec_line_in_r_125 : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal ZedCodec_next_adc_sample : STD_LOGIC;
  signal ZedCodec_next_dac_sample : STD_LOGIC;
  signal ZedboardOLED_0_DC : STD_LOGIC;
  signal ZedboardOLED_0_RES : STD_LOGIC;
  signal ZedboardOLED_0_SCLK : STD_LOGIC;
  signal ZedboardOLED_0_SDIN : STD_LOGIC;
  signal ZedboardOLED_0_VBAT : STD_LOGIC;
  signal ZedboardOLED_0_VDD : STD_LOGIC;
  signal adau1761_controller_0_adau1761_cclk : STD_LOGIC;
  signal adau1761_controller_0_adau1761_cdata : STD_LOGIC;
  signal adau1761_controller_0_adau1761_clatchn : STD_LOGIC;
  signal adau1761_cout_0_1 : STD_LOGIC;
  signal audio_to_eth_interfa_0_irq_out : STD_LOGIC;
  signal audio_to_eth_interfa_0_m_audio_payload_axis_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal audio_to_eth_interfa_0_m_audio_payload_axis_TLAST : STD_LOGIC;
  signal audio_to_eth_interfa_0_m_audio_payload_axis_TREADY : STD_LOGIC;
  signal audio_to_eth_interfa_0_m_audio_payload_axis_TVALID : STD_LOGIC;
  signal audio_to_eth_interfa_0_m_audio_payload_hdr_valid : STD_LOGIC;
  signal audio_to_eth_interfa_0_udp_payload_length : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal axi_gpio_0_ip2intc_irpt : STD_LOGIC;
  signal axi_gpio_1_GPIO_TRI_I : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_gpio_1_ip2intc_irpt : STD_LOGIC;
  signal axi_gpio_2_ip2intc_irpt : STD_LOGIC;
  signal btnc_0_1 : STD_LOGIC;
  signal btnd_0_1 : STD_LOGIC;
  signal btnl_0_1 : STD_LOGIC;
  signal btnr_0_1 : STD_LOGIC;
  signal btnu_0_1 : STD_LOGIC;
  signal clk_wiz_0_clk_100_out : STD_LOGIC;
  signal clk_wiz_0_clk_125_out1 : STD_LOGIC;
  signal eth_to_audio_interfa_0_audio_l_out : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal eth_to_audio_interfa_0_audio_r_out : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal eth_to_audio_interfa_0_fifo_empty_out : STD_LOGIC;
  signal eth_to_audio_interfa_0_fifo_full_out : STD_LOGIC;
  signal eth_to_audio_interfa_0_irq_out : STD_LOGIC;
  signal eth_to_audio_interfa_0_replace_pkt_out : STD_LOGIC;
  signal eth_to_audio_interfa_0_s_ch1_audio_payload_hdr_ready : STD_LOGIC;
  signal full_udp_stack_ip_0_clk_100_out : STD_LOGIC;
  signal full_udp_stack_ip_0_led : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal full_udp_stack_ip_0_m_ch1_audio_payload_axis_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal full_udp_stack_ip_0_m_ch1_audio_payload_axis_TLAST : STD_LOGIC;
  signal full_udp_stack_ip_0_m_ch1_audio_payload_axis_TREADY : STD_LOGIC;
  signal full_udp_stack_ip_0_m_ch1_audio_payload_axis_TVALID : STD_LOGIC;
  signal full_udp_stack_ip_0_phy_reset_n : STD_LOGIC;
  signal full_udp_stack_ip_0_phy_tx_clk : STD_LOGIC;
  signal full_udp_stack_ip_0_phy_tx_ctl : STD_LOGIC;
  signal full_udp_stack_ip_0_phy_txd : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal full_udp_stack_ip_0_s_audio_payload_hdr_ready : STD_LOGIC;
  signal full_udp_stack_ip_0_uart_txd : STD_LOGIC;
  signal i2s_transmitter_0_sd : STD_LOGIC;
  signal mixer_0_audio_mixed_a_b_left_out : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal mixer_0_audio_mixed_a_b_right_out : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal phy_int_n_0_1 : STD_LOGIC;
  signal phy_pme_n_0_1 : STD_LOGIC;
  signal phy_rx_clk_0_1 : STD_LOGIC;
  signal phy_rx_ctl_0_1 : STD_LOGIC;
  signal phy_rxd_0_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal pmod_controller_0_Rotary_event : STD_LOGIC;
  signal processing_system7_0_DDR_ADDR : STD_LOGIC_VECTOR ( 14 downto 0 );
  signal processing_system7_0_DDR_BA : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal processing_system7_0_DDR_CAS_N : STD_LOGIC;
  signal processing_system7_0_DDR_CKE : STD_LOGIC;
  signal processing_system7_0_DDR_CK_N : STD_LOGIC;
  signal processing_system7_0_DDR_CK_P : STD_LOGIC;
  signal processing_system7_0_DDR_CS_N : STD_LOGIC;
  signal processing_system7_0_DDR_DM : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_DDR_DQ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal processing_system7_0_DDR_DQS_N : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_DDR_DQS_P : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_DDR_ODT : STD_LOGIC;
  signal processing_system7_0_DDR_RAS_N : STD_LOGIC;
  signal processing_system7_0_DDR_RESET_N : STD_LOGIC;
  signal processing_system7_0_DDR_WE_N : STD_LOGIC;
  signal processing_system7_0_FCLK_CLK1 : STD_LOGIC;
  signal processing_system7_0_FCLK_CLK2 : STD_LOGIC;
  signal processing_system7_0_FCLK_CLK3 : STD_LOGIC;
  signal processing_system7_0_FCLK_RESET0_N : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_DDR_VRN : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_DDR_VRP : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_MIO : STD_LOGIC_VECTOR ( 53 downto 0 );
  signal processing_system7_0_FIXED_IO_PS_CLK : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_PS_PORB : STD_LOGIC;
  signal processing_system7_0_FIXED_IO_PS_SRSTB : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARLEN : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARLOCK : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARREADY : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_ARSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal processing_system7_0_M_AXI_GP0_ARVALID : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWBURST : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWCACHE : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWLEN : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWLOCK : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWQOS : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWREADY : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_AWSIZE : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal processing_system7_0_M_AXI_GP0_AWVALID : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_BID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal processing_system7_0_M_AXI_GP0_BREADY : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal processing_system7_0_M_AXI_GP0_BVALID : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal processing_system7_0_M_AXI_GP0_RID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal processing_system7_0_M_AXI_GP0_RLAST : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_RREADY : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal processing_system7_0_M_AXI_GP0_RVALID : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal processing_system7_0_M_AXI_GP0_WID : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal processing_system7_0_M_AXI_GP0_WLAST : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_WREADY : STD_LOGIC;
  signal processing_system7_0_M_AXI_GP0_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal processing_system7_0_M_AXI_GP0_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M00_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M00_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M00_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M00_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M00_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M00_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M00_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M00_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M00_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M00_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M00_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M00_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M00_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M00_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M00_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M00_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M00_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M01_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M01_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M01_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M02_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M02_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M03_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M03_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M04_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M04_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M05_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M05_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M06_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M06_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M07_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M07_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M07_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M07_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M07_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M07_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M07_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M07_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M07_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M07_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M07_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M08_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M08_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M08_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M08_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M08_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M08_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M08_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M08_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M08_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M08_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M08_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M08_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M08_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M08_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M08_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M08_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M08_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M09_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M09_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M09_AXI_ARVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M09_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M09_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M09_AXI_AWVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M09_AXI_BREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M09_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M09_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M09_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M09_AXI_RREADY : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M09_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M09_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M09_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M09_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M09_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M09_AXI_WVALID : STD_LOGIC_VECTOR ( 0 to 0 );
  signal ps7_0_axi_periph_M10_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M10_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M10_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M11_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M11_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M12_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M12_AXI_WVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_ARADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_ARPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_ARREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_ARVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_AWADDR : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_AWPROT : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_AWREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_AWVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_BREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_BRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_BVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_RDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_RREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_RRESP : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_RVALID : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_WDATA : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_WREADY : STD_LOGIC;
  signal ps7_0_axi_periph_M13_AXI_WSTRB : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal ps7_0_axi_periph_M13_AXI_WVALID : STD_LOGIC;
  signal rst_ps7_0_100M_interconnect_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  signal rst_ps7_0_100M_peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
  signal uart_rxd_0_1 : STD_LOGIC;
  signal user_org_plc_seq_ip_0_fifo_empty_out : STD_LOGIC;
  signal user_org_plc_seq_ip_0_fifo_full_out : STD_LOGIC;
  signal user_org_plc_seq_ip_0_status1_out : STD_LOGIC;
  signal user_org_plc_seq_ip_0_status2_out : STD_LOGIC;
  signal user_org_plc_seq_ip_0_to_audio_m_axis_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal user_org_plc_seq_ip_0_to_audio_m_axis_TLAST : STD_LOGIC;
  signal user_org_plc_seq_ip_0_to_audio_m_axis_TREADY : STD_LOGIC;
  signal user_org_plc_seq_ip_0_to_audio_m_axis_TVALID : STD_LOGIC;
  signal user_org_plc_seq_ip_0_to_udp_hdr_valid : STD_LOGIC;
  signal user_org_plc_seq_ip_0_to_udp_m_axis_TDATA : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal user_org_plc_seq_ip_0_to_udp_m_axis_TLAST : STD_LOGIC;
  signal user_org_plc_seq_ip_0_to_udp_m_axis_TREADY : STD_LOGIC;
  signal user_org_plc_seq_ip_0_to_udp_m_axis_TVALID : STD_LOGIC;
  signal xlconcat_0_dout : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal NLW_FILTER_IIR_0_AUDIO_OUT_L_UNCONNECTED : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal NLW_FILTER_IIR_0_AUDIO_OUT_R_UNCONNECTED : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal NLW_FILTER_IIR_1_AUDIO_OUT_L_UNCONNECTED : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal NLW_FILTER_IIR_1_AUDIO_OUT_R_UNCONNECTED : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal NLW_audio_to_eth_interfa_0_m_audio_payload_axis_tuser_UNCONNECTED : STD_LOGIC;
  signal NLW_axi_gpio_2_gpio_io_o_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_eth_to_audio_interfa_0_play_out_ready_out_UNCONNECTED : STD_LOGIC;
  signal NLW_eth_to_audio_interfa_0_fifo_occ_out_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_ip_rx_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_ip_rx_error_header_early_termination_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_ip_rx_error_invalid_checksum_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_ip_rx_error_invalid_header_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_ip_rx_error_payload_early_termination_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_ip_tx_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_ip_tx_error_arp_failed_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_ip_tx_error_payload_early_termination_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_ch1_audio_payload_axis_tuser_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_ch1_audio_payload_hdr_valid_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_ip_hdr_valid_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_ip_payload_axis_tlast_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_ip_payload_axis_tuser_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_ip_payload_axis_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_udp_hdr_valid_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_udp_payload_axis_tlast_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_udp_payload_axis_tuser_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_udp_payload_axis_tvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_s_ip_hdr_ready_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_s_ip_payload_axis_tready_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_s_udp_hdr_ready_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_s_udp_payload_axis_tready_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_udp_rx_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_udp_rx_error_header_early_termination_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_udp_rx_error_payload_early_termination_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_udp_tx_busy_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_udp_tx_error_payload_early_termination_UNCONNECTED : STD_LOGIC;
  signal NLW_full_udp_stack_ip_0_m_ip_dest_ip_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_dscp_UNCONNECTED : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_ecn_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_eth_dest_mac_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_eth_src_mac_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_eth_type_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_flags_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_fragment_offset_UNCONNECTED : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_header_checksum_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_identification_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_ihl_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_length_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_payload_axis_tdata_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_protocol_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_source_ip_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_ttl_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_ip_version_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_checksum_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_dest_port_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_eth_dest_mac_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_eth_src_mac_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_eth_type_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_dest_ip_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_dscp_UNCONNECTED : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_ecn_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_flags_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_fragment_offset_UNCONNECTED : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_header_checksum_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_identification_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_ihl_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_length_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_protocol_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_source_ip_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_ttl_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_ip_version_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_length_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_payload_axis_tdata_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal NLW_full_udp_stack_ip_0_m_udp_source_port_UNCONNECTED : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal NLW_processing_system7_0_TTC0_WAVE0_OUT_UNCONNECTED : STD_LOGIC;
  signal NLW_processing_system7_0_TTC0_WAVE1_OUT_UNCONNECTED : STD_LOGIC;
  signal NLW_processing_system7_0_TTC0_WAVE2_OUT_UNCONNECTED : STD_LOGIC;
  signal NLW_processing_system7_0_USB0_VBUS_PWRSELECT_UNCONNECTED : STD_LOGIC;
  signal NLW_processing_system7_0_USB0_PORT_INDCTL_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_rst_ps7_0_100M_mb_reset_UNCONNECTED : STD_LOGIC;
  signal NLW_rst_ps7_0_100M_bus_struct_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  signal NLW_rst_ps7_0_100M_peripheral_reset_UNCONNECTED : STD_LOGIC_VECTOR ( 0 to 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of DDR_cas_n : signal is "xilinx.com:interface:ddrx:1.0 DDR CAS_N";
  attribute X_INTERFACE_INFO of DDR_ck_n : signal is "xilinx.com:interface:ddrx:1.0 DDR CK_N";
  attribute X_INTERFACE_INFO of DDR_ck_p : signal is "xilinx.com:interface:ddrx:1.0 DDR CK_P";
  attribute X_INTERFACE_INFO of DDR_cke : signal is "xilinx.com:interface:ddrx:1.0 DDR CKE";
  attribute X_INTERFACE_INFO of DDR_cs_n : signal is "xilinx.com:interface:ddrx:1.0 DDR CS_N";
  attribute X_INTERFACE_INFO of DDR_odt : signal is "xilinx.com:interface:ddrx:1.0 DDR ODT";
  attribute X_INTERFACE_INFO of DDR_ras_n : signal is "xilinx.com:interface:ddrx:1.0 DDR RAS_N";
  attribute X_INTERFACE_INFO of DDR_reset_n : signal is "xilinx.com:interface:ddrx:1.0 DDR RESET_N";
  attribute X_INTERFACE_INFO of DDR_we_n : signal is "xilinx.com:interface:ddrx:1.0 DDR WE_N";
  attribute X_INTERFACE_INFO of FIXED_IO_ddr_vrn : signal is "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO DDR_VRN";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of FIXED_IO_ddr_vrn : signal is "XIL_INTERFACENAME FIXED_IO, CAN_DEBUG false";
  attribute X_INTERFACE_INFO of FIXED_IO_ddr_vrp : signal is "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO DDR_VRP";
  attribute X_INTERFACE_INFO of FIXED_IO_ps_clk : signal is "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_CLK";
  attribute X_INTERFACE_INFO of FIXED_IO_ps_porb : signal is "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_PORB";
  attribute X_INTERFACE_INFO of FIXED_IO_ps_srstb : signal is "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_SRSTB";
  attribute X_INTERFACE_INFO of clk_100_in : signal is "xilinx.com:signal:clock:1.0 CLK.CLK_100_IN CLK";
  attribute X_INTERFACE_PARAMETER of clk_100_in : signal is "XIL_INTERFACENAME CLK.CLK_100_IN, CLK_DOMAIN cantavi_streamer_project_clk_100_in, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000";
  attribute X_INTERFACE_INFO of phy_rx_clk_0 : signal is "xilinx.com:signal:clock:1.0 CLK.PHY_RX_CLK_0 CLK";
  attribute X_INTERFACE_PARAMETER of phy_rx_clk_0 : signal is "XIL_INTERFACENAME CLK.PHY_RX_CLK_0, CLK_DOMAIN cantavi_streamer_project_phy_rx_clk_0, FREQ_HZ 125000000, INSERT_VIP 0, PHASE 0.000";
  attribute X_INTERFACE_INFO of DDR_addr : signal is "xilinx.com:interface:ddrx:1.0 DDR ADDR";
  attribute X_INTERFACE_PARAMETER of DDR_addr : signal is "XIL_INTERFACENAME DDR, AXI_ARBITRATION_SCHEME TDM, BURST_LENGTH 8, CAN_DEBUG false, CAS_LATENCY 11, CAS_WRITE_LATENCY 11, CS_ENABLED true, DATA_MASK_ENABLED true, DATA_WIDTH 8, MEMORY_TYPE COMPONENTS, MEM_ADDR_MAP ROW_COLUMN_BANK, SLOT Single, TIMEPERIOD_PS 1250";
  attribute X_INTERFACE_INFO of DDR_ba : signal is "xilinx.com:interface:ddrx:1.0 DDR BA";
  attribute X_INTERFACE_INFO of DDR_dm : signal is "xilinx.com:interface:ddrx:1.0 DDR DM";
  attribute X_INTERFACE_INFO of DDR_dq : signal is "xilinx.com:interface:ddrx:1.0 DDR DQ";
  attribute X_INTERFACE_INFO of DDR_dqs_n : signal is "xilinx.com:interface:ddrx:1.0 DDR DQS_N";
  attribute X_INTERFACE_INFO of DDR_dqs_p : signal is "xilinx.com:interface:ddrx:1.0 DDR DQS_P";
  attribute X_INTERFACE_INFO of FIXED_IO_mio : signal is "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO MIO";
  attribute X_INTERFACE_INFO of sws_8bits_tri_i : signal is "xilinx.com:interface:gpio:1.0 sws_8bits TRI_I";
begin
  Button_1 <= Button;
  DC <= ZedboardOLED_0_DC;
  RES <= ZedboardOLED_0_RES;
  Rotary_a_1 <= Rotary_a;
  SCLK <= ZedboardOLED_0_SCLK;
  SDIN <= ZedboardOLED_0_SDIN;
  Switch_1 <= Switch;
  VBAT <= ZedboardOLED_0_VBAT;
  VDD <= ZedboardOLED_0_VDD;
  adau1761_cclk_0 <= adau1761_controller_0_adau1761_cclk;
  adau1761_cdata_0 <= adau1761_controller_0_adau1761_cdata;
  adau1761_clatchn_0 <= adau1761_controller_0_adau1761_clatchn;
  adau1761_cout_0_1 <= adau1761_cout_0;
  adau1761_dac_sdata_0 <= i2s_transmitter_0_sd;
  axi_gpio_1_GPIO_TRI_I(7 downto 0) <= sws_8bits_tri_i(7 downto 0);
  btnc_0_1 <= btnc_0;
  btnd_0_1 <= btnd_0;
  btnl_0_1 <= btnl_0;
  btnr_0_1 <= btnr_0;
  btnu_0_1 <= btnu_0;
  led_0(7 downto 0) <= full_udp_stack_ip_0_led(7 downto 0);
  phy_int_n_0_1 <= phy_int_n_0;
  phy_pme_n_0_1 <= phy_pme_n_0;
  phy_reset_n_0 <= full_udp_stack_ip_0_phy_reset_n;
  phy_rx_clk_0_1 <= phy_rx_clk_0;
  phy_rx_ctl_0_1 <= phy_rx_ctl_0;
  phy_rxd_0_1(3 downto 0) <= phy_rxd_0(3 downto 0);
  phy_tx_clk_0 <= full_udp_stack_ip_0_phy_tx_clk;
  phy_tx_ctl_0 <= full_udp_stack_ip_0_phy_tx_ctl;
  phy_txd_0(3 downto 0) <= full_udp_stack_ip_0_phy_txd(3 downto 0);
  uart_rxd_0_1 <= uart_rxd_0;
  uart_txd_0 <= full_udp_stack_ip_0_uart_txd;
FILTER_IIR_0: component cantavi_streamer_project_FILTER_IIR_0_0
     port map (
      AUDIO_IN_L(23 downto 0) => B"000000000000000000000000",
      AUDIO_IN_R(23 downto 0) => B"000000000000000000000000",
      AUDIO_OUT_L(23 downto 0) => NLW_FILTER_IIR_0_AUDIO_OUT_L_UNCONNECTED(23 downto 0),
      AUDIO_OUT_R(23 downto 0) => NLW_FILTER_IIR_0_AUDIO_OUT_R_UNCONNECTED(23 downto 0),
      FILTER_DONE => FILTER_IIR_0_FILTER_DONE,
      SAMPLE_TRIG => Volume_Pregain_0_OUT_RDY,
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(6 downto 0) => ps7_0_axi_periph_M01_AXI_ARADDR(6 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M01_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M01_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M01_AXI_ARVALID,
      s00_axi_awaddr(6 downto 0) => ps7_0_axi_periph_M01_AXI_AWADDR(6 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M01_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M01_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M01_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M01_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M01_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M01_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M01_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M01_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M01_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M01_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M01_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M01_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M01_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M01_AXI_WVALID
    );
FILTER_IIR_1: component cantavi_streamer_project_FILTER_IIR_1_0
     port map (
      AUDIO_IN_L(23 downto 0) => B"000000000000000000000000",
      AUDIO_IN_R(23 downto 0) => B"000000000000000000000000",
      AUDIO_OUT_L(23 downto 0) => NLW_FILTER_IIR_1_AUDIO_OUT_L_UNCONNECTED(23 downto 0),
      AUDIO_OUT_R(23 downto 0) => NLW_FILTER_IIR_1_AUDIO_OUT_R_UNCONNECTED(23 downto 0),
      FILTER_DONE => FILTER_IIR_1_FILTER_DONE,
      SAMPLE_TRIG => Volume_Pregain_1_OUT_RDY,
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(6 downto 0) => ps7_0_axi_periph_M05_AXI_ARADDR(6 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M05_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M05_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M05_AXI_ARVALID,
      s00_axi_awaddr(6 downto 0) => ps7_0_axi_periph_M05_AXI_AWADDR(6 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M05_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M05_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M05_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M05_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M05_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M05_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M05_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M05_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M05_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M05_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M05_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M05_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M05_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M05_AXI_WVALID
    );
Volume_Pregain_0: component cantavi_streamer_project_Volume_Pregain_0_0
     port map (
      IN_SIG_L(23 downto 0) => ZedCodec_line_in_l_125(23 downto 0),
      IN_SIG_R(23 downto 0) => ZedCodec_line_in_r_125(23 downto 0),
      OUT_RDY => Volume_Pregain_0_OUT_RDY,
      OUT_VOLCTRL_L(23 downto 0) => Volume_Pregain_0_OUT_VOLCTRL_L(23 downto 0),
      OUT_VOLCTRL_R(23 downto 0) => Volume_Pregain_0_OUT_VOLCTRL_R(23 downto 0),
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(3 downto 0) => ps7_0_axi_periph_M02_AXI_ARADDR(3 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M02_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M02_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M02_AXI_ARVALID,
      s00_axi_awaddr(3 downto 0) => ps7_0_axi_periph_M02_AXI_AWADDR(3 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M02_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M02_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M02_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M02_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M02_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M02_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M02_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M02_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M02_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M02_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M02_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M02_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M02_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M02_AXI_WVALID
    );
Volume_Pregain_1: component cantavi_streamer_project_Volume_Pregain_1_1
     port map (
      IN_SIG_L(23 downto 0) => eth_to_audio_interfa_0_audio_l_out(23 downto 0),
      IN_SIG_R(23 downto 0) => eth_to_audio_interfa_0_audio_r_out(23 downto 0),
      OUT_RDY => Volume_Pregain_1_OUT_RDY,
      OUT_VOLCTRL_L(23 downto 0) => Volume_Pregain_1_OUT_VOLCTRL_L(23 downto 0),
      OUT_VOLCTRL_R(23 downto 0) => Volume_Pregain_1_OUT_VOLCTRL_R(23 downto 0),
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(3 downto 0) => ps7_0_axi_periph_M04_AXI_ARADDR(3 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M04_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M04_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M04_AXI_ARVALID,
      s00_axi_awaddr(3 downto 0) => ps7_0_axi_periph_M04_AXI_AWADDR(3 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M04_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M04_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M04_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M04_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M04_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M04_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M04_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M04_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M04_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M04_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M04_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M04_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M04_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M04_AXI_WVALID
    );
ZedCodec: entity work.ZedCodec_imp_DC5242
     port map (
      S00_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M13_AXI_ARADDR(31 downto 0),
      S00_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M13_AXI_ARPROT(2 downto 0),
      S00_AXI_arready => ps7_0_axi_periph_M13_AXI_ARREADY,
      S00_AXI_arvalid => ps7_0_axi_periph_M13_AXI_ARVALID,
      S00_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M13_AXI_AWADDR(31 downto 0),
      S00_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M13_AXI_AWPROT(2 downto 0),
      S00_AXI_awready => ps7_0_axi_periph_M13_AXI_AWREADY,
      S00_AXI_awvalid => ps7_0_axi_periph_M13_AXI_AWVALID,
      S00_AXI_bready => ps7_0_axi_periph_M13_AXI_BREADY,
      S00_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M13_AXI_BRESP(1 downto 0),
      S00_AXI_bvalid => ps7_0_axi_periph_M13_AXI_BVALID,
      S00_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M13_AXI_RDATA(31 downto 0),
      S00_AXI_rready => ps7_0_axi_periph_M13_AXI_RREADY,
      S00_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M13_AXI_RRESP(1 downto 0),
      S00_AXI_rvalid => ps7_0_axi_periph_M13_AXI_RVALID,
      S00_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M13_AXI_WDATA(31 downto 0),
      S00_AXI_wready => ps7_0_axi_periph_M13_AXI_WREADY,
      S00_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M13_AXI_WSTRB(3 downto 0),
      S00_AXI_wvalid => ps7_0_axi_periph_M13_AXI_WVALID,
      adau1761_adc_sdata_0 => adau1761_adc_sdata_0,
      adau1761_bclk_0 => adau1761_bclk_0,
      adau1761_cclk_0 => adau1761_controller_0_adau1761_cclk,
      adau1761_cdata_0 => adau1761_controller_0_adau1761_cdata,
      adau1761_clatchn_0 => adau1761_controller_0_adau1761_clatchn,
      adau1761_cout_0 => adau1761_cout_0_1,
      adau1761_dac_sdata_0 => i2s_transmitter_0_sd,
      adau1761_lrclk_0 => adau1761_lrclk_0,
      clk_125 => clk_wiz_0_clk_125_out1,
      hphone_l(23 downto 0) => mixer_0_audio_mixed_a_b_left_out(23 downto 0),
      hphone_r(23 downto 0) => mixer_0_audio_mixed_a_b_right_out(23 downto 0),
      line_in_l_125(23 downto 0) => ZedCodec_line_in_l_125(23 downto 0),
      line_in_r_125(23 downto 0) => ZedCodec_line_in_r_125(23 downto 0),
      next_adc_sample => ZedCodec_next_adc_sample,
      next_dac_sample => ZedCodec_next_dac_sample,
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0)
    );
ZedboardOLED_0: component cantavi_streamer_project_ZedboardOLED_0_0
     port map (
      DC => ZedboardOLED_0_DC,
      RES => ZedboardOLED_0_RES,
      SCLK => ZedboardOLED_0_SCLK,
      SDIN => ZedboardOLED_0_SDIN,
      VBAT => ZedboardOLED_0_VBAT,
      VDD => ZedboardOLED_0_VDD,
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(6 downto 0) => ps7_0_axi_periph_M03_AXI_ARADDR(6 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M03_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M03_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M03_AXI_ARVALID,
      s00_axi_awaddr(6 downto 0) => ps7_0_axi_periph_M03_AXI_AWADDR(6 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M03_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M03_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M03_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M03_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M03_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M03_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M03_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M03_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M03_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M03_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M03_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M03_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M03_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M03_AXI_WVALID
    );
audio_to_eth_interfa_0: component cantavi_streamer_project_audio_to_eth_interfa_0_0
     port map (
      CLK_125 => clk_wiz_0_clk_125_out1,
      irq_out => audio_to_eth_interfa_0_irq_out,
      line_in_l_in(23 downto 0) => ZedCodec_line_in_l_125(23 downto 0),
      line_in_r_in(23 downto 0) => ZedCodec_line_in_r_125(23 downto 0),
      m_audio_payload_axis_tdata(7 downto 0) => audio_to_eth_interfa_0_m_audio_payload_axis_TDATA(7 downto 0),
      m_audio_payload_axis_tlast => audio_to_eth_interfa_0_m_audio_payload_axis_TLAST,
      m_audio_payload_axis_tready => audio_to_eth_interfa_0_m_audio_payload_axis_TREADY,
      m_audio_payload_axis_tuser => NLW_audio_to_eth_interfa_0_m_audio_payload_axis_tuser_UNCONNECTED,
      m_audio_payload_axis_tvalid => audio_to_eth_interfa_0_m_audio_payload_axis_TVALID,
      m_audio_payload_hdr_ready => full_udp_stack_ip_0_s_audio_payload_hdr_ready,
      m_audio_payload_hdr_valid => audio_to_eth_interfa_0_m_audio_payload_hdr_valid,
      newsample_in => ZedCodec_next_adc_sample,
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(6 downto 0) => ps7_0_axi_periph_M10_AXI_ARADDR(6 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M10_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M10_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M10_AXI_ARVALID,
      s00_axi_awaddr(6 downto 0) => ps7_0_axi_periph_M10_AXI_AWADDR(6 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M10_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M10_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M10_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M10_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M10_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M10_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M10_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M10_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M10_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M10_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M10_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M10_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M10_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M10_AXI_WVALID,
      udp_payload_length(15 downto 0) => audio_to_eth_interfa_0_udp_payload_length(15 downto 0)
    );
axi_gpio_0: component cantavi_streamer_project_axi_gpio_0_2
     port map (
      gpio_io_i(4 downto 0) => B"00000",
      ip2intc_irpt => axi_gpio_0_ip2intc_irpt,
      s_axi_aclk => clk_wiz_0_clk_100_out,
      s_axi_araddr(8 downto 0) => ps7_0_axi_periph_M00_AXI_ARADDR(8 downto 0),
      s_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s_axi_arready => ps7_0_axi_periph_M00_AXI_ARREADY,
      s_axi_arvalid => ps7_0_axi_periph_M00_AXI_ARVALID(0),
      s_axi_awaddr(8 downto 0) => ps7_0_axi_periph_M00_AXI_AWADDR(8 downto 0),
      s_axi_awready => ps7_0_axi_periph_M00_AXI_AWREADY,
      s_axi_awvalid => ps7_0_axi_periph_M00_AXI_AWVALID(0),
      s_axi_bready => ps7_0_axi_periph_M00_AXI_BREADY(0),
      s_axi_bresp(1 downto 0) => ps7_0_axi_periph_M00_AXI_BRESP(1 downto 0),
      s_axi_bvalid => ps7_0_axi_periph_M00_AXI_BVALID,
      s_axi_rdata(31 downto 0) => ps7_0_axi_periph_M00_AXI_RDATA(31 downto 0),
      s_axi_rready => ps7_0_axi_periph_M00_AXI_RREADY(0),
      s_axi_rresp(1 downto 0) => ps7_0_axi_periph_M00_AXI_RRESP(1 downto 0),
      s_axi_rvalid => ps7_0_axi_periph_M00_AXI_RVALID,
      s_axi_wdata(31 downto 0) => ps7_0_axi_periph_M00_AXI_WDATA(31 downto 0),
      s_axi_wready => ps7_0_axi_periph_M00_AXI_WREADY,
      s_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M00_AXI_WSTRB(3 downto 0),
      s_axi_wvalid => ps7_0_axi_periph_M00_AXI_WVALID(0)
    );
axi_gpio_1: component cantavi_streamer_project_axi_gpio_1_0
     port map (
      gpio_io_i(7 downto 0) => axi_gpio_1_GPIO_TRI_I(7 downto 0),
      ip2intc_irpt => axi_gpio_1_ip2intc_irpt,
      s_axi_aclk => clk_wiz_0_clk_100_out,
      s_axi_araddr(8 downto 0) => ps7_0_axi_periph_M08_AXI_ARADDR(8 downto 0),
      s_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s_axi_arready => ps7_0_axi_periph_M08_AXI_ARREADY,
      s_axi_arvalid => ps7_0_axi_periph_M08_AXI_ARVALID(0),
      s_axi_awaddr(8 downto 0) => ps7_0_axi_periph_M08_AXI_AWADDR(8 downto 0),
      s_axi_awready => ps7_0_axi_periph_M08_AXI_AWREADY,
      s_axi_awvalid => ps7_0_axi_periph_M08_AXI_AWVALID(0),
      s_axi_bready => ps7_0_axi_periph_M08_AXI_BREADY(0),
      s_axi_bresp(1 downto 0) => ps7_0_axi_periph_M08_AXI_BRESP(1 downto 0),
      s_axi_bvalid => ps7_0_axi_periph_M08_AXI_BVALID,
      s_axi_rdata(31 downto 0) => ps7_0_axi_periph_M08_AXI_RDATA(31 downto 0),
      s_axi_rready => ps7_0_axi_periph_M08_AXI_RREADY(0),
      s_axi_rresp(1 downto 0) => ps7_0_axi_periph_M08_AXI_RRESP(1 downto 0),
      s_axi_rvalid => ps7_0_axi_periph_M08_AXI_RVALID,
      s_axi_wdata(31 downto 0) => ps7_0_axi_periph_M08_AXI_WDATA(31 downto 0),
      s_axi_wready => ps7_0_axi_periph_M08_AXI_WREADY,
      s_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M08_AXI_WSTRB(3 downto 0),
      s_axi_wvalid => ps7_0_axi_periph_M08_AXI_WVALID(0)
    );
axi_gpio_2: component cantavi_streamer_project_axi_gpio_2_0
     port map (
      gpio_io_o(7 downto 0) => NLW_axi_gpio_2_gpio_io_o_UNCONNECTED(7 downto 0),
      ip2intc_irpt => axi_gpio_2_ip2intc_irpt,
      s_axi_aclk => clk_wiz_0_clk_100_out,
      s_axi_araddr(8 downto 0) => ps7_0_axi_periph_M09_AXI_ARADDR(8 downto 0),
      s_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s_axi_arready => ps7_0_axi_periph_M09_AXI_ARREADY,
      s_axi_arvalid => ps7_0_axi_periph_M09_AXI_ARVALID(0),
      s_axi_awaddr(8 downto 0) => ps7_0_axi_periph_M09_AXI_AWADDR(8 downto 0),
      s_axi_awready => ps7_0_axi_periph_M09_AXI_AWREADY,
      s_axi_awvalid => ps7_0_axi_periph_M09_AXI_AWVALID(0),
      s_axi_bready => ps7_0_axi_periph_M09_AXI_BREADY(0),
      s_axi_bresp(1 downto 0) => ps7_0_axi_periph_M09_AXI_BRESP(1 downto 0),
      s_axi_bvalid => ps7_0_axi_periph_M09_AXI_BVALID,
      s_axi_rdata(31 downto 0) => ps7_0_axi_periph_M09_AXI_RDATA(31 downto 0),
      s_axi_rready => ps7_0_axi_periph_M09_AXI_RREADY(0),
      s_axi_rresp(1 downto 0) => ps7_0_axi_periph_M09_AXI_RRESP(1 downto 0),
      s_axi_rvalid => ps7_0_axi_periph_M09_AXI_RVALID,
      s_axi_wdata(31 downto 0) => ps7_0_axi_periph_M09_AXI_WDATA(31 downto 0),
      s_axi_wready => ps7_0_axi_periph_M09_AXI_WREADY,
      s_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M09_AXI_WSTRB(3 downto 0),
      s_axi_wvalid => ps7_0_axi_periph_M09_AXI_WVALID(0)
    );
eth_to_audio_interfa_0: component cantavi_streamer_project_eth_to_audio_interfa_0_0
     port map (
      CLK_100 => full_udp_stack_ip_0_clk_100_out,
      CLK_125 => clk_wiz_0_clk_125_out1,
      audio_l_out(23 downto 0) => eth_to_audio_interfa_0_audio_l_out(23 downto 0),
      audio_r_out(23 downto 0) => eth_to_audio_interfa_0_audio_r_out(23 downto 0),
      fifo_empty_out => eth_to_audio_interfa_0_fifo_empty_out,
      fifo_full_out => eth_to_audio_interfa_0_fifo_full_out,
      fifo_occ_out(15 downto 0) => NLW_eth_to_audio_interfa_0_fifo_occ_out_UNCONNECTED(15 downto 0),
      irq_out => eth_to_audio_interfa_0_irq_out,
      newsample_in => ZedCodec_next_dac_sample,
      play_out_ready_out => NLW_eth_to_audio_interfa_0_play_out_ready_out_UNCONNECTED,
      replace_pkt_out => eth_to_audio_interfa_0_replace_pkt_out,
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(5 downto 0) => ps7_0_axi_periph_M06_AXI_ARADDR(5 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M06_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M06_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M06_AXI_ARVALID,
      s00_axi_awaddr(5 downto 0) => ps7_0_axi_periph_M06_AXI_AWADDR(5 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M06_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M06_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M06_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M06_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M06_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M06_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M06_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M06_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M06_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M06_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M06_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M06_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M06_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M06_AXI_WVALID,
      s_ch1_audio_payload_axis_tdata(7 downto 0) => user_org_plc_seq_ip_0_to_audio_m_axis_TDATA(7 downto 0),
      s_ch1_audio_payload_axis_tlast => user_org_plc_seq_ip_0_to_audio_m_axis_TLAST,
      s_ch1_audio_payload_axis_tready => user_org_plc_seq_ip_0_to_audio_m_axis_TREADY,
      s_ch1_audio_payload_axis_tuser => '0',
      s_ch1_audio_payload_axis_tvalid => user_org_plc_seq_ip_0_to_audio_m_axis_TVALID,
      s_ch1_audio_payload_hdr_ready => eth_to_audio_interfa_0_s_ch1_audio_payload_hdr_ready
    );
full_udp_stack_ip_0: component cantavi_streamer_project_full_udp_stack_ip_0_0
     port map (
      btnc => btnc_0_1,
      btnd => btnd_0_1,
      btnl => btnl_0_1,
      btnr => btnr_0_1,
      btnu => btnu_0_1,
      clk_100_in => clk_wiz_0_clk_100_out,
      clk_100_out => full_udp_stack_ip_0_clk_100_out,
      clk_125_in => processing_system7_0_FCLK_CLK2,
      clk_125_out => clk_wiz_0_clk_125_out1,
      clk_200_in => processing_system7_0_FCLK_CLK3,
      clk_90_in => processing_system7_0_FCLK_CLK1,
      fifo_empty_in => user_org_plc_seq_ip_0_fifo_empty_out,
      fifo_full_in => user_org_plc_seq_ip_0_fifo_full_out,
      ip_rx_busy => NLW_full_udp_stack_ip_0_ip_rx_busy_UNCONNECTED,
      ip_rx_error_header_early_termination => NLW_full_udp_stack_ip_0_ip_rx_error_header_early_termination_UNCONNECTED,
      ip_rx_error_invalid_checksum => NLW_full_udp_stack_ip_0_ip_rx_error_invalid_checksum_UNCONNECTED,
      ip_rx_error_invalid_header => NLW_full_udp_stack_ip_0_ip_rx_error_invalid_header_UNCONNECTED,
      ip_rx_error_payload_early_termination => NLW_full_udp_stack_ip_0_ip_rx_error_payload_early_termination_UNCONNECTED,
      ip_tx_busy => NLW_full_udp_stack_ip_0_ip_tx_busy_UNCONNECTED,
      ip_tx_error_arp_failed => NLW_full_udp_stack_ip_0_ip_tx_error_arp_failed_UNCONNECTED,
      ip_tx_error_payload_early_termination => NLW_full_udp_stack_ip_0_ip_tx_error_payload_early_termination_UNCONNECTED,
      led(7 downto 0) => full_udp_stack_ip_0_led(7 downto 0),
      m_ch1_audio_payload_axis_tdata(7 downto 0) => full_udp_stack_ip_0_m_ch1_audio_payload_axis_TDATA(7 downto 0),
      m_ch1_audio_payload_axis_tlast => full_udp_stack_ip_0_m_ch1_audio_payload_axis_TLAST,
      m_ch1_audio_payload_axis_tready => full_udp_stack_ip_0_m_ch1_audio_payload_axis_TREADY,
      m_ch1_audio_payload_axis_tuser => NLW_full_udp_stack_ip_0_m_ch1_audio_payload_axis_tuser_UNCONNECTED,
      m_ch1_audio_payload_axis_tvalid => full_udp_stack_ip_0_m_ch1_audio_payload_axis_TVALID,
      m_ch1_audio_payload_hdr_ready => eth_to_audio_interfa_0_s_ch1_audio_payload_hdr_ready,
      m_ch1_audio_payload_hdr_valid => NLW_full_udp_stack_ip_0_m_ch1_audio_payload_hdr_valid_UNCONNECTED,
      m_ip_dest_ip(31 downto 0) => NLW_full_udp_stack_ip_0_m_ip_dest_ip_UNCONNECTED(31 downto 0),
      m_ip_dscp(5 downto 0) => NLW_full_udp_stack_ip_0_m_ip_dscp_UNCONNECTED(5 downto 0),
      m_ip_ecn(1 downto 0) => NLW_full_udp_stack_ip_0_m_ip_ecn_UNCONNECTED(1 downto 0),
      m_ip_eth_dest_mac(47 downto 0) => NLW_full_udp_stack_ip_0_m_ip_eth_dest_mac_UNCONNECTED(47 downto 0),
      m_ip_eth_src_mac(47 downto 0) => NLW_full_udp_stack_ip_0_m_ip_eth_src_mac_UNCONNECTED(47 downto 0),
      m_ip_eth_type(15 downto 0) => NLW_full_udp_stack_ip_0_m_ip_eth_type_UNCONNECTED(15 downto 0),
      m_ip_flags(2 downto 0) => NLW_full_udp_stack_ip_0_m_ip_flags_UNCONNECTED(2 downto 0),
      m_ip_fragment_offset(12 downto 0) => NLW_full_udp_stack_ip_0_m_ip_fragment_offset_UNCONNECTED(12 downto 0),
      m_ip_hdr_ready => '0',
      m_ip_hdr_valid => NLW_full_udp_stack_ip_0_m_ip_hdr_valid_UNCONNECTED,
      m_ip_header_checksum(15 downto 0) => NLW_full_udp_stack_ip_0_m_ip_header_checksum_UNCONNECTED(15 downto 0),
      m_ip_identification(15 downto 0) => NLW_full_udp_stack_ip_0_m_ip_identification_UNCONNECTED(15 downto 0),
      m_ip_ihl(3 downto 0) => NLW_full_udp_stack_ip_0_m_ip_ihl_UNCONNECTED(3 downto 0),
      m_ip_length(15 downto 0) => NLW_full_udp_stack_ip_0_m_ip_length_UNCONNECTED(15 downto 0),
      m_ip_payload_axis_tdata(7 downto 0) => NLW_full_udp_stack_ip_0_m_ip_payload_axis_tdata_UNCONNECTED(7 downto 0),
      m_ip_payload_axis_tlast => NLW_full_udp_stack_ip_0_m_ip_payload_axis_tlast_UNCONNECTED,
      m_ip_payload_axis_tready => '1',
      m_ip_payload_axis_tuser => NLW_full_udp_stack_ip_0_m_ip_payload_axis_tuser_UNCONNECTED,
      m_ip_payload_axis_tvalid => NLW_full_udp_stack_ip_0_m_ip_payload_axis_tvalid_UNCONNECTED,
      m_ip_protocol(7 downto 0) => NLW_full_udp_stack_ip_0_m_ip_protocol_UNCONNECTED(7 downto 0),
      m_ip_source_ip(31 downto 0) => NLW_full_udp_stack_ip_0_m_ip_source_ip_UNCONNECTED(31 downto 0),
      m_ip_ttl(7 downto 0) => NLW_full_udp_stack_ip_0_m_ip_ttl_UNCONNECTED(7 downto 0),
      m_ip_version(3 downto 0) => NLW_full_udp_stack_ip_0_m_ip_version_UNCONNECTED(3 downto 0),
      m_udp_checksum(15 downto 0) => NLW_full_udp_stack_ip_0_m_udp_checksum_UNCONNECTED(15 downto 0),
      m_udp_dest_port(15 downto 0) => NLW_full_udp_stack_ip_0_m_udp_dest_port_UNCONNECTED(15 downto 0),
      m_udp_eth_dest_mac(47 downto 0) => NLW_full_udp_stack_ip_0_m_udp_eth_dest_mac_UNCONNECTED(47 downto 0),
      m_udp_eth_src_mac(47 downto 0) => NLW_full_udp_stack_ip_0_m_udp_eth_src_mac_UNCONNECTED(47 downto 0),
      m_udp_eth_type(15 downto 0) => NLW_full_udp_stack_ip_0_m_udp_eth_type_UNCONNECTED(15 downto 0),
      m_udp_hdr_ready => '0',
      m_udp_hdr_valid => NLW_full_udp_stack_ip_0_m_udp_hdr_valid_UNCONNECTED,
      m_udp_ip_dest_ip(31 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_dest_ip_UNCONNECTED(31 downto 0),
      m_udp_ip_dscp(5 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_dscp_UNCONNECTED(5 downto 0),
      m_udp_ip_ecn(1 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_ecn_UNCONNECTED(1 downto 0),
      m_udp_ip_flags(2 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_flags_UNCONNECTED(2 downto 0),
      m_udp_ip_fragment_offset(12 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_fragment_offset_UNCONNECTED(12 downto 0),
      m_udp_ip_header_checksum(15 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_header_checksum_UNCONNECTED(15 downto 0),
      m_udp_ip_identification(15 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_identification_UNCONNECTED(15 downto 0),
      m_udp_ip_ihl(3 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_ihl_UNCONNECTED(3 downto 0),
      m_udp_ip_length(15 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_length_UNCONNECTED(15 downto 0),
      m_udp_ip_protocol(7 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_protocol_UNCONNECTED(7 downto 0),
      m_udp_ip_source_ip(31 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_source_ip_UNCONNECTED(31 downto 0),
      m_udp_ip_ttl(7 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_ttl_UNCONNECTED(7 downto 0),
      m_udp_ip_version(3 downto 0) => NLW_full_udp_stack_ip_0_m_udp_ip_version_UNCONNECTED(3 downto 0),
      m_udp_length(15 downto 0) => NLW_full_udp_stack_ip_0_m_udp_length_UNCONNECTED(15 downto 0),
      m_udp_payload_axis_tdata(7 downto 0) => NLW_full_udp_stack_ip_0_m_udp_payload_axis_tdata_UNCONNECTED(7 downto 0),
      m_udp_payload_axis_tlast => NLW_full_udp_stack_ip_0_m_udp_payload_axis_tlast_UNCONNECTED,
      m_udp_payload_axis_tready => '1',
      m_udp_payload_axis_tuser => NLW_full_udp_stack_ip_0_m_udp_payload_axis_tuser_UNCONNECTED,
      m_udp_payload_axis_tvalid => NLW_full_udp_stack_ip_0_m_udp_payload_axis_tvalid_UNCONNECTED,
      m_udp_source_port(15 downto 0) => NLW_full_udp_stack_ip_0_m_udp_source_port_UNCONNECTED(15 downto 0),
      phy_int_n => phy_int_n_0_1,
      phy_pme_n => phy_pme_n_0_1,
      phy_reset_n => full_udp_stack_ip_0_phy_reset_n,
      phy_rx_clk => phy_rx_clk_0_1,
      phy_rx_ctl => phy_rx_ctl_0_1,
      phy_rxd(3 downto 0) => phy_rxd_0_1(3 downto 0),
      phy_tx_clk => full_udp_stack_ip_0_phy_tx_clk,
      phy_tx_ctl => full_udp_stack_ip_0_phy_tx_ctl,
      phy_txd(3 downto 0) => full_udp_stack_ip_0_phy_txd(3 downto 0),
      reset_n => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(6 downto 0) => ps7_0_axi_periph_M11_AXI_ARADDR(6 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M11_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M11_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M11_AXI_ARVALID,
      s00_axi_awaddr(6 downto 0) => ps7_0_axi_periph_M11_AXI_AWADDR(6 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M11_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M11_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M11_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M11_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M11_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M11_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M11_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M11_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M11_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M11_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M11_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M11_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M11_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M11_AXI_WVALID,
      s_audio_payload_axis_tdata(7 downto 0) => user_org_plc_seq_ip_0_to_udp_m_axis_TDATA(7 downto 0),
      s_audio_payload_axis_tlast => user_org_plc_seq_ip_0_to_udp_m_axis_TLAST,
      s_audio_payload_axis_tready => user_org_plc_seq_ip_0_to_udp_m_axis_TREADY,
      s_audio_payload_axis_tuser => '0',
      s_audio_payload_axis_tvalid => user_org_plc_seq_ip_0_to_udp_m_axis_TVALID,
      s_audio_payload_hdr_ready => full_udp_stack_ip_0_s_audio_payload_hdr_ready,
      s_audio_payload_hdr_valid => user_org_plc_seq_ip_0_to_udp_hdr_valid,
      s_ip_dest_ip(31 downto 0) => B"00000000000000000000000000000000",
      s_ip_dscp(5 downto 0) => B"000000",
      s_ip_ecn(1 downto 0) => B"00",
      s_ip_hdr_ready => NLW_full_udp_stack_ip_0_s_ip_hdr_ready_UNCONNECTED,
      s_ip_hdr_valid => '0',
      s_ip_length(15 downto 0) => B"0000000000000000",
      s_ip_payload_axis_tdata(7 downto 0) => B"00000000",
      s_ip_payload_axis_tlast => '0',
      s_ip_payload_axis_tready => NLW_full_udp_stack_ip_0_s_ip_payload_axis_tready_UNCONNECTED,
      s_ip_payload_axis_tuser => '0',
      s_ip_payload_axis_tvalid => '0',
      s_ip_protocol(7 downto 0) => B"00000000",
      s_ip_source_ip(31 downto 0) => B"00000000000000000000000000000000",
      s_ip_ttl(7 downto 0) => B"00000000",
      s_udp_checksum(15 downto 0) => B"0000000000000000",
      s_udp_dest_port(15 downto 0) => B"0000000000000000",
      s_udp_hdr_ready => NLW_full_udp_stack_ip_0_s_udp_hdr_ready_UNCONNECTED,
      s_udp_hdr_valid => '0',
      s_udp_ip_dest_ip(31 downto 0) => B"00000000000000000000000000000000",
      s_udp_ip_dscp(5 downto 0) => B"000000",
      s_udp_ip_ecn(1 downto 0) => B"00",
      s_udp_ip_source_ip(31 downto 0) => B"00000000000000000000000000000000",
      s_udp_ip_ttl(7 downto 0) => B"00000000",
      s_udp_length(15 downto 0) => B"0000000000000000",
      s_udp_payload_axis_tdata(7 downto 0) => B"00000000",
      s_udp_payload_axis_tlast => '0',
      s_udp_payload_axis_tready => NLW_full_udp_stack_ip_0_s_udp_payload_axis_tready_UNCONNECTED,
      s_udp_payload_axis_tuser => '0',
      s_udp_payload_axis_tvalid => '0',
      s_udp_source_port(15 downto 0) => B"0000000000000000",
      seq_status1_in => user_org_plc_seq_ip_0_status1_out,
      seq_status2_in => user_org_plc_seq_ip_0_status2_out,
      stream_reset_out => Net1,
      sw(7 downto 0) => B"00000000",
      uart_rxd => uart_rxd_0_1,
      uart_txd => full_udp_stack_ip_0_uart_txd,
      udp_payload_length(15 downto 0) => audio_to_eth_interfa_0_udp_payload_length(15 downto 0),
      udp_rx_busy => NLW_full_udp_stack_ip_0_udp_rx_busy_UNCONNECTED,
      udp_rx_error_header_early_termination => NLW_full_udp_stack_ip_0_udp_rx_error_header_early_termination_UNCONNECTED,
      udp_rx_error_payload_early_termination => NLW_full_udp_stack_ip_0_udp_rx_error_payload_early_termination_UNCONNECTED,
      udp_tx_busy => NLW_full_udp_stack_ip_0_udp_tx_busy_UNCONNECTED,
      udp_tx_error_payload_early_termination => NLW_full_udp_stack_ip_0_udp_tx_error_payload_early_termination_UNCONNECTED
    );
mixer_0: component cantavi_streamer_project_mixer_0_0
     port map (
      audio_channel_a_left_in(23 downto 0) => Volume_Pregain_0_OUT_VOLCTRL_L(23 downto 0),
      audio_channel_a_right_in(23 downto 0) => Volume_Pregain_0_OUT_VOLCTRL_R(23 downto 0),
      audio_channel_b_left_in(23 downto 0) => Volume_Pregain_1_OUT_VOLCTRL_L(23 downto 0),
      audio_channel_b_right_in(23 downto 0) => Volume_Pregain_1_OUT_VOLCTRL_R(23 downto 0),
      audio_mixed_a_b_left_out(23 downto 0) => mixer_0_audio_mixed_a_b_left_out(23 downto 0),
      audio_mixed_a_b_right_out(23 downto 0) => mixer_0_audio_mixed_a_b_right_out(23 downto 0)
    );
pmod_controller_0: component cantavi_streamer_project_pmod_controller_0_1
     port map (
      Button => Button_1,
      Rotary_a => Rotary_a_1,
      Rotary_b => '0',
      Rotary_event => pmod_controller_0_Rotary_event,
      Switch => Switch_1,
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(3 downto 0) => ps7_0_axi_periph_M07_AXI_ARADDR(3 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M07_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M07_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M07_AXI_ARVALID(0),
      s00_axi_awaddr(3 downto 0) => ps7_0_axi_periph_M07_AXI_AWADDR(3 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M07_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M07_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M07_AXI_AWVALID(0),
      s00_axi_bready => ps7_0_axi_periph_M07_AXI_BREADY(0),
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M07_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M07_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M07_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M07_AXI_RREADY(0),
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M07_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M07_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M07_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M07_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M07_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M07_AXI_WVALID(0)
    );
processing_system7_0: component cantavi_streamer_project_processing_system7_0_0
     port map (
      DDR_Addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_BankAddr(2 downto 0) => DDR_ba(2 downto 0),
      DDR_CAS_n => DDR_cas_n,
      DDR_CKE => DDR_cke,
      DDR_CS_n => DDR_cs_n,
      DDR_Clk => DDR_ck_p,
      DDR_Clk_n => DDR_ck_n,
      DDR_DM(3 downto 0) => DDR_dm(3 downto 0),
      DDR_DQ(31 downto 0) => DDR_dq(31 downto 0),
      DDR_DQS(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_DQS_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_DRSTB => DDR_reset_n,
      DDR_ODT => DDR_odt,
      DDR_RAS_n => DDR_ras_n,
      DDR_VRN => FIXED_IO_ddr_vrn,
      DDR_VRP => FIXED_IO_ddr_vrp,
      DDR_WEB => DDR_we_n,
      FCLK_CLK0 => clk_wiz_0_clk_100_out,
      FCLK_CLK1 => processing_system7_0_FCLK_CLK1,
      FCLK_CLK2 => processing_system7_0_FCLK_CLK2,
      FCLK_CLK3 => processing_system7_0_FCLK_CLK3,
      FCLK_RESET0_N => processing_system7_0_FCLK_RESET0_N,
      IRQ_F2P(9 downto 0) => xlconcat_0_dout(9 downto 0),
      MIO(53 downto 0) => FIXED_IO_mio(53 downto 0),
      M_AXI_GP0_ACLK => clk_wiz_0_clk_100_out,
      M_AXI_GP0_ARADDR(31 downto 0) => processing_system7_0_M_AXI_GP0_ARADDR(31 downto 0),
      M_AXI_GP0_ARBURST(1 downto 0) => processing_system7_0_M_AXI_GP0_ARBURST(1 downto 0),
      M_AXI_GP0_ARCACHE(3 downto 0) => processing_system7_0_M_AXI_GP0_ARCACHE(3 downto 0),
      M_AXI_GP0_ARID(11 downto 0) => processing_system7_0_M_AXI_GP0_ARID(11 downto 0),
      M_AXI_GP0_ARLEN(3 downto 0) => processing_system7_0_M_AXI_GP0_ARLEN(3 downto 0),
      M_AXI_GP0_ARLOCK(1 downto 0) => processing_system7_0_M_AXI_GP0_ARLOCK(1 downto 0),
      M_AXI_GP0_ARPROT(2 downto 0) => processing_system7_0_M_AXI_GP0_ARPROT(2 downto 0),
      M_AXI_GP0_ARQOS(3 downto 0) => processing_system7_0_M_AXI_GP0_ARQOS(3 downto 0),
      M_AXI_GP0_ARREADY => processing_system7_0_M_AXI_GP0_ARREADY,
      M_AXI_GP0_ARSIZE(2 downto 0) => processing_system7_0_M_AXI_GP0_ARSIZE(2 downto 0),
      M_AXI_GP0_ARVALID => processing_system7_0_M_AXI_GP0_ARVALID,
      M_AXI_GP0_AWADDR(31 downto 0) => processing_system7_0_M_AXI_GP0_AWADDR(31 downto 0),
      M_AXI_GP0_AWBURST(1 downto 0) => processing_system7_0_M_AXI_GP0_AWBURST(1 downto 0),
      M_AXI_GP0_AWCACHE(3 downto 0) => processing_system7_0_M_AXI_GP0_AWCACHE(3 downto 0),
      M_AXI_GP0_AWID(11 downto 0) => processing_system7_0_M_AXI_GP0_AWID(11 downto 0),
      M_AXI_GP0_AWLEN(3 downto 0) => processing_system7_0_M_AXI_GP0_AWLEN(3 downto 0),
      M_AXI_GP0_AWLOCK(1 downto 0) => processing_system7_0_M_AXI_GP0_AWLOCK(1 downto 0),
      M_AXI_GP0_AWPROT(2 downto 0) => processing_system7_0_M_AXI_GP0_AWPROT(2 downto 0),
      M_AXI_GP0_AWQOS(3 downto 0) => processing_system7_0_M_AXI_GP0_AWQOS(3 downto 0),
      M_AXI_GP0_AWREADY => processing_system7_0_M_AXI_GP0_AWREADY,
      M_AXI_GP0_AWSIZE(2 downto 0) => processing_system7_0_M_AXI_GP0_AWSIZE(2 downto 0),
      M_AXI_GP0_AWVALID => processing_system7_0_M_AXI_GP0_AWVALID,
      M_AXI_GP0_BID(11 downto 0) => processing_system7_0_M_AXI_GP0_BID(11 downto 0),
      M_AXI_GP0_BREADY => processing_system7_0_M_AXI_GP0_BREADY,
      M_AXI_GP0_BRESP(1 downto 0) => processing_system7_0_M_AXI_GP0_BRESP(1 downto 0),
      M_AXI_GP0_BVALID => processing_system7_0_M_AXI_GP0_BVALID,
      M_AXI_GP0_RDATA(31 downto 0) => processing_system7_0_M_AXI_GP0_RDATA(31 downto 0),
      M_AXI_GP0_RID(11 downto 0) => processing_system7_0_M_AXI_GP0_RID(11 downto 0),
      M_AXI_GP0_RLAST => processing_system7_0_M_AXI_GP0_RLAST,
      M_AXI_GP0_RREADY => processing_system7_0_M_AXI_GP0_RREADY,
      M_AXI_GP0_RRESP(1 downto 0) => processing_system7_0_M_AXI_GP0_RRESP(1 downto 0),
      M_AXI_GP0_RVALID => processing_system7_0_M_AXI_GP0_RVALID,
      M_AXI_GP0_WDATA(31 downto 0) => processing_system7_0_M_AXI_GP0_WDATA(31 downto 0),
      M_AXI_GP0_WID(11 downto 0) => processing_system7_0_M_AXI_GP0_WID(11 downto 0),
      M_AXI_GP0_WLAST => processing_system7_0_M_AXI_GP0_WLAST,
      M_AXI_GP0_WREADY => processing_system7_0_M_AXI_GP0_WREADY,
      M_AXI_GP0_WSTRB(3 downto 0) => processing_system7_0_M_AXI_GP0_WSTRB(3 downto 0),
      M_AXI_GP0_WVALID => processing_system7_0_M_AXI_GP0_WVALID,
      PS_CLK => FIXED_IO_ps_clk,
      PS_PORB => FIXED_IO_ps_porb,
      PS_SRSTB => FIXED_IO_ps_srstb,
      TTC0_WAVE0_OUT => NLW_processing_system7_0_TTC0_WAVE0_OUT_UNCONNECTED,
      TTC0_WAVE1_OUT => NLW_processing_system7_0_TTC0_WAVE1_OUT_UNCONNECTED,
      TTC0_WAVE2_OUT => NLW_processing_system7_0_TTC0_WAVE2_OUT_UNCONNECTED,
      USB0_PORT_INDCTL(1 downto 0) => NLW_processing_system7_0_USB0_PORT_INDCTL_UNCONNECTED(1 downto 0),
      USB0_VBUS_PWRFAULT => '0',
      USB0_VBUS_PWRSELECT => NLW_processing_system7_0_USB0_VBUS_PWRSELECT_UNCONNECTED
    );
ps7_0_axi_periph: entity work.cantavi_streamer_project_ps7_0_axi_periph_0
     port map (
      ACLK => clk_wiz_0_clk_100_out,
      ARESETN => rst_ps7_0_100M_interconnect_aresetn(0),
      M00_ACLK => clk_wiz_0_clk_100_out,
      M00_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M00_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M00_AXI_ARADDR(31 downto 0),
      M00_AXI_arready(0) => ps7_0_axi_periph_M00_AXI_ARREADY,
      M00_AXI_arvalid(0) => ps7_0_axi_periph_M00_AXI_ARVALID(0),
      M00_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M00_AXI_AWADDR(31 downto 0),
      M00_AXI_awready(0) => ps7_0_axi_periph_M00_AXI_AWREADY,
      M00_AXI_awvalid(0) => ps7_0_axi_periph_M00_AXI_AWVALID(0),
      M00_AXI_bready(0) => ps7_0_axi_periph_M00_AXI_BREADY(0),
      M00_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M00_AXI_BRESP(1 downto 0),
      M00_AXI_bvalid(0) => ps7_0_axi_periph_M00_AXI_BVALID,
      M00_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M00_AXI_RDATA(31 downto 0),
      M00_AXI_rready(0) => ps7_0_axi_periph_M00_AXI_RREADY(0),
      M00_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M00_AXI_RRESP(1 downto 0),
      M00_AXI_rvalid(0) => ps7_0_axi_periph_M00_AXI_RVALID,
      M00_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M00_AXI_WDATA(31 downto 0),
      M00_AXI_wready(0) => ps7_0_axi_periph_M00_AXI_WREADY,
      M00_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M00_AXI_WSTRB(3 downto 0),
      M00_AXI_wvalid(0) => ps7_0_axi_periph_M00_AXI_WVALID(0),
      M01_ACLK => clk_wiz_0_clk_100_out,
      M01_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M01_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M01_AXI_ARADDR(31 downto 0),
      M01_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M01_AXI_ARPROT(2 downto 0),
      M01_AXI_arready => ps7_0_axi_periph_M01_AXI_ARREADY,
      M01_AXI_arvalid => ps7_0_axi_periph_M01_AXI_ARVALID,
      M01_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M01_AXI_AWADDR(31 downto 0),
      M01_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M01_AXI_AWPROT(2 downto 0),
      M01_AXI_awready => ps7_0_axi_periph_M01_AXI_AWREADY,
      M01_AXI_awvalid => ps7_0_axi_periph_M01_AXI_AWVALID,
      M01_AXI_bready => ps7_0_axi_periph_M01_AXI_BREADY,
      M01_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M01_AXI_BRESP(1 downto 0),
      M01_AXI_bvalid => ps7_0_axi_periph_M01_AXI_BVALID,
      M01_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M01_AXI_RDATA(31 downto 0),
      M01_AXI_rready => ps7_0_axi_periph_M01_AXI_RREADY,
      M01_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M01_AXI_RRESP(1 downto 0),
      M01_AXI_rvalid => ps7_0_axi_periph_M01_AXI_RVALID,
      M01_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M01_AXI_WDATA(31 downto 0),
      M01_AXI_wready => ps7_0_axi_periph_M01_AXI_WREADY,
      M01_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M01_AXI_WSTRB(3 downto 0),
      M01_AXI_wvalid => ps7_0_axi_periph_M01_AXI_WVALID,
      M02_ACLK => clk_wiz_0_clk_100_out,
      M02_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M02_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M02_AXI_ARADDR(31 downto 0),
      M02_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M02_AXI_ARPROT(2 downto 0),
      M02_AXI_arready => ps7_0_axi_periph_M02_AXI_ARREADY,
      M02_AXI_arvalid => ps7_0_axi_periph_M02_AXI_ARVALID,
      M02_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M02_AXI_AWADDR(31 downto 0),
      M02_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M02_AXI_AWPROT(2 downto 0),
      M02_AXI_awready => ps7_0_axi_periph_M02_AXI_AWREADY,
      M02_AXI_awvalid => ps7_0_axi_periph_M02_AXI_AWVALID,
      M02_AXI_bready => ps7_0_axi_periph_M02_AXI_BREADY,
      M02_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M02_AXI_BRESP(1 downto 0),
      M02_AXI_bvalid => ps7_0_axi_periph_M02_AXI_BVALID,
      M02_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M02_AXI_RDATA(31 downto 0),
      M02_AXI_rready => ps7_0_axi_periph_M02_AXI_RREADY,
      M02_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M02_AXI_RRESP(1 downto 0),
      M02_AXI_rvalid => ps7_0_axi_periph_M02_AXI_RVALID,
      M02_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M02_AXI_WDATA(31 downto 0),
      M02_AXI_wready => ps7_0_axi_periph_M02_AXI_WREADY,
      M02_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M02_AXI_WSTRB(3 downto 0),
      M02_AXI_wvalid => ps7_0_axi_periph_M02_AXI_WVALID,
      M03_ACLK => clk_wiz_0_clk_100_out,
      M03_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M03_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M03_AXI_ARADDR(31 downto 0),
      M03_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M03_AXI_ARPROT(2 downto 0),
      M03_AXI_arready => ps7_0_axi_periph_M03_AXI_ARREADY,
      M03_AXI_arvalid => ps7_0_axi_periph_M03_AXI_ARVALID,
      M03_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M03_AXI_AWADDR(31 downto 0),
      M03_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M03_AXI_AWPROT(2 downto 0),
      M03_AXI_awready => ps7_0_axi_periph_M03_AXI_AWREADY,
      M03_AXI_awvalid => ps7_0_axi_periph_M03_AXI_AWVALID,
      M03_AXI_bready => ps7_0_axi_periph_M03_AXI_BREADY,
      M03_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M03_AXI_BRESP(1 downto 0),
      M03_AXI_bvalid => ps7_0_axi_periph_M03_AXI_BVALID,
      M03_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M03_AXI_RDATA(31 downto 0),
      M03_AXI_rready => ps7_0_axi_periph_M03_AXI_RREADY,
      M03_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M03_AXI_RRESP(1 downto 0),
      M03_AXI_rvalid => ps7_0_axi_periph_M03_AXI_RVALID,
      M03_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M03_AXI_WDATA(31 downto 0),
      M03_AXI_wready => ps7_0_axi_periph_M03_AXI_WREADY,
      M03_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M03_AXI_WSTRB(3 downto 0),
      M03_AXI_wvalid => ps7_0_axi_periph_M03_AXI_WVALID,
      M04_ACLK => clk_wiz_0_clk_100_out,
      M04_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M04_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M04_AXI_ARADDR(31 downto 0),
      M04_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M04_AXI_ARPROT(2 downto 0),
      M04_AXI_arready => ps7_0_axi_periph_M04_AXI_ARREADY,
      M04_AXI_arvalid => ps7_0_axi_periph_M04_AXI_ARVALID,
      M04_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M04_AXI_AWADDR(31 downto 0),
      M04_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M04_AXI_AWPROT(2 downto 0),
      M04_AXI_awready => ps7_0_axi_periph_M04_AXI_AWREADY,
      M04_AXI_awvalid => ps7_0_axi_periph_M04_AXI_AWVALID,
      M04_AXI_bready => ps7_0_axi_periph_M04_AXI_BREADY,
      M04_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M04_AXI_BRESP(1 downto 0),
      M04_AXI_bvalid => ps7_0_axi_periph_M04_AXI_BVALID,
      M04_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M04_AXI_RDATA(31 downto 0),
      M04_AXI_rready => ps7_0_axi_periph_M04_AXI_RREADY,
      M04_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M04_AXI_RRESP(1 downto 0),
      M04_AXI_rvalid => ps7_0_axi_periph_M04_AXI_RVALID,
      M04_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M04_AXI_WDATA(31 downto 0),
      M04_AXI_wready => ps7_0_axi_periph_M04_AXI_WREADY,
      M04_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M04_AXI_WSTRB(3 downto 0),
      M04_AXI_wvalid => ps7_0_axi_periph_M04_AXI_WVALID,
      M05_ACLK => clk_wiz_0_clk_100_out,
      M05_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M05_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M05_AXI_ARADDR(31 downto 0),
      M05_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M05_AXI_ARPROT(2 downto 0),
      M05_AXI_arready => ps7_0_axi_periph_M05_AXI_ARREADY,
      M05_AXI_arvalid => ps7_0_axi_periph_M05_AXI_ARVALID,
      M05_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M05_AXI_AWADDR(31 downto 0),
      M05_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M05_AXI_AWPROT(2 downto 0),
      M05_AXI_awready => ps7_0_axi_periph_M05_AXI_AWREADY,
      M05_AXI_awvalid => ps7_0_axi_periph_M05_AXI_AWVALID,
      M05_AXI_bready => ps7_0_axi_periph_M05_AXI_BREADY,
      M05_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M05_AXI_BRESP(1 downto 0),
      M05_AXI_bvalid => ps7_0_axi_periph_M05_AXI_BVALID,
      M05_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M05_AXI_RDATA(31 downto 0),
      M05_AXI_rready => ps7_0_axi_periph_M05_AXI_RREADY,
      M05_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M05_AXI_RRESP(1 downto 0),
      M05_AXI_rvalid => ps7_0_axi_periph_M05_AXI_RVALID,
      M05_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M05_AXI_WDATA(31 downto 0),
      M05_AXI_wready => ps7_0_axi_periph_M05_AXI_WREADY,
      M05_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M05_AXI_WSTRB(3 downto 0),
      M05_AXI_wvalid => ps7_0_axi_periph_M05_AXI_WVALID,
      M06_ACLK => clk_wiz_0_clk_100_out,
      M06_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M06_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M06_AXI_ARADDR(31 downto 0),
      M06_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M06_AXI_ARPROT(2 downto 0),
      M06_AXI_arready => ps7_0_axi_periph_M06_AXI_ARREADY,
      M06_AXI_arvalid => ps7_0_axi_periph_M06_AXI_ARVALID,
      M06_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M06_AXI_AWADDR(31 downto 0),
      M06_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M06_AXI_AWPROT(2 downto 0),
      M06_AXI_awready => ps7_0_axi_periph_M06_AXI_AWREADY,
      M06_AXI_awvalid => ps7_0_axi_periph_M06_AXI_AWVALID,
      M06_AXI_bready => ps7_0_axi_periph_M06_AXI_BREADY,
      M06_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M06_AXI_BRESP(1 downto 0),
      M06_AXI_bvalid => ps7_0_axi_periph_M06_AXI_BVALID,
      M06_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M06_AXI_RDATA(31 downto 0),
      M06_AXI_rready => ps7_0_axi_periph_M06_AXI_RREADY,
      M06_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M06_AXI_RRESP(1 downto 0),
      M06_AXI_rvalid => ps7_0_axi_periph_M06_AXI_RVALID,
      M06_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M06_AXI_WDATA(31 downto 0),
      M06_AXI_wready => ps7_0_axi_periph_M06_AXI_WREADY,
      M06_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M06_AXI_WSTRB(3 downto 0),
      M06_AXI_wvalid => ps7_0_axi_periph_M06_AXI_WVALID,
      M07_ACLK => clk_wiz_0_clk_100_out,
      M07_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M07_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M07_AXI_ARADDR(31 downto 0),
      M07_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M07_AXI_ARPROT(2 downto 0),
      M07_AXI_arready(0) => ps7_0_axi_periph_M07_AXI_ARREADY,
      M07_AXI_arvalid(0) => ps7_0_axi_periph_M07_AXI_ARVALID(0),
      M07_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M07_AXI_AWADDR(31 downto 0),
      M07_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M07_AXI_AWPROT(2 downto 0),
      M07_AXI_awready(0) => ps7_0_axi_periph_M07_AXI_AWREADY,
      M07_AXI_awvalid(0) => ps7_0_axi_periph_M07_AXI_AWVALID(0),
      M07_AXI_bready(0) => ps7_0_axi_periph_M07_AXI_BREADY(0),
      M07_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M07_AXI_BRESP(1 downto 0),
      M07_AXI_bvalid(0) => ps7_0_axi_periph_M07_AXI_BVALID,
      M07_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M07_AXI_RDATA(31 downto 0),
      M07_AXI_rready(0) => ps7_0_axi_periph_M07_AXI_RREADY(0),
      M07_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M07_AXI_RRESP(1 downto 0),
      M07_AXI_rvalid(0) => ps7_0_axi_periph_M07_AXI_RVALID,
      M07_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M07_AXI_WDATA(31 downto 0),
      M07_AXI_wready(0) => ps7_0_axi_periph_M07_AXI_WREADY,
      M07_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M07_AXI_WSTRB(3 downto 0),
      M07_AXI_wvalid(0) => ps7_0_axi_periph_M07_AXI_WVALID(0),
      M08_ACLK => clk_wiz_0_clk_100_out,
      M08_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M08_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M08_AXI_ARADDR(31 downto 0),
      M08_AXI_arready(0) => ps7_0_axi_periph_M08_AXI_ARREADY,
      M08_AXI_arvalid(0) => ps7_0_axi_periph_M08_AXI_ARVALID(0),
      M08_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M08_AXI_AWADDR(31 downto 0),
      M08_AXI_awready(0) => ps7_0_axi_periph_M08_AXI_AWREADY,
      M08_AXI_awvalid(0) => ps7_0_axi_periph_M08_AXI_AWVALID(0),
      M08_AXI_bready(0) => ps7_0_axi_periph_M08_AXI_BREADY(0),
      M08_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M08_AXI_BRESP(1 downto 0),
      M08_AXI_bvalid(0) => ps7_0_axi_periph_M08_AXI_BVALID,
      M08_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M08_AXI_RDATA(31 downto 0),
      M08_AXI_rready(0) => ps7_0_axi_periph_M08_AXI_RREADY(0),
      M08_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M08_AXI_RRESP(1 downto 0),
      M08_AXI_rvalid(0) => ps7_0_axi_periph_M08_AXI_RVALID,
      M08_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M08_AXI_WDATA(31 downto 0),
      M08_AXI_wready(0) => ps7_0_axi_periph_M08_AXI_WREADY,
      M08_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M08_AXI_WSTRB(3 downto 0),
      M08_AXI_wvalid(0) => ps7_0_axi_periph_M08_AXI_WVALID(0),
      M09_ACLK => clk_wiz_0_clk_100_out,
      M09_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M09_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M09_AXI_ARADDR(31 downto 0),
      M09_AXI_arready(0) => ps7_0_axi_periph_M09_AXI_ARREADY,
      M09_AXI_arvalid(0) => ps7_0_axi_periph_M09_AXI_ARVALID(0),
      M09_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M09_AXI_AWADDR(31 downto 0),
      M09_AXI_awready(0) => ps7_0_axi_periph_M09_AXI_AWREADY,
      M09_AXI_awvalid(0) => ps7_0_axi_periph_M09_AXI_AWVALID(0),
      M09_AXI_bready(0) => ps7_0_axi_periph_M09_AXI_BREADY(0),
      M09_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M09_AXI_BRESP(1 downto 0),
      M09_AXI_bvalid(0) => ps7_0_axi_periph_M09_AXI_BVALID,
      M09_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M09_AXI_RDATA(31 downto 0),
      M09_AXI_rready(0) => ps7_0_axi_periph_M09_AXI_RREADY(0),
      M09_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M09_AXI_RRESP(1 downto 0),
      M09_AXI_rvalid(0) => ps7_0_axi_periph_M09_AXI_RVALID,
      M09_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M09_AXI_WDATA(31 downto 0),
      M09_AXI_wready(0) => ps7_0_axi_periph_M09_AXI_WREADY,
      M09_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M09_AXI_WSTRB(3 downto 0),
      M09_AXI_wvalid(0) => ps7_0_axi_periph_M09_AXI_WVALID(0),
      M10_ACLK => clk_wiz_0_clk_100_out,
      M10_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M10_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M10_AXI_ARADDR(31 downto 0),
      M10_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M10_AXI_ARPROT(2 downto 0),
      M10_AXI_arready => ps7_0_axi_periph_M10_AXI_ARREADY,
      M10_AXI_arvalid => ps7_0_axi_periph_M10_AXI_ARVALID,
      M10_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M10_AXI_AWADDR(31 downto 0),
      M10_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M10_AXI_AWPROT(2 downto 0),
      M10_AXI_awready => ps7_0_axi_periph_M10_AXI_AWREADY,
      M10_AXI_awvalid => ps7_0_axi_periph_M10_AXI_AWVALID,
      M10_AXI_bready => ps7_0_axi_periph_M10_AXI_BREADY,
      M10_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M10_AXI_BRESP(1 downto 0),
      M10_AXI_bvalid => ps7_0_axi_periph_M10_AXI_BVALID,
      M10_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M10_AXI_RDATA(31 downto 0),
      M10_AXI_rready => ps7_0_axi_periph_M10_AXI_RREADY,
      M10_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M10_AXI_RRESP(1 downto 0),
      M10_AXI_rvalid => ps7_0_axi_periph_M10_AXI_RVALID,
      M10_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M10_AXI_WDATA(31 downto 0),
      M10_AXI_wready => ps7_0_axi_periph_M10_AXI_WREADY,
      M10_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M10_AXI_WSTRB(3 downto 0),
      M10_AXI_wvalid => ps7_0_axi_periph_M10_AXI_WVALID,
      M11_ACLK => clk_wiz_0_clk_100_out,
      M11_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M11_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M11_AXI_ARADDR(31 downto 0),
      M11_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M11_AXI_ARPROT(2 downto 0),
      M11_AXI_arready => ps7_0_axi_periph_M11_AXI_ARREADY,
      M11_AXI_arvalid => ps7_0_axi_periph_M11_AXI_ARVALID,
      M11_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M11_AXI_AWADDR(31 downto 0),
      M11_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M11_AXI_AWPROT(2 downto 0),
      M11_AXI_awready => ps7_0_axi_periph_M11_AXI_AWREADY,
      M11_AXI_awvalid => ps7_0_axi_periph_M11_AXI_AWVALID,
      M11_AXI_bready => ps7_0_axi_periph_M11_AXI_BREADY,
      M11_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M11_AXI_BRESP(1 downto 0),
      M11_AXI_bvalid => ps7_0_axi_periph_M11_AXI_BVALID,
      M11_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M11_AXI_RDATA(31 downto 0),
      M11_AXI_rready => ps7_0_axi_periph_M11_AXI_RREADY,
      M11_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M11_AXI_RRESP(1 downto 0),
      M11_AXI_rvalid => ps7_0_axi_periph_M11_AXI_RVALID,
      M11_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M11_AXI_WDATA(31 downto 0),
      M11_AXI_wready => ps7_0_axi_periph_M11_AXI_WREADY,
      M11_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M11_AXI_WSTRB(3 downto 0),
      M11_AXI_wvalid => ps7_0_axi_periph_M11_AXI_WVALID,
      M12_ACLK => clk_wiz_0_clk_100_out,
      M12_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M12_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M12_AXI_ARADDR(31 downto 0),
      M12_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M12_AXI_ARPROT(2 downto 0),
      M12_AXI_arready => ps7_0_axi_periph_M12_AXI_ARREADY,
      M12_AXI_arvalid => ps7_0_axi_periph_M12_AXI_ARVALID,
      M12_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M12_AXI_AWADDR(31 downto 0),
      M12_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M12_AXI_AWPROT(2 downto 0),
      M12_AXI_awready => ps7_0_axi_periph_M12_AXI_AWREADY,
      M12_AXI_awvalid => ps7_0_axi_periph_M12_AXI_AWVALID,
      M12_AXI_bready => ps7_0_axi_periph_M12_AXI_BREADY,
      M12_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M12_AXI_BRESP(1 downto 0),
      M12_AXI_bvalid => ps7_0_axi_periph_M12_AXI_BVALID,
      M12_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M12_AXI_RDATA(31 downto 0),
      M12_AXI_rready => ps7_0_axi_periph_M12_AXI_RREADY,
      M12_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M12_AXI_RRESP(1 downto 0),
      M12_AXI_rvalid => ps7_0_axi_periph_M12_AXI_RVALID,
      M12_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M12_AXI_WDATA(31 downto 0),
      M12_AXI_wready => ps7_0_axi_periph_M12_AXI_WREADY,
      M12_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M12_AXI_WSTRB(3 downto 0),
      M12_AXI_wvalid => ps7_0_axi_periph_M12_AXI_WVALID,
      M13_ACLK => clk_wiz_0_clk_100_out,
      M13_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      M13_AXI_araddr(31 downto 0) => ps7_0_axi_periph_M13_AXI_ARADDR(31 downto 0),
      M13_AXI_arprot(2 downto 0) => ps7_0_axi_periph_M13_AXI_ARPROT(2 downto 0),
      M13_AXI_arready => ps7_0_axi_periph_M13_AXI_ARREADY,
      M13_AXI_arvalid => ps7_0_axi_periph_M13_AXI_ARVALID,
      M13_AXI_awaddr(31 downto 0) => ps7_0_axi_periph_M13_AXI_AWADDR(31 downto 0),
      M13_AXI_awprot(2 downto 0) => ps7_0_axi_periph_M13_AXI_AWPROT(2 downto 0),
      M13_AXI_awready => ps7_0_axi_periph_M13_AXI_AWREADY,
      M13_AXI_awvalid => ps7_0_axi_periph_M13_AXI_AWVALID,
      M13_AXI_bready => ps7_0_axi_periph_M13_AXI_BREADY,
      M13_AXI_bresp(1 downto 0) => ps7_0_axi_periph_M13_AXI_BRESP(1 downto 0),
      M13_AXI_bvalid => ps7_0_axi_periph_M13_AXI_BVALID,
      M13_AXI_rdata(31 downto 0) => ps7_0_axi_periph_M13_AXI_RDATA(31 downto 0),
      M13_AXI_rready => ps7_0_axi_periph_M13_AXI_RREADY,
      M13_AXI_rresp(1 downto 0) => ps7_0_axi_periph_M13_AXI_RRESP(1 downto 0),
      M13_AXI_rvalid => ps7_0_axi_periph_M13_AXI_RVALID,
      M13_AXI_wdata(31 downto 0) => ps7_0_axi_periph_M13_AXI_WDATA(31 downto 0),
      M13_AXI_wready => ps7_0_axi_periph_M13_AXI_WREADY,
      M13_AXI_wstrb(3 downto 0) => ps7_0_axi_periph_M13_AXI_WSTRB(3 downto 0),
      M13_AXI_wvalid => ps7_0_axi_periph_M13_AXI_WVALID,
      S00_ACLK => clk_wiz_0_clk_100_out,
      S00_ARESETN => rst_ps7_0_100M_peripheral_aresetn(0),
      S00_AXI_araddr(31 downto 0) => processing_system7_0_M_AXI_GP0_ARADDR(31 downto 0),
      S00_AXI_arburst(1 downto 0) => processing_system7_0_M_AXI_GP0_ARBURST(1 downto 0),
      S00_AXI_arcache(3 downto 0) => processing_system7_0_M_AXI_GP0_ARCACHE(3 downto 0),
      S00_AXI_arid(11 downto 0) => processing_system7_0_M_AXI_GP0_ARID(11 downto 0),
      S00_AXI_arlen(3 downto 0) => processing_system7_0_M_AXI_GP0_ARLEN(3 downto 0),
      S00_AXI_arlock(1 downto 0) => processing_system7_0_M_AXI_GP0_ARLOCK(1 downto 0),
      S00_AXI_arprot(2 downto 0) => processing_system7_0_M_AXI_GP0_ARPROT(2 downto 0),
      S00_AXI_arqos(3 downto 0) => processing_system7_0_M_AXI_GP0_ARQOS(3 downto 0),
      S00_AXI_arready => processing_system7_0_M_AXI_GP0_ARREADY,
      S00_AXI_arsize(2 downto 0) => processing_system7_0_M_AXI_GP0_ARSIZE(2 downto 0),
      S00_AXI_arvalid => processing_system7_0_M_AXI_GP0_ARVALID,
      S00_AXI_awaddr(31 downto 0) => processing_system7_0_M_AXI_GP0_AWADDR(31 downto 0),
      S00_AXI_awburst(1 downto 0) => processing_system7_0_M_AXI_GP0_AWBURST(1 downto 0),
      S00_AXI_awcache(3 downto 0) => processing_system7_0_M_AXI_GP0_AWCACHE(3 downto 0),
      S00_AXI_awid(11 downto 0) => processing_system7_0_M_AXI_GP0_AWID(11 downto 0),
      S00_AXI_awlen(3 downto 0) => processing_system7_0_M_AXI_GP0_AWLEN(3 downto 0),
      S00_AXI_awlock(1 downto 0) => processing_system7_0_M_AXI_GP0_AWLOCK(1 downto 0),
      S00_AXI_awprot(2 downto 0) => processing_system7_0_M_AXI_GP0_AWPROT(2 downto 0),
      S00_AXI_awqos(3 downto 0) => processing_system7_0_M_AXI_GP0_AWQOS(3 downto 0),
      S00_AXI_awready => processing_system7_0_M_AXI_GP0_AWREADY,
      S00_AXI_awsize(2 downto 0) => processing_system7_0_M_AXI_GP0_AWSIZE(2 downto 0),
      S00_AXI_awvalid => processing_system7_0_M_AXI_GP0_AWVALID,
      S00_AXI_bid(11 downto 0) => processing_system7_0_M_AXI_GP0_BID(11 downto 0),
      S00_AXI_bready => processing_system7_0_M_AXI_GP0_BREADY,
      S00_AXI_bresp(1 downto 0) => processing_system7_0_M_AXI_GP0_BRESP(1 downto 0),
      S00_AXI_bvalid => processing_system7_0_M_AXI_GP0_BVALID,
      S00_AXI_rdata(31 downto 0) => processing_system7_0_M_AXI_GP0_RDATA(31 downto 0),
      S00_AXI_rid(11 downto 0) => processing_system7_0_M_AXI_GP0_RID(11 downto 0),
      S00_AXI_rlast => processing_system7_0_M_AXI_GP0_RLAST,
      S00_AXI_rready => processing_system7_0_M_AXI_GP0_RREADY,
      S00_AXI_rresp(1 downto 0) => processing_system7_0_M_AXI_GP0_RRESP(1 downto 0),
      S00_AXI_rvalid => processing_system7_0_M_AXI_GP0_RVALID,
      S00_AXI_wdata(31 downto 0) => processing_system7_0_M_AXI_GP0_WDATA(31 downto 0),
      S00_AXI_wid(11 downto 0) => processing_system7_0_M_AXI_GP0_WID(11 downto 0),
      S00_AXI_wlast => processing_system7_0_M_AXI_GP0_WLAST,
      S00_AXI_wready => processing_system7_0_M_AXI_GP0_WREADY,
      S00_AXI_wstrb(3 downto 0) => processing_system7_0_M_AXI_GP0_WSTRB(3 downto 0),
      S00_AXI_wvalid => processing_system7_0_M_AXI_GP0_WVALID
    );
rst_ps7_0_100M: component cantavi_streamer_project_rst_ps7_0_100M_0
     port map (
      aux_reset_in => '1',
      bus_struct_reset(0) => NLW_rst_ps7_0_100M_bus_struct_reset_UNCONNECTED(0),
      dcm_locked => '1',
      ext_reset_in => processing_system7_0_FCLK_RESET0_N,
      interconnect_aresetn(0) => rst_ps7_0_100M_interconnect_aresetn(0),
      mb_debug_sys_rst => '0',
      mb_reset => NLW_rst_ps7_0_100M_mb_reset_UNCONNECTED,
      peripheral_aresetn(0) => rst_ps7_0_100M_peripheral_aresetn(0),
      peripheral_reset(0) => NLW_rst_ps7_0_100M_peripheral_reset_UNCONNECTED(0),
      slowest_sync_clk => clk_wiz_0_clk_100_out
    );
user_org_plc_seq_ip_0: component cantavi_streamer_project_user_org_plc_seq_ip_0_0
     port map (
      clk_125 => clk_wiz_0_clk_125_out1,
      fifo_empty_in => eth_to_audio_interfa_0_fifo_empty_out,
      fifo_empty_out => user_org_plc_seq_ip_0_fifo_empty_out,
      fifo_full_in => eth_to_audio_interfa_0_fifo_full_out,
      fifo_full_out => user_org_plc_seq_ip_0_fifo_full_out,
      fifo_occ_in(15 downto 0) => B"0000000000000000",
      fm_audio_hdr_valid => audio_to_eth_interfa_0_m_audio_payload_hdr_valid,
      fm_audio_s_axis_aclk => clk_wiz_0_clk_125_out1,
      fm_audio_s_axis_aresetn => Net1,
      fm_audio_s_axis_tdata(7 downto 0) => audio_to_eth_interfa_0_m_audio_payload_axis_TDATA(7 downto 0),
      fm_audio_s_axis_tlast => audio_to_eth_interfa_0_m_audio_payload_axis_TLAST,
      fm_audio_s_axis_tready => audio_to_eth_interfa_0_m_audio_payload_axis_TREADY,
      fm_audio_s_axis_tvalid => audio_to_eth_interfa_0_m_audio_payload_axis_TVALID,
      fm_udp_s_axis_aclk => clk_wiz_0_clk_125_out1,
      fm_udp_s_axis_aresetn => Net1,
      fm_udp_s_axis_tdata(7 downto 0) => full_udp_stack_ip_0_m_ch1_audio_payload_axis_TDATA(7 downto 0),
      fm_udp_s_axis_tlast => full_udp_stack_ip_0_m_ch1_audio_payload_axis_TLAST,
      fm_udp_s_axis_tready => full_udp_stack_ip_0_m_ch1_audio_payload_axis_TREADY,
      fm_udp_s_axis_tvalid => full_udp_stack_ip_0_m_ch1_audio_payload_axis_TVALID,
      new_sample_in => '0',
      play_out_ready_in => '0',
      replace_pkt_in => eth_to_audio_interfa_0_replace_pkt_out,
      s00_axi_aclk => clk_wiz_0_clk_100_out,
      s00_axi_araddr(7 downto 0) => ps7_0_axi_periph_M12_AXI_ARADDR(7 downto 0),
      s00_axi_aresetn => rst_ps7_0_100M_peripheral_aresetn(0),
      s00_axi_arprot(2 downto 0) => ps7_0_axi_periph_M12_AXI_ARPROT(2 downto 0),
      s00_axi_arready => ps7_0_axi_periph_M12_AXI_ARREADY,
      s00_axi_arvalid => ps7_0_axi_periph_M12_AXI_ARVALID,
      s00_axi_awaddr(7 downto 0) => ps7_0_axi_periph_M12_AXI_AWADDR(7 downto 0),
      s00_axi_awprot(2 downto 0) => ps7_0_axi_periph_M12_AXI_AWPROT(2 downto 0),
      s00_axi_awready => ps7_0_axi_periph_M12_AXI_AWREADY,
      s00_axi_awvalid => ps7_0_axi_periph_M12_AXI_AWVALID,
      s00_axi_bready => ps7_0_axi_periph_M12_AXI_BREADY,
      s00_axi_bresp(1 downto 0) => ps7_0_axi_periph_M12_AXI_BRESP(1 downto 0),
      s00_axi_bvalid => ps7_0_axi_periph_M12_AXI_BVALID,
      s00_axi_rdata(31 downto 0) => ps7_0_axi_periph_M12_AXI_RDATA(31 downto 0),
      s00_axi_rready => ps7_0_axi_periph_M12_AXI_RREADY,
      s00_axi_rresp(1 downto 0) => ps7_0_axi_periph_M12_AXI_RRESP(1 downto 0),
      s00_axi_rvalid => ps7_0_axi_periph_M12_AXI_RVALID,
      s00_axi_wdata(31 downto 0) => ps7_0_axi_periph_M12_AXI_WDATA(31 downto 0),
      s00_axi_wready => ps7_0_axi_periph_M12_AXI_WREADY,
      s00_axi_wstrb(3 downto 0) => ps7_0_axi_periph_M12_AXI_WSTRB(3 downto 0),
      s00_axi_wvalid => ps7_0_axi_periph_M12_AXI_WVALID,
      status1_out => user_org_plc_seq_ip_0_status1_out,
      status2_out => user_org_plc_seq_ip_0_status2_out,
      to_audio_m_axis_aclk => clk_wiz_0_clk_125_out1,
      to_audio_m_axis_aresetn => Net1,
      to_audio_m_axis_tdata(7 downto 0) => user_org_plc_seq_ip_0_to_audio_m_axis_TDATA(7 downto 0),
      to_audio_m_axis_tlast => user_org_plc_seq_ip_0_to_audio_m_axis_TLAST,
      to_audio_m_axis_tready => user_org_plc_seq_ip_0_to_audio_m_axis_TREADY,
      to_audio_m_axis_tvalid => user_org_plc_seq_ip_0_to_audio_m_axis_TVALID,
      to_udp_hdr_valid => user_org_plc_seq_ip_0_to_udp_hdr_valid,
      to_udp_m_axis_aclk => clk_wiz_0_clk_125_out1,
      to_udp_m_axis_aresetn => Net1,
      to_udp_m_axis_tdata(7 downto 0) => user_org_plc_seq_ip_0_to_udp_m_axis_TDATA(7 downto 0),
      to_udp_m_axis_tlast => user_org_plc_seq_ip_0_to_udp_m_axis_TLAST,
      to_udp_m_axis_tready => user_org_plc_seq_ip_0_to_udp_m_axis_TREADY,
      to_udp_m_axis_tvalid => user_org_plc_seq_ip_0_to_udp_m_axis_TVALID
    );
xlconcat_0: component cantavi_streamer_project_xlconcat_0_0
     port map (
      In0(0) => FILTER_IIR_0_FILTER_DONE,
      In1(0) => Volume_Pregain_0_OUT_RDY,
      In2(0) => FILTER_IIR_1_FILTER_DONE,
      In3(0) => Volume_Pregain_1_OUT_RDY,
      In4(0) => pmod_controller_0_Rotary_event,
      In5(0) => axi_gpio_0_ip2intc_irpt,
      In6(0) => axi_gpio_1_ip2intc_irpt,
      In7(0) => axi_gpio_2_ip2intc_irpt,
      In8(0) => audio_to_eth_interfa_0_irq_out,
      In9(0) => eth_to_audio_interfa_0_irq_out,
      dout(9 downto 0) => xlconcat_0_dout(9 downto 0)
    );
end STRUCTURE;
