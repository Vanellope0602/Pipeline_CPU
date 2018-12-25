`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:06 12/19/2018 
// Design Name: 
// Module Name:    Register_F_D 
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
module Register_F_D(
    input clk,
    input reset,
    input stall,
    input [31:0] instr_F,
    input [31:0] PC_plus4_F,
    input [31:0] PC_plus8_F,
    output [31:0] instr_D,
    output [31:0] PC_plus4_D,
    output [31:0] PC_plus8_D
    );
	 
	 reg [31:0] PCAdd4;
	 reg [31:0] PCAdd8;
	 reg [31:0] instr;
	 assign PC_plus4_D = PCAdd4;
	 assign PC_plus8_D = PCAdd8;  // next stage 
	 assign instr_D = instr;
	 
	 initial begin
		instr <= 0;
		PCAdd4 <= 32'h00003004;
		PCAdd8 <= 32'h00003008;
	 end

	 always @(posedge clk) begin
	 	if (reset) begin
	 		instr <= 0;
			PCAdd4 <= 32'h00003004;
			PCAdd8 <= 32'h00003008;	
	 	end
	 	else if (reset == 0 && stall == 0) begin
	 		instr <= instr_F;
	 		PCAdd4 <= PC_plus4_F;
	 		PCAdd8 <= PC_plus8_F;
	 	end
		else if (reset == 0 && stall == 1) begin
	 		instr <= instr;
	 		PCAdd4 <= PCAdd4;
	 		PCAdd8 <= PCAdd8;
	 	end
	 end
	 


endmodule
