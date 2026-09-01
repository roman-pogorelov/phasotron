// APB3 definitions package
package apb3_defs;

    // APB3 address
    typedef struct packed {
        logic [29 : 0]  word_addr;
        logic [1 : 0]   byte_idx;
    } apb3_addr_t;


    // APB3 data
    typedef logic [31 : 0] apb3_data_t;

endpackage: apb3_defs


// APB3 interface
interface apb3_if;

    import apb3_defs::*;

    // Interface signals
    apb3_addr_t paddr;
    logic       psel;
    logic       penable;
    logic       pwrite;
    apb3_data_t pwdata;
    logic       pready;
    apb3_data_t prdata;
    logic       pslverr;


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