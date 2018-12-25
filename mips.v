`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:48 12/22/2018 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mips(
    input clk,
    input reset
    );

    wire [31:0] instr_D, instr_E, instr_M, instr_W;

    wire RegWrite_W;// W need
    wire [1:0] Mem_to_Reg_W;// W need
    wire MemWrite_M; // M need
    wire [2:0] ALUctr_E;// E need , 3 bits 
    wire ALUsrc_E;   // E need
     
    wire if_j;
    wire if_jal;
    wire if_jr;
    wire [1:0] RegDst_E;// E need
    wire [1:0] ext_op_D; // D need
    wire if_beq_D;// D need

    wire [1:0] res_D, res_E, res_M, res_W;
    wire stall;
    wire [4:0] rd_D, rt_D, rs_D, rs_E, rt_E, A3_E, rt_M, A3_M, A3_W;
    wire [2:0] fwd_sel_D1, fwd_sel_D2, fwd_sel_E1, fwd_sel_E2, fwd_sel_M;
	 
	 control ctrl_D (
    .instr(instr_D), 
    .Ext_op(ext_op_D), 
    .Branch_on_equal(if_beq_D),  // port: branch on equal ; wire's name: if_beq_D
	 .res(res_D)
    );
	 
	 control ctrl_E (
    .instr(instr_E), 
    .ALUctr(ALUctr_E), 
    .ALUsrc(ALUsrc_E), 
    .RegDst(RegDst_E),
	 .res(res_E)
    );
	 
	 control ctrl_M (
    .instr(instr_M), 
    .MemWrite(MemWrite_M),
	 .res(res_M)
    );

	control ctrl_W (
    .instr(instr_W), 
    .RegWrite(RegWrite_W), 
    .Mem_to_Reg(Mem_to_Reg_W),
	 .res(res_W)
    );
	 
	 datapath datapath(
     .clk(clk), 
    .reset(reset), 
    .ext_op_D(ext_op_D), 
    .if_beq_D(if_beq_D), 
    .ALUsrc_E(ALUsrc_E), 
    .ALUctr_E(ALUctr_E), 
    .RegDst_E(RegDst_E), 
    .MemWrite_M(MemWrite_M), 
    .RegWrite_W(RegWrite_W), 
    .Mem_to_Reg_W(Mem_to_Reg_W), 
    .stall(stall), 
    .fwd_sel_D1(fwd_sel_D1), 
    .fwd_sel_D2(fwd_sel_D2), 
    .fwd_sel_E1(fwd_sel_E1), 
    .fwd_sel_E2(fwd_sel_E2), 
    .fwd_sel_M(fwd_sel_M), 
    .rs_D(rs_D), 
    .rt_D(rt_D), 
    .rd_D(rd_D), 
    .rs_E(rs_E), 
    .rt_E(rt_E), 
    .A3_E(A3_E), 
    .rt_M(rt_M), 
    .A3_M(A3_M), 
    .A3_W(A3_W), 
    .instr_D(instr_D), 
    .instr_M(instr_M), 
    .instr_E(instr_E), 
    .instr_W(instr_W)
    );
	 
	 HazardUnit hazard (
    .rs_D(rs_D), 
    .rt_D(rt_D), 
    .rd_D(rd_D), 
    .res_D(res_D), 
    .rs_E(rs_E), 
    .rt_E(rt_E), 
    .A3_E(A3_E), 
    .res_E(res_E), 
    .rt_M(rt_M), 
    .A3_M(A3_M), 
    .res_M(res_M), 
    .A3_W(A3_W), 
    .res_W(res_W), 
	 
    .instr_D(instr_D), 
    .fwd_sel_D1(fwd_sel_D1), 
    .fwd_sel_D2(fwd_sel_D2), 
    .fwd_sel_E1(fwd_sel_E1), 
    .fwd_sel_E2(fwd_sel_E2), 
    .fwd_sel_M(fwd_sel_M), 
    .stall(stall)
    );




endmodule
