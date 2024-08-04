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
    sign_flag=1;//�з���
    MUL_A='hf;
    MUL_B='h7;
    #10 sign_flag=0;//�޷���
    end
    MUL  MUL_1(
    .sign_flag(sign_flag),  //�Ƿ����з��ų˷�
    .A(MUL_A),              //����ĳ���A
    .B(MUL_B),              //����ĳ���B
    .HI(MUL_HI),            //��32λ���
    .LO(MUL_LO)             //��32λ���
    );
endmodule
