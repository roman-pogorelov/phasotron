/*
    // AXIS arbiter
    axis_arbiter #(
        .IN_CNT     (), // Number of input streams
        .SCHEME     ()  // Arbitration scheme ("RR" - round-robin, "FP" - fixed priorities)
    )
    the_axis_arbiter (
        // Reset and clock
        .rst        (), // i
        .clk        (), // i

        // Input AXIS interface
        .in         (), // axis_if[IN_CNT].slave

        // Output AXIS interface
        .out        ()  // axis_if.master
    ); // the_axis_arbiter
*/


module axis_arbiter
#(
    parameter int unsigned  IN_CNT  = 2,    // Number of input streams
    parameter string        SCHEME  = "RR"  // Arbitration scheme ("RR" - round-robin, "FP" - fixed priorities)
)
(
    // Reset and clock
    input  logic            rst,
    input  logic            clk,

    // Input AXIS interface
    axis_if.slave           in[IN_CNT],

    // Output AXIS interface
    axis_if.master          out
);
    // Constants
    localparam int unsigned         TDATA_W = $bits(out.tdata);
    localparam int unsigned         TKEEP_W = $bits(out.tkeep);


    // Variables
    logic [IN_CNT - 1 : 0][TDATA_W - 1 : 0] in_tdata;
    logic [IN_CNT - 1 : 0][TKEEP_W - 1 : 0] in_tkeep;
    logic [IN_CNT - 1 : 0]                  in_tlast;
    logic [IN_CNT - 1 : 0]                  in_tvalid;
    logic [IN_CNT - 1 : 0]                  in_tready;
    //
    logic [IN_CNT - 1 : 0]                  active_pos;
    logic [$clog2(IN_CNT) - 1 : 0]          active_idx;


    // Unroll the input interface array
    generate
        genvar i;
        for (i = 0; i < IN_CNT; i++) begin: in_if_connect
            assign in_tdata[i]  = in[i].tdata;
            assign in_tkeep[i]  = in[i].tkeep;
            assign in_tlast[i]  = in[i].tlast;
            assign in_tvalid[i] = in[i].tvalid;
            assign in[i].tready = in_tready[i];
        end // in_if_connect
    endgenerate


    // Single resource arbiter
    arbiter
    #(
        .REQS           (IN_CNT),                   // The number of requesters (REQS > 1)
        .SCHEME         (SCHEME)                    // Arbitration scheme ("RR" - round-robin, "FP" - fixed priorities)
    )
    the_arbiter
    (
        // Reset and clock
        .rst            (rst),                      // i
        .clk            (clk),                      // i

        // Requests vector
        .req            (in_tvalid),                // i  [REQS - 1 : 0]

        // Ready to process a request
        .rdy            (out.tready & out.tlast),   // i

        // Grants vector
        .gnt            (active_pos),               // o  [REQS - 1 : 0]

        // Index of port having the grant
        .num            (active_idx)                // o  [$clog2(REQS) - 1 : 0]
    ); // the_arbiter


    // Select the active input stream
    assign out.tdata  = in_tdata[active_idx];
    assign out.tkeep  = in_tkeep[active_idx];
    assign out.tlast  = in_tlast[active_idx];
    assign out.tvalid = in_tvalid[active_idx];
    assign in_tready  = active_pos & {IN_CNT{out.tready}};

endmodule: axis_arbiter