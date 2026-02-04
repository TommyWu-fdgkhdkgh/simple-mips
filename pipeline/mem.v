`timescale 1ns / 1ps

module Mem(
  clk_i,
  rst_i,

  alu_zero_i,
  alu_result_i,
  d_branch_type_i,

  d_branch_i,
  branch_and_o,

  regfile_2_i,
  d_memread_i,
  d_memwrite_i,
  data_mem_o,
);

input clk_i, rst_i;
input alu_zero_i;
input [31:0] alu_result_i;
input [1:0] d_branch_type_i;

input d_branch_i;
output branch_and_o;

input [31:0] regfile_2_i;
input d_memread_i, d_memwrite_i;
output [31:0] data_mem_o;

wire mux_branch_type_o;

// 0 : beq
//     兩值相減等於 0, 代表相同
// 1 : branch greater than ( bgt )
//     兩值相減後為正整數 ( 不可為 0 )
// 2 : branch greater than or equal ( bge )
//     兩值相減後不為負數 ( 可為 0 )
// 3 : bne
//     兩值相減不等於 0
Mux_4to1 #(.size(1)) mux_branch_type(alu_zero_i,
                                     (~alu_result_i[31] & ~alu_zero_i),
                                     ~alu_result_i[31],
                                     ~alu_zero_i,
                                     d_branch_type_i,
                                     mux_branch_type_o);

and branch_and(branch_and_o, d_branch_i, mux_branch_type_o);

Data_Memory data_mem(clk_i, alu_result_i, regfile_2_i,
                     d_memread_i, d_memwrite_i,
                     data_mem_o);
endmodule
