/*
    // 2-stage AXIS buffer
    axis_2stage_buf the_axis_2stage_buf (
        // Reset and clock
        .rst        (), // i
        .clk        (), // i

        // Input AXIS interface
        .in         (), // axis_if.slave

        // Output AXIS interface
        .out        ()  // axis_if.master
    ); // the_axis_2stage_buf
*/


module axis_2stage_buf
(
    // Reset and clock
    input  logic    rst,
    input  logic    clk,

    // Input AXIS interface
    axis_if.slave   in,

    // Output AXIS interface
    axis_if.master  out
);
    // Constants
    localparam int unsigned TDATA_W = $bits(in.tdata);
    localparam int unsigned TKEEP_W = $bits(in.tkeep);


    // Variables
    logic [TDATA_W - 1 : 0] i_tdata_reg = '0;
    logic [TKEEP_W - 1 : 0] i_tkeep_reg = '0;
    logic                   i_tlast_reg = '0;
    logic                   i_tvalid_reg = '0;
    //
    logic [TDATA_W - 1 : 0] o_tdata_reg = '0;
    logic [TKEEP_W - 1 : 0] o_tkeep_reg = '0;
    logic                   o_tlast_reg = '0;
    logic                   o_tvalid_reg = '0;


    // Input stage for TDATA, TKEEP, TLAST
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            i_tdata_reg <= '0;
            i_tkeep_reg <= '0;
            i_tlast_reg <= '0;
        end
        else if (!i_tvalid_reg) begin
            i_tdata_reg <= in.tdata;
            i_tkeep_reg <= in.tkeep;
            i_tlast_reg <= in.tlast;
        end
        else begin
            i_tdata_reg <= i_tdata_reg;
            i_tkeep_reg <= i_tkeep_reg;
            i_tlast_reg <= i_tlast_reg;
        end
    end


    // Input stage for TVALID
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            i_tvalid_reg <= '0;
        end
        else if (!i_tvalid_reg | !o_tvalid_reg | out.tready) begin
            i_tvalid_reg <= !(!o_tvalid_reg | out.tready) & in.tvalid;
        end
        else begin
            i_tvalid_reg <= i_tvalid_reg;
        end
    end
    assign in.tready = !i_tvalid_reg;


    // Output stage for TDATA, TKEEP, TLAST
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            o_tdata_reg <= '0;
            o_tkeep_reg <= '0;
            o_tlast_reg <= '0;
        end
        else if (!o_tvalid_reg | out.tready) begin
            if (i_tvalid_reg) begin
                o_tdata_reg <= i_tdata_reg;
                o_tkeep_reg <= i_tkeep_reg;
                o_tlast_reg <= i_tlast_reg;
            end
            else begin
                o_tdata_reg <= in.tdata;
                o_tkeep_reg <= in.tkeep;
                o_tlast_reg <= in.tlast;
            end
        end
        else begin
            o_tdata_reg <= o_tdata_reg;
            o_tkeep_reg <= o_tkeep_reg;
            o_tlast_reg <= o_tlast_reg;
        end
    end
    assign out.tdata = o_tdata_reg;
    assign out.tkeep = o_tkeep_reg;
    assign out.tlast = o_tlast_reg;


    // Output stage for TVALID
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            o_tvalid_reg <= '0;
        end
        else if (!o_tvalid_reg | out.tready) begin
            o_tvalid_reg <= i_tvalid_reg | in.tvalid;
        end
        else begin
            o_tvalid_reg <= o_tvalid_reg;
        end
    end
    assign out.tvalid = o_tvalid_reg;

endmodule: axis_2stage_buf