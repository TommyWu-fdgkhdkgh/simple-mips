`timescale 1ns / 1ps

module Pipeline_Reg_MEM_WB (
  clk_i,
  rst_i,
  keep_i,
  clear_i,

  d_memtoreg_i,
  d_memtoreg_o,
  d_regwrite_i,
  d_regwrite_o,
  regdst_i,
  regdst_o,
  data_mem_i,
  data_mem_o,
  alu_result_i,
  alu_result_o,
);

input clk_i, rst_i, keep_i, clear_i;

input d_memtoreg_i;
output d_memtoreg_o;
input d_regwrite_i;
output d_regwrite_o;
input [4:0] regdst_i;
output [4:0] regdst_o;
input [31:0] data_mem_i;
output [31:0] data_mem_o;
input [31:0] alu_result_i;
output [31:0] alu_result_o;

Pipeline_Reg #(.size(1)) d_memtoreg(clk_i, rst_i,
                                    keep_i, clear_i,
                                    d_memtoreg_i,
                                    d_memtoreg_o);

Pipeline_Reg #(.size(1)) d_regwrite(clk_i, rst_i,
                                    keep_i, clear_i, 
                                    d_regwrite_i,
                                    d_regwrite_o);

Pipeline_Reg #(.size(5)) regdst(clk_i, rst_i,
                                keep_i, clear_i,
                                regdst_i,
                                regdst_o);

Pipeline_Reg #(.size(32)) data_mem(clk_i, rst_i,
                                   keep_i, clear_i,
                                   data_mem_i,
                                   data_mem_o);

Pipeline_Reg #(.size(32)) alu_result(clk_i, rst_i,
                                     keep_i, clear_i,
                                     alu_result_i,
                                     alu_result_o);

endmodule
