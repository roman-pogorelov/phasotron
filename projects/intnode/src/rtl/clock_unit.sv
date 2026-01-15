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


    // Variables
    logic [RST_SYS_CNT_W - 1 : 0]   rst_sys_cnt = '0;
    logic                           rst_sys_req = '1;


    // Diff buffer for the input reference clock 100MHz
    IBUFGDS clk_100mhz_buf (
        .I      (clk_100mhz_p),
        .IB     (clk_100mhz_n),
        .O      (clk_gt_init)
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


    // MMCM instance
    clk_gen the_clk_gen
    (
        // Clock in ports
        .clk_in1    (clk_gt_init),  // i

        // Clock out ports
        .clk_out1   (clk_sys),      // o
        .clk_out2   (clk_mig_ref),  // o
        .clk_out3   (clk_mig_sys),  // o

        // Status and control signals
        .locked     (  )            // o
    ); // the_clk_gen


    // Generate the system clock domain reset
    always @(posedge clk_sys) begin
        rst_sys_cnt <= (rst_sys_cnt < RST_SYS_LEN) ? rst_sys_cnt + 1'b1 : rst_sys_cnt;
        rst_sys_req <= (rst_sys_cnt < RST_SYS_LEN) & rst_sys_req;
    end
    assign rst_sys = rst_sys_req;


endmodule: clock_unit