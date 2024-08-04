`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/13 21:17:25
// Design Name: 
// Module Name: Divider
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


module Divider(
    input I_CLK,
    output reg  O_CLK_1M=0
    );
    parameter size=32'd30000000;
    integer i = 0;
    always@(posedge I_CLK) begin
    i=i+1;   
    if(i >= size) begin 
    i=0;
    O_CLK_1M=!O_CLK_1M;
    end  
    end
endmodule

