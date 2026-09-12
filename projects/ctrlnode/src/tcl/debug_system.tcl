
################################################################
# This is a generated script based on design: debug_system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source debug_system_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7k355tffg901-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name debug_system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_apb_bridge:3.0\
xilinx.com:ip:axi_fifo_mm_s:4.2\
xilinx.com:ip:axis_dwidth_converter:1.1\
xilinx.com:ip:jtag_axi:1.2\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set apb3_m [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:apb_rtl:1.0 apb3_m ]

  set axis_ctl_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_ctl_out ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {94696970} \
   ] $axis_ctl_out

  set axis_in [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 axis_in ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {94696970} \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.HAS_TREADY {1} \
   CONFIG.HAS_TSTRB {0} \
   CONFIG.LAYERED_METADATA {undef} \
   CONFIG.TDATA_NUM_BYTES {16} \
   CONFIG.TDEST_WIDTH {0} \
   CONFIG.TID_WIDTH {0} \
   CONFIG.TUSER_WIDTH {0} \
   ] $axis_in

  set axis_out [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_out ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {94696970} \
   ] $axis_out


  # Create ports
  set clk [ create_bd_port -dir I -type clk -freq_hz 94696970 clk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_RESET {rstn} \
 ] $clk
  set rstn [ create_bd_port -dir I -type rst rstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $rstn

  # Create instance: axi_apb_conv, and set properties
  set axi_apb_conv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_apb_bridge:3.0 axi_apb_conv ]
  set_property -dict [ list \
   CONFIG.C_APB_NUM_SLAVES {1} \
 ] $axi_apb_conv

  # Create instance: axi_interconn, and set properties
  set axi_interconn [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconn ]

  # Create instance: axi_stream_fifo, and set properties
  set axi_stream_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.2 axi_stream_fifo ]
  set_property -dict [ list \
   CONFIG.C_HAS_AXIS_TKEEP {true} \
 ] $axi_stream_fifo

  # Create instance: axis_dwidth_conv_in, and set properties
  set axis_dwidth_conv_in [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_conv_in ]
  set_property -dict [ list \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {4} \
   CONFIG.S_TDATA_NUM_BYTES {16} \
 ] $axis_dwidth_conv_in

  # Create instance: axis_dwidth_conv_out, and set properties
  set axis_dwidth_conv_out [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_dwidth_converter:1.1 axis_dwidth_conv_out ]
  set_property -dict [ list \
   CONFIG.HAS_MI_TKEEP {1} \
   CONFIG.HAS_TKEEP {1} \
   CONFIG.HAS_TLAST {1} \
   CONFIG.M_TDATA_NUM_BYTES {16} \
   CONFIG.S_TDATA_NUM_BYTES {4} \
 ] $axis_dwidth_conv_out

  # Create instance: jtag_axi_bridge, and set properties
  set jtag_axi_bridge [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_bridge ]
  set_property -dict [ list \
   CONFIG.PROTOCOL {2} \
 ] $jtag_axi_bridge

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins axi_interconn/S00_AXI] [get_bd_intf_pins jtag_axi_bridge/M_AXI]
  connect_bd_intf_net -intf_net S_AXIS_0_1 [get_bd_intf_ports axis_in] [get_bd_intf_pins axis_dwidth_conv_in/S_AXIS]
  connect_bd_intf_net -intf_net axi_apb_bridge_0_APB_M [get_bd_intf_ports apb3_m] [get_bd_intf_pins axi_apb_conv/APB_M]
  connect_bd_intf_net -intf_net axi_fifo_mm_s_0_AXI_STR_TXC [get_bd_intf_ports axis_ctl_out] [get_bd_intf_pins axi_stream_fifo/AXI_STR_TXC]
  connect_bd_intf_net -intf_net axi_fifo_mm_s_0_AXI_STR_TXD [get_bd_intf_pins axi_stream_fifo/AXI_STR_TXD] [get_bd_intf_pins axis_dwidth_conv_out/S_AXIS]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconn/M00_AXI] [get_bd_intf_pins axi_stream_fifo/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_apb_conv/AXI4_LITE] [get_bd_intf_pins axi_interconn/M01_AXI]
  connect_bd_intf_net -intf_net axis_dwidth_converter_0_M_AXIS [get_bd_intf_ports axis_out] [get_bd_intf_pins axis_dwidth_conv_out/M_AXIS]
  connect_bd_intf_net -intf_net axis_dwidth_converter_1_M_AXIS [get_bd_intf_pins axi_stream_fifo/AXI_STR_RXD] [get_bd_intf_pins axis_dwidth_conv_in/M_AXIS]

  # Create port connections
  connect_bd_net -net ACLK_0_1 [get_bd_ports clk] [get_bd_pins axi_apb_conv/s_axi_aclk] [get_bd_pins axi_interconn/ACLK] [get_bd_pins axi_interconn/M00_ACLK] [get_bd_pins axi_interconn/M01_ACLK] [get_bd_pins axi_interconn/S00_ACLK] [get_bd_pins axi_stream_fifo/s_axi_aclk] [get_bd_pins axis_dwidth_conv_in/aclk] [get_bd_pins axis_dwidth_conv_out/aclk] [get_bd_pins jtag_axi_bridge/aclk]
  connect_bd_net -net ARESETN_0_1 [get_bd_ports rstn] [get_bd_pins axi_apb_conv/s_axi_aresetn] [get_bd_pins axi_interconn/ARESETN] [get_bd_pins axi_interconn/M00_ARESETN] [get_bd_pins axi_interconn/M01_ARESETN] [get_bd_pins axi_interconn/S00_ARESETN] [get_bd_pins axi_stream_fifo/s_axi_aresetn] [get_bd_pins axis_dwidth_conv_in/aresetn] [get_bd_pins axis_dwidth_conv_out/aresetn] [get_bd_pins jtag_axi_bridge/aresetn]

  # Create address segments
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_bridge/Data] [get_bd_addr_segs apb3_m/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_bridge/Data] [get_bd_addr_segs axi_stream_fifo/S_AXI/Mem0] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


