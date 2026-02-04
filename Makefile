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

cpu: adder/full_adder.v mux/mux_2to1.v mux/mux_4to1.v \
	./pipeline_reg/pipeline_reg.v ./pipeline_reg/pipeline_reg_if_id.v \
	./pipeline_reg/pipeline_reg_id_ex.v ./pipeline_reg/pipeline_reg_ex_mem.v \
	./pipeline_reg/pipeline_reg_mem_wb.v \
	./misc/alu_ctrl.v ./misc/alu.v ./misc/data_memory.v \
	./misc/decoder.v ./misc/inst_mem.v ./misc/program_counter.v \
	./misc/reg_file.v ./misc/shift_left_two_32.v ./misc/sign_extend.v \
	./pipeline/fetch.v ./pipeline/decode.v ./pipeline/execute.v \
	./pipeline/mem.v ./pipeline/wb.v ./pipeline/forward_unit.v \
	./cpu.v ./testbench.v
	./install_iverilog/bin/iverilog -o $@ $^

.PHONY: run/cpu/testcase1
run/cpu/testcase1: cpu ./testcases/testcase1.txt
	cp ./testcases/testcase1.txt ./testcase.txt
	./cpu

.PHONY: run/cpu/testcase2
run/cpu/testcase2: cpu ./testcases/testcase2.txt
	cp ./testcases/testcase2.txt ./testcase.txt
	./cpu

.PHONY: run/cpu/testcase3
run/cpu/testcase3: cpu ./testcases/testcase3.txt
	cp ./testcases/testcase3.txt ./testcase.txt
	./cpu

.PHONY: run/cpu/testcase4
run/cpu/testcase4: cpu ./testcases/testcase4.txt
	cp ./testcases/testcase4.txt ./testcase.txt
	./cpu

.PHONY: run/cpu/testcase5
run/cpu/testcase5: cpu ./testcases/testcase5.txt
	cp ./testcases/testcase5.txt ./testcase.txt
	./cpu

.PHONY: clean
clean:
	cd adder && make clean
	cd mux && make clean
	rm -f cpu
	rm -f waveform.vcd
	rm -f testcase.txt
