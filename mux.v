`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:23 12/21/2018 
// Design Name: 
// Module Name:    mux 
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
module mux_regdst(
	input [4:0] in0,
	input [4:0] in1,
	input [4:0] in2,  // if RegDst == 2 , then it's jal , write register $31 
	input [1:0] RegDst,
	output [4:0] mux_regdst_out
    );
	 //assign in2 = 31;
	 assign mux_regdst_out = (RegDst == 1)? in1 :
									 (RegDst == 2)? 5'b11111 : in0;
endmodule

module mux_alusrc(
	input [31:0] in0,
	input [31:0] in1,
	input ALUSrc,     // its "S" capital 
	output [31:0] mux_alusrc_out

);
	assign mux_alusrc_out = (ALUSrc == 1)? in1 :in0;
	
endmodule 

module mux_memtoreg(  // select 32-bit data 
	input [31:0] in0,
	input [31:0] in1,
	input [31:0] in2,
	input [31:0] in3,
	input [1:0] MemtoReg,
	output [31:0] mux_memtoreg_out

);
	assign mux_memtoreg_out = (MemtoReg == 1)? in1 :
									  (MemtoReg == 2)? in2 : 
									  (MemtoReg == 3)? in3: in0;
endmodule 
