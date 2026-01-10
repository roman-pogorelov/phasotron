/*
    // Upstream unit
    upstream_unit the_upstream_unit
    (
        // Common asynchronous reset
        .rst            (), // i

        // Intialization clock
        .clk_init       (), // i

        // GT reference clock
        .clk_gt         (), // i

        // GT RX
        .up0_rx_p       (), // i  [1 : 0]
        .up0_rx_n       (), // i  [1 : 0]

        // GT TX
        .up0_tx_p       (), // o  [1 : 0]
        .up0_tx_n       ()  // o  [1 : 0]
    ); // the_upstream_unit
*/


module upstream_unit
(
    // Common asynchronous reset
    input  logic            rst,

    // Intialization clock
    input  logic            clk_init,

    // GT reference clock
    input  wire             clk_gt,

    // GT RX
    input  wire  [1 : 0]    up0_rx_p,
    input  wire  [1 : 0]    up0_rx_n,

    // GT TX
    output wire  [1 : 0]    up0_tx_p,
    output wire  [1 : 0]    up0_tx_n
);

    // Constants
    localparam int unsigned         CH_CNT = 1;


    // Variables
    logic                           user_clk;
    //
    logic [CH_CNT - 1 : 0][127 : 0] tx_tdata;
    logic [CH_CNT - 1 : 0][15 : 0]  tx_tkeep;
    logic [CH_CNT - 1 : 0]          tx_tvalid;
    logic [CH_CNT - 1 : 0]          tx_tlast;


    // Aurora 64b66b IP wrapper
    aurora64b66b_wrp #(
        .CH_CNT     (CH_CNT)        // The number of channels
    )
    the_aurora64b66b_wrp (
        // Common reset
        .reset      (rst),          // i

        // GT reference clock
        .gt_clk     (clk_gt),       // i

        // Free running clock
        .init_clk   (clk_init),     // i

        // Output user clock
        .user_clk   (user_clk),     // o

        // GT serial RX
        .gt_rx_p    (up0_rx_p),     // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n    (up0_rx_n),     // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p    (up0_tx_p),     // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n    (up0_tx_n),     // o  [CH_CNT - 1 : 0][1 : 0]

        // Link status
        .channel_up (  ),           // o  [CH_CNT - 1 : 0]
        .lane_up    (  ),           // o  [CH_CNT - 1 : 0][1 : 0]

        // Error detection status
        .hard_err   (  ),           // o  [CH_CNT - 1 : 0]
        .soft_err   (  ),           // o  [CH_CNT - 1 : 0]

        // AXIS TX interface
        .tx_tdata   (tx_tdata),     // i  [CH_CNT - 1 : 0][127 : 0]
        .tx_tkeep   (tx_tkeep),     // i  [CH_CNT - 1 : 0][15 : 0]
        .tx_tvalid  (tx_tvalid),    // i  [CH_CNT - 1 : 0]
        .tx_tlast   (tx_tlast),     // i  [CH_CNT - 1 : 0]
        .tx_tready  (  ),           // o  [CH_CNT - 1 : 0]

        // AXIS RX interface
        .rx_tdata   (tx_tdata),     // o  [CH_CNT - 1 : 0][127 : 0]
        .rx_tkeep   (tx_tkeep),     // o  [CH_CNT - 1 : 0][15 : 0]
        .rx_tvalid  (tx_tvalid),    // o  [CH_CNT - 1 : 0]
        .rx_tlast   (tx_tlast)      // o  [CH_CNT - 1 : 0]
    ); // the_aurora64b66b_wrp

endmodule: upstream_unit