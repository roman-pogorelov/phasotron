// AXIS interface definition

interface axis_if #(
    parameter int unsigned  TDATA_W = 128,
    parameter int unsigned  TKEEP_W = 16
);

    // Interface signals
    logic [TDATA_W - 1 : 0] tdata;
    logic [TKEEP_W - 1 : 0] tkeep;
    logic                   tvalid;
    logic                   tlast;
    logic                   tready;

    // Master mode
    modport master (
        output tdata,
        output tkeep,
        output tvalid,
        output tlast,
        input  tready
    );

    // Slave mode
    modport slave (
        input  tdata,
        input  tkeep,
        input  tvalid,
        input  tlast,
        output tready
    );

endinterface: axis_if


/*
    // Connects AXIS interfaces
    axis_if_connect the_axis_if_connect (
        // Slave interface
        .s      (), // axis_if.slave

        // Master interface
        .m      ()  // axis_if.master
    ); // the_axis_if_connect
*/


module axis_if_connect
(
    // Slave interface
    axis_if.slave   s,

    // Master interface
    axis_if.master  m
);

    assign m.tdata = s.tdata;
    assign m.tkeep = s.tkeep;
    assign m.tvalid = s.tvalid;
    assign m.tlast = s.tlast;
    assign s.tready = m.tready;

endmodule: axis_if_connect