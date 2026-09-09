`timescale  1ns / 1ps

// Simulation delay
`define SIM_DLY     #1ps

module tip_up_ep_tb ();

    import apb3_sim::*;
    import axis_sim::*;
    import tip_defs::*;
    import tip_sim::*;


    // Public clock parameters
    localparam int unsigned CLKFREQ_HZ      = 100_000_000;
    // Private clock parameters (don't modify)
    localparam int unsigned CLKP_NS         = 1_000_000_000 / CLKFREQ_HZ;
    localparam int unsigned CLKHP_NS        = CLKP_NS / 2;


    // Public delay parameters
    localparam int unsigned RSTLEN          = 5 * CLKHP_NS;
    localparam int unsigned INITDLY         = 10 * CLKP_NS;


    // Public DUT parameters
    parameter logic [31 : 0] TYPE_ID        = 32'hDEADBEEF;
    parameter logic [31 : 0] FW_REV_ID      = 32'h12345678;
    //
    parameter logic [31 : 0] INDIV_ADDR     = 32'h00000050;
    parameter logic [31 : 0] GROUP_ADDR0    = 32'h80000050;


    // Valiables
    logic                   rst;
    logic                   clk;


    // Interfaces
    tip_transp_stat_if      transp_stat();
    //
    apb3_if                 user_apb3();
    apb3_if                 dn_apb3();
    //
    axis_if                 transp_in();
    axis_if                 transp_out();
    //
    axis_if                 ctrl_in();
    axis_if                 ctrl_out();
    axis_if                 data_in();


    // Clock generation
    initial clk = 1'b1;
    always  clk = #CLKHP_NS ~clk;


    // Reset generation
    initial begin
        #0ns    rst = 1'b1;
        #RSTLEN rst = 1'b0;
    end


    // Defaults
    initial begin
        transp_stat.link_up = 1;
        transp_stat.soft_err = 0;
        transp_stat.hard_err = 0;
        transp_stat.rx_data_loss = 0;
        transp_stat.rx_frame_loss = 0;
        transp_stat.tx_data_loss = 0;
        transp_stat.tx_frame_loss = 0;
        //
        dn_apb3.pready = 1;
        dn_apb3.prdata = 0;
        dn_apb3.pslverr = 0;
        //
        user_apb3.pready = 1;
        user_apb3.prdata = 0;
        user_apb3.pslverr = 0;
        //
        axis_master_idle_set(transp_in);
        axis_slave_ready_set(transp_out, 1);
        axis_master_idle_set(ctrl_in);
        axis_slave_ready_set(ctrl_out, 1);
        axis_master_idle_set(data_in);
    end


    // Make AXIS slaves ready randomly
    always @(posedge clk) begin
        `SIM_DLY;
        axis_slave_ready_set(transp_out, $random());
        axis_slave_ready_set(ctrl_out, $random());
    end


    // Test-bench logic
    initial begin
        #INITDLY;
        tip_ctrl_rd_send(transp_in, clk, 0, 0, 0, 4);
        #INITDLY;
        tip_ctrl_wr_send(transp_in, clk, 0, 0, TIP_CFG_ADDR_INDIV_ADDR, '{INDIV_ADDR});
        #INITDLY;
        #INITDLY;
        tip_ctrl_rd_send(transp_in, clk, 0, INDIV_ADDR, 0, 4);
        tip_ctrl_rd_send(transp_in, clk, 0, INDIV_ADDR, TIP_CFG_ADDR_INDIV_ADDR, 1);
        tip_ctrl_wr_send(transp_in, clk, 0, INDIV_ADDR, TIP_CFG_ADDR_GROUP_ADDR0, '{GROUP_ADDR0});
        #INITDLY;
        #INITDLY;
        tip_ctrl_rd_send(transp_in, clk, 0, INDIV_ADDR, TIP_CFG_ADDR_GROUP_ADDR0, 8);
        tip_ctrl_wr_send(transp_in, clk, 1, INDIV_ADDR, 32'h8000F000, '{32'h11223344});
        tip_ctrl_rd_send(transp_in, clk, 1, INDIV_ADDR, 32'h8000F000, 32);
        tip_ctrl_wr_send(transp_in, clk, 0, INDIV_ADDR, TIP_CFG_ADDR_RST_REQ, '{TIP_CFG_RST_REQ_KEY});
    end


    initial fork
        // tip_pkt_parse(ctrl_out, clk, "CTRL OUT");
        // tip_pkt_parse(transp_in, clk, "TRANSPORT IN");
        tip_pkt_parse(transp_out, clk, "TRANSPORT OUT");
    join


    // TIP upstream endpoint
    tip_up_ep #(
        .TYPE_ID        (TYPE_ID),      // Node type ID
        .FW_REV_ID      (FW_REV_ID)     // FW revision ID
    )
    the_tip_up_ep (
        // Reset and clock
        .rst            (rst),          // i
        .clk            (clk),          // i

        // Upstream tsransport status
        .up_transp_stat (transp_stat),  // tip_transp_stat_if.slave

        // Streams to/from the upstream transport
        .up_transp_in   (transp_in),    // axis_if.slave
        .up_transp_out  (transp_out),   // axis_if.master

        // APB3 master to access the user-defined register map
        .user_apb3_m    (user_apb3),    // apb3_if.master

        // APB3 master to control the downstream endpoints
        .dn_apb3_m      (dn_apb3),      // apb3_if.master

        // Streams to/from the downstream endpoint
        .dn_ctrl_in     (ctrl_in),      // axis_if.slave
        .dn_ctrl_out    (ctrl_out),     // axis_if.master
        .dn_data_in     (data_in)       // axis_if.slave
    ); // the_tip_up_ep

endmodule: tip_up_ep_tb