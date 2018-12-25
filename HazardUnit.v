`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:01 12/22/2018 
// Design Name: 
// Module Name:    HazardUnit 
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
`define Opcode  instr[31:26]
`define Funct   instr[5:0]
`define R       (`Opcode == 6'b000000)  // calculation type instr
`define addu    (`R & (`Funct == 6'b100001))
`define subu    (`R & (`Funct == 6'b100011))
`define ori     (`Opcode == 6'b001101)
`define lw      (`Opcode == 6'b100011)
`define sw      (`Opcode == 6'b101011)
`define beq     (`Opcode == 6'b000100)
`define lui     (`Opcode == 6'b001111)
`define j       (`Opcode == 6'b000010)
`define jal     (`Opcode == 6'b000011)
`define jr      (`R & (`Funct == 6'b001000))
/*
res stands for type of instruction , to decide where it writes data, where the data source come from 
*/
`define ALU 2'b01
`define DM  2'b10    //almost refer to the load instruction 
`define PC  2'b11
`define NW  2'b00
module HazardUnit(
    input [4:0] rs_D,
    input [4:0] rt_D,
    input [4:0] rd_D,
    input [1:0] res_D,   
    input [4:0] rs_E,
    input [4:0] rt_E,
    input [4:0] A3_E,
    input [1:0] res_E,
    input [4:0] rt_M,
    input [4:0] A3_M,
    input [1:0] res_M,
    input [4:0] A3_W,
    input [1:0] res_W,
    input [31:0] instr_D,
    output [2:0] fwd_sel_D1,
    output [2:0] fwd_sel_D2,
    output [2:0] fwd_sel_E1,
    output [2:0] fwd_sel_E2,
    output [2:0] fwd_sel_M,
    output stall
    );
	 wire [31:0] instr = instr_D;
	// forwarding to D level 
	`define E2D_PCAdd8	4	//E->D, PCAdd8        "PC_plus8_E"
	`define M2D_PCAdd8	3	//M->D, PCAdd8       "PC_plus8_M"
	`define M2D_ALU		2	//M->D, ALUOut         "ALUout_M"
	`define W2D_WD		1	//W->D, WriteData, the "result_W" 
	`define ORIGINAL	0	//No Forward
   /*assign fwd_sel_D1 = 3'b000;
	assign fwd_sel_D2 = 3'b000;
	assign fwd_sel_E1 = 3'b000;
	assign fwd_sel_E2 = 3'b000;*/
	//assign stall = 0;
    assign fwd_sel_D1 = ( (A3_E == rs_D) && (rd_D != 0) && (res_E == `PC) ) ? `E2D_PCAdd8 :
                        ( (A3_M == rs_D) && (rd_D != 0) && (res_M == `PC) ) ? `M2D_PCAdd8 :
                        ( (A3_M == rs_D) && (A3_M != 0) && (res_M == `ALU) )? `M2D_ALU    :
                        ( (A3_W == rs_D) && (A3_W != 0) && (res_W == `ALU || res_W == `DM || res_W == `PC ) ) ? `W2D_WD :
                        `ORIGINAL;
    assign fwd_sel_D2 = ( (A3_E == rt_D) && (rt_D != 0) && (res_E == `PC) ) ? `E2D_PCAdd8 :
                        ( (A3_M == rt_D) && (rt_D != 0) && (res_M == `PC) ) ? `M2D_PCAdd8 :
                        ( (A3_M == rt_D) && (rt_D != 0) && (res_M == `ALU) )? `M2D_ALU    :
                        ( (A3_W == rt_D) && (rt_D != 0) && (res_W == `ALU || res_W == `DM || res_W == `PC ) ) ? `W2D_WD :
                      `ORIGINAL;

    // forwarding to E level 
    `define M2E_PCAdd8  3   //M->E, PCAdd8
    `define M2E_ALU     2   //M->E, ALUOut
    `define W2E_WD      1   //W->E, WriteData
    //`define ORIGINAL    0   //No Forward
   assign fwd_sel_E1 = ( (A3_M == rs_E) && (rs_E != 0) && (res_M == `PC) )? `M2E_PCAdd8 :
                        ( (A3_M == rs_E) && (rs_E != 0) && (res_M == `ALU))? `M2E_ALU :
                        ( (A3_W == rs_E) && (rs_E != 0) && (res_W == `ALU || res_W == `DM || res_W == `PC ) ) ? `W2E_WD:
                        `ORIGINAL;
    assign fwd_sel_E2 = ( (A3_M == rt_E) && (rt_E != 0) && (res_M == `PC) )? `M2E_PCAdd8 :
                        ( (A3_M == rt_E) && (rt_E != 0) && (res_M == `ALU))? `M2E_ALU :
                        ( (A3_W == rt_E) && (rt_E != 0) && (res_W == `ALU || res_W == `DM || res_W == `PC ) ) ? `W2E_WD:
                        `ORIGINAL;


    // forwarding to M level 
    `define W2M_WD      1   //W->M, WriteData
    //define ORIGINAL    0   //No Forward
    assign fwd_sel_M =  ( (A3_W == rt_M) && (rt_M != 0) && (res_W == `ALU || res_W == `DM || res_W == `PC ) ) ? `W2M_WD:
                        `ORIGINAL;
/******** Now we step into stall condition  ********/

    wire Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1, Tuse_rt2;
    wire Stall_rs0_E1, Stall_rs0_E2, Stall_rs0_M1, Stall_rs1_E2, Stall_rs,
         Stall_rt0_E1, Stall_rt0_E2, Stall_rt0_M1, Stall_rt1_E2, Stall_rt;
//current instr's type , current is instr_D
    assign Tuse_rs0 = (`beq || `jr );   // have to read rs in D level
    assign Tuse_rt0 = (`beq );  //have to read rt in D level 
    // ori, lui, sw, lw in D level use imm, so can be calculated out immediately 
    assign Tuse_rs1 = (`addu || `subu || `ori || `lui || `lw || `sw );   // have to read rs in E level , use value to calculate 
    assign Tuse_rt1 = (`addu || `subu );    // have to read rt in E level 
    assign Tuse_rt2 = (`sw);   // have to read rt in M level , deleted `sw 

/*first situation 
addu $6, rs, rt
beq $6, rt, label 
///////////
addu $31, rs, rt
jr $31
*/
    assign Stall_rs0_E1 = ( Tuse_rs0 && (A3_E == rs_D) && (rs_D != 0) && (res_E == `ALU) );

/*second situation 
lw $6, 0($8)
beq $6, rt, label 
/////////
lw $31, 0($8)
jr $31
*/
    assign Stall_rs0_E2 = ( Tuse_rs0 && (A3_E == rs_D) && (rs_D != 0) && (res_E == `DM) );

    assign Stall_rs0_M1 = ( Tuse_rs0 && (A3_M == rs_D) && (rs_D != 0) && (res_M == `DM));
/*
ori $6, $5, 1205
beq $6, rt, label 
*/
    assign Stall_rs1_E2 = ( Tuse_rs1 &&(A3_E == rs_D) && (rs_D != 0) && (res_E == `DM  || res_E == `ALU));  
							//|| ( Tuse_rs1 && (A3_M == rs_D) && (rs_D != 0) && (res_M == `DM)) ) ;//I think it's forward?
	 
	/*modified*/

    assign Stall_rt0_E1 = ( Tuse_rt0 && (A3_E == rt_D) && (rt_D != 0) && (res_E == `ALU));
    assign Stall_rt0_E2 = ( Tuse_rt0 && (A3_E == rt_D) && (rt_D != 0) && (res_E == `DM));
    assign Stall_rt0_M1 = ( Tuse_rt0 && (A3_M == rt_D) && (rt_D != 0) && (res_M == `DM));
    assign Stall_rt1_E2 = ( Tuse_rt1 && (A3_E == rt_D) && (rt_D != 0) && (res_E == `DM ));//fix 



    assign Stall_rs = (Stall_rs0_E1 || Stall_rs0_E2 || Stall_rs1_E2 || Stall_rs0_M1);
    assign Stall_rt = (Stall_rt0_E1 || Stall_rt0_E2 || Stall_rt1_E2 || Stall_rt0_M1) ;


    assign stall = (Stall_rt || Stall_rs) ? 1 : 0;
   

endmodule
