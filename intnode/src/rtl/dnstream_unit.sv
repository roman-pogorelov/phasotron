/*
    // Downstream unit
    dnstream_unit the_dnstream_unit
    (
        // Common asynchronous reset
        .rst            (), // i

        // Intialization clock
        .clk_init       (), // i

        // GT reference clock
        .clk_gt         (), // i

        // GT RX
        .dn0_rx_p       (), // i  [1 : 0]
        .dn0_rx_n       (), // i  [1 : 0]
        .dn1_rx_p       (), // i  [1 : 0]
        .dn1_rx_n       (), // i  [1 : 0]
        .dn2_rx_p       (), // i  [1 : 0]
        .dn2_rx_n       (), // i  [1 : 0]
        .dn3_rx_p       (), // i  [1 : 0]
        .dn3_rx_n       (), // i  [1 : 0]

        // GT TX
        .dn0_tx_p       (), // o  [1 : 0]
        .dn0_tx_n       (), // o  [1 : 0]
        .dn1_tx_p       (), // o  [1 : 0]
        .dn1_tx_n       (), // o  [1 : 0]
        .dn2_tx_p       (), // o  [1 : 0]
        .dn2_tx_n       (), // o  [1 : 0]
        .dn3_tx_p       (), // o  [1 : 0]
        .dn3_tx_n       ()  // o  [1 : 0]
    ); // the_dnstream_unit
*/


