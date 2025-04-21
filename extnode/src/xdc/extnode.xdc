# System clock
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {clk_100mhz_?}]
set_property PACKAGE_PIN    AC9                 [get_ports {clk_100mhz_p}]
set_property PACKAGE_PIN    AD9                 [get_ports {clk_100mhz_n}]
#
# DDR3 Reset
set_property SLEW           FAST                [get_ports {ddr3_reset_n}]
set_property IOSTANDARD     LVCMOS15            [get_ports {ddr3_reset_n}]
set_property PACKAGE_PIN    AA4                 [get_ports {ddr3_reset_n}]
#
# DDR3 Clock
set_property SLEW           FAST                [get_ports {ddr3_ck_?[0]}]
set_property IOSTANDARD     DIFF_SSTL15         [get_ports {ddr3_ck_?[0]}]
set_property PACKAGE_PIN    W6                  [get_ports {ddr3_ck_p[0]}]
set_property PACKAGE_PIN    W5                  [get_ports {ddr3_ck_n[0]}]
#
# DDR3 Control
set_property SLEW           FAST                [get_ports {ddr3_addr[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_addr[*]}]
set_property PACKAGE_PIN    AB1                 [get_ports {ddr3_addr[0]}]
set_property PACKAGE_PIN    V1                  [get_ports {ddr3_addr[1]}]
set_property PACKAGE_PIN    V2                  [get_ports {ddr3_addr[2]}]
set_property PACKAGE_PIN    Y2                  [get_ports {ddr3_addr[3]}]
set_property PACKAGE_PIN    Y3                  [get_ports {ddr3_addr[4]}]
set_property PACKAGE_PIN    V4                  [get_ports {ddr3_addr[5]}]
set_property PACKAGE_PIN    V6                  [get_ports {ddr3_addr[6]}]
set_property PACKAGE_PIN    U7                  [get_ports {ddr3_addr[7]}]
set_property PACKAGE_PIN    W3                  [get_ports {ddr3_addr[8]}]
set_property PACKAGE_PIN    V3                  [get_ports {ddr3_addr[9]}]
set_property PACKAGE_PIN    U1                  [get_ports {ddr3_addr[10]}]
set_property PACKAGE_PIN    U2                  [get_ports {ddr3_addr[11]}]
set_property PACKAGE_PIN    U5                  [get_ports {ddr3_addr[12]}]
set_property PACKAGE_PIN    U6                  [get_ports {ddr3_addr[13]}]
#
set_property SLEW           FAST                [get_ports {ddr3_ba[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_ba[*]}]
set_property PACKAGE_PIN    Y1                  [get_ports {ddr3_ba[0]}]
set_property PACKAGE_PIN    W1                  [get_ports {ddr3_ba[1]}]
set_property PACKAGE_PIN    AC1                 [get_ports {ddr3_ba[2]}]
#
set_property SLEW           FAST                [get_ports {ddr3_cas_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cas_n}]
set_property PACKAGE_PIN    AC2                 [get_ports {ddr3_cas_n}]
#
set_property SLEW           FAST                [get_ports {ddr3_cke[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cke[0]}]
set_property PACKAGE_PIN    AA5                 [get_ports {ddr3_cke[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_cs_n[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_cs_n[0]}]
set_property PACKAGE_PIN    AA2                 [get_ports {ddr3_cs_n[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_odt[0]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_odt[0]}]
set_property PACKAGE_PIN    AB5                 [get_ports {ddr3_odt[0]}]
#
set_property SLEW           FAST                [get_ports {ddr3_ras_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_ras_n}]
set_property PACKAGE_PIN    AB2                 [get_ports {ddr3_ras_n}]
#
set_property SLEW           FAST                [get_ports {ddr3_we_n}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_we_n}]
set_property PACKAGE_PIN    AA3                 [get_ports {ddr3_we_n}]
#
# DDR3 DQ
set_property SLEW           FAST                [get_ports {ddr3_dq[*]}]
set_property IOSTANDARD     SSTL15_T_DCI        [get_ports {ddr3_dq[*]}]
set_property PACKAGE_PIN    AD1                 [get_ports {ddr3_dq[0]}]
set_property PACKAGE_PIN    AE1                 [get_ports {ddr3_dq[1]}]
set_property PACKAGE_PIN    AE3                 [get_ports {ddr3_dq[2]}]
set_property PACKAGE_PIN    AE2                 [get_ports {ddr3_dq[3]}]
set_property PACKAGE_PIN    AE6                 [get_ports {ddr3_dq[4]}]
set_property PACKAGE_PIN    AE5                 [get_ports {ddr3_dq[5]}]
set_property PACKAGE_PIN    AF3                 [get_ports {ddr3_dq[6]}]
set_property PACKAGE_PIN    AF2                 [get_ports {ddr3_dq[7]}]
set_property PACKAGE_PIN    W11                 [get_ports {ddr3_dq[8]}]
set_property PACKAGE_PIN    V8                  [get_ports {ddr3_dq[9]}]
set_property PACKAGE_PIN    V7                  [get_ports {ddr3_dq[10]}]
set_property PACKAGE_PIN    Y8                  [get_ports {ddr3_dq[11]}]
set_property PACKAGE_PIN    Y7                  [get_ports {ddr3_dq[12]}]
set_property PACKAGE_PIN    Y11                 [get_ports {ddr3_dq[13]}]
set_property PACKAGE_PIN    Y10                 [get_ports {ddr3_dq[14]}]
set_property PACKAGE_PIN    V9                  [get_ports {ddr3_dq[15]}]
#
# DDR3 DQS
set_property SLEW           FAST                [get_ports {ddr3_dqs_?[*]}]
set_property IOSTANDARD     DIFF_SSTL15_T_DCI   [get_ports {ddr3_dqs_?[*]}]
set_property PACKAGE_PIN    AF5                 [get_ports {ddr3_dqs_p[0]}]
set_property PACKAGE_PIN    AF4                 [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN    W10                 [get_ports {ddr3_dqs_p[1]}]
set_property PACKAGE_PIN    W9                  [get_ports {ddr3_dqs_n[1]}]
#
# DDR3 DM
set_property SLEW           FAST                [get_ports {ddr3_dm[*]}]
set_property IOSTANDARD     SSTL15              [get_ports {ddr3_dm[*]}]
set_property PACKAGE_PIN    AD4                 [get_ports {ddr3_dm[0]}]
set_property PACKAGE_PIN    V11                 [get_ports {ddr3_dm[1]}]
#
# QSPI Flash
set_property IOSTANDARD     LVCMOS33            [get_ports {flash_*}]
set_property PACKAGE_PIN    C23                 [get_ports {flash_cs_n}]
set_property PACKAGE_PIN    B24                 [get_ports {flash_data[0]}]
set_property PACKAGE_PIN    A25                 [get_ports {flash_data[1]}]
set_property PACKAGE_PIN    B22                 [get_ports {flash_data[2]}]
set_property PACKAGE_PIN    A22                 [get_ports {flash_data[3]}]