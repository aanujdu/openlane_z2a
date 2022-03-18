`timescale 1 ns / 1 ps

module picorv32_sram(
`ifdef USE_POWER_PINS
        input vccd1,
	input vssd1,
`endif
        input             clk, resetn,
	output            trap,
	input             sram_csb0,sram_csb1,
	output            mem_la_read,
	output            mem_la_write,
	output     [31:0] mem_la_addr,
	output [31:0]     mem_la_wdata,
	output [ 3:0]     mem_la_wstrb,
	output [31:0]     mem_rdata1,
	output            mem_instr,

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
	output [31:0] eoi,

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
	wire        mem_valid;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [ 3:0] mem_wstrb;
	wire [31:0] mem_rdata;
	wire [13:0] mem_addr_unused;
  
  assign mem_addr_unused=mem_addr[31:18]; //tying unused addr bits to outer pins to prevent any violations

  sky130_sram_2kbyte_1rw1r_32x512_8 sram(
  `ifdef USE_POWER_PINS
    .vccd1(vccd1),
    .vssd1(vssd1),
  `endif
  // Port 0: RW
    .clk0(clk),.csb0(sram_csb0),.web0(mem_valid),
    .wmask0(mem_wstrb),.addr0(mem_addr[8:0]),
    .din0(mem_wdata),.dout0(mem_rdata),
  // Port 1: R
    .clk1(clk),.csb1(sram_csb1),
    .addr1(mem_addr[17:9]),
    .dout1(mem_rdata1));

  picorv32a_woready cpu(
        .clk(clk),.resetn(resetn),
	.trap(trap),
	.mem_valid(mem_valid),

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
	.trace_data(trace_data));

endmodule
