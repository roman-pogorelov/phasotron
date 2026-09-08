vlog -work work ../../src/sim/axis/axis_sim.sv
vlog -work work ../../src/rtl/axis/axis_if.sv
vlog -work work ../../src/rtl/axis/axis_2stage_buf.sv
vlog -work work ../../src/sim/apb3/apb3_sim.sv
vlog -work work ../../src/rtl/apb3/apb3.sv
vlog -work work ../../src/sim/tip/tip_sim.sv
vlog -work work ../../src/rtl/tip/tip_defs.sv
vlog -work work ../../src/rtl/tip/tip_if.sv
vlog -work work ../../src/rtl/tip/tip_axis_apb3_bridge.sv
vlog -work work ./tip_axis_apb3_bridge_tb.sv

vopt work.tip_axis_apb3_bridge_tb +acc -o tip_axis_apb3_bridge_tb_opt
vsim work.tip_axis_apb3_bridge_tb_opt
do wave.do

run 30001ps