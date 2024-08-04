`timescale 1ns / 1ps
module regfile(                 
    input  reg_clk,            
    input  reg_ena,          
    input  rst,                
    input  reg_w,              
    input  [4:0] RdC,         
    input  [4:0] RtC,        
    input  [4:0] RsC,       
    input  [31:0] Rd_data_in,   
    output [31:0] Rs_data_out,  
    output [31:0] Rt_data_out   
    );
reg [31:0] array_reg [31:0];   
assign Rs_data_out = reg_ena ? array_reg[RsC] : 32'bz;
assign Rt_data_out = reg_ena ? array_reg[RtC] : 32'bz;  

always @(negedge reg_clk or posedge rst)  
begin
    if(rst && reg_ena)  
    begin
        array_reg[0]  <= 32'h0;
        array_reg[1]  <= 32'h0;
        array_reg[2]  <= 32'h0;
        array_reg[3]  <= 32'h0;
        array_reg[4]  <= 32'h0;
        array_reg[5]  <= 32'h0;
        array_reg[6]  <= 32'h0;
        array_reg[7]  <= 32'h0;
        array_reg[8]  <= 32'h0;
        array_reg[9]  <= 32'h0;
        array_reg[10] <= 32'h0;
        array_reg[11] <= 32'h0;
        array_reg[12] <= 32'h0;
        array_reg[13] <= 32'h0;
        array_reg[14] <= 32'h0;
        array_reg[15] <= 32'h0;
        array_reg[16] <= 32'h0;
        array_reg[17] <= 32'h0;
        array_reg[18] <= 32'h0;
        array_reg[19] <= 32'h0;
        array_reg[20] <= 32'h0;
        array_reg[21] <= 32'h0;
        array_reg[22] <= 32'h0;
        array_reg[23] <= 32'h0;
        array_reg[24] <= 32'h0;
        array_reg[25] <= 32'h0;
        array_reg[26] <= 32'h0;
        array_reg[27] <= 32'h0;
        array_reg[28] <= 32'h0;
        array_reg[29] <= 32'h0;
        array_reg[30] <= 32'h0;
        array_reg[31] <= 32'h0;
    end
    else if(reg_ena && reg_w && (RdC != 0)) 
        array_reg[RdC] <= Rd_data_in;
end

endmodule
