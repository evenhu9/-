`timescale 1ns / 1ps
module sccomp_dataflow(
    input clk_in,      
    input reset,     
    output [7 : 0] o_seg,//输出内容
    output [7 : 0] o_sel //片选信号 
    );
wire [31:0] pc,inst;
wire [31:0] pc_out;         
wire [31:0] dm_addr_temp;    
wire [31:0] im_addr_in;     
wire [31:0] im_instr_out;  
assign im_addr_in = pc_out - 32'h00400000;

wire dm_ena;               
wire dm_r, dm_w;          
wire [31:0] dm_addr;       
wire [31:0] dm_data_out;    
wire [31:0] dm_data_w;      
wire sb_flag;               
wire sh_flag;             
wire sw_flag;              
wire lb_flag;          
wire lh_flag;               
wire lbu_flag;         
wire lhu_flag;           
wire lw_flag;              

assign dm_addr = dm_addr_temp -  32'h10010000;
assign pc = pc_out;
assign inst = im_instr_out;
seg7x16 seg7x16_(clk_in, reset, 1, pc, o_seg, o_sel);

Divider Divider_inst(clk_in, clk_cpu);
IMEM imem(.im_addr_in(im_addr_in[12:2]),.im_instr_out(im_instr_out) );

DMEM dmem(                          
    .dm_clk(clk_cpu),
    .dm_ena(dm_ena),                
    .dm_r(dm_r), 
    .dm_w(dm_w),
    .sb_flag(sb_flag),
    .sh_flag(sh_flag),
    .sw_flag(sw_flag),
    .lb_flag(lb_flag),
    .lh_flag(lh_flag),
    .lbu_flag(lbu_flag),
    .lhu_flag(lhu_flag),
    .lw_flag(lw_flag),
    .dm_addr(dm_addr[6:0]),
    .dm_data_in(dm_data_w),
    .dm_data_out(dm_data_out)
    );

cpu sccpu(
    .clk(clk_cpu),                   
    .ena(1'b1),                     
    .rst(reset),                    
    .instr_in(im_instr_out),        
    .dm_data(dm_data_out),          
    .dm_ena(dm_ena),                
    .dm_w(dm_w),                    
    .dm_r(dm_r),                    
    .pc_out(pc_out),                
    .dm_addr(dm_addr_temp),         
    .dm_data_w(dm_data_w),          
    .sb_flag(sb_flag),              
    .sh_flag(sh_flag),              
    .sw_flag(sw_flag),              
    .lb_flag(lb_flag),              
    .lh_flag(lh_flag),              
    .lbu_flag(lbu_flag),            
    .lhu_flag(lhu_flag),            
    .lw_flag(lw_flag)               
    );

endmodule
