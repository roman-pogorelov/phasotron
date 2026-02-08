/*
    // Aurora-based transport
    aurora_transport #(
        .CH_CNT                 ()  // The number of channels
    )
    the_aurora_transport
    (
        // Common reset
        .rst                    (), // i

        // GT reference clock input
        .gt_clk                 (), // i

        // Free running clock input
        .init_clk               (), // i

        // User reset and clock outputs
        .user_rst               (), // o
        .user_clk               (), // o

        // GT serial RX
        .gt_rx_p                (), // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n                (), // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p                (), // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n                (), // o  [CH_CNT - 1 : 0][1 : 0]

        // Status
        .stat_link_up           (), // o  [CH_CNT - 1 : 0]
        .stat_soft_err          (), // o  [CH_CNT - 1 : 0]
        .stat_hard_err          (), // o  [CH_CNT - 1 : 0]
        .stat_rx_data_loss      (), // o  [CH_CNT - 1 : 0]
        .stat_rx_frame_loss     (), // o  [CH_CNT - 1 : 0]
        .stat_tx_data_loss      (), // o  [CH_CNT - 1 : 0]
        .stat_tx_frame_loss     (), // o  [CH_CNT - 1 : 0]

        // AXIS TX interface
        .tx_tdata               (), // i  [CH_CNT - 1 : 0][127 : 0]
        .tx_tkeep               (), // i  [CH_CNT - 1 : 0][15 : 0]
        .tx_tvalid              (), // i  [CH_CNT - 1 : 0]
        .tx_tlast               (), // i  [CH_CNT - 1 : 0]
        .tx_tready              (), // o  [CH_CNT - 1 : 0]

        // AXIS RX interface
        .rx_tdata               (), // o  [CH_CNT - 1 : 0][127 : 0]
        .rx_tkeep               (), // o  [CH_CNT - 1 : 0][15 : 0]
        .rx_tvalid              (), // o  [CH_CNT - 1 : 0]
        .rx_tlast               (), // o  [CH_CNT - 1 : 0]
        .rx_tready              ()  // i  [CH_CNT - 1 : 0]
    ); // the_aurora_transport
*/


