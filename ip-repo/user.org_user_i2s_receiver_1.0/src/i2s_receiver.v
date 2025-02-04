`timescale 1ns/1ns
module i2s_receiver # (
    parameter DATA_WIDTH = 32,
    parameter AUDIO_WIDTH = 24
) (
//    input ETH_M_AXIS_ACLK,
//    input ETH_M_AXIS_ARESETN,
//    output reg ETH_M_AXIS_TVALID,
//    output reg [DATA_WIDTH - 1:0] ETH_M_AXIS_TDATA,
//    output reg ETH_M_AXIS_TLAST,
//    input ETH_M_AXIS_TREADY,
    
    
//    input LL_M_AXIS_ACLK,
//    input LL_M_AXIS_ARESETN,
//    output reg LL_M_AXIS_TVALID,
//    output reg [DATA_WIDTH - 1:0] LL_M_AXIS_TDATA,
//    output reg LL_M_AXIS_TLAST,
//    input LL_M_AXIS_TREADY,
    
    
   
    input clk_125 , // 100 mhz input clock from top level logic
    input rst ,
    
    input mclk_cw,
    input [7:0] sw,
           
    
    output reg [AUDIO_WIDTH-1:0] line_in_l_125, // samples from "line in" jack    
    output reg [AUDIO_WIDTH-1:0] line_in_r_125,
   
          
   output wire next_adc_sample_out, // active for 1 clk cycle if new "line in" sample is tranmitted/received
           
   
    input bclk, //BCLK
    input lrclk, // LRCLK
    input serial_data_in2,  // Serial Data in
    output mclk, //MCL
    
    
    input serial_data_in1,  // Serial Data in
    output mclk1, //MCL
    output bclk1, //BCLK
    output lrclk1, // LRCLK
    
    
    output ctrl_sw_out

);

    wire serial_data_in;
    wire ctrl_sw;
    wire [7:0] sw_int;

    reg [AUDIO_WIDTH-1:0] line_in_l_125_reg = 0; // samples from "line in" jack    
    reg [AUDIO_WIDTH-1:0] line_in_r_125_reg = 0;
    // 32-bit register for data.
    reg [0:DATA_WIDTH - 1] data;
    reg next_adc_sample;
    reg [1:0] bclk_ctrl = 0;
    
    assign sw_int = sw;
    
    assign ctrl_sw = sw_int[0];    
    assign serial_data_in = ctrl_sw==1 ? serial_data_in1 : serial_data_in2;    
    assign mclk1 = ctrl_sw ==1 ? mclk_cw : 0;
	assign mclk = mclk_cw;	
	assign bclk1 = bclk;
	assign lrclk1 = lrclk;
	assign ctrl_sw_out = ctrl_sw;
    
    
    
    always @(posedge clk_125) begin
        bclk_ctrl <= {bclk_ctrl, bclk};
    end
    wire bclk_rise = bclk_ctrl == 2'b01;
    wire bclk_fall = bclk_ctrl == 2'b10;

    // 2-bit register to control wsd and wsp signals.
    reg [1:0] data_ctrl = 0;
    always @(posedge clk_125) begin
        if (bclk_rise)
            data_ctrl <= {data_ctrl, lrclk};
    end
    wire lrclkd = data_ctrl[0]; // word strobe direction: 0 - left, 1 - right
    wire lrclkp = data_ctrl[1] ^ lrclkd; //lr edge detect 

    reg [$clog2(DATA_WIDTH + 1) - 1:0] counter = 0;
    always @(posedge clk_125) begin
        if (bclk_fall)
            if (lrclkp)
                counter <= 0;
            else
                if (counter < DATA_WIDTH)
                    counter <= counter + 1;
    end

    
    always @(posedge clk_125) begin
        if (bclk_rise) begin
            if (lrclkp)
                data <= 0;
            if (counter < DATA_WIDTH)
                data[counter] <= serial_data_in;
        end
    end


    always @(posedge clk_125) begin
        if (bclk_rise && lrclkp && (!lrclkd)) begin
            line_in_l_125  <= data[0:AUDIO_WIDTH-1]; 
            next_adc_sample <= 0;
        end
        else if(bclk_rise && lrclkp && (lrclkd)) begin
            line_in_r_125  <= data[0:AUDIO_WIDTH-1]; 
            next_adc_sample <= 1;
        end
        
    end


IBUFG
next_sample_ibufg_inst(
    .I(next_adc_sample),
    .O(next_adc_sample_out)
);





endmodule
