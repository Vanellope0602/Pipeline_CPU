`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:29 12/21/2018 
// Design Name: 
// Module Name:    NPC 
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
`define beq     (`Opcode == 6'b000100)
`define j	    (`Opcode == 6'b000010)
`define jal     (`Opcode == 6'b000011)
`define jr      (`R & (`Funct == 6'b001000))
module NPC(
    input [31:0] PC,
    input Branch,
    input [31:0] GPRrs,  // input from the V1_D out line 
    input [31:0] instr,
    output [31:0] NPCout,
    output [31:0] PC_plus8
    );
	 /*PC      type 0
	  *branch  type 1
	  * j /jal type 2
	  * jr     type 3
	 */
	 assign PC_plus8 = PC + 8;
	 wire [1:0] sel;
	 assign sel = (Branch == 1) ? 1:
					  (`j || `jal)  ? 2:
					  (`jr )			 ? 3:0;
					  //PC + 4 + { {14{instr[15]}} , instr[15:0] , 2'b00} 
	 assign NPCout = (sel == 1)? ( PC + { {14{instr[15]}} , instr[15:0] , 2'b00} ) : // signed ext can be done like this 
						  (sel == 2)? { PC[31:28] , instr[25:0] , 2'b00} :
						  (sel == 3)? GPRrs : (PC+4) ;
	

endmodule
