`timescale  1ns / 1ps

import axis_sim::*;
import apb3_sim::*;
import tip_sim::*;

module tip_axis_apb3_bridge_tb ();

    // Public clock parameters
    localparam int unsigned CLKFREQ_HZ      = 100_000_000;
    // Private clock parameters (don't modify)
    localparam int unsigned CLKP_NS         = 1_000_000_000 / CLKFREQ_HZ;
    localparam int unsigned CLKHP_NS        = CLKP_NS / 2;


    // Public delay parameters
    localparam int unsigned RSTLEN          = 5 * CLKHP_NS;
    localparam int unsigned INITDLY         = 10 * CLKP_NS;


    // Public DUT paramaters
    localparam int unsigned RPT_TYPE        = 0;


    // Valiables
    logic                   rst;
    logic                   clk;

    // Interfaces
    tip_up_conf_if  conf();
    //
    axis_if         in();
    axis_if         out();
    //
    apb3_if         apb3();


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
        conf.indiv_addr = 'h11111111;
        conf.group_addr0 = 0;
        conf.group_addr1 = 0;
        conf.group_addr2 = 0;
        conf.group_addr3 = 0;
        conf.group_addr4 = 0;
        conf.group_addr5 = 0;
        conf.group_addr6 = 0;
        conf.group_addr7 = 0;
        //
        axis_master_idle_set(in);
        axis_slave_ready_set(out, 1);
        //
        apb3.pready = 1;
        apb3.prdata = 0;
        apb3.pslverr = 0;
    end


    // Make ready signals random
    always @(posedge clk) begin
        axis_slave_ready_set(out, $random());
        apb3.pready <= $random();
    end


    // Generate random PRDATA on the APB3
    always @(posedge clk) begin
        if (apb3.psel & !apb3.penable & !apb3.pwrite) begin
            apb3.prdata <= $random();
        end
    end


    // Test-bench logic
    initial begin
        #INITDLY;
        tip_cmd_cfg_wr(in, clk, 32'h11111111, 32'h80000000, '{32'h33333333, 32'h44444444, 32'h55555555, 32'h66666666});
        tip_cmd_cfg_rd(in, clk, 32'h11111111, 32'h80000000, 13);
    end


    // Converts TIP AXIS packets into APB3 transactions and
    // converts APB3 responses back into TIP AXIS packets
    tip_axis_apb3_bridge #(
        .RPT_TYPE   (RPT_TYPE)  // Report type: 0 - configuration report, 1 - user report
    )
    the_tip_axis_apb3_bridge (
        // Reset and clock
        .rst        (rst),      // i
        .clk        (clk),      // i

        // Configuration interface
        .conf       (conf),     // tip_up_conf_if.slave

        // Control streams
        .ctrl_in    (in),       // axis_if.slave
        .ctrl_out   (out),      // axis_if.master

        // APB3 master
        .apb3_m     (apb3)      // apb3_if.master
    ); // the_tip_axis_apb3_bridge

endmodule: tip_axis_apb3_bridge_tb