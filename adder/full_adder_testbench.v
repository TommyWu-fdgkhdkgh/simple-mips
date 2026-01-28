module full_adder_testbench;

reg a, b, cin;
wire sum, c_out;

// correct answer
reg [7:0] ans_sum;
reg [7:0] ans_carry;
reg correct, clk;
reg [7:0] counter;

Full_Adder fa(
  .a(a),
  .b(b),
  .cin(cin),
  .sum(sum),
  .cout(c_out));

initial begin
  $dumpfile("waveform.vcd");           // Specify the name of the VCD file
  $dumpvars(0, full_adder_testbench);  // Dump all signals (level 0) within the specified module
end

initial #100 $finish;
initial begin
  // 1 : 寬度
  // b : binary
  // 0 : 值
  clk = 1'b0;

  counter =  8'd8;
  correct = 1;
  ans_sum     = 8'b01101001;
  ans_carry   = 8'b00010111;

  #10
  a = 0; b = 0; cin = 0;
  #10
  a = 0; b = 1; cin = 0;
  #10
  a = 1; b = 0; cin = 0;
  #10
  a = 1; b = 1; cin = 0;
  #10
  a = 0; b = 0; cin = 1;
  #10
  a = 0; b = 1; cin = 1;
  #10
  a = 1; b = 0; cin = 1;
  #10
  a = 1; b = 1; cin = 1;

end

always #5 clk = ~clk;

always @(posedge clk) begin
  if(counter <= 8 && (ans_sum[counter] != sum || ans_carry[counter] != c_out)) begin
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
