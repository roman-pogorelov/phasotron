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
    // Interfaces
    axis_if     up2dn_ctrl[DN_CNT]();
    axis_if     dn2up_ctrl();


    // Forwards the input stream to a mask-selected
    // subset of multiple outputs
    axis_multicast #(
        .OUT_CNT    (DN_CNT)            // Number of output stream
    )
    up_ctrl_in_multicast (
        // Reset and clock
        .rst        (rst),              // i
        .clk        (clk),              // i

        // Mask selecting the active outputs
        .out_mask   ({DN_CNT{1'b1}}),   // i  [OUT_CNT - 1 : 0]

        // Input AXIS interface
        .in         (up_ctrl_in),       // axis_if.slave

        // Output AXIS interface
        .out        (up2dn_ctrl)        // axis_if[OUT_CNT].master
    ); // up_ctrl_in_multicast


    // Generate AXIS buffers for the control traffic goes from
    // the upstream EP to the downstream ones
    generate
        genvar i;
        for (i = 0; i < DN_CNT; i++) begin: up2dn_ctrl_buf_gen

            // 2-stage AXIS buffer
            axis_2stage_buf up2dn_ctrl_buf (
                // Reset and clock
                .rst        (rst),              // i
                .clk        (clk),              // i

                // Input AXIS interface
                .in         (up2dn_ctrl[i]),    // axis_if.slave

                // Output AXIS interface
                .out        (dn_ctrl_out[i])    // axis_if.master
            ); // up2dn_ctrl_buf

        end // up2dn_ctrl_buf_gen
    endgenerate


    // AXIS arbiter
    axis_arbiter #(
        .IN_CNT     (DN_CNT),       // Number of input streams
        .SCHEME     ("RR")          // Arbitration scheme ("RR" - round-robin, "FP" - fixed priorities)
    )
    the_axis_arbiter (
        // Reset and clock
        .rst        (rst),          // i
        .clk        (clk),          // i

        // Input AXIS interface
        .in         (dn_ctrl_in),   // axis_if[IN_CNT].slave

        // Output AXIS interface
        .out        (dn2up_ctrl)    // axis_if.master
    ); // the_axis_arbiter


    // 2-stage AXIS buffer
    axis_2stage_buf up2dn_ctrl_buf (
        // Reset and clock
        .rst        (rst),          // i
        .clk        (clk),          // i

        // Input AXIS interface
        .in         (dn2up_ctrl),   // axis_if.slave

        // Output AXIS interface
        .out        (up_ctrl_out)   // axis_if.master
    ); // up2dn_ctrl_buf

endmodule: tip_mid_axis_intcon