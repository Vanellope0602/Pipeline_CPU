`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:00:54 12/21/2018 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] PC,
    output [31:0] instr_F
    );
	 
	 reg [31:0] Memory [1023:0];  //
	 
	 initial 
	   $readmemh("code.txt", Memory);//, 0, 1024
		
	 assign instr_F = Memory[PC[11:2]];  


endmodule
