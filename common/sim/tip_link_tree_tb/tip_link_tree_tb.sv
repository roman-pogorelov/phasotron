`timescale  1ps / 1ps

// Simulation delay
`define SIM_DLY     #1ps

module tip_link_tree_tb ();

    import apb3_sim::*;
    import axis_sim::*;
    import tip_defs::*;
    import tip_sim::*;


    // Public clock parameters
    localparam longint unsigned GT_CLKFREQ_HZ   = 156_250_000;
    localparam longint unsigned INIT_CLKFREQ_HZ = 100_000_000;
    // Private clock parameters (don't modify)
    localparam longint unsigned GT_CLKP_PS      = 64'd1_000_000_000_000 / GT_CLKFREQ_HZ;
    localparam longint unsigned GT_CLKHP_PS     = GT_CLKP_PS / 2;
    localparam longint unsigned INIT_CLKP_PS    = 64'd1_000_000_000_000 / INIT_CLKFREQ_HZ;
    localparam longint unsigned INIT_CLKHP_PS   = INIT_CLKP_PS / 2;


    // Public DUT parameters
    parameter int unsigned      DN_CNT          = 4;
    //
    parameter logic [31 : 0]    MID_TYPE_ID     = 32'hDEADBEEF;
    parameter logic [31 : 0]    MID_FW_REV_ID   = 32'h12345678;
    //
    parameter logic [31 : 0]    UP_TYPE_ID      = 32'hBEEF0000;
    parameter logic [31 : 0]    UP_FW_REV_ID    = 32'h9ABC0000;
    //
    parameter logic [31 : 0]    DEF_ADDR        = 32'h00000000;
    parameter logic [31 : 0]    MID_ADDR        = 32'h00001000;
    parameter logic [31 : 0]    UP0_ADDR        = 32'h00001001;
    parameter logic [31 : 0]    UP1_ADDR        = 32'h00001002;
    parameter logic [31 : 0]    UP2_ADDR        = 32'h00001003;
    parameter logic [31 : 0]    UP3_ADDR        = 32'h00001004;
    //
    parameter logic [31 : 0]    GRP_ADDR        = 32'h80000000;


    // Variables declaration
    logic                           gt_clk;
    logic                           init_clk;
    //
    logic                           dn_user_rst;
    logic                           dn_user_clk;
    //
    logic                           mid_user_rst;
    logic                           mid_user_clk;
    //
    logic [DN_CNT - 1 : 0]          up_user_rst;
    logic [DN_CNT - 1 : 0]          up_user_clk;
    //
    logic [1 : 0]                   mid_up_gt_rx_p;
    logic [1 : 0]                   mid_up_gt_rx_n;
    //
    logic [1 : 0]                   mid_up_gt_tx_p;
    logic [1 : 0]                   mid_up_gt_tx_n;
    //
    logic [DN_CNT - 1 : 0][1 : 0]   mid_dn_gt_rx_p;
    logic [DN_CNT - 1 : 0][1 : 0]   mid_dn_gt_rx_n;
    //
    logic [DN_CNT - 1 : 0][1 : 0]   mid_dn_gt_tx_p;
    logic [DN_CNT - 1 : 0][1 : 0]   mid_dn_gt_tx_n;


    // Interfaces
    apb3_if                         dn_apb3();
    apb3_if                         mid_user_apb3();
    apb3_if                         up_user_apb3[DN_CNT]();
    //
    axis_if                         dn_ctrl_in();
    axis_if                         dn_ctrl_out();
    axis_if                         dn_data_out();
    //
    axis_if                         mid_up_data_in();
    axis_if                         mid_dn_data_out[DN_CNT]();
    //
    axis_if                         up_dn_data_in[DN_CNT]();


    // GT clock generation
    initial gt_clk = 1'b1;
    always  gt_clk = #GT_CLKHP_PS ~gt_clk;


    // Init clock generation
    initial init_clk = 1'b1;
    always  init_clk = #INIT_CLKHP_PS ~init_clk;


    // Defaults
    initial begin
        apb3_idle_set(dn_apb3);
        axis_master_idle_set(dn_ctrl_in);
        axis_slave_ready_set(dn_ctrl_out, 1);
        axis_slave_ready_set(dn_data_out, 1);
        axis_master_idle_set(mid_up_data_in);
    end


    // Test-bench logic
    initial begin
        do begin
            @(posedge dn_user_clk);
        end while (!(&the_tip_mid_link.the_tip_transport.the_aurora_transport.stat_link_up));

        $display("All midstream links are UP!");

        @(posedge dn_user_clk);
        @(posedge dn_user_clk);

        apb3_read(dn_apb3, dn_user_clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(dn_apb3, dn_user_clk, TIP_CFG_ADDR_DN_LINK_STATE);
        apb3_read(dn_apb3, dn_user_clk, TIP_CFG_ADDR_DN_ENA);
        apb3_write(dn_apb3, dn_user_clk, TIP_CFG_ADDR_DN_ENA, 1);
        apb3_read(dn_apb3, dn_user_clk, TIP_CFG_ADDR_DN_ENA);

        @(posedge dn_user_clk);
        @(posedge dn_user_clk);


        // MID
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_INDIV_ADDR, '{MID_ADDR});
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_CNT, 2);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);


        // DN0
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA, 1);
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA, '{1});
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA, 1);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_INDIV_ADDR, '{UP0_ADDR});
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, UP0_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);


        // DN1
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 4, 1);
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 4, '{1});
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 4, 1);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_INDIV_ADDR, '{UP1_ADDR});
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, UP1_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);


        // DN2
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 8, 1);
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 8, '{1});
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 8, 1);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_INDIV_ADDR, '{UP2_ADDR});
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, UP2_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);


        // DN3
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 12, 1);
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 12, '{1});
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_DN_ENA + 12, 1);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, DEF_ADDR, TIP_CFG_ADDR_INDIV_ADDR, '{UP3_ADDR});
        axis_packet_wait(dn_ctrl_out, dn_user_clk);

        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 0, UP3_ADDR, TIP_CFG_ADDR_MAGIC_ID, 4);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);


        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 1, MID_ADDR, 'h10, '{ 1,  2,  3,  4});
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 1, UP0_ADDR, 'h10, '{ 5,  6,  7,  8});
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 1, UP1_ADDR, 'h10, '{ 9, 10, 11, 12});
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 1, UP2_ADDR, 'h10, '{13, 14, 15, 16});
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 1, UP3_ADDR, 'h10, '{17, 18, 19, 20});
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);


        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, MID_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, UP0_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, UP1_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, UP2_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 0, UP3_ADDR, TIP_CFG_ADDR_GROUP_ADDR1, '{GRP_ADDR});
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);


        tip_ctrl_wr_send(dn_ctrl_in, dn_user_clk, 1, GRP_ADDR, 8, '{32'h89ABCDEF});
        tip_ctrl_rd_send(dn_ctrl_in, dn_user_clk, 1, GRP_ADDR, 0, 3);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
        axis_packet_wait(dn_ctrl_out, dn_user_clk);
    end


    // Parse incoming control packets
    initial fork
        tip_pkt_parse(dn_ctrl_out, dn_user_clk, "DN CTRL OUT");
    join


    // TIP downstream link
    tip_dn_link the_tip_dn_link (
        // GT reference clock input
        .gt_clk         (gt_clk),           // i

        // Free running clock input
        .init_clk       (init_clk),         // i

        // User reset and clock outputs
        .user_rst       (dn_user_rst),      // i
        .user_clk       (dn_user_clk),      // i

        // GT serial RX
        .gt_rx_p        (mid_up_gt_tx_p),   // i  [1 : 0]
        .gt_rx_n        (mid_up_gt_tx_n),   // i  [1 : 0]

        // GT serial TX
        .gt_tx_p        (mid_up_gt_rx_p),   // o  [1 : 0]
        .gt_tx_n        (mid_up_gt_rx_n),   // o  [1 : 0]

        // APB3 slave to control the downstream endpoint @ user_clk
        .dn_apb3_s      (dn_apb3),          // apb3_if.slave

        // Streams to/from the upstream endpoint @ user_clk
        .up_ctrl_in     (dn_ctrl_in),       // axis_if.slave
        .up_ctrl_out    (dn_ctrl_out),      // axis_if.master
        .up_data_out    (dn_data_out)       // axis_if.master
    ); // the_tip_dn_link


    // TIP midstream link
    tip_mid_link #(
        .TYPE_ID        (MID_TYPE_ID),      // Node type ID
        .FW_REV_ID      (MID_FW_REV_ID),    // FW revision ID
        .DN_CNT         (DN_CNT)            // Number of downstream links
    )
    the_tip_mid_link (
        // GT reference clock input
        .gt_clk         (gt_clk),           // i

        // Free running clock input
        .init_clk       (init_clk),         // i

        // User reset and clock outputs
        .user_rst       (mid_user_rst),     // i
        .user_clk       (mid_user_clk),     // i

        // GT serial RX (upstream link)
        .up_gt_rx_p     (mid_up_gt_rx_p),   // i  [1 : 0]
        .up_gt_rx_n     (mid_up_gt_rx_n),   // i  [1 : 0]

        // GT serial TX (upstream link)
        .up_gt_tx_p     (mid_up_gt_tx_p),   // o  [1 : 0]
        .up_gt_tx_n     (mid_up_gt_tx_n),   // o  [1 : 0]

        // GT serial RX (downstream link)
        .dn_gt_rx_p     (mid_dn_gt_rx_p),   // i  [DN_CNT - 1 : 0][1 : 0]
        .dn_gt_rx_n     (mid_dn_gt_rx_n),   // i  [DN_CNT - 1 : 0][1 : 0]

        // GT serial TX (downstream link)
        .dn_gt_tx_p     (mid_dn_gt_tx_p),   // o  [DN_CNT - 1 : 0][1 : 0]
        .dn_gt_tx_n     (mid_dn_gt_tx_n),   // o  [DN_CNT - 1 : 0][1 : 0]

        // APB3 master to access the user-defined register map @ user_clk
        .user_apb3_m    (mid_user_apb3),    // apb3_if.master

        // Data streams to the upstream / from the downstream links @ user_clk
        .up_data_in     (mid_up_data_in),   // axis_if.slave
        .dn_data_out    (mid_dn_data_out)   // axis_if[DN_CNT].master
    ); // the_tip_mid_link


    // Placeholder for the user_system
    user_system mid_user_system (
        // Reset and clock
        .rst        (mid_user_rst),     // i
        .clk        (mid_user_clk),     // i

        // APB3 slave interface
        .apb3_s     (mid_user_apb3)     // apb3_if.slave
    ); // mid_user_system


    // Generate upstream EPs
    generate
        genvar i;
        for (i = 0; i < DN_CNT; i++) begin: up_link_gen

            // Defaults
            initial begin
                //
                axis_slave_ready_set(mid_dn_data_out[i], 1);
                axis_master_idle_set(up_dn_data_in[i]);
            end


            // TIP upstream link
            tip_up_link #(
                .TYPE_ID        (UP_TYPE_ID + i + 1),   // Node type ID
                .FW_REV_ID      (UP_FW_REV_ID + i + 1)  // FW revision ID
            )
            the_tip_up_link (
                // GT reference clock input
                .gt_clk         (gt_clk),               // i

                // Free running clock input
                .init_clk       (init_clk),             // i

                // User reset and clock outputs
                .user_rst       (up_user_rst[i]),       // o
                .user_clk       (up_user_clk[i]),       // o

                // GT serial RX
                .gt_rx_p        (mid_dn_gt_tx_p[i]),    // i  [1 : 0]
                .gt_rx_n        (mid_dn_gt_tx_n[i]),    // i  [1 : 0]

                // GT serial TX
                .gt_tx_p        (mid_dn_gt_rx_p[i]),    // o  [1 : 0]
                .gt_tx_n        (mid_dn_gt_rx_n[i]),    // o  [1 : 0]

                // APB3 master to access the user-defined register map @ user_clk
                .user_apb3_m    (up_user_apb3[i]),      // apb3_if.master

                // Data stream to upstream link @ user_clk
                .up_data_in     (up_dn_data_in[i])      // axis_if.slave
            ); // the_tip_up_link


            // Placeholder for the user_system
            user_system up_user_system (
                // Reset and clock
                .rst        (up_user_rst[i]),   // i
                .clk        (up_user_clk[i]),   // i

                // APB3 slave interface
                .apb3_s     (up_user_apb3[i])   // apb3_if.slave
            ); // up_user_system

        end // up_ep_gen
    endgenerate


endmodule: tip_link_tree_tb