`timescale 1 ns / 1 ps
module picorv32_woready(
	input             clk, resetn,
	output            trap,

	output            mem_valid,
	output            mem_instr,

	output  [31:0]    mem_addr,
	output  [31:0]    mem_wdata,
	output  [ 3:0]    mem_wstrb,
	input   [31:0]    mem_rdata,

	// Look-Ahead Interface
	output            mem_la_read,
	output            mem_la_write,
	output     [31:0] mem_la_addr,
	output [31:0]     mem_la_wdata,
	output [ 3:0]     mem_la_wstrb,

	// Pico Co-Processor Interface (PCPI)
	output            pcpi_valid,
	output [31:0]     pcpi_insn,
	output     [31:0] pcpi_rs1,
	output     [31:0] pcpi_rs2,
	input             pcpi_wr,
	input      [31:0] pcpi_rd,
	input             pcpi_wait,
	input             pcpi_ready,

	// IRQ Interface
	input      [31:0] irq,
	output [31:0]     eoi,

`ifdef RISCV_FORMAL
	output        rvfi_valid,
	output [63:0] rvfi_order,
	output [31:0] rvfi_insn,
	output        rvfi_trap,
	output        rvfi_halt,
	output        rvfi_intr,
	output [ 4:0] rvfi_rs1_addr,
	output [ 4:0] rvfi_rs2_addr,
	output [31:0] rvfi_rs1_rdata,
	output [31:0] rvfi_rs2_rdata,
	output [ 4:0] rvfi_rd_addr,
	output [31:0] rvfi_rd_wdata,
	output [31:0] rvfi_pc_rdata,
	output [31:0] rvfi_pc_wdata,
	output [31:0] rvfi_mem_addr,
	output [ 3:0] rvfi_mem_rmask,
	output [ 3:0] rvfi_mem_wmask,
	output [31:0] rvfi_mem_rdata,
	output [31:0] rvfi_mem_wdata,
`endif

	// Trace Interface
	output        trace_valid,
	output [35:0] trace_data
);
  
  reg mem_ready;

  picorv32a cpu(
  	.clk(clk), 
	.resetn(resetn),
	.trap(trap),

	.mem_valid(mem_valid),
	.mem_instr(mem_instr),
	.mem_ready(mem_ready),

	.mem_addr(mem_addr),
	.mem_wdata(mem_wdata),
	.mem_wstrb(mem_wstrb),
	.mem_rdata(mem_rdata),

	// Look-Ahead Interface
	.mem_la_read(mem_la_read),
	.mem_la_write(mem_la_write),
	.mem_la_addr(mem_la_addr),
	.mem_la_wdata(mem_la_wdata),
	.mem_la_wstrb(mem_la_wstrb),

	// Pico Co-Processor Interface (PCPI)
	.pcpi_valid(pcpi_valid),
	.pcpi_insn(pcpi_insn),
	.pcpi_rs1(pcpi_rs1),
	.pcpi_rs2(pcpi_rs2),
	.pcpi_wr(pcpi_wr),
	.pcpi_rd(pcpi_rd),
	.pcpi_wait(pcpi_wait),
	.pcpi_ready(pcpi_ready),

	// IRQ Interface
	.irq(irq),
	.eoi(eoi),

`ifdef RISCV_FORMAL
	.rvfi_valid(rvfi_valid),
	.rvfi_order(rvfi_order),
	.rvfi_insn(rvfi_insn),
	.rvfi_trap(rvfi_trap),
	.rvfi_halt(rvfi_halt),
	.rvfi_intr(rvfi_intr),
	.rvfi_rs1_addr(rvfi_rs1_addr),
	.rvfi_rs2_addr(rvfi_rs2_addr),
	.rvfi_rs1_rdata(rvfi_rs1_rdata),
	.rvfi_rs2_rdata(rvfi_rs2_rdata),
	.rvfi_rd_addr(rvfi_rd_addr),
	.rvfi_rd_wdata(rvfi_rd_wdata),
	.rvfi_pc_rdata(rvfi_pc_rdata),
	.rvfi_pc_wdata(rvfi_pc_wdata),
	.rvfi_mem_addr(rvfi_mem_addr),
	.rvfi_mem_rmask(rvfi_mem_rmask),
	.rvfi_mem_wmask(rvfi_mem_wmask),
	.rvfi_mem_rdata(rvfi_mem_rdata),
	.rvfi_mem_wdata(rvfi_mem_wdata),
`endif

	// Trace Interface
	.trace_valid(trace_valid),
	.trace_data(trace_data)
  );

  always@(posedge clk)begin     
    mem_ready<=1'b0;
    if(mem_valid & ~mem_ready)
      mem_ready<=1'b1;       	     
  end
endmodule
