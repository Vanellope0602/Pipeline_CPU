`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:18:25 12/19/2018 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUop,
    output reg [31:0] result,
    output zero
    );
	 
	 assign zero = (A == B)? 1:0;// seems that we dont need this sentence, CMP is in D level 
	 always @(*) begin
		case(ALUop)
		  3'b000:
			begin
				result = A + B;
			end
		  
		  3'b001:
		   begin
				result = A - B;
			end
			
		  3'b010:
		   begin
				result = A | B;
			
			end
			
		  3'b011:
		   begin
				result = B;
			end
		  
		  endcase
		  
	 end
	 


endmodule
