vlog -work work ../../src/rtl/axis/axis_if.sv
vlog -work work ../../src/rtl/axis/axis_multicast.sv
vlog -work work ./axis_multicast_tb.sv

vopt work.axis_multicast_tb +acc -o axis_multicast_tb_opt
vsim work.axis_multicast_tb_opt
do wave.do

run 30001ps