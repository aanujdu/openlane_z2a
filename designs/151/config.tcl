# User config
set ::env(DESIGN_NAME) riscv_top

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]
set ::env(CLOCK_PORT) "clk"
# Design config
set ::env(CLOCK_PERIOD) 30
set ::env(SYNTH_STRATEGY) "DELAY 1"

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}
