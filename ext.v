`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:54:42 12/21/2018 
// Design Name: 
// Module Name:    ext 
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
module ext(
    input [15:0] imm,
    input [1:0] Ext_op,
    output [31:0] out
    );
	 
	 assign out = (Ext_op == 1) ? { {16{imm[15]}} , imm} : // signed extend
					  (Ext_op == 2) ? {imm, 16'b0000_0000_0000_0000 } : // to high
					  (Ext_op == 3) ? {32'h00000000} : {16'b0000_0000_0000_0000, imm} ;
	

endmodule
