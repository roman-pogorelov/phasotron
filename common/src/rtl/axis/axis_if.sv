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