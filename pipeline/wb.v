`timescale 1ns / 1ps

module Wb(
  clk_i, rst_i,
  
  alu_result_i,
  data_mem_i,
  d_memtoreg_i,
  mem_to_regfile_o
);

input clk_i, rst_i;
input [31:0] alu_result_i;
input [31:0] data_mem_i;
input d_memtoreg_i;
output [31:0] mem_to_regfile_o;

Mux_2to1 #(.size(32)) mem_to_regfile(alu_result_i,
                                     data_mem_i,
                                     d_memtoreg_i,
                                     mem_to_regfile_o);

endmodule
