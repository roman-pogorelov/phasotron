onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axis_multicast_tb/rst
add wave -noupdate /axis_multicast_tb/clk
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /axis_multicast_tb/mask
add wave -noupdate -divider In
add wave -noupdate -radix hexadecimal /axis_multicast_tb/in/tdata
add wave -noupdate -radix hexadecimal /axis_multicast_tb/in/tkeep
add wave -noupdate /axis_multicast_tb/in/tvalid
add wave -noupdate /axis_multicast_tb/in/tlast
add wave -noupdate /axis_multicast_tb/in/tready
add wave -noupdate -divider {Out 0}
add wave -noupdate -radix hexadecimal {/axis_multicast_tb/out[0]/tdata}
add wave -noupdate -radix hexadecimal {/axis_multicast_tb/out[0]/tkeep}
add wave -noupdate {/axis_multicast_tb/out[0]/tvalid}
add wave -noupdate {/axis_multicast_tb/out[0]/tlast}
add wave -noupdate {/axis_multicast_tb/out[0]/tready}
add wave -noupdate -divider {Out 1}
add wave -noupdate -radix hexadecimal {/axis_multicast_tb/out[1]/tdata}
add wave -noupdate -radix hexadecimal {/axis_multicast_tb/out[1]/tkeep}
add wave -noupdate {/axis_multicast_tb/out[1]/tvalid}
add wave -noupdate {/axis_multicast_tb/out[1]/tlast}
add wave -noupdate {/axis_multicast_tb/out[1]/tready}
add wave -noupdate -divider {Out 2}
add wave -noupdate -radix hexadecimal {/axis_multicast_tb/out[2]/tdata}
add wave -noupdate -radix hexadecimal {/axis_multicast_tb/out[2]/tkeep}
add wave -noupdate {/axis_multicast_tb/out[2]/tvalid}
add wave -noupdate {/axis_multicast_tb/out[2]/tlast}
add wave -noupdate {/axis_multicast_tb/out[2]/tready}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67456 ps} 0}
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
WaveRestoreZoom {0 ps} {252 ns}
