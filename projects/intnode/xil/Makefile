# SPDX-License-Identifier: BSD-2-Clause-Views
# Copyright (c) 2019-2023 The Regents of the University of California


# FPGA settings
FPGA_PART = xc7k355tffg901-1
FPGA_TOP = intnode


# Files for synthesis
SYN_FILES  = ../src/rtl/intnode.sv
SYN_FILES += ../src/rtl/upstream_unit.sv
SYN_FILES += ../src/rtl/dnstream_unit.sv
SYN_FILES += ../src/rtl/clock_unit.sv
SYN_FILES += ../src/rtl/mig7_stub.sv
SYN_FILES += ../../../common/src/rtl/aurora/aurora64b66b_wrp.sv
SYN_FILES += ../../../common/src/rtl/aurora/support_6_2500/aurora64b66b_clock_module.v
SYN_FILES += ../../../common/src/rtl/aurora/support_6_2500/aurora64b66b_gt_common_wrapper.v
SYN_FILES += ../../../common/src/rtl/aurora/support_6_2500/aurora64b66b_support_reset_logic.v


# XDC files
XDC_FILES  = ../src/xdc/intnode.xdc
XDC_FILES += ../src/xdc/timing.xdc
XDC_FILES += ../../../common/src/xdc/aurora64b66b_wrp.xdc


# IP
IP_TCL_FILES  = ../src/tcl/clk_gen.tcl
IP_TCL_FILES += ../src/tcl/mig7series.tcl
IP_TCL_FILES += ../../../common/src/tcl/aurora64b66b_6_2500.tcl


# Configuration
# CONFIG_TCL_FILES = ./config.tcl


include ../../../common/vivado.mk
