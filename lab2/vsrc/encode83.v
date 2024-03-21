module encode83(
    input [7:0] x,
    input en,
    output reg [2:0] y,
    output reg o
);

always@(x or en) begin
    if(en) begin
        o=1;
        casez(x[7:0])

            /*8'b1xxx_xxxx: y = 7;
            8'b01xx_xxxx: y = 6;
            8'b001x_xxxx: y = 5;
            8'b0001_xxxx: y = 4;
            8'b0000_1xxx: y = 3;
            8'b0000_01xx: y = 2;
            8'b0000_001x: y = 1;
            8'b0000_0001: y = 0;*/
            8'b1???_????: y = 3'b111;
            8'b01??_????: y = 3'b110;
            8'b001?_????: y = 3'b101;
            8'b0001_????: y = 3'b100;
            8'b0000_1???: y = 3'b011;
            8'b0000_01??: y = 3'b010;
            8'b0000_001?: y = 3'b001;
            8'b0000_0001: y = 3'b000;
            default: o=0;
        endcase
    end
end

endmodule


/*
//x：输入信号；en：使能信号；y：输出信号；o指示是否全为0
module encode83(x,en,y,o);
    input [7:0] x;
    input en;
    output reg [2:0] y;
    output reg o;
    integer i;
    always @(x or en) begin
        if(en) begin
            y = 3'b0;
            for(i=0; i<8; i=i+1) begin
                if(x[i] == 0) y = i[2:0];
            end
        end else begin
            o=1'b1;
        end
    end
endmodule
*/
