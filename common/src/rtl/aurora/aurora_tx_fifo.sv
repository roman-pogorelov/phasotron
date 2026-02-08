/*
    // Aurora TX FIFO
    aurora_tx_fifo #(
        .DATA_W         (), // AXI-S data bus width
        .KEEP_W         (), // AXI-S keep bus width
        .FIFO_DEPTH     ()  // FIFO depth
    )
    the_aurora_tx_fifo (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // FIFO status
        .fifo_ready     (), // o

        // Incoming AXI stream
        .i_tdata        (), // i  [DATA_W - 1 : 0]
        .i_tkeep        (), // i  [KEEP_W - 1 : 0]
        .i_tvalid       (), // i
        .i_tlast        (), // i
        .i_tready       (), // o

        // TX AXI stream going out
        .o_tdata        (), // o  [DATA_W - 1 : 0]
        .o_tkeep        (), // o  [KEEP_W - 1 : 0]
        .o_tvalid       (), // o
        .o_tlast        (), // o
        .o_tready       ()  // i
    ); // the_aurora_tx_fifo
*/


module aurora_tx_fifo
#(
    parameter int unsigned          DATA_W      = 8,            // AXI-S data bus width
    parameter int unsigned          KEEP_W      = DATA_W / 8,   // AXI-S keep bus width
    parameter int unsigned          FIFO_DEPTH  = 32            // FIFO depth
)
(
    // Reset and clock
    input  logic                    rst,
    input  logic                    clk,

    // FIFO status
    output logic                    fifo_ready,

    // Incoming AXI stream
    input  logic [DATA_W - 1 : 0]   i_tdata,
    input  logic [KEEP_W - 1 : 0]   i_tkeep,
    input  logic                    i_tvalid,
    input  logic                    i_tlast,
    output logic                    i_tready,

    // TX AXI stream going out
    output logic [DATA_W - 1 : 0]   o_tdata,
    output logic [KEEP_W - 1 : 0]   o_tkeep,
    output logic                    o_tvalid,
    output logic                    o_tlast,
    input  logic                    o_tready
);
    // Variables
    logic       rd_rst_busy;
    logic       wr_rst_busy;
    //
    logic       full;
    logic       empty;


    // XPM FIFO instance
    xpm_fifo_sync #(
        .CASCADE_HEIGHT         (0),
        .DOUT_RESET_VALUE       ("0"),
        .ECC_MODE               ("no_ecc"),
        .FIFO_MEMORY_TYPE       ("auto"),
        .FIFO_READ_LATENCY      (0),
        .FIFO_WRITE_DEPTH       (FIFO_DEPTH),
        .FULL_RESET_VALUE       (0),
        .PROG_EMPTY_THRESH      (10),
        .PROG_FULL_THRESH       (10),
        .RD_DATA_COUNT_WIDTH    ($clog2(FIFO_DEPTH + 1)),
        .READ_DATA_WIDTH        (KEEP_W + DATA_W + 1),
        .READ_MODE              ("fwft"),
        .SIM_ASSERT_CHK         (0),
        .USE_ADV_FEATURES       ("0000"),
        .WAKEUP_TIME            (0),
        .WRITE_DATA_WIDTH       (KEEP_W + DATA_W + 1),
        .WR_DATA_COUNT_WIDTH    ($clog2(FIFO_DEPTH + 1))
    )
    tx_fifo (
        .almost_empty           (  ),                           // 1-bit output
        .almost_full            (  ),                           // 1-bit output
        .data_valid             (  ),                           // 1-bit output
        .dbiterr                (  ),                           // 1-bit output
        .dout                   ({o_tdata, o_tkeep, o_tlast}),  // READ_DATA_WIDTH-bit output
        .empty                  (empty),                        // 1-bit output
        .full                   (full),                         // 1-bit output
        .overflow               (  ),                           // 1-bit output
        .prog_empty             (  ),                           // 1-bit output
        .prog_full              (  ),                           // 1-bit output
        .rd_data_count          (  ),                           // RD_DATA_COUNT_WIDTH-bit output
        .rd_rst_busy            (rd_rst_busy),                  // 1-bit output
        .sbiterr                (  ),                           // 1-bit output
        .underflow              (  ),                           // 1-bit output
        .wr_ack                 (  ),                           // 1-bit output
        .wr_data_count          (  ),                           // WR_DATA_COUNT_WIDTH-bit output
        .wr_rst_busy            (wr_rst_busy),                  // 1-bit output
        .din                    ({i_tdata, i_tkeep, i_tlast}),  // WRITE_DATA_WIDTH-bit input
        .injectdbiterr          (1'b1),                         // 1-bit input
        .injectsbiterr          (1'b1),                         // 1-bit input
        .rd_en                  (fifo_ready & o_tready),        // 1-bit input
        .rst                    (rst),                          // 1-bit input
        .sleep                  (1'b1),                         // 1-bit input
        .wr_clk                 (clk),                          // 1-bit input
        .wr_en                  (fifo_ready & i_tvalid)         // 1-bit input
    ); // tx_fifo


    // Indicates if the FIFO is ready after reset
    initial fifo_ready = 1'b0;
    always @(posedge rst, posedge clk) begin
        if (rst)
            fifo_ready <= 1'b0;
        else
            fifo_ready <= !(wr_rst_busy | rd_rst_busy);
    end


    // Incoming stream can come in as long as the FIFO is not full
    assign i_tready = fifo_ready & !full;


    // Outgoing stream data are valid as long as the FIFO is not empty
    assign o_tvalid = fifo_ready & !empty;

endmodule: aurora_tx_fifo