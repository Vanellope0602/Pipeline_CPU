`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:45:45 12/19/2018 
// Design Name: 
// Module Name:    control 
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
`define Opcode	instr[31:26]
`define Funct	instr[5:0]
`define R 		(`Opcode == 6'b000000)  // calculation type instr
`define addu	(`R & (`Funct == 6'b100001))
`define subu	(`R & (`Funct == 6'b100011))
`define ori     (`Opcode == 6'b001101)
`define lw      (`Opcode == 6'b100011)
`define sw      (`Opcode == 6'b101011)
`define beq     (`Opcode == 6'b000100)
`define lui     (`Opcode == 6'b001111)
`define j	    (`Opcode == 6'b000010)
`define jal     (`Opcode == 6'b000011)
`define jr      (`R & (`Funct == 6'b001000))

`define ALU 2'b01
`define DM  2'b10
`define PC  2'b11
`define NW  2'b00
module control(
    input [31:0] instr,
    
	output RegWrite,   // W need
    output [1:0] Mem_to_Reg,// W need
    output MemWrite,    // M need
    output [2:0] ALUctr, // E need 
    output ALUsrc,      // E need, 1bit 
	 
	output if_j,
	output if_jal,
	output if_jr,
    output [1:0] RegDst,  // E need
    output [1:0] Ext_op,  // D need
    output Branch_on_equal,// D need
	 output [1:0] res
    );

	assign RegDst = (`addu || `subu ) ? 1:
                    (`jal ) ? 2 : 0; 
    assign Ext_op = (`lw || `sw) ? 1 :  // sign_ext
                    (`lui )? 2 : 0;  // to high 
    assign Branch_on_equal = (`beq )? 1: 0;
	 
	 
	 assign ALUsrc = (`ori || `lw || `sw || `lui )? 1:0;
	
	 assign ALUctr = (`subu || `beq )? 1:  //sub
					     (`ori )? 2:           //or
					     (`lui )? 3: 0;   // 3 remain itself, like lui, immediate was to high at the extender 
					  // actually I think lui use add is ok, cuz rs is always 00000
					  
	 assign MemWrite = (`sw )? 1:0;
	 
	 assign RegWrite = (`addu || `subu || `ori || `lw || `lui || `jal ) ? 1 : 0;
	 assign Mem_to_Reg = (`lw )? 1 :    // mem from DM 
					         (`jal)? 2 : 0; // 2-> PC + 4? PC+ 8
	 

    assign if_j = `j ? 1:0;
    assign if_jal = `jal ? 1:0;
    assign if_jr = `jr ? 1:0;
	 
	 assign res = (`addu || `subu || `ori || `lui ) ? `ALU : 
						(`lw ) ? `DM :
						( `jal )? `PC : `NW;
	 
endmodule

