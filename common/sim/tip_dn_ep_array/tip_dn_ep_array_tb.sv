`timescale  1ns / 1ps

module tip_dn_ep_array_tb ();

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
    localparam int unsigned DN_CNT          = 3;


    // APB3 write
    task automatic apb3_read_all(virtual apb3_if.master apb3_m, ref logic clk);
        static int id = 0;
        $display("APB3 read back cycle #%0d", id++);
        apb3_read(apb3_m, clk, TIP_CFG_ADDR_DN_CNT);
        apb3_read(apb3_m, clk, TIP_CFG_ADDR_DN_LINK_STATE);
        for (int i = 0; i < DN_CNT; i++) begin
            $display("DN EP %0d:", i);
            apb3_read(apb3_m, clk, TIP_CFG_ADDR_DN_ENA + (i * 4));
            apb3_read(apb3_m, clk, TIP_CFG_ADDR_DN_LINK_UP_CNT + (i * 4));
            apb3_read(apb3_m, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT + (i * 4));
        end
        $display("");
    endtask


    // Valiables
    logic                   rst;
    logic                   clk;


    // Interfaces
    tip_transp_stat_if      dn_transp_stat[DN_CNT]();
    //
    apb3_if                 up_apb3_s();
    apb3_if                 dn_apb3_s[DN_CNT]();
    //
    axis_if                 dn_transp_in[DN_CNT]();
    axis_if                 dn_transp_out[DN_CNT]();
    //
    axis_if                 dn2up_ctrl[DN_CNT]();
    axis_if                 up2dn_ctrl[DN_CNT]();
    //
    axis_if                 up_ctrl_in();
    axis_if                 up_ctrl_out();
    //
    axis_if                 up_data_out[DN_CNT]();


    // Clock generation
    initial clk = 1'b1;
    always  clk = #CLKHP_NS ~clk;


    // Reset generation
    initial begin
        #0ns    rst = 1'b1;
        #RSTLEN rst = 1'b0;
    end


    // Generate logic according to the number of downstream endpoints
    generate
        genvar i;
        for (i = 0; i < DN_CNT; i++) begin: gen_logic

            // Defaults
            initial begin
                dn_transp_stat[i].link_up = 0;
                dn_transp_stat[i].soft_err = 0;
                dn_transp_stat[i].hard_err = 0;
                dn_transp_stat[i].rx_data_loss = 0;
                dn_transp_stat[i].rx_frame_loss = 0;
                dn_transp_stat[i].tx_data_loss = 0;
                dn_transp_stat[i].tx_frame_loss = 0;
                //
                axis_master_idle_set(dn_transp_in[i]);
                axis_slave_ready_set(dn_transp_out[i], 1);
                //
                axis_slave_ready_set(up_data_out[i], 1);
            end

            // Make AXIS slaves ready randomly
            always @(posedge clk) begin
                axis_slave_ready_set(dn_transp_out[i], $random());
                axis_slave_ready_set(up_data_out[i], $random());
            end

        end // gen_logic
    endgenerate


    // Defaults
    initial begin
        apb3_idle_set(up_apb3_s);
        //
        axis_master_idle_set(up_ctrl_in);
        axis_slave_ready_set(up_ctrl_out, 1);
    end


    // Make AXIS slaves ready randomly
    always @(posedge clk) begin
        axis_slave_ready_set(up_ctrl_out, $random());
    end

    // Test-bench logic
    initial begin
        #INITDLY;
        apb3_read_all(up_apb3_s, clk);
        dn_transp_stat[0].link_up = 1;
        apb3_read_all(up_apb3_s, clk);
        dn_transp_stat[1].link_up = 1;
        apb3_read_all(up_apb3_s, clk);
        dn_transp_stat[2].link_up = 1;
        apb3_read_all(up_apb3_s, clk);
        dn_transp_stat[0].link_up = 0;
        apb3_read_all(up_apb3_s, clk);
        dn_transp_stat[0].link_up = 1;
        apb3_read_all(up_apb3_s, clk);
        dn_transp_stat[1].hard_err = 1;
        apb3_read_all(up_apb3_s, clk);
        apb3_read_all(up_apb3_s, clk);
        dn_transp_stat[1].hard_err = 0;
        apb3_write(up_apb3_s, clk, TIP_CFG_ADDR_DN_LINK_ERR_CNT + 4, 0);
        apb3_write(up_apb3_s, clk, TIP_CFG_ADDR_DN_ENA, 1);
        apb3_read_all(up_apb3_s, clk);
        apb3_write(up_apb3_s, clk, TIP_CFG_ADDR_DN_ENA + 4, 1);
        apb3_read_all(up_apb3_s, clk);
        apb3_write(up_apb3_s, clk, TIP_CFG_ADDR_DN_ENA + 8, 1);
        apb3_read_all(up_apb3_s, clk);
        tip_cmd_cfg_wr(up_ctrl_in, clk, 32'h11111111, 32'h22222222, '{32'h33333333, 32'h44444444, 32'h55555555, 32'h66666666});
        tip_data_send(dn_transp_in[0], clk, 32'h11111111, '{8'h22, 8'h33, 8'h44, 8'h55, 8'h66, 8'h77, 8'h88, 8'h99, 8'hAA});
        tip_data_send(dn_transp_in[1], clk, 32'hBBBBBBBB, '{8'h22, 8'h33, 8'h44, 8'h55, 8'h66, 8'h77, 8'h88, 8'h99, 8'hAA});
        tip_data_send(dn_transp_in[2], clk, 32'hCCCCCCCC, '{8'h22, 8'h33, 8'h44, 8'h55, 8'h66, 8'h77, 8'h88, 8'h99, 8'hAA});
        tip_rpt_cfg_wr(dn_transp_in[0], clk, 32'h11111111, 32'hAAAAAAAA, 1'b0);
        tip_rpt_cfg_wr(dn_transp_in[1], clk, 32'h22222222, 32'hAAAAAAAA, 1'b0);
        tip_rpt_cfg_wr(dn_transp_in[2], clk, 32'h33333333, 32'hAAAAAAAA, 1'b0);

/*

        tip_cmd_cfg_wr(up_ctrl_in, clk, 32'h11111111, 32'h22222222, '{32'h33333333, 32'h44444444, 32'h55555555, 32'h66666666});
        tip_data_send(dn_transp_in, clk, 32'h11111111, '{8'h22, 8'h33, 8'h44, 8'h55, 8'h66, 8'h77, 8'h88, 8'h99, 8'hAA});
        tip_rpt_cfg_wr(dn_transp_in, clk, 32'h11111111, 32'h22222222, 1'b0);
*/
    end



    // APB3 interconnect routing downstream control transactions
    // driven by the upstream endpoint
    tip_mid_apb3_intcon #(
        .DN_CNT         (DN_CNT)        // Number of downstream links
    )
    tip_mid_apb3_intcon (
        // Reset and clock
        .rst            (rst),          // i
        .clk            (clk),          // i

        // APB3 slave from the upstream endpoint
        .up_apb3_s      (up_apb3_s),    // apb3_if.slave

        // APB3 masters to the downstream endpoints
        .dn_apb3_m      (dn_apb3_s)     // apb3_if[DN_CNT].master
    ); // tip_mid_apb3_intcon


    // AXIS interconnect routing control packets
    // between the upstream and downstream endpoints
    tip_mid_axis_intcon #(
        .DN_CNT         (DN_CNT)        // Number of downstream links
    )
    the_tip_mid_axis_intcon (
        // Reset and clock
        .rst            (rst),          // i
        .clk            (clk),          // i

        // Streams to/from the upstream endpoint
        .up_ctrl_in     (up_ctrl_in),   // axis_if.slave
        .up_ctrl_out    (up_ctrl_out),  // axis_if.master

        // Streams to/from the downstream endpoints
        .dn_ctrl_in     (dn2up_ctrl),   // axis_if[DN_CNT].slave
        .dn_ctrl_out    (up2dn_ctrl)   // axis_if[DN_CNT].master
    ); // the_tip_mid_axis_intcon


    // Generate TIP downstream endpoints
    generate
        genvar j;
        for (j = 0; j < DN_CNT; j++) begin: tip_dn_ep_gen

            // TIP downstream endpoint
            tip_dn_ep #(
                .DN_ID          (j)                     // Downstream endpoint ID
            )
            the_tip_dn_ep (
                // Reset and clock
                .rst            (rst),                  // i
                .clk            (clk),                  // i

                // Downstream tsransport status
                .dn_transp_stat (dn_transp_stat[j]),    // tip_transp_stat_if.slave

                // Streams to/from the downstream transport
                .dn_transp_in   (dn_transp_in[j]),      // axis_if.slave
                .dn_transp_out  (dn_transp_out[j]),     // axis_if.master

                // APB3 slave to control the downstream endpoint
                .dn_apb3_s      (dn_apb3_s[j]),         // apb3_if.slave

                // Streams to/from the upstream endpoint
                .up_ctrl_in     (up2dn_ctrl[j]),        // axis_if.slave
                .up_ctrl_out    (dn2up_ctrl[j]),        // axis_if.master
                .up_data_out    (up_data_out[j])        // axis_if.master
            ); // the_tip_dn_ep

        end // tip_dn_ep_gen
    endgenerate


endmodule: tip_dn_ep_array_tb