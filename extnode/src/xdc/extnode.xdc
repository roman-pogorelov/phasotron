# System clock
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {clk_100mhz_?}]
set_property PACKAGE_PIN    D27                 [get_ports {clk_100mhz_p}]
set_property PACKAGE_PIN    C27                 [get_ports {clk_100mhz_n}]
#
# DDR3 Reset
set_property SLEW           FAST                [get_ports {ddr3_reset_n}]
set_property IOSTANDARD     LVCMOS15            [get_ports {ddr3_reset_n}]
set_property PACKAGE_PIN    C17                 [get_ports {ddr3_reset_n}]
#
# DDR3 Clock
set_property SLEW           FAST                [get_ports {ddr3_ck_?[0]}]
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {ddr3_ck_?[0]}]
set_property PACKAGE_PIN    J17                 [get_ports {ddr3_ck_p[0]}]
set_property PACKAGE_PIN    H17                 [get_ports {ddr3_ck_n[0]}]
#
# DDR3 Control
set_property SLEW           FAST                [get_ports {ddr3_addr[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_addr[*]}]
set_property PACKAGE_PIN    G22                 [get_ports {ddr3_addr[0]}]
set_property PACKAGE_PIN    C21                 [get_ports {ddr3_addr[1]}]
set_property PACKAGE_PIN    D21                 [get_ports {ddr3_addr[2]}]
set_property PACKAGE_PIN    H22                 [get_ports {ddr3_addr[3]}]
set_property PACKAGE_PIN    H21                 [get_ports {ddr3_addr[4]}]
set_property PACKAGE_PIN    K19                 [get_ports {ddr3_addr[5]}]
set_property PACKAGE_PIN    L18                 [get_ports {ddr3_addr[6]}]
set_property PACKAGE_PIN    L17                 [get_ports {ddr3_addr[7]}]
set_property PACKAGE_PIN    H19                 [get_ports {ddr3_addr[8]}]
set_property PACKAGE_PIN    J19                 [get_ports {ddr3_addr[9]}]
set_property PACKAGE_PIN    G20                 [get_ports {ddr3_addr[10]}]
set_property PACKAGE_PIN    H20                 [get_ports {ddr3_addr[11]}]
set_property PACKAGE_PIN    J18                 [get_ports {ddr3_addr[12]}]
set_property PACKAGE_PIN    K18                 [get_ports {ddr3_addr[13]}]
#
set_property SLEW           FAST                [get_ports {ddr3_ba[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_ba[*]}]
set_property PACKAGE_PIN    C22                 [get_ports {ddr3_ba[0]}]
set_property PACKAGE_PIN    D22                 [get_ports {ddr3_ba[1]}]
set_property PACKAGE_PIN    F22                 [get_ports {ddr3_ba[2]}]
#
set_property SLEW           FAST                [get_ports {ddr3_cas_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cas_n}]
set_property PACKAGE_PIN    E21                 [get_ports {ddr3_cas_n}]
#
set_property SLEW           FAST                [get_ports {ddr3_cke[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cke[0]}]
set_property PACKAGE_PIN    D16                 [get_ports {ddr3_cke[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_cs_n[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cs_n[0]}]
set_property PACKAGE_PIN    E20                 [get_ports {ddr3_cs_n[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_odt[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_odt[0]}]
set_property PACKAGE_PIN    C16                 [get_ports {ddr3_odt[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_ras_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_ras_n}]
set_property PACKAGE_PIN    F21                 [get_ports {ddr3_ras_n}]
#
set_property SLEW           FAST                [get_ports {ddr3_we_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_we_n}]
set_property PACKAGE_PIN    F20                 [get_ports {ddr3_we_n}]
#
# DDR3 DQ
set_property SLEW           FAST                [get_ports {ddr3_dq[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_dq[*]}]
set_property PACKAGE_PIN    A16                 [get_ports {ddr3_dq[0]}]
set_property PACKAGE_PIN    A17                 [get_ports {ddr3_dq[1]}]
set_property PACKAGE_PIN    B18                 [get_ports {ddr3_dq[2]}]
set_property PACKAGE_PIN    A18                 [get_ports {ddr3_dq[3]}]
set_property PACKAGE_PIN    B22                 [get_ports {ddr3_dq[4]}]
set_property PACKAGE_PIN    A22                 [get_ports {ddr3_dq[5]}]
set_property PACKAGE_PIN    C19                 [get_ports {ddr3_dq[6]}]
set_property PACKAGE_PIN    B19                 [get_ports {ddr3_dq[7]}]
set_property PACKAGE_PIN    A23                 [get_ports {ddr3_dq[8]}]
set_property PACKAGE_PIN    E23                 [get_ports {ddr3_dq[9]}]
set_property PACKAGE_PIN    D23                 [get_ports {ddr3_dq[10]}]
set_property PACKAGE_PIN    E24                 [get_ports {ddr3_dq[11]}]
set_property PACKAGE_PIN    D24                 [get_ports {ddr3_dq[12]}]
set_property PACKAGE_PIN    F26                 [get_ports {ddr3_dq[13]}]
set_property PACKAGE_PIN    E26                 [get_ports {ddr3_dq[14]}]
set_property PACKAGE_PIN    G23                 [get_ports {ddr3_dq[15]}]
#
# DDR3 DQS
set_property SLEW           FAST                [get_ports {ddr3_dqs_?[*]}]
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {ddr3_dqs_?[*]}]
set_property PACKAGE_PIN    A20                 [get_ports {ddr3_dqs_p[0]}]
set_property PACKAGE_PIN    A21                 [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN    F25                 [get_ports {ddr3_dqs_p[1]}]
set_property PACKAGE_PIN    E25                 [get_ports {ddr3_dqs_n[1]}]
#
# DDR3 DM
set_property SLEW           FAST                [get_ports {ddr3_dm[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_dm[*]}]
set_property PACKAGE_PIN    C20                 [get_ports {ddr3_dm[0]}]
set_property PACKAGE_PIN    B23                 [get_ports {ddr3_dm[1]}]
#
# QSPI Flash
set_property IOSTANDARD     LVCMOS33            [get_ports {flash_*}]
set_property PACKAGE_PIN    U19                 [get_ports {flash_cs_n}]
set_property PACKAGE_PIN    P24                 [get_ports {flash_data[0]}]
set_property PACKAGE_PIN    R25                 [get_ports {flash_data[1]}]
set_property PACKAGE_PIN    R20                 [get_ports {flash_data[2]}]
set_property PACKAGE_PIN    R21                 [get_ports {flash_data[3]}]