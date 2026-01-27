module half_adder_testbench;

reg a, b;
wire sum, c_out;

// correct answer
reg [3:0] ans_sum;
reg [3:0] ans_carry;
reg correct, clk;
reg [3:0] counter;

Half_Adder ha(a, b, sum, c_out);

initial begin
  $dumpfile("waveform.vcd");           // Specify the name of the VCD file
  $dumpvars(0, half_adder_testbench);  // Dump all signals (level 0) within the specified module
end

initial #100 $finish;
initial begin
  // 1 : 寬度
  // b : binary
  // 0 : 值
  clk = 1'b0;

  counter =  4'd4;
  correct = 1;
  ans_sum     = 4'b0110;
  ans_carry   = 4'b0001;

  #10 a = 0; b = 0;
  #10 a = 0; b = 1;
  #10 a = 1; b = 0;
  #10 a = 1; b = 1;
end

always #5 clk = ~clk;

always @(posedge clk) begin
  if(counter <= 4 && (ans_sum[counter] != sum || ans_carry[counter] != c_out)) begin
    $display(" Pattern %d is wrong! ", counter);
    $display(" sum %d ans %d ", sum, ans_sum[counter]);
    $display(" car %d ans %d ", c_out, ans_carry[counter]);
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
