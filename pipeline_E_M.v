`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:42:19 12/19/2018 
// Design Name: 
// Module Name:    pipeline_E_M 
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
module Register_E_M(
    input clk,
    input reset,
    input [31:0] instr_E,
    input [31:0] ALUout_E,
    input [31:0] WriteData_E,
	 
	 input [4:0] rt_E,
	 input [4:0] A3_E,
    input [4:0] WriteReg_E,// no use 
    input [31:0] PC_plus4_E,
    input [31:0] PC_plus8_E,
	 
    output [31:0] instr_M,
    output [31:0] ALUout_M,
    output [31:0] WriteData_M,
	 output [4:0] rt_M,
	 output [4:0] A3_M,
    output [4:0] WriteReg_M,
    output [31:0] PC_plus4_M,
    output [31:0] PC_plus8_M
    );
	 reg [31:0] instr;
	 reg [31:0] ALUresult;
	 reg [31:0] data;
	 reg [4:0] rt;
	 reg [4:0] A3;
     reg [4:0] WriteReg;
	 reg [31:0] PCAdd4;
	 reg [31:0] PCAdd8;
	 
	  assign instr_M = instr;
     assign ALUout_M = ALUresult;
     assign WriteData_M = data;
	  assign rt_M = rt;
	  assign A3_M = A3;
     assign WriteReg_M = WriteReg;
     assign PC_plus4_M = PCAdd4;
     assign PC_plus8_M = PCAdd8;
	  
	  initial begin
				instr <= 0;
             ALUresult <= 0;
             data <= 0;
				 rt <= 0;
				 A3 <= 0;
             WriteReg <= 0;
             PCAdd4 <= 0;
             PCAdd8 <= 0;
	  end

     always @(posedge clk) begin
         if (reset) begin
             instr <= 0;
             ALUresult <= 0;
             data <= 0;
				 rt <= 0;
				 A3 <= 0;
             WriteReg <= 0;
             PCAdd4 <= 0;
             PCAdd8 <= 0;
         end
         else if (reset == 0) begin
             instr <= instr_E;
             ALUresult <= ALUout_E;
             data <= WriteData_E;
				 rt <= rt_E;
				 A3 <= A3_E;
             WriteReg <= WriteReg_E;
             PCAdd4 <= PC_plus4_E;
             PCAdd8 <= PC_plus8_E;
         end
     end


endmodule
