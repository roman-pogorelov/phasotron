vlog -work work ../../src/rtl/aurora/aurora_tx_guard.sv
vopt work.aurora_tx_guard +acc -o aurora_tx_guard_opt
vsim work.aurora_tx_guard_opt
do wave.do

force rst 1 0ns, 0 15ns
force clk 1 0ns, 0 5ns -r 10ns

force channel_up 0

force i_tx_tdata 0
force i_tx_tkeep 0
force i_tx_tvalid 0
force i_tx_tlast 0

force o_tx_tready 1

run 30001ps