`timescale 1ns / 1ps

// TODO : delete clk_i, rst_i
module Execute(
  clk_i,
  rst_i,

  sign_extend_i,

  regfile_1_i,
  regfile_2_i,
  forward_alu_result_i,
  forward_mem_to_regfile_i,
  forward_1_i,
  forward_2_i,

  d_alusrc_i,

  rt_i,
  inst_15_11_i,
  d_regdst_i,
  regdst_o,

  pc_adder_i,
  branch_adder_o,

  d_aluop_i,

  alu_result_o,
  alu_zero_o,
);

input clk_i, rst_i;
input [31:0] sign_extend_i;
input [31:0] regfile_1_i, regfile_2_i;

// forward from 上一個 cycle 的 EX stage
input [31:0] forward_alu_result_i;
// forward from 這一個 cycle 的 WB stage
input [31:0] forward_mem_to_regfile_i;

input [1:0] forward_1_i;
input [1:0] forward_2_i;

input d_alusrc_i;

input [4:0] rt_i;
input [4:0] inst_15_11_i;
input d_regdst_i;
output [4:0] regdst_o;

input [31:0] pc_adder_i;
output [31:0] branch_adder_o;

input [5:0] d_aluop_i;

output [31:0] alu_result_o;
output alu_zero_o;

wire [31:0] shift_left_o;
wire [31:0] forward_regfile_1_o;
wire [31:0] forward_regfile_2_o;
wire [31:0] mux_alusrc_o;
wire [3:0] alu_ctrl_o;

Shift_Left_Two_32 shift_left(sign_extend_i,
                             shift_left_o);

Mux_4to1 #(.size(32)) forward_regfile_1(regfile_1_i,
                                        forward_alu_result_i,
                                        forward_mem_to_regfile_i,
                                        32'd0,
                                        forward_1_i, forward_regfile_1_o);

Mux_4to1 #(.size(32)) forward_regfile_2(regfile_2_i,
                                        forward_alu_result_i,
                                        forward_mem_to_regfile_i,
                                        32'd0,
                                        forward_2_i, forward_regfile_2_o);

Mux_2to1 #(.size(32)) mux_alusrc(forward_regfile_2_o, sign_extend_i,
                                 d_alusrc_i, mux_alusrc_o);

Mux_2to1 #(.size(5)) mux_regdst(rt_i,
                                inst_15_11_i,
                                d_regdst_i,
                                regdst_o);

Full_Adder_32 ex_branch_adder(pc_adder_i, shift_left_o,
                              branch_adder_o);

ALU_Ctrl alu_ctrl(sign_extend_i[5:0], d_aluop_i,
                  alu_ctrl_o);

ALU ex_alu(forward_regfile_1_o, mux_alusrc_o, alu_ctrl_o,
           alu_result_o, alu_zero_o);


endmodule
