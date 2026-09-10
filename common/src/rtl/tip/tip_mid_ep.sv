/*
    // TIP midstream endpoint
    tip_mid_ep #(
        .TYPE_ID        (), // Node type ID
        .FW_REV_ID      (), // FW revision ID
        .DN_CNT         ()  // Number of downstream links
    )
    the_tip_mid_ep (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Upstream/downstream tsransport status
        .up_transp_stat (), // tip_transp_stat_if.slave
        .dn_transp_stat (), // tip_transp_stat_if[DN_CNT].slave

        // Request interface
        .up_req         (), // tip_up_req_if.master

        // Streams to/from the upstream/downstream transport
        .up_transp_in   (), // axis_if.slave
        .up_transp_out  (), // axis_if.master
        .dn_transp_in   (), // axis_if[DN_CNT].slave
        .dn_transp_out  (), // axis_if[DN_CNT].master

        // APB3 master to access the user-defined register map
        .user_apb3_m    (), // apb3_if.master

        // Streams to/from the upstream/downstream endpoints
        .up_data_in     (), // axis_if.slave
        .dn_data_out    ()  // axis_if[DN_CNT].master
    ); // the_tip_mid_ep
*/


module tip_mid_ep
#(
    parameter logic [31 : 0]    TYPE_ID     = 32'h00000000, // Node type ID
    parameter logic [31 : 0]    FW_REV_ID   = 32'h00000000, // FW revision ID

    parameter int unsigned      DN_CNT      = 1             // Number of downstream links
)
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // Upstream/downstream tsransport status
    tip_transp_stat_if.slave    up_transp_stat,
    tip_transp_stat_if.slave    dn_transp_stat[DN_CNT],

    // Request interface
    tip_up_req_if.master        up_req,

    // Streams to/from the upstream/downstream transport
    axis_if.slave               up_transp_in,
    axis_if.master              up_transp_out,
    axis_if.slave               dn_transp_in[DN_CNT],
    axis_if.master              dn_transp_out[DN_CNT],

    // APB3 master to access the user-defined register map
    apb3_if.master              user_apb3_m,

    // Streams to/from the upstream/downstream endpoints
    axis_if.slave               up_data_in,
    axis_if.master              dn_data_out[DN_CNT]
);
    // Interfaces
    apb3_if     up_apb3();
    apb3_if     dn_apb3[DN_CNT]();
    //
    axis_if     up_ctrl_in();
    axis_if     up_ctrl_out();
    //
    axis_if     dn_ctrl_in[DN_CNT]();
    axis_if     dn_ctrl_out[DN_CNT]();


    // TIP upstream endpoint
    tip_up_ep #(
        .TYPE_ID        (TYPE_ID),          // Node type ID
        .FW_REV_ID      (FW_REV_ID)         // FW revision ID
    )
    the_tip_up_ep (
        // Reset and clock
        .rst            (rst),              // i
        .clk            (clk),              // i

        // Upstream tsransport status
        .up_transp_stat (up_transp_stat),   // tip_transp_stat_if.slave

        // Request interface
        .up_req         (up_req),           // tip_up_req_if.master

        // Streams to/from the upstream transport
        .up_transp_in   (up_transp_in),     // axis_if.slave
        .up_transp_out  (up_transp_out),    // axis_if.master

        // APB3 master to access the user-defined register map
        .user_apb3_m    (user_apb3_m),      // apb3_if.master

        // APB3 master to control the downstream endpoints
        .dn_apb3_m      (up_apb3),          // apb3_if.master

        // Streams to/from the downstream endpoint
        .dn_ctrl_in     (up_ctrl_out),      // axis_if.slave
        .dn_ctrl_out    (up_ctrl_in),       // axis_if.master
        .dn_data_in     (up_data_in)        // axis_if.slave
    ); // the_tip_up_ep


    // Generate a number of downstream endpoints
    generate
        genvar i;
        for (i = 0; i < DN_CNT; i++) begin: dn_ep_gen

            // TIP downstream endpoint
            tip_dn_ep #(
                .DN_ID          (i)                     // Downstream endpoint ID
            )
            the_tip_dn_ep (
                // Reset and clock
                .rst            (rst),                  // i
                .clk            (clk),                  // i

                // Downstream tsransport status
                .dn_transp_stat (dn_transp_stat[i]),    // tip_transp_stat_if.slave

                // Streams to/from the downstream transport
                .dn_transp_in   (dn_transp_in[i]),      // axis_if.slave
                .dn_transp_out  (dn_transp_out[i]),     // axis_if.master

                // APB3 slave to control the downstream endpoint
                .dn_apb3_s      (dn_apb3[i]),           // apb3_if.slave

                // Streams to/from the upstream endpoint
                .up_ctrl_in     (dn_ctrl_out[i]),       // axis_if.slave
                .up_ctrl_out    (dn_ctrl_in[i]),        // axis_if.master
                .up_data_out    (dn_data_out[i])        // axis_if.master
            ); // the_tip_dn_ep

        end // dn_ep_gen
    endgenerate


    // AXIS interconnect routing control packets
    // between the upstream and downstream endpoints
    tip_mid_axis_intcon #(
        .DN_CNT         (DN_CNT)        // Number of downstream links
    )
    the_tip_mid_axis_intcon (
        // Reset and clock
        .rst            (rst),          // i
        .clk            (clk),          // i

        // Streams to/from the upstream endpoint
        .up_ctrl_in     (up_ctrl_in),   // axis_if.slave
        .up_ctrl_out    (up_ctrl_out),  // axis_if.master

        // Streams to/from the downstream endpoints
        .dn_ctrl_in     (dn_ctrl_in),   // axis_if[DN_CNT].slave
        .dn_ctrl_out    (dn_ctrl_out)   // axis_if[DN_CNT].master
    ); // the_tip_mid_axis_intcon


    // APB3 interconnect routing downstream control transactions
    // driven by the upstream endpoint
    tip_mid_apb3_intcon #(
        .DN_CNT         (DN_CNT)        // Number of downstream links
    )
    tip_mid_apb3_intcon (
        // Reset and clock
        .rst            (rst),          // i
        .clk            (clk),          // i

        // APB3 slave from the upstream endpoint
        .up_apb3_s      (up_apb3),      // apb3_if.slave

        // APB3 masters to the downstream endpoints
        .dn_apb3_m      (dn_apb3)       // apb3_if[DN_CNT].master
    ); // tip_mid_apb3_intcon

endmodule: tip_mid_ep