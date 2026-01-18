`timescale 1ps / 1ps

module aurora64b66b_wrp_tb ();

    // Public clock parameters
    localparam longint unsigned GT_CLKFREQ_HZ   = 156_250_000;
    localparam longint unsigned INIT_CLKFREQ_HZ = 100_000_000;
    // Private clock parameters (don't modify)
    localparam longint unsigned GT_CLKP_PS      = 64'd1_000_000_000_000 / GT_CLKFREQ_HZ;
    localparam longint unsigned GT_CLKHP_PS     = GT_CLKP_PS / 2;
    localparam longint unsigned INIT_CLKP_PS    = 64'd1_000_000_000_000 / INIT_CLKFREQ_HZ;
    localparam longint unsigned INIT_CLKHP_PS   = INIT_CLKP_PS / 2;


    // Public delay parameters
    localparam longint unsigned RSTLEN  = 5 * INIT_CLKHP_PS;


    // Public simulation parameters
    localparam int unsigned     PACK_LEN = 16;


    // Variables declaration
    logic           rst;
    //
    logic           gt_clk;
    logic           init_clk;
    //
    logic           user_rst;
    logic           user_clk;
    //
    logic [1 : 0]   gt_serial0_p;
    logic [1 : 0]   gt_serial0_n;
    logic [1 : 0]   gt_serial1_p;
    logic [1 : 0]   gt_serial1_n;
    //
    logic           channel_up0;
    logic           channel_up1;
    logic [1 : 0]   lane_up0;
    logic [1 : 0]   lane_up1;
    //
    logic           hard_err0;
    logic           hard_err1;
    logic           soft_err0;
    logic           soft_err1;
    //
    logic [127 : 0] tx0_tdata;
    logic [15 : 0]  tx0_tkeep;
    logic           tx0_tvalid;
    logic           tx0_tlast;
    logic           tx0_tready;
    //
    logic [127 : 0] tx1_tdata;
    logic [15 : 0]  tx1_tkeep;
    logic           tx1_tvalid;
    logic           tx1_tlast;
    logic           tx1_tready;
    //
    logic [127 : 0] rx0_tdata;
    logic [15 : 0]  rx0_tkeep;
    logic           rx0_tvalid;
    logic           rx0_tlast;
    //
    logic [127 : 0] rx1_tdata;
    logic [15 : 0]  rx1_tkeep;
    logic           rx1_tvalid;
    logic           rx1_tlast;

    // GT clock generation
    initial gt_clk = 1'b1;
    always  gt_clk = #GT_CLKHP_PS ~gt_clk;


    // Init clock generation
    initial init_clk = 1'b1;
    always  init_clk = #INIT_CLKHP_PS ~init_clk;


    // Reset generation
    initial begin
        #0ns    rst = 1'b1;
        #RSTLEN rst = 1'b0;
    end


    // Defaults
    initial begin
        tx0_tdata   = 0;
        tx0_tkeep   = 0;
        tx0_tvalid  = 0;
        tx0_tlast   = 0;
        //
        tx1_tdata   = 0;
        tx1_tkeep   = 0;
        tx1_tvalid  = 0;
        tx1_tlast   = 0;
    end


    // Send data to the 0th port
    initial begin
        automatic byte idx = 0;

        do begin
            @(posedge user_clk);
        end while (!channel_up0);

        $display("Link 0 is UP!");

        @(posedge user_clk);

        tx0_tdata = {16{idx}};
        tx0_tkeep = {16{1'b1}};
        tx0_tvalid = 1;
        tx0_tlast = (PACK_LEN == 1);
        do begin
            @(posedge user_clk);
            if (tx0_tready) begin
                idx++;
                tx0_tdata = {16{idx}};
                tx0_tlast = (idx == (PACK_LEN - 1));
            end
        end while (idx < PACK_LEN);
        tx0_tdata = 0;
        tx0_tkeep = 0;
        tx0_tvalid = 0;
        tx0_tlast = 0;
    end


    // Send data to the 1st port
    initial begin
        automatic byte idx = 0;

        do begin
            @(posedge user_clk);
        end while (!channel_up1);

        $display("Link 1 is UP!");

        @(posedge user_clk);

        tx1_tdata = {16{idx}};
        tx1_tkeep = {16{1'b1}};
        tx1_tvalid = 1;
        tx1_tlast = (PACK_LEN == 1);
        do begin
            @(posedge user_clk);
            if (tx1_tready) begin
                idx++;
                tx1_tdata = {16{idx}};
                tx1_tlast = (idx == (PACK_LEN - 1));
            end
        end while (idx < PACK_LEN);
        tx1_tdata = 0;
        tx1_tkeep = 0;
        tx1_tvalid = 0;
        tx1_tlast = 0;
    end


    // Aurora 64b66b IP wrapper
    aurora64b66b_wrp #(
        .CH_CNT     (2)         // The number of channels
    )
    DUT (
        // Common reset
        .reset      (rst),      // i

        // GT reference clock input
        .gt_clk     (gt_clk),   // i

        // Free running clock input
        .init_clk   (init_clk), // i

        // User reset and clock outputs
        .user_rst   (user_rst), // o
        .user_clk   (user_clk), // o

        // GT serial RX
        .gt_rx_p    ({
                        gt_serial0_p,
                        gt_serial1_p
                    }),         // i  [CH_CNT - 1 : 0][1 : 0]
        .gt_rx_n    ({
                        gt_serial0_n,
                        gt_serial1_n
                    }),         // i  [CH_CNT - 1 : 0][1 : 0]

        // GT serial TX
        .gt_tx_p    ({
                        gt_serial1_p,
                        gt_serial0_p
                    }),         // o  [CH_CNT - 1 : 0][1 : 0]
        .gt_tx_n    ({
                        gt_serial1_n,
                        gt_serial0_n
                    }),         // o  [CH_CNT - 1 : 0][1 : 0]

        // Link status
        .channel_up ({
                        channel_up1,
                        channel_up0
                    }),         // o  [CH_CNT - 1 : 0]
        .lane_up    ({
                        lane_up1,
                        lane_up0
                    }),         // o  [CH_CNT - 1 : 0][1 : 0]

        // Error detection status
        .hard_err   ({
                        hard_err1,
                        hard_err0
                    }),         // o  [CH_CNT - 1 : 0]
        .soft_err   ({
                        soft_err1,
                        soft_err0
                    }),         // o  [CH_CNT - 1 : 0]

        // AXIS TX interface
        .tx_tdata   ({
                        tx1_tdata,
                        tx0_tdata
                    }),         // i  [CH_CNT - 1 : 0][127 : 0]
        .tx_tkeep   ({
                        tx1_tkeep,
                        tx0_tkeep
                    }),         // i  [CH_CNT - 1 : 0][15 : 0]
        .tx_tvalid  ({
                        tx1_tvalid,
                        tx0_tvalid
                    }),         // i  [CH_CNT - 1 : 0]
        .tx_tlast   ({
                        tx1_tlast,
                        tx0_tlast
                    }),         // i  [CH_CNT - 1 : 0]
        .tx_tready  ({
                        tx1_tready,
                        tx0_tready
                    }),         // o  [CH_CNT - 1 : 0]

        // AXIS RX interface
        .rx_tdata   ({
                        rx1_tdata,
                        rx0_tdata
                    }),         // o  [CH_CNT - 1 : 0][127 : 0]
        .rx_tkeep   ({
                        rx1_tkeep,
                        rx0_tkeep
                    }),         // o  [CH_CNT - 1 : 0][15 : 0]
        .rx_tvalid  ({
                        rx1_tvalid,
                        rx0_tvalid
                    }),         // o  [CH_CNT - 1 : 0]
        .rx_tlast   ({
                        rx1_tlast,
                        rx0_tlast
                    })          // o  [CH_CNT - 1 : 0]
    ); // DUT

endmodule: aurora64b66b_wrp_tb
