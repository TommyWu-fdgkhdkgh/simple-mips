`timescale 1ns / 1ps

module Pipeline_Reg_EX_MEM (
  clk_i,
  rst_i,
  keep_i,
  clear_i,

  regfile_2_i,
  regfile_2_o,

  decoder_signals_i,
  decoder_signals_o,

  regdst_i,
  regdst_o,

  branch_adder_i,
  branch_adder_o,

  alu_result_i,
  alu_result_o,

  alu_zero_i,
  alu_zero_o
);

input clk_i, rst_i, keep_i, clear_i;

input [31:0] regfile_2_i;
output [31:0] regfile_2_o;

input [6:0] decoder_signals_i;
output [6:0] decoder_signals_o;

input [4:0] regdst_i;
output [4:0] regdst_o;

input [31:0] branch_adder_i;
output[31:0] branch_adder_o;

input [31:0] alu_result_i;
output [31:0] alu_result_o;

input alu_zero_i;
output alu_zero_o;


wire [6:0] d_control_signals_o;

Pipeline_Reg #(.size(32)) regfile_2(clk_i, rst_i,
                                    keep_i, clear_i,
                                    regfile_2_i,
                                    regfile_2_o);

// control signals from decoder
Pipeline_Reg #(.size(7)) decoder_signals(clk_i, rst_i,
                                         keep_i, clear_i,
                                         decoder_signals_i,
                                         decoder_signals_o);

Pipeline_Reg #(.size(5)) regdst(clk_i, rst_i,
                                keep_i, clear_i,
                                regdst_i,
                                regdst_o);

Pipeline_Reg #(.size(32)) branch_adder(clk_i, rst_i,
                                       keep_i, clear_i,
                                       branch_adder_i,
                                       branch_adder_o);

Pipeline_Reg #(.size(32)) alu_result(clk_i, rst_i,
                                     keep_i, clear_i,
                                     alu_result_i,
                                     alu_result_o);

Pipeline_Reg #(.size(1)) alu_zero(clk_i, rst_i,
                                  keep_i, clear_i,
                                  alu_zero_i,
                                  alu_zero_o);
endmodule
