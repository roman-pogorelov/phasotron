/*
    // Generates clocks and related resets
    clock_unit the_clock_unit
    (
        // Input reference clock 100MHz
        .clk_100mhz_p   (), // i
        .clk_100mhz_n   (), // i

        // System clock and reset
        .clk_sys        (), // o
        .rst_sys        (), // o

        // MIG system clock
        .clk_mig_sys    (), // o

        // MIG reference clock 200MHz
        .clk_mig_ref    ()  // o
    ); // the_clock_unit
*/


module clock_unit
(
    // Input reference clock 100MHz
    input  wire     clk_100mhz_p,
    input  wire     clk_100mhz_n,

    // System clock and reset
    output wire     clk_sys,
    output wire     rst_sys,

    // MIG system clock
    output wire     clk_mig_sys,

    // MIG reference clock 200MHz
    output wire     clk_mig_ref
);
    // Constants
    localparam int unsigned     RST_SYS_LEN     = 1000;
    localparam int unsigned     RST_SYS_CNT_W   = $clog2(RST_SYS_LEN + 1);


    // Variables
    logic [RST_SYS_CNT_W - 1 : 0]   rst_sys_cnt = '0;
    logic                           rst_sys_req = '1;


    // MMCM instance
    clk_gen the_clk_gen
    (
        // Clock in ports
        .clk_in1_p  (clk_100mhz_p), // i
        .clk_in1_n  (clk_100mhz_n), // i

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