module dnstream_unit
(
    // Common asynchronous reset
    input  logic            rst,

    // Intialization clock
    input  logic            clk_init,

    // GT reference clock
    input  wire             clk_gt,

    // GT RX
    input  wire  [1 : 0]    dn0_rx_p,
    input  wire  [1 : 0]    dn0_rx_n,
    input  wire  [1 : 0]    dn1_rx_p,
    input  wire  [1 : 0]    dn1_rx_n,
    input  wire  [1 : 0]    dn2_rx_p,
    input  wire  [1 : 0]    dn2_rx_n,
    input  wire  [1 : 0]    dn3_rx_p,
    input  wire  [1 : 0]    dn3_rx_n,

    // GT TX
    output wire  [1 : 0]    dn0_tx_p,
    output wire  [1 : 0]    dn0_tx_n,
    output wire  [1 : 0]    dn1_tx_p,
    output wire  [1 : 0]    dn1_tx_n,
    output wire  [1 : 0]    dn2_tx_p,
    output wire  [1 : 0]    dn2_tx_n,
    output wire  [1 : 0]    dn3_tx_p,
    output wire  [1 : 0]    dn3_tx_n
);
    // Variables
    logic           user_clk;
    //
    logic           reset_usr;
    logic           reset_sys;
    logic           reset_gt;
    //
    logic           gtq0_qpllclk;
    logic           gtq0_qpllrefclk;
    logic           gtq0_qplllock;
    logic           gtq0_qpllrefclklost;
    //
    logic           gtq1_qpllclk;
    logic           gtq1_qpllrefclk;
    logic           gtq1_qplllock;
    logic           gtq1_qpllrefclklost;
    //
    logic [63 : 0]  dn0_axis_tdata;
    logic           dn0_axis_tvalid;
    logic           dn0_axis_tready;
    //
    logic           dn0_tx_out_clk;
    logic           dn0_tx_lock;
    //
    logic [63 : 0]  dn1_axis_tdata;
    logic           dn1_axis_tvalid;
    logic           dn1_axis_tready;
    //
    logic           dn1_tx_out_clk;
    logic           dn1_tx_lock;
    //
    logic [63 : 0]  dn2_axis_tdata;
    logic           dn2_axis_tvalid;
    logic           dn2_axis_tready;
    //
    logic           dn2_tx_out_clk;
    logic           dn2_tx_lock;
    //
    logic [63 : 0]  dn3_axis_tdata;
    logic           dn3_axis_tvalid;
    logic           dn3_axis_tready;
    //
    logic           dn3_tx_out_clk;
    logic           dn3_tx_lock;


    // Asynchronous Reset Synchronizer
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF       (4),
        .INIT_SYNC_FF       (0),
        .RST_ACTIVE_HIGH    (1)
   )
   user_reset_sync
   (
        .src_arst   (rst),
        .dest_clk   (user_clk),
        .dest_arst  (reset_usr)
   ); // user_reset_sync


    // Reset logic instance
    aurora8b10b_SUPPORT_RESET_LOGIC reset_logic
    (
        .RESET          (reset_usr),
        .USER_CLK       (user_clk),
        .INIT_CLK_IN    (init_clk),
        .GT_RESET_IN    (rst),
        .SYSTEM_RESET   (reset_sys),
        .GT_RESET_OUT   (reset_gt)
    ); // reset_logic


    // BUFG instance
    BUFG user_clk_buf
    (
        .I  (dn0_tx_out_clk),
        .O  (user_clk)
    ); // user_clk_buf


    // Aurora 8B10B GT common instance
    aurora8b10b_gt_common_wrapper gt_common_dn0_dn1
    (
        .gt_qpllclk_quad1_i         (gtq0_qpllclk),
        .gt_qpllrefclk_quad1_i      (gtq0_qpllrefclk),

        .gt0_gtrefclk0_common_in    (clk_gt),

        .gt0_qplllock_out           (gtq0_qplllock),
        .gt0_qplllockdetclk_in      (init_clk),
        .gt0_qpllrefclklost_out     (gtq0_qpllrefclklost),
        .gt0_qpllreset_in           (1'b0)
    ); // gt_common_dn0_dn1


    // Aurora 8B10B GT common instance
    aurora8b10b_gt_common_wrapper gt_common_dn2_dn3
    (
        .gt_qpllclk_quad1_i         (gtq1_qpllclk),
        .gt_qpllrefclk_quad1_i      (gtq1_qpllrefclk),

        .gt0_gtrefclk0_common_in    (clk_gt),

        .gt0_qplllock_out           (gtq1_qplllock),
        .gt0_qplllockdetclk_in      (init_clk),
        .gt0_qpllrefclklost_out     (gtq1_qpllrefclklost),
        .gt0_qpllreset_in           (1'b0)
    ); // gt_common_dn2_dn3


    // Aurora 8B10B IP instance
    aurora8b10b aurora8b10b_dn0
    (
        .s_axi_tx_tdata             (dn0_axis_tdata),               // i  [63:0]
        .s_axi_tx_tvalid            (dn0_axis_tvalid),              // i
        .s_axi_tx_tready            (dn0_axis_tready),              // o

        .m_axi_rx_tdata             (dn0_axis_tdata),               // o  [63:0]
        .m_axi_rx_tvalid            (dn0_axis_tvalid),              // o

        // GT Serial I/O
        .rxp                        ({dn0_rx_p[0], dn0_rx_p[1]}),   // i  [0:1]
        .rxn                        ({dn0_rx_n[0], dn0_rx_n[1]}),   // i  [0:1]

        .txp                        ({dn0_tx_p[0], dn0_tx_p[1]}),   // o  [0:1]
        .txn                        ({dn0_tx_n[0], dn0_tx_n[1]}),   // o  [0:1]

        // GT Reference Clock Interface
        .gt_refclk1                 (clk_gt),                       // i

        // Error Detection Interface
        .hard_err                   (  ),                           // o
        .soft_err                   (  ),                           // o

        // Status
        .lane_up                    (  ),                           // o  [0:1]
        .channel_up                 (  ),                           // o

        // System Interface
        .user_clk                   (user_clk),                     // i
        .sync_clk                   (user_clk),                     // i
        .gt_reset                   (reset_gt),                     // i
        .reset                      (reset_sys),                    // i
        .sys_reset_out              (  ),                           // o

        .power_down                 (1'b0),                         // i
        .loopback                   (3'b000),                       // i  [2:0]
        .tx_lock                    (dn0_tx_lock),                  // o

        .init_clk_in                (clk_init),                     // i
        .tx_resetdone_out           (  ),                           // o
        .rx_resetdone_out           (  ),                           // o
        .link_reset_out             (  ),                           // o

        // DRP Ports
        .drpclk_in                  (clk_init),                     // i
        .drpaddr_in                 (9'b0),                         // i  [8:0]
        .drpen_in                   (1'b0),                         // i
        .drpdi_in                   (16'b0),                        // i  [15:0]
        .drprdy_out                 (  ),                           // o
        .drpdo_out                  (  ),                           // o  [15:0]
        .drpwe_in                   (1'b0),                         // i
        .drpaddr_in_lane1           (9'b0),                         // i  [8:0]
        .drpen_in_lane1             (1'b0),                         // i
        .drpdi_in_lane1             (16'b0),                        // i  [15:0]
        .drprdy_out_lane1           (  ),                           // o
        .drpdo_out_lane1            (  ),                           // o  [15:0]
        .drpwe_in_lane1             (1'b0),                         // i

        .gt0_qplllock_in            (gtq0_qplllock),                // i
        .gt0_qpllrefclklost_in      (gtq0_qpllrefclklost),          // i
        .gt0_qpllreset_out          (  ),                           // o
        .gt_qpllclk_quad1_in        (gtq0_qpllclk),                 // i
        .gt_qpllrefclk_quad1_in     (gtq0_qpllrefclk),              // i

        .tx_out_clk                 (dn0_tx_out_clk),               // o
        .pll_not_locked             (~dn0_tx_lock)                  // i
    ); // aurora8b10b_dn0


    // Aurora 8B10B IP instance
    aurora8b10b aurora8b10b_dn1
    (
        .s_axi_tx_tdata             (dn1_axis_tdata),               // i  [63:0]
        .s_axi_tx_tvalid            (dn1_axis_tvalid),              // i
        .s_axi_tx_tready            (dn1_axis_tready),              // o

        .m_axi_rx_tdata             (dn1_axis_tdata),               // o  [63:0]
        .m_axi_rx_tvalid            (dn1_axis_tvalid),              // o

        // GT Serial I/O
        .rxp                        ({dn1_rx_p[0], dn1_rx_p[1]}),   // i  [0:1]
        .rxn                        ({dn1_rx_n[0], dn1_rx_n[1]}),   // i  [0:1]

        .txp                        ({dn1_tx_p[0], dn1_tx_p[1]}),   // o  [0:1]
        .txn                        ({dn1_tx_n[0], dn1_tx_n[1]}),   // o  [0:1]

        // GT Reference Clock Interface
        .gt_refclk1                 (clk_gt),                       // i

        // Error Detection Interface
        .hard_err                   (  ),                           // o
        .soft_err                   (  ),                           // o

        // Status
        .lane_up                    (  ),                           // o  [0:1]
        .channel_up                 (  ),                           // o

        // System Interface
        .user_clk                   (user_clk),                     // i
        .sync_clk                   (user_clk),                     // i
        .gt_reset                   (reset_gt),                     // i
        .reset                      (reset_sys),                    // i
        .sys_reset_out              (  ),                           // o

        .power_down                 (1'b0),                         // i
        .loopback                   (3'b000),                       // i  [2:0]
        .tx_lock                    (dn1_tx_lock),                  // o

        .init_clk_in                (clk_init),                     // i
        .tx_resetdone_out           (  ),                           // o
        .rx_resetdone_out           (  ),                           // o
        .link_reset_out             (  ),                           // o

        // DRP Ports
        .drpclk_in                  (clk_init),                     // i
        .drpaddr_in                 (9'b0),                         // i  [8:0]
        .drpen_in                   (1'b0),                         // i
        .drpdi_in                   (16'b0),                        // i  [15:0]
        .drprdy_out                 (  ),                           // o
        .drpdo_out                  (  ),                           // o  [15:0]
        .drpwe_in                   (1'b0),                         // i
        .drpaddr_in_lane1           (9'b0),                         // i  [8:0]
        .drpen_in_lane1             (1'b0),                         // i
        .drpdi_in_lane1             (16'b0),                        // i  [15:0]
        .drprdy_out_lane1           (  ),                           // o
        .drpdo_out_lane1            (  ),                           // o  [15:0]
        .drpwe_in_lane1             (1'b0),                         // i

        .gt0_qplllock_in            (gtq0_qplllock),                // i
        .gt0_qpllrefclklost_in      (gtq0_qpllrefclklost),          // i
        .gt0_qpllreset_out          (  ),                           // o
        .gt_qpllclk_quad1_in        (gtq0_qpllclk),                 // i
        .gt_qpllrefclk_quad1_in     (gtq0_qpllrefclk),              // i

        .tx_out_clk                 (dn1_tx_out_clk),               // o
        .pll_not_locked             (~dn1_tx_lock)                  // i
    ); // aurora8b10b_dn1


    // Aurora 8B10B IP instance
    aurora8b10b aurora8b10b_dn2
    (
        .s_axi_tx_tdata             (dn2_axis_tdata),               // i  [63:0]
        .s_axi_tx_tvalid            (dn2_axis_tvalid),              // i
        .s_axi_tx_tready            (dn2_axis_tready),              // o

        .m_axi_rx_tdata             (dn2_axis_tdata),               // o  [63:0]
        .m_axi_rx_tvalid            (dn2_axis_tvalid),              // o

        // GT Serial I/O
        .rxp                        ({dn2_rx_p[0], dn2_rx_p[1]}),   // i  [0:1]
        .rxn                        ({dn2_rx_n[0], dn2_rx_n[1]}),   // i  [0:1]

        .txp                        ({dn2_tx_p[0], dn2_tx_p[1]}),   // o  [0:1]
        .txn                        ({dn2_tx_n[0], dn2_tx_n[1]}),   // o  [0:1]

        // GT Reference Clock Interface
        .gt_refclk1                 (clk_gt),                       // i

        // Error Detection Interface
        .hard_err                   (  ),                           // o
        .soft_err                   (  ),                           // o

        // Status
        .lane_up                    (  ),                           // o  [0:1]
        .channel_up                 (  ),                           // o

        // System Interface
        .user_clk                   (user_clk),                     // i
        .sync_clk                   (user_clk),                     // i
        .gt_reset                   (reset_gt),                     // i
        .reset                      (reset_sys),                    // i
        .sys_reset_out              (  ),                           // o

        .power_down                 (1'b0),                         // i
        .loopback                   (3'b000),                       // i  [2:0]
        .tx_lock                    (dn2_tx_lock),                  // o

        .init_clk_in                (clk_init),                     // i
        .tx_resetdone_out           (  ),                           // o
        .rx_resetdone_out           (  ),                           // o
        .link_reset_out             (  ),                           // o

        // DRP Ports
        .drpclk_in                  (clk_init),                     // i
        .drpaddr_in                 (9'b0),                         // i  [8:0]
        .drpen_in                   (1'b0),                         // i
        .drpdi_in                   (16'b0),                        // i  [15:0]
        .drprdy_out                 (  ),                           // o
        .drpdo_out                  (  ),                           // o  [15:0]
        .drpwe_in                   (1'b0),                         // i
        .drpaddr_in_lane1           (9'b0),                         // i  [8:0]
        .drpen_in_lane1             (1'b0),                         // i
        .drpdi_in_lane1             (16'b0),                        // i  [15:0]
        .drprdy_out_lane1           (  ),                           // o
        .drpdo_out_lane1            (  ),                           // o  [15:0]
        .drpwe_in_lane1             (1'b0),                         // i

        .gt0_qplllock_in            (gtq1_qplllock),                // i
        .gt0_qpllrefclklost_in      (gtq1_qpllrefclklost),          // i
        .gt0_qpllreset_out          (  ),                           // o
        .gt_qpllclk_quad1_in        (gtq1_qpllclk),                 // i
        .gt_qpllrefclk_quad1_in     (gtq1_qpllrefclk),              // i

        .tx_out_clk                 (dn2_tx_out_clk),               // o
        .pll_not_locked             (~dn2_tx_lock)                  // i
    ); // aurora8b10b_dn2


    // Aurora 8B10B IP instance
    aurora8b10b aurora8b10b_dn3
    (
        .s_axi_tx_tdata             (dn3_axis_tdata),               // i  [63:0]
        .s_axi_tx_tvalid            (dn3_axis_tvalid),              // i
        .s_axi_tx_tready            (dn3_axis_tready),              // o

        .m_axi_rx_tdata             (dn3_axis_tdata),               // o  [63:0]
        .m_axi_rx_tvalid            (dn3_axis_tvalid),              // o

        // GT Serial I/O
        .rxp                        ({dn3_rx_p[0], dn3_rx_p[1]}),   // i  [0:1]
        .rxn                        ({dn3_rx_n[0], dn3_rx_n[1]}),   // i  [0:1]

        .txp                        ({dn3_tx_p[0], dn3_tx_p[1]}),   // o  [0:1]
        .txn                        ({dn3_tx_n[0], dn3_tx_n[1]}),   // o  [0:1]

        // GT Reference Clock Interface
        .gt_refclk1                 (clk_gt),                       // i

        // Error Detection Interface
        .hard_err                   (  ),                           // o
        .soft_err                   (  ),                           // o

        // Status
        .lane_up                    (  ),                           // o  [0:1]
        .channel_up                 (  ),                           // o

        // System Interface
        .user_clk                   (user_clk),                     // i
        .sync_clk                   (user_clk),                     // i
        .gt_reset                   (reset_gt),                     // i
        .reset                      (reset_sys),                    // i
        .sys_reset_out              (  ),                           // o

        .power_down                 (1'b0),                         // i
        .loopback                   (3'b000),                       // i  [2:0]
        .tx_lock                    (dn3_tx_lock),                  // o

        .init_clk_in                (clk_init),                     // i
        .tx_resetdone_out           (  ),                           // o
        .rx_resetdone_out           (  ),                           // o
        .link_reset_out             (  ),                           // o

        // DRP Ports
        .drpclk_in                  (clk_init),                     // i
        .drpaddr_in                 (9'b0),                         // i  [8:0]
        .drpen_in                   (1'b0),                         // i
        .drpdi_in                   (16'b0),                        // i  [15:0]
        .drprdy_out                 (  ),                           // o
        .drpdo_out                  (  ),                           // o  [15:0]
        .drpwe_in                   (1'b0),                         // i
        .drpaddr_in_lane1           (9'b0),                         // i  [8:0]
        .drpen_in_lane1             (1'b0),                         // i
        .drpdi_in_lane1             (16'b0),                        // i  [15:0]
        .drprdy_out_lane1           (  ),                           // o
        .drpdo_out_lane1            (  ),                           // o  [15:0]
        .drpwe_in_lane1             (1'b0),                         // i

        .gt0_qplllock_in            (gtq1_qplllock),                // i
        .gt0_qpllrefclklost_in      (gtq1_qpllrefclklost),          // i
        .gt0_qpllreset_out          (  ),                           // o
        .gt_qpllclk_quad1_in        (gtq1_qpllclk),                 // i
        .gt_qpllrefclk_quad1_in     (gtq1_qpllrefclk),              // i

        .tx_out_clk                 (dn3_tx_out_clk),               // o
        .pll_not_locked             (~dn3_tx_lock)                  // i
    ); // aurora8b10b_dn3

endmodule: dnstream_unit