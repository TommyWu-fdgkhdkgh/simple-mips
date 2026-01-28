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

.PHONY: clean
clean:
	cd adder && make clean
