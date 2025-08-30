# System clock
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {clk_100mhz_?}]
set_property PACKAGE_PIN    G27                 [get_ports {clk_100mhz_p}]
set_property PACKAGE_PIN    F27                 [get_ports {clk_100mhz_n}]
#
# DDR3 Reset
set_property SLEW           FAST                [get_ports {ddr3_reset_n}]
set_property IOSTANDARD     LVCMOS15            [get_ports {ddr3_reset_n}]
set_property PACKAGE_PIN    E20                 [get_ports {ddr3_reset_n}]
#
# DDR3 Clock
set_property SLEW           FAST                [get_ports {ddr3_ck_?[0]}]
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {ddr3_ck_?[0]}]
set_property PACKAGE_PIN    K21                 [get_ports {ddr3_ck_p[0]}]
set_property PACKAGE_PIN    J21                 [get_ports {ddr3_ck_n[0]}]
#
# DDR3 Control
set_property SLEW           FAST                [get_ports {ddr3_addr[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_addr[*]}]
set_property PACKAGE_PIN    H19                 [get_ports {ddr3_addr[0]}]
set_property PACKAGE_PIN    G20                 [get_ports {ddr3_addr[1]}]
set_property PACKAGE_PIN    H20                 [get_ports {ddr3_addr[2]}]
set_property PACKAGE_PIN    F23                 [get_ports {ddr3_addr[3]}]
set_property PACKAGE_PIN    G23                 [get_ports {ddr3_addr[4]}]
set_property PACKAGE_PIN    L18                 [get_ports {ddr3_addr[5]}]
set_property PACKAGE_PIN    J19                 [get_ports {ddr3_addr[6]}]
set_property PACKAGE_PIN    J18                 [get_ports {ddr3_addr[7]}]
set_property PACKAGE_PIN    K20                 [get_ports {ddr3_addr[8]}]
set_property PACKAGE_PIN    K19                 [get_ports {ddr3_addr[9]}]
set_property PACKAGE_PIN    H22                 [get_ports {ddr3_addr[10]}]
set_property PACKAGE_PIN    J22                 [get_ports {ddr3_addr[11]}]
set_property PACKAGE_PIN    J23                 [get_ports {ddr3_addr[12]}]
set_property PACKAGE_PIN    K23                 [get_ports {ddr3_addr[13]}]
#
set_property SLEW           FAST                [get_ports {ddr3_ba[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_ba[*]}]
set_property PACKAGE_PIN    F18                 [get_ports {ddr3_ba[0]}]
set_property PACKAGE_PIN    G18                 [get_ports {ddr3_ba[1]}]
set_property PACKAGE_PIN    G19                 [get_ports {ddr3_ba[2]}]
#
set_property SLEW           FAST                [get_ports {ddr3_cas_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cas_n}]
set_property PACKAGE_PIN    F22                 [get_ports {ddr3_cas_n}]
#
set_property SLEW           FAST                [get_ports {ddr3_cke[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cke[0]}]
set_property PACKAGE_PIN    E23                 [get_ports {ddr3_cke[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_cs_n[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cs_n[0]}]
set_property PACKAGE_PIN    F21                 [get_ports {ddr3_cs_n[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_odt[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_odt[0]}]
set_property PACKAGE_PIN    D23                 [get_ports {ddr3_odt[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_ras_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_ras_n}]
set_property PACKAGE_PIN    G22                 [get_ports {ddr3_ras_n}]
#
set_property SLEW           FAST                [get_ports {ddr3_we_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_we_n}]
set_property PACKAGE_PIN    F20                 [get_ports {ddr3_we_n}]
#
# DDR3 DQ
set_property SLEW           FAST                [get_ports {ddr3_dq[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_dq[*]}]
set_property PACKAGE_PIN    B19                 [get_ports {ddr3_dq[0]}]
set_property PACKAGE_PIN    B20                 [get_ports {ddr3_dq[1]}]
set_property PACKAGE_PIN    A20                 [get_ports {ddr3_dq[2]}]
set_property PACKAGE_PIN    A21                 [get_ports {ddr3_dq[3]}]
set_property PACKAGE_PIN    B22                 [get_ports {ddr3_dq[4]}]
set_property PACKAGE_PIN    B23                 [get_ports {ddr3_dq[5]}]
set_property PACKAGE_PIN    A22                 [get_ports {ddr3_dq[6]}]
set_property PACKAGE_PIN    A23                 [get_ports {ddr3_dq[7]}]
set_property PACKAGE_PIN    C24                 [get_ports {ddr3_dq[8]}]
set_property PACKAGE_PIN    B24                 [get_ports {ddr3_dq[9]}]
set_property PACKAGE_PIN    B25                 [get_ports {ddr3_dq[10]}]
set_property PACKAGE_PIN    A25                 [get_ports {ddr3_dq[11]}]
set_property PACKAGE_PIN    A26                 [get_ports {ddr3_dq[12]}]
set_property PACKAGE_PIN    C27                 [get_ports {ddr3_dq[13]}]
set_property PACKAGE_PIN    B27                 [get_ports {ddr3_dq[14]}]
set_property PACKAGE_PIN    D26                 [get_ports {ddr3_dq[15]}]
#
# DDR3 DQS
set_property SLEW           FAST                [get_ports {ddr3_dqs_?[*]}]
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {ddr3_dqs_?[*]}]
set_property PACKAGE_PIN    B18                 [get_ports {ddr3_dqs_p[0]}]
set_property PACKAGE_PIN    A18                 [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN    C25                 [get_ports {ddr3_dqs_p[1]}]
set_property PACKAGE_PIN    C26                 [get_ports {ddr3_dqs_n[1]}]
#
# DDR3 DM
set_property SLEW           FAST                [get_ports {ddr3_dm[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_dm[*]}]
set_property PACKAGE_PIN    C19                 [get_ports {ddr3_dm[0]}]
set_property PACKAGE_PIN    D24                 [get_ports {ddr3_dm[1]}]
#
# QSPI Flash
set_property IOSTANDARD     LVCMOS33            [get_ports {flash_*}]
set_property PACKAGE_PIN    V26                 [get_ports {flash_cs_n}]
set_property PACKAGE_PIN    R30                 [get_ports {flash_data[0]}]
set_property PACKAGE_PIN    T30                 [get_ports {flash_data[1]}]
set_property PACKAGE_PIN    R28                 [get_ports {flash_data[2]}]
set_property PACKAGE_PIN    T28                 [get_ports {flash_data[3]}]
#
# Common GT reference clock
set_property PACKAGE_PIN    U8                  [get_ports {clk_gt_156p25mhz_p}]
set_property PACKAGE_PIN    U7                  [get_ports {clk_gt_156p25mhz_n}]
#
# Downsteam ports GT RX
set_property PACKAGE_PIN    AH6                 [get_ports {dn0_rx_p[0]}]
set_property PACKAGE_PIN    AH5                 [get_ports {dn0_rx_n[0]}]
set_property PACKAGE_PIN    AG4                 [get_ports {dn0_rx_p[1]}]
set_property PACKAGE_PIN    AG3                 [get_ports {dn0_rx_n[1]}]
set_property PACKAGE_PIN    AE4                 [get_ports {dn1_rx_p[0]}]
set_property PACKAGE_PIN    AE3                 [get_ports {dn1_rx_n[0]}]
set_property PACKAGE_PIN    AC4                 [get_ports {dn1_rx_p[1]}]
set_property PACKAGE_PIN    AC3                 [get_ports {dn1_rx_n[1]}]
set_property PACKAGE_PIN    AB6                 [get_ports {dn2_rx_p[0]}]
set_property PACKAGE_PIN    AB5                 [get_ports {dn2_rx_n[0]}]
set_property PACKAGE_PIN    AA4                 [get_ports {dn2_rx_p[1]}]
set_property PACKAGE_PIN    AA3                 [get_ports {dn2_rx_n[1]}]
set_property PACKAGE_PIN    Y6                  [get_ports {dn3_rx_p[0]}]
set_property PACKAGE_PIN    Y5                  [get_ports {dn3_rx_n[0]}]
set_property PACKAGE_PIN    W4                  [get_ports {dn3_rx_p[1]}]
set_property PACKAGE_PIN    W3                  [get_ports {dn3_rx_n[1]}]
#
# Downsteam ports GT TX
set_property PACKAGE_PIN    AK6                 [get_ports {dn0_tx_p[0]}]
set_property PACKAGE_PIN    AK5                 [get_ports {dn0_tx_n[0]}]
set_property PACKAGE_PIN    AJ4                 [get_ports {dn0_tx_p[1]}]
set_property PACKAGE_PIN    AJ3                 [get_ports {dn0_tx_n[1]}]
set_property PACKAGE_PIN    AK2                 [get_ports {dn1_tx_p[0]}]
set_property PACKAGE_PIN    AK1                 [get_ports {dn1_tx_n[0]}]
set_property PACKAGE_PIN    AH2                 [get_ports {dn1_tx_p[1]}]
set_property PACKAGE_PIN    AH1                 [get_ports {dn1_tx_n[1]}]
set_property PACKAGE_PIN    AF2                 [get_ports {dn2_tx_p[0]}]
set_property PACKAGE_PIN    AF1                 [get_ports {dn2_tx_n[0]}]
set_property PACKAGE_PIN    AD2                 [get_ports {dn2_tx_p[1]}]
set_property PACKAGE_PIN    AD1                 [get_ports {dn2_tx_n[1]}]
set_property PACKAGE_PIN    AB2                 [get_ports {dn3_tx_p[0]}]
set_property PACKAGE_PIN    AB1                 [get_ports {dn3_tx_n[0]}]
set_property PACKAGE_PIN    Y2                  [get_ports {dn3_tx_p[1]}]
set_property PACKAGE_PIN    Y1                  [get_ports {dn3_tx_n[1]}]
#
# Upsteam ports GT RX
set_property PACKAGE_PIN    V6                  [get_ports {up0_rx_p[0]}]
set_property PACKAGE_PIN    V5                  [get_ports {up0_rx_n[0]}]
set_property PACKAGE_PIN    U4                  [get_ports {up0_rx_p[1]}]
set_property PACKAGE_PIN    U3                  [get_ports {up0_rx_n[1]}]
#
# Upsteam ports GT TX
set_property PACKAGE_PIN    V2                  [get_ports {up0_tx_p[0]}]
set_property PACKAGE_PIN    V1                  [get_ports {up0_tx_n[0]}]
set_property PACKAGE_PIN    T2                  [get_ports {up0_tx_p[1]}]
set_property PACKAGE_PIN    T1                  [get_ports {up0_tx_n[1]}]
#
# System reference clock
set_property IOSTANDARD     LVDS_25             [get_ports {clk_ref_?}]
set_property PACKAGE_PIN    AG24                [get_ports {clk_ref_p}]
set_property PACKAGE_PIN    AH24                [get_ports {clk_ref_n}]
#
# System synchronization
set_property IOSTANDARD     LVDS_25             [get_ports {sync_?}]
set_property PACKAGE_PIN    AG22                [get_ports {sync_p}]
set_property PACKAGE_PIN    AG23                [get_ports {sync_n}]
#
# DDS control
set_property IOSTANDARD     LVCMOS33            [get_ports {dds_*}]
set_property PACKAGE_PIN    R18                 [get_ports {dds_cs_n}]
set_property PACKAGE_PIN    R20                 [get_ports {dds_drctl}]
set_property PACKAGE_PIN    R21                 [get_ports {dds_drhold}]
set_property PACKAGE_PIN    T17                 [get_ports {dds_drover}]
set_property PACKAGE_PIN    T18                 [get_ports {dds_ext_pwr_dwn}]
set_property PACKAGE_PIN    T20                 [get_ports {dds_io_update}]
set_property PACKAGE_PIN    T21                 [get_ports {dds_master_reset}]
set_property PACKAGE_PIN    T22                 [get_ports {dds_osk}]
set_property PACKAGE_PIN    U17                 [get_ports {dds_sclk}]
set_property PACKAGE_PIN    U18                 [get_ports {dds_sdo}]
set_property PACKAGE_PIN    U19                 [get_ports {dds_syncio}]
set_property PACKAGE_PIN    U20                 [get_ports {dds_sdio}]
set_property PACKAGE_PIN    V20                 [get_ports {dds_ps[0]}]
set_property PACKAGE_PIN    W22                 [get_ports {dds_ps[1]}]
set_property PACKAGE_PIN    W23                 [get_ports {dds_ps[2]}]
#
# HMC1118 control
set_property IOSTANDARD     LVCMOS33            [get_ports {hmc1118_*}]
set_property PACKAGE_PIN    W18                 [get_ports {hmc1118_ls}]
set_property PACKAGE_PIN    W19                 [get_ports {hmc1118_vctrl}]
#
# GL interface
set_property IOSTANDARD     LVDS_25             [get_ports {gl_clk_?[?]}]
set_property IOSTANDARD     LVCMOS25            [get_ports {gl_nrst[?]}]
set_property PACKAGE_PIN    Y20                 [get_ports {gl_clk_p[0]}]
set_property PACKAGE_PIN    Y21                 [get_ports {gl_clk_n[0]}]
set_property PACKAGE_PIN    AA20                [get_ports {gl_clk_p[1]}]
set_property PACKAGE_PIN    AA21                [get_ports {gl_clk_n[1]}]
set_property PACKAGE_PIN    AB20                [get_ports {gl_clk_p[2]}]
set_property PACKAGE_PIN    AC20                [get_ports {gl_clk_n[2]}]
set_property PACKAGE_PIN    AB22                [get_ports {gl_clk_p[3]}]
set_property PACKAGE_PIN    AB23                [get_ports {gl_clk_n[3]}]
set_property PACKAGE_PIN    AD26                [get_ports {gl_nrst[0]}]
set_property PACKAGE_PIN    AE26                [get_ports {gl_nrst[1]}]
set_property PACKAGE_PIN    AH25                [get_ports {gl_nrst[2]}]
set_property PACKAGE_PIN    AH26                [get_ports {gl_nrst[3]}]
#
# PLL control
set_property IOSTANDARD     LVCMOS33            [get_ports {pll_*}]
set_property PACKAGE_PIN    U30                 [get_ports {pll_sck}]
set_property PACKAGE_PIN    U28                 [get_ports {pll_sen}]
set_property PACKAGE_PIN    U27                 [get_ports {pll_sdi}]
set_property PACKAGE_PIN    U29                 [get_ports {pll_ld_sdo}]
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