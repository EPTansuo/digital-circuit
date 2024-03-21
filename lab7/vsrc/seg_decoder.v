module seg_decoder(
    input [4:0] binary_input, // 最高位存储是否关闭数码管(1关闭)，低3位存储数值
    output reg [7:0] seg_output // 8-bit 段码值
);

always @(binary_input) begin
    case(binary_input)
		5'h00: seg_output = 8'b0000_0011; // 0
        5'h01: seg_output = 8'b1001_1111; // 1
        5'h02: seg_output = 8'b0010_0101; // 2
        5'h03: seg_output = 8'b0000_1101; // 3
        5'h04: seg_output = 8'b1001_1001; // 4
        5'h05: seg_output = 8'b0100_1001; // 5
        5'h06: seg_output = 8'b0100_0001; // 6
        5'h07: seg_output = 8'b0001_1111; // 7
        5'h08: seg_output = 8'b0000_0001; // 8
        5'h09: seg_output = 8'b0000_1001; // 9
        5'h0A: seg_output = 8'b0001_0001; // A
        5'h0B: seg_output = 8'b1100_0001; // B
        5'h0C: seg_output = 8'b0110_0011; // C
        5'h0D: seg_output = 8'b1000_0101; // D
        5'h0E: seg_output = 8'b0110_0001; // E
        5'h0F: seg_output = 8'b0111_0001; // F
        default: seg_output = 8'b1111_1111; // 关闭数码管
    endcase
    //$display("binary_input = 0x%h, seg_output = 0x%h", binary_input, seg_output);
end

endmodule
