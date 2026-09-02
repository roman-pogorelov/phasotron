onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tip_dn_ep_tb/rst
add wave -noupdate /tip_dn_ep_tb/clk
add wave -noupdate -divider Status
add wave -noupdate /tip_dn_ep_tb/dn_transp_stat/link_up
add wave -noupdate /tip_dn_ep_tb/dn_transp_stat/soft_err
add wave -noupdate /tip_dn_ep_tb/dn_transp_stat/hard_err
add wave -noupdate /tip_dn_ep_tb/dn_transp_stat/rx_data_loss
add wave -noupdate /tip_dn_ep_tb/dn_transp_stat/rx_frame_loss
add wave -noupdate /tip_dn_ep_tb/dn_transp_stat/tx_data_loss
add wave -noupdate /tip_dn_ep_tb/dn_transp_stat/tx_frame_loss
add wave -noupdate -divider {DN transport IN}
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/dn_transp_in/tdata
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/dn_transp_in/tkeep
add wave -noupdate /tip_dn_ep_tb/dn_transp_in/tvalid
add wave -noupdate /tip_dn_ep_tb/dn_transp_in/tlast
add wave -noupdate /tip_dn_ep_tb/dn_transp_in/tready
add wave -noupdate -divider {DN transport OUT}
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/dn_transp_out/tdata
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/dn_transp_out/tkeep
add wave -noupdate /tip_dn_ep_tb/dn_transp_out/tvalid
add wave -noupdate /tip_dn_ep_tb/dn_transp_out/tlast
add wave -noupdate /tip_dn_ep_tb/dn_transp_out/tready
add wave -noupdate -divider APB3
add wave -noupdate -radix hexadecimal -childformat {{/tip_dn_ep_tb/dn_apb3_s/paddr.word_addr -radix hexadecimal} {/tip_dn_ep_tb/dn_apb3_s/paddr.byte_idx -radix hexadecimal}} -expand -subitemconfig {/tip_dn_ep_tb/dn_apb3_s/paddr.word_addr {-radix hexadecimal} /tip_dn_ep_tb/dn_apb3_s/paddr.byte_idx {-radix hexadecimal}} /tip_dn_ep_tb/dn_apb3_s/paddr
add wave -noupdate /tip_dn_ep_tb/dn_apb3_s/psel
add wave -noupdate /tip_dn_ep_tb/dn_apb3_s/penable
add wave -noupdate /tip_dn_ep_tb/dn_apb3_s/pwrite
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/dn_apb3_s/pwdata
add wave -noupdate /tip_dn_ep_tb/dn_apb3_s/pready
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/dn_apb3_s/prdata
add wave -noupdate /tip_dn_ep_tb/dn_apb3_s/pslverr
add wave -noupdate -divider {UP control IN}
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/up_ctrl_in/tdata
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/up_ctrl_in/tkeep
add wave -noupdate /tip_dn_ep_tb/up_ctrl_in/tvalid
add wave -noupdate /tip_dn_ep_tb/up_ctrl_in/tlast
add wave -noupdate /tip_dn_ep_tb/up_ctrl_in/tready
add wave -noupdate -divider {UP control OUT}
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/up_ctrl_out/tdata
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/up_ctrl_out/tkeep
add wave -noupdate /tip_dn_ep_tb/up_ctrl_out/tvalid
add wave -noupdate /tip_dn_ep_tb/up_ctrl_out/tlast
add wave -noupdate /tip_dn_ep_tb/up_ctrl_out/tready
add wave -noupdate -divider {UP data OUT}
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/up_data_out/tdata
add wave -noupdate -radix hexadecimal /tip_dn_ep_tb/up_data_out/tkeep
add wave -noupdate /tip_dn_ep_tb/up_data_out/tvalid
add wave -noupdate /tip_dn_ep_tb/up_data_out/tlast
add wave -noupdate /tip_dn_ep_tb/up_data_out/tready
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {75887 ps} 0}
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
WaveRestoreZoom {0 ps} {504 ns}
