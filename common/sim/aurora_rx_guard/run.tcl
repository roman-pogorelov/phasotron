vlog -work work ../../src/rtl/aurora/aurora_rx_guard.sv
vopt work.aurora_rx_guard +acc -o aurora_rx_guard_opt
vsim -fsmdebug work.aurora_rx_guard_opt
do wave.do

force rst 1 0ns, 0 15ns
force clk 1 0ns, 0 5ns -r 10ns

force channel_up 0

force fifo_ready 0
force fifo_below_lwm 0
force fifo_above_hwm 0

force i_rx_tdata 0
force i_rx_tkeep 0
force i_rx_tvalid 0
force i_rx_tlast 0

run 30001ps