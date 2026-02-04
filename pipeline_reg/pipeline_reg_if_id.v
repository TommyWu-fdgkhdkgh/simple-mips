`timescale 1ns / 1ps

module Pipeline_Reg_IF_ID (
  clk_i,
  rst_i,
  keep_i,
  clear_i,
  inst_i,
  pc_adder_i,
  inst_o,
  pc_adder_o
);

input clk_i, rst_i, keep_i, clear_i;
input [31:0] inst_i, pc_adder_i;
output [31:0] inst_o, pc_adder_o;

Pipeline_Reg #(.size(32)) inst(clk_i, rst_i,
                               keep_i,
                               clear_i,
                               inst_i,
                               inst_o);

Pipeline_Reg #(.size(32)) pc_adder(clk_i, rst_i,
                                   keep_i,
                                   clear_i,
                                   pc_adder_i,
                                   pc_adder_o);

endmodule
