
//btn[0]给时钟，方便调试
//ledr[7:0]代表输出
//sw[7:0]输入
//sw[15]：L/R，控制左移和右移，1:左移，0:右移
//sw[14]：A/L，算术逻辑选择，置为1为算术移位，置为0为逻辑移位。
//sw[13:11]：移位位数

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

reg [7:0]q;


assign ledr[7:0] = q;

always @(*) begin
    case({sw[15], sw[14]})
        2'b10: q = sw[7:0] << sw[13:11]; // 左移，逻辑移位
        2'b11: q = $signed(sw[7:0]) <<< sw[13:11]; // 左移，算术移位
        2'b00: q = sw[7:0] >> sw[13:11]; // 右移，逻辑移位
        2'b01: q = $signed(sw[7:0]) >>> sw[13:11]; // 右移，算术移位
        default: q = 0;
    endcase
    
end



endmodule




