/*
    // TIP upstream endpoint configuration unit
    tip_up_conf #(
        .TYPE_ID    (), // Node type ID
        .FW_REV_ID  ()  // FW revision ID
    )
    the_tip_up_conf (
        // Reset and clock
        .rst        (), // i
        .clk        (), // i

        // Configuration control
        .up_conf    (), // tip_up_conf_if.master

        // APB3 slave interface
        .apb3_s     (), // apb3_if.slave

        // APB3 msater interface
        .dn_apb3_m  ()  // apb3_if.master
    ); // the_tip_up_conf
*/


module tip_up_conf
#(
    parameter logic [31 : 0]    TYPE_ID     = 32'h00000000, // Node type ID
    parameter logic [31 : 0]    FW_REV_ID   = 32'h00000000  // FW revision ID
)
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // Configuration control
    tip_up_conf_if.master       up_conf,

    // APB3 slave interface
    apb3_if.slave               apb3_s,

    // APB3 msater interface
    apb3_if.master              dn_apb3_m
);
    // FIXME:
    assign up_conf.indiv_addr = '0;
    assign up_conf.group_addr0 = '0;
    assign up_conf.group_addr1 = '0;
    assign up_conf.group_addr2 = '0;
    assign up_conf.group_addr3 = '0;
    assign up_conf.group_addr4 = '0;
    assign up_conf.group_addr5 = '0;
    assign up_conf.group_addr6 = '0;
    assign up_conf.group_addr7 = '0;


    // FIXME:
    assign apb3_s.pready = '1;
    assign apb3_s.prdata = '0;
    assign apb3_s.pslverr = '0;


    // FIXME:
    assign dn_apb3_m.paddr = '0;
    assign dn_apb3_m.psel = '0;
    assign dn_apb3_m.penable = '0;
    assign dn_apb3_m.pwrite = '0;
    assign dn_apb3_m.pwdata = '0;

endmodule: tip_up_conf