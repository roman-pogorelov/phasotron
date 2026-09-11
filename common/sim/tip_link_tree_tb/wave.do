onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/rst
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/gt_clk
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/init_clk
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/user_rst
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/user_clk
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/gt_rx_p
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/gt_rx_n
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/gt_tx_p
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/gt_tx_n
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/stat_link_up
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/stat_soft_err
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/stat_hard_err
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/stat_rx_data_loss
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/stat_rx_frame_loss
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/stat_tx_data_loss
add wave -noupdate /tip_link_tree_tb/the_tip_dn_link/the_tip_transport/the_aurora_transport/stat_tx_frame_loss
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1187592 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {10342273 ps}
