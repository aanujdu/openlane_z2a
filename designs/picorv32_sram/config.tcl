# User config
set ::env(DESIGN_NAME) picorv32_sram

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) "100.0"
set ::env(CLOCK_PORT) "clk"

set ::env(MACRO_PLACEMENT_CFG) [glob $::env(DESIGN_DIR)/macro.cfg]

### Black-box verilog and views
#set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]
set ::env(EXTRA_LEFS) [glob $::env(DESIGN_DIR)/macros/lef/*.lef]
set ::env(EXTRA_GDS_FILES) [glob $::env(DESIGN_DIR)/macros/gds/*.gds]

set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA) {0 0 2000 2000}

### Macro PDN Connections
set ::env(FP_PDN_MACRO_HOOKS) "\
        sram vccd1 vssd1"
set ::env(FP_PDN_CHECK_NODES) 0
set ::env(FP_PDN_ENABLE_RAILS) 0

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

