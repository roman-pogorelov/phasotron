/*
    // Aurora 64b66b IP wrapper
    aurora64b66b_wrp #(
        .CH_CNT     ()  // The number of channels
    )
    the_aurora64b66b_wrp (
        // Common reset
        .reset      (), // i

        // GT reference clock input
        .gt_clk     (), // i

        // Free running clock input
        .init_clk   (), // i

        // User reset and clock outputs
        .user_rst   (), // o
        .user_clk   (), // o

        // GT serial RX
        .gt_rx_p    (), // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n    (), // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p    (), // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n    (), // o  [CH_CNT - 1 : 0][1 : 0]

        // Link status
        .channel_up (), // o  [CH_CNT - 1 : 0]
        .lane_up    (), // o  [CH_CNT - 1 : 0][1 : 0]

        // Error detection status
        .hard_err   (), // o  [CH_CNT - 1 : 0]
        .soft_err   (), // o  [CH_CNT - 1 : 0]

        // AXIS TX interface
        .tx_tdata   (), // i  [CH_CNT - 1 : 0][127 : 0]
        .tx_tkeep   (), // i  [CH_CNT - 1 : 0][15 : 0]
        .tx_tvalid  (), // i  [CH_CNT - 1 : 0]
        .tx_tlast   (), // i  [CH_CNT - 1 : 0]
        .tx_tready  (), // o  [CH_CNT - 1 : 0]

        // AXIS RX interface
        .rx_tdata   (), // o  [CH_CNT - 1 : 0][127 : 0]
        .rx_tkeep   (), // o  [CH_CNT - 1 : 0][15 : 0]
        .rx_tvalid  (), // o  [CH_CNT - 1 : 0]
        .rx_tlast   ()  // o  [CH_CNT - 1 : 0]
    ); // the_aurora64b66b_wrp
*/


