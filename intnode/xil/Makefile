# SPDX-License-Identifier: BSD-2-Clause-Views
# Copyright (c) 2019-2023 The Regents of the University of California


# FPGA settings
FPGA_PART = xc7k355tffg901-1
FPGA_TOP = intnode


# Files for synthesis
SYN_FILES = src/rtl/intnode.sv
SYN_FILES += src/rtl/upstream_unit.sv
SYN_FILES += src/rtl/dnstream_unit.sv
SYN_FILES += src/rtl/clock_unit.sv
SYN_FILES += src/rtl/mig7_stub.sv
SYN_FILES += src/rtl/aurora8b10b_ex/aurora8b10b_cdc_sync_exdes.v
SYN_FILES += src/rtl/aurora8b10b_ex/aurora8b10b_gt_common_wrapper.v
SYN_FILES += src/rtl/aurora8b10b_ex/aurora8b10b_support_reset_logic.v


# XDC files
XDC_FILES = src/xdc/intnode.xdc


# IP
IP_TCL_FILES = src/intnode-ips.tcl


# Configuration
# CONFIG_TCL_FILES = ./config.tcl


include ../../common/vivado.mk
