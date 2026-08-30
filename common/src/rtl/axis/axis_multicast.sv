/*
    // Forwards the input stream to a mask-selected
    // subset of multiple outputs
    axis_multicast #(
        .OUT_CNT    ()  // Number out output stream
    )
    the_axis_multicast (
        // Reset and clock
        .rst        (), // i
        .clk        (), // i

        // Mask selecting the active outputs
        .out_mask   (), // i  [OUT_CNT - 1 : 0]

        // Input AXIS interface
        .in         (), // axis_if.slave

        // Output AXIS interface
        .out        ()  // axis_if[OUT_CNT].master
    ); // the_axis_multicast
*/


module axis_multicast
#(
    parameter int unsigned          OUT_CNT = 2 // Number out output stream
)
(
    // Reset and clock
    input  logic                    rst,
    input  logic                    clk,

    // Mask selecting the active outputs
    input  logic [OUT_CNT - 1 : 0]  out_mask,

    // Input AXIS interface
    axis_if.slave                   in,

    // Output AXIS interface
    axis_if.master                  out[OUT_CNT]
);
    // Variables
    logic                   i_tfirst_reg = 1'b1;
    //
    logic [OUT_CNT - 1 : 0] out_mask_kept = '0;
    logic [OUT_CNT - 1 : 0] out_mask_pkt;
    //
    logic [OUT_CNT - 1 : 0] out_tready;


    // Indicates the first transfer at the input
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            i_tfirst_reg <= 1'b1;
        end
        else if (in.tvalid & in.tready) begin
            i_tfirst_reg <= in.tlast;
        end
        else begin
            i_tfirst_reg <= i_tfirst_reg;
        end
    end


    // Keeps the output selection mask for the whole packet
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            out_mask_kept <= '0;
        end
        else if (in.tvalid & in.tready & i_tfirst_reg) begin
            out_mask_kept <= out_mask;
        end
        else begin
            out_mask_kept <= out_mask_kept;
        end
    end


    // Mask can change only at a packet boundary
    assign out_mask_pkt = i_tfirst_reg ? out_mask : out_mask_kept;


    // Multicast logic
    generate
        genvar i, j, k;

        logic [OUT_CNT - 1 : 0][OUT_CNT - 1 : 0] mask;

        for (i = 0; i < OUT_CNT; i++) begin: out_gen
            for (j = 0; j < OUT_CNT; j++) begin: mask_gen
                assign mask[i][j] = (i == j);
            end // mask_gen

            assign out[i].tdata = in.tdata;
            assign out[i].tkeep = in.tkeep;
            assign out[i].tlast = in.tlast;
            assign out[i].tvalid = in.tvalid & out_mask_pkt[i] & (&(out_tready | mask[i] | ~out_mask_pkt));
        end // out_gen

        for (k = 0; k < OUT_CNT; k++) begin: out_tready_gen
            assign out_tready[k] = out[k].tready;
        end // out_tready_gen

    endgenerate
    assign in.tready = &(out_tready | ~out_mask_pkt);

endmodule: axis_multicast