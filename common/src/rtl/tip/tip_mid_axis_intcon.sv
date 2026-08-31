/*
    // AXIS interconnect routing control packets
    // between the upstream and downstream endpoints
    tip_mid_axis_intcon #(
        .DN_CNT         ()  // Number of downstream links
    )
    the_tip_mid_axis_intcon (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Streams to/from the upstream endpoint
        .up_ctrl_in     (), // axis_if.slave
        .up_ctrl_out    (), // axis_if.master

        // Streams to/from the downstream endpoints
        .dn_ctrl_in     (), // axis_if[DN_CNT].slave
        .dn_ctrl_out    ()  // axis_if[DN_CNT].master
    ); // the_tip_mid_axis_intcon
*/


module tip_mid_axis_intcon
#(
    parameter int unsigned      DN_CNT      = 1             // Number of downstream links
)
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // Streams to/from the upstream endpoint
    axis_if.slave               up_ctrl_in,
    axis_if.master              up_ctrl_out,

    // Streams to/from the downstream endpoints
    axis_if.slave               dn_ctrl_in[DN_CNT],
    axis_if.master              dn_ctrl_out[DN_CNT]
);

    // TODO: to be implemented

endmodule: tip_mid_axis_intcon