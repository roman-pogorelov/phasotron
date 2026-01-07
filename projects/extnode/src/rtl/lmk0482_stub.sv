/*
    // LMK0482 control stub
    lmk0482_stub the_lmk0482_stub
    (
        // Output clock/synchronization
        .lmk0482_clkin0_p   (), // o
        .lmk0482_clkin0_n   (), // o

        // Control
        .lmk0482_reset      (), // o
        .lmk0482_sync       (), // o
        .lmk0482_clkin_sel0 (), // o
        .lmk0482_clkin_sel1 (), // o
        .lmk0482_status_ld1 (), // i
        .lmk0482_status_ld2 (), // i
        .lmk0482_spi_cs_n   (), // o
        .lmk0482_spi_sclk   (), // o
        .lmk0482_spi_sdio   ()  // io
    ); // the_lmk0482_stub
*/


module lmk0482_stub
(
    // Output clock/synchronization
    output  wire    lmk0482_clkin0_p,
    output  wire    lmk0482_clkin0_n,

    // Control
    output  wire    lmk0482_reset,
    output  wire    lmk0482_sync,
    output  wire    lmk0482_clkin_sel0,
    output  wire    lmk0482_clkin_sel1,
    input   wire    lmk0482_status_ld1,
    input   wire    lmk0482_status_ld2,
    output  wire    lmk0482_spi_cs_n,
    output  wire    lmk0482_spi_sclk,
    inout   wire    lmk0482_spi_sdio
);
    // OBUFDS instance
    OBUFDS obufds_lmk0482_clkin0 (
        .I      (1'b1),
        .O      (lmk0482_clkin0_p),
        .OB     (lmk0482_clkin0_n)
    ); // obufds_lmk0482_clkin0


    // Terminate the control
    assign lmk0482_reset        = 1'b0;
    assign lmk0482_sync         = 1'b0;
    assign lmk0482_clkin_sel0   = 1'b0;
    assign lmk0482_clkin_sel1   = 1'b0;
    assign lmk0482_spi_cs_n     = 1'b1;
    assign lmk0482_spi_sclk     = 1'b0;
    assign lmk0482_spi_sdio     = 1'bz;

endmodule:lmk0482_stub