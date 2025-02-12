// File mixer.vhd translated with vhd2vl v2.4 VHDL to Verilog RTL translator
// vhd2vl settings:
//  * Verilog Module Declaration Style: 1995

// vhd2vl is Free (libre) Software:
//   Copyright (C) 2001 Vincenzo Liguori - Ocean Logic Pty Ltd
//     http://www.ocean-logic.com
//   Modifications Copyright (C) 2006 Mark Gonzales - PMC Sierra Inc
//   Modifications (C) 2010 Shankar Giri
//   Modifications Copyright (C) 2002, 2005, 2008-2010 Larry Doolittle - LBNL
//     http://doolittle.icarus.com/~larry/vhd2vl/
//
//   vhd2vl comes with ABSOLUTELY NO WARRANTY.  Always check the resulting
//   Verilog for correctness, ideally with a formal verification tool.
//
//   You are welcome to redistribute vhd2vl under certain conditions.
//   See the license (GPLv2) file included with the source for details.

// The result of translation follows.  Its copyright status should be
// considered unchanged from the original VHDL.

// no timescale needed

module mixer(
audio_mixed_a_b_left_out,
audio_mixed_a_b_right_out,
audio_channel_a_left_in,
audio_channel_a_right_in,
audio_channel_b_left_in,
audio_channel_b_right_in
);

parameter [31:0] size=24;
output [size - 1:0] audio_mixed_a_b_left_out;
output [size - 1:0] audio_mixed_a_b_right_out;
input [size - 1:0] audio_channel_a_left_in;
input [size - 1:0] audio_channel_a_right_in;
input [size - 1:0] audio_channel_b_left_in;
input [size - 1:0] audio_channel_b_right_in;

wire [size - 1:0] audio_mixed_a_b_left_out;
wire [size - 1:0] audio_mixed_a_b_right_out;
wire [size - 1:0] audio_channel_a_left_in;
wire [size - 1:0] audio_channel_a_right_in;
wire [size - 1:0] audio_channel_b_left_in;
wire [size - 1:0] audio_channel_b_right_in;



  assign audio_mixed_a_b_left_out = (((audio_channel_a_left_in[size - 1:0])) + ((audio_channel_b_left_in[size - 1:0])));
  assign audio_mixed_a_b_right_out = (((audio_channel_a_right_in[size - 1:0])) + ((audio_channel_b_right_in[size - 1:0])));

endmodule
