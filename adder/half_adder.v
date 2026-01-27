`timescale 1ns / 1ps

module Half_Adder(
  In_A,
  In_B,
  Sum,
  Carry_out
);

input In_A, In_B;
output Sum, Carry_out;

xor(Sum, In_A, In_B);
and(Carry_out, In_A, In_B);

endmodule
