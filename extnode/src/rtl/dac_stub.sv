/*
    // AD9148 DAC stub
    dac_stub the_dac_stub
    (
        // DAC reference clock
        .clk            (), // i

        // DAC data interface A
        .dac_data_a_p   (), // o  [15 : 0]
        .dac_data_a_n   (), // o  [15 : 0]
        .dac_frame_a_p  (), // o
        .dac_frame_a_n  (), // o
        .dac_clock_a_p  (), // o
        .dac_clock_a_n  (), // o

        // DAC data interface A
        .dac_data_b_p   (), // o  [15 : 0]
        .dac_data_b_n   (), // o  [15 : 0]
        .dac_frame_b_p  (), // o
        .dac_frame_b_n  (), // o
        .dac_clock_b_p  (), // o
        .dac_clock_b_n  (), // o

        // DAC control interface
        .dac_spi_rstn   (), // o
        .dac_spi_cs_n   (), // o
        .dac_spi_sclk   (), // o
        .dac_spi_mosi   (), // o
        .dac_spi_miso   ()  // i
    ); // the_dac_stub
*/

module dac_stub
(
    // DAC reference clock
    input  logic            clk,

    // DAC data interface A
    output wire  [15 : 0]   dac_data_a_p,
    output wire  [15 : 0]   dac_data_a_n,
    output wire             dac_frame_a_p,
    output wire             dac_frame_a_n,
    output wire             dac_clock_a_p,
    output wire             dac_clock_a_n,

    // DAC data interface A
    output wire  [15 : 0]   dac_data_b_p,
    output wire  [15 : 0]   dac_data_b_n,
    output wire             dac_frame_b_p,
    output wire             dac_frame_b_n,
    output wire             dac_clock_b_p,
    output wire             dac_clock_b_n,

    // DAC control interface
    output wire             dac_spi_rstn,
    output wire             dac_spi_cs_n,
    output wire             dac_spi_sclk,
    output wire             dac_spi_mosi,
    input  wire             dac_spi_miso
);
    // Variables
    logic           frame_cnt = '0;
    logic [31 : 0]  data_cnt  = '0;
    //
    logic           dac_clock_a;
    logic           dac_clock_b;
    //
    logic           dac_frame_a;
    logic           dac_frame_b;
    //
    logic [15 : 0]  dac_data_a;
    logic [15 : 0]  dac_data_b;


    // Dummy counters counter
    always @(posedge clk) begin
        frame_cnt <= !frame_cnt;
        data_cnt  <= data_cnt + 1'b1;
    end


    // ODDR instance
    ODDR #(
        .DDR_CLK_EDGE   ("SAME_EDGE"),
        .INIT           (1'b0),
        .SRTYPE         ("SYNC")
    )
    oddr_dac_clock_a (
        .Q              (dac_clock_a),
        .C              (clk),
        .CE             (1'b1),
        .D1             (1'b0),
        .D2             (1'b1),
        .R              (1'b0),
        .S              (1'b0)
    ); // oddr_dac_clock_a


    // OBUFDS instance
    OBUFDS obufds_dac_clock_a (
        .O      (dac_clock_a_p),
        .OB     (dac_clock_a_n),
        .I      (dac_clock_a)
    ); // obufds_dac_clock_a


    // ODDR instance
    ODDR #(
        .DDR_CLK_EDGE   ("SAME_EDGE"),
        .INIT           (1'b0),
        .SRTYPE         ("SYNC")
    )
    oddr_dac_clock_b (
        .Q              (dac_clock_b),
        .C              (clk),
        .CE             (1'b1),
        .D1             (1'b0),
        .D2             (1'b1),
        .R              (1'b0),
        .S              (1'b0)
    ); // oddr_dac_clock_b


    // OBUFDS instance
    OBUFDS obufds_dac_clock_b (
        .O      (dac_clock_b_p),
        .OB     (dac_clock_b_n),
        .I      (dac_clock_b)
    ); // obufds_dac_clock_b


    // ODDR instance
    ODDR #(
        .DDR_CLK_EDGE   ("SAME_EDGE"),
        .INIT           (1'b0),
        .SRTYPE         ("SYNC")
    )
    oddr_dac_frame_a (
        .Q              (dac_frame_a),
        .C              (clk),
        .CE             (1'b1),
        .D1             (frame_cnt),
        .D2             (frame_cnt),
        .R              (1'b0),
        .S              (1'b0)
    ); // oddr_dac_frame_a


    // OBUFDS instance
    OBUFDS obufds_dac_frame_a (
        .O      (dac_frame_a_p),
        .OB     (dac_frame_a_n),
        .I      (dac_frame_a)
    ); // obufds_dac_frame_a


    // ODDR instance
    ODDR #(
        .DDR_CLK_EDGE   ("SAME_EDGE"),
        .INIT           (1'b0),
        .SRTYPE         ("SYNC")
    )
    oddr_dac_frame_b (
        .Q              (dac_frame_b),
        .C              (clk),
        .CE             (1'b1),
        .D1             (frame_cnt),
        .D2             (frame_cnt),
        .R              (1'b0),
        .S              (1'b0)
    ); // oddr_dac_frame_b


    // OBUFDS instance
    OBUFDS obufds_dac_frame_b (
        .O      (dac_frame_b_p),
        .OB     (dac_frame_b_n),
        .I      (dac_frame_b)
    ); // obufds_dac_frame_b


    // ODDR instance
    ODDR #(
        .DDR_CLK_EDGE   ("SAME_EDGE"),
        .INIT           (1'b0),
        .SRTYPE         ("SYNC")
    )
    oddr_dac_data_a [15 : 0] (
        .Q              (dac_data_a),
        .C              (clk),
        .CE             (1'b1),
        .D1             (data_cnt[15 : 0]),
        .D2             (data_cnt[31 : 16]),
        .R              (1'b0),
        .S              (1'b0)
    ); // oddr_dac_data_a


    // OBUFDS instance
    OBUFDS obufds_dac_data_a [15 : 0] (
        .O      (dac_data_a_p),
        .OB     (dac_data_a_n),
        .I      (dac_data_a)
    ); // obufds_dac_data_a


    // ODDR instance
    ODDR #(
        .DDR_CLK_EDGE   ("SAME_EDGE"),
        .INIT           (1'b0),
        .SRTYPE         ("SYNC")
    )
    oddr_dac_data_b [15 : 0] (
        .Q              (dac_data_b),
        .C              (clk),
        .CE             (1'b1),
        .D1             (data_cnt[15 : 0]),
        .D2             (data_cnt[31 : 16]),
        .R              (1'b0),
        .S              (1'b0)
    ); // oddr_dac_data_b


    // OBUFDS instance
    OBUFDS obufds_dac_data_b [15 : 0] (
        .O      (dac_data_b_p),
        .OB     (dac_data_b_n),
        .I      (dac_data_b)
    ); // obufds_dac_data_b


    // Terminate the DAC control interface
    assign dac_spi_rstn = 1'b1;
    assign dac_spi_cs_n = 1'b1;
    assign dac_spi_sclk = 1'b1;
    assign dac_spi_mosi = 1'b1;

endmodule: dac_stub