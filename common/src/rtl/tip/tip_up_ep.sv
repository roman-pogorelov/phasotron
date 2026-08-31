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
    // FIXME: loopback the transport streams
    assign up_transp_in.tdata = up_transp_out.tdata;
    assign up_transp_in.tkeep = up_transp_out.tkeep;
    assign up_transp_in.tvalid = up_transp_out.tvalid;
    assign up_transp_in.tlast = up_transp_out.tlast;
    assign up_transp_out.tready = up_transp_in.tready;


    // FIXME: do not drive user_apb3_m
    assign user_apb3_m.paddr = '0;
    assign user_apb3_m.psel = '0;
    assign user_apb3_m.penable = '0;
    assign user_apb3_m.pwrite = '0;
    assign user_apb3_m.pwdata = '0;


    // FIXME: do not drive user_apb3_m
    assign dn_apb3_m.paddr = '0;
    assign dn_apb3_m.psel = '0;
    assign dn_apb3_m.penable = '0;
    assign dn_apb3_m.pwrite = '0;
    assign dn_apb3_m.pwdata = '0;


    // FIXME: do not send anything to the downstream endpoint
    assign dn_ctrl_out.tdata = '0;
    assign dn_ctrl_out.tkeep = '0;
    assign dn_ctrl_out.tvalid = '0;
    assign dn_ctrl_out.tlast = '0;

    // FIXME: remove everything received from downstream endpoint
    assign dn_ctrl_in.tready = '1;
    assign dn_data_in.tready = '1;

endmodule: tip_up_ep