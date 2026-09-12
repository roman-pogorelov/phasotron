# SPDX-License-Identifier: BSD-2-Clause-Views
# Copyright (c) 2019-2023 The Regents of the University of California


# FPGA settings
FPGA_PART = xc7k355tffg901-1
FPGA_TOP = ctrlnode


# Files for synthesis
SYN_FILES  = ../src/rtl/ctrlnode.sv
SYN_FILES += ../src/rtl/clock_unit.sv
SYN_FILES += ../src/rtl/debug_ctrl.sv
SYN_FILES += ../../../common/src/rtl/misc/freq_estimator.sv
SYN_FILES += ../../../common/src/rtl/apb3/apb3.sv
SYN_FILES += ../../../common/src/rtl/axis/axis_if.sv
SYN_FILES += ../../../common/src/rtl/axis/axis_2stage_buf.sv
SYN_FILES += ../../../common/src/rtl/axis/axis_multicast.sv
SYN_FILES += ../../../common/src/rtl/tip/tip_if.sv
SYN_FILES += ../../../common/src/rtl/tip/tip_defs.sv
SYN_FILES += ../../../common/src/rtl/tip/tip_transport.sv
SYN_FILES += ../../../common/src/rtl/tip/tip_reset.sv
SYN_FILES += ../../../common/src/rtl/tip/tip_dn_ep.sv
SYN_FILES += ../../../common/src/rtl/tip/tip_dn_conf.sv
SYN_FILES += ../../../common/src/rtl/tip/tip_dn_router.sv
SYN_FILES += ../../../common/src/rtl/tip/tip_dn_link.sv
SYN_FILES += ../../../common/src/rtl/aurora/aurora64b66b_wrp.sv
SYN_FILES += ../../../common/src/rtl/aurora/aurora_params.sv
SYN_FILES += ../../../common/src/rtl/aurora/aurora_transport.sv
SYN_FILES += ../../../common/src/rtl/aurora/aurora_rx_fifo.sv
SYN_FILES += ../../../common/src/rtl/aurora/aurora_tx_fifo.sv
SYN_FILES += ../../../common/src/rtl/aurora/aurora_tx_guard.sv
SYN_FILES += ../../../common/src/rtl/aurora/aurora_rx_guard.sv
SYN_FILES += ../../../common/src/rtl/aurora/support_6_2500/aurora64b66b_clock_module.v
SYN_FILES += ../../../common/src/rtl/aurora/support_6_2500/aurora64b66b_gt_common_wrapper.v
SYN_FILES += ../../../common/src/rtl/aurora/support_6_2500/aurora64b66b_support_reset_logic.v


# XDC files
XDC_FILES  = ../src/xdc/ctrlnode.xdc
XDC_FILES += ../src/xdc/timing.xdc
XDC_FILES += ../../../common/src/xdc/aurora64b66b_wrp.xdc


# IP
IP_TCL_FILES  = ../src/tcl/clk_gen.tcl
IP_TCL_FILES += ../src/tcl/debug_system.tcl
IP_TCL_FILES += ../../../common/src/tcl/aurora64b66b_6_2500.tcl


# Configuration
# CONFIG_TCL_FILES = ./config.tcl


include ../../../common/vivado.mk
