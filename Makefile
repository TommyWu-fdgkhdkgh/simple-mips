.PHONY: install/iverilog-prerequisites
install/iverilog-prerequisites:
	sudo apt install -y autoconf gperf make gcc g++ bison flex

.PHONY: install/iverilog
install/iverilog:
	mkdir install_iverilog
	git clone https://github.com/steveicarus/iverilog.git
	cd iverilog && git checkout s20251012
	cd iverilog && ./configure --prefix=$(realpath ./)/install_iverilog
	cd iverilog && make -j10
	cd iverilog && make install

.PHONY: run/half_adder_testbench
run/half_adder_testbench:
	cd adder && make half_adder_testbench

.PHONY: run/full_adder_testbench
run/full_adder_testbench:
	cd adder && make full_adder_testbench

.PHONY: run/full_adder_32_testbench
run/full_adder_32_testbench:
	cd adder && make full_adder_32_testbench

.PHONY: run/mux_2to1_testbench
run/mux_2to1_testbench:
	cd mux && make mux_2to1_testbench

.PHONY: run/mux_4to1_testbench
run/mux_4to1_testbench:
	cd mux && make mux_4to1_testbench

.PHONY: clean
clean:
	cd adder && make clean
	cd mux && make clean
