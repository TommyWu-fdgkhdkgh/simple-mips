`timescale 1ns / 1ps

module Forward_Unit(
  ex_rs_i,
  ex_rt_i,
  mem_regwrite_i,
  mem_regdst_i,
  wb_regwrite_i,
  wb_regdst_i,
  forward_1_o,
  forward_2_o,
);

input [4:0] ex_rs_i, ex_rt_i;
input mem_regwrite_i;
input [4:0] mem_regdst_i;
input wb_regwrite_i;
input [4:0] wb_regdst_i;

output reg [1:0] forward_1_o, forward_2_o;

/*
 * forward_x_o == 0 : 不需要 forward
 * forward_x_o == 1 : 將 mem stage 的資訊 forward 給 ex stage
 * forward_x_o == 2 : 將 wb  stage 的資訊 forward 給 ex stage
 */
always @(*) begin
  if (mem_regwrite_i == 1'b1 && ex_rs_i == mem_regdst_i) begin
    forward_1_o <= 2'd1;
  end else if (wb_regwrite_i == 1'b1 && ex_rs_i == wb_regdst_i) begin
    forward_1_o <= 2'd2;
  end else begin
    forward_1_o <= 2'd0;
  end

  if (mem_regwrite_i == 1'b1 && ex_rt_i == mem_regdst_i) begin
    forward_2_o <= 2'd1;
  end else if (wb_regwrite_i == 1'b1 && ex_rt_i == wb_regdst_i) begin
    forward_2_o <= 2'd2;
  end else begin
    forward_2_o <= 2'd0;
  end
end

endmodule
