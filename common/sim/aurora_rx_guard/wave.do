onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aurora_rx_guard/rst
add wave -noupdate /aurora_rx_guard/clk
add wave -noupdate -divider <NULL>
add wave -noupdate /aurora_rx_guard/channel_up
add wave -noupdate -divider <NULL>
add wave -noupdate /aurora_rx_guard/fifo_below_lwm
add wave -noupdate /aurora_rx_guard/fifo_above_hwm
add wave -noupdate /aurora_rx_guard/fifo_ready
add wave -noupdate -divider <NULL>
add wave -noupdate /aurora_rx_guard/loss_data
add wave -noupdate /aurora_rx_guard/loss_frame
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /aurora_rx_guard/i_rx_tdata
add wave -noupdate -radix hexadecimal /aurora_rx_guard/i_rx_tkeep
add wave -noupdate /aurora_rx_guard/i_rx_tvalid
add wave -noupdate /aurora_rx_guard/i_rx_tlast
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /aurora_rx_guard/o_rx_tdata
add wave -noupdate -radix hexadecimal /aurora_rx_guard/o_rx_tkeep
add wave -noupdate /aurora_rx_guard/o_rx_tvalid
add wave -noupdate /aurora_rx_guard/o_rx_tlast
add wave -noupdate -divider <NULL>
add wave -noupdate /aurora_rx_guard/i_rx_tfirst
add wave -noupdate /aurora_rx_guard/buf_capture
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate -color Gold /aurora_rx_guard/cstate
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {59 ns} 0}
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
