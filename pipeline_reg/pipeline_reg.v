`timescale 1ns / 1ps

module Pipeline_Reg (
  clk_i,
  rst_i,
  keep_i,
  clear_i,
  data_i,
  data_o
);

parameter size = 0;

input clk_i, rst_i, keep_i, clear_i;
input [size - 1:0] data_i;
output reg [size - 1:0] data_o;

always @(posedge clk_i) begin
  if (~rst_i) begin
    data_o <= 0;
  end else begin
    if (keep_i)
      data_o <= data_o;
    else if (clear_i)
      data_o <= 0;
    else 
      data_o <= data_i;
  end
end

endmodule
