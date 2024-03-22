//如果启用nvboard仿真的话:
//btn[0]代表时钟，为了方便nvboard，不过这里没用
//ledr[7:0]表征寄存器的值，seg[0]代表输出
//rst复位

//如果用verilator波形输出的话：
//观察shift_reg寄存器即可

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

reg [7:0] shift_reg;
reg out;

assign seg0[0] = out;
assign ledr[7:0] = shift_reg;

always @(posedge btn or posedge rst) begin
    if (rst) begin
         shift_reg <= 8'b00000001;
    end 
    else begin
        shift_reg <= { shift_reg[4] ^ shift_reg[3] ^ shift_reg[2] ^ shift_reg[0], shift_reg[7:1]};
	out <= shift_reg[0];
    end
end



endmodule
