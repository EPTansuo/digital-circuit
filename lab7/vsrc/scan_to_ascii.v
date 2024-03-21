module scan_to_ascii (
    input wire [7:0] scan_code,
    output reg [7:0] ascii_code
);

always @(scan_code) begin
    case (scan_code)
        // 字母a-z
        8'h1C: ascii_code = "a";
        8'h32: ascii_code = "b";
        8'h21: ascii_code = "c";
        8'h23: ascii_code = "d";
        8'h24: ascii_code = "e";
        8'h2B: ascii_code = "f";
        8'h34: ascii_code = "g";
        8'h33: ascii_code = "h";
        8'h43: ascii_code = "i";
        8'h3B: ascii_code = "j";
        8'h42: ascii_code = "k";
        8'h4B: ascii_code = "l";
        8'h3A: ascii_code = "m";
        8'h31: ascii_code = "n";
        8'h44: ascii_code = "o";
        8'h4D: ascii_code = "p";
        8'h15: ascii_code = "q";
        8'h2D: ascii_code = "r";
        8'h1B: ascii_code = "s";
        8'h2C: ascii_code = "t";
        8'h3C: ascii_code = "u";
        8'h2A: ascii_code = "v";
        8'h1D: ascii_code = "w";
        8'h22: ascii_code = "x";
        8'h35: ascii_code = "y";
        8'h1A: ascii_code = "z";
        // 数字0-9
        8'h45: ascii_code = "0";
        8'h16: ascii_code = "1";
        8'h1E: ascii_code = "2";
        8'h26: ascii_code = "3";
        8'h25: ascii_code = "4";
        8'h2E: ascii_code = "5";
        8'h36: ascii_code = "6";
        8'h3D: ascii_code = "7";
        8'h3E: ascii_code = "8";
        8'h46: ascii_code = "9";
        default: ascii_code = 8'h00; // 如果不是字母或数字，则返回0
    endcase
end

endmodule
