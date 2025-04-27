/*
    // AD9695 ADCs stub
    adc_stub the_adc_stub
    (
        // JESD204B GT reference clock
        .clk_jesd204b_gt        (), // i

        // JESD204B link clock
        .clk_jesd204b_link      (), // i

        // System clock
        .clk_sys                (), // i

        // JESD204B SYSREF input
        .jesd204b_sysref_p      (), // o
        .jesd204b_sysref_n      (), // o

        // JESD204B sync outputs
        .adc0_jesd204b_syncb_p  (), // o
        .adc0_jesd204b_syncb_n  (), // o
        .adc1_jesd204b_syncb_p  (), // o
        .adc1_jesd204b_syncb_n  (), // o
        .adc2_jesd204b_syncb_p  (), // o
        .adc2_jesd204b_syncb_n  (), // o
        .adc3_jesd204b_syncb_p  (), // o
        .adc3_jesd204b_syncb_n  (), // o

        // JESD204B ADC #0 GT RX
        .adc0_jesd204b_gt_rx_p  (), // i  [1 : 0]
        .adc0_jesd204b_gt_rx_n  (), // i  [1 : 0]

        // JESD204B ADC #1 GT RX
        .adc1_jesd204b_gt_rx_p  (), // i  [1 : 0]
        .adc1_jesd204b_gt_rx_n  (), // i  [1 : 0]

        // JESD204B ADC #2 GT RX
        .adc2_jesd204b_gt_rx_p  (), // i  [1 : 0]
        .adc2_jesd204b_gt_rx_n  (), // i  [1 : 0]

        // JESD204B ADC #3 GT RX
        .adc3_jesd204b_gt_rx_p  (), // i  [1 : 0]
        .adc3_jesd204b_gt_rx_n  (), // i  [1 : 0]

        // ADC data
        .adc0_data              (), // o  [63 : 0]
        .adc1_data              (), // o  [63 : 0]
        .adc2_data              (), // o  [63 : 0]
        .adc3_data              ()  // o  [63 : 0]
    ); // the_adc_stub
*/


