set_false_path -to [get_pins -filter {NAME =~ */D} -of_objects [get_cells -hierarchical -filter {NAME =~ *support_reset_logic*/*u_rst_sync_gt*/stg1_aurora64b66b_cdc_to*}]]
