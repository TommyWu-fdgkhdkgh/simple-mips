`timescale 1ns / 1ps

module Decoder (
  funct_i,
  inst_op_i,
  Branch_o,
  Branch_Type_o,
  MemToReg_o,
  MemRead_o,
  MemWrite_o,
  ALUOp_o,
  ALUSrc_o,
  RegWrite_o,
  RegDst_o
);

input [5:0] funct_i, inst_op_i;
output Branch_o;
output [1:0] Branch_Type_o;
output MemToReg_o; 
output MemRead_o, MemWrite_o;
output [5:0] ALUOp_o;
output ALUSrc_o;
output RegWrite_o;
output RegDst_o;

assign Branch_o = (inst_op_i == 6'b000100) ||  // beq
                  (inst_op_i == 6'b000101) ||  // bne
                  (inst_op_i == 6'b000001) ||  // bge
                  (inst_op_i == 6'b000111);    // bgt
// 0 : not a branch
// 1 : is a branch

assign Branch_Type_o[1] = (inst_op_i == 6'b000001) || // bge
                          (inst_op_i == 6'b000101);   // bne
assign Branch_Type_o[0] = (inst_op_i == 6'b000111) || // bgt
                          (inst_op_i == 6'b000101);   // bne
// 可以參考 single cycle cpu 的 architecture diagram
// 0 : beq
// 1 : branch greater than ( bgt )
// 2 : branch greater than or equal to
// 3 : bne

assign MemToReg_o = (inst_op_i == 6'b100011);  // lw
// 00 : alu reseult to reg-file
// 01 : memory result to reg-file

assign MemRead_o = (inst_op_i == 6'b100011);    // lw
// 0 : don't want to read memory
// 1 : want to read memory

assign MemWrite_o = (inst_op_i == 6'b101011);   // sw
// 0 : don't want to write memory
// 1 : want to write memory

assign ALUOp_o = inst_op_i[5:0];
// 丟給 ALU_control 的訊號

assign ALUSrc_o = (inst_op_i == 6'b001000) || // addi
                  (inst_op_i == 6'b001010) || // slti
                  (inst_op_i == 6'b100011) || // lw
                  (inst_op_i == 6'b101011);   // sw
// ALUSrc --> 是要用 register 的值，還是在 instruction 裡的 imm ?
//        --> 0 代表要用 register 的值給 ALU
//        --> 1 代表要用 imm      的值給 ALU
// Branch 系列的指令，因為送進 ALU 做運算的還是兩個 register, 而不是 imm 的部
// 分, 所以不需要將 ALUSrc 設為 1

assign RegWrite_o = (inst_op_i == 6'b000000) || // add, sub, and, or, slt, mult
                    (inst_op_i == 6'b001000) || // addi
                    (inst_op_i == 6'b001010) || // slti
                    (inst_op_i == 6'b100011);   // lw
// RegWrite --> 是否要寫入 register
//        --> 0 代表不需要寫入
//        --> 1 代表要寫入

assign RegDst_o = (inst_op_i == 6'b000000);   // R-type instructions
//        --> 0 代表要用 rt 當作 write register 寫入的目標
//            --> 通常是用到 imm 的 instruction 會做這樣的事情
//                因為沒有空間給 rd 了
//                所以可以看到 ALUSrc_o 跟 RegDst_o 都是看 instr_op_i[3]
//        --> 1 代表要用 rd 當作 write register 寫入的目標
//            --> 通常是沒有用到 imm 的 instruction 會做這樣的事情
//        --> 2 代表是要寫入 r31 ( jal )

endmodule
