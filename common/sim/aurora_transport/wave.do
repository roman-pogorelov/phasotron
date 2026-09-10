onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aurora_transport_tb/rst
add wave -noupdate /aurora_transport_tb/gt_clk
add wave -noupdate /aurora_transport_tb/init_clk
add wave -noupdate /aurora_transport_tb/user_rst
add wave -noupdate /aurora_transport_tb/user_clk
add wave -noupdate /aurora_transport_tb/gt_serial0_p
add wave -noupdate /aurora_transport_tb/gt_serial0_n
add wave -noupdate /aurora_transport_tb/gt_serial1_p
add wave -noupdate /aurora_transport_tb/gt_serial1_n
add wave -noupdate /aurora_transport_tb/link_up0
add wave -noupdate /aurora_transport_tb/link_up1
add wave -noupdate /aurora_transport_tb/hard_err0
add wave -noupdate /aurora_transport_tb/hard_err1
add wave -noupdate /aurora_transport_tb/soft_err0
add wave -noupdate /aurora_transport_tb/soft_err1
add wave -noupdate /aurora_transport_tb/rx_data_loss0
add wave -noupdate /aurora_transport_tb/rx_data_loss1
add wave -noupdate /aurora_transport_tb/rx_frame_loss0
add wave -noupdate /aurora_transport_tb/rx_frame_loss1
add wave -noupdate /aurora_transport_tb/tx_data_loss0
add wave -noupdate /aurora_transport_tb/tx_data_loss1
add wave -noupdate /aurora_transport_tb/tx_frame_loss0
add wave -noupdate /aurora_transport_tb/tx_frame_loss1
add wave -noupdate /aurora_transport_tb/tx0_tdata
add wave -noupdate /aurora_transport_tb/tx0_tkeep
add wave -noupdate /aurora_transport_tb/tx0_tvalid
add wave -noupdate /aurora_transport_tb/tx0_tlast
add wave -noupdate /aurora_transport_tb/tx0_tready
add wave -noupdate /aurora_transport_tb/tx1_tdata
add wave -noupdate /aurora_transport_tb/tx1_tkeep
add wave -noupdate /aurora_transport_tb/tx1_tvalid
add wave -noupdate /aurora_transport_tb/tx1_tlast
add wave -noupdate /aurora_transport_tb/tx1_tready
add wave -noupdate /aurora_transport_tb/rx0_tdata
add wave -noupdate /aurora_transport_tb/rx0_tkeep
add wave -noupdate /aurora_transport_tb/rx0_tvalid
add wave -noupdate /aurora_transport_tb/rx0_tlast
add wave -noupdate /aurora_transport_tb/rx0_tready
add wave -noupdate /aurora_transport_tb/rx1_tdata
add wave -noupdate /aurora_transport_tb/rx1_tkeep
add wave -noupdate /aurora_transport_tb/rx1_tvalid
add wave -noupdate /aurora_transport_tb/rx1_tlast
add wave -noupdate /aurora_transport_tb/rx1_tready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3029103 ps} 0}
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
WaveRestoreZoom {3029051 ps} {3030051 ps}
