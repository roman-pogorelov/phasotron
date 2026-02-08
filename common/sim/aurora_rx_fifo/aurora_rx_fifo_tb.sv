`timescale  1ns / 1ps

module aurora_rx_fifo_tb ();

    // Public clock parameters
    localparam int unsigned CLKFREQ_HZ      = 100000000;
    // Private clock parameters (don't modify)
    localparam int unsigned CLKP_NS         = 1000000000 / CLKFREQ_HZ;
    localparam int unsigned CLKHP_NS        = CLKP_NS / 2;


    // Public delay parameters
    localparam int unsigned RSTLEN          = 5 * CLKHP_NS;
    localparam int unsigned XFRDLY          = 15 * CLKP_NS;


    // Public DUT parameters
    localparam int unsigned DATA_W          = 8;
    localparam int unsigned KEEP_W          = DATA_W / 8;
    localparam int unsigned FIFO_DEPTH      = 64;
    localparam int unsigned FIFO_LWM        = 32;
    localparam int unsigned FIFO_HWM        = 56;


    // Public transfer parameters
    localparam int unsigned FRAME_LEN       = 40;
    localparam int unsigned FRAME_CNT       = 5;


    // Valiables declaration
    logic                   rst;
    logic                   clk;
    //
    logic                   fifo_ready;
    logic                   fifo_below_lwm;
    logic                   fifo_above_hwm;
    //
    logic [DATA_W - 1 : 0]  i_tdata;
    logic [KEEP_W - 1 : 0]  i_tkeep;
    logic                   i_tvalid;
    logic                   i_tlast;
    //
    logic [DATA_W - 1 : 0]  o_tdata;
    logic [KEEP_W - 1 : 0]  o_tkeep;
    logic                   o_tvalid;
    logic                   o_tlast;
    logic                   o_tready;


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
        i_tdata     = 0;
        i_tkeep     = 0;
        i_tvalid    = 0;
        i_tlast     = 0;
        //
        o_tready    = 1;
    end


    // Transfer data
    initial begin

        #XFRDLY;
        @(posedge clk);

        i_tvalid = 1;
        for (int fId = 0; fId < FRAME_CNT; fId++) begin
            for (int dId = 0; dId < FRAME_LEN; dId++) begin
                i_tdata = $random();
                i_tkeep = dId == (FRAME_LEN - 1) ? $random() : 0;
                i_tlast = dId == (FRAME_LEN - 1);
                @(posedge clk);
            end
        end
        i_tvalid = 0;
        i_tdata = 0;
        i_tkeep = 0;
        i_tlast = 0;
    end


    // Aurora RX FIFO
    aurora_rx_fifo #(
        .DATA_W         (DATA_W),           // AXI-S data bus width
        .KEEP_W         (KEEP_W),           // AXI-S keep bus width
        .FIFO_DEPTH     (FIFO_DEPTH),       // FIFO depth
        .FIFO_LWM       (FIFO_LWM),         // FIFO low watermark
        .FIFO_HWM       (FIFO_HWM)          // FIFO high watermark
    )
    DUT (
        // Reset and clock
        .rst            (rst),              // i
        .clk            (clk),              // i

        // FIFO status
        .fifo_ready     (fifo_ready),       // o
        .fifo_below_lwm (fifo_below_lwm),   // o
        .fifo_above_hwm (fifo_above_hwm),   // o

        // Incoming AXI stream (w/o tready)
        .i_tdata        (i_tdata),          // i  [DATA_W - 1 : 0]
        .i_tkeep        (i_tkeep),          // i  [KEEP_W - 1 : 0]
        .i_tvalid       (i_tvalid),         // i
        .i_tlast        (i_tlast),          // i

        // RX AXI stream going out
        .o_tdata        (o_tdata),          // o  [DATA_W - 1 : 0]
        .o_tkeep        (o_tkeep),          // o  [KEEP_W - 1 : 0]
        .o_tvalid       (o_tvalid),         // o
        .o_tlast        (o_tlast),          // o
        .o_tready       (o_tready)          // i
    ); // DUT

endmodule: aurora_rx_fifo_tb