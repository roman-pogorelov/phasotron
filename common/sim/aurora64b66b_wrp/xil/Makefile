# SPDX-License-Identifier: BSD-2-Clause-Views
# Copyright (c) 2019-2023 The Regents of the University of California


# FPGA settings
FPGA_PART = xc7k355tffg901-1
FPGA_TOP = aurora64b66b_wrp


# Files for synthesis
SYN_FILES  = ../../../src/rtl/aurora/aurora64b66b_wrp.sv
SYN_FILES += ../../../src/rtl/aurora/support_6_2500/aurora64b66b_clock_module.v
SYN_FILES += ../../../src/rtl/aurora/support_6_2500/aurora64b66b_gt_common_wrapper.v
SYN_FILES += ../../../src/rtl/aurora/support_6_2500/aurora64b66b_support_reset_logic.v


# File for simulation
SIM_FILES = ../aurora64b66b_wrp_tb.sv


# XDC files
# XDC_FILES = ../src/xdc/intnode.xdc


# IP
IP_TCL_FILES = ../../../src/tcl/aurora64b66b_6_2500.tcl


# Configuration
# CONFIG_TCL_FILES = ./config.tcl


include ../../../../common/vivado.mk
