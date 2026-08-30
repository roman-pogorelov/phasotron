onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axis_2stage_buf_tb/rst
add wave -noupdate /axis_2stage_buf_tb/clk
add wave -noupdate -divider In
add wave -noupdate -radix hexadecimal /axis_2stage_buf_tb/in/tdata
add wave -noupdate -radix hexadecimal /axis_2stage_buf_tb/in/tkeep
add wave -noupdate /axis_2stage_buf_tb/in/tvalid
add wave -noupdate /axis_2stage_buf_tb/in/tlast
add wave -noupdate /axis_2stage_buf_tb/in/tready
add wave -noupdate -divider Out
add wave -noupdate -radix hexadecimal /axis_2stage_buf_tb/out/tdata
add wave -noupdate -radix hexadecimal /axis_2stage_buf_tb/out/tkeep
add wave -noupdate /axis_2stage_buf_tb/out/tvalid
add wave -noupdate /axis_2stage_buf_tb/out/tlast
add wave -noupdate /axis_2stage_buf_tb/out/tready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {101567 ps} 0}
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
WaveRestoreZoom {0 ps} {344178 ps}
