`timescale 1ns / 1ps

module Program_Counter (
  clk_i,
  rst_i,
  keep_i,
  pc_in_i,
  pc_out_o
);

input clk_i, rst_i, keep_i;
input [31:0] pc_in_i;
output reg [31:0] pc_out_o;

always @(posedge clk_i) begin
  if (~rst_i) begin
    pc_out_o <= 0;
  end else begin
    if (keep_i)
      pc_out_o <= pc_out_o;
    else
      pc_out_o <= pc_in_i;
  end
end

endmodule
