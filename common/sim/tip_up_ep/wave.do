onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tip_up_ep_tb/rst
add wave -noupdate /tip_up_ep_tb/clk
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/transp_in/tdata
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/transp_in/tkeep
add wave -noupdate /tip_up_ep_tb/transp_in/tvalid
add wave -noupdate /tip_up_ep_tb/transp_in/tlast
add wave -noupdate /tip_up_ep_tb/transp_in/tready
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/transp_out/tdata
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/transp_out/tkeep
add wave -noupdate /tip_up_ep_tb/transp_out/tvalid
add wave -noupdate /tip_up_ep_tb/transp_out/tlast
add wave -noupdate /tip_up_ep_tb/transp_out/tready
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/ctrl_out/tdata
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/ctrl_out/tkeep
add wave -noupdate /tip_up_ep_tb/ctrl_out/tvalid
add wave -noupdate /tip_up_ep_tb/ctrl_out/tlast
add wave -noupdate /tip_up_ep_tb/ctrl_out/tready
add wave -noupdate -divider <NULL>
add wave -noupdate /tip_up_ep_tb/the_tip_up_ep/up_req/reset
add wave -noupdate -divider <NULL>
add wave -noupdate /tip_up_ep_tb/the_tip_up_ep/the_tip_up_conf/indiv_addr
add wave -noupdate /tip_up_ep_tb/the_tip_up_ep/the_tip_up_conf/group_addr0
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/user_apb3/paddr
add wave -noupdate /tip_up_ep_tb/user_apb3/psel
add wave -noupdate /tip_up_ep_tb/user_apb3/penable
add wave -noupdate /tip_up_ep_tb/user_apb3/pwrite
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/user_apb3/pwdata
add wave -noupdate /tip_up_ep_tb/user_apb3/pready
add wave -noupdate -radix hexadecimal /tip_up_ep_tb/user_apb3/prdata
add wave -noupdate /tip_up_ep_tb/user_apb3/pslverr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {657625 ps} 0}
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
WaveRestoreZoom {286122 ps} {2115811 ps}
