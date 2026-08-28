/*
    // Clock frequency estimator
    freq_estimator
    #(
        .PERIOD         (), // Duration of estimation in refclk cycles (PERIOD > 0)
        .FACTOR         ()  // The maximum estclk to refclk ration
    )
    the_freq_estimator
    (
        // Reference clock
        .refclk         (), // i

        // Estimable clock
        .estclk         (), // i

        // Estimated clock frequency
        .frequency      ()  // o  [$clog2(FACTOR * PERIOD) - 1 : 0]
    ); // the_freq_estimator
*/


module freq_estimator
#(
    parameter int unsigned                          PERIOD = 1000,  // Период замеров в тактах refclk (PERIOD > 0)
    parameter int unsigned                          FACTOR = 2      // Максимально возможное отношение estclk/refclk
)
(
    // Reference clock
    input  logic                                    refclk,

    // Estimable clock
    input  logic                                    estclk,

    // Estimated clock frequency
    output logic [$clog2(FACTOR * PERIOD) - 1 : 0]  frequency
);
    // Parameters
    localparam int unsigned     REF_CNT_W = $clog2(PERIOD);
    localparam int unsigned     EST_CNT_W = $clog2(PERIOD * FACTOR);

    // Signals
    logic [REF_CNT_W - 1 : 0]   ref_tick_cnt;
    logic                       ref_stb_reg;
    //
    logic [EST_CNT_W - 1 : 0]   est_tick_cnt;
    logic [EST_CNT_W - 1 : 0]   est_tick_cnt_gray;
    logic [EST_CNT_W - 1 : 0]   est_tick_cnt_gray_sync;
    logic [EST_CNT_W - 1 : 0]   est_tick_cnt_sync;
    //
    logic [EST_CNT_W - 1 : 0]   est_tick_curr;
    logic [EST_CNT_W - 1 : 0]   est_tick_prev;
    logic [EST_CNT_W - 1 : 0]   freq_est_reg;


    // Binary to gray
    function automatic logic [EST_CNT_W - 1 : 0] bin2gray(input logic [EST_CNT_W - 1 : 0] bin);
        bin2gray = {1'b0, bin[EST_CNT_W - 1 : 1]} ^ bin;
    endfunction


    // Gray to binary
    function automatic logic [EST_CNT_W - 1 : 0] gray2bin(input logic [EST_CNT_W - 1 : 0] gray);
        gray2bin[EST_CNT_W - 1] = gray[EST_CNT_W - 1];
        for (int i = EST_CNT_W - 2; i >= 0; i--)
            gray2bin[i] = gray2bin[i + 1] ^ gray[i];
    endfunction


    // Reference counter
    initial ref_tick_cnt = '0;
    always @(posedge refclk)
        if (ref_tick_cnt == PERIOD - 1)
            ref_tick_cnt <= '0;
        else
            ref_tick_cnt <= ref_tick_cnt + 1'b1;


    // The register of reference strobe
    initial ref_stb_reg = '0;
    always @(posedge refclk)
        ref_stb_reg <= (ref_tick_cnt == PERIOD - 1);


    // Estimable counter
    initial est_tick_cnt = '0;
    always @(posedge estclk)
        est_tick_cnt <= est_tick_cnt + 1'b1;


    // Estimable counter encoder in Gray code
    initial est_tick_cnt_gray = '0;
    always @(posedge estclk)
        est_tick_cnt_gray <= bin2gray(est_tick_cnt);


    // Synchronize the estimable counter encoder in Gray code
    // to the reference clock
    xpm_cdc_array_single #(
        .DEST_SYNC_FF   (3),
        .SRC_INPUT_REG  (0),
        .WIDTH          (EST_CNT_W)
    )
    gray_cnt_sync (
        .src_clk        (1'b0),
        .dest_clk       (refclk),
        .src_in         (est_tick_cnt_gray),
        .dest_out       (est_tick_cnt_gray_sync)
    ); // gray_cnt_sync


    // Estimable counter synchronized to the reference clock
    initial est_tick_cnt_sync = '0;
    always @(posedge refclk)
        est_tick_cnt_sync <= gray2bin(est_tick_cnt_gray_sync);


    // Current value of estimable counter
    assign est_tick_curr = est_tick_cnt_sync;


    // The register of previous value of estimable counter
    initial est_tick_prev = '0;
    always @(posedge refclk)
        if (ref_stb_reg)
            est_tick_prev <= est_tick_curr;
        else
            est_tick_prev <= est_tick_prev;


    // The register of estimated clock frequency
    initial freq_est_reg = '0;
    always @(posedge refclk)
        if (ref_stb_reg)
            freq_est_reg <= est_tick_curr - est_tick_prev;
        else
            freq_est_reg <= freq_est_reg;
    assign frequency = freq_est_reg;

endmodule: freq_estimator