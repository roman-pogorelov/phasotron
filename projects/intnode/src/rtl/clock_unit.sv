/*
    // Generates clocks and related resets
    clock_unit the_clock_unit (
        // Reference 100 MHz clock input
        .clk_100mhz_p           (), // i
        .clk_100mhz_n           (), // i

        // GT reference 156.25 MHz clock input
        .clk_gt_156p25mhz_p     (), // i
        .clk_gt_156p25mhz_n     (), // i

        // System clock and reset outputs
        .clk_sys                (), // o
        .rst_sys                (), // o

        // MIG system clock output
        .clk_mig_sys            (), // o

        // MIG reference clock output
        .clk_mig_ref            (), // o

        // GT reference clock output
        .clk_gt_ref             (), // o

        // GT init clock output
        .clk_gt_init            ()  // o
    ); // the_clock_unit
*/


module clock_unit
(
    // Reference 100 MHz clock input
    input  wire     clk_100mhz_p,
    input  wire     clk_100mhz_n,

    // GT reference 156.25 MHz clock input
    input  wire     clk_gt_156p25mhz_p,
    input  wire     clk_gt_156p25mhz_n,

    // System clock and reset outputs
    output wire     clk_sys,
    output wire     rst_sys,

    // MIG system clock output
    output wire     clk_mig_sys,

    // MIG reference clock output
    output wire     clk_mig_ref,

    // GT reference clock output
    output wire     clk_gt_ref,

    // GT init clock output
    output wire     clk_gt_init
);
    // Constants
    localparam int unsigned     RST_SYS_LEN     = 1000;
    localparam int unsigned     RST_SYS_CNT_W   = $clog2(RST_SYS_LEN + 1);
    //
    localparam int unsigned     REF_CLK_FREQ    = 100_000_000;
    localparam int unsigned     FREQ_EST_FACTOR = 4;
    localparam int unsigned     FREQ_W          = $clog2(REF_CLK_FREQ * FREQ_EST_FACTOR);


    // Variables
    logic                           clk_100mhz;
    logic                           rst_100mhz;
    //
    logic                           mmcm_locked;
    //
    (* mark_debug = "true" *)
    logic [FREQ_W - 1 : 0]          clk_sys_freq;
    (* mark_debug = "true" *)
    logic [FREQ_W - 1 : 0]          clk_ram_freq;
    (* mark_debug = "true" *)
    logic [FREQ_W - 1 : 0]          clk_gt_ref_freq;


    // Diff buffer for the input reference clock 100MHz
    IBUFGDS clk_100mhz_buf (
        .I      (clk_100mhz_p),
        .IB     (clk_100mhz_n),
        .O      (clk_100mhz)
    ); // clk_100mhz_buf


    // GT differential buffer instance
    IBUFDS_GTE2 the_ibufds_gte2
    (
        .I      (clk_gt_156p25mhz_p),
        .IB     (clk_gt_156p25mhz_n),
        .CEB    (1'b0),
        .O      (clk_gt_ref),
        .ODIV2  (  )
    ); // the_ibufds_gte2


    // GT init clock output
    assign clk_gt_init = clk_100mhz;


    // MMCM instance
    clk_gen the_clk_gen
    (
        // Clock in ports
        .clk_in1    (clk_100mhz),   // i

        // Clock out ports
        .clk_out1   (clk_sys),      // o
        .clk_out2   (clk_mig_ref),  // o
        .clk_out3   (clk_mig_sys),  // o

        // Status and control signals
        .locked     (mmcm_locked)   // o
    ); // the_clk_gen


    // XPM reset synchronizer
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF       (10),
        .INIT_SYNC_FF       (0),
        .RST_ACTIVE_HIGH    (1)
    )
    xpm_cdc_async_rst_100mhz (
        .src_arst           (!mmcm_locked),
        .dest_clk           (clk_100mhz),
        .dest_arst          (rst_100mhz)
    ); // xpm_cdc_async_rst_100mhz


    // XPM reset synchronizer
    xpm_cdc_async_rst #(
        .DEST_SYNC_FF       (10),
        .INIT_SYNC_FF       (0),
        .RST_ACTIVE_HIGH    (1)
    )
    xpm_cdc_async_rst_sys (
        .src_arst           (rst_100mhz),
        .dest_clk           (clk_sys),
        .dest_arst          (rst_sys)
    ); // xpm_cdc_async_rst_sys


    // Clock frequency estimator
    freq_estimator
    #(
        .PERIOD         (REF_CLK_FREQ),     // Duration of estimation in refclk cycles (PERIOD > 0)
        .FACTOR         (FREQ_EST_FACTOR)   // The maximum estclk to refclk ration
    )
    clk_sys_freq_estimator
    (
        // Reference clock
        .refclk         (clk_gt_init),      // i

        // Estimable clock
        .estclk         (clk_sys),          // i

        // Estimated clock frequency
        .frequency      (clk_sys_freq)      // o  [$clog2(FACTOR * PERIOD) - 1 : 0]
    ); // clk_sys_freq_estimator


    // Clock frequency estimator
    freq_estimator
    #(
        .PERIOD         (REF_CLK_FREQ),     // Duration of estimation in refclk cycles (PERIOD > 0)
        .FACTOR         (FREQ_EST_FACTOR)   // The maximum estclk to refclk ration
    )
    clk_ram_freq_estimator
    (
        // Reference clock
        .refclk         (clk_gt_init),      // i

        // Estimable clock
        .estclk         (clk_ram),          // i

        // Estimated clock frequency
        .frequency      (clk_ram_freq)      // o  [$clog2(FACTOR * PERIOD) - 1 : 0]
    ); // clk_ram_freq_estimator


    // Clock frequency estimator
    freq_estimator
    #(
        .PERIOD         (REF_CLK_FREQ),     // Duration of estimation in refclk cycles (PERIOD > 0)
        .FACTOR         (FREQ_EST_FACTOR)   // The maximum estclk to refclk ration
    )
    clk_gt_ref_freq_estimator
    (
        // Reference clock
        .refclk         (clk_gt_init),      // i

        // Estimable clock
        .estclk         (clk_gt_ref),       // i

        // Estimated clock frequency
        .frequency      (clk_gt_ref_freq)   // o  [$clog2(FACTOR * PERIOD) - 1 : 0]
    ); // clk_gt_ref_freq_estimator

endmodule: clock_unit