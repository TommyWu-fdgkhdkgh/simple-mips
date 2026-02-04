`timescale 1ns / 1ps

module Pipeline_Reg_ID_EX (
  clk_i,
  rst_i,
  keep_i,
  clear_i,

  rs_o,
  rt_o,

  inst_i,
  inst_15_11_o,

  pc_adder_i,
  pc_adder_o,

  regfile_1_i,
  regfile_1_o,

  regfile_2_i,
  regfile_2_o,

  sign_extend_i,
  sign_extend_o,

  decoder_signals_i,
  decoder_signals_o,
);

input clk_i, rst_i, keep_i, clear_i;

output [4:0] rs_o;
output [4:0] rt_o;

input [31:0] inst_i;
output [4:0] inst_15_11_o;

input [31:0] pc_adder_i;
output [31:0] pc_adder_o;

input [31:0] regfile_1_i;
output [31:0] regfile_1_o;

input [31:0] regfile_2_i;
output [31:0] regfile_2_o;

input [31:0] sign_extend_i;
output [31:0] sign_extend_o;

input [14:0] decoder_signals_i;
output [14:0] decoder_signals_o;

Pipeline_Reg #(.size(5)) rs(clk_i, rst_i,
                            keep_i,
                            clear_i,
                            inst_i[25:21],
                            rs_o);

Pipeline_Reg #(.size(5)) rt(clk_i, rst_i,
                            keep_i,
                            clear_i,
                            inst_i[20:16],
                            rt_o);

Pipeline_Reg #(.size(5)) inst_15_11(clk_i, rst_i,
                                    keep_i,
                                    clear_i,
                                    inst_i[15:11],
                                    inst_15_11_o);

Pipeline_Reg #(.size(32)) pc_adder(clk_i, rst_i,
                                   keep_i,
                                   clear_i,
                                   pc_adder_i,
                                   pc_adder_o);

Pipeline_Reg #(.size(32)) regfile_1(clk_i, rst_i,
                                    keep_i,
                                    clear_i,
                                    regfile_1_i,
                                    regfile_1_o);

Pipeline_Reg #(.size(32)) regfile_2(clk_i, rst_i,
                                    keep_i,
                                    clear_i,
                                    regfile_2_i,
                                    regfile_2_o);

Pipeline_Reg #(.size(32)) sign_extend(clk_i, rst_i,
                                      keep_i,
                                      clear_i,
                                      sign_extend_i,
                                      sign_extend_o);

Pipeline_Reg #(.size(15)) decoder_signals(clk_i, rst_i,
                                          keep_i,
                                          clear_i,
					  decoder_signals_i,
                                          decoder_signals_o);
endmodule
