`timescale  1ns / 1ps

module tip_dn_ep_tb ();

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


    // Valiables
    logic                   rst;
    logic                   clk;


    // Interfaces
    tip_transp_stat_if      dn_transp_stat();
    //
    apb3_if                 dn_apb3_s();
    //
    axis_if                 dn_transp_in();
    axis_if                 dn_transp_out();
    //
    axis_if                 up_ctrl_in();
    axis_if                 up_ctrl_out();
    axis_if                 up_data_out();


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
        dn_transp_stat.link_up = 0;
        dn_transp_stat.soft_err = 0;
        dn_transp_stat.hard_err = 0;
        dn_transp_stat.rx_data_loss = 0;
        dn_transp_stat.rx_frame_loss = 0;
        dn_transp_stat.tx_data_loss = 0;
        dn_transp_stat.tx_frame_loss = 0;
        //
        dn_apb3_s.paddr = 0;
        dn_apb3_s.psel = 0;
        dn_apb3_s.penable = 0;
        dn_apb3_s.pwrite = 0;
        dn_apb3_s.pwdata = 0;
        //
        axis_master_idle_set(dn_transp_in);
        axis_master_idle_set(up_ctrl_in);
        axis_slave_ready_set(dn_transp_out, 1);
        axis_slave_ready_set(up_ctrl_out, 1);
        axis_slave_ready_set(up_data_out, 1);
    end


    // Make AXIS slaves ready randomly
    always @(posedge clk) begin
        axis_slave_ready_set(dn_transp_out, $random());
        axis_slave_ready_set(up_ctrl_out, $random());
        axis_slave_ready_set(up_data_out, $random());
    end


    // Test-bench logic
    initial begin
        #INITDLY;
        apb3_write(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA, 1);
        $display("");

        #INITDLY;
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_STATE);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT);
        $display("");

        dn_transp_stat.link_up = 1;
        apb3_write(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA, 1);
        $display("");

        #INITDLY;
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_STATE);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT);
        $display("");

        dn_transp_stat.link_up = 0;

        #INITDLY;
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_STATE);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT);
        $display("");

        dn_transp_stat.link_up = 1;

        #INITDLY;
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_STATE);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT);
        $display("");

        dn_transp_stat.hard_err = 1;

        #INITDLY;
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_STATE);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT);
        $display("");

        dn_transp_stat.hard_err = 0;

        #INITDLY;
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_STATE);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT);
        $display("");

        apb3_write(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA, 1);
        apb3_write(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT, 0);
        apb3_write(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT, 0);
        $display("");

        #INITDLY;
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_STATE);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_ENA);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT);
        apb3_read(dn_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT);
        $display("");

        tip_cmd_cfg_wr(up_ctrl_in, clk, 32'h11111111, 32'h22222222, '{32'h33333333, 32'h44444444, 32'h55555555, 32'h66666666});
        tip_data_send(dn_transp_in, clk, 32'h11111111, '{8'h22, 8'h33, 8'h44, 8'h55, 8'h66, 8'h77, 8'h88, 8'h99, 8'hAA});
        tip_rpt_cfg_wr(dn_transp_in, clk, 32'h11111111, 32'h22222222, 1'b0);
    end


    // TIP downstream endpoint
    tip_dn_ep the_tip_dn_ep (
        // Reset and clock
        .rst            (rst),              // i
        .clk            (clk),              // i

        // Downstream tsransport status
        .dn_transp_stat (dn_transp_stat),   // tip_transp_stat_if.slave

        // Streams to/from the downstream transport
        .dn_transp_in   (dn_transp_in),     // axis_if.slave
        .dn_transp_out  (dn_transp_out),    // axis_if.master

        // APB3 slave to control the downstream endpoint
        .dn_apb3_s      (dn_apb3_s),        // apb3_if.slave

        // Streams to/from the upstream endpoint
        .up_ctrl_in     (up_ctrl_in),       // axis_if.slave
        .up_ctrl_out    (up_ctrl_out),      // axis_if.master
        .up_data_out    (up_data_out)       // axis_if.master
    ); // the_tip_dn_ep

endmodule: tip_dn_ep_tb