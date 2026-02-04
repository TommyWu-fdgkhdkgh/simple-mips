`timescale 1ns / 1ps

module CPU (
  clk_i,
  rst_i
);

input clk_i, rst_i;

/////////// decleration ///////////
// IF
wire [31:0] if_inst, if_pc_adder;
///////////
// IF/ID
wire [31:0] if_id_inst, if_id_pc_adder;
///////////
// ID
wire [31:0] id_regfile_1, id_regfile_2, id_sign_extend;
wire [14:0] id_decoder_signals;
///////////
// ID/EX
wire [4:0] id_ex_rs, id_ex_rt;
wire [4:0] id_ex_inst_15_11;
wire [31:0] id_ex_pc_adder;
wire [31:0] id_ex_regfile_1, id_ex_regfile_2;
wire [31:0] id_ex_sign_extend;
wire [14:0] id_ex_decoder_signals;
///////////
// EX
wire [31:0] ex_forward_regfile_2;
wire [4:0] ex_regdst;
wire [31:0] ex_branch_adder, ex_alu_result;
wire ex_alu_zero;
///////////
// EX/MEM
wire [31:0] ex_mem_regfile_2;
wire [6:0] ex_mem_decoder_signals;
wire [4:0] ex_mem_regdst;
wire [31:0] ex_mem_branch_adder;
wire [31:0] ex_mem_alu_result;
wire ex_mem_alu_zero;
///////////
// MEM
wire mem_branch_and;
wire [31:0] mem_data_mem;
///////////
// MEM/WB
wire mem_wb_d_memtoreg, mem_wb_d_regwrite;
wire [4:0] mem_wb_regdst;
wire [31:0] mem_wb_data_mem, mem_wb_alu_result; 
///////////
// WB
wire [31:0] wb_to_regfile;
///////////
// Forwarding Unit
wire [1:0] fu_forward_1;
wire [1:0] fu_forward_2;
///////////
// data Hazard ( load and then use data hazard )
reg hz_stall_if_id;
///////////
// control Hazard ( flush pipeline for branch )
reg hz_flush_if_id;
reg hz_flush_id_ex;
reg hz_flush_ex_mem;
///////////////////////////////////

///////// implementation /////////
// IF
Fetch fetch (
  .clk_i(clk_i), .rst_i(rst_i),
  .mux_pc_i(ex_mem_branch_adder),
  .mux_pc_sel_i(mem_branch_and),
  .stall_i(hz_stall_if_id),
  .inst_o(if_inst),
  .pc_adder_o(if_pc_adder)
);
///////////
// IF/ID
Pipeline_Reg_IF_ID pipeline_reg_if_id (
  .clk_i(clk_i), .rst_i(rst_i),
  .keep_i(hz_stall_if_id),
  .clear_i(hz_flush_if_id),
  .inst_i(if_inst),
  .pc_adder_i(if_pc_adder),
  .inst_o(if_id_inst),
  .pc_adder_o(if_id_pc_adder)
);
///////////
// ID
Decode decode (
  .clk_i(clk_i), .rst_i(rst_i),
  .inst_i(if_id_inst),
  .regfile_write_i(mem_wb_d_regwrite),
  .regfile_wr_addr_i(mem_wb_regdst),
  .regfile_wr_data_i(wb_to_regfile),
  .regfile_1_o(id_regfile_1),
  .regfile_2_o(id_regfile_2),
  .sign_extend_o(id_sign_extend),
  .decoder_signals_o(id_decoder_signals)
);
///////////
// ID/EX
// stall_if_id : 當我們 stall if id 的時候
//   需要往 EX stage 送一個 bubble.
//   這是因為 if 跟 id stage 會停一個 cycle,
//   導致沒有任何資料可以遞給 ex stage
Pipeline_Reg_ID_EX pipeline_reg_id_ex (
  .clk_i(clk_i), .rst_i(rst_i),
  .keep_i(1'b0),
  .clear_i(stall_if_id || flush_id_ex),
  .rs_o(id_ex_rs),
  .rt_o(id_ex_rt),

  .inst_i(if_id_inst),
  .inst_15_11_o(id_ex_inst_15_11),

  .pc_adder_i(if_id_pc_adder),
  .pc_adder_o(id_ex_pc_adder),

  .regfile_1_i(id_regfile_1),
  .regfile_1_o(id_ex_regfile_1),

  .regfile_2_i(id_regfile_2),
  .regfile_2_o(id_ex_regfile_2),

  .sign_extend_i(id_sign_extend),
  .sign_extend_o(id_ex_sign_extend),

  .decoder_signals_i(id_decoder_signals),
  .decoder_signals_o(id_ex_decoder_signals)
);

/*
 * id_ex_decoder_signals
 * branch      = decoder_signals[14:14];
 * branch_type = decoder_signals[13:12];
 * memtoreg    = decoder_signals[11:11];
 * memread     = decoder_signals[10:10];
 * memwrite    = decoder_signals[9:9];
 * aluop       = decoder_signals[8:3];
 * alusrc      = decoder_signals[2:2];
 * regwrite    = decoder_signals[1:1];
 * regdst      = decoder_signals[0:0];
 */ 

///////////
// EX
Execute execute (
  .clk_i(clk_i), .rst_i(rst_i),

  .sign_extend_i(id_ex_sign_extend),

  .regfile_1_i(id_ex_regfile_1),
  .regfile_2_i(id_ex_regfile_2),
  .forward_alu_result_i(ex_mem_alu_result),
  .forward_mem_to_regfile_i(wb_to_regfile),
  .forward_1_i(fu_forward_1),
  .forward_2_i(fu_forward_2),
  .forward_regfile_2_o(ex_forward_regfile_2),

  .d_alusrc_i(id_ex_decoder_signals[2:2]),

  .rt_i(id_ex_rt),
  .inst_15_11_i(id_ex_inst_15_11),
  .d_regdst_i(id_ex_decoder_signals[0:0]),
  .regdst_o(ex_regdst),

  .pc_adder_i(id_ex_pc_adder),
  .branch_adder_o(ex_branch_adder),

  .d_aluop_i(id_ex_decoder_signals[8:3]),

  .alu_result_o(ex_alu_result),
  .alu_zero_o(ex_alu_zero)
);

///////////
// EX/MEM
Pipeline_Reg_EX_MEM pipeline_reg_ex_mem (
  .clk_i(clk_i), .rst_i(rst_i),
  .keep_i(1'b0),
  .clear_i(flush_ex_mem),

  .regfile_2_i(ex_forward_regfile_2),
  .regfile_2_o(ex_mem_regfile_2),

  .decoder_signals_i(
    {
      id_ex_decoder_signals[14:14],
      id_ex_decoder_signals[13:12],
      id_ex_decoder_signals[11:11],
      id_ex_decoder_signals[10:10],
      id_ex_decoder_signals[9:9],
      id_ex_decoder_signals[1:1]
    }),
  .decoder_signals_o(ex_mem_decoder_signals),

  .regdst_i(ex_regdst),
  .regdst_o(ex_mem_regdst),

  .branch_adder_i(ex_branch_adder),
  .branch_adder_o(ex_mem_branch_adder),

  .alu_result_i(ex_alu_result),
  .alu_result_o(ex_mem_alu_result),

  .alu_zero_i(ex_alu_zero),
  .alu_zero_o(ex_mem_alu_zero)
);

/*
 * ex_mem_decoder_signals : 7 bits
 * branch      = decoder_signals[6:6];
 * branch_type = decoder_signals[5:4];
 * memtoreg    = decoder_signals[3:3];
 * memread     = decoder_signals[2:2];
 * memwrite    = decoder_signals[1:1];
 * regwrite    = decoder_signals[0:0];
 */

///////////
// MEM
Mem mem (
  .clk_i(clk_i), .rst_i(rst_i),

  .alu_zero_i(ex_mem_alu_zero),
  .alu_result_i(ex_mem_alu_result),
  .d_branch_type_i(ex_mem_decoder_signals[5:4]),

  .d_branch_i(ex_mem_decoder_signals[6:6]),
  .branch_and_o(mem_branch_and),

  .regfile_2_i(ex_mem_regfile_2),
  .d_memread_i(ex_mem_decoder_signals[2:2]),
  .d_memwrite_i(ex_mem_decoder_signals[1:1]),
  .data_mem_o(mem_data_mem)
);
///////////
// MEM/WB
Pipeline_Reg_MEM_WB pipeline_reg_mem_wb (
  .clk_i(clk_i), .rst_i(rst_i),
  .keep_i(1'b0),
  .clear_i(1'b0),

  .d_memtoreg_i(ex_mem_decoder_signals[3:3]),
  .d_memtoreg_o(mem_wb_d_memtoreg),
  .d_regwrite_i(ex_mem_decoder_signals[0:0]),
  .d_regwrite_o(mem_wb_d_regwrite),
  .regdst_i(ex_mem_regdst),
  .regdst_o(mem_wb_regdst),
  .data_mem_i(mem_data_mem),
  .data_mem_o(mem_wb_data_mem),
  .alu_result_i(ex_mem_alu_result),
  .alu_result_o(mem_wb_alu_result)
);
///////////
// WB
Wb wb (
  .clk_i(clk_i), .rst_i(rst_i), 
  .alu_result_i(mem_wb_alu_result),
  .data_mem_i(mem_wb_data_mem),
  .d_memtoreg_i(mem_wb_d_memtoreg),
  .mem_to_regfile_o(wb_to_regfile)
);
///////////
// Forwarding
// 會需要 ex 階段的 rs, rt
// 假如 mem 階段，我們已知會對某個 register 進行寫入
//   且已知 ex 階段會使用到該 register
//   就把 mem 階段的運算結果 forward 到 ex 階段
// 假如 wb 階段，我們已知會對某個 register 進行寫入
//   且已知 ex 階段會使用到該 register
//   就把 wb 階段的運算結果 forward 到 ex 階段
// 要注意到，光是這樣是無法解決 `lw` and use 的 hazard
//   `lw` and use 需要搭配 pipeline stall ( insert a bubble )
Forward_Unit forwarding_unit(
  .ex_rs_i(id_ex_rs), .ex_rt_i(id_ex_rt),
  .mem_regwrite_i(ex_mem_decoder_signals[0:0]),
  .mem_regdst_i(ex_mem_regdst),
  .wb_regwrite_i(mem_wb_d_regwrite),
  .wb_regdst_i(mem_wb_regdst),
  .forward_1_o(fu_forward_1), .forward_2_o(fu_forward_2)
);
///////////
// data Hazard ( load and then use data hazard )
// 當該道指令走到了 EX 階段, 且令該道指令要進行 memread
//   因為上一道指令走到了 ID 階段, 所以這時候想要使用到的 register index 
//   已經被解析出來了, 所以可以在這時候偵測是否存在 load and then use data
//   hazard
//
//   當該類型 hazard 存在的時候，我們需要將 IF/ID stall 住, 並在 EX 插入一個
//   bubble, 而原先在 EX 的指令則往前進行到了 MEM
//
//   memread = id_ex_decoder_signals[10:10]
//   表示 EX stage 的指令想要從 data_memory 讀取資料到 regfile
//   根據 lw 的 format，會想要把 data_memory 讀取資料到編號為 rt 的 regfile
//
//   id_rs = if_id_inst[25:21]
//   id_rt = if_id_inst[20:16]
always @(*) begin
  if ((id_ex_decoder_signals[10:10] == 1'b1) &&
      ((if_id_inst[25:21] == id_ex_rt) ||
       (if_id_inst[20:16] == id_ex_rt))) begin
    hz_stall_if_id = 1'b1;
  end else begin
    hz_stall_if_id = 1'b0;
  end
end
///////////
// control Hazard ( flush pipeline for branch )
// 因為我們要到 mem 階段才知道要不要做 branch
//   所以當我們在 mem 階段確定要 branch 的時候，需要把 if->id, id->ex, ex->mem
//   的 pipeline-reg 都 flush 掉, 因為這些可能都是不該執行的指令
// 除了 branch 以外，jump 可能也要做類似的處理, 不過這邊沒有實作 jump 指令，所
//   以先不考慮
always @(*) begin
  if (mem_branch_and) begin 
    hz_flush_if_id = 1'b1;
    hz_flush_id_ex = 1'b1;
    hz_flush_ex_mem = 1'b1;
  end else begin
    hz_flush_if_id = 1'b0;
    hz_flush_id_ex = 1'b0;
    hz_flush_ex_mem = 1'b0;
  end
end
//////////////////////////////////
endmodule
