`timescale 1ns / 1ps

// Author: 韋詠祥
////////

`define CYCLE_TIME 10

module testbench;
reg clk, rst;

CPU cpu(clk, rst);

always #(`CYCLE_TIME/2)
	clk = ~clk;

initial begin
	clk = 0;
	rst = 0;
	$dumpfile("debug.vcd");
	$dumpvars;

	#(`CYCLE_TIME) rst = 1;
	#(`CYCLE_TIME * 31)

	$display("PC = %d", cpu.fetch.program_counter.pc_out_o);

	$display("# Registers");
	$display("R0  =%d, R1  =%d, R2  =%d, R3  =%d, R4  =%d, R5  =%d, R6  =%d, R7  =%d", cpu.decode.regfile.reg_file[ 0], cpu.decode.regfile.reg_file[ 1], cpu.decode.regfile.reg_file[ 2], cpu.decode.regfile.reg_file[ 3], cpu.decode.regfile.reg_file[ 4], cpu.decode.regfile.reg_file[ 5], cpu.decode.regfile.reg_file[ 6], cpu.decode.regfile.reg_file[ 7]);
	$display("R8  =%d, R9  =%d, R10 =%d, R11 =%d, R12 =%d, R13 =%d, R14 =%d, R15 =%d", cpu.decode.regfile.reg_file[ 8], cpu.decode.regfile.reg_file[ 9], cpu.decode.regfile.reg_file[10], cpu.decode.regfile.reg_file[11], cpu.decode.regfile.reg_file[12], cpu.decode.regfile.reg_file[13], cpu.decode.regfile.reg_file[14], cpu.decode.regfile.reg_file[15]);
	$display("R16 =%d, R17 =%d, R18 =%d, R19 =%d, R20 =%d, R21 =%d, R22 =%d, R23 =%d", cpu.decode.regfile.reg_file[16], cpu.decode.regfile.reg_file[17], cpu.decode.regfile.reg_file[18], cpu.decode.regfile.reg_file[19], cpu.decode.regfile.reg_file[20], cpu.decode.regfile.reg_file[21], cpu.decode.regfile.reg_file[22], cpu.decode.regfile.reg_file[23]);
	$display("R24 =%d, R25 =%d, R26 =%d, R27 =%d, R28 =%d, R29 =%d, R30 =%d, R31 =%d", cpu.decode.regfile.reg_file[24], cpu.decode.regfile.reg_file[25], cpu.decode.regfile.reg_file[26], cpu.decode.regfile.reg_file[27], cpu.decode.regfile.reg_file[28], cpu.decode.regfile.reg_file[29], cpu.decode.regfile.reg_file[30], cpu.decode.regfile.reg_file[31]);

	$display("# Data Memory");
	$display("%d, %d, %d, %d, %d, %d, %d, %d", cpu.mem.data_mem.memory[ 0], cpu.mem.data_mem.memory[ 1], cpu.mem.data_mem.memory[ 2], cpu.mem.data_mem.memory[ 3], cpu.mem.data_mem.memory[ 4], cpu.mem.data_mem.memory[ 5], cpu.mem.data_mem.memory[ 6], cpu.mem.data_mem.memory[ 7]);
	$display("%d, %d, %d, %d, %d, %d, %d, %d", cpu.mem.data_mem.memory[ 8], cpu.mem.data_mem.memory[ 9], cpu.mem.data_mem.memory[10], cpu.mem.data_mem.memory[11], cpu.mem.data_mem.memory[12], cpu.mem.data_mem.memory[13], cpu.mem.data_mem.memory[14], cpu.mem.data_mem.memory[15]);
	$display("%d, %d, %d, %d, %d, %d, %d, %d", cpu.mem.data_mem.memory[16], cpu.mem.data_mem.memory[17], cpu.mem.data_mem.memory[18], cpu.mem.data_mem.memory[19], cpu.mem.data_mem.memory[20], cpu.mem.data_mem.memory[21], cpu.mem.data_mem.memory[22], cpu.mem.data_mem.memory[23]);
	$display("%d, %d, %d, %d, %d, %d, %d, %d", cpu.mem.data_mem.memory[24], cpu.mem.data_mem.memory[25], cpu.mem.data_mem.memory[26], cpu.mem.data_mem.memory[27], cpu.mem.data_mem.memory[28], cpu.mem.data_mem.memory[29], cpu.mem.data_mem.memory[30], cpu.mem.data_mem.memory[31]);
	$finish;
end

endmodule
