# 100 MHz clock
create_clock -period 10.000 -name clk_100mhz [get_ports clk_100mhz_p]

# GT reference clock
create_clock -period 6.400 -name clk_gt_156p25mhz [get_ports clk_gt_156p25mhz_p]

# Exclude MIG 7-Series system reset
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *infrastructure/rst*_sync_r*/PRE}]