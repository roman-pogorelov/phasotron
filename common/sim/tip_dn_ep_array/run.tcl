vlog -work work ../../src/rtl/apb3/apb3.sv
vlog -work work ../../src/sim/apb3/apb3_sim.sv
vlog -work work ../../src/rtl/generic/arbiter.sv
vlog -work work ../../src/rtl/generic/onehot2binary.sv
vlog -work work ../../src/sim/axis/axis_sim.sv
vlog -work work ../../src/rtl/axis/axis_if.sv
vlog -work work ../../src/rtl/axis/axis_multicast.sv
vlog -work work ../../src/rtl/axis/axis_2stage_buf.sv
vlog -work work ../../src/rtl/axis/axis_arbiter.sv
vlog -work work ../../src/rtl/tip/tip_defs.sv
vlog -work work ../../src/sim/tip/tip_sim.sv
vlog -work work ../../src/rtl/tip/tip_if.sv
vlog -work work ../../src/rtl/tip/tip_dn_router.sv
vlog -work work ../../src/rtl/tip/tip_dn_conf.sv
vlog -work work ../../src/rtl/tip/tip_dn_ep.sv
vlog -work work ../../src/rtl/tip/tip_mid_apb3_intcon.sv
vlog -work work ../../src/rtl/tip/tip_mid_axis_intcon.sv

vlog -sv -work work ./tip_dn_ep_array_tb.sv

vopt work.tip_dn_ep_array_tb +acc -o tip_dn_ep_array_tb_opt
vsim work.tip_dn_ep_array_tb_opt
do wave.do

run 30001ps