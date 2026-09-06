// TIP transport status interface
interface tip_transp_stat_if;

    // Interface signals
    logic link_up;
    logic soft_err;
    logic hard_err;
    logic rx_data_loss;
    logic rx_frame_loss;
    logic tx_data_loss;
    logic tx_frame_loss;


    // Master mode
    modport master (
        output link_up,
        output soft_err,
        output hard_err,
        output rx_data_loss,
        output rx_frame_loss,
        output tx_data_loss,
        output tx_frame_loss
    );


    // Slave mode
    modport slave (
        input  link_up,
        input  soft_err,
        input  hard_err,
        input  rx_data_loss,
        input  rx_frame_loss,
        input  tx_data_loss,
        input  tx_frame_loss
    );

endinterface: tip_transp_stat_if


/*
    // Connects TIP transport status interfaces
    tip_transp_stat_connect the_tip_transp_stat_connect (
        // Slave interface
        .s      (), // tip_transp_stat_if.slave

        // Master interface
        .m      ()  // tip_transp_stat_if.master
    ); // the_tip_transp_stat_connect
*/


module tip_transp_stat_connect
(
    // Slave interface
    tip_transp_stat_if.slave    s,

    // Master interface
    tip_transp_stat_if.master   m
);
    assign m.link_up = s.link_up;
    assign m.soft_err = s.soft_err;
    assign m.hard_err = s.hard_err;
    assign m.rx_data_loss = s.rx_data_loss;
    assign m.rx_frame_loss = s.rx_frame_loss;
    assign m.tx_data_loss = s.tx_data_loss;
    assign m.tx_frame_loss = s.tx_frame_loss;

endmodule: tip_transp_stat_connect


// TIP downstream control interface
interface tip_dn_ctrl_if;

    // Interface signals
    logic transp_rx_ena;
    logic transp_tx_ena;


    // Master mode
    modport master (
        output transp_rx_ena,
        output transp_tx_ena
    );


    // Slave mode
    modport slave (
        input  transp_rx_ena,
        input  transp_tx_ena
    );

endinterface: tip_dn_ctrl_if


// TIP upsteram configuration interface
interface tip_up_conf_if;

    // Interface signals
    logic [31 : 0]  indiv_addr;
    logic [31 : 0]  group_addr0;
    logic [31 : 0]  group_addr1;
    logic [31 : 0]  group_addr2;
    logic [31 : 0]  group_addr3;
    logic [31 : 0]  group_addr4;
    logic [31 : 0]  group_addr5;
    logic [31 : 0]  group_addr6;
    logic [31 : 0]  group_addr7;


    // Master mode
    modport master (
        output indiv_addr,
        output group_addr0,
        output group_addr1,
        output group_addr2,
        output group_addr3,
        output group_addr4,
        output group_addr5,
        output group_addr6,
        output group_addr7
    );


    // Slave mode
    modport slave (
        input  indiv_addr,
        input  group_addr0,
        input  group_addr1,
        input  group_addr2,
        input  group_addr3,
        input  group_addr4,
        input  group_addr5,
        input  group_addr6,
        input  group_addr7
    );

endinterface: tip_up_conf_if


// TIP upsteram request interface
interface tip_up_req_if;

    // Interface signals
    logic   reset;

    // Master mode
    modport master (
        output reset
    );


    // Slave mode
    modport slave (
        input  reset
    );

endinterface: tip_up_req_if