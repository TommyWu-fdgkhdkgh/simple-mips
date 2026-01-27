half_adder_testbench: half_adder.v half_adder_testbench.v
	../install_iverilog/bin/iverilog -o $@ $^
	./half_adder_testbench

clean:
	rm -f half_adder_testbench
	rm -f waveform.vcd
