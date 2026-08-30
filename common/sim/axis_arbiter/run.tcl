vlog -work work ../../src/rtl/generic/onehot2binary.sv
vlog -work work ../../src/rtl/generic/arbiter.sv
vlog -work work ../../src/rtl/axis/axis_if.sv
vlog -work work ../../src/rtl/axis/axis_arbiter.sv
vlog -work work ./axis_arbiter_tb.sv

vopt work.axis_arbiter_tb +acc -o axis_arbiter_tb_opt
vsim work.axis_arbiter_tb_opt
do wave.do

run 30001ps