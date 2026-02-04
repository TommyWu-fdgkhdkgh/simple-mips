`timescale 1ns / 1ps

module Reg_File (
  clk_i,
  rst_i,
  rd_addr_1_in,
  rd_addr_2_in,
  reg_write_in,
  wr_addr_in,
  wr_data_in,
  rd_data_1_out,
  rd_data_2_out,
);

input clk_i, rst_i, reg_write_in;
input [4:0] rd_addr_1_in, rd_addr_2_in, wr_addr_in;
input [31:0] wr_data_in;
output [31:0] rd_data_1_out, rd_data_2_out;

reg signed [31:0] reg_file [0:31];

// *** 假如寫進來的 address 跟輸出的 address 相同，則直接把輸出打出去, 可以快
// 一個 cycle
assign rd_data_1_out = ((rd_addr_1_in == wr_addr_in) && reg_write_in) ? wr_data_in : reg_file[rd_addr_1_in];
assign rd_data_2_out = ((rd_addr_2_in == wr_addr_in) && reg_write_in) ? wr_data_in : reg_file[rd_addr_2_in];

// 不知道為什麼, 這堂課的作業需要將 R29 的 reset value 設定成 128 ... ?
// TODO : use for loop
always @(posedge clk_i) begin
  if (~rst_i) begin
    reg_file[0]  <= 0; reg_file[1]  <= 0; reg_file[2]  <= 0; reg_file[3]  <= 0;
    reg_file[4]  <= 0; reg_file[5]  <= 0; reg_file[6]  <= 0; reg_file[7]  <= 0;
    reg_file[8]  <= 0; reg_file[9]  <= 0; reg_file[10] <= 0; reg_file[11] <= 0;
    reg_file[12] <= 0; reg_file[13] <= 0; reg_file[14] <= 0; reg_file[15] <= 0;
    reg_file[16] <= 0; reg_file[17] <= 0; reg_file[18] <= 0; reg_file[19] <= 0;
    reg_file[20] <= 0; reg_file[21] <= 0; reg_file[22] <= 0; reg_file[23] <= 0;
    reg_file[24] <= 0; reg_file[25] <= 0; reg_file[26] <= 0; reg_file[27] <= 0;
    reg_file[28] <= 0; reg_file[29] <= 128; reg_file[30] <= 0; reg_file[31] <= 0;
  end else begin
    // reg_file[0] is hardwired to zero
    if (reg_write_in && wr_addr_in) begin
      reg_file[wr_addr_in] <= wr_data_in;
    end
  end	  
end

endmodule
