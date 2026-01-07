##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2021.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source intnode-ips.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./xil/intnode.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project intnode xil -part xc7k355tffg901-1
  set_property target_language Verilog [current_project]
  set_property simulator_language Mixed [current_project]
}

##################################################################
# CHECK IPs
##################################################################

set bCheckIPs 1
set bCheckIPsPassed 1
if { $bCheckIPs == 1 } {
  set list_check_ips { xilinx.com:ip:aurora_8b10b:11.1 xilinx.com:ip:clk_wiz:6.0 xilinx.com:ip:mig_7series:4.2 }
  set list_ips_missing ""
  common::send_msg_id "IPS_TCL-1001" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

  foreach ip_vlnv $list_check_ips {
  set ip_obj [get_ipdefs -all $ip_vlnv]
  if { $ip_obj eq "" } {
    lappend list_ips_missing $ip_vlnv
    }
  }

  if { $list_ips_missing ne "" } {
    catch {common::send_msg_id "IPS_TCL-105" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
    set bCheckIPsPassed 0
  }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "IPS_TCL-102" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 1
}

##################################################################
# CREATE IP aurora8b10b
##################################################################

set aurora8b10b [create_ip -name aurora_8b10b -vendor xilinx.com -library ip -version 11.1 -module_name aurora8b10b]

set_property -dict { 
  CONFIG.C_AURORA_LANES {2}
  CONFIG.C_LANE_WIDTH {4}
  CONFIG.C_LINE_RATE {6.250}
  CONFIG.C_REFCLK_FREQUENCY {156.250}
  CONFIG.C_INIT_CLK {100.0}
  CONFIG.DRP_FREQ {100.0000}
  CONFIG.Interface_Mode {Streaming}
  CONFIG.C_GT_LOC_2 {2}
  CONFIG.C_GT_LOC_1 {1}
  CONFIG.C_USE_BYTESWAP {true}
} [get_ips aurora8b10b]

set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $aurora8b10b

##################################################################

##################################################################
# CREATE IP clk_gen
##################################################################

set clk_gen [create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_gen]

set_property -dict { 
  CONFIG.CLKOUT2_USED {true}
  CONFIG.CLKOUT3_USED {true}
  CONFIG.NUM_OUT_CLKS {3}
  CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000}
  CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {400.000}
  CONFIG.PRIM_SOURCE {Differential_clock_capable_pin}
  CONFIG.CLKOUT1_DRIVES {BUFGCE}
  CONFIG.CLKOUT2_DRIVES {BUFGCE}
  CONFIG.CLKOUT3_DRIVES {BUFGCE}
  CONFIG.CLKOUT4_DRIVES {BUFGCE}
  CONFIG.CLKOUT5_DRIVES {BUFGCE}
  CONFIG.CLKOUT6_DRIVES {BUFGCE}
  CONFIG.CLKOUT7_DRIVES {BUFGCE}
  CONFIG.FEEDBACK_SOURCE {FDBK_AUTO}
  CONFIG.USE_RESET {false}
  CONFIG.MMCM_CLKFBOUT_MULT_F {8.000}
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000}
  CONFIG.MMCM_CLKOUT1_DIVIDE {4}
  CONFIG.MMCM_CLKOUT2_DIVIDE {2}
  CONFIG.USE_SAFE_CLOCK_STARTUP {true}
  CONFIG.CLKOUT1_JITTER {144.719}
  CONFIG.CLKOUT1_PHASE_ERROR {114.212}
  CONFIG.CLKOUT2_JITTER {126.455}
  CONFIG.CLKOUT2_PHASE_ERROR {114.212}
  CONFIG.CLKOUT3_JITTER {111.164}
  CONFIG.CLKOUT3_PHASE_ERROR {114.212}
} [get_ips clk_gen]

set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $clk_gen

##################################################################

##################################################################
# mig7series FILES
##################################################################

