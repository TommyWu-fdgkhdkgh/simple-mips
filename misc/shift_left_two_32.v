`timescale 1ns / 1ps

module Shift_Left_Two_32 (
  data_in,
  data_out
);

input [31:0] data_in;
output [31:0] data_out;

assign data_out = {data_in[29:0], 2'b0};

endmodule
