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


// IP VLNV: user.org:user:i2s_transmitter:1.0
// IP Revision: 39

(* X_CORE_INFO = "i2s_transmitter,Vivado 2018.3" *)
(* CHECK_LICENSE_TYPE = "cantavi_streamer_project_i2s_transmitter_0_0,i2s_transmitter,{}" *)
(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module cantavi_streamer_project_i2s_transmitter_0_0 (
  S_AXIS_ARESETN,
  clk_125,
  ctrl_sw,
  hphone_l,
  hphone_l_valid,
  hphone_r,
  hphone_r_valid,
  next_dac_sample,
  bclk,
  lrclk,
  serial_data_out2,
  serial_data_out1
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S_AXIS_ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S_AXIS_ARESETN RST" *)
input wire S_AXIS_ARESETN;
input wire clk_125;
input wire ctrl_sw;
input wire [23 : 0] hphone_l;
input wire hphone_l_valid;
input wire [23 : 0] hphone_r;
input wire hphone_r_valid;
output wire next_dac_sample;
input wire bclk;
input wire lrclk;
output wire serial_data_out2;
output wire serial_data_out1;

  i2s_transmitter #(
    .DATA_WIDTH(32),
    .AUDIO_WIDTH(24)
  ) inst (
    .S_AXIS_ARESETN(S_AXIS_ARESETN),
    .clk_125(clk_125),
    .ctrl_sw(ctrl_sw),
    .hphone_l(hphone_l),
    .hphone_l_valid(hphone_l_valid),
    .hphone_r(hphone_r),
    .hphone_r_valid(hphone_r_valid),
    .next_dac_sample(next_dac_sample),
    .bclk(bclk),
    .lrclk(lrclk),
    .serial_data_out2(serial_data_out2),
    .serial_data_out1(serial_data_out1)
  );
endmodule
