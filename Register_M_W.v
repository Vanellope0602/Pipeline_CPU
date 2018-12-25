`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:00:45 12/19/2018 
// Design Name: 
// Module Name:    Register_M_W 
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
module Register_M_W(
    input clk,
    input reset,
	 
    input [31:0] instr_M,
    input [31:0] DMout_M,
    input [31:0] ALUout_M,
	 input [4:0] A3_M,
    input [31:0] PC_plus4_M,
    input [31:0] PC_plus8_M,
	 
    output [31:0] instr_W,
    output [31:0] DMout_W,
    output [31:0] ALUout_W,
	 output [4:0] A3_W,
    output [31:0] PC_plus4_W,
    output [31:0] PC_plus8_W
    );
    
    reg [31:0] instr;
    reg [31:0] memdata;
    reg [31:0] ALUresult;
	 reg [4:0] A3;
    reg [31:0] PCAdd4;
    reg [31:0] PCAdd8;

    assign instr_W = instr;
    assign DMout_W = memdata;
    assign ALUout_W = ALUresult;
	 assign A3_W = A3;
    assign PC_plus4_W = PCAdd4;
    assign PC_plus8_W = PCAdd8;
	 
	 initial begin
				instr <= 0;
            memdata <= 0;
            ALUresult <= 0;
				A3 <= 0;
            PCAdd4 <= 0;
            PCAdd8 <= 0;
	 end

    always @(posedge clk) begin
        if (reset) begin
            instr <= 0;
            memdata <= 0;
            ALUresult <= 0;
				A3 <= 0;
            PCAdd4 <= 0;
            PCAdd8 <= 0;
        end
        else if (reset == 0) begin
            instr <= instr_M;
            memdata <= DMout_M;
            ALUresult <= ALUout_M;
				A3 <= A3_M;
            PCAdd4 <= PC_plus4_M;
            PCAdd8 <= PC_plus8_M;
        end
    end



endmodule
