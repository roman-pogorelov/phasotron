onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axis_arbiter_tb/rst
add wave -noupdate /axis_arbiter_tb/clk
add wave -noupdate -divider {In 0}
add wave -noupdate -radix hexadecimal {/axis_arbiter_tb/in[0]/tdata}
add wave -noupdate -radix hexadecimal {/axis_arbiter_tb/in[0]/tkeep}
add wave -noupdate {/axis_arbiter_tb/in[0]/tvalid}
add wave -noupdate {/axis_arbiter_tb/in[0]/tlast}
add wave -noupdate {/axis_arbiter_tb/in[0]/tready}
add wave -noupdate -divider {In 1}
add wave -noupdate -radix hexadecimal {/axis_arbiter_tb/in[1]/tdata}
add wave -noupdate -radix hexadecimal {/axis_arbiter_tb/in[1]/tkeep}
add wave -noupdate {/axis_arbiter_tb/in[1]/tvalid}
add wave -noupdate {/axis_arbiter_tb/in[1]/tlast}
add wave -noupdate {/axis_arbiter_tb/in[1]/tready}
add wave -noupdate -divider {In 2}
add wave -noupdate -radix hexadecimal {/axis_arbiter_tb/in[2]/tdata}
add wave -noupdate -radix hexadecimal {/axis_arbiter_tb/in[2]/tkeep}
add wave -noupdate {/axis_arbiter_tb/in[2]/tvalid}
add wave -noupdate {/axis_arbiter_tb/in[2]/tlast}
add wave -noupdate {/axis_arbiter_tb/in[2]/tready}
add wave -noupdate -divider Out
add wave -noupdate -radix hexadecimal /axis_arbiter_tb/out/tdata
add wave -noupdate -radix hexadecimal /axis_arbiter_tb/out/tkeep
add wave -noupdate /axis_arbiter_tb/out/tvalid
add wave -noupdate /axis_arbiter_tb/out/tlast
add wave -noupdate /axis_arbiter_tb/out/tready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13031 ps} 0}
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
