
`timescale 1 ns / 1 ps

	module synchronizer_v1_0 #
	(
		// Users to add parameters here
        parameter SIGNAL_WIDTH = 24,
        parameter SYNC_STAGES = 4
		// User parameters ends
		// Do not modify the parameters beyond this line
	)
	(
		// Users to add ports here
        input wire  sync_clk,
		input wire [SIGNAL_WIDTH-1 : 0] signal_in,

		output wire [SIGNAL_WIDTH-1 : 0] signal_out
		// User ports end
		
	);

	// Add user logic here
    sync_signal #(
    .N(SYNC_STAGES),
    .WIDTH(SIGNAL_WIDTH)
)
sync_inst (
    .clk(sync_clk),
    .in(signal_in),
    .out(signal_out)
);
	// User logic ends

	endmodule
