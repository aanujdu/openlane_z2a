# SCL Configs
set ::env(CLOCK_PERIOD) "17.0"
set ::env(FP_CORE_UTIL) 35
set ::env(SYNTH_MAX_FANOUT) 6
set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]

