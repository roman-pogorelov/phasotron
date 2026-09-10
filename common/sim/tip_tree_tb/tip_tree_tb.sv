`timescale  1ns / 1ps

// Simulation delay
`define SIM_DLY     #1ps

module tip_tree_tb ();

    import apb3_sim::*;
    import axis_sim::*;
    import tip_defs::*;
    import tip_sim::*;


    // Public clock parameters
    localparam int unsigned     CLKFREQ_HZ      = 100_000_000;
    // Private clock parameters (don't modify)
    localparam int unsigned     CLKP_NS         = 1_000_000_000 / CLKFREQ_HZ;
    localparam int unsigned     CLKHP_NS        = CLKP_NS / 2;


    // Public delay parameters
    localparam int unsigned     RSTLEN          = 5 * CLKHP_NS;
    localparam int unsigned     INITDLY         = 10 * CLKP_NS;


    // Public DUT parameters
    parameter int unsigned      DN_CNT          = 4;
    //
    parameter logic [31 : 0]    MID_TYPE_ID     = 32'hDEADBEEF;
    parameter logic [31 : 0]    MID_FW_REV_ID   = 32'h12345678;
    //
    parameter logic [31 : 0]    UP_TYPE_ID      = 32'hBEEF0000;
    parameter logic [31 : 0]    UP_FW_REV_ID    = 32'h9ABC0000;
    //
    parameter logic [31 : 0]    MID_ADDR        = 32'h00001000;
    parameter logic [31 : 0]    UP0_ADDR        = 32'h00001001;
    parameter logic [31 : 0]    UP1_ADDR        = 32'h00001002;
    parameter logic [31 : 0]    UP2_ADDR        = 32'h00001003;
    parameter logic [31 : 0]    UP3_ADDR        = 32'h00001004;
    //
    parameter logic [31 : 0]    GRP_ADDR        = 32'h80000000;

    // Valiables
    logic                   rst;
    logic                   clk;


    // Interfaces
    tip_transp_stat_if      mid_up_transp_stat();
    tip_transp_stat_if      mid_dn_transp_stat[DN_CNT]();
    tip_transp_stat_if      up_transp_stat[DN_CNT]();
    //
    apb3_if                 mid_user_apb3();
    apb3_if                 up_user_apb3[DN_CNT]();
    apb3_if                 up_dn_apb3[DN_CNT]();
    //
    axis_if                 mid_up_transp_in();
    axis_if                 mid_up_transp_out();
    axis_if                 mid_dn_transp_in[DN_CNT]();
    axis_if                 mid_dn_transp_out[DN_CNT]();
    //
    axis_if                 mid_up_data_in();
    axis_if                 mid_dn_data_out[DN_CNT]();
    //
    axis_if                 up_dn_ctrl_in[DN_CNT]();
    axis_if                 up_dn_ctrl_out[DN_CNT]();
    axis_if                 up_dn_data_in[DN_CNT]();


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
        mid_up_transp_stat.link_up = 1;
        mid_up_transp_stat.soft_err = 0;
        mid_up_transp_stat.hard_err = 0;
        mid_up_transp_stat.rx_data_loss = 0;
        mid_up_transp_stat.rx_frame_loss = 0;
        mid_up_transp_stat.tx_data_loss = 0;
        mid_up_transp_stat.tx_frame_loss = 0;
        //
        axis_master_idle_set(mid_up_transp_in);
        axis_slave_ready_set(mid_up_transp_out, 1);
        axis_master_idle_set(mid_up_data_in);
    end


    // Make AXIS slaves ready randomly
    always @(posedge clk) begin
        `SIM_DLY;
        axis_slave_ready_set(mid_up_transp_out, $random());
        // axis_slave_ready_set(ctrl_out, $random());
    end


    // Test-bench logic
    initial begin
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, 0, 0, 4);
        #INITDLY;
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, 0, TIP_CFG_ADDR_INDIV_ADDR, '{MID_ADDR});
        #INITDLY;
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, 0, 4);
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_CNT, 2);

        // DN0
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA, 1);
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA, '{1});
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA, 1);
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, 0, 0, 4);
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, 0, TIP_CFG_ADDR_INDIV_ADDR, '{UP0_ADDR});
        #INITDLY;
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, UP0_ADDR, 0, 4);

        // DN1
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 4, 1);
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 4, '{1});
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 4, 1);
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, 0, 0, 4);
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, 0, TIP_CFG_ADDR_INDIV_ADDR, '{UP1_ADDR});
        #INITDLY;
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, UP1_ADDR, 0, 4);

        // DN2
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 8, 1);
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 8, '{1});
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 8, 1);
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, 0, 0, 4);
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, 0, TIP_CFG_ADDR_INDIV_ADDR, '{UP2_ADDR});
        #INITDLY;
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, UP2_ADDR, 0, 4);

        // DN3
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 12, 1);
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 12, '{1});
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 12, 1);
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, 0, 0, 4);
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, 0, TIP_CFG_ADDR_INDIV_ADDR, '{UP3_ADDR});
        #INITDLY;
        #INITDLY;
        tip_ctrl_rd_send(mid_up_transp_in, clk, 0, UP3_ADDR, 0, 4);

        #INITDLY;
        tip_ctrl_wr_send(mid_up_transp_in, clk, 1, MID_ADDR, 'h10, '{1, 2, 3, 4});
        tip_ctrl_wr_send(mid_up_transp_in, clk, 1, UP0_ADDR, 'h10, '{1, 2, 3, 4});
        tip_ctrl_wr_send(mid_up_transp_in, clk, 1, UP1_ADDR, 'h10, '{1, 2, 3, 4});
        tip_ctrl_wr_send(mid_up_transp_in, clk, 1, UP2_ADDR, 'h10, '{1, 2, 3, 4});
        tip_ctrl_wr_send(mid_up_transp_in, clk, 1, UP3_ADDR, 'h10, '{1, 2, 3, 4});

        #INITDLY;
        #INITDLY;
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, MID_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, UP0_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, UP1_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, UP2_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        tip_ctrl_wr_send(mid_up_transp_in, clk, 0, UP3_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});

        #INITDLY;
        #INITDLY;
        #INITDLY;
        #INITDLY;
        tip_ctrl_wr_send(mid_up_transp_in, clk, 1, GRP_ADDR, 8, '{32'h89ABCDEF});
        tip_ctrl_rd_send(mid_up_transp_in, clk, 1, GRP_ADDR, 0, 3);
    end


    initial fork
        tip_pkt_parse(mid_up_transp_out, clk, "MID TRANSP OUT");
    join


    // TIP midstream endpoint
    tip_mid_ep #(
        .TYPE_ID        (MID_TYPE_ID),          // Node type ID
        .FW_REV_ID      (MID_FW_REV_ID),        // FW revision ID
        .DN_CNT         (DN_CNT)                // Number of downstream links
    )
    the_tip_mid_ep (
        // Reset and clock
        .rst            (rst),                  // i
        .clk            (clk),                  // i

        // Upstream/downstream tsransport status
        .up_transp_stat (mid_up_transp_stat),   // tip_transp_stat_if.slave
        .dn_transp_stat (mid_dn_transp_stat),   // tip_transp_stat_if[DN_CNT].slave

        // Streams to/from the upstream/downstream transport
        .up_transp_in   (mid_up_transp_in),     // axis_if.slave
        .up_transp_out  (mid_up_transp_out),    // axis_if.master
        .dn_transp_in   (mid_dn_transp_in),     // axis_if[DN_CNT].slave
        .dn_transp_out  (mid_dn_transp_out),    // axis_if[DN_CNT].master

        // APB3 master to access the user-defined register map
        .user_apb3_m    (mid_user_apb3),        // apb3_if.master

        // Streams to/from the upstream/downstream endpoints
        .up_data_in     (mid_up_data_in),       // axis_if.slave
        .dn_data_out    (mid_dn_data_out)       // axis_if[DN_CNT].master
    ); // the_tip_mid_ep


    // Placeholder for the user_system
    user_system mid_user_system (
        // Reset and clock
        .rst        (rst),              // i
        .clk        (clk),              // i

        // APB3 slave interface
        .apb3_s     (mid_user_apb3)     // apb3_if.slave
    ); // mid_user_system


    // Generate upstream EPs
    generate
        genvar i;
        for (i = 0; i < DN_CNT; i++) begin: up_ep_gen

            // Defaults
            initial begin
                mid_dn_transp_stat[i].link_up = 1;
                mid_dn_transp_stat[i].soft_err = 0;
                mid_dn_transp_stat[i].hard_err = 0;
                mid_dn_transp_stat[i].rx_data_loss = 0;
                mid_dn_transp_stat[i].rx_frame_loss = 0;
                mid_dn_transp_stat[i].tx_data_loss = 0;
                mid_dn_transp_stat[i].tx_frame_loss = 0;
                //
                up_transp_stat[i].link_up = 1;
                up_transp_stat[i].soft_err = 0;
                up_transp_stat[i].hard_err = 0;
                up_transp_stat[i].rx_data_loss = 0;
                up_transp_stat[i].rx_frame_loss = 0;
                up_transp_stat[i].tx_data_loss = 0;
                up_transp_stat[i].tx_frame_loss = 0;
                //
                up_dn_apb3[i].pready = 1;
                up_dn_apb3[i].prdata = 0;
                up_dn_apb3[i].pslverr = 0;
                //
                axis_slave_ready_set(mid_dn_data_out[i], 1);
                axis_master_idle_set(up_dn_ctrl_in[i]);
                axis_slave_ready_set(up_dn_ctrl_out[i], 1);
                axis_master_idle_set(up_dn_data_in[i]);
            end


            // TIP upstream endpoint
            tip_up_ep #(
                .TYPE_ID        (UP_TYPE_ID + i + 1),   // Node type ID
                .FW_REV_ID      (UP_FW_REV_ID + i + 1)  // FW revision ID
            )
            the_tip_up_ep (
                // Reset and clock
                .rst            (rst),                  // i
                .clk            (clk),                  // i

                // Upstream tsransport status
                .up_transp_stat (up_transp_stat[i]),    // tip_transp_stat_if.slave

                // Streams to/from the upstream transport
                .up_transp_in   (mid_dn_transp_out[i]), // axis_if.slave
                .up_transp_out  (mid_dn_transp_in[i]),  // axis_if.master

                // APB3 master to access the user-defined register map
                .user_apb3_m    (up_user_apb3[i]),      // apb3_if.master

                // APB3 master to control the downstream endpoints
                .dn_apb3_m      (up_dn_apb3[i]),        // apb3_if.master

                // Streams to/from the downstream endpoint
                .dn_ctrl_in     (up_dn_ctrl_in[i]),     // axis_if.slave
                .dn_ctrl_out    (up_dn_ctrl_out[i]),    // axis_if.master
                .dn_data_in     (up_dn_data_in[i])      // axis_if.slave
            ); // the_tip_up_ep


            // Placeholder for the user_system
            user_system up_user_system (
                // Reset and clock
                .rst        (rst),              // i
                .clk        (clk),              // i

                // APB3 slave interface
                .apb3_s     (up_user_apb3[i])   // apb3_if.slave
            ); // up_user_system

        end // up_ep_gen
    endgenerate


endmodule: tip_tree_tb