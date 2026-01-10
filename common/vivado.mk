###################################################################
#
# Xilinx Vivado FPGA Makefile
#
# Copyright (c) 2016 Alex Forencich
#
###################################################################
#
# Parameters:
# FPGA_TOP - Top module name
# FPGA_FAMILY - FPGA family (e.g. VirtexUltrascale)
# FPGA_DEVICE - FPGA device (e.g. xcvu095-ffva2104-2-e)
# SYN_FILES - space-separated list of source files
# INC_FILES - space-separated list of include files
# XDC_FILES - space-separated list of timing constraint files
# XCI_FILES - space-separated list of IP XCI files
#
# Example:
#
# FPGA_TOP = fpga
# FPGA_FAMILY = VirtexUltrascale
# FPGA_DEVICE = xcvu095-ffva2104-2-e
# SYN_FILES = rtl/fpga.v
# XDC_FILES = fpga.xdc
# XCI_FILES = ip/pcspma.xci
# include ../common/vivado.mk
#
###################################################################

# phony targets
.PHONY: fpga vivado tmpclean clean

# prevent make from deleting intermediate files and reports
.PRECIOUS: %.xpr %.bit %.mcs %.prm
.SECONDARY:

CONFIG ?= config.mk
-include ../$(CONFIG)

FPGA_TOP ?= fpga
PROJECT ?= $(FPGA_TOP)

# directory created by Vivado for some reason
IP_GEN_DIR = ../../$(PROJECT).gen

# Color codes for "echo"
BLACK = \033[0;30m
DARK_GRAY = \033[1;30m
RED = \033[0;31m
LIGHT_RED = \033[1;31m
GREEN = \033[0;32m
LIGHT_GREEN = \033[1;32m
ORANGE = \033[0;33m
YELLOW = \033[1;33m
BLUE = \033[0;34m
LIGHT_BLUE = \033[1;34m
PURPLE = \033[0;35m
LIGHT_PURPLE = \033[1;35m
CYAN = \033[0;36m
LIGHT_CYAN = \033[1;36m
LIGHT_GRAY = \033[0;37m
WHITE = \033[1;37m
RESET = \033[0m

###################################################################
# Main Targets
#
# all: build everything
# clean: remove output files and project files
###################################################################

all: fpga

fpga: $(PROJECT).bit

vivado: $(PROJECT).xpr
	@echo "$(LIGHT_BLUE)\nOpening Vivado project...\n$(RESET)"
	vivado $(PROJECT).xpr

tmpclean::
	@-rm -rf *.log *.jou *.cache *.gen *.hbs *.hw *.ip_user_files *.runs *.xpr *.html *.xml *.sim *.srcs *.str .Xil
	@-rm -rf create_project.tcl update_config.tcl run_synth.tcl run_impl.tcl generate_bit.tcl
	@-rm -rf $(IP_GEN_DIR)

clean:: tmpclean
	@-rm -rf *.bit *.ltx program.tcl generate_mcs.tcl *.mcs *.prm flash.tcl
	@-rm -rf *_utilization.rpt *_utilization_hierarchical.rpt

###################################################################
# Target implementations
###################################################################

# Vivado project file
create_project.tcl: Makefile $(XCI_FILES) $(IP_TCL_FILES)
	@echo "create_project -force -part $(FPGA_PART) $(PROJECT)" > $@
	@if [ ! -z "$(SYN_FILES)" ]; then echo "add_files -fileset sources_1 $(SYN_FILES)" >> $@; fi
	@if [ ! -z "$(SIM_FILES)" ]; then echo "add_files -fileset sim_1 $(SIM_FILES)" >> $@; fi
	@echo "set_property top $(FPGA_TOP) [current_fileset]" >> $@
	@if [ ! -z "$(XDC_FILES)" ]; then echo "add_files -fileset constrs_1 $(XDC_FILES)" >> $@; fi
	@for x in $(XCI_FILES); do echo "import_ip $$x" >> $@; done
	@for x in $(IP_TCL_FILES); do echo "source $$x" >> $@; done
	@for x in $(CONFIG_TCL_FILES); do echo "source $$x" >> $@; done

update_config.tcl: $(CONFIG_TCL_FILES) $(SYN_FILES) $(INC_FILES) $(XDC_FILES)
	@echo "open_project -quiet $(PROJECT).xpr" > $@
	@for x in $(CONFIG_TCL_FILES); do echo "source $$x" >> $@; done

$(PROJECT).xpr: create_project.tcl update_config.tcl
	@echo "$(LIGHT_BLUE)\nGenerating Vivado project...\n$(RESET)"
	vivado -nojournal -nolog -mode batch $(foreach x,$?,-source $x)

# synthesis run
$(PROJECT).runs/synth_1/$(PROJECT).dcp: create_project.tcl update_config.tcl $(SYN_FILES) $(INC_FILES) $(XDC_FILES) | $(PROJECT).xpr
	@echo "$(LIGHT_BLUE)\nRunning synthesis...\n$(RESET)"
	@echo "open_project $(PROJECT).xpr" > run_synth.tcl
	@echo "reset_run synth_1" >> run_synth.tcl
	@echo "launch_runs -jobs 4 synth_1" >> run_synth.tcl
	@echo "wait_on_run synth_1" >> run_synth.tcl
	vivado -nojournal -nolog -mode batch -source run_synth.tcl
	@if [ -e $(IP_GEN_DIR) ]; then rm -rf $(IP_GEN_DIR); fi

# implementation run
$(PROJECT).runs/impl_1/$(PROJECT)_routed.dcp: $(PROJECT).runs/synth_1/$(PROJECT).dcp
	@echo "$(LIGHT_BLUE)\nRunning implementation...\n$(RESET)"
	@echo "open_project $(PROJECT).xpr" > run_impl.tcl
	@echo "reset_run impl_1" >> run_impl.tcl
	@echo "launch_runs -jobs 4 impl_1" >> run_impl.tcl
	@echo "wait_on_run impl_1" >> run_impl.tcl
	@echo "open_run impl_1" >> run_impl.tcl
	@echo "report_utilization -file $(PROJECT)_utilization.rpt" >> run_impl.tcl
	@echo "report_utilization -hierarchical -file $(PROJECT)_utilization_hierarchical.rpt" >> run_impl.tcl
	vivado -nojournal -nolog -mode batch -source run_impl.tcl
	@if [ -e $(IP_GEN_DIR) ]; then rm -rf $(IP_GEN_DIR); fi

# bit file
$(PROJECT).bit $(PROJECT).ltx: $(PROJECT).runs/impl_1/$(PROJECT)_routed.dcp
	@echo "$(LIGHT_BLUE)\nGenerating bitstream...\n$(RESET)"
	@echo "open_project $(PROJECT).xpr" > generate_bit.tcl
	@echo "open_run impl_1" >> generate_bit.tcl
	@echo "write_bitstream -force $(PROJECT).runs/impl_1/$(PROJECT).bit" >> generate_bit.tcl
	@echo "write_debug_probes -force $(PROJECT).runs/impl_1/$(PROJECT).ltx" >> generate_bit.tcl
	vivado -nojournal -nolog -mode batch -source generate_bit.tcl