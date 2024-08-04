`timescale 1ns / 1ps
module DIV(
    input sign_flag,    //�Ƿ����з��ų���
    input [31:0] A,     //����ı�����
    input [31:0] B,     //����ĳ���
    output reg [31:0] R,    //����
    output reg [31:0] Q     //��
    );

    always @(*) begin
    if(sign_flag)
    {R, Q} <= {$signed(A) % $signed(B), $signed(A) / $signed(B)};//DIV
    else
    {R, Q} <= {A % B, A / B};//DIVU
    end

endmodule
