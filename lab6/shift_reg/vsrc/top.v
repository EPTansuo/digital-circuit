

//ledr[7:0]代表各个位
//btn[0]给时钟，方便nvboard手动调时钟
//sw[0]给输入
//sw[15]控制左移和右移，1:左移，0:右移


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

always@(posedge btn[0] or posedge rst) begin
    if(rst == 1'b1) begin
        q <= 8'b0;
    end
    else begin
        if(sw[15]==1'b0) begin
            q <= {sw[0],q[7:1]};
        end
        else begin
            q<= {q[6:0],sw[0]};
        end
    end
end





endmodule




