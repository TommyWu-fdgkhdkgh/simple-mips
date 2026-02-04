`timescale 1ns / 1ps

module ALU_Ctrl(
  funct_i,
  ALUOp_i,
  ALUCtrl_o
);

input [5:0] funct_i;
input [5:0] ALUOp_i;
output [3:0] ALUCtrl_o;

assign ALUCtrl_o[3] = ((ALUOp_i == 6'b000000) && (funct_i == 6'b011000));  // mult
assign ALUCtrl_o[2] = ((ALUOp_i == 6'b000000) && (funct_i == 6'b100010)) | // sub
	              ((ALUOp_i == 6'b000000) && (funct_i == 6'b101010)) | // slt
		      (ALUOp_i == 6'b001010) | // slti
                      (ALUOp_i == 6'b000100) | // beq
                      (ALUOp_i == 6'b000101) | // bne
                      (ALUOp_i == 6'b000001) | // bge
                      (ALUOp_i == 6'b000111);  // bgt

// 00 : and
// 01 : or
// 10 : add, mult
// 11 : slt, slti
assign ALUCtrl_o[1] = ((ALUOp_i == 6'b000000) && (funct_i == 6'b100000)) | // add
	              ((ALUOp_i == 6'b000000) && (funct_i == 6'b100010)) | // sub
		      ((ALUOp_i == 6'b000000) && (funct_i == 6'b101010)) | // slt
		      ((ALUOp_i == 6'b000000) && (funct_i == 6'b011000)) | // mult
		      (ALUOp_i == 6'b001010) | // slti
		      (ALUOp_i == 6'b001000) | // addi
                      (ALUOp_i == 6'b000100) | // beq
                      (ALUOp_i == 6'b000101) | // bne
                      (ALUOp_i == 6'b000001) | // bge
                      (ALUOp_i == 6'b000111) | // bgt
                      (ALUOp_i == 6'b100011) | // lw;
                      (ALUOp_i == 6'b101011);  // sw;
assign ALUCtrl_o[0] = ((ALUOp_i == 6'b000000) && (funct_i == 6'b100101)) | // or
		      ((ALUOp_i == 6'b000000) && (funct_i == 6'b101010)) | // slt
		      (ALUOp_i == 6'b001010); // slti

endmodule
