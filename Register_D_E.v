`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:44:18 12/19/2018 
// Design Name: 
// Module Name:    Register_D_E 
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
module Register_D_E(
    input clk,
    input reset,
	 input stall,
    input [31:0] instr_D,
    input [31:0] RD1_D,
    input [31:0] RD2_D,
	 input [4:0] rs_D,
	 input [4:0] rt_D,
	 input [4:0] rd_D,
	 input [31:0] ext_imm_D,
    input [31:0] PC_plus4_D,
    input [31:0] PC_plus8_D,
	 
    output [31:0] RD1_E,
    output [31:0] RD2_E,
	 output [4:0] rs_E,
	 output [4:0] rt_E,
	 output [4:0] rd_E,
	 input [31:0] ext_imm_E,
    output [31:0] PC_plus4_E,
    output [31:0] PC_plus8_E,
    output [31:0] instr_E
    );
	 reg [31:0] RD1;
	 reg [31:0] RD2;
	 reg [4:0] rs, rt, rd;
	 reg [31:0] ext_imm;
 	 reg [31:0] PCAdd4;
	 reg [31:0] PCAdd8;
	 reg [31:0] instr;
	 
	 assign RD1_E = RD1;
	 assign RD2_E = RD2;
	 assign rs_E = rs;
	 assign rt_E = rt;
	 assign rd_E = rd;
	 assign ext_imm_E = ext_imm;
	 assign PC_plus4_E = PCAdd4;
	 assign PC_plus8_E = PCAdd8;  // next stage 
	 assign instr_E = instr;
	 
	 initial begin
		instr <= 0;
		RD1 <= 0;
		RD2 <= 0;
		rs <= 0;
		rt <= 0;
		rd <= 0;
		ext_imm <= 0;
		PCAdd4 <= 32'h00003004;
		PCAdd8 <= 32'h00003008;
	 end

	 always @(posedge clk) begin
	 	if (reset || stall ) begin
	 		instr <= 0;
			RD1 <= 0;
			RD2 <= 0;
			rs <= 0;
			rt <= 0;
			rd <= 0;
			ext_imm <= 0;
			PCAdd4 <= 32'h00003004;
			PCAdd8 <= 32'h00003008;	
	 	end
	 	else if (reset == 0) begin
	 		instr <= instr_D;
			RD1 <= RD1_D;
			RD2 <= RD2_D;
			rs <= rs_D;
			rt <= rt_D;
			rd <= rd_D;
			ext_imm <= ext_imm_D;
	 		PCAdd4 <= PC_plus4_D;
	 		PCAdd8 <= PC_plus8_D;
	 	end
	 end


endmodule
