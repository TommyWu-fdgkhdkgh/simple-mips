`timescale 1ns / 1ps

module Full_Adder(
  a,
  b,
  cin,
  sum,
  cout,
);
    input a, b, cin;
    output sum, cout;

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule

module Full_Adder_32(
  data_1_i,
  data_2_i,
  data_o
);
    input [31:0] data_1_i, data_2_i;
    output [31:0] data_o;

    wire [32:0] carry;
    assign carry[0] = 1'b0;

    genvar i;
    generate 
        for (i = 0; i < 32; i = i + 1) begin : gen_fa
            Full_Adder fa(data_1_i[i], data_2_i[i], carry[i], data_o[i], carry[i + 1]);
        end
    endgenerate

endmodule
