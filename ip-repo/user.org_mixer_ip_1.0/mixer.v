// S_AXIS is syncronized to the M_AXIS port's VALID signal which is controlled by the codec  
// no timescale needed
`timescale 1ns/1ns

module mixer #(
parameter AUDIO_WIDTH = 24,
parameter DATA_WIDTH = 32
)(
input ACLK,
    input ARESETN,
    input M_AXIS_TREADY,
    output reg M_AXIS_TVALID,
    output reg M_AXIS_TLAST,
    output reg [DATA_WIDTH - 1:0] M_AXIS_TDATA,

    
    input CH_1_S_AXIS_ACLK,
    input CH_1_S_AXIS_ARESETN,
    input CH_1_S_AXIS_TVALID,
    input [DATA_WIDTH - 1:0] CH_1_S_AXIS_TDATA,
    input CH_1_S_AXIS_TLAST,
    output reg CH_1_S_AXIS_TREADY,
    
    
    input CH_2_S_AXIS_ACLK,
    input CH_2_S_AXIS_ARESETN,
    input CH_2_S_AXIS_TVALID,
    input [DATA_WIDTH - 1:0] CH_2_S_AXIS_TDATA,
    input CH_2_S_AXIS_TLAST,
    output reg CH_2_S_AXIS_TREADY


//output [AUDIO_WIDTH - 1:0] audio_mixed_a_b_left_out,
//output [AUDIO_WIDTH - 1:0] audio_mixed_a_b_right_out,
//input [AUDIO_WIDTH - 1:0] audio_channel_a_left_in,
//input [AUDIO_WIDTH - 1:0] audio_channel_a_right_in,
//input [AUDIO_WIDTH - 1:0] audio_channel_b_left_in,
//input [AUDIO_WIDTH - 1:0] audio_channel_b_right_in
);

wire [AUDIO_WIDTH - 1:0] audio_mixed_a_b_left_out;
wire [AUDIO_WIDTH - 1:0] audio_mixed_a_b_right_out;

reg [AUDIO_WIDTH - 1:0] audio_channel_a_left_in;
reg [AUDIO_WIDTH - 1:0] audio_channel_a_right_in;
reg [AUDIO_WIDTH - 1:0] audio_channel_b_left_in;
reg [AUDIO_WIDTH - 1:0] audio_channel_b_right_in;

  assign audio_mixed_a_b_left_out = (((audio_channel_a_left_in[AUDIO_WIDTH - 1:0])) + ((audio_channel_b_left_in[AUDIO_WIDTH - 1:0])));
  assign audio_mixed_a_b_right_out = (((audio_channel_a_right_in[AUDIO_WIDTH - 1:0])) + ((audio_channel_b_right_in[AUDIO_WIDTH - 1:0])));
  
  
  //--------------------------------------------------------------------------------------------------------------------
  always @(posedge CH_1_S_AXIS_ACLK)
        if (!CH_1_S_AXIS_ARESETN)
            CH_1_S_AXIS_TREADY <= 0;
//        else if (CH_1_S_AXIS_TREADY && CH_1_S_AXIS_TVALID)
//            CH_1_S_AXIS_TREADY <= 0;
//        else if (wsp && CH_1_S_AXIS_TLAST == wsd)
//            CH_1_S_AXIS_TREADY <= 1;
         else if(!M_AXIS_TVALID)
            CH_1_S_AXIS_TREADY <= 1;
        else 
            CH_1_S_AXIS_TREADY <= 0;

    always @(posedge CH_1_S_AXIS_ACLK)
        if (CH_1_S_AXIS_TREADY && CH_1_S_AXIS_TVALID && !CH_1_S_AXIS_TLAST)
            audio_channel_a_left_in <= CH_1_S_AXIS_TDATA;

    always @(posedge CH_1_S_AXIS_ACLK)
        if (CH_1_S_AXIS_TREADY && CH_1_S_AXIS_TVALID && CH_1_S_AXIS_TLAST)
            audio_channel_a_right_in <= CH_1_S_AXIS_TDATA;
            
//--------------------------------------------------------------------------------------------------           
            
    always @(posedge CH_2_S_AXIS_ACLK)
        if (!CH_2_S_AXIS_ARESETN)
            CH_2_S_AXIS_TREADY <= 0;
//        else if (CH_2_S_AXIS_TREADY && CH_2_S_AXIS_TVALID)
//            CH_2_S_AXIS_TREADY <= 0;
//        else if (wsp && CH_2_S_AXIS_TLAST == wsd)
//            CH_2_S_AXIS_TREADY <= 1;
        else if(!M_AXIS_TVALID)
            CH_2_S_AXIS_TREADY <= 1;
        else 
            CH_2_S_AXIS_TREADY <= 0;


    always @(posedge CH_2_S_AXIS_ACLK)
        if (CH_2_S_AXIS_TREADY && CH_2_S_AXIS_TVALID && !CH_2_S_AXIS_TLAST)
            audio_channel_b_left_in <= CH_2_S_AXIS_TDATA;

    always @(posedge CH_2_S_AXIS_ACLK)
        if (CH_2_S_AXIS_TREADY && CH_2_S_AXIS_TVALID && CH_2_S_AXIS_TLAST)
            audio_channel_b_right_in <= CH_2_S_AXIS_TDATA;
            
//--------------------------------------------------------------------------------------------------       

    always @(posedge ACLK)
            if (!ARESETN) begin
                M_AXIS_TLAST <= 1;
                M_AXIS_TDATA = 0;
            end else
                if (!M_AXIS_TVALID)
                    // setup the left channel
                    if (M_AXIS_TLAST) begin
                        M_AXIS_TDATA[DATA_WIDTH - 1 -: AUDIO_WIDTH] <= audio_mixed_a_b_left_out;
                            
                        M_AXIS_TLAST <= 0;
                    // setup the right channel
                    end else begin
                        M_AXIS_TDATA[DATA_WIDTH - 1 -: AUDIO_WIDTH] <= audio_mixed_a_b_right_out;
                            
                        M_AXIS_TLAST <= 1;
                    end
    
    always @(posedge ACLK)
        if (!ARESETN)
            M_AXIS_TVALID <= 0;
        else if (!M_AXIS_TREADY && !M_AXIS_TVALID)
            M_AXIS_TVALID <= 1;
        else if (M_AXIS_TREADY)
            M_AXIS_TVALID <= ~M_AXIS_TVALID;


endmodule
