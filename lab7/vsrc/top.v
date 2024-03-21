//ps/2键盘输入实验

/*
七段数码管低两位显示当前按键的键码，中间两位显示对应的ASCII码(字符和数字)
当按键松开时，七段数码管的低四位全灭。
七段数码管的高两位显示按键的总次数。。
*/

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


//parameter [15:0][7:0] SEG_TABLE = {
//    8'b0000_1001, // 0
//    8'b0000_0001, // 1
//    8'b0001_1111, // 2
//    8'b0100_0001, // 3
//    8'b0100_1001, // 4
//    8'b1001_1001, // 5
//    8'b0000_1101, // 6
//    8'b0010_0101, // 7
//    8'b1001_1111, // 8
//    8'b0000_0011, // 9
//    8'b0001_0001, // A
//    8'b1100_0001, // B
//    8'b0110_0011, // C
//    8'b1000_0101, // D
//    8'b0110_0001, // E
//    8'b0111_0001  // F
//};


//assign seg1 = 8'b0001_0001; //A
//assign seg2 = 8'b1100_0001; //B
//assign seg3 = 8'b0110_0011; //C
//assign seg4 = 8'b1000_0101; //D
//assign seg5 = 8'b0110_0001; //E
//assign seg6 = 8'b0111_0001; //F

wire ready;
wire overflow;
reg [7:0]data;
reg nextdata_n;
reg unsigned [3:0]number;
reg [7:0]data_buf[1:0]; //两个字节，可判断按下和松开 

reg [4:0] seg0_data; //最高位存储是否关闭数码管(1关闭)，低3位存储数值
reg [4:0] seg1_data;
reg [4:0] seg2_data;
reg [4:0] seg3_data;
reg [4:0] seg6_data;
reg [4:0] seg7_data;

assign seg4 = 8'hff;
assign seg5 = 8'hff;

//数码管数值到段码的解析
seg_decoder u_seg_decoder0(
	.binary_input 	( seg0_data  ),
	.seg_output   	( seg0    )
);

seg_decoder u_seg_decoder1(
	.binary_input 	( seg1_data  ),
	.seg_output   	( seg1    )
);

seg_decoder u_seg_decoder2(
	.binary_input 	( seg2_data  ),
	.seg_output   	( seg2    )
);

seg_decoder u_seg_decoder3(
	.binary_input 	( seg3_data  ),
	.seg_output   	( seg3    )
);

seg_decoder u_seg_decoder6(
	.binary_input 	( seg6_data  ),
	.seg_output   	( seg6    )
);

seg_decoder u_seg_decoder7(
	.binary_input 	( seg7_data  ),
	.seg_output   	( seg7    )
);





assign ledr[7:0] = data;



//获取按键键值
ps2_keyboard keyboard1(
    .clk(clk),
    .clrn(~rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .data(data),
    .ready(ready),
    .nextdata_n(nextdata_n),
    .overflow(overflow)
);

// outports wire
wire [7:0] 	ascii_code;

// 按键的键值转换到ASCII码
scan_to_ascii u_scan_to_ascii(
	.scan_code  	( data_buf[0]   ),
	.ascii_code 	( ascii_code  )
);

reg [7:0] count; // 记录按键按下松开的次数

//获取按键数据，并将其存到缓冲区。
//判断按下和松开，并用数码管显示
always @(posedge clk) begin
    if(rst == 1'b1) begin
        data_buf[0] <= 8'h0;
        data_buf[1] <= 8'h0;
        count <= 8'h0;
        seg0_data <= 5'h10; 
        seg1_data <= 5'h10;
        seg2_data <= 5'h10;
        seg3_data <= 5'h10;
        seg6_data <= 5'h00;
        seg7_data <= 5'h00;
    end
    else begin
        if(ready) begin
            nextdata_n <= 1'b0;
            //data_buf <= {data_buf[0],data};
			data_buf[1] <= data_buf[0];
			data_buf[0] <= data;
            $display("data_buf[1]:%x, data_buf[0]:%x", data_buf[1],data_buf[0]);
            
            if(data_buf[1] != 8'hf0 && data_buf[0] != 8'hf0) begin
                //seg[0] <= SEG_TABLE[2];
                $display("data_buf[0](scan_code):%x, ascii_code:%x", data_buf[0],ascii_code);  
                $display("seg1:%b, seg0:%b", seg1,seg0);
                $display("seg1:%b, seg0:%b", seg7,seg6);
                seg0_data  <= {1'b0, data_buf[0][3:0]};
                seg1_data  <= {1'b0, data_buf[0][7:4]};
                seg2_data  <= {1'b0, ascii_code[3:0]};
                seg3_data  <= {1'b0, ascii_code[7:4]};
            end
            else begin
                seg0_data  <= {5'h10};  //最高位为1时，关闭数码管
                seg1_data  <= {5'h10};
                seg2_data  <= {5'h10};
                seg3_data  <= {5'h10};
            end

            if(data_buf[1] == 8'hf0 && data_buf[0] != 8'hf0)begin
                count <= count + 1;
                $display("count: 0x%h ", (count)); 
                seg6_data  <= {1'b0, count[3:0]};
                seg7_data  <= {1'b0, count[7:4]};
                //$display("count[3:0] = 0x%h, seg6 = 0x%h", count[3:0], seg6);
                //$display("count[7:4] = 0x%h, seg7 = 0x%h", count[7:4], seg7);
            end

        end
        else begin 
            nextdata_n <= 1'b1;
        end
    end
end 

endmodule




