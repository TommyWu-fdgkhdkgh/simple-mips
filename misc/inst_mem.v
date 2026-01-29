`timescale 1ns / 1ps

module Inst_Mem (
  pc_addr_i,
  inst_o
);

input [31:0] pc_addr_i;
output [31:0] inst_o;

reg [31:0] memory [0:31];

// pc_addr_i[31:2] == (pc_addr_i / 4)
assign inst_o = memory[pc_addr_i[31:2]];

integer i;
initial begin
  for (i = 0; i < 32; i = i + 1) begin
    memory[i] = 32'b0;
  end
  $readmemb("testcase.txt", memory);
end

endmodule;
