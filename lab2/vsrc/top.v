//`include "mux_module.v"

//优先编码器,sw[8]使能，sw[7:0]编码

module top(
    input clk,
    input rst,
    input [4:0] btn,
    input [15:0] sw,
    input ps2_clk,
    input ps2_data,
    output [15:0] ledr,
    output VGA_CLK,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_BLANK_N,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B,
    output [7:0] seg0,
    output [7:0] seg1,
    output [7:0] seg2,
    output [7:0] seg3,
    output [7:0] seg4,
    output [7:0] seg5,
    output [7:0] seg6,
    output [7:0] seg7
);
/*
0:b0000_0011
1:b1001_1111
2:b0010_0101
3:b0000_1101
4:b1001_1001
5:b0100_1001
6:b0100_0001
7:b0001_1111
8:b0000_0001
9:b0000_1001
 */

/*
parameter [15:0][7:0] SEG_TABLE = {
    8'b0000_0011, // 0
    8'b1001_1111, // 1
    8'b0010_0101, // 2
    8'b0000_1101, // 3
    8'b1001_1001, // 4
    8'b0100_1001, // 5
    8'b0100_0001, // 6
    8'b0001_1111, // 7
    8'b0000_0001, // 8
    8'b0000_1001, // 9
    8'b0001_0001, // A
    8'b1100_0001, // B
    8'b0110_0011, // C
    8'b1000_0101, // D
    8'b0110_0001, // E
    8'b0111_0001  // F
};
*/



/*
assign seg0 = 8'b0000_0011;
assign seg1 = 8'b1001_1111;
assign seg2 = 8'b0010_0101;
assign seg3 = 8'b0000_1101;
assign seg4 = 8'b1001_1001;
assign seg5 = 8'b0100_1001;
assign seg6 = 8'b0000_1001;
assign seg7 = 8'b0000_0001;
*/


//assign seg0 = SEG_TABLE[0];
//assign seg1 = SEG_TABLE[1];
//assign seg2 = SEG_TABLE[2];

assign seg1 = 8'hff;
assign seg2 = 8'hff;
assign seg3 = 8'hff;
assign seg4 = 8'hff;
assign seg5 = 8'hff;
assign seg6 = 8'hff;
assign seg7 = 8'hff;

//assign seg0 = SEG_TABLE[{1'b0,ledr[2:0]}];

encode83 encode1(sw[7:0], sw[8], ledr[2:0], ledr[4]);

seg_decoder u_seg_decoder(
	.binary_input 	( {!(ledr[4]&sw[8]),1'b0,ledr[2:0]}  ),
	.seg_output   	( seg0    )
);

//assign ledr[8:0] = sw[8:0];

endmodule



