//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
//Date        : Tue Mar 21 22:49:47 2023
//Host        : JAIRE running 64-bit Arch Linux
//Command     : generate_target cantavi_streamer_project_wrapper.bd
//Design      : cantavi_streamer_project_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module cantavi_streamer_project_wrapper
   (DC,
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    RES,
    SCLK,
    SDIN,
    VBAT,
    VDD,
    adau1761_adc_sdata_0,
    adau1761_bclk_0,
    adau1761_cclk_0,
    adau1761_cdata_0,
    adau1761_clatchn_0,
    adau1761_cout_0,
    adau1761_dac_sdata_0,
    adau1761_lrclk_0,
    adau1761_mclk,
    bclk1_0,
    btnc_0,
    btnd_0,
    btnl_0,
    btnr_0,
    btnu_0,
    clk_100_in,
    ctrl_sw_out_0,
    led_0,
    lrclk1_0,
    mclk1_0,
    phy_int_n_0,
    phy_mdc_0,
    phy_mdio_0,
    phy_pme_n_0,
    phy_reset_n_0,
    phy_rx_clk_0,
    phy_rx_ctl_0,
    phy_rxd_0,
    phy_tx_clk_0,
    phy_tx_ctl_0,
    phy_txd_0,
    serial_data_in1_0,
    serial_data_out1_0,
    sw_0,
    sync_en_out_0,
    tsync_out_0);
  output DC;
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  output RES;
  output SCLK;
  output SDIN;
  output VBAT;
  output VDD;
  input adau1761_adc_sdata_0;
  input adau1761_bclk_0;
  output adau1761_cclk_0;
  output adau1761_cdata_0;
  output adau1761_clatchn_0;
  input adau1761_cout_0;
  output adau1761_dac_sdata_0;
  input adau1761_lrclk_0;
  output adau1761_mclk;
  output bclk1_0;
  input btnc_0;
  input btnd_0;
  input btnl_0;
  input btnr_0;
  input btnu_0;
  input clk_100_in;
  output ctrl_sw_out_0;
  output [7:0]led_0;
  output lrclk1_0;
  output mclk1_0;
  input phy_int_n_0;
  output phy_mdc_0;
  inout phy_mdio_0;
  input phy_pme_n_0;
  output phy_reset_n_0;
  input phy_rx_clk_0;
  input phy_rx_ctl_0;
  input [3:0]phy_rxd_0;
  output phy_tx_clk_0;
  output phy_tx_ctl_0;
  output [3:0]phy_txd_0;
  input serial_data_in1_0;
  output serial_data_out1_0;
  input [7:0]sw_0;
  output sync_en_out_0;
  output tsync_out_0;

  wire DC;
  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire RES;
  wire SCLK;
  wire SDIN;
  wire VBAT;
  wire VDD;
  wire adau1761_adc_sdata_0;
  wire adau1761_bclk_0;
  wire adau1761_cclk_0;
  wire adau1761_cdata_0;
  wire adau1761_clatchn_0;
  wire adau1761_cout_0;
  wire adau1761_dac_sdata_0;
  wire adau1761_lrclk_0;
  wire adau1761_mclk;
  wire bclk1_0;
  wire btnc_0;
  wire btnd_0;
  wire btnl_0;
  wire btnr_0;
  wire btnu_0;
  wire clk_100_in;
  wire ctrl_sw_out_0;
  wire [7:0]led_0;
  wire lrclk1_0;
  wire mclk1_0;
  wire phy_int_n_0;
  wire phy_mdc_0;
  wire phy_mdio_0;
  wire phy_pme_n_0;
  wire phy_reset_n_0;
  wire phy_rx_clk_0;
  wire phy_rx_ctl_0;
  wire [3:0]phy_rxd_0;
  wire phy_tx_clk_0;
  wire phy_tx_ctl_0;
  wire [3:0]phy_txd_0;
  wire serial_data_in1_0;
  wire serial_data_out1_0;
  wire [7:0]sw_0;
  wire sync_en_out_0;
  wire tsync_out_0;

  cantavi_streamer_project cantavi_streamer_project_i
       (.DC(DC),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .RES(RES),
        .SCLK(SCLK),
        .SDIN(SDIN),
        .VBAT(VBAT),
        .VDD(VDD),
        .adau1761_adc_sdata_0(adau1761_adc_sdata_0),
        .adau1761_bclk_0(adau1761_bclk_0),
        .adau1761_cclk_0(adau1761_cclk_0),
        .adau1761_cdata_0(adau1761_cdata_0),
        .adau1761_clatchn_0(adau1761_clatchn_0),
        .adau1761_cout_0(adau1761_cout_0),
        .adau1761_dac_sdata_0(adau1761_dac_sdata_0),
        .adau1761_lrclk_0(adau1761_lrclk_0),
        .adau1761_mclk(adau1761_mclk),
        .bclk1_0(bclk1_0),
        .btnc_0(btnc_0),
        .btnd_0(btnd_0),
        .btnl_0(btnl_0),
        .btnr_0(btnr_0),
        .btnu_0(btnu_0),
        .clk_100_in(clk_100_in),
        .ctrl_sw_out_0(ctrl_sw_out_0),
        .led_0(led_0),
        .lrclk1_0(lrclk1_0),
        .mclk1_0(mclk1_0),
        .phy_int_n_0(phy_int_n_0),
        .phy_mdc_0(phy_mdc_0),
        .phy_mdio_0(phy_mdio_0),
        .phy_pme_n_0(phy_pme_n_0),
        .phy_reset_n_0(phy_reset_n_0),
        .phy_rx_clk_0(phy_rx_clk_0),
        .phy_rx_ctl_0(phy_rx_ctl_0),
        .phy_rxd_0(phy_rxd_0),
        .phy_tx_clk_0(phy_tx_clk_0),
        .phy_tx_ctl_0(phy_tx_ctl_0),
        .phy_txd_0(phy_txd_0),
        .serial_data_in1_0(serial_data_in1_0),
        .serial_data_out1_0(serial_data_out1_0),
        .sw_0(sw_0),
        .sync_en_out_0(sync_en_out_0),
        .tsync_out_0(tsync_out_0));
endmodule
