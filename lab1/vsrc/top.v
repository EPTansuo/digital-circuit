
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


wire [1:0] data[3:0];


genvar i;
generate
    for(i = 0; i < 4; i = i + 1) begin
        assign data[i] = {sw[2*i+3], sw[2*i+2]};
    end
endgenerate

/*
assign data[0] = {sw[3],sw[2]};
assign data[1] = {sw[5],sw[4]};
assign data[2] = {sw[7],sw[6]};
assign data[3] = {sw[9],sw[8]};
*/
mux41b u1(
  .a(data),
  .s(sw[1:0]),
  .y(ledr[1:0]));


endmodule

module mux41b(a,s,y);
  input  [1:0] a[3:0];
  input  [1:0] s;
  output [1:0] y;
  MuxKeyWithDefault #(4, 2, 2) i0 (y, s, 2'b00, {
    2'b00, a[0],
    2'b01, a[1],
    2'b10, a[2],
    2'b11, a[3]
  });
endmodule
