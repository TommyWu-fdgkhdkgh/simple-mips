module full_adder_32_testbench;

reg [31:0] a, b;
wire [31:0] sum;

// correct answer
//
reg [31:0] ans_sum[0:8];
reg correct, clk;
reg [7:0] counter;


Full_Adder_32 fa32(
  .data_1_i(a),
  .data_2_i(b),
  .data_o(sum));

initial begin
  $dumpfile("waveform.vcd");           // Specify the name of the VCD file
  $dumpvars(0, full_adder_32_testbench);  // Dump all signals (level 0) within the specified module
end

initial #100 $finish;
initial begin
  // 1 : 寬度
  // b : binary
  // 0 : 值
  clk = 1'b0;

  counter =  8'd8;
  correct = 1;
  ans_sum[7] = 8'd10;
  ans_sum[6] = 8'd55;
  ans_sum[5] = 8'd100;
  ans_sum[4] = 8'd78;
  ans_sum[3] = 8'd64;
  ans_sum[2] = 8'd31;
  ans_sum[1] = 8'd17;
  ans_sum[0] = 8'd246;

  #10
  a = 8'd10; b = 8'd0;
  #10
  a = 8'd32; b = 8'd23;
  #10
  a = 8'd55; b = 8'd45;
  #10
  a = 8'd43; b = 8'd35;
  #10
  a = 8'd40; b = 8'd24;
  #10
  a = 8'd17; b = 8'd14;
  #10
  a = 8'd14; b = 8'd3;
  #10
  a = 8'd147; b = 8'd99;

end

always #5 clk = ~clk;

always @(posedge clk) begin
  if(counter <= 8 && (ans_sum[counter] != sum)) begin
    $display(" Pattern %d is wrong! ", counter);
    $display(" sum %d ans %d ", sum, ans_sum[counter]);
    correct = 0;
  end
  else if (counter == 0 && correct) begin
    $display("***************************************************");
    $display(" Congratulation! All data are correct! ");
    $display("***************************************************");
  end
  counter <= counter - 8'd1;
end

endmodule
