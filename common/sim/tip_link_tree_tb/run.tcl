vlog -work work /opt/Xilinx/Vivado/2021.2/data/verilog/src/glbl.v

vlog -work work ../../src/sim/aurora/aurora64b66b.v
vlog -work work ../../src/sim/aurora/aurora64b66b_core.v
vlog -work work ../../src/sim/aurora/aurora64b66b_wrapper.v
vlog -work work ../../src/sim/aurora/aurora64b66b_multi_wrapper.v
vlog -work work ../../src/sim/aurora/aurora64b66b_gtx.v
vlog -work work ../../src/sim/aurora/aurora64b66b_64b66b_descrambler.v
vlog -work work ../../src/sim/aurora/aurora64b66b_64b66b_scrambler.v
vlog -work work ../../src/sim/aurora/aurora64b66b_aurora_lane.v
vlog -work work ../../src/sim/aurora/aurora64b66b_axi_to_ll.v
vlog -work work ../../src/sim/aurora/aurora64b66b_block_sync_sm.v
vlog -work work ../../src/sim/aurora/aurora64b66b_cbcc_gtx_6466.v
vlog -work work ../../src/sim/aurora/aurora64b66b_cdc_sync.v
vlog -work work ../../src/sim/aurora/aurora64b66b_channel_err_detect.v
vlog -work work ../../src/sim/aurora/aurora64b66b_channel_init_sm.v
vlog -work work ../../src/sim/aurora/aurora64b66b_ch_bond_code_gen.v
vlog -work work ../../src/sim/aurora/aurora64b66b_common_logic_cbcc.v
vlog -work work ../../src/sim/aurora/aurora64b66b_common_reset_cbcc.v
vlog -work work ../../src/sim/aurora/aurora64b66b_err_detect.v
vlog -work work ../../src/sim/aurora/aurora64b66b_global_logic.v
vlog -work work ../../src/sim/aurora/aurora64b66b_lane_init_sm.v
vlog -work work ../../src/sim/aurora/aurora64b66b_ll_to_axi.v
vlog -work work ../../src/sim/aurora/aurora64b66b_polarity_check.v
vlog -work work ../../src/sim/aurora/aurora64b66b_reset_logic.v
vlog -work work ../../src/sim/aurora/aurora64b66b_rx_ll.v
vlog -work work ../../src/sim/aurora/aurora64b66b_rx_ll_datapath.v
vlog -work work ../../src/sim/aurora/aurora64b66b_rx_startup_fsm.v
vlog -work work ../../src/sim/aurora/aurora64b66b_standard_cc_module.v
vlog -work work ../../src/sim/aurora/aurora64b66b_sym_dec.v
vlog -work work ../../src/sim/aurora/aurora64b66b_sym_gen.v
vlog -work work ../../src/sim/aurora/aurora64b66b_tx_ll.v
vlog -work work ../../src/sim/aurora/aurora64b66b_tx_ll_control_sm.v
vlog -work work ../../src/sim/aurora/aurora64b66b_tx_ll_datapath.v
vlog -work work ../../src/sim/aurora/aurora64b66b_tx_startup_fsm.v
vlog -work work ../../src/sim/aurora/aurora64b66b_width_conversion.v

vlog -work work ../../src/rtl/aurora/aurora_params.sv
vlog -work work ../../src/rtl/aurora/aurora_rx_guard.sv
vlog -work work ../../src/rtl/aurora/aurora_tx_guard.sv
vlog -work work ../../src/rtl/aurora/aurora_rx_fifo.sv
vlog -work work ../../src/rtl/aurora/aurora_tx_fifo.sv
vlog -work work ../../src/rtl/aurora/aurora64b66b_wrp.sv
vlog -work work ../../src/rtl/aurora/aurora_transport.sv
vlog -work work ../../src/rtl/aurora/support_6_2500/aurora64b66b_clock_module.v
vlog -work work ../../src/rtl/aurora/support_6_2500/aurora64b66b_gt_common_wrapper.v
vlog -work work ../../src/rtl/aurora/support_6_2500/aurora64b66b_support_reset_logic.v

vlog -work work ../../src/rtl/generic/onehot2binary.sv
vlog -work work ../../src/rtl/generic/arbiter.sv
vlog -work work ../../src/rtl/apb3/apb3.sv
vlog -work work ../../src/sim/apb3/apb3_sim.sv
vlog -work work ../../src/sim/axis/axis_sim.sv
vlog -work work ../../src/rtl/axis/axis_if.sv
vlog -work work ../../src/rtl/axis/axis_multicast.sv
vlog -work work ../../src/rtl/axis/axis_2stage_buf.sv
vlog -work work ../../src/rtl/axis/axis_arbiter.sv
vlog -work work ../../src/rtl/tip/tip_defs.sv
vlog -work work ../../src/sim/tip/tip_sim.sv
vlog -work work ../../src/rtl/tip/tip_if.sv
vlog -work work ../../src/rtl/tip/tip_transport.sv
vlog -work work ../../src/rtl/tip/tip_up_conf.sv
vlog -work work ../../src/rtl/tip/tip_axis_apb3_bridge.sv
vlog -work work ../../src/rtl/tip/tip_up_router.sv
vlog -work work ../../src/rtl/tip/tip_up_ep.sv
vlog -work work ../../src/rtl/tip/tip_up_link.sv
vlog -work work ../../src/rtl/tip/tip_mid_link.sv
vlog -work work ../../src/rtl/tip/tip_dn_conf.sv
vlog -work work ../../src/rtl/tip/tip_dn_router.sv
vlog -work work ../../src/rtl/tip/tip_dn_ep.sv
vlog -work work ../../src/rtl/tip/tip_dn_link.sv
vlog -work work ../../src/rtl/tip/tip_mid_apb3_intcon.sv
vlog -work work ../../src/rtl/tip/tip_mid_axis_intcon.sv
vlog -work work ../../src/rtl/tip/tip_mid_ep.sv
vlog -work work ../../src/rtl/tip/tip_reset.sv
vlog -work work ../../src/rtl/dummy/user_system.sv

vlog -sv -work work ./tip_link_tree_tb.sv

vopt work.tip_link_tree_tb work.glbl +acc -o tip_link_tree_tb_opt -L unisims_ver -L secureip -L xpm
vsim work.tip_link_tree_tb_opt
do wave.do

run 30001ps