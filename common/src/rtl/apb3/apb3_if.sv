interface apb3_if;

    // Interface signals
    logic [31 : 0]  paddr;
    logic           psel;
    logic           penable;
    logic           pwrite;
    logic [31 : 0]  pwdata;
    logic           pready;
    logic [31 : 0]  prdata;
    logic           pslverr;


    // Master mode
    modport master (
        output paddr,
        output psel,
        output penable,
        output pwrite,
        output pwdata,
        input  pready,
        input  prdata,
        input  pslverr
    );


    // Slave mode
    modport slave (
        input  paddr,
        input  psel,
        input  penable,
        input  pwrite,
        input  pwdata,
        output pready,
        output prdata,
        output pslverr
    );

endinterface: apb3_if