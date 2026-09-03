/*
    // TIP upstream endpoint router
    tip_up_router the_tip_up_router (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Configuration control
        .up_conf        (), // tip_up_conf_if.slave

        // Streams to/from the transport
        .up_transp_in   (), // axis_if.slave
        .up_transp_out  (), // axis_if.master

        // Control streams: configuration commands/reports
        .conf_cmd_out   (), // axis_if.master
        .conf_rpt_in    (), // axis_if.slave

        // Control streams: user commands/reports
        .user_cmd_out   (), // axis_if.master
        .user_rpt_in    (), // axis_if.slave

        // Streams to/from the downstream endpoint
        .dn_ctrl_in     (), // axis_if.slave
        .dn_ctrl_out    (), // axis_if.master
        .dn_data_in     ()  // axis_if.slave
    ); // the_tip_up_router
*/

module tip_up_router
(
    // Reset and clock
    input  logic            rst,
    input  logic            clk,

    // Configuration control
    tip_up_conf_if.slave    up_conf,

    // Streams to/from the transport
    axis_if.slave           up_transp_in,
    axis_if.master          up_transp_out,

    // Control streams: configuration commands/reports
    axis_if.master          conf_cmd_out,
    axis_if.slave           conf_rpt_in,

    // Control streams: user commands/reports
    axis_if.master          user_cmd_out,
    axis_if.slave           user_rpt_in,

    // Streams to/from the downstream endpoint
    axis_if.slave           dn_ctrl_in,
    axis_if.master          dn_ctrl_out,
    axis_if.slave           dn_data_in
);
    // FIXME:
    assign up_transp_out.tdata = up_transp_out.tdata;
    assign up_transp_out.tkeep = up_transp_out.tkeep;
    assign up_transp_out.tvalid = up_transp_out.tvalid;
    assign up_transp_out.tlast = up_transp_out.tlast;
    assign up_transp_in.tready = up_transp_in.tready;


    // FIXME:
    assign conf_cmd_out.tdata = '0;
    assign conf_cmd_out.tkeep = '0;
    assign conf_cmd_out.tvalid = '0;
    assign conf_cmd_out.tlast = '0;
    assign conf_rpt_in.tready = '1;


    // FIXME:
    assign user_cmd_out.tdata = '0;
    assign user_cmd_out.tkeep = '0;
    assign user_cmd_out.tvalid = '0;
    assign user_cmd_out.tlast = '0;
    assign user_rpt_in.tready = '1;


    // FIXME:
    assign dn_ctrl_out.tdata = '0;
    assign dn_ctrl_out.tkeep = '0;
    assign dn_ctrl_out.tvalid = '0;
    assign dn_ctrl_out.tlast = '0;
    assign dn_ctrl_in.tready = '1;
    assign dn_data_in.tready = '1;

endmodule: tip_up_router