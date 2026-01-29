`timescale 1ns / 1ps

module Mux_4to1 (
    data_1_i,
    data_2_i,
    data_3_i,
    data_4_i,
    select_i,
    data_o
);

parameter size = 0;

input [size - 1:0] data_1_i, data_2_i, data_3_i, data_4_i;
input [1:0] select_i;
output reg [size - 1:0] data_o;

always @(*) begin
    case (select_i)
        2'b00: data_o = data_1_i;
        2'b01: data_o = data_2_i;
	2'b10: data_o = data_3_i;
	2'b11: data_o = data_4_i;
	default: data_o = 0;
    endcase  
end

endmodule
