`timescale 1ns / 1ps

module ALU (
  src_1_i,
  src_2_i,
  ctrl_i,
  result_o,
  zero_o
);

input [31:0] src_1_i, src_2_i;
input [3:0] ctrl_i;
output reg [31:0] result_o;
output zero_o;

always @(src_1_i, src_2_i, ctrl_i) begin
  case (ctrl_i)
    0: result_o <= src_1_i & src_2_i;
    1: result_o <= src_1_i | src_2_i;
    2: result_o <= src_1_i + src_2_i;
    6: result_o <= src_1_i - src_2_i;
    7: result_o <= src_1_i < src_2_i ? 1 : 0;
    10: result_o <= src_1_i * src_2_i;
    12: result_o <= ~(src_1_i | src_2_i);
    default: result_o <= 0;
  endcase
end

assign zero_o = ~|result_o;

endmodule
