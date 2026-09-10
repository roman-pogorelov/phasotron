/*
    // TIP upstream endpoint
    tip_up_ep #(
        .TYPE_ID        (), // Node type ID
        .FW_REV_ID      ()  // FW revision ID
    )
    the_tip_up_ep (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Upstream tsransport status
        .up_transp_stat (), // tip_transp_stat_if.slave

        // Request interface
        .up_req         (), // tip_up_req_if.master

        // Streams to/from the upstream transport
        .up_transp_in   (), // axis_if.slave
        .up_transp_out  (), // axis_if.master

        // APB3 master to access the user-defined register map
        .user_apb3_m    (), // apb3_if.master

        // APB3 master to control the downstream endpoints
        .dn_apb3_m      (), // apb3_if.master

        // Streams to/from the downstream endpoint
        .dn_ctrl_in     (), // axis_if.slave
        .dn_ctrl_out    (), // axis_if.master
        .dn_data_in     ()  // axis_if.slave
    ); // the_tip_up_ep
*/


module tip_up_ep
#(
    parameter logic [31 : 0]    TYPE_ID     = 32'h00000000, // Node type ID
    parameter logic [31 : 0]    FW_REV_ID   = 32'h00000000  // FW revision ID
)
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // Upstream tsransport status
    tip_transp_stat_if.slave    up_transp_stat,

    // Request interface
    tip_up_req_if.master        up_req,

    // Streams to/from the upstream transport
    axis_if.slave               up_transp_in,
    axis_if.master              up_transp_out,

    // APB3 master to access the user-defined register map
    apb3_if.master              user_apb3_m,

    // APB3 master to control the downstream endpoints
    apb3_if.master              dn_apb3_m,

    // Streams to/from the downstream endpoint
    axis_if.slave               dn_ctrl_in,
    axis_if.master              dn_ctrl_out,
    axis_if.slave               dn_data_in
);
    // Interfaces
    tip_up_conf_if      up_conf();
    //
    axis_if             conf_cmd();
    axis_if             conf_rpt();
    //
    axis_if             user_cmd();
    axis_if             user_rpt();
    //
    apb3_if             conf_apb3();


    // TIP upstream endpoint router
    tip_up_router the_tip_up_router (
        // Reset and clock
        .rst            (rst),              // i
        .clk            (clk),              // i

        // Configuration control
        .up_conf        (up_conf),          // tip_up_conf_if.slave

        // Streams to/from the transport
        .up_transp_in   (up_transp_in),     // axis_if.slave
        .up_transp_out  (up_transp_out),    // axis_if.master

        // Control streams: configuration commands/reports
        .conf_cmd_out   (conf_cmd),         // axis_if.master
        .conf_rpt_in    (conf_rpt),         // axis_if.slave

        // Control streams: user commands/reports
        .user_cmd_out   (user_cmd),         // axis_if.master
        .user_rpt_in    (user_rpt),         // axis_if.slave

        // Streams to/from the downstream endpoint
        .dn_ctrl_in     (dn_ctrl_in),       // axis_if.slave
        .dn_ctrl_out    (dn_ctrl_out),      // axis_if.master
        .dn_data_in     (dn_data_in)        // axis_if.slave
    ); // the_tip_up_router


    // Converts TIP AXIS packets into APB3 transactions and
    // converts APB3 responses back into TIP AXIS packets
    tip_axis_apb3_bridge  #(
        .RPT_TYPE   (0)             // Report type: 0 - configuration report, 1 - user report
    )
    tip_axis_apb3_bridge_conf (
        // Reset and clock
        .rst        (rst),          // i
        .clk        (clk),          // i

        // Configuration interface
        .conf       (up_conf),      // tip_up_conf_if.slave

        // Control streams
        .ctrl_in    (conf_cmd),     // axis_if.slave
        .ctrl_out   (conf_rpt),     // axis_if.master

        // APB3 master
        .apb3_m     (conf_apb3)     // apb3_if.master
    ); // tip_axis_apb3_bridge_conf


    // TIP upstream endpoint configuration unit
    tip_up_conf #(
        .TYPE_ID        (TYPE_ID),          // Node type ID
        .FW_REV_ID      (FW_REV_ID)         // FW revision ID
    )
    the_tip_up_conf (
        // Reset and clock
        .rst            (rst),              // i
        .clk            (clk),              // i

        // Transport status interface
        .up_transp_stat (up_transp_stat),   // tip_transp_stat_if.slave

        // Configuration control
        .up_conf        (up_conf),          // tip_up_conf_if.master

        // APB3 slave interface
        .apb3_s         (conf_apb3),        // apb3_if.slave

        // APB3 msater interface
        .dn_apb3_m      (dn_apb3_m),        // apb3_if.master

        // Request interface
        .up_req         (up_req)            // tip_up_req_if.master
    ); // the_tip_up_conf


    // Converts TIP AXIS packets into APB3 transactions and
    // converts APB3 responses back into TIP AXIS packets
    tip_axis_apb3_bridge #(
        .RPT_TYPE   (1)             // Report type: 0 - configuration report, 1 - user report
    )
    tip_axis_apb3_bridge_user (
        // Reset and clock
        .rst        (rst),          // i
        .clk        (clk),          // i

        // Configuration interface
        .conf       (up_conf),      // tip_up_conf_if.slave

        // Control streams
        .ctrl_in    (user_cmd),     // axis_if.slave
        .ctrl_out   (user_rpt),     // axis_if.master

        // APB3 master
        .apb3_m     (user_apb3_m)   // apb3_if.master
    ); // tip_axis_apb3_bridge_user

endmodule: tip_up_ep