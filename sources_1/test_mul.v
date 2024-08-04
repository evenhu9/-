`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/09 21:41:50
// Design Name: 
// Module Name: test_mul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_mul;
    reg sign_flag=0;
    reg [31:0] MUL_A,MUL_B;
    wire [31:0] MUL_HI,MUL_LO;
    initial begin
    sign_flag=1;//有符号
    MUL_A='hf;
    MUL_B='h7;
    #10 sign_flag=0;//无符号
    end
    MUL  MUL_1(
    .sign_flag(sign_flag),  //是否是有符号乘法
    .A(MUL_A),              //输入的乘数A
    .B(MUL_B),              //输入的乘数B
    .HI(MUL_HI),            //高32位结果
    .LO(MUL_LO)             //低32位结果
    );
endmodule
