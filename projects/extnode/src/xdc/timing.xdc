# Exclude MIG 7-Series system reset
set_false_path -to [get_pins -hierarchical -filter {NAME =~ *infrastructure/rst*_sync_r*/PRE}]