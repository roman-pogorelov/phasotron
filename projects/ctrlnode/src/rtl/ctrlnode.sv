module ctrlnode
(
    // System clock
    input  wire             clk_100mhz_p,
    input  wire             clk_100mhz_n,

    // GT reference clock
    input  wire             clk_gt_156p25mhz_p,
    input  wire             clk_gt_156p25mhz_n,

    // Downstream GT RX
    input  wire  [1 : 0]    dn0_rx_p,
    input  wire  [1 : 0]    dn0_rx_n,

    // Upstream GT TX
    output wire  [1 : 0]    dn0_tx_p,
    output wire  [1 : 0]    dn0_tx_n,

    // SFP control
    input  wire             sfp0_los,
    inout  wire [2 : 0]     sfp0_mod_def,
    output wire [1 : 0]     sfp0_rs,
    output logic            sfp0_tx_disable,
    input  logic            sfp0_tx_fault,
    input  wire             sfp1_los,
    inout  wire [2 : 0]     sfp1_mod_def,
    output wire [1 : 0]     sfp1_rs,
    output logic            sfp1_tx_disable,
    input  logic            sfp1_tx_fault

);
    // Variables
    logic           clk_sys;
    logic           rst_sys;
    //
    logic           clk_user;
    logic           rst_user;
    //
    logic           clk_gt_ref;
    logic           clk_gt_init;


    // Itrefaces
    apb3_if         dn_apb3();
    //
    axis_if         ctrl_in();
    axis_if         ctrl_out();
    axis_if         data_out();


    // Generates clocks and related resets
    clock_unit the_clock_unit (
        // Reference 100 MHz clock input
        .clk_100mhz_p           (clk_100mhz_p),         // i
        .clk_100mhz_n           (clk_100mhz_n),         // i

        // GT reference 156.25 MHz clock input
        .clk_gt_156p25mhz_p     (clk_gt_156p25mhz_p),   // i
        .clk_gt_156p25mhz_n     (clk_gt_156p25mhz_n),   // i

        // System clock and reset outputs
        .clk_sys                (clk_sys),              // o
        .rst_sys                (rst_sys),              // o

        // MIG system clock output
        .clk_mig_sys            (  ),                   // o

        // MIG reference clock output
        .clk_mig_ref            (  ),                   // o

        // GT reference clock output
        .clk_gt_ref             (clk_gt_ref),           // o

        // GT init clock output
        .clk_gt_init            (clk_gt_init)           // o
    ); // the_clock_unit


    // Debug control interface
    debug_ctrl the_debug_ctrl (
        // Reset and clock
        .rst        (rst_user),     // i
        .clk        (clk_user),     // i

        // APB3 master interface
        .apb3_m     (dn_apb3),      // apb3_if.master

        // Input/output streams
        .axis_in    (ctrl_out),     // axis_if.slave
        .axis_out   (ctrl_in)       // axis_if.master
    ); // the_debug_ctrl


    // TIP downstream link
    tip_dn_link the_tip_dn_link (
        // GT reference clock input
        .gt_clk         (clk_gt_ref),   // i

        // Free running clock input
        .init_clk       (clk_gt_init),  // i

        // User reset and clock outputs
        .user_rst       (rst_user),     // i
        .user_clk       (clk_user),     // i

        // GT serial RX
        .gt_rx_p        (dn0_rx_p),     // i  [1 : 0]
        .gt_rx_n        (dn0_rx_n),     // i  [1 : 0]

        // GT serial TX
        .gt_tx_p        (dn0_tx_p),     // o  [1 : 0]
        .gt_tx_n        (dn0_tx_n),     // o  [1 : 0]

        // APB3 slave to control the downstream endpoint @ user_clk
        .dn_apb3_s      (dn_apb3),      // apb3_if.slave

        // Streams to/from the upstream endpoint @ user_clk
        .up_ctrl_in     (ctrl_in),      // axis_if.slave
        .up_ctrl_out    (ctrl_out),     // axis_if.master
        .up_data_out    (data_out)      // axis_if.master
    ); // the_tip_dn_link


    // XXX: Remove data packets
    assign data_out.tready = 1'b1;


    // Terminate SFP control
    assign sfp0_mod_def     = {3{1'bz}};
    assign sfp0_rs          = {2{1'bz}};
    assign sfp0_tx_disable  = 1'b0;
    assign sfp1_mod_def     = {3{1'bz}};
    assign sfp1_rs          = {2{1'bz}};
    assign sfp1_tx_disable  = 1'b0;

endmodule: ctrlnode