module aurora_transport
#(
    parameter int unsigned                  CH_CNT  = 1 // The number of channels
)
(
    // Common reset
    input  logic                            rst,

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

    // Status
    output logic [CH_CNT - 1 : 0]           stat_link_up,
    output logic [CH_CNT - 1 : 0]           stat_soft_err,
    output logic [CH_CNT - 1 : 0]           stat_hard_err,
    output logic [CH_CNT - 1 : 0]           stat_rx_data_loss,
    output logic [CH_CNT - 1 : 0]           stat_rx_frame_loss,
    output logic [CH_CNT - 1 : 0]           stat_tx_data_loss,
    output logic [CH_CNT - 1 : 0]           stat_tx_frame_loss,

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
    output logic [CH_CNT - 1 : 0]           rx_tlast,
    input  logic [CH_CNT - 1 : 0]           rx_tready
);
    // Constants
    localparam int unsigned AXIS_TX_DATA_W  = $size(tx_tdata, 2);
    localparam int unsigned AXIS_TX_KEEP_W  = $size(tx_tkeep, 2);
    localparam int unsigned AXIS_RX_DATA_W  = $size(rx_tdata, 2);
    localparam int unsigned AXIS_RX_KEEP_W  = $size(rx_tkeep, 2);


    // Variables
    logic [CH_CNT - 1 : 0][AXIS_TX_DATA_W - 1 : 0]  tx_fifo_tdata;
    logic [CH_CNT - 1 : 0][AXIS_TX_KEEP_W - 1 : 0]  tx_fifo_tkeep;
    logic [CH_CNT - 1 : 0]                          tx_fifo_tvalid;
    logic [CH_CNT - 1 : 0]                          tx_fifo_tlast;
    logic [CH_CNT - 1 : 0]                          tx_fifo_tready;
    //
    logic [CH_CNT - 1 : 0][AXIS_TX_DATA_W - 1 : 0]  tx_guard_tdata;
    logic [CH_CNT - 1 : 0][AXIS_TX_KEEP_W - 1 : 0]  tx_guard_tkeep;
    logic [CH_CNT - 1 : 0]                          tx_guard_tvalid;
    logic [CH_CNT - 1 : 0]                          tx_guard_tlast;
    logic [CH_CNT - 1 : 0]                          tx_guard_tready;
    //
    logic [CH_CNT - 1 : 0]                          rx_fifo_ready;
    logic [CH_CNT - 1 : 0]                          rx_fifo_below_lwm;
    logic [CH_CNT - 1 : 0]                          rx_fifo_above_hwm;
    //
    logic [CH_CNT - 1 : 0][AXIS_RX_DATA_W - 1 : 0]  rx_guard_tdata;
    logic [CH_CNT - 1 : 0][AXIS_RX_KEEP_W - 1 : 0]  rx_guard_tkeep;
    logic [CH_CNT - 1 : 0]                          rx_guard_tvalid;
    logic [CH_CNT - 1 : 0]                          rx_guard_tlast;
    //
    logic [CH_CNT - 1 : 0][AXIS_RX_DATA_W - 1 : 0]  rx_fifo_tdata;
    logic [CH_CNT - 1 : 0][AXIS_RX_KEEP_W - 1 : 0]  rx_fifo_tkeep;
    logic [CH_CNT - 1 : 0]                          rx_fifo_tvalid;
    logic [CH_CNT - 1 : 0]                          rx_fifo_tlast;


    // Aurora 64b66b IP wrapper
    aurora64b66b_wrp #(
        .CH_CNT     (CH_CNT)            // The number of channels
    )
    the_aurora64b66b_wrp (
        // Common reset
        .reset      (rst),              // i

        // GT reference clock input
        .gt_clk     (gt_clk),           // i

        // Free running clock input
        .init_clk   (init_clk),         // i

        // User reset and clock outputs
        .user_rst   (user_rst),         // o
        .user_clk   (user_clk),         // o

        // GT serial RX
        .gt_rx_p    (gt_rx_p),          // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n    (gt_rx_n),          // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p    (gt_tx_p),          // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n    (gt_tx_n),          // o  [CH_CNT - 1 : 0][1 : 0]

        // Link status
        .channel_up (stat_link_up),     // o  [CH_CNT - 1 : 0]
        .lane_up    (  ),               // o  [CH_CNT - 1 : 0][1 : 0]

        // Error detection status
        .hard_err   (stat_hard_err),    // o  [CH_CNT - 1 : 0]
        .soft_err   (stat_soft_err),    // o  [CH_CNT - 1 : 0]

        // AXIS TX interface
        .tx_tdata   (tx_guard_tdata),   // i  [CH_CNT - 1 : 0][127 : 0]
        .tx_tkeep   (tx_guard_tkeep),   // i  [CH_CNT - 1 : 0][15 : 0]
        .tx_tvalid  (tx_guard_tvalid),  // i  [CH_CNT - 1 : 0]
        .tx_tlast   (tx_guard_tlast),   // i  [CH_CNT - 1 : 0]
        .tx_tready  (tx_guard_tready),  // o  [CH_CNT - 1 : 0]

        // AXIS RX interface
        .rx_tdata   (rx_guard_tdata),   // o  [CH_CNT - 1 : 0][127 : 0]
        .rx_tkeep   (rx_guard_tkeep),   // o  [CH_CNT - 1 : 0][15 : 0]
        .rx_tvalid  (rx_guard_tvalid),  // o  [CH_CNT - 1 : 0]
        .rx_tlast   (rx_guard_tlast)    // o  [CH_CNT - 1 : 0]
    ); // the_aurora64b66b_wrp


    // Gererate the utility units
    generate
        genvar ch;
        for (ch = 0; ch < CH_CNT; ch++) begin: channel_gen

            // Aurora TX FIFO
            aurora_tx_fifo #(
                .DATA_W         (AXIS_TX_DATA_W),               // AXI-S data bus width
                .KEEP_W         (AXIS_TX_KEEP_W),               // AXI-S keep bus width
                .FIFO_DEPTH     (aurora_params::TX_FIFO_DEPTH)  // FIFO depth
            )
            the_aurora_tx_fifo (
                // Reset and clock
                .rst            (user_rst),                     // i
                .clk            (user_clk),                     // i

                // FIFO status
                .fifo_ready     (  ),                           // o

                // Incoming AXI stream
                .i_tdata        (tx_tdata[ch]),                 // i  [DATA_W - 1 : 0]
                .i_tkeep        (tx_tkeep[ch]),                 // i  [KEEP_W - 1 : 0]
                .i_tvalid       (tx_tvalid[ch]),                // i
                .i_tlast        (tx_tlast[ch]),                 // i
                .i_tready       (tx_tready[ch]),                // o

                // TX AXI stream going out
                .o_tdata        (tx_fifo_tdata[ch]),            // o  [DATA_W - 1 : 0]
                .o_tkeep        (tx_fifo_tkeep[ch]),            // o  [KEEP_W - 1 : 0]
                .o_tvalid       (tx_fifo_tvalid[ch]),           // o
                .o_tlast        (tx_fifo_tlast[ch]),            // o
                .o_tready       (tx_fifo_tready[ch])            // i
            ); // the_aurora_tx_fifo


            // Handles the stream going to an Aurora IP in the event
            // of a link failure
            aurora_tx_guard #(
                .DATA_W             (AXIS_TX_DATA_W),           // AXI-S data bus width
                .KEEP_W             (AXIS_TX_KEEP_W)            // AXI-S keep bus width
            )
            the_aurora_tx_guard (
                // Reset and clock
                .rst                (user_rst),                 // i
                .clk                (user_clk),                 // i

                // Link status
                .channel_up         (stat_link_up[ch]),         // i

                // Loss detection
                .loss_data          (stat_tx_data_loss[ch]),    // i
                .loss_frame         (stat_tx_frame_loss[ch]),   // i

                // TX AXI stream coming in from the TX FIFO
                .i_tx_tdata         (tx_fifo_tdata[ch]),        // i  [DATA_W - 1 : 0]
                .i_tx_tkeep         (tx_fifo_tkeep[ch]),        // i  [KEEP_W - 1 : 0]
                .i_tx_tvalid        (tx_fifo_tvalid[ch]),       // i
                .i_tx_tlast         (tx_fifo_tlast[ch]),        // i
                .i_tx_tready        (tx_fifo_tready[ch]),       // o

                // TX AXI stream going out to an Aurora IP
                .o_tx_tdata         (tx_guard_tdata[ch]),       // o  [DATA_W - 1 : 0]
                .o_tx_tkeep         (tx_guard_tkeep[ch]),       // o  [KEEP_W - 1 : 0]
                .o_tx_tvalid        (tx_guard_tvalid[ch]),      // o
                .o_tx_tlast         (tx_guard_tlast[ch]),       // o
                .o_tx_tready        (tx_guard_tready[ch])       // i
            ); // the_aurora_tx_guard


            // Handles the stream coming from an Aurora IP in the event
            // of a link failure or an overflow condition
            aurora_rx_guard #(
                .DATA_W             (AXIS_RX_DATA_W),       // AXI-S data bus width
                .KEEP_W             (AXIS_RX_KEEP_W)        // AXI-S keep bus width
            )
            the_aurora_rx_guard (
                // Reset and clock
                .rst                (user_rst),                 // i
                .clk                (user_clk),                 // i

                // Link status
                .channel_up         (stat_link_up[ch]),         // i

                // FIFO status
                .fifo_ready         (rx_fifo_ready[ch]),        // i
                .fifo_below_lwm     (rx_fifo_below_lwm[ch]),    // i
                .fifo_above_hwm     (rx_fifo_above_hwm[ch]),    // i

                // Loss detection
                .loss_data          (stat_rx_data_loss[ch]),    // i
                .loss_frame         (stat_rx_frame_loss[ch]),   // i

                // RX AXI stream coming in from an Aurora IP
                .i_rx_tdata         (rx_guard_tdata[ch]),       // i  [DATA_W - 1 : 0]
                .i_rx_tkeep         (rx_guard_tkeep[ch]),       // i  [KEEP_W - 1 : 0]
                .i_rx_tvalid        (rx_guard_tvalid[ch]),      // i
                .i_rx_tlast         (rx_guard_tlast[ch]),       // i

                // RX AXI stream going out
                .o_rx_tdata         (rx_fifo_tdata[ch]),        // o  [DATA_W - 1 : 0]
                .o_rx_tkeep         (rx_fifo_tkeep[ch]),        // o  [KEEP_W - 1 : 0]
                .o_rx_tvalid        (rx_fifo_tvalid[ch]),       // o
                .o_rx_tlast         (rx_fifo_tlast[ch])         // o
            ); // the_aurora_rx_guard


            // Aurora RX FIFO
            aurora_rx_fifo #(
                .DATA_W         (AXIS_RX_DATA_W),               // AXI-S data bus width
                .KEEP_W         (AXIS_RX_KEEP_W),               // AXI-S keep bus width
                .FIFO_DEPTH     (aurora_params::RX_FIFO_DEPTH), // FIFO depth
                .FIFO_LWM       (aurora_params::RX_FIFO_LWM),   // FIFO low watermark
                .FIFO_HWM       (aurora_params::RX_FIFO_HWM)    // FIFO high watermark
            )
            the_aurora_rx_fifo (
                // Reset and clock
                .rst            (user_rst),                     // i
                .clk            (user_clk),                     // i

                // FIFO status
                .fifo_ready     (rx_fifo_ready[ch]),            // o
                .fifo_below_lwm (rx_fifo_below_lwm[ch]),        // o
                .fifo_above_hwm (rx_fifo_above_hwm[ch]),        // o

                // Incoming AXI stream (w/o tready)
                .i_tdata        (rx_fifo_tdata[ch]),            // i  [DATA_W - 1 : 0]
                .i_tkeep        (rx_fifo_tkeep[ch]),            // i  [KEEP_W - 1 : 0]
                .i_tvalid       (rx_fifo_tvalid[ch]),           // i
                .i_tlast        (rx_fifo_tlast[ch]),            // i

                // RX AXI stream going out
                .o_tdata        (rx_tdata[ch]),                 // o  [DATA_W - 1 : 0]
                .o_tkeep        (rx_tkeep[ch]),                 // o  [KEEP_W - 1 : 0]
                .o_tvalid       (rx_tvalid[ch]),                // o
                .o_tlast        (rx_tlast[ch]),                 // o
                .o_tready       (rx_tready[ch])                 // i
            ); // the_aurora_rx_fifo

        end // channel_gen
    endgenerate

endmodule: aurora_transport