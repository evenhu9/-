`timescale 1ns / 1ps
module cpu(
    input clk,                 
    input ena,                  
    input rst,                  
    input [31:0] instr_in,      
    input [31:0] dm_data,       
    output dm_ena,              
    output dm_w,                
    output dm_r,                
    output [31:0] pc_out,       
    output [31:0] dm_addr,      
    output [31:0] dm_data_w,    
    output sb_flag,             
    output sh_flag,             
    output sw_flag,         
    output lb_flag,           
    output lh_flag,          
    output lbu_flag,            
    output lhu_flag,            
    output lw_flag             
    );
parameter ADD   = 6'd0;
parameter ADDU  = 6'd1;
parameter SUB   = 6'd2;
parameter SUBU  = 6'd3;
parameter AND   = 6'd4;
parameter OR    = 6'd5;
parameter XOR   = 6'd6;
parameter NOR   = 6'd7;
parameter SLT   = 6'd8;
parameter SLTU  = 6'd9;
parameter SLL   = 6'd10;
parameter SRL   = 6'd11;
parameter SRA   = 6'd12;
parameter SLLV  = 6'd13;
parameter SRLV  = 6'd14;
parameter SRAV  = 6'd15;
parameter JR    = 6'd16;
parameter ADDI  = 6'd17;
parameter ADDIU = 6'd18;
parameter ANDI  = 6'd19;
parameter ORI   = 6'd20;
parameter XORI  = 6'd21;
parameter LW    = 6'd22;
parameter SW    = 6'd23;
parameter BEQ   = 6'd24;
parameter BNE   = 6'd25;
parameter SLTI  = 6'd26;
parameter SLTIU = 6'd27;
parameter LUI   = 6'd28;
parameter J     = 6'd29;
parameter JAL   = 6'd30;

parameter CLZ     = 6'd31;
parameter JALR    = 6'd32;
parameter MTHI    = 6'd33;
parameter MTLO    = 6'd34;
parameter MFHI    = 6'd35;
parameter MFLO    = 6'd36;
parameter SB      = 6'd37;
parameter SH      = 6'd38;
parameter LB      = 6'd39;
parameter LH      = 6'd40;
parameter LBU     = 6'd41;
parameter LHU     = 6'd42;
parameter ERET    = 6'd43;
parameter BREAK   = 6'd44;
parameter SYSCALL = 6'd45;
parameter TEQ     = 6'd46;
parameter MFC0    = 6'd47;
parameter MTC0    = 6'd48;
parameter MUL     = 6'd49;
parameter MULTU   = 6'd50;
parameter DIV     = 6'd51;
parameter DIVU    = 6'd52;
parameter BGEZ    = 6'd53;

/* Decoder */ 
wire [53:0] op_flags;           
wire [4:0] RsC;                 
wire [4:0] RtC;               
wire [4:0] RdC;               
wire [4:0] shamt;              
wire [15:0] immediate;          
wire [25:0] address;           

/* Controler */
wire reg_w;                
wire [4:0] cause;              
wire [10:0] mux;               
wire [2:0]  mux6_1;            
wire [2:0]  mux6_2;            
wire [4:0] ext_ena;            
wire cat_ena;                  

/* ALU */
wire [31:0] a, b;                       
wire [3:0]  aluc;                      
wire [31:0] alu_data_out;               
wire zero, carry, negative, overflow;   

/* RegFile */
wire [31:0] Rd_data_in;     
wire [31:0] Rs_data_out;    
wire [31:0] Rt_data_out;    

/* PC�Ĵ��� */
wire [31:0] pc_addr_in;   
wire [31:0] pc_addr_out;    

/* HI_LO�Ĵ��� */
wire HI_w;                  
wire LO_w;                 
wire [31:0] HI_out;         
wire [31:0] LO_out;        

/* DIVģ���� */
wire sign_flag;            
wire [31:0] DIV_A;          
wire [31:0] DIV_B;         
wire [31:0] DIV_R;       
wire [31:0] DIV_Q;         

/* MULģ���� */
wire [31:0] MUL_A;          
wire [31:0] MUL_B;          
wire [31:0] MUL_HI;         
wire [31:0] MUL_LO;         

/* CP0ģ���� */
wire [31:0] cp0_out;        
wire [31:0] epc_out;        
/* CLZģ���� */
wire [31:0] CLZ_out;       

/* ���š�������չ����· */
wire [31:0] ext1_out;
wire [31:0] ext5_out;
wire [31:0] ext16_out;
wire signed [31:0] ext16_out_signed;
wire signed [31:0] ext18_out_signed;

assign ext1_out         = (op_flags[SLT]  || op_flags[SLTU]) ? negative : 
                          (op_flags[SLTI] || op_flags[SLTIU]) ? carry : 32'hz;
assign ext5_out         = (op_flags[SLL]  || op_flags[SRL]   || op_flags[SRA]) ? shamt : 32'hz;
assign ext16_out        = (op_flags[ANDI] || op_flags[ORI]   || op_flags[XORI] || op_flags[LUI]) ? { 16'h0 , immediate[15:0] } : 32'hz;
assign ext16_out_signed = (op_flags[ADDI] || op_flags[ADDIU] || op_flags[LW]   || op_flags[SW] || 
                           op_flags[SLTI] || op_flags[SLTIU] || op_flags[SB]   || op_flags[SH] ||
                           op_flags[LB]   || op_flags[LH]    || op_flags[LBU]  || op_flags[LHU]) ?  { {16{immediate[15]}} , immediate[15:0] } : 32'hz;
assign ext18_out_signed = (op_flags[BEQ]  || op_flags[BNE]   || op_flags[BGEZ]) ? {{14{immediate[15]}}, immediate[15:0], 2'b0} : 32'hz;

/* ||ƴ������· */
wire [31:0] cat_out;
assign cat_out = cat_ena ? {pc_out[31:28], address[25:0], 2'h0} : 32'hz;

/* NPC��· */
wire [31:0] npc;
wire [31:0] add_out_61;    //�ӷ�������Ӧ6ѡ1ͨ·
wire [31:0] add_out_62;    //�ӷ�������Ӧ�ڶ���6ѡ1ͨ·
assign npc = pc_addr_out + 4;

/* ��·ѡ������· */
wire [31:0] mux1_out;
wire [31:0] mux2_out;
wire [31:0] mux3_out;
wire [31:0] mux4_out;
wire [31:0] mux5_out;
wire [31:0] mux6_out;
wire [31:0] mux7_out;
wire [31:0] mux8_out;
wire [31:0] mux9_out;
wire [31:0] mux10_out;
wire [31:0] mux6_1_out;
wire [31:0] mux6_2_out;

assign mux1_out  = mux[1]  ? Rt_data_out : Rs_data_out;
assign mux2_out  = mux[2]  ? ext16_out_signed : ext16_out;
assign mux3_out  = mux[3]  ? ext5_out : Rs_data_out;
assign mux4_out  = mux[4]  ? mux2_out : Rt_data_out;
assign mux5_out  = mux[5]  ? mux9_out : Rs_data_out;
assign mux6_out  = mux[6]  ? mux10_out: Rs_data_out;
assign mux7_out  = mux[7]  ? LO_out   : HI_out;
assign mux8_out  = mux[8]  ? alu_data_out : ext1_out;
assign mux9_out  = mux[9]  ? DIV_R : MUL_HI;
assign mux10_out = mux[10] ? DIV_Q : MUL_LO;

/* PC��· */
assign pc_addr_in = mux6_1_out;
assign add_out_61 = ext18_out_signed + npc;
assign add_out_62 = pc_addr_out + 4;

/* ALU ���߿� */
assign a = mux3_out;
assign b = op_flags[BGEZ] ? 32'd0 : mux4_out;

/* IMEM�ӿ� */
assign pc_out = pc_addr_out;

/* DMEM�ӿ� */
assign dm_ena    = (dm_r || dm_w) ? 1'b1 : 1'b0;
assign dm_addr   = alu_data_out;
assign dm_data_w = Rt_data_out;
assign sb_flag   = op_flags[SB];
assign sh_flag   = op_flags[SH];
assign sw_flag   = op_flags[SW];
assign lb_flag   = op_flags[LB];
assign lh_flag   = op_flags[LH];
assign lbu_flag  = op_flags[LBU];
assign lhu_flag  = op_flags[LHU];
assign lw_flag   = op_flags[LW];

/* �Ĵ�������· */
assign Rd_data_in = mux6_2_out;

/* DIV MUL�� */
assign sign_flag = op_flags[MUL] || op_flags[DIV] ? 1'b1 : 1'b0;
assign MUL_A = op_flags[MUL] || op_flags[MULTU] ? Rs_data_out : 32'hz;
assign MUL_B = op_flags[MUL] || op_flags[MULTU] ? Rt_data_out : 32'hz;
assign DIV_A = op_flags[DIV] || op_flags[DIVU]  ? Rs_data_out : 32'hz;
assign DIV_B = op_flags[DIV] || op_flags[DIVU] ? Rt_data_out : 32'hz;

/* ʵ���������� */
Decoder Decoder_inst(
    .instr_in(instr_in),       
    .op_flags(op_flags),        
    .RsC(RsC),                  
    .RtC(RtC),                  
    .RdC(RdC),                  
    .shamt(shamt),              
    .immediate(immediate),      
    .address(address)           
    );

/* ʵ���������� */
Controler Controler_inst(              
    .op_flags(op_flags),       
    .zero_flag(zero),         
    .sign_flag(negative),    
    .reg_w(reg_w),             
    .aluc(aluc),              
    .dm_r(dm_r),              
    .dm_w(dm_w),             
    .HI_w(HI_w),              
    .LO_w(LO_w),              
    .cause(cause),            
    .ext_ena(ext_ena),         
    .cat_ena(cat_ena),        
    .mux(mux),                
    .mux6_1(mux6_1),          
    .mux6_2(mux6_2)            
    );

/* ʵ����ALU */
ALU ALU_inst(                      
    .A(a),                      //��ӦA�ӿ�
    .B(b),                      //��ӦB�ӿ�
    .ALUC(aluc),                //ALUC��λ����ָ��
    .alu_data_out(alu_data_out),//�������
    .zero(zero),                //ZF��־λ��BEQ/BNEʹ��
    .carry(carry),              //CF��־λ��SLTI/SLTIUʹ��
    .negative(negative),        //NF(SF)��־λ��SLT/SLTUʹ��
    .overflow(overflow)         //OF��־λ����ʵû���õ�
    );

/* ʵ�����Ĵ����� */
regfile cpu_ref(                
    .reg_clk(clk),             
    .reg_ena(ena),             
    .rst(rst),                  
    .reg_w(reg_w),              
    .RdC(RdC),                
    .RtC(RtC),                  
    .RsC(RsC),                  
    .Rd_data_in(Rd_data_in),    
    .Rs_data_out(Rs_data_out),  
    .Rt_data_out(Rt_data_out)   
    );

/* ʵ����PC�Ĵ��� */
PC PC_inst(                     
    .pc_clk(clk),               
    .pc_ena(ena),             
    .rst(rst),                  
    .pc_addr_in(pc_addr_in),    
    .pc_addr_out(pc_addr_out)   
    );

/* ʵ����HI_LO�Ĵ��� */
HI_LO HI_LO_inst(
    .HI_LO_clk(clk),            
    .HI_LO_ena(ena),            
    .HI_LO_rst(rst),            
    .HI_in(mux5_out),              
    .LO_in(mux6_out),              
    .HI_w(HI_w),                
    .LO_w(LO_w),                
    .HI_out(HI_out),            
    .LO_out(LO_out)             
    );

MUX MUX6_1(                 //ѡPC
    .chosen(mux6_1),        
    .line0(Rs_data_out),    
    .line1(npc),            
    .line2(add_out_61),     
    .line3(32'h00400004),   //����
    .line4(epc_out),        
    .line5(cat_out),        
    .line6(32'bz),          
    .line7(32'bz),          
    .MUX_out(mux6_1_out)   
    );

MUX MUX6_2(          
    .chosen(mux6_2),        
    .line0(dm_data),        
    .line1(mux7_out),       
    .line2(CLZ_out),        
    .line3(mux8_out),       
    .line4(32'bz),         
    .line5(add_out_62),     
    .line6(cp0_out),          
    .line7(32'bz),          
    .MUX_out(mux6_2_out)    
    );

DIV DIV_inst(
    .sign_flag(sign_flag),  
    .A(DIV_A),              
    .B(DIV_B),              
    .R(DIV_R),              
    .Q(DIV_Q)               
    );

MUL MUL_inst(
    .sign_flag(sign_flag),  
    .A(MUL_A),              
    .B(MUL_B),             
    .HI(MUL_HI),            
    .LO(MUL_LO)             
    );

CP0 CP0_inst(
    .cp0_clk(clk),         
    .cp0_rst(rst),          
    .cp0_ena(ena),          
    .MFC0(op_flags[MFC0]),   
    .MTC0(op_flags[MTC0]),   
    .ERET(op_flags[ERET]),   
    .PC(npc),       
    .addr(mux1_out),        
    .cause(cause),          
    .data_in(Rt_data_out),  
    .CP0_out(cp0_out),      
    .EPC_out(epc_out)       
    );

CLZ CLZ_inst(
    .CLZ_in(Rs_data_out),   
    .CLZ_out(CLZ_out)        
    );

endmodule
