half_adder_testbench: half_adder.v half_adder_testbench.v
	../install_iverilog/bin/iverilog -o $@ $^
	./half_adder_testbench

full_adder_testbench: full_adder.v full_adder_testbench.v
	../install_iverilog/bin/iverilog -o $@ $^
	./full_adder_testbench

full_adder_32_testbench: full_adder.v full_adder_32_testbench.v
	../install_iverilog/bin/iverilog -o $@ $^
	./full_adder_32_testbench

clean:
	rm -f full_adder_32_testbench
	rm -f full_adder_testbench
	rm -f half_adder_testbench
	rm -f waveform.vcd
