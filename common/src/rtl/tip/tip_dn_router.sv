/*
    // TIP downstream endpoint router
    tip_dn_router the_tip_dn_router (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Control
        .dn_ctrl        (), // tip_dn_ctrl_if.slave

        // Streams to/from the transport
        .dn_transp_in   (), // axis_if.slave
        .dn_transp_out  (), // axis_if.master

        // Streams to/from the upstream endpoint
        .up_ctrl_in     (), // axis_if.slave
        .up_ctrl_out    (), // axis_if.master
        .up_data_out    ()  // axis_if.master
    ); // the_tip_dn_router
*/

import tip_defs::*;

module tip_dn_router
(
    // Reset and clock
    input  logic            rst,
    input  logic            clk,

    // Control
    tip_dn_ctrl_if.slave    dn_ctrl,

    // Streams to/from the transport
    axis_if.slave           dn_transp_in,
    axis_if.master          dn_transp_out,

    // Streams to/from the upstream endpoint
    axis_if.slave           up_ctrl_in,
    axis_if.master          up_ctrl_out,
    axis_if.master          up_data_out
);
    // Variables
    tip_pkt_hdr_t   dn_transp_in_hdr;
    logic           dn_transp_in_is_ctrl;
    logic           dn_transp_in_is_data;


    // Interfaces
    axis_if         up_ctrl_in_i[1]();
    axis_if         up_ctrl_in_sw[1]();
    axis_if         dn_transp_in_i[1]();
    axis_if         dn_transp_in_sw[1]();
    axis_if         dn_transp_in_sw_buf();
    axis_if         dn_transp_in_rt[2]();


    // Connects AXIS interfaces
    axis_if_connect ctrl_in_connect (
        // Slave interface
        .s      (up_ctrl_in),       // axis_if.slave

        // Master interface
        .m      (up_ctrl_in_i[0])   // axis_if.master
    ); // ctrl_in_connect


    // Forwards the input stream to a mask-selected
    // subset of multiple outputs
    axis_multicast #(
        .OUT_CNT    (1)                         // Number out output stream
    )
    ctrl_in_switch (
        // Reset and clock
        .rst        (rst),                      // i
        .clk        (clk),                      // i

        // Mask selecting the active outputs
        .out_mask   (dn_ctrl.transp_tx_ena),    // i  [OUT_CNT - 1 : 0]

        // Input AXIS interface
        .in         (up_ctrl_in_i[0]),          // axis_if.slave

        // Output AXIS interface
        .out        (up_ctrl_in_sw)             // axis_if[OUT_CNT].master
    ); // ctrl_in_switch


    // 2-stage AXIS buffer
    axis_2stage_buf ctrl_in_buf (
        // Reset and clock
        .rst        (rst),              // i
        .clk        (clk),              // i

        // Input AXIS interface
        .in         (up_ctrl_in_sw[0]), // axis_if.slave

        // Output AXIS interface
        .out        (dn_transp_out)     // axis_if.master
    ); // ctrl_in_buf


    // Connects AXIS interfaces
    axis_if_connect dn_transp_in_connect (
        // Slave interface
        .s      (dn_transp_in),     // axis_if.slave

        // Master interface
        .m      (dn_transp_in_i[0]) // axis_if.master
    ); // dn_transp_in_connect


    // Forwards the input stream to a mask-selected
    // subset of multiple outputs
    axis_multicast #(
        .OUT_CNT    (1)                         // Number out output stream
    )
    dn_transp_in_switch (
        // Reset and clock
        .rst        (rst),                      // i
        .clk        (clk),                      // i

        // Mask selecting the active outputs
        .out_mask   (dn_ctrl.transp_rx_ena),    // i  [OUT_CNT - 1 : 0]

        // Input AXIS interface
        .in         (dn_transp_in_i[0]),        // axis_if.slave

        // Output AXIS interface
        .out        (dn_transp_in_sw)           // axis_if[OUT_CNT].master
    ); // dn_transp_in_switch


    // 2-stage AXIS buffer
    axis_2stage_buf dn_transp_in_buffer (
        // Reset and clock
        .rst        (rst),                  // i
        .clk        (clk),                  // i

        // Input AXIS interface
        .in         (dn_transp_in_sw[0]),   // axis_if.slave

        // Output AXIS interface
        .out        (dn_transp_in_sw_buf)   // axis_if.master
    ); // dn_transp_in_buffer


    // Identify the traffic coming the transport
    assign dn_transp_in_hdr = dn_transp_in_sw_buf.tdata;
    //
    assign dn_transp_in_is_ctrl = (
        (&dn_transp_in_sw_buf.tkeep[TIP_AXIS_TKEEP_W - 1 : 0]) &
        ((dn_transp_in_hdr.cmn.type_id == TIP_PKT_TYPE_RPT_CFG) | (dn_transp_in_hdr.cmn.type_id == TIP_PKT_TYPE_RPT_USR))
    );
    //
    assign dn_transp_in_is_data = (
        (&dn_transp_in_sw_buf.tkeep[TIP_AXIS_TKEEP_W / 2 - 1 : 0]) &
        (dn_transp_in_hdr.cmn.type_id == TIP_PKT_TYPE_DATA)
    );


    // Forwards the input stream to a mask-selected
    // subset of multiple outputs
    axis_multicast #(
        .OUT_CNT    (2)                     // Number of output stream
    )
    dn_transp_in_router (
        // Reset and clock
        .rst        (rst),                  // i
        .clk        (clk),                  // i

        // Mask selecting the active outputs
        .out_mask   ({
                        dn_transp_in_is_data,
                        dn_transp_in_is_ctrl
                    }),                     // i  [OUT_CNT - 1 : 0]

        // Input AXIS interface
        .in         (dn_transp_in_sw_buf),  // axis_if.slave

        // Output AXIS interface
        .out        (dn_transp_in_rt)       // axis_if[OUT_CNT].master
    ); // dn_transp_in_router


    // 2-stage AXIS buffer
    axis_2stage_buf up_ctrl_out_buf (
        // Reset and clock
        .rst        (rst),                  // i
        .clk        (clk),                  // i

        // Input AXIS interface
        .in         (dn_transp_in_rt[0]),   // axis_if.slave

        // Output AXIS interface
        .out        (up_ctrl_out)           // axis_if.master
    ); // up_ctrl_out_buf


    // 2-stage AXIS buffer
    axis_2stage_buf up_data_out_buf (
        // Reset and clock
        .rst        (rst),                  // i
        .clk        (clk),                  // i

        // Input AXIS interface
        .in         (dn_transp_in_rt[1]),   // axis_if.slave

        // Output AXIS interface
        .out        (up_data_out)           // axis_if.master
    ); // up_data_out_buf

endmodule: tip_dn_router