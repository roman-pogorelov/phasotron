`timescale  1ns / 1ps

module axis_multicast_tb ();

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
    localparam int unsigned OUT_CNT         = 3;


    // Valiables
    logic                   rst;
    logic                   clk;
    //
    logic [OUT_CNT - 1 : 0] mask;


    // Interfaces
    axis_if #(.TDATA_W(TDATA_W), .TKEEP_W(TKEEP_W))   in();
    axis_if #(.TDATA_W(TDATA_W), .TKEEP_W(TKEEP_W))   out[OUT_CNT]();

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
        mask = 0;
        //
        in.tdata = 0;
        in.tkeep = 0;
        in.tvalid = 0;
        in.tlast = 0;
    end


    // Defaults
    generate
        genvar id;
        for (id = 0; id < OUT_CNT; id++) begin
            initial out[id].tready = 0;
        end
    endgenerate


    // Forwards the input stream to a mask-selected
    // subset of multiple outputs
    axis_multicast #(
        .OUT_CNT    (OUT_CNT)  // Number out output stream
    )
    the_axis_multicast (
        // Reset and clock
        .rst        (rst),      // i
        .clk        (clk),      // i

        // Mask selecting the active outputs
        .out_mask   (mask),     // i  [OUT_CNT - 1 : 0]

        // Input AXIS interface
        .in         (in),       // axis_if.slave

        // Output AXIS interface
        .out        (out)       // axis_if[OUT_CNT].master
    ); // the_axis_multicast

endmodule: axis_multicast_tb