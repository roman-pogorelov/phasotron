onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aurora_tx_guard/rst
add wave -noupdate /aurora_tx_guard/clk
add wave -noupdate -divider <NULL>
add wave -noupdate /aurora_tx_guard/channel_up
add wave -noupdate -divider <NULL>
add wave -noupdate /aurora_tx_guard/loss_data
add wave -noupdate /aurora_tx_guard/loss_frame
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /aurora_tx_guard/i_tx_tdata
add wave -noupdate -radix hexadecimal /aurora_tx_guard/i_tx_tkeep
add wave -noupdate /aurora_tx_guard/i_tx_tvalid
add wave -noupdate /aurora_tx_guard/i_tx_tlast
add wave -noupdate /aurora_tx_guard/i_tx_tready
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /aurora_tx_guard/o_tx_tdata
add wave -noupdate -radix hexadecimal /aurora_tx_guard/o_tx_tkeep
add wave -noupdate /aurora_tx_guard/o_tx_tvalid
add wave -noupdate /aurora_tx_guard/o_tx_tlast
add wave -noupdate /aurora_tx_guard/o_tx_tready
add wave -noupdate -divider <NULL>
add wave -noupdate /aurora_tx_guard/removal_wip
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {77 ns} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
