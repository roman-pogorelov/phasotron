`timescale  1ns / 1ps

module axis_2stage_buf_tb ();

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


    // Valiables
    logic       rst;
    logic       clk;


    // Interfaces
    axis_if #(.TDATA_W(TDATA_W), .TKEEP_W(TKEEP_W))   in();
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
        in.tdata     = 0;
        in.tkeep     = 0;
        in.tvalid    = 0;
        in.tlast     = 0;
        //
        out.tready   = 0;
    end


    // 2-stage AXIS buffer
    axis_2stage_buf the_axis_2stage_buf (
        // Reset and clock
        .rst        (rst),  // i
        .clk        (clk),  // i

        // Input AXIS interface
        .in         (in),   // axis_if.slave

        // Output AXIS interface
        .out        (out)   // axis_if.master
    ); // the_axis_2stage_buf

endmodule: axis_2stage_buf_tb