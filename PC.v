`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:10:40 12/21/2018 
// Design Name: 
// Module Name:    PC 
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
module PC(
    input [31:0] nextPC,
	 input clk,
    input reset,
    input EN,   // connect to "stall"
    output [31:0] PCout
    );
	 reg [31:0] PC;
	 assign PCout = PC;
	 initial begin
		PC = 32'h00003000;
	 end
	 always @(posedge clk) begin
		if(reset) 
			PC = 32'h00003000; // clear 
		else if(reset == 0 && EN == 1) 
			PC<= nextPC;  // move to NPC
		else if(reset == 0 && EN == 0)
			PC <= PC;     // remain frozen 
	 end

endmodule
