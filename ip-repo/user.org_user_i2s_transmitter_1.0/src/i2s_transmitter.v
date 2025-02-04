`timescale 1ns/1ns
module i2s_transmitter # (
    parameter DATA_WIDTH = 32,
    parameter AUDIO_WIDTH = 24
) (
//    input S_AXIS_ACLK,
    input S_AXIS_ARESETN,
//    input S_AXIS_TVALID,
//    input [DATA_WIDTH - 1:0] S_AXIS_TDATA,
//    input S_AXIS_TLAST,
//    output reg S_AXIS_TREADY,
    
    input clk_125 , // 100 mhz input clock from top level logic
    input ctrl_sw,
           
    input [AUDIO_WIDTH-1:0] hphone_l  , //samples to head phone jack
    input hphone_l_valid,
           
    input [AUDIO_WIDTH-1:0] hphone_r, 
    input hphone_r_valid, //dummy valid signal to create AXIS interface in Vivado (r and l channel synchronous to hphone_l_valid
           
           
//    input [AUDIO_WIDTH-1:0] line_out_l, //samples to head phone jack
//    input line_out_l_valid,
           
//    input [AUDIO_WIDTH-1:0] line_out_r,
//    input line_out_r_valid,           //dummy valid signal to create AXIS interface in Vivado (r and l channel synchronous to hphone_l_valid
           
           
    
   output reg next_dac_sample, // active for 1 clk cycle if new "line in" sample is tranmitted/received
    
    
    input bclk,  // BCLK in 
    input lrclk,   // LRCLK in 
    output serial_data_out2,   // Serial data out
    
    output serial_data_out1   // Serial data out
    
);


    wire serial_data_out;


	
	assign serial_data_out1 = ctrl_sw == 1 ? serial_data_out : 0;
	assign serial_data_out2 = ctrl_sw == 1 ? 0 : serial_data_out;

    reg [1:0] bclk_ctrl = 0;
    always @(posedge clk_125) begin
        bclk_ctrl <= {bclk_ctrl, bclk};
    end
    wire bclk_rise = bclk_ctrl == 2'b01;
    wire bclk_fall = bclk_ctrl == 2'b10;

    // 2-bit register to control lrclkd and lrclkp signals.
    reg [1:0] data_ctrl = 0;
    always @(posedge bclk) begin
        data_ctrl <= {data_ctrl, lrclk};
    end
//    always @(negedge bclk) begin
//        data_ctrl <= {data_ctrl, lrclk};
//    end
    wire lrclkd = data_ctrl[0]; // word strobe direction: 0 - left, 1 - right
    wire lrclkp = ^data_ctrl; // word strobe pulse --- lr edge detect

    reg [DATA_WIDTH - 1:0] data_left = 0;
    reg [DATA_WIDTH - 1:0] data_right = 0;
    reg [0:DATA_WIDTH - 1] data = 0;
    always @(posedge clk_125) begin
        if (bclk_fall)
            if (lrclkp)
                data <= lrclkd ? data_right : data_left;
            else
                data <= { data[1:DATA_WIDTH - 1], 1'b0 };
    end


// always @(posedge clk_125) begin
        
//            if (lrclkp)
//                data <= lrclkd ? data_right : data_left;
//            else begin
//                if (bclk_fall)
//                    data <= { data[1:DATA_WIDTH - 1], 1'b0 };
//                else
//                    data <= data;
//            end
//    end


//always @(negedge bclk) begin
        
//            if (lrclkp)
//                data <= lrclkd ? data_right : data_left;
//            else begin               
//                data <= { data[1:DATA_WIDTH - 1], 1'b0 };
                
//            end
//    end

    assign serial_data_out = data[0];



always @(posedge clk_125)
        if (!S_AXIS_ARESETN)
            next_dac_sample <= 0;        
        else if (lrclkp && (lrclkd==1)) begin
            next_dac_sample <= 1;
        end   
        else begin
            next_dac_sample <= 0;
        end 

    always @(posedge clk_125) begin
//        if (next_dac_sample) begin
            data_left[DATA_WIDTH - 1 : DATA_WIDTH-AUDIO_WIDTH] <= hphone_l;
            data_right[DATA_WIDTH - 1 : DATA_WIDTH-AUDIO_WIDTH] <= hphone_r;
//        end
end
   

endmodule
