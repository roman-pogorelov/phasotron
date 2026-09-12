/*
    // TIP upstream link
    tip_up_link #(
        .TYPE_ID        (), // Node type ID
        .FW_REV_ID      ()  // FW revision ID
    )
    the_tip_up_link (
        // GT reference clock input
        .gt_clk         (), // i

        // Free running clock input
        .init_clk       (), // i

        // User reset and clock outputs
        .user_rst       (), // o
        .user_clk       (), // o

        // GT serial RX
        .gt_rx_p        (), // i  [1 : 0]
        .gt_rx_n        (), // i  [1 : 0]

        // GT serial TX
        .gt_tx_p        (), // o  [1 : 0]
        .gt_tx_n        (), // o  [1 : 0]

        // APB3 master to access the user-defined register map @ user_clk
        .user_apb3_m    (), // apb3_if.master

        // Data stream to upstream link @ user_clk
        .up_data_in     ()  // axis_if.slave
    ); // the_tip_up_link
*/


module tip_up_link
#(
    parameter logic [31 : 0]    TYPE_ID     = 32'h00000000, // Node type ID
    parameter logic [31 : 0]    FW_REV_ID   = 32'h00000000  // FW revision ID
)
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

    // APB3 master to access the user-defined register map @ user_clk
    apb3_if.master              user_apb3_m,

    // Data stream to upstream link @ user_clk
    axis_if.slave               up_data_in
);
    // Variables
    logic                       rst;


    // Itrefaces
    axis_if                     transp_rx[1]();
    axis_if                     transp_tx[1]();
    //
    axis_if                     dn_ctrl_in();
    axis_if                     dn_ctrl_out();
    //
    apb3_if                     dn_apb3();
    //
    tip_transp_stat_if          status[1]();
    //
    tip_up_req_if               up_req();


    // TIP reset unit
    tip_reset the_tip_reset (
        // Free running clock input
        .init_clk   (init_clk),     // i

        // User reset and clock inputs
        .user_rst   (user_rst),     // i
        .user_clk   (user_clk),     // i

        // Reset request input @ user_clk
        .rst_req    (up_req.reset), // i

        // Common reset output
        .rst_out    (rst)           // o
    ); // the_tip_reset


    // TIP upstream endpoint
    tip_up_ep #(
        .TYPE_ID        (TYPE_ID),      // Node type ID
        .FW_REV_ID      (FW_REV_ID)     // FW revision ID
    )
    the_tip_up_ep (
        // Reset and clock
        .rst            (user_rst),     // i
        .clk            (user_clk),     // i

        // Upstream tsransport status
        .up_transp_stat (status[0]),    // tip_transp_stat_if.slave

        // Request interface
        .up_req         (up_req),       // tip_up_req_if.master

        // Streams to/from the upstream transport
        .up_transp_in   (transp_rx[0]), // axis_if.slave
        .up_transp_out  (transp_tx[0]), // axis_if.master

        // APB3 master to access the user-defined register map
        .user_apb3_m    (user_apb3_m),  // apb3_if.master

        // APB3 master to control the downstream endpoints
        .dn_apb3_m      (dn_apb3),      // apb3_if.master

        // Streams to/from the downstream endpoint
        .dn_ctrl_in     (dn_ctrl_in),   // axis_if.slave
        .dn_ctrl_out    (dn_ctrl_out),  // axis_if.master
        .dn_data_in     (up_data_in)    // axis_if.slave
    ); // the_tip_up_ep


    // TIP transport
    tip_transport #(
        .CH_CNT     (1)             // The number of channels
    )
    tip_transport_up_link (
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
    ); // tip_transport_up_link


    // No downstream endpoins
    assign dn_ctrl_in.tdata = '0;
    assign dn_ctrl_in.tkeep = '0;
    assign dn_ctrl_in.tvalid = '0;
    assign dn_ctrl_in.tlast = '0;
    //
    assign dn_ctrl_out.tready = 1'b1;
    //
    assign dn_apb3.pready = '1;
    assign dn_apb3.prdata = '0;
    assign dn_apb3.pslverr = '0;

endmodule: tip_up_link