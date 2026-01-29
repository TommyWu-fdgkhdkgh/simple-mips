`timescale 1ns / 1ps

module Mux_2to1 (
    data_1_i,
    data_2_i,
    select_i,
    data_o
);

parameter size = 0;

input [size - 1:0] data_1_i, data_2_i;
input select_i;
output reg [size - 1:0] data_o;

always @(*) begin
    if (~select_i) begin
        data_o = data_1_i;
    end else begin
        data_o = data_2_i;
    end  
end

endmodule
