`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:13:19 12/21/2018 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
    input clk,
    input reset,
	 
	 //functional import
    input [1:0] ext_op_D,
    input if_beq_D,
    input ALUsrc_E,        // ALU src "s" is the small letter
    input [2:0] ALUctr_E,
    input [1:0] RegDst_E,
    input MemWrite_M,
    input RegWrite_W,
    input [1:0] Mem_to_Reg_W,
    /*input if_j,
    input if_jal,
    input if_jr,    // this information has been contained in instr_D
    */
	  
	 // hazard import 
    input stall,
    input [2:0] fwd_sel_D1,
    input [2:0] fwd_sel_D2,
    input [2:0] fwd_sel_E1,
    input [2:0] fwd_sel_E2,
    input [2:0] fwd_sel_M,
	 
	 // signal out transfer to hazard unit 
	 output [4:0] rs_D,
	 output [4:0] rt_D,
	 output [4:0] rd_D,
	 
	 output [4:0] rs_E,
	 output [4:0] rt_E,
	 output [4:0] A3_E,
	 
	 output [4:0] rt_M,
	 output [4:0] A3_M,
	 
	 output [4:0] A3_W,
	 
	 output [31:0] instr_D,
	 output [31:0] instr_M,
	 output [31:0] instr_E,
	 output [31:0] instr_W
    );

    wire [31:0] instr_F;    //instr_D,instr_E,instr_M, instr_W;
    wire [31:0] PC, NPCout;
    wire [31:0] PC_plus4_F, PC_plus4_D, PC_plus4_E, PC_plus4_M, PC_plus4_W;
    wire [31:0] PC_plus8_F, PC_plus8_D, PC_plus8_E, PC_plus8_M, PC_plus8_W;
    assign PC_plus4_F = PC + 4;
    //assign PC_plus8_F = PC + 8;

    wire [4:0] rd_E;  //rs_D, rs_E, rt_D, rt_E, rt_M, rd_D    have been define in output line 
    wire [31:0] RD1_out, RD2_out;  // connect to the port of GPR 
    wire [31:0] v1_D, v2_D, v1_E, v2_E;

    wire Branch;
    assign Branch = ((v1_D == v2_D) && if_beq_D == 1)? 1:0;  // can be replace by CMP 

    wire [15:0] imm;
    wire [31:0] ext_imm_D, ext_imm_E;

    wire [31:0] ALU_A, ALU_B;
    wire [31:0] ALUout_E, ALUout_M, ALUout_W;
    wire [31:0] WriteData_E, WriteData_M, fwd_M_out;
    wire [31:0] mem_out_M, mem_out_W;


    wire [31:0] result_W;
	 
	 assign rs_D = instr_D[25:21];
	 assign rt_D = instr_D[20:16];
	 assign rd_D = instr_D[15:11];
	 assign imm = instr_D[15:0];
	 
    

	 
	 //complete
	 NPC nextPC (
    .PC(PC),         // After D level decode, and then decide to branch ,the PC input has already added 4 !!!! 
    .Branch(Branch),  
    .GPRrs(v1_D), 
    .instr(instr_D),       // !!! After the first Decode 
    .NPCout(NPCout), 
    .PC_plus8(PC_plus8_F)  //assign PC_plus8_F = PC + 8;
    );
	 
    //complete
	 PC pc (
    .nextPC(NPCout), 
    .clk(clk), 
    .reset(reset), 
    .EN( ~stall ), 
    .PCout(PC)
    );
	 //complete
	 IM instr_mem(
    .PC(PC), 
    .instr_F(instr_F)
    );
	 // dont need to change 
	 Register_F_D pipelineFD (
    .clk(clk), 
    .reset(reset), 
    .stall(stall), 
    .instr_F(instr_F), 
    .PC_plus4_F(PC_plus4_F), 
    .PC_plus8_F(PC_plus8_F), 
    .instr_D(instr_D), 
    .PC_plus4_D(PC_plus4_D), 
    .PC_plus8_D(PC_plus8_D)
    );
	 
     //complete
	 GPR Regfile (
    .PC(PC_plus4_W - 4),    // PC+4 - 4 is the real PC of current instruction  
    .clk(clk), 
    .reset(reset), 
    .RegWrite(RegWrite_W),  // transfer from W level 
    .A1(rs_D), 
    .A2(rt_D), 
    .A3(A3_W), 
    .RegData(result_W), 
    .RD1(RD1_out), 
    .RD2(RD2_out)
    );
	 
     //complete
	 ext extender (
    .imm(imm), 
    .Ext_op(ext_op_D), 
    .out(ext_imm_D)
    );
	 
	 mux_forward fwdD1 (
    .in0(RD1_out), 
    .in1(result_W),   // it contains selected data including ALU , DM ,PC
    .in2(ALUout_M), 
    .in3(PC_plus8_M), 
    .in4(PC_plus8_E),
    .sel(fwd_sel_D1), 
    .out(v1_D)
    );
	 
	 mux_forward fwdD2 (
    .in0(RD2_out), 
    .in1(result_W),        // it contains selected data including ALU , DM ,PC
    .in2(ALUout_M), 
    .in3(PC_plus8_M), 
    .in4(PC_plus8_E),
    .sel(fwd_sel_D2), 
    .out(v2_D)
    );   // complete
	 
	 Register_D_E pipelineDE (
    .clk(clk), 
    .reset(reset), 
	 .stall(stall),
    .instr_D(instr_D), 
    .RD1_D(v1_D), 
    .RD2_D(v2_D), 
    .rs_D(rs_D), 
    .rt_D(rt_D), 
    .rd_D(rd_D), 
    .ext_imm_D(ext_imm_D), 
    .PC_plus4_D(PC_plus4_D), 
    .PC_plus8_D(PC_plus8_D), 
	 
    .RD1_E(v1_E), 
    .RD2_E(v2_E), 
    .rs_E(rs_E), 
    .rt_E(rt_E), 
    .rd_E(rd_E), 
    .ext_imm_E(ext_imm_E), 
    .PC_plus4_E(PC_plus4_E), 
    .PC_plus8_E(PC_plus8_E), 
    .instr_E(instr_E)
    );   //complete 
	 
	 mux_regdst mux_Rdst (
    .in0(rt_E), 
    .in1(rd_E), 
    .in2(),     // write $31 
    .RegDst(RegDst_E), 
    .mux_regdst_out(A3_E)
    ); // complete 
	 
	 mux_forward fwdE1 (
    .in0(v1_E), 
    .in1(result_W), 
    .in2(ALUout_M), 
    .in3(PC_plus8_M), 
    .sel(fwd_sel_E1), 
    .out(ALU_A)
    );
	 
	 mux_forward fwdE2 (
    .in0(v2_E), 
    .in1(result_W), 
    .in2(ALUout_M), 
    .in3(PC_plus8_M), 
    .sel(fwd_sel_E2), 
    .out(WriteData_E)
    );
	 
	 mux_alusrc mux_ALUsrc (
    .in0(WriteData_E), 
    .in1(ext_imm_E), 
    .ALUSrc(ALUsrc_E), 
    .mux_alusrc_out(ALU_B)
    );
	 
	 ALU alu_ins (  
    .A(ALU_A), 
    .B(ALU_B), 
    .ALUop(ALUctr_E), 
    .result(ALUout_E)
    //.zero(zero)
    );  //complete 
	 
	 Register_E_M pipelineEM (
    .clk(clk), 
    .reset(reset), 
    .instr_E(instr_E), 
    .ALUout_E(ALUout_E), 
    .WriteData_E(WriteData_E), 
    .rt_E(rt_E), 
    .A3_E(A3_E),

    .PC_plus4_E(PC_plus4_E), 
    .PC_plus8_E(PC_plus8_E), 
	 
    .instr_M(instr_M), 
    .ALUout_M(ALUout_M), 
    .WriteData_M(WriteData_M), 
    .rt_M(rt_M), 
    .A3_M(A3_M),
 
    .PC_plus4_M(PC_plus4_M), 
    .PC_plus8_M(PC_plus8_M)
    ); // complete 


	 mux_forward fwd_M (
    .in0(WriteData_M), 
    .in1(result_W), 
    .in2(), 
    .in3(), 
    .sel(fwd_sel_M), 
    .out(fwd_M_out)
    ); // complete 
	 
	 DM Data_Memory (
    .clk(clk), 
    .reset(reset), 
    .PC(PC_plus4_M - 4), 
    .address(ALUout_M), 
    .MemWrite(MemWrite_M), 
    .MemData(fwd_M_out), 
    .data_output(mem_out_M)
    );

	 
	 Register_M_W pipelineMW (
    .clk(clk), 
    .reset(reset), 
    .instr_M(instr_M), 
    .DMout_M(mem_out_M), 
    .ALUout_M(ALUout_M), 
    .A3_M(A3_M), 
    .PC_plus4_M(PC_plus4_M), 
    .PC_plus8_M(PC_plus8_M), 
    .instr_W(instr_W), 
    .DMout_W(mem_out_W), 
    .ALUout_W(ALUout_W), 
    .A3_W(A3_W), 
    .PC_plus4_W(PC_plus4_W), 
    .PC_plus8_W(PC_plus8_W)
    );  // complete 
	 
	 mux_memtoreg mux_Mem2Reg (
    .in0(ALUout_W), 
    .in1(mem_out_W), 
    .in2(PC_plus8_W), 
    .in3(),          // wait for new instructon to insert 
    .MemtoReg(Mem_to_Reg_W), 
    .mux_memtoreg_out(result_W)
    );



endmodule
