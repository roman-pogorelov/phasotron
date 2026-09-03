onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tip_dn_ep_array_tb/rst
add wave -noupdate /tip_dn_ep_array_tb/clk
add wave -noupdate -divider APB3
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /tip_dn_ep_array_tb/up_apb3_s/paddr
add wave -noupdate /tip_dn_ep_array_tb/up_apb3_s/psel
add wave -noupdate /tip_dn_ep_array_tb/up_apb3_s/penable
add wave -noupdate /tip_dn_ep_array_tb/up_apb3_s/pwrite
add wave -noupdate -radix hexadecimal /tip_dn_ep_array_tb/up_apb3_s/pwdata
add wave -noupdate /tip_dn_ep_array_tb/up_apb3_s/pready
add wave -noupdate -radix hexadecimal /tip_dn_ep_array_tb/up_apb3_s/prdata
add wave -noupdate /tip_dn_ep_array_tb/up_apb3_s/pslverr
add wave -noupdate -divider {Transport #0}
add wave -noupdate -divider IN
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_in[0]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_in[0]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[0]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[0]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[0]/tready}
add wave -noupdate -divider OUT
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_out[0]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_out[0]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[0]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[0]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[0]/tready}
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Transport #1}
add wave -noupdate -divider IN
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_in[1]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_in[1]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[1]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[1]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[1]/tready}
add wave -noupdate -divider OUT
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_out[1]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_out[1]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[1]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[1]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[1]/tready}
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Transport #2}
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_in[2]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_in[2]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[2]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[2]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_in[2]/tready}
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_out[2]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/dn_transp_out[2]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[2]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[2]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/dn_transp_out[2]/tready}
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Control IN}
add wave -noupdate -radix hexadecimal /tip_dn_ep_array_tb/up_ctrl_in/tdata
add wave -noupdate -radix hexadecimal /tip_dn_ep_array_tb/up_ctrl_in/tkeep
add wave -noupdate /tip_dn_ep_array_tb/up_ctrl_in/tvalid
add wave -noupdate /tip_dn_ep_array_tb/up_ctrl_in/tlast
add wave -noupdate /tip_dn_ep_array_tb/up_ctrl_in/tready
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Control OUT}
add wave -noupdate -radix hexadecimal /tip_dn_ep_array_tb/up_ctrl_out/tdata
add wave -noupdate -radix hexadecimal /tip_dn_ep_array_tb/up_ctrl_out/tkeep
add wave -noupdate /tip_dn_ep_array_tb/up_ctrl_out/tvalid
add wave -noupdate /tip_dn_ep_array_tb/up_ctrl_out/tlast
add wave -noupdate /tip_dn_ep_array_tb/up_ctrl_out/tready
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Data OUT #0}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/up_data_out[0]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/up_data_out[0]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[0]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[0]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[0]/tready}
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Data OUT #1}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/up_data_out[1]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/up_data_out[1]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[1]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[1]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[1]/tready}
add wave -noupdate -divider <NULL>
add wave -noupdate -divider {Data OUT #2}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/up_data_out[2]/tdata}
add wave -noupdate -radix hexadecimal {/tip_dn_ep_array_tb/up_data_out[2]/tkeep}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[2]/tvalid}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[2]/tlast}
add wave -noupdate {/tip_dn_ep_array_tb/up_data_out[2]/tready}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1911783 ps} 0}
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
WaveRestoreZoom {0 ps} {5281501 ps}
