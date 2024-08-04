`timescale 1ns / 1ps
module DIV(
    input sign_flag,    //是否是有符号除法
    input [31:0] A,     //输入的被除数
    input [31:0] B,     //输入的除数
    output reg [31:0] R,    //余数
    output reg [31:0] Q     //商
    );

    always @(*) begin
    if(sign_flag)
    {R, Q} <= {$signed(A) % $signed(B), $signed(A) / $signed(B)};//DIV
    else
    {R, Q} <= {A % B, A / B};//DIVU
    end

endmodule
