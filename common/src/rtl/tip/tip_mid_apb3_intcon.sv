/*
    // APB3 interconnect routing downstream control transactions
    // driven by the upstream endpoint
    tip_mid_apb3_intcon #(
        .DN_CNT         ()  // Number of downstream links
    )
    tip_mid_apb3_intcon (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // APB3 slave from the upstream endpoint
        .up_apb3_s      (), // apb3_if.slave

        // APB3 masters to the downstream endpoints
        .dn_apb3_m      ()  // apb3_if[DN_CNT].master
    ); // tip_mid_apb3_intcon
*/


module tip_mid_apb3_intcon
#(
    parameter int unsigned      DN_CNT      = 1             // Number of downstream links
)
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // APB3 slave from the upstream endpoint
    apb3_if.slave               up_apb3_s,

    // APB3 masters to the downstream endpoints
    apb3_if.master              dn_apb3_m[DN_CNT]
);

    // TODO: to be implemented

endmodule: tip_mid_apb3_intcon