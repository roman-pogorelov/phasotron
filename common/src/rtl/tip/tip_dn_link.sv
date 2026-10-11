/*
    // TIP downstream link
    tip_dn_link the_tip_dn_link (
        // GT reference clock input
        .gt_clk         (), // i

        // Free running clock input
        .init_clk       (), // i

        // User reset and clock outputs
        .user_rst       (), // i
        .user_clk       (), // i

        // GT serial RX
        .gt_rx_p        (), // i  [1 : 0]
        .gt_rx_n        (), // i  [1 : 0]

        // GT serial TX
        .gt_tx_p        (), // o  [1 : 0]
        .gt_tx_n        (), // o  [1 : 0]

        // APB3 slave to control the downstream endpoint @ user_clk
        .dn_apb3_s      (), // apb3_if.slave

        // Streams to/from the upstream endpoint @ user_clk
        .up_ctrl_in     (), // axis_if.slave
        .up_ctrl_out    (), // axis_if.master
        .up_data_out    ()  // axis_if.master
    ); // the_tip_dn_link
*/


module tip_dn_link
(
    // GT reference clock input
    input  logic                gt_clk,

    // Free running clock input
    input  logic                init_clk,

    // User reset and clock outputs
    output logic                user_rst,
    output logic                user_clk,

    // GT serial RX
    input  logic [1 : 0]        gt_rx_p,
    input  logic [1 : 0]        gt_rx_n,

    // GT serial TX
    output logic [1 : 0]        gt_tx_p,
    output logic [1 : 0]        gt_tx_n,

    // APB3 slave to control the downstream endpoint @ user_clk
    apb3_if.slave               dn_apb3_s,

    // Streams to/from the upstream endpoint @ user_clk
    axis_if.slave               up_ctrl_in,
    axis_if.master              up_ctrl_out,
    axis_if.master              up_data_out
);
    // Variables
    logic                   rst;


    // Interfaces
    tip_transp_stat_if      status[1]();
    //
    axis_if                 transp_rx[1]();
    axis_if                 transp_tx[1]();


    // TIP reset unit
    tip_reset the_tip_reset (
        // Free running clock input
        .init_clk   (init_clk), // i

        // User reset and clock inputs
        .user_rst   (user_rst), // i
        .user_clk   (user_clk), // i

        // Reset request input @ user_clk
        .rst_req    (1'b0),     // i

        // Common reset output
        .rst_out    (rst)       // o
    ); // the_tip_reset


    // TIP downstream endpoint
    tip_dn_ep #(
        .DN_ID          (0)             // Downstream endpoint ID
    )
    the_tip_dn_ep (
        // Reset and clock
        .rst            (user_rst),     // i
        .clk            (user_clk),     // i

        // Downstream tsransport status
        .dn_transp_stat (status[0]),    // tip_transp_stat_if.slave

        // Streams to/from the downstream transport
        .dn_transp_in   (transp_rx[0]), // axis_if.slave
        .dn_transp_out  (transp_tx[0]), // axis_if.master

        // APB3 slave to control the downstream endpoint
        .dn_apb3_s      (dn_apb3_s),    // apb3_if.slave

        // Streams to/from the upstream endpoint
        .up_ctrl_in     (up_ctrl_in),   // axis_if.slave
        .up_ctrl_out    (up_ctrl_out),  // axis_if.master
        .up_data_out    (up_data_out)   // axis_if.master
    ); // the_tip_dn_ep


    // TIP transport
    tip_transport #(
        .CH_CNT     (1)             // The number of channels
    )
    the_tip_transport (
        // Common reset
        .rst        (rst),          // i

        // GT reference clock input
        .gt_clk     (gt_clk),       // i

        // Free running clock input
        .init_clk   (init_clk),     // i

        // User reset and clock outputs
        .user_rst   (user_rst),     // i
        .user_clk   (user_clk),     // i

        // GT serial RX
        .gt_rx_p    (gt_rx_p),      // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n    (gt_rx_n),      // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p    (gt_tx_p),      // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n    (gt_tx_n),      // o  [CH_CNT - 1 : 0][1 : 0]

        // Status interface
        .status     (status),       // tip_transp_stat_if[CH_CNT].master

        // AXIS interface to the transport level
        .tx         (transp_tx),    // axis_if[CH_CNT].slave,

        // AXIS interface from the transport level
        .rx         (transp_rx)     // axis_if[CH_CNT].master
    ); // the_tip_transport


endmodule: tip_dn_link