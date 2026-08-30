vlog -work work ../../src/rtl/axis/axis_if.sv
vlog -work work ../../src/rtl/axis/axis_2stage_buf.sv
vlog -work work ./axis_2stage_buf_tb.sv

vopt work.axis_2stage_buf_tb +acc -o axis_2stage_buf_tb_opt
vsim work.axis_2stage_buf_tb_opt
do wave.do

run 30001ps