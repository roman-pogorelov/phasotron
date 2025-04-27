module extnode
(
    // System clock
    input  wire             clk_100mhz_p,
    input  wire             clk_100mhz_n,

    // DDR3 intreface
    inout  wire [15 : 0]    ddr3_dq,
    inout  wire [1 : 0]     ddr3_dqs_n,
    inout  wire [1 : 0]     ddr3_dqs_p,
    output wire [13:0]      ddr3_addr,
    output wire [2:0]       ddr3_ba,
    output wire             ddr3_ras_n,
    output wire             ddr3_cas_n,
    output wire             ddr3_we_n,
    output wire             ddr3_reset_n,
    output wire [0 : 0]     ddr3_ck_p,
    output wire [0 : 0]     ddr3_ck_n,
    output wire [0 : 0]     ddr3_cke,
    output wire [0 : 0]     ddr3_cs_n,
    output wire [1 : 0]     ddr3_dm,
    output wire [0 : 0]     ddr3_odt,

    // QSPI Flash interface (clock must be
    // connected to a dedicated pin)
    output wire             flash_cs_n,
    inout  wire [3 : 0]     flash_data,

    // GT reference clock
    input  wire             clk_gt_p,
    input  wire             clk_gt_n,

    // Upstream GT RX
    input  wire  [1 : 0]    up0_rx_p,
    input  wire  [1 : 0]    up0_rx_n,

    // Upstream GT TX
    output wire  [1 : 0]    up0_tx_p,
    output wire  [1 : 0]    up0_tx_n,

    // System reference clock
    input  wire             clk_ref_p,
    input  wire             clk_ref_n,

    // System synchronization
    // at the system reference clock
    input  wire             sync_p,
    input  wire             sync_n,

    // DAC #0 data interface A
    output wire  [15 : 0]   dac0_data_a_p,
    output wire  [15 : 0]   dac0_data_a_n,
    output wire             dac0_frame_a_p,
    output wire             dac0_frame_a_n,
    output wire             dac0_clock_a_p,
    output wire             dac0_clock_a_n,

    // DAC #0 data interface B
    output wire  [15 : 0]   dac0_data_b_p,
    output wire  [15 : 0]   dac0_data_b_n,
    output wire             dac0_frame_b_p,
    output wire             dac0_frame_b_n,
    output wire             dac0_clock_b_p,
    output wire             dac0_clock_b_n,

    // DAC #0 control interface
    output wire             dac0_spi_rstn,
    output wire             dac0_spi_cs_n,
    output wire             dac0_spi_sclk,
    output wire             dac0_spi_mosi,
    input  wire             dac0_spi_miso,

    // DAC #1 data interface A
    output wire  [15 : 0]   dac1_data_a_p,
    output wire  [15 : 0]   dac1_data_a_n,
    output wire             dac1_frame_a_p,
    output wire             dac1_frame_a_n,
    output wire             dac1_clock_a_p,
    output wire             dac1_clock_a_n,

    // DAC #1 data interface B
    output wire  [15 : 0]   dac1_data_b_p,
    output wire  [15 : 0]   dac1_data_b_n,
    output wire             dac1_frame_b_p,
    output wire             dac1_frame_b_n,
    output wire             dac1_clock_b_p,
    output wire             dac1_clock_b_n,

    // DAC #1 control interface
    output wire             dac1_spi_rstn,
    output wire             dac1_spi_cs_n,
    output wire             dac1_spi_sclk,
    output wire             dac1_spi_mosi,
    input  wire             dac1_spi_miso,

    // JESD204B GT reference clock
    input  wire             clk_jesd204b_gt_p,
    input  wire             clk_jesd204b_gt_n,

    // JESD204B SYSREF
    input  wire             sysref_jesd204b_p,
    input  wire             sysref_jesd204b_n,

    // JESD204B SYNCB outputs
    output logic            adc0_jesd204b_syncb_p,
    output logic            adc0_jesd204b_syncb_n,
    output logic            adc1_jesd204b_syncb_p,
    output logic            adc1_jesd204b_syncb_n,
    output logic            adc2_jesd204b_syncb_p,
    output logic            adc2_jesd204b_syncb_n,
    output logic            adc3_jesd204b_syncb_p,
    output logic            adc3_jesd204b_syncb_n,

    // JESD204B ADC #0 GT RX
    input  wire [1 : 0]     adc0_jesd204b_gt_rx_p,
    input  wire [1 : 0]     adc0_jesd204b_gt_rx_n,

    // JESD204B ADC #1 GT RX
    input  wire [1 : 0]     adc1_jesd204b_gt_rx_p,
    input  wire [1 : 0]     adc1_jesd204b_gt_rx_n,

    // JESD204B ADC #2 GT RX
    input  wire [1 : 0]     adc2_jesd204b_gt_rx_p,
    input  wire [1 : 0]     adc2_jesd204b_gt_rx_n,

    // JESD204B ADC #3 GT RX
    input  wire [1 : 0]     adc3_jesd204b_gt_rx_p,
    input  wire [1 : 0]     adc3_jesd204b_gt_rx_n
);
    // Variables
    logic           clk_sys;
    logic           rst_sys;
    //
    logic           clk_ram;
    logic           rst_ram;
    //
    logic           clk_mig_sys;
    logic           clk_mig_ref;
    //
    logic           clk_gt_aurora;
    logic           clk_gt_jesd204b;
    logic           clk_ref;
    //
    logic           sync;
    //
    logic [27 : 0]  app_addr;
    logic [2 : 0]   app_cmd;
    logic           app_en;
    logic [127 : 0] app_wdf_data;
    logic           app_wdf_end;
    logic [15 : 0]  app_wdf_mask;
    logic           app_wdf_wren;
    logic [127 : 0] app_rd_data;
    logic           app_rd_data_end;
    logic           app_rd_data_valid;
    logic           app_rdy;
    logic           app_wdf_rdy;
    logic           app_sr_req;
    logic           app_ref_req;
    logic           app_zq_req;
    logic           app_sr_active;
    logic           app_ref_ack;
    logic           app_zq_ack;
    //
    logic           init_calib_complete;
    //
    logic [63 : 0]  adc0_data;
    logic [63 : 0]  adc1_data;
    logic [63 : 0]  adc2_data;
    logic [63 : 0]  adc3_data;
    //
    logic [63 : 0]  dac0_data = '0;
    logic [63 : 0]  dac1_data = '0;


    // Generates clocks and related resets
    clock_unit the_clock_unit
    (
        // Input reference clock 100MHz
        .clk_100mhz_p   (clk_100mhz_p), // i
        .clk_100mhz_n   (clk_100mhz_n), // i

        // System clock and reset
        .clk_sys        (clk_sys),      // o
        .rst_sys        (rst_sys),      // o

        // MIG system clock
        .clk_mig_sys    (clk_mig_sys),  // o

        // MIG reference clock 200MHz
        .clk_mig_ref    (clk_mig_ref)   // o
    ); // the_clock_unit


    // Simple stub to drive a MIG7 instance
    mig7_stub the_mig7_stub
    (
        // Reset and clock
        .rst                    (rst_ram),              // i
        .clk                    (clk_ram),              // i

        // MIG local interface
        .app_addr               (app_addr),             // o  [27 : 0]
        .app_cmd                (app_cmd),              // o  [2 : 0]
        .app_en                 (app_en),               // o
        .app_wdf_data           (app_wdf_data),         // o  [127 : 0]
        .app_wdf_end            (app_wdf_end),          // o
        .app_wdf_mask           (app_wdf_mask),         // o  [15 : 0]
        .app_wdf_wren           (app_wdf_wren),         // o
        .app_rd_data            (app_rd_data),          // i  [127 : 0]
        .app_rd_data_end        (app_rd_data_end),      // i
        .app_rd_data_valid      (app_rd_data_valid),    // i
        .app_rdy                (app_rdy),              // i
        .app_wdf_rdy            (app_wdf_rdy),          // i
        .app_sr_req             (app_sr_req),           // o
        .app_ref_req            (app_ref_req),          // o
        .app_zq_req             (app_zq_req),           // o
        .app_sr_active          (app_sr_active),        // i
        .app_ref_ack            (app_ref_ack),          // i
        .app_zq_ack             (app_zq_ack),           // i

        // Calibration status
        .init_calib_complete    (init_calib_complete)   // i
    ); // the_mig7_stub


    // DDR3 controller
    mig7series the_mig7series (
        // Inouts
        .ddr3_dq                (ddr3_dq),              // io [15 : 0]
        .ddr3_dqs_n             (ddr3_dqs_n),           // io [1 : 0]
        .ddr3_dqs_p             (ddr3_dqs_p),           // io [1 : 0]

        // Outputs
        .ddr3_addr              (ddr3_addr),            // o  [13 : 0]
        .ddr3_ba                (ddr3_ba),              // o  [2 : 0]
        .ddr3_ras_n             (ddr3_ras_n),           // o
        .ddr3_cas_n             (ddr3_cas_n),           // o
        .ddr3_we_n              (ddr3_we_n),            // o
        .ddr3_reset_n           (ddr3_reset_n),         // o
        .ddr3_ck_p              (ddr3_ck_p),            // o  [0 : 0]
        .ddr3_ck_n              (ddr3_ck_n),            // o  [0 : 0]
        .ddr3_cke               (ddr3_cke),             // o  [0 : 0]
        .ddr3_cs_n              (ddr3_cs_n),            // o  [0 : 0]
        .ddr3_dm                (ddr3_dm),              // o  [1 : 0]
        .ddr3_odt               (ddr3_odt),             // o  [0 : 0]

        // System reset
        .sys_rst                (rst_sys),              // i

        // Single-ended system clock
        .sys_clk_i              (clk_mig_sys),          // i

        // Single-ended iodelayctrl clk (reference clock)
        .clk_ref_i              (clk_mig_ref),          // i

        // User interface signals
        .app_addr               (app_addr),             // i [27 : 0]
        .app_cmd                (app_cmd),              // i [2 : 0]
        .app_en                 (app_en),               // i
        .app_wdf_data           (app_wdf_data),         // i [127 : 0]
        .app_wdf_end            (app_wdf_end),          // i
        .app_wdf_mask           (app_wdf_mask),         // i [15 : 0]
        .app_wdf_wren           (app_wdf_wren),         // i
        .app_rd_data            (app_rd_data),          // o [127 : 0]
        .app_rd_data_end        (app_rd_data_end),      // o
        .app_rd_data_valid      (app_rd_data_valid),    // o
        .app_rdy                (app_rdy),              // o
        .app_wdf_rdy            (app_wdf_rdy),          // o
        .app_sr_req             (app_sr_req),           // i
        .app_ref_req            (app_ref_req),          // i
        .app_zq_req             (app_zq_req),           // i
        .app_sr_active          (app_sr_active),        // o
        .app_ref_ack            (app_ref_ack),          // o
        .app_zq_ack             (app_zq_ack),           // o
        .ui_clk                 (clk_ram),              // o
        .ui_clk_sync_rst        (rst_ram),              // o
        .init_calib_complete    (init_calib_complete),  // o
        .device_temp            (  )                    // o [11 : 0]
    ); // the_mig7series


    // GT differential buffer instance
    IBUFDS_GTE2 ibufds_gte2_aurora
    (
        .I      (clk_gt_p),
        .IB     (clk_gt_n),
        .CEB    (1'b0),
        .O      (clk_gt_aurora),
        .ODIV2  (  )
    ); // ibufds_gte2_aurora


    // Upstream unit
    upstream_unit the_upstream_unit
    (
        // Common asynchronous reset
        .rst            (rst_sys),          // i

        // Intialization clock
        .clk_init       (clk_sys),          // i

        // GT reference clock
        .clk_gt         (clk_gt_aurora),    // i

        // GT RX
        .up0_rx_p       (up0_rx_p),         // i  [1 : 0]
        .up0_rx_n       (up0_rx_n),         // i  [1 : 0]

        // GT TX
        .up0_tx_p       (up0_tx_p),         // o  [1 : 0]
        .up0_tx_n       (up0_tx_n)          // o  [1 : 0]
    ); // the_upstream_unit


    // Differential clock buffer
    IBUFGDS ibufgds_clk_ref
    (
        .I      (clk_ref_p),
        .IB     (clk_ref_n),
        .O      (clk_ref)
    ); // ibufgds_clk_ref


    // Differential buffer
    IBUFDS ibufds_sync
    (
        .I      (sync_p),
        .IB     (sync_n),
        .O      (sync)
    ); // ibufds_sync


    // AD9148 DAC stub
    dac_stub dac0_stub
    (
        // DAC reference clock
        .clk            (clk_ref),          // i

        // Incoming data
        .data_in        (dac0_data),        // i  [63 : 0]

        // DAC data interface A
        .dac_data_a_p   (dac0_data_a_p),    // o  [15 : 0]
        .dac_data_a_n   (dac0_data_a_n),    // o  [15 : 0]
        .dac_frame_a_p  (dac0_frame_a_p),   // o
        .dac_frame_a_n  (dac0_frame_a_n),   // o
        .dac_clock_a_p  (dac0_clock_a_p),   // o
        .dac_clock_a_n  (dac0_clock_a_n),   // o

        // DAC data interface A
        .dac_data_b_p   (dac0_data_b_p),    // o  [15 : 0]
        .dac_data_b_n   (dac0_data_b_n),    // o  [15 : 0]
        .dac_frame_b_p  (dac0_frame_b_p),   // o
        .dac_frame_b_n  (dac0_frame_b_n),   // o
        .dac_clock_b_p  (dac0_clock_b_p),   // o
        .dac_clock_b_n  (dac0_clock_b_n),   // o

        // DAC control interface
        .dac_spi_rstn   (dac0_spi_rstn),    // o
        .dac_spi_cs_n   (dac0_spi_cs_n),    // o
        .dac_spi_sclk   (dac0_spi_sclk),    // o
        .dac_spi_mosi   (dac0_spi_mosi),    // o
        .dac_spi_miso   (dac0_spi_miso)     // i
    ); // dac0_stub


    // AD9148 DAC stub
    dac_stub dac1_stub
    (
        // DAC reference clock
        .clk            (clk_ref),          // i

        // Incoming data
        .data_in        (dac1_data),        // i  [63 : 0]

        // DAC data interface A
        .dac_data_a_p   (dac1_data_a_p),    // o  [15 : 0]
        .dac_data_a_n   (dac1_data_a_n),    // o  [15 : 0]
        .dac_frame_a_p  (dac1_frame_a_p),   // o
        .dac_frame_a_n  (dac1_frame_a_n),   // o
        .dac_clock_a_p  (dac1_clock_a_p),   // o
        .dac_clock_a_n  (dac1_clock_a_n),   // o

        // DAC data interface A
        .dac_data_b_p   (dac1_data_b_p),    // o  [15 : 0]
        .dac_data_b_n   (dac1_data_b_n),    // o  [15 : 0]
        .dac_frame_b_p  (dac1_frame_b_p),   // o
        .dac_frame_b_n  (dac1_frame_b_n),   // o
        .dac_clock_b_p  (dac1_clock_b_p),   // o
        .dac_clock_b_n  (dac1_clock_b_n),   // o

        // DAC control interface
        .dac_spi_rstn   (dac1_spi_rstn),    // o
        .dac_spi_cs_n   (dac1_spi_cs_n),    // o
        .dac_spi_sclk   (dac1_spi_sclk),    // o
        .dac_spi_mosi   (dac1_spi_mosi),    // o
        .dac_spi_miso   (dac1_spi_miso)     // i
    ); // dac1_stub


    // GT differential buffer instance
    IBUFDS_GTE2 ibufds_gte2_jesd204b
    (
        .I      (clk_jesd204b_gt_p),
        .IB     (clk_jesd204b_gt_n),
        .CEB    (1'b0),
        .O      (clk_gt_jesd204b),
        .ODIV2  (  )
    ); // ibufds_gte2_jesd204b


    // AD9695 ADCs stub
    adc_stub the_adc_stub
    (
        // JESD204B GT reference clock
        .clk_jesd204b_gt        (clk_gt_jesd204b),          // i

        // JESD204B link clock
        .clk_jesd204b_link      (clk_ref),                  // i

        // System clock
        .clk_sys                (clk_sys),                  // i

        // JESD204B SYSREF input
        .jesd204b_sysref_p      (sysref_jesd204b_p),        // o
        .jesd204b_sysref_n      (sysref_jesd204b_n),        // o

        // JESD204B sync outputs
        .adc0_jesd204b_syncb_p  (adc0_jesd204b_syncb_p),    // o
        .adc0_jesd204b_syncb_n  (adc0_jesd204b_syncb_n),    // o
        .adc1_jesd204b_syncb_p  (adc1_jesd204b_syncb_p),    // o
        .adc1_jesd204b_syncb_n  (adc1_jesd204b_syncb_n),    // o
        .adc2_jesd204b_syncb_p  (adc2_jesd204b_syncb_p),    // o
        .adc2_jesd204b_syncb_n  (adc2_jesd204b_syncb_n),    // o
        .adc3_jesd204b_syncb_p  (adc3_jesd204b_syncb_p),    // o
        .adc3_jesd204b_syncb_n  (adc3_jesd204b_syncb_n),    // o

        // JESD204B ADC #0 GT RX
        .adc0_jesd204b_gt_rx_p  (adc0_jesd204b_gt_rx_p),    // i  [1 : 0]
        .adc0_jesd204b_gt_rx_n  (adc0_jesd204b_gt_rx_n),    // i  [1 : 0]

        // JESD204B ADC #1 GT RX
        .adc1_jesd204b_gt_rx_p  (adc1_jesd204b_gt_rx_p),    // i  [1 : 0]
        .adc1_jesd204b_gt_rx_n  (adc1_jesd204b_gt_rx_n),    // i  [1 : 0]

        // JESD204B ADC #2 GT RX
        .adc2_jesd204b_gt_rx_p  (adc2_jesd204b_gt_rx_p),    // i  [1 : 0]
        .adc2_jesd204b_gt_rx_n  (adc2_jesd204b_gt_rx_n),    // i  [1 : 0]

        // JESD204B ADC #3 GT RX
        .adc3_jesd204b_gt_rx_p  (adc3_jesd204b_gt_rx_p),    // i  [1 : 0]
        .adc3_jesd204b_gt_rx_n  (adc3_jesd204b_gt_rx_n),    // i  [1 : 0]

        // ADC data
        .adc0_data              (adc0_data),                // o  [63 : 0]
        .adc1_data              (adc1_data),                // o  [63 : 0]
        .adc2_data              (adc2_data),                // o  [63 : 0]
        .adc3_data              (adc3_data)                 // o  [63 : 0]
    ); // the_adc_stub


    // Make incoming DAC data
    always @(posedge clk_ref) begin
        dac0_data = adc0_data + adc1_data;
        dac1_data = adc2_data + adc3_data;
    end

endmodule: extnode