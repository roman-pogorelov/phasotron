onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider <NULL>
add wave -noupdate /tip_link_tree_tb/the_tip_mid_link/the_tip_transport/stat_link_up
add wave -noupdate -divider <NULL>
add wave -noupdate -divider <NULL>
add wave -noupdate /tip_link_tree_tb/mid_user_apb3/paddr
add wave -noupdate /tip_link_tree_tb/mid_user_apb3/psel
add wave -noupdate /tip_link_tree_tb/mid_user_apb3/penable
add wave -noupdate /tip_link_tree_tb/mid_user_apb3/pwrite
add wave -noupdate /tip_link_tree_tb/mid_user_apb3/pwdata
add wave -noupdate /tip_link_tree_tb/mid_user_apb3/pready
add wave -noupdate /tip_link_tree_tb/mid_user_apb3/prdata
add wave -noupdate /tip_link_tree_tb/mid_user_apb3/pslverr
add wave -noupdate -divider <NULL>
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[0]/paddr}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[0]/psel}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[0]/penable}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[0]/pwrite}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[0]/pwdata}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[0]/pready}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[0]/prdata}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[0]/pslverr}
add wave -noupdate -divider <NULL>
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[1]/paddr}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[1]/psel}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[1]/penable}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[1]/pwrite}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[1]/pwdata}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[1]/pready}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[1]/prdata}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[1]/pslverr}
add wave -noupdate -divider <NULL>
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[2]/paddr}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[2]/psel}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[2]/penable}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[2]/pwrite}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[2]/pwdata}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[2]/pready}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[2]/prdata}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[2]/pslverr}
add wave -noupdate -divider <NULL>
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[3]/paddr}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[3]/psel}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[3]/penable}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[3]/pwrite}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[3]/pwdata}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[3]/pready}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[3]/prdata}
add wave -noupdate {/tip_link_tree_tb/up_user_apb3[3]/pslverr}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28095581 ps} 0} {{Cursor 2} {1150672 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {0 ps} {42031501 ps}
