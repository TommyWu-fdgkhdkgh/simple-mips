mux_2to1_testbench: mux_2to1.v mux_2to1_testbench.v
	../install_iverilog/bin/iverilog -o $@ $^
	./mux_2to1_testbench

mux_4to1_testbench: mux_4to1.v mux_4to1_testbench.v
	../install_iverilog/bin/iverilog -o $@ $^
	./mux_4to1_testbench

clean:
	rm -f waveform.vcd
	rm -f mux_2to1_testbench
	rm -f mux_4to1_testbench