proc write_mig_7series_mig_b { mig_7series_mig_b_filepath } {
  set mig_7series_mig_b [open $mig_7series_mig_b_filepath  w+]

  puts $mig_7series_mig_b {﻿<?xml version="1.0" encoding="UTF-8" standalone="no" ?>}
  puts $mig_7series_mig_b {<Project NoOfControllers="1">}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  }
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {<!-- IMPORTANT: This is an internal file that has been generated by the MIG software. Any direct editing or changes made to this file may result in unpredictable behavior or data corruption. It is strongly advised that users do not edit the contents of this file. Re-run the MIG GUI with the required settings if any of the options provided below need to be altered. -->}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <ModuleName>mig7series</ModuleName>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <dci_inouts_inputs>1</dci_inouts_inputs>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <dci_inputs>1</dci_inputs>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <Debug_En>OFF</Debug_En>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <DataDepth_En>1024</DataDepth_En>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <LowPower_En>ON</LowPower_En>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <XADC_En>Enabled</XADC_En>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <TargetFPGA>xc7k355t-ffg901/-1</TargetFPGA>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <Version>4.2</Version>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <SystemClock>No Buffer</SystemClock>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <ReferenceClock>No Buffer</ReferenceClock>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <SysResetPolarity>ACTIVE HIGH</SysResetPolarity>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <BankSelectionFlag>FALSE</BankSelectionFlag>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <InternalVref>0</InternalVref>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <dci_hr_inouts_inputs>50 Ohms</dci_hr_inouts_inputs>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <dci_cascade>0</dci_cascade>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {  <Controller number="0">}
  puts $mig_7series_mig_b {    <MemoryDevice>DDR3_SDRAM/Components/MT41J128M16XX-125</MemoryDevice>}
  puts $mig_7series_mig_b {    <TimePeriod>2500</TimePeriod>}
  puts $mig_7series_mig_b {    <VccAuxIO>1.8V</VccAuxIO>}
  puts $mig_7series_mig_b {    <PHYRatio>4:1</PHYRatio>}
  puts $mig_7series_mig_b {    <InputClkFreq>400</InputClkFreq>}
  puts $mig_7series_mig_b {    <UIExtraClocks>0</UIExtraClocks>}
  puts $mig_7series_mig_b {    <MMCM_VCO>800</MMCM_VCO>}
  puts $mig_7series_mig_b {    <MMCMClkOut0> 1.000</MMCMClkOut0>}
  puts $mig_7series_mig_b {    <MMCMClkOut1>1</MMCMClkOut1>}
  puts $mig_7series_mig_b {    <MMCMClkOut2>1</MMCMClkOut2>}
  puts $mig_7series_mig_b {    <MMCMClkOut3>1</MMCMClkOut3>}
  puts $mig_7series_mig_b {    <MMCMClkOut4>1</MMCMClkOut4>}
  puts $mig_7series_mig_b {    <DataWidth>16</DataWidth>}
  puts $mig_7series_mig_b {    <DeepMemory>1</DeepMemory>}
  puts $mig_7series_mig_b {    <DataMask>1</DataMask>}
  puts $mig_7series_mig_b {    <ECC>Disabled</ECC>}
  puts $mig_7series_mig_b {    <Ordering>Normal</Ordering>}
  puts $mig_7series_mig_b {    <BankMachineCnt>8</BankMachineCnt>}
  puts $mig_7series_mig_b {    <CustomPart>FALSE</CustomPart>}
  puts $mig_7series_mig_b {    <NewPartName/>}
  puts $mig_7series_mig_b {    <RowAddress>14</RowAddress>}
  puts $mig_7series_mig_b {    <ColAddress>10</ColAddress>}
  puts $mig_7series_mig_b {    <BankAddress>3</BankAddress>}
  puts $mig_7series_mig_b {    <MemoryVoltage>1.5V</MemoryVoltage>}
  puts $mig_7series_mig_b {    <UserMemoryAddressMap>BANK_ROW_COLUMN</UserMemoryAddressMap>}
  puts $mig_7series_mig_b {    <PinSelection>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="H19" SLEW="" VCCAUX_IO="" name="ddr3_addr[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="H22" SLEW="" VCCAUX_IO="" name="ddr3_addr[10]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="J22" SLEW="" VCCAUX_IO="" name="ddr3_addr[11]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="J23" SLEW="" VCCAUX_IO="" name="ddr3_addr[12]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="K23" SLEW="" VCCAUX_IO="" name="ddr3_addr[13]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="G20" SLEW="" VCCAUX_IO="" name="ddr3_addr[1]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="H20" SLEW="" VCCAUX_IO="" name="ddr3_addr[2]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="F23" SLEW="" VCCAUX_IO="" name="ddr3_addr[3]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="G23" SLEW="" VCCAUX_IO="" name="ddr3_addr[4]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="L18" SLEW="" VCCAUX_IO="" name="ddr3_addr[5]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="J19" SLEW="" VCCAUX_IO="" name="ddr3_addr[6]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="J18" SLEW="" VCCAUX_IO="" name="ddr3_addr[7]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="K20" SLEW="" VCCAUX_IO="" name="ddr3_addr[8]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="K19" SLEW="" VCCAUX_IO="" name="ddr3_addr[9]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="F18" SLEW="" VCCAUX_IO="" name="ddr3_ba[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="G18" SLEW="" VCCAUX_IO="" name="ddr3_ba[1]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="G19" SLEW="" VCCAUX_IO="" name="ddr3_ba[2]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="F22" SLEW="" VCCAUX_IO="" name="ddr3_cas_n"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="J21" SLEW="" VCCAUX_IO="" name="ddr3_ck_n[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="K21" SLEW="" VCCAUX_IO="" name="ddr3_ck_p[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="E23" SLEW="" VCCAUX_IO="" name="ddr3_cke[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="F21" SLEW="" VCCAUX_IO="" name="ddr3_cs_n[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="C19" SLEW="" VCCAUX_IO="" name="ddr3_dm[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="D24" SLEW="" VCCAUX_IO="" name="ddr3_dm[1]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="B19" SLEW="" VCCAUX_IO="" name="ddr3_dq[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="B25" SLEW="" VCCAUX_IO="" name="ddr3_dq[10]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="A25" SLEW="" VCCAUX_IO="" name="ddr3_dq[11]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="A26" SLEW="" VCCAUX_IO="" name="ddr3_dq[12]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="C27" SLEW="" VCCAUX_IO="" name="ddr3_dq[13]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="B27" SLEW="" VCCAUX_IO="" name="ddr3_dq[14]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="D26" SLEW="" VCCAUX_IO="" name="ddr3_dq[15]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="B20" SLEW="" VCCAUX_IO="" name="ddr3_dq[1]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="A20" SLEW="" VCCAUX_IO="" name="ddr3_dq[2]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="A21" SLEW="" VCCAUX_IO="" name="ddr3_dq[3]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="B22" SLEW="" VCCAUX_IO="" name="ddr3_dq[4]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="B23" SLEW="" VCCAUX_IO="" name="ddr3_dq[5]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="A22" SLEW="" VCCAUX_IO="" name="ddr3_dq[6]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="A23" SLEW="" VCCAUX_IO="" name="ddr3_dq[7]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="C24" SLEW="" VCCAUX_IO="" name="ddr3_dq[8]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="B24" SLEW="" VCCAUX_IO="" name="ddr3_dq[9]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="A18" SLEW="" VCCAUX_IO="" name="ddr3_dqs_n[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="C26" SLEW="" VCCAUX_IO="" name="ddr3_dqs_n[1]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="B18" SLEW="" VCCAUX_IO="" name="ddr3_dqs_p[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="C25" SLEW="" VCCAUX_IO="" name="ddr3_dqs_p[1]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="D23" SLEW="" VCCAUX_IO="" name="ddr3_odt[0]"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="G22" SLEW="" VCCAUX_IO="" name="ddr3_ras_n"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="E20" SLEW="" VCCAUX_IO="" name="ddr3_reset_n"/>}
  puts $mig_7series_mig_b {      <Pin IN_TERM="" IOSTANDARD="" PADName="F20" SLEW="" VCCAUX_IO="" name="ddr3_we_n"/>}
  puts $mig_7series_mig_b {    </PinSelection>}
  puts $mig_7series_mig_b {    <System_Control>}
  puts $mig_7series_mig_b {      <Pin Bank="Select Bank" PADName="No connect" name="sys_rst"/>}
  puts $mig_7series_mig_b {      <Pin Bank="Select Bank" PADName="No connect" name="init_calib_complete"/>}
  puts $mig_7series_mig_b {      <Pin Bank="Select Bank" PADName="No connect" name="tg_compare_error"/>}
  puts $mig_7series_mig_b {    </System_Control>}
  puts $mig_7series_mig_b {    <TimingParameters>}
  puts $mig_7series_mig_b {      <Parameters tcke="5" tfaw="40" tras="35" trcd="13.75" trefi="7.8" trfc="160" trp="13.75" trrd="7.5" trtp="7.5" twtr="7.5"/>}
  puts $mig_7series_mig_b {    </TimingParameters>}
  puts $mig_7series_mig_b {    <mrBurstLength name="Burst Length">8 - Fixed</mrBurstLength>}
  puts $mig_7series_mig_b {    <mrBurstType name="Read Burst Type and Length">Sequential</mrBurstType>}
  puts $mig_7series_mig_b {    <mrCasLatency name="CAS Latency">6</mrCasLatency>}
  puts $mig_7series_mig_b {    <mrMode name="Mode">Normal</mrMode>}
  puts $mig_7series_mig_b {    <mrDllReset name="DLL Reset">No</mrDllReset>}
  puts $mig_7series_mig_b {    <mrPdMode name="DLL control for precharge PD">Slow Exit</mrPdMode>}
  puts $mig_7series_mig_b {    <emrDllEnable name="DLL Enable">Enable</emrDllEnable>}
  puts $mig_7series_mig_b {    <emrOutputDriveStrength name="Output Driver Impedance Control">RZQ/7</emrOutputDriveStrength>}
  puts $mig_7series_mig_b {    <emrMirrorSelection name="Address Mirroring">Disable</emrMirrorSelection>}
  puts $mig_7series_mig_b {    <emrCSSelection name="Controller Chip Select Pin">Enable</emrCSSelection>}
  puts $mig_7series_mig_b {    <emrRTT name="RTT (nominal) - On Die Termination (ODT)">RZQ/4</emrRTT>}
  puts $mig_7series_mig_b {    <emrPosted name="Additive Latency (AL)">0</emrPosted>}
  puts $mig_7series_mig_b {    <emrOCD name="Write Leveling Enable">Disabled</emrOCD>}
  puts $mig_7series_mig_b {    <emrDQS name="TDQS enable">Enabled</emrDQS>}
  puts $mig_7series_mig_b {    <emrRDQS name="Qoff">Output Buffer Enabled</emrRDQS>}
  puts $mig_7series_mig_b {    <mr2PartialArraySelfRefresh name="Partial-Array Self Refresh">Full Array</mr2PartialArraySelfRefresh>}
  puts $mig_7series_mig_b {    <mr2CasWriteLatency name="CAS write latency">5</mr2CasWriteLatency>}
  puts $mig_7series_mig_b {    <mr2AutoSelfRefresh name="Auto Self Refresh">Enabled</mr2AutoSelfRefresh>}
  puts $mig_7series_mig_b {    <mr2SelfRefreshTempRange name="High Temparature Self Refresh Rate">Normal</mr2SelfRefreshTempRange>}
  puts $mig_7series_mig_b {    <mr2RTTWR name="RTT_WR - Dynamic On Die Termination (ODT)">Dynamic ODT off</mr2RTTWR>}
  puts $mig_7series_mig_b {    <PortInterface>NATIVE</PortInterface>}
  puts $mig_7series_mig_b {  </Controller>}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {}
  puts $mig_7series_mig_b {</Project>}

  flush $mig_7series_mig_b
  close $mig_7series_mig_b
}

##################################################################
# CREATE IP mig7series
##################################################################

set mig7series [create_ip -name mig_7series -vendor xilinx.com -library ip -version 4.2 -module_name mig7series]

write_mig_7series_mig_b  [file join [get_property IP_DIR [get_ips mig7series]] mig_b.prj]
set_property -dict { 
  CONFIG.XML_INPUT_FILE {mig_b.prj}
  CONFIG.RESET_BOARD_INTERFACE {Custom}
  CONFIG.MIG_DONT_TOUCH_PARAM {Custom}
  CONFIG.BOARD_MIG_PARAM {Custom}
  CONFIG.SYSTEM_RESET.INSERT_VIP {0}
  CONFIG.CLK_REF_I.INSERT_VIP {0}
  CONFIG.RESET.INSERT_VIP {0}
  CONFIG.DDR3_RESET.INSERT_VIP {0}
  CONFIG.DDR2_RESET.INSERT_VIP {0}
  CONFIG.LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.RLDII_RESET.INSERT_VIP {0}
  CONFIG.RLDIII_RESET.INSERT_VIP {0}
  CONFIG.CLOCK.INSERT_VIP {0}
  CONFIG.MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S_AXI.INSERT_VIP {0}
  CONFIG.SYS_CLK_I.INSERT_VIP {0}
  CONFIG.ARESETN.INSERT_VIP {0}
  CONFIG.C0_RESET.INSERT_VIP {0}
  CONFIG.C0_DDR3_RESET.INSERT_VIP {0}
  CONFIG.C0_DDR2_RESET.INSERT_VIP {0}
  CONFIG.C0_LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.C0_QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.C0_RLDII_RESET.INSERT_VIP {0}
  CONFIG.C0_RLDIII_RESET.INSERT_VIP {0}
  CONFIG.C0_CLOCK.INSERT_VIP {0}
  CONFIG.C0_MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.C0_MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.C0_MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.C0_MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.C0_MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S0_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S0_AXI.INSERT_VIP {0}
  CONFIG.C0_SYS_CLK_I.INSERT_VIP {0}
  CONFIG.C0_ARESETN.INSERT_VIP {0}
  CONFIG.C1_RESET.INSERT_VIP {0}
  CONFIG.C1_DDR3_RESET.INSERT_VIP {0}
  CONFIG.C1_DDR2_RESET.INSERT_VIP {0}
  CONFIG.C1_LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.C1_QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.C1_RLDII_RESET.INSERT_VIP {0}
  CONFIG.C1_RLDIII_RESET.INSERT_VIP {0}
  CONFIG.C1_CLOCK.INSERT_VIP {0}
  CONFIG.C1_MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.C1_MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.C1_MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.C1_MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.C1_MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S1_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S1_AXI.INSERT_VIP {0}
  CONFIG.C1_SYS_CLK_I.INSERT_VIP {0}
  CONFIG.C1_ARESETN.INSERT_VIP {0}
  CONFIG.C2_RESET.INSERT_VIP {0}
  CONFIG.C2_DDR3_RESET.INSERT_VIP {0}
  CONFIG.C2_DDR2_RESET.INSERT_VIP {0}
  CONFIG.C2_LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.C2_QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.C2_RLDII_RESET.INSERT_VIP {0}
  CONFIG.C2_RLDIII_RESET.INSERT_VIP {0}
  CONFIG.C2_CLOCK.INSERT_VIP {0}
  CONFIG.C2_MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.C2_MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.C2_MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.C2_MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.C2_MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S2_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S2_AXI.INSERT_VIP {0}
  CONFIG.C2_SYS_CLK_I.INSERT_VIP {0}
  CONFIG.C2_ARESETN.INSERT_VIP {0}
  CONFIG.C3_RESET.INSERT_VIP {0}
  CONFIG.C3_DDR3_RESET.INSERT_VIP {0}
  CONFIG.C3_DDR2_RESET.INSERT_VIP {0}
  CONFIG.C3_LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.C3_QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.C3_RLDII_RESET.INSERT_VIP {0}
  CONFIG.C3_RLDIII_RESET.INSERT_VIP {0}
  CONFIG.C3_CLOCK.INSERT_VIP {0}
  CONFIG.C3_MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.C3_MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.C3_MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.C3_MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.C3_MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S3_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S3_AXI.INSERT_VIP {0}
  CONFIG.C3_SYS_CLK_I.INSERT_VIP {0}
  CONFIG.C3_ARESETN.INSERT_VIP {0}
  CONFIG.C4_RESET.INSERT_VIP {0}
  CONFIG.C4_DDR3_RESET.INSERT_VIP {0}
  CONFIG.C4_DDR2_RESET.INSERT_VIP {0}
  CONFIG.C4_LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.C4_QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.C4_RLDII_RESET.INSERT_VIP {0}
  CONFIG.C4_RLDIII_RESET.INSERT_VIP {0}
  CONFIG.C4_CLOCK.INSERT_VIP {0}
  CONFIG.C4_MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.C4_MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.C4_MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.C4_MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.C4_MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S4_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S4_AXI.INSERT_VIP {0}
  CONFIG.C4_SYS_CLK_I.INSERT_VIP {0}
  CONFIG.C4_ARESETN.INSERT_VIP {0}
  CONFIG.C5_RESET.INSERT_VIP {0}
  CONFIG.C5_DDR3_RESET.INSERT_VIP {0}
  CONFIG.C5_DDR2_RESET.INSERT_VIP {0}
  CONFIG.C5_LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.C5_QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.C5_RLDII_RESET.INSERT_VIP {0}
  CONFIG.C5_RLDIII_RESET.INSERT_VIP {0}
  CONFIG.C5_CLOCK.INSERT_VIP {0}
  CONFIG.C5_MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.C5_MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.C5_MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.C5_MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.C5_MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S5_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S5_AXI.INSERT_VIP {0}
  CONFIG.C5_SYS_CLK_I.INSERT_VIP {0}
  CONFIG.C5_ARESETN.INSERT_VIP {0}
  CONFIG.C6_RESET.INSERT_VIP {0}
  CONFIG.C6_DDR3_RESET.INSERT_VIP {0}
  CONFIG.C6_DDR2_RESET.INSERT_VIP {0}
  CONFIG.C6_LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.C6_QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.C6_RLDII_RESET.INSERT_VIP {0}
  CONFIG.C6_RLDIII_RESET.INSERT_VIP {0}
  CONFIG.C6_CLOCK.INSERT_VIP {0}
  CONFIG.C6_MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.C6_MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.C6_MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.C6_MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.C6_MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S6_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S6_AXI.INSERT_VIP {0}
  CONFIG.C6_SYS_CLK_I.INSERT_VIP {0}
  CONFIG.C6_ARESETN.INSERT_VIP {0}
  CONFIG.C7_RESET.INSERT_VIP {0}
  CONFIG.C7_DDR3_RESET.INSERT_VIP {0}
  CONFIG.C7_DDR2_RESET.INSERT_VIP {0}
  CONFIG.C7_LPDDR2_RESET.INSERT_VIP {0}
  CONFIG.C7_QDRIIP_RESET.INSERT_VIP {0}
  CONFIG.C7_RLDII_RESET.INSERT_VIP {0}
  CONFIG.C7_RLDIII_RESET.INSERT_VIP {0}
  CONFIG.C7_CLOCK.INSERT_VIP {0}
  CONFIG.C7_MMCM_CLKOUT0.INSERT_VIP {0}
  CONFIG.C7_MMCM_CLKOUT1.INSERT_VIP {0}
  CONFIG.C7_MMCM_CLKOUT2.INSERT_VIP {0}
  CONFIG.C7_MMCM_CLKOUT3.INSERT_VIP {0}
  CONFIG.C7_MMCM_CLKOUT4.INSERT_VIP {0}
  CONFIG.S7_AXI_CTRL.INSERT_VIP {0}
  CONFIG.S7_AXI.INSERT_VIP {0}
  CONFIG.C7_SYS_CLK_I.INSERT_VIP {0}
  CONFIG.C7_ARESETN.INSERT_VIP {0}
} [get_ips mig7series]

set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $mig7series

##################################################################

