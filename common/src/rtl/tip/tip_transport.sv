/*
    // TIP transport
    tip_transport #(
        .CH_CNT     ()  // The number of channels
    )
    the_tip_transport (
        // Common reset
        .rst        (), // i

        // GT reference clock input
        .gt_clk     (), // i

        // Free running clock input
        .init_clk   (), // i

        // User reset and clock outputs
        .user_rst   (), // i
        .user_clk   (), // i

        // GT serial RX
        .gt_rx_p    (), // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n    (), // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p    (), // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n    (), // o  [CH_CNT - 1 : 0][1 : 0]

        // Status interface
        .status     (), // tip_transp_stat_if[CH_CNT].master

        // AXIS interface to the transport level
        .tx         (), // axis_if[CH_CNT].slave,

        // AXIS interface from the transport level
        .rx         ()  // axis_if[CH_CNT].master
    ); // the_tip_transport
*/

import tip_defs::*;

module tip_transport
#(
    parameter int unsigned                      CH_CNT  = 1 // The number of channels
)
(
    // Common reset
    input  logic                                rst,

    // GT reference clock input
    input  logic                                gt_clk,

    // Free running clock input
    input  logic                                init_clk,

    // User reset and clock outputs
    output logic                                user_rst,
    output logic                                user_clk,

    // GT serial RX
    input  logic [CH_CNT - 1 : 0][1 : 0]        gt_rx_p,
    input  logic [CH_CNT - 1 : 0][1 : 0]        gt_rx_n,

    // GT serial TX
    output logic [CH_CNT - 1 : 0][1 : 0]        gt_tx_p,
    output logic [CH_CNT - 1 : 0][1 : 0]        gt_tx_n,

    // Status interface
    tip_transp_stat_if.master                   status[CH_CNT],

    // AXIS interface to the transport level
    axis_if.slave                               tx[CH_CNT],

    // AXIS interface from the transport level
    axis_if.master                              rx[CH_CNT]
);
    // Variables
    logic [CH_CNT - 1 : 0]                              stat_link_up;
    logic [CH_CNT - 1 : 0]                              stat_soft_err;
    logic [CH_CNT - 1 : 0]                              stat_hard_err;
    logic [CH_CNT - 1 : 0]                              stat_rx_data_loss;
    logic [CH_CNT - 1 : 0]                              stat_rx_frame_loss;
    logic [CH_CNT - 1 : 0]                              stat_tx_data_loss;
    logic [CH_CNT - 1 : 0]                              stat_tx_frame_loss;
    //
    logic [CH_CNT - 1 : 0][TIP_AXIS_TDATA_W - 1 : 0]    tx_tdata;
    logic [CH_CNT - 1 : 0][TIP_AXIS_TKEEP_W - 1 : 0]    tx_tkeep;
    logic [CH_CNT - 1 : 0]                              tx_tvalid;
    logic [CH_CNT - 1 : 0]                              tx_tlast;
    logic [CH_CNT - 1 : 0]                              tx_tready;
    //
    logic [CH_CNT - 1 : 0][TIP_AXIS_TDATA_W - 1 : 0]    rx_tdata;
    logic [CH_CNT - 1 : 0][TIP_AXIS_TKEEP_W - 1 : 0]    rx_tkeep;
    logic [CH_CNT - 1 : 0]                              rx_tvalid;
    logic [CH_CNT - 1 : 0]                              rx_tlast;
    logic [CH_CNT - 1 : 0]                              rx_tready;


    // Connect interface/structure arrays
    generate
        genvar ch;
        for (ch = 0; ch < CH_CNT; ch++) begin: axis_if_conn
            assign status[ch].link_up       = stat_link_up[ch];
            assign status[ch].soft_err      = stat_soft_err[ch];
            assign status[ch].hard_err      = stat_hard_err[ch];
            assign status[ch].rx_data_loss  = stat_rx_data_loss[ch];
            assign status[ch].rx_frame_loss = stat_rx_frame_loss[ch];
            assign status[ch].tx_data_loss  = stat_tx_data_loss[ch];
            assign status[ch].tx_frame_loss = stat_tx_frame_loss[ch];
            //
            assign tx_tdata[ch]  = tx[ch].tdata;
            assign tx_tkeep[ch]  = tx[ch].tkeep;
            assign tx_tvalid[ch] = tx[ch].tvalid;
            assign tx_tlast[ch]  = tx[ch].tlast;
            assign tx[ch].tready = tx_tready[ch];
            //
            assign rx[ch].tdata  = rx_tdata[ch];
            assign rx[ch].tkeep  = rx_tkeep[ch];
            assign rx[ch].tvalid = rx_tvalid[ch];
            assign rx[ch].tlast  = rx_tlast[ch];
            assign rx_tready[ch] = rx[ch].tready;
        end // axis_if_conn
    endgenerate


    // Aurora-based transport
    aurora_transport #(
        .CH_CNT                 (CH_CNT)                // The number of channels
    )
    the_aurora_transport (
        // Common reset
        .rst                    (rst),                  // i

        // GT reference clock input
        .gt_clk                 (gt_clk),               // i

        // Free running clock input
        .init_clk               (init_clk),             // i

        // User reset and clock outputs
        .user_rst               (user_rst),             // o
        .user_clk               (user_clk),             // o

        // GT serial RX
        .gt_rx_p                (gt_rx_p),              // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n                (gt_rx_n),              // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p                (gt_tx_p),              // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n                (gt_tx_n),              // o  [CH_CNT - 1 : 0][1 : 0]

        // Status
        .stat_link_up           (stat_link_up),         // o  [CH_CNT - 1 : 0]
        .stat_soft_err          (stat_soft_err),        // o  [CH_CNT - 1 : 0]
        .stat_hard_err          (stat_hard_err),        // o  [CH_CNT - 1 : 0]
        .stat_rx_data_loss      (stat_rx_data_loss),    // o  [CH_CNT - 1 : 0]
        .stat_rx_frame_loss     (stat_rx_frame_loss),   // o  [CH_CNT - 1 : 0]
        .stat_tx_data_loss      (stat_tx_data_loss),    // o  [CH_CNT - 1 : 0]
        .stat_tx_frame_loss     (stat_tx_frame_loss),   // o  [CH_CNT - 1 : 0]

        // AXIS TX interface
        .tx_tdata               (tx_tdata),             // i  [CH_CNT - 1 : 0][127 : 0]
        .tx_tkeep               (tx_tkeep),             // i  [CH_CNT - 1 : 0][15 : 0]
        .tx_tvalid              (tx_tvalid),            // i  [CH_CNT - 1 : 0]
        .tx_tlast               (tx_tlast),             // i  [CH_CNT - 1 : 0]
        .tx_tready              (tx_tready),            // o  [CH_CNT - 1 : 0]

        // AXIS RX interface
        .rx_tdata               (rx_tdata),             // o  [CH_CNT - 1 : 0][127 : 0]
        .rx_tkeep               (rx_tkeep),             // o  [CH_CNT - 1 : 0][15 : 0]
        .rx_tvalid              (rx_tvalid),            // o  [CH_CNT - 1 : 0]
        .rx_tlast               (rx_tlast),             // o  [CH_CNT - 1 : 0]
        .rx_tready              (rx_tready)             // i  [CH_CNT - 1 : 0]
    ); // the_aurora_transport

endmodule: tip_transport