module adc_stub
(
    // JESD204B GT reference clock
    input  logic            clk_jesd204b_gt,

    // JESD204B link clock
    input  logic            clk_jesd204b_link,

    // System clock
    input  logic            clk_sys,

    // JESD204B SYSREF input
    input logic             jesd204b_sysref_p,
    input logic             jesd204b_sysref_n,

    // JESD204B sync outputs
    output logic            adc0_jesd204b_syncb_p,
    output logic            adc0_jesd204b_syncb_n,
    output logic            adc1_jesd204b_syncb_p,
    output logic            adc1_jesd204b_syncb_n,
    output logic            adc2_jesd204b_syncb_p,
    output logic            adc2_jesd204b_syncb_n,
    output logic            adc3_jesd204b_syncb_p,
    output logic            adc3_jesd204b_syncb_n,

    // JESD204B ADC #0 GT RX
    input  wire  [1 : 0]    adc0_jesd204b_gt_rx_p,
    input  wire  [1 : 0]    adc0_jesd204b_gt_rx_n,

    // JESD204B ADC #1 GT RX
    input  wire  [1 : 0]    adc1_jesd204b_gt_rx_p,
    input  wire  [1 : 0]    adc1_jesd204b_gt_rx_n,

    // JESD204B ADC #2 GT RX
    input  wire  [1 : 0]    adc2_jesd204b_gt_rx_p,
    input  wire  [1 : 0]    adc2_jesd204b_gt_rx_n,

    // JESD204B ADC #3 GT RX
    input  wire  [1 : 0]    adc3_jesd204b_gt_rx_p,
    input  wire  [1 : 0]    adc3_jesd204b_gt_rx_n,

    // ADC data
    output logic [63 : 0]   adc0_data,
    output logic [63 : 0]   adc1_data,
    output logic [63 : 0]   adc2_data,
    output logic [63 : 0]   adc3_data
);
    // Variables
    logic       jesd204b_sysref;
    //
    logic       gtq0_qpllclk;
    logic       gtq0_qpllrefclk;
    //
    logic       gtq1_qpllclk;
    logic       gtq1_qpllrefclk;


    // IBUFDS instance
    IBUFDS ibufds_sysref (
        .I      (jesd204b_sysref_p),
        .IB     (jesd204b_sysref_n),
        .O      (jesd204b_sysref)
    ); // ibufds_sysref


    // OBUFDS instance
    OBUFDS obufds_syncb [3 : 0] (
        .O      ({
                    adc3_jesd204b_syncb_p,
                    adc2_jesd204b_syncb_p,
                    adc1_jesd204b_syncb_p,
                    adc0_jesd204b_syncb_p
                }),
        .OB     ({
                    adc3_jesd204b_syncb_n,
                    adc2_jesd204b_syncb_n,
                    adc1_jesd204b_syncb_n,
                    adc0_jesd204b_syncb_n
                }),
        .I      ({4{1'b1}})
    ); // obufds_syncb


    // Aurora 8B10B GT common instance
    aurora8b10b_gt_common_wrapper gt_common_adc0_adc1
    (
        .gt_qpllclk_quad1_i         (gtq0_qpllclk),
        .gt_qpllrefclk_quad1_i      (gtq0_qpllrefclk),

        .gt0_gtrefclk0_common_in    (clk_jesd204b_gt),

        .gt0_qplllock_out           (  ),
        .gt0_qplllockdetclk_in      (clk_sys),
        .gt0_qpllrefclklost_out     (  ),
        .gt0_qpllreset_in           (1'b0)
    ); // gt_common_adc0_adc1


    // Aurora 8B10B GT common instance
    aurora8b10b_gt_common_wrapper gt_common_adc2_adc3
    (
        .gt_qpllclk_quad1_i         (gtq1_qpllclk),
        .gt_qpllrefclk_quad1_i      (gtq1_qpllrefclk),

        .gt0_gtrefclk0_common_in    (clk_jesd204b_gt),

        .gt0_qplllock_out           (  ),
        .gt0_qplllockdetclk_in      (clk_sys),
        .gt0_qpllrefclklost_out     (  ),
        .gt0_qpllreset_in           (1'b0)
    ); // gt_common_adc0_adc1


    // JESD204b PHY instance
    jesd204phy jesd204phy_adc0
    (
        // System Reset Inputs for each direction
        .tx_sys_reset           (1'b0),                     // i
        .rx_sys_reset           (1'b0),                     // i

        // Reset Inputs for each direction
        .tx_reset_gt            (1'b0),                     // i
        .rx_reset_gt            (1'b0),                     // i

        // Reset Done for each direction
        .tx_reset_done          (  ),                       // o
        .rx_reset_done          (  ),                       // o

        .cpll_refclk            (clk_jesd204b_gt),          // i

        // GT Common inputs
        .common0_qpll_clk_in    (gtq0_qpllclk),             // i
        .common0_qpll_refclk_in (gtq0_qpllrefclk),          // i

        .rxencommaalign         (1'b1),                     // i

        // Clocks
        .tx_core_clk            (clk_jesd204b_link),        // i
        .txoutclk               (  ),                       // o

        .rx_core_clk            (clk_jesd204b_link),        // i
        .rxoutclk               (  ),                       // o

        .drpclk                 (clk_sys),                  // i

        // PRBS mode
        .gt_prbssel             (3'b000),                   // i  [2 : 0]

        // Tx Ports
        // Lane 0
        .gt0_txcharisk          (4'b0),                     // i  [3 : 0]
        .gt0_txdata             (32'b0),                    // i  [31 : 0]
        // Lane 1
        .gt1_txcharisk          (4'b0),                     // i  [3 : 0]
        .gt1_txdata             (32'b0),                    // i  [31 : 0]

        // Rx Ports
        // Lane 0
        .gt0_rxcharisk          (  ),                       // o  [3 : 0]
        .gt0_rxdisperr          (  ),                       // o  [3 : 0]
        .gt0_rxnotintable       (  ),                       // o  [3 : 0]
        .gt0_rxdata             (adc0_data[31 : 0]),        // o  [31 : 0]
        // Lane 1
        .gt1_rxcharisk          (  ),                       // o  [3 : 0]
        .gt1_rxdisperr          (  ),                       // o  [3 : 0]
        .gt1_rxnotintable       (  ),                       // o  [3 : 0]
        .gt1_rxdata             (adc0_data[63 : 32]),       // o  [31 : 0]

        // Serial ports
        .rxn_in                 (adc0_jesd204b_gt_rx_n),    // i  [1 : 0]
        .rxp_in                 (adc0_jesd204b_gt_rx_p),    // i  [1 : 0]
        .txn_out                (  ),                       // o  [1 : 0]
        .txp_out                (  )                        // o  [1 : 0]
    ); // jesd204phy_adc0


    // JESD204b PHY instance
    jesd204phy jesd204phy_adc1
    (
        // System Reset Inputs for each direction
        .tx_sys_reset           (1'b0),                     // i
        .rx_sys_reset           (1'b0),                     // i

        // Reset Inputs for each direction
        .tx_reset_gt            (1'b0),                     // i
        .rx_reset_gt            (1'b0),                     // i

        // Reset Done for each direction
        .tx_reset_done          (  ),                       // o
        .rx_reset_done          (  ),                       // o

        .cpll_refclk            (clk_jesd204b_gt),          // i

        // GT Common inputs
        .common0_qpll_clk_in    (gtq0_qpllclk),             // i
        .common0_qpll_refclk_in (gtq0_qpllrefclk),          // i

        .rxencommaalign         (1'b1),                     // i

        // Clocks
        .tx_core_clk            (clk_jesd204b_link),        // i
        .txoutclk               (  ),                       // o

        .rx_core_clk            (clk_jesd204b_link),        // i
        .rxoutclk               (  ),                       // o

        .drpclk                 (clk_sys),                  // i

        // PRBS mode
        .gt_prbssel             (3'b000),                   // i  [2 : 0]

        // Tx Ports
        // Lane 0
        .gt0_txcharisk          (4'b0),                     // i  [3 : 0]
        .gt0_txdata             (32'b0),                    // i  [31 : 0]
        // Lane 1
        .gt1_txcharisk          (4'b0),                     // i  [3 : 0]
        .gt1_txdata             (32'b0),                    // i  [31 : 0]

        // Rx Ports
        // Lane 0
        .gt0_rxcharisk          (  ),                       // o  [3 : 0]
        .gt0_rxdisperr          (  ),                       // o  [3 : 0]
        .gt0_rxnotintable       (  ),                       // o  [3 : 0]
        .gt0_rxdata             (adc1_data[31 : 0]),        // o  [31 : 0]
        // Lane 1
        .gt1_rxcharisk          (  ),                       // o  [3 : 0]
        .gt1_rxdisperr          (  ),                       // o  [3 : 0]
        .gt1_rxnotintable       (  ),                       // o  [3 : 0]
        .gt1_rxdata             (adc1_data[63 : 32]),       // o  [31 : 0]

        // Serial ports
        .rxn_in                 (adc1_jesd204b_gt_rx_n),    // i  [1 : 0]
        .rxp_in                 (adc1_jesd204b_gt_rx_p),    // i  [1 : 0]
        .txn_out                (  ),                       // o  [1 : 0]
        .txp_out                (  )                        // o  [1 : 0]
    ); // jesd204phy_adc1


    // JESD204b PHY instance
    jesd204phy jesd204phy_adc2
    (
        // System Reset Inputs for each direction
        .tx_sys_reset           (1'b0),                     // i
        .rx_sys_reset           (1'b0),                     // i

        // Reset Inputs for each direction
        .tx_reset_gt            (1'b0),                     // i
        .rx_reset_gt            (1'b0),                     // i

        // Reset Done for each direction
        .tx_reset_done          (  ),                       // o
        .rx_reset_done          (  ),                       // o

        .cpll_refclk            (clk_jesd204b_gt),          // i

        // GT Common inputs
        .common0_qpll_clk_in    (gtq1_qpllclk),             // i
        .common0_qpll_refclk_in (gtq1_qpllrefclk),          // i

        .rxencommaalign         (1'b1),                     // i

        // Clocks
        .tx_core_clk            (clk_jesd204b_link),        // i
        .txoutclk               (  ),                       // o

        .rx_core_clk            (clk_jesd204b_link),        // i
        .rxoutclk               (  ),                       // o

        .drpclk                 (clk_sys),                  // i

        // PRBS mode
        .gt_prbssel             (3'b000),                   // i  [2 : 0]

        // Tx Ports
        // Lane 0
        .gt0_txcharisk          (4'b0),                     // i  [3 : 0]
        .gt0_txdata             (32'b0),                    // i  [31 : 0]
        // Lane 1
        .gt1_txcharisk          (4'b0),                     // i  [3 : 0]
        .gt1_txdata             (32'b0),                    // i  [31 : 0]

        // Rx Ports
        // Lane 0
        .gt0_rxcharisk          (  ),                       // o  [3 : 0]
        .gt0_rxdisperr          (  ),                       // o  [3 : 0]
        .gt0_rxnotintable       (  ),                       // o  [3 : 0]
        .gt0_rxdata             (adc2_data[31 : 0]),        // o  [31 : 0]
        // Lane 1
        .gt1_rxcharisk          (  ),                       // o  [3 : 0]
        .gt1_rxdisperr          (  ),                       // o  [3 : 0]
        .gt1_rxnotintable       (  ),                       // o  [3 : 0]
        .gt1_rxdata             (adc2_data[63 : 32]),       // o  [31 : 0]

        // Serial ports
        .rxn_in                 (adc2_jesd204b_gt_rx_n),    // i  [1 : 0]
        .rxp_in                 (adc2_jesd204b_gt_rx_p),    // i  [1 : 0]
        .txn_out                (  ),                       // o  [1 : 0]
        .txp_out                (  )                        // o  [1 : 0]
    ); // jesd204phy_adc2


    // JESD204b PHY instance
    jesd204phy jesd204phy_adc3
    (
        // System Reset Inputs for each direction
        .tx_sys_reset           (1'b0),                     // i
        .rx_sys_reset           (1'b0),                     // i

        // Reset Inputs for each direction
        .tx_reset_gt            (1'b0),                     // i
        .rx_reset_gt            (1'b0),                     // i

        // Reset Done for each direction
        .tx_reset_done          (  ),                       // o
        .rx_reset_done          (  ),                       // o

        .cpll_refclk            (clk_jesd204b_gt),          // i

        // GT Common inputs
        .common0_qpll_clk_in    (gtq1_qpllclk),             // i
        .common0_qpll_refclk_in (gtq1_qpllrefclk),          // i

        .rxencommaalign         (1'b1),                     // i

        // Clocks
        .tx_core_clk            (clk_jesd204b_link),        // i
        .txoutclk               (  ),                       // o

        .rx_core_clk            (clk_jesd204b_link),        // i
        .rxoutclk               (  ),                       // o

        .drpclk                 (clk_sys),                  // i

        // PRBS mode
        .gt_prbssel             (3'b000),                   // i  [2 : 0]

        // Tx Ports
        // Lane 0
        .gt0_txcharisk          (4'b0),                     // i  [3 : 0]
        .gt0_txdata             (32'b0),                    // i  [31 : 0]
        // Lane 1
        .gt1_txcharisk          (4'b0),                     // i  [3 : 0]
        .gt1_txdata             (32'b0),                    // i  [31 : 0]

        // Rx Ports
        // Lane 0
        .gt0_rxcharisk          (  ),                       // o  [3 : 0]
        .gt0_rxdisperr          (  ),                       // o  [3 : 0]
        .gt0_rxnotintable       (  ),                       // o  [3 : 0]
        .gt0_rxdata             (adc3_data[31 : 0]),        // o  [31 : 0]
        // Lane 1
        .gt1_rxcharisk          (  ),                       // o  [3 : 0]
        .gt1_rxdisperr          (  ),                       // o  [3 : 0]
        .gt1_rxnotintable       (  ),                       // o  [3 : 0]
        .gt1_rxdata             (adc3_data[63 : 32]),       // o  [31 : 0]

        // Serial ports
        .rxn_in                 (adc3_jesd204b_gt_rx_n),    // i  [1 : 0]
        .rxp_in                 (adc3_jesd204b_gt_rx_p),    // i  [1 : 0]
        .txn_out                (  ),                       // o  [1 : 0]
        .txp_out                (  )                        // o  [1 : 0]
    ); // jesd204phy_adc3

endmodule: adc_stub