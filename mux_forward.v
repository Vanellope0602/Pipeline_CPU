`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:32:19 12/21/2018 
// Design Name: 
// Module Name:    mux_forward 
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
module mux_forward(   // can be instantiated for lots of time 
    input [31:0] in0,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
	 input [31:0] in4,
    input [2:0] sel,
    output [31:0] out
    );
	 
	 assign out = (sel == 1)? in1 :
					  (sel == 2)? in2 : 
					  (sel == 3)? in3: 
					  (sel == 4)? in4 : in0;

endmodule
