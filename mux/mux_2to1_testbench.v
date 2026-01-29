module mux_2to1_testbench;

reg [14:0] a, b;
reg sel;
wire [14:0]out;

// correct answer
reg [14:0] ans [0:3];
reg correct, clk;
reg [3:0] counter;

Mux_2to1 #(.size(15)) mux_2to1(a, b, sel, out);

initial begin
  $dumpfile("waveform.vcd");           // Specify the name of the VCD file
  $dumpvars(0, mux_2to1_testbench);  // Dump all signals (level 0) within the specified module
end

initial #100 $finish;
initial begin
  // 1 : 寬度
  // b : binary
  // 0 : 值
  clk = 1'b0;

  counter =  4'd4;
  correct = 1;
  ans[3] = 14'd53;
  ans[2] = 14'd37;
  ans[1] = 14'd17;
  ans[0] = 14'd144;

  #10 a = 39; b = 53; sel = 1'b1;
  #10 a = 37; b = 17; sel = 1'b0;
  #10 a = 19; b = 17; sel = 1'b1;
  #10 a = 144; b = 120; sel = 1'b0;
end

always #5 clk = ~clk;

always @(posedge clk) begin
  if(counter <= 4 && (ans[counter] != out)) begin
    $display(" Pattern %d is wrong! ", counter);
    $display(" out %d ans %d ", out, ans[counter]);
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
