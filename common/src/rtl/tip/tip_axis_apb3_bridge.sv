/*
    // Converts TIP AXIS packets into APB3 transactions and
    // converts APB3 responses back into TIP AXIS packets
    tip_axis_apb3_bridge the_tip_axis_apb3_bridge (
        // Reset and clock
        .rst        (), // i
        .clk        (), // i

        // Control streams
        .ctrl_in    (), // axis_if.slave
        .ctrl_out   (), // axis_if.master

        // APB3 master
        .apb3_m     ()  // apb3_if.master
    ); // the_tip_axis_apb3_bridge
*/


module tip_axis_apb3_bridge
(
    // Reset and clock
    input  logic        rst,
    input  logic        clk,

    // Control streams
    axis_if.slave       ctrl_in,
    axis_if.master      ctrl_out,

    // APB3 master
    apb3_if.master      apb3_m
);
    // FIXME:
    assign ctrl_out.tdata = '0;
    assign ctrl_out.tkeep = '0;
    assign ctrl_out.tvalid = '0;
    assign ctrl_out.tlast = '0;
    assign ctrl_in.tready = '1;


    // FIXME:
    assign apb3_m.paddr = '0;
    assign apb3_m.psel = '0;
    assign apb3_m.penable = '0;
    assign apb3_m.pwrite = '0;
    assign apb3_m.pwdata = '0;

endmodule: tip_axis_apb3_bridge