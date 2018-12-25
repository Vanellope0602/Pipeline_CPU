`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:52:08 12/21/2018 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input clk,
    input reset,
    input [31:0] PC,
    input [31:0] address,
	 input MemWrite,
    input [31:0] MemData,
    output [31:0] data_output
    );
	 integer i;
	 reg [31:0] Memory [1023:0];
	 
	 assign data_output = Memory[address[11:2]];
	 
	 initial begin
		for(i = 0; i<=1023; i = i+1)
			Memory[i] = 0;
	 end
	 always @(posedge clk) begin
		if(reset == 0) begin
			if(MemWrite) begin
				Memory[address[11:2]] <= MemData;
				//$display("memory data ");
				$display("%d@%h: *%h <= %h", $time, PC, address,MemData); 
			end
			
		end
		else if(reset == 1) begin
			for(i = 0; i<=1023; i = i+1)
				Memory[i] <= 0;
		end
	 end


endmodule
