`timescale 1ns / 1ps

module Fetch(
  clk_i,
  rst_i,

  /*
   * XXX 
   */
  mux_pc_i,
  mux_pc_sel_i,
  stall_i,
  inst_o,
  pc_adder_o,
);

input clk_i, rst_i;
input [31:0] mux_pc_i;
input mux_pc_sel_i;
input stall_i;
output [31:0] inst_o;
output [31:0] pc_adder_o;

wire [31:0] mux_pc;
wire [31:0] pc;
wire [31:0] pc_adder;

// 在這邊會決定，下一 cycle 的 pc 值是單純的
// `這個 cycle + 4` 抑或是 `跳到 mux_pc_i`
Mux_2to1 #(.size(32)) mux_two_pc(pc_adder, mux_pc_i,
                                 mux_pc_sel_i, mux_pc);

// pc_o 是這個 cycle 的 pc 值
// mux_pc 是 `下一 cycle` 的 pc 值
Program_Counter program_counter(clk_i, rst_i, stall_i, mux_pc, pc);

// 把這個 cycle 的 pc 值 + 4
Full_Adder_32 pc_adder_32(pc, 32'd4, pc_adder);

// 依照這個 cycle 的 pc 值，向 instruction memory 拿取 instruction
Inst_Mem inst_mem(pc, inst_o);

assign pc_adder_o = pc_adder;

endmodule
