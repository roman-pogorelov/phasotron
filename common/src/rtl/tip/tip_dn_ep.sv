/*
    // TIP downstream endpoint
    tip_dn_ep #(
        .DN_ID          ()  // Downstream endpoint ID
    )
    the_tip_dn_ep (
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
#(
    parameter int unsigned      DN_ID = 0   // Downstream endpoint ID
)
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
    // Interfaces
    tip_dn_ctrl_if  dn_ctrl();


    // TIP downstream endpoint configuration unit
    tip_dn_conf #(
        .DN_ID          (DN_ID)             // Downstream endpoint ID
    )
    the_tip_dn_conf (
        // Reset and clock
        .rst            (rst),              // i
        .clk            (clk),              // i

        // APB3 slave interface
        .dn_apb3_s      (dn_apb3_s),        // apb3_if.slave

        // Downstream control interface
        .dn_ctrl        (dn_ctrl),          // tip_dn_ctrl_if.master

        // Transport status interface
        .dn_transp_stat (dn_transp_stat)    // tip_transp_stat_if.slave
    ); // the_tip_dn_conf


    // TIP downstream endpoint router
    tip_dn_router the_tip_dn_router (
        // Reset and clock
        .rst            (rst),                  // i
        .clk            (clk),                  // i

        // Control
        .dn_ctrl        (dn_ctrl),              // tip_dn_ctrl_if.slave

        // Streams to/from the transport
        .dn_transp_in   (dn_transp_in),         // axis_if.slave
        .dn_transp_out  (dn_transp_out),        // axis_if.master

        // Streams to/from the upstream endpoint
        .up_ctrl_in     (up_ctrl_in),           // axis_if.slave
        .up_ctrl_out    (up_ctrl_out),          // axis_if.master
        .up_data_out    (up_data_out)           // axis_if.master
    ); // the_tip_dn_router

endmodule: tip_dn_ep