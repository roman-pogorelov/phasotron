module debug_ctrl
(
    // Reset and clock
    input  logic        rst,
    input  logic        clk,

    // APB3 master interface
    apb3_if.master      apb3_m,

    // Input/output streams
    axis_if.slave       axis_in,
    axis_if.master      axis_out
);

    // Xilinx block design system
    debug_system the_debug_system (
        .rstn                   (!rst),
        .clk                    (clk),

        .apb3_m_paddr           (apb3_m.paddr),
        .apb3_m_penable         (apb3_m.penable),
        .apb3_m_prdata          (apb3_m.prdata),
        .apb3_m_pready          (apb3_m.pready),
        .apb3_m_psel            (apb3_m.psel),
        .apb3_m_pslverr         (apb3_m.pslverr),
        .apb3_m_pwdata          (apb3_m.pwdata),
        .apb3_m_pwrite          (apb3_m.pwrite),

        .axis_ctl_out_tdata     (  ),
        .axis_ctl_out_tkeep     (  ),
        .axis_ctl_out_tlast     (  ),
        .axis_ctl_out_tready    (1'b1),
        .axis_ctl_out_tvalid    (  ),

        .axis_in_tdata          (axis_in.tdata),
        .axis_in_tkeep          (axis_in.tkeep),
        .axis_in_tlast          (axis_in.tlast),
        .axis_in_tready         (axis_in.tready),
        .axis_in_tvalid         (axis_in.tvalid),

        .axis_out_tdata         (axis_out.tdata),
        .axis_out_tkeep         (axis_out.tkeep),
        .axis_out_tlast         (axis_out.tlast),
        .axis_out_tready        (axis_out.tready),
        .axis_out_tvalid        (axis_out.tvalid)
    ); // the_debug_system

endmodule: debug_ctrl