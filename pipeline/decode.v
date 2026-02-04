`timescale 1ns / 1ps

module Decode(
  clk_i,
  rst_i,

  inst_i,

  regfile_write_i,
  regfile_wr_addr_i,
  regfile_wr_data_i,
  regfile_1_o,
  regfile_2_o,

  sign_extend_o,

  decoder_signals_o,
);

input clk_i, rst_i;

input [31:0] inst_i;

input regfile_write_i;
input [4:0] regfile_wr_addr_i;
input [31:0] regfile_wr_data_i;
output [31:0] regfile_1_o, regfile_2_o;

output [31:0] sign_extend_o;

output [14:0] decoder_signals_o;

wire [4:0] rs, rt;

assign rs = inst_i[25:21];
assign rt = inst_i[20:16];

Reg_File regfile(clk_i, rst_i, rs, rt,
                 regfile_write_i, regfile_wr_addr_i,
                 regfile_wr_data_i,
                 regfile_1_o, regfile_2_o);

Sign_Extend imm_sign_extend(inst_i[15:0], sign_extend_o);

Decoder decoder(inst_i[5:0], inst_i[31:26],
                decoder_signals_o[14:14], // branch
                decoder_signals_o[13:12], // branch_type
                decoder_signals_o[11:11], // memtoreg
                decoder_signals_o[10:10], // memread 
                decoder_signals_o[9:9],   // memwrite
                decoder_signals_o[8:3],   // aluop
                decoder_signals_o[2:2],   // alusrc
                decoder_signals_o[1:1],   // regwrite
                decoder_signals_o[0:0]);  // regdst
endmodule
