/*
    // Placeholder for the DSP system
    dsp_system #(
        .DN_CNT         ()  // Number of downstream links
    )
    the_dsp_system (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Streams to/from the upstream/downstream endpoints
        .up_data_out    (), // axis_if.master
        .dn_data_in     ()  // axis_if[DN_CNT].slave
    ); // the_dsp_system
*/

module dsp_system
#(
    parameter int unsigned  DN_CNT = 4  // Number of downstream links
)
(
    // Reset and clock
    input  logic            rst,
    input  logic            clk,

    // Streams to/from the upstream/downstream endpoints
    axis_if.master          up_data_out,
    axis_if.slave           dn_data_in[DN_CNT]
);
    // Interfaces
    axis_if         up_data_arb();


    // AXIS arbiter
    axis_arbiter #(
        .IN_CNT     (DN_CNT),       // Number of input streams
        .SCHEME     ("RR")          // Arbitration scheme ("RR" - round-robin, "FP" - fixed priorities)
    )
    dn_data_arbiter (
        // Reset and clock
        .rst        (rst),          // i
        .clk        (clk),          // i

        // Input AXIS interface
        .in         (dn_data_in),   // axis_if[IN_CNT].slave

        // Output AXIS interface
        .out        (up_data_arb)   // axis_if.master
    ); // dn_data_arbiter


    // 2-stage AXIS buffer
    axis_2stage_buf dn_data_buf (
        // Reset and clock
        .rst        (rst),          // i
        .clk        (clk),          // i

        // Input AXIS interface
        .in         (up_data_arb), // axis_if.slave

        // Output AXIS interface
        .out        (up_data_out)   // axis_if.master
    ); // dn_data_buf

endmodule: dsp_system