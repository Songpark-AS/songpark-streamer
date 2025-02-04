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


// IP VLNV: user.org:user:i2s_receiver:1.0
// IP Revision: 45

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module cantavi_streamer_project_i2s_receiver_0_0 (
  clk_125,
  rst,
  mclk_cw,
  sw,
  line_in_l_125,
  line_in_r_125,
  next_adc_sample_out,
  bclk,
  lrclk,
  serial_data_in2,
  mclk,
  serial_data_in1,
  mclk1,
  bclk1,
  lrclk1,
  ctrl_sw_out
);

input wire clk_125;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
input wire mclk_cw;
input wire [7 : 0] sw;
output wire [23 : 0] line_in_l_125;
output wire [23 : 0] line_in_r_125;
output wire next_adc_sample_out;
input wire bclk;
input wire lrclk;
input wire serial_data_in2;
output wire mclk;
input wire serial_data_in1;
output wire mclk1;
output wire bclk1;
output wire lrclk1;
output wire ctrl_sw_out;

  i2s_receiver #(
    .DATA_WIDTH(32),
    .AUDIO_WIDTH(24)
  ) inst (
    .clk_125(clk_125),
    .rst(rst),
    .mclk_cw(mclk_cw),
    .sw(sw),
    .line_in_l_125(line_in_l_125),
    .line_in_r_125(line_in_r_125),
    .next_adc_sample_out(next_adc_sample_out),
    .bclk(bclk),
    .lrclk(lrclk),
    .serial_data_in2(serial_data_in2),
    .mclk(mclk),
    .serial_data_in1(serial_data_in1),
    .mclk1(mclk1),
    .bclk1(bclk1),
    .lrclk1(lrclk1),
    .ctrl_sw_out(ctrl_sw_out)
  );
endmodule
