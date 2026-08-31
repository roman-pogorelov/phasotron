/*
    // TIP downstream endpoint
    tip_dn_ep the_tip_dn_ep (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Downstream tsransport status
        .dn_transp_stat (), // tip_transp_stat_if.slave

        // Streams to/from the downstream transport
        .dn_transp_in   (), // axis_if.slave
        .dn_transp_out  (), // axis_if.master

        // APB3 slave to control the downstream endpoint
        .dn_apb3_s      (), // apb3_if.slave

        // Streams to/from the upstream endpoint
        .up_ctrl_in     (), // axis_if.slave
        .up_ctrl_out    (), // axis_if.master
        .up_data_out    ()  // axis_if.master
    ); // the_tip_dn_ep
*/


module tip_dn_ep
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // Downstream tsransport status
    tip_transp_stat_if.slave    dn_transp_stat,

    // Streams to/from the downstream transport
    axis_if.slave               dn_transp_in,
    axis_if.master              dn_transp_out,

    // APB3 slave to control the downstream endpoint
    apb3_if.slave               dn_apb3_s,

    // Streams to/from the upstream endpoint
    axis_if.slave               up_ctrl_in,
    axis_if.master              up_ctrl_out,
    axis_if.master              up_data_out
);
    // FIXME: loopback the transport streams
    assign dn_transp_in.tdata = dn_transp_out.tdata;
    assign dn_transp_in.tkeep = dn_transp_out.tkeep;
    assign dn_transp_in.tvalid = dn_transp_out.tvalid;
    assign dn_transp_in.tlast = dn_transp_out.tlast;
    assign dn_transp_out.tready = dn_transp_in.tready;


    // FIXME: terminate dn_apb3_s
    assign dn_apb3_s.pready = '1;
    assign dn_apb3_s.prdata = '0;
    assign dn_apb3_s.pslverr = '0;


    // FIXME: do not send anything to the upstream endpoint
    assign up_ctrl_out.tdata = '0;
    assign up_ctrl_out.tkeep = '0;
    assign up_ctrl_out.tvalid = '0;
    assign up_ctrl_out.tlast = '0;
    //
    assign up_data_out.tdata = '0;
    assign up_data_out.tkeep = '0;
    assign up_data_out.tvalid = '0;
    assign up_data_out.tlast = '0;

    // FIXME: remove everything received from upstream endpoint
    assign up_ctrl_in.tready = '1;

endmodule: tip_dn_ep