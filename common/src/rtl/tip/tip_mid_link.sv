/*
    // TIP midstream link
    tip_mid_link #(
        .TYPE_ID        (), // Node type ID
        .FW_REV_ID      (), // FW revision ID
        .DN_CNT         ()  // Number of downstream links
    )
    the_tip_mid_link (
        // Common reset
        .rst            (), // i

        // GT reference clock input
        .gt_clk         (), // i

        // Free running clock input
        .init_clk       (), // i

        // User reset and clock outputs
        .user_rst       (), // i
        .user_clk       (), // i

        // GT serial RX (upstream link)
        .up_gt_rx_p     (), // i  [1 : 0]
        .up_gt_rx_n     (), // i  [1 : 0]

        // GT serial TX (upstream link)
        .up_gt_tx_p     (), // o  [1 : 0]
        .up_gt_tx_n     (), // o  [1 : 0]

        // GT serial RX (downstream link)
        .dn_gt_rx_p     (), // i  [DN_CNT - 1 : 0][1 : 0]
        .dn_gt_rx_n     (), // i  [DN_CNT - 1 : 0][1 : 0]

        // GT serial TX (downstream link)
        .dn_gt_tx_p     (), // o  [DN_CNT - 1 : 0][1 : 0]
        .dn_gt_tx_n     (), // o  [DN_CNT - 1 : 0][1 : 0]

        // APB3 master to access the user-defined register map @ user_clk
        .user_apb3_m    (), // apb3_if.master

        // Data streams to the upstream / from the downstream links @ user_clk
        .up_data_in     (), // axis_if.slave
        .dn_data_out    ()  // axis_if[DN_CNT].master
    ); // the_tip_mid_link
*/


module tip_mid_link
#(
    parameter logic [31 : 0]                TYPE_ID     = 32'h00000000, // Node type ID
    parameter logic [31 : 0]                FW_REV_ID   = 32'h00000000, // FW revision ID

    parameter int unsigned                  DN_CNT      = 1             // Number of downstream links
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

    // GT serial RX (upstream link)
    input  logic [1 : 0]                    up_gt_rx_p,
    input  logic [1 : 0]                    up_gt_rx_n,

    // GT serial TX (upstream link)
    output logic [1 : 0]                    up_gt_tx_p,
    output logic [1 : 0]                    up_gt_tx_n,

    // GT serial RX (downstream link)
    input  logic [DN_CNT - 1 : 0][1 : 0]    dn_gt_rx_p,
    input  logic [DN_CNT - 1 : 0][1 : 0]    dn_gt_rx_n,

    // GT serial TX (downstream link)
    output logic [DN_CNT - 1 : 0][1 : 0]    dn_gt_tx_p,
    output logic [DN_CNT - 1 : 0][1 : 0]    dn_gt_tx_n,

    // APB3 master to access the user-defined register map @ user_clk
    apb3_if.master                          user_apb3_m,

    // Data streams to the upstream / from the downstream links @ user_clk
    axis_if.slave                           up_data_in,
    axis_if.master                          dn_data_out[DN_CNT]
);
    // Interfaces
    tip_transp_stat_if      status[DN_CNT + 1]();
    tip_transp_stat_if      status_dn[DN_CNT]();
    //
    axis_if                 transp_rx[DN_CNT + 1]();
    axis_if                 transp_rx_dn[DN_CNT]();
    axis_if                 transp_tx[DN_CNT + 1]();
    axis_if                 transp_tx_dn[DN_CNT]();
    //
    tip_up_req_if           up_req();


    // TIP midstream endpoint
    tip_mid_ep #(
        .TYPE_ID        (TYPE_ID),              // Node type ID
        .FW_REV_ID      (FW_REV_ID),            // FW revision ID
        .DN_CNT         (DN_CNT)                // Number of downstream links
    )
    the_tip_mid_ep (
        // Reset and clock
        .rst            (rst),                  // i
        .clk            (clk),                  // i

        // Upstream/downstream tsransport status
        .up_transp_stat (status[DN_CNT]),       // tip_transp_stat_if.slave
        .dn_transp_stat (status_dn),            // tip_transp_stat_if[DN_CNT].slave

        // Request interface
        .up_req         (up_req),               // tip_up_req_if.master

        // Streams to/from the upstream/downstream transport
        .up_transp_in   (transp_rx[DN_CNT]),    // axis_if.slave
        .up_transp_out  (transp_tx[DN_CNT]),    // axis_if.master
        .dn_transp_in   (transp_rx_dn),         // axis_if[DN_CNT].slave
        .dn_transp_out  (transp_tx_dn),         // axis_if[DN_CNT].master

        // APB3 master to access the user-defined register map
        .user_apb3_m    (user_apb3_m),          // apb3_if.master

        // Streams to/from the upstream/downstream endpoints
        .up_data_in     (up_data_in),           // axis_if.slave
        .dn_data_out    (dn_data_out)           // axis_if[DN_CNT].master
    ); // the_tip_mid_ep


    // TIP transport
    tip_transport #(
        .CH_CNT     (DN_CNT + 1)                // The number of channels
    )
    the_tip_transport (
        // Common reset
        .rst        (rst),                      // i

        // GT reference clock input
        .gt_clk     (gt_clk),                   // i

        // Free running clock input
        .init_clk   (init_clk),                 // i

        // User reset and clock outputs
        .user_rst   (user_rst),                 // i
        .user_clk   (user_clk),                 // i

        // GT serial RX
        .gt_rx_p    ({up_gt_rx_p, dn_gt_rx_p}), // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n    ({up_gt_rx_n, dn_gt_rx_n}), // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p    ({up_gt_tx_p, dn_gt_tx_p}), // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n    ({up_gt_tx_n, dn_gt_tx_n}), // o  [CH_CNT - 1 : 0][1 : 0]

        // Status interface
        .status     (status),                   // tip_transp_stat_if[CH_CNT].master

        // AXIS interface to the transport level
        .tx         (transp_tx),                // axis_if[CH_CNT].slave,

        // AXIS interface from the transport level
        .rx         (transp_rx)                 // axis_if[CH_CNT].master
    ); // the_tip_transport


    // Generate interface connections
    generate
        genvar i;
        for (i = 0; i < DN_CNT; i++) begin: if_connection

            // Connects TIP transport status interfaces
            tip_transp_stat_connect tip_transp_stat_connect_dn (
                // Slave interface
                .s      (status[i]),        // tip_transp_stat_if.slave

                // Master interface
                .m      (status_dn[i])      // tip_transp_stat_if.master
            ); // tip_transp_stat_connect_dn


            axis_if_connect axis_if_connect_tx (
                // Slave interface
                .s      (transp_tx_dn[i]),  // axis_if.slave

                // Master interface
                .m      (transp_tx[i])      // axis_if.master
            ); // axis_if_connect_tx


            axis_if_connect axis_if_connect_rx (
                // Slave interface
                .s      (transp_rx[i]),     // axis_if.slave

                // Master interface
                .m      (transp_rx_dn[i])   // axis_if.master
            ); // axis_if_connect_rx

        end // if_connection
    endgenerate

endmodule: tip_mid_link