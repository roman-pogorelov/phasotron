# Configuration voltages
set_property CFGBVS         VCCO                [current_design]
set_property CONFIG_VOLTAGE 3.3                 [current_desig]
#
# System clock
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {clk_100mhz_?}]
set_property PACKAGE_PIN    G27                 [get_ports {clk_100mhz_p}]
set_property PACKAGE_PIN    F27                 [get_ports {clk_100mhz_n}]
#
# Common GT reference clock
set_property PACKAGE_PIN    U8                  [get_ports {clk_gt_156p25mhz_p}]
set_property PACKAGE_PIN    U7                  [get_ports {clk_gt_156p25mhz_n}]
# Upsteam ports GT RX
set_property PACKAGE_PIN    V6                  [get_ports {dn0_rx_p[0]}]
set_property PACKAGE_PIN    V5                  [get_ports {dn0_rx_n[0]}]
set_property PACKAGE_PIN    U4                  [get_ports {dn0_rx_p[1]}]
set_property PACKAGE_PIN    U3                  [get_ports {dn0_rx_n[1]}]
#
# Upsteam ports GT TX
set_property PACKAGE_PIN    V2                  [get_ports {dn0_tx_p[0]}]
set_property PACKAGE_PIN    V1                  [get_ports {dn0_tx_n[0]}]
set_property PACKAGE_PIN    T2                  [get_ports {dn0_tx_p[1]}]
set_property PACKAGE_PIN    T1                  [get_ports {dn0_tx_n[1]}]
#
# SFP control
set_property IOSTANDARD     LVCMOS33            [get_ports {sfp?_*}]
set_property PACKAGE_PIN    R26                 [get_ports {sfp0_los}]
set_property PACKAGE_PIN    V24                 [get_ports {sfp0_mod_def[0]}]
set_property PACKAGE_PIN    T23                 [get_ports {sfp0_mod_def[1]}]
set_property PACKAGE_PIN    R23                 [get_ports {sfp0_mod_def[2]}]
set_property PACKAGE_PIN    V25                 [get_ports {sfp0_rs[0]}]
set_property PACKAGE_PIN    T27                 [get_ports {sfp0_rs[1]}]
set_property PACKAGE_PIN    R25                 [get_ports {sfp0_tx_disable}]
set_property PACKAGE_PIN    R24                 [get_ports {sfp0_tx_fault}]
set_property PACKAGE_PIN    U22                 [get_ports {sfp1_los}]
set_property PACKAGE_PIN    V21                 [get_ports {sfp1_mod_def[0]}]
set_property PACKAGE_PIN    U25                 [get_ports {sfp1_mod_def[1]}]
set_property PACKAGE_PIN    U24                 [get_ports {sfp1_mod_def[2]}]
set_property PACKAGE_PIN    V22                 [get_ports {sfp1_rs[0]}]
set_property PACKAGE_PIN    U23                 [get_ports {sfp1_rs[1]}]
set_property PACKAGE_PIN    T26                 [get_ports {sfp1_tx_disable}]
set_property PACKAGE_PIN    T25                 [get_ports {sfp1_tx_fault}]