module aurora64b66b_wrp
#(
    parameter int unsigned                  CH_CNT  = 3 // The number of channels
)
(
    // Common reset
    input  logic                            reset,

    // GT reference clock input
    input  logic                            gt_clk,

    // Free running clock input
    input  logic                            init_clk,

    // User reset and clock outputs
    output logic                            user_rst,
    output logic                            user_clk,

    // GT serial RX
    input  logic [CH_CNT - 1 : 0][1 : 0]    gt_rx_p,
    input  logic [CH_CNT - 1 : 0][1 : 0]    gt_rx_n,

    // GT serial TX
    output logic [CH_CNT - 1 : 0][1 : 0]    gt_tx_p,
    output logic [CH_CNT - 1 : 0][1 : 0]    gt_tx_n,

    // Link status
    output logic [CH_CNT - 1 : 0]           channel_up,
    output logic [CH_CNT - 1 : 0][1 : 0]    lane_up,

    // Error detection status
    output logic [CH_CNT - 1 : 0]           hard_err,
    output logic [CH_CNT - 1 : 0]           soft_err,

    // AXIS TX interface
    input  logic [CH_CNT - 1 : 0][127 : 0]  tx_tdata,
    input  logic [CH_CNT - 1 : 0][15 : 0]   tx_tkeep,
    input  logic [CH_CNT - 1 : 0]           tx_tvalid,
    input  logic [CH_CNT - 1 : 0]           tx_tlast,
    output logic [CH_CNT - 1 : 0]           tx_tready,

    // AXIS RX interface
    output logic [CH_CNT - 1 : 0][127 : 0]  rx_tdata,
    output logic [CH_CNT - 1 : 0][15 : 0]   rx_tkeep,
    output logic [CH_CNT - 1 : 0]           rx_tvalid,
    output logic [CH_CNT - 1 : 0]           rx_tlast
);
    // Constants
    localparam int unsigned     QUAD_CNT = (CH_CNT + 1) / 2;


    // Variables
    logic                       gt_reset;
    logic                       sys_reset;
    //
    logic [CH_CNT - 1 : 0]      gt_pll_lock;
    logic [CH_CNT - 1 : 0]      tx_out_clk;
    logic                       mmcm_not_locked;
    logic                       sync_clk;
    //
    logic                       pma_init;
    logic                       reset_pb;
    //
    logic [QUAD_CNT - 1 : 0]    gt_qpllclk_quad;
    logic [QUAD_CNT - 1 : 0]    gt_qpllrefclk_quad;


    // XPM reset synchronizer
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF       (5),
        .INIT_SYNC_FF       (0),
        .RST_ACTIVE_HIGH    (1)
    )
    xpm_cdc_async_rst_init (
        .src_arst           (reset),
        .dest_clk           (init_clk),
        .dest_arst          (gt_reset)
    ); // xpm_cdc_async_rst_init


    // XPM reset synchronizer
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF       (5),
        .INIT_SYNC_FF       (0),
        .RST_ACTIVE_HIGH    (1)
    )
    xpm_cdc_async_rst_sys (
        .src_arst           (reset),
        .dest_clk           (user_clk),
        .dest_arst          (sys_reset)
    ); // xpm_cdc_async_rst_sys


    // XPM reset synchronizer
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF       (10),
        .INIT_SYNC_FF       (0),
        .RST_ACTIVE_HIGH    (1)
    )
    xpm_cdc_async_rst_user (
        .src_arst           (sys_reset | mmcm_not_locked),
        .dest_clk           (user_clk),
        .dest_arst          (user_rst)
    ); // xpm_cdc_async_rst_user


    // Common reset logic
    aurora64b66b_support_reset_logic the_aurora64b66b_support_reset_logic (
        .RESET          (sys_reset),    // i
        .GT_RESET_IN    (gt_reset),     // i
        .USER_CLK       (user_clk),     // i
        .INIT_CLK       (init_clk),     // i
        .SYSTEM_RESET   (reset_pb),     // o
        .GT_RESET_OUT   (pma_init)      // o
    ); // the_aurora64b66b_support_reset_logic


    // Common clock module
    aurora64b66b_clock_module the_aurora64b66b_clock_module (
        .CLK                (tx_out_clk[0]),    // i
        .CLK_LOCKED         (&gt_pll_lock),     // i
        .USER_CLK           (user_clk),         // o
        .SYNC_CLK           (sync_clk),         // o
        .MMCM_NOT_LOCKED    (mmcm_not_locked)   // o
    ); // the_aurora64b66b_clock_module


    // Generate common GT primitives
    generate
        genvar q;
        for (q = 0; q < QUAD_CNT; q++) begin: common_gen
            aurora64b66b_gt_common_wrapper the_aurora64b66b_gt_common_wrapper (
                .GT0_GTREFCLK0_COMMON_IN    (gt_clk),                   // i
                .GT0_QPLLLOCKDETCLK_IN      (init_clk),                 // i

                .gt_qpllclk_quad_out        (gt_qpllclk_quad[q]),       // o
                .gt_qpllrefclk_quad_out     (gt_qpllrefclk_quad[q]),    // o
                .GT0_QPLLLOCK_OUT           (  ),                       // o
                .GT0_QPLLREFCLKLOST_OUT     (  ),                       // o

                .qpll_drpclk_in             (init_clk),                 // i
                .qpll_drpaddr_in            ({8{1'b0}}),                // i [7 : 0]
                .qpll_drpdi_in              ({16{1'b0}}),               // i [15 : 0]
                .qpll_drpen_in              (1'b0),                     // i
                .qpll_drpwe_in              (1'b0),                     // i
                .qpll_drpdo_out             (  ),                       // o [15 : 0]
                .qpll_drprdy_out            (  )                        // o
            ); // the_aurora64b66b_gt_common_wrapper
        end
    endgenerate


    // Generate Aurora IP instances
    generate
        genvar ch;
        for (ch = 0; ch < CH_CNT; ch++) begin: aurora64b66b_gen
            aurora64b66b the_aurora64b66b (
                .refclk1_in             (gt_clk),                       // input  wire refclk1_in

                .rxp                    (gt_rx_p[ch]),                  // input  wire [0 : 1] rxp
                .rxn                    (gt_rx_n[ch]),                  // input  wire [0 : 1] rxn
                .txp                    (gt_tx_p[ch]),                  // output wire [0 : 1] txp
                .txn                    (gt_tx_n[ch]),                  // output wire [0 : 1] txn

                .user_clk               (user_clk),                     // input  wire user_clk
                .sync_clk               (sync_clk),                     // input  wire sync_clk
                .tx_out_clk             (tx_out_clk[ch]),               // output wire tx_out_clk

                .reset_pb               (reset_pb),                     // input  wire reset_pb
                .power_down             (1'b0),                         // input  wire power_down
                .pma_init               (pma_init),                     // input  wire pma_init

                .loopback               ({3{1'b0}}),                    // input  wire [2 : 0] loopback

                .hard_err               (hard_err[ch]),                 // output wire hard_err
                .soft_err               (soft_err[ch]),                 // output wire soft_err

                .channel_up             (channel_up[ch]),               // output wire channel_up
                .lane_up                (lane_up[ch]),                  // output wire [0 : 1] lane_up

                .init_clk               (init_clk),                     // input  wire init_clk
                .gt_pll_lock            (gt_pll_lock[ch]),              // output wire gt_pll_lock
                .gt_rxcdrovrden_in      (1'b0),                         // input  wire gt_rxcdrovrden_in
                .mmcm_not_locked        (mmcm_not_locked),              // input  wire mmcm_not_locked
                .link_reset_out         (  ),                           // output wire link_reset_out
                .sys_reset_out          (  ),                           // output wire sys_reset_out

                .s_axi_tx_tdata         (tx_tdata[ch]),                 // input  wire [127 : 0] s_axi_tx_tdata
                .s_axi_tx_tkeep         (tx_tkeep[ch]),                 // input  wire [15 : 0] s_axi_tx_tkeep
                .s_axi_tx_tlast         (tx_tlast[ch]),                 // input  wire s_axi_tx_tlast
                .s_axi_tx_tvalid        (tx_tvalid[ch]),                // input  wire s_axi_tx_tvalid
                .s_axi_tx_tready        (tx_tready[ch]),                // output wire s_axi_tx_tready

                .m_axi_rx_tdata         (rx_tdata[ch]),                 // output wire [127 : 0] m_axi_rx_tdata
                .m_axi_rx_tkeep         (rx_tkeep[ch]),                 // output wire [15 : 0] m_axi_rx_tkeep
                .m_axi_rx_tlast         (rx_tlast[ch]),                 // output wire m_axi_rx_tlast
                .m_axi_rx_tvalid        (rx_tvalid[ch]),                // output wire m_axi_rx_tvalid

                .drp_clk_in             (init_clk),                     // input  wire drp_clk_in
                .drpaddr_in             ({9{1'b0}}),                    // input  wire [8 : 0] drpaddr_in
                .drpaddr_in_lane1       ({9{1'b0}}),                    // input  wire [8 : 0] drpaddr_in_lane1
                .drpdi_in               ({16{1'b0}}),                   // input  wire [15 : 0] drpdi_in
                .drpdi_in_lane1         ({16{1'b0}}),                   // input  wire [15 : 0] drpdi_in_lane1
                .drprdy_out             (  ),                           // output wire drprdy_out
                .drprdy_out_lane1       (  ),                           // output wire drprdy_out_lane1
                .drpen_in               (1'b0),                         // input  wire drpen_in
                .drpen_in_lane1         (1'b0),                         // input  wire drpen_in_lane1
                .drpwe_in               (1'b0),                         // input  wire drpwe_in
                .drpwe_in_lane1         (1'b0),                         // input  wire drpwe_in_lane1
                .drpdo_out              (  ),                           // output wire [15 : 0] drpdo_out
                .drpdo_out_lane1        (  ),                           // output wire [15 : 0] drpdo_out_lane1

                .gt_qpllclk_quad1_in    (gt_qpllclk_quad[ch / 2]),      // input  wire gt_qpllclk_quad1_in
                .gt_qpllrefclk_quad1_in (gt_qpllrefclk_quad[ch / 2])    // input  wire gt_qpllrefclk_quad1_in
            ); // the_aurora64b66b
        end // aurora64b66b_gen
    endgenerate


endmodule: aurora64b66b_wrp