
//sw[15:13]代表功能选择
//sw[7:4]代表A，sw[3:0]代表B
//ledr[5]代表溢出，ledr[4]代表进位
//ledr[3:0]代表结果输出

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

`define OP_WIDTH 3
`define ALU_WIDTH 4

`define ADD_OP 3'b000
`define SUB_OP 3'b001
`define NOT_OP 3'b010
`define AND_OP 3'b011
`define OR_OP  3'b100
`define XOR_OP 3'b101
`define CMP_OP 3'b110
`define EQ_OP  3'b111

//手册建议使用button来选择，但是只有5个按钮,故使用了sw[15:13]来进行功能选择
wire [`OP_WIDTH-1:0] alu_op;
assign alu_op = sw[15:13];

//sw[7:4]作为操作数A，sw[3:0]作为操作数B, sw[8]为进位。
wire [`ALU_WIDTH-1:0] A;
wire [`ALU_WIDTH-1:0] B;
wire Cin;
assign A = sw[7:4];
assign B = sw[3:0];
assign Cin = sw[8];

//使用ledr[3:0]作为结果输出,ledr[4]为溢出
reg [`ALU_WIDTH-1:0] Result;
wire Carry;
wire Overflow;
assign ledr[4] = Carry;
assign ledr[5] = Overflow;

always@(*) begin
    ledr[3:0]= Result;
end

wire zero; //是否加减法输出为0
assign zero = ~(|addsum_out);


wire [`ALU_WIDTH-1:0] addsum_out; //加减运算的结果
wire [`ALU_WIDTH-1:0] B_tmp;


assign B_tmp = alu_op == `ADD_OP ? (B) : (~B + 1);

assign { Carry, addsum_out } = A + B_tmp;


//在有符号数加法中，如果两个相加的数符号相同，但结果的符号与它们不同，那么就发生了溢出。
assign Overflow = (A[`ALU_WIDTH-1] == B_tmp[`ALU_WIDTH-1]) &&
                    (addsum_out[`ALU_WIDTH-1] != A[`ALU_WIDTH-1]);


//assign ledr[11] = (A[`ALU_WIDTH-1] == t_add_Cin[`ALU_WIDTH-1]);
//assign ledr[10] = (  (addsum_out[`ALU_WIDTH-1] != A[`ALU_WIDTH-1]));

wire lt; //是否A<B

assign lt = addsum_out[`ALU_WIDTH-1];



always@(*) begin
	if(rst == 1'b1) begin
		Result =  `ALU_WIDTH'b0;
	end
	else begin
		case(alu_op)
            `ADD_OP: begin
                Result = addsum_out;
            end
            `SUB_OP: begin
                Result = addsum_out;
            end
			`NOT_OP: begin
				Result = ~A;
			end
			`AND_OP: begin
				Result = A&B;
			end
			`OR_OP: begin
				Result = A|B;
			end
			`XOR_OP: begin
                Result = A^B;
            end
            `CMP_OP: begin
                Result = {{(`ALU_WIDTH-1){1'b0}}, lt};
            end
            `EQ_OP: begin
                Result = {{(`ALU_WIDTH-1){1'b0}}, zero};
            end
			default: begin
				Result = `ALU_WIDTH'b0;
			end
		endcase
	end
end




endmodule




