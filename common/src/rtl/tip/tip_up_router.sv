/*
    // TIP upstream endpoint router
    tip_up_router the_tip_up_router (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Configuration control
        .up_conf        (), // tip_up_conf_if.slave

        // Streams to/from the transport
        .up_transp_in   (), // axis_if.slave
        .up_transp_out  (), // axis_if.master

        // Control streams: configuration commands/reports
        .conf_cmd_out   (), // axis_if.master
        .conf_rpt_in    (), // axis_if.slave

        // Control streams: user commands/reports
        .user_cmd_out   (), // axis_if.master
        .user_rpt_in    (), // axis_if.slave

        // Streams to/from the downstream endpoint
        .dn_ctrl_in     (), // axis_if.slave
        .dn_ctrl_out    (), // axis_if.master
        .dn_data_in     ()  // axis_if.slave
    ); // the_tip_up_router
*/

import tip_defs::*;

module tip_up_router
(
    // Reset and clock
    input  logic            rst,
    input  logic            clk,

    // Configuration control
    tip_up_conf_if.slave    up_conf,

    // Streams to/from the transport
    axis_if.slave           up_transp_in,
    axis_if.master          up_transp_out,

    // Control streams: configuration commands/reports
    axis_if.master          conf_cmd_out,
    axis_if.slave           conf_rpt_in,

    // Control streams: user commands/reports
    axis_if.master          user_cmd_out,
    axis_if.slave           user_rpt_in,

    // Streams to/from the downstream endpoint
    axis_if.slave           dn_ctrl_in,
    axis_if.master          dn_ctrl_out,
    axis_if.slave           dn_data_in
);
    // Interfaces
    axis_if         to_up_transp[4]();
    axis_if         to_up_transp_buf();
    //
    axis_if         from_up_transp[3]();
    //
    tip_pkt_hdr_t   transp_in_hdr;
    logic           is_tkeep_valid;
    logic           does_addr_match;
    //
    logic           is_conf_cmd;
    logic           is_user_cmd;
    logic           is_ctrl_pkt;


    // Connects AXIS interfaces
    axis_if_connect conf_rpt_in_connect (
        // Slave interface
        .s      (conf_rpt_in),      // axis_if.slave

        // Master interface
        .m      (to_up_transp[0])   // axis_if.master
    ); // conf_rpt_in_connect


    // Connects AXIS interfaces
    axis_if_connect user_rpt_in_connect (
        // Slave interface
        .s      (user_rpt_in),      // axis_if.slave

        // Master interface
        .m      (to_up_transp[1])   // axis_if.master
    ); // user_rpt_in_connect


    // Connects AXIS interfaces
    axis_if_connect dn_ctrl_in_connect (
        // Slave interface
        .s      (dn_ctrl_in),      // axis_if.slave

        // Master interface
        .m      (to_up_transp[2])   // axis_if.master
    ); // dn_ctrl_in_connect


    // Connects AXIS interfaces
    axis_if_connect dn_data_in_connect (
        // Slave interface
        .s      (dn_data_in),      // axis_if.slave

        // Master interface
        .m      (to_up_transp[3])   // axis_if.master
    ); // dn_data_in_connect


    // AXIS arbiter
    axis_arbiter #(
        .IN_CNT     (4),                // Number of input streams
        .SCHEME     ("FP")              // Arbitration scheme ("RR" - round-robin, "FP" - fixed priorities)
    )
    up_transp_out_arbiter (
        // Reset and clock
        .rst        (rst),              // i
        .clk        (clk),              // i

        // Input AXIS interface
        .in         (to_up_transp),     // axis_if[IN_CNT].slave

        // Output AXIS interface
        .out        (to_up_transp_buf)  // axis_if.master
    ); // up_transp_out_arbiter


    // 2-stage AXIS buffer
    axis_2stage_buf up_transp_out_buf (
        // Reset and clock
        .rst        (rst),              // i
        .clk        (clk),              // i

        // Input AXIS interface
        .in         (to_up_transp_buf), // axis_if.slave

        // Output AXIS interface
        .out        (up_transp_out)     // axis_if.master
    ); // up_transp_out_buf


    // Forwards the input stream to a mask-selected
    // subset of multiple outputs
    axis_multicast #(
        .OUT_CNT    (3)                 // Number of output stream
    )
    up_transp_in_multicast (
        // Reset and clock
        .rst        (rst),              // i
        .clk        (clk),              // i

        // Mask selecting the active outputs
        .out_mask   ({
                        is_ctrl_pkt,
                        is_user_cmd,
                        is_conf_cmd
                    }),                 // i  [OUT_CNT - 1 : 0]

        // Input AXIS interface
        .in         (up_transp_in),     // axis_if.slave

        // Output AXIS interface
        .out        (from_up_transp)    // axis_if[OUT_CNT].master
    ); // up_transp_in_multicast


    // 2-stage AXIS buffer
    axis_2stage_buf conf_cmd_out_buf (
        // Reset and clock
        .rst        (rst),                  // i
        .clk        (clk),                  // i

        // Input AXIS interface
        .in         (from_up_transp[0]),    // axis_if.slave

        // Output AXIS interface
        .out        (conf_cmd_out)          // axis_if.master
    ); // conf_cmd_out_buf


    // 2-stage AXIS buffer
    axis_2stage_buf user_cmd_out_buf (
        // Reset and clock
        .rst        (rst),                  // i
        .clk        (clk),                  // i

        // Input AXIS interface
        .in         (from_up_transp[1]),    // axis_if.slave

        // Output AXIS interface
        .out        (user_cmd_out)          // axis_if.master
    ); // user_cmd_out_buf


    // 2-stage AXIS buffer
    axis_2stage_buf dn_ctrl_out_buf (
        // Reset and clock
        .rst        (rst),                  // i
        .clk        (clk),                  // i

        // Input AXIS interface
        .in         (from_up_transp[2]),    // axis_if.slave

        // Output AXIS interface
        .out        (dn_ctrl_out)           // axis_if.master
    ); // dn_ctrl_out_buf


    // Identify the traffic coming from the transport
    assign transp_in_hdr = up_transp_in.tdata;
    assign is_tkeep_valid = &up_transp_in.tkeep[TIP_AXIS_TKEEP_W - 1 : 0];
    assign does_addr_match = (
        (transp_in_hdr.cmn.node_addr == up_conf.indiv_addr) |
        ((transp_in_hdr.cmn.node_addr == up_conf.group_addr0) & (up_conf.group_addr0 != 0)) |
        ((transp_in_hdr.cmn.node_addr == up_conf.group_addr1) & (up_conf.group_addr1 != 0)) |
        ((transp_in_hdr.cmn.node_addr == up_conf.group_addr2) & (up_conf.group_addr2 != 0)) |
        ((transp_in_hdr.cmn.node_addr == up_conf.group_addr3) & (up_conf.group_addr3 != 0)) |
        ((transp_in_hdr.cmn.node_addr == up_conf.group_addr4) & (up_conf.group_addr4 != 0)) |
        ((transp_in_hdr.cmn.node_addr == up_conf.group_addr5) & (up_conf.group_addr5 != 0)) |
        ((transp_in_hdr.cmn.node_addr == up_conf.group_addr6) & (up_conf.group_addr6 != 0)) |
        ((transp_in_hdr.cmn.node_addr == up_conf.group_addr7) & (up_conf.group_addr7 != 0))
    );
    assign is_conf_cmd = is_tkeep_valid & (transp_in_hdr.cmn.type_id == TIP_PKT_TYPE_CMD_CFG) & does_addr_match;
    assign is_user_cmd = is_tkeep_valid & (transp_in_hdr.cmn.type_id == TIP_PKT_TYPE_CMD_USR) & does_addr_match;;
    assign is_ctrl_pkt = is_tkeep_valid & ((transp_in_hdr.cmn.type_id == TIP_PKT_TYPE_CMD_CFG) | (transp_in_hdr.cmn.type_id == TIP_PKT_TYPE_CMD_USR));

endmodule: tip_up_router