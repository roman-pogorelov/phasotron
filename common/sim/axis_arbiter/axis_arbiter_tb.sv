`timescale  1ns / 1ps

module axis_arbiter_tb ();

    // Public clock parameters
    localparam int unsigned CLKFREQ_HZ      = 100_000_000;
    // Private clock parameters (don't modify)
    localparam int unsigned CLKP_NS         = 1_000_000_000 / CLKFREQ_HZ;
    localparam int unsigned CLKHP_NS        = CLKP_NS / 2;


    // Public delay parameters
    localparam int unsigned RSTLEN          = 5 * CLKHP_NS;


    // Public DUT paramaters
    localparam int unsigned TDATA_W         = 16;
    localparam int unsigned TKEEP_W         = 2;
    localparam int unsigned IN_CNT          = 3;
    localparam string       SCHEME          = "RR";


    // Valiables
    logic                   rst;
    logic                   clk;

    // Interfaces
    axis_if #(.TDATA_W(TDATA_W), .TKEEP_W(TKEEP_W))   in[IN_CNT]();
    axis_if #(.TDATA_W(TDATA_W), .TKEEP_W(TKEEP_W))   out();

    // Clock generation
    initial clk = 1'b1;
    always  clk = #CLKHP_NS ~clk;


    // Reset generation
    initial begin
        #0ns    rst = 1'b1;
        #RSTLEN rst = 1'b0;
    end


    // Defaults
    initial begin
        out.tready = 1;
    end


    // Defaults
    generate
        genvar id;
        for (id = 0; id < IN_CNT; id++) begin
            initial begin
                in[id].tdata = (id + 1) * 'h1111;
                in[id].tkeep = id + 1;
                in[id].tlast = 0;
                in[id].tvalid = 0;
            end
        end
    endgenerate


    // AXIS arbiter
    axis_arbiter #(
        .IN_CNT     (IN_CNT),   // Number of input streams
        .SCHEME     (SCHEME)    // Arbitration scheme ("RR" - round-robin, "FP" - fixed priorities)
    )
    the_axis_arbiter (
        // Reset and clock
        .rst        (rst),      // i
        .clk        (clk),      // i

        // Input AXIS interface
        .in         (in),       // axis_if[IN_CNT].slave

        // Output AXIS interface
        .out        (out)       // axis_if.master
    ); // the_axis_arbiter

endmodule: axis_arbiter_tb