/*
    // TIP downstream endpoint configuration unit
    tip_dn_conf #(
        .DN_ID          ()  // Downstream endpoint ID
    )
    the_tip_dn_conf (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // APB3 slave interface
        .dn_apb3_s      (), // apb3_if.slave

        // Downstream control interface
        .dn_ctrl        (), // tip_dn_ctrl_if.master

        // Transport status interface
        .dn_transp_stat ()  // tip_transp_stat_if.slave
    ); // the_tip_dn_conf
*/

import apb3_defs::*;
import tip_defs::*;

module tip_dn_conf
#(
    parameter int unsigned      DN_ID = 0   // Downstream endpoint ID
)
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // APB3 slave interface
    apb3_if.slave               dn_apb3_s,

    // Downstream control interface
    tip_dn_ctrl_if.master       dn_ctrl,

    // Transport status interface
    tip_transp_stat_if.slave    dn_transp_stat
);
    // Constants
    localparam apb3_addr_t ADDR_DN_CNT          = TIP_CFG_ADDR_DN_CNT;
    localparam apb3_addr_t ADDR_DN_LINK_STATE   = TIP_CFG_ADDR_DN_LINK_STATE;
    localparam apb3_addr_t ADDR_DN_ENA          = TIP_CFG_ADDR_DN_ENA + apb3_addr_t'('{word_addr: DN_ID, byte_idx: 0});
    localparam apb3_addr_t ADDR_DN_LINK_UP_CNT  = TIP_CFG_ADDR_DN_LINK_UP_CNT + apb3_addr_t'('{word_addr: DN_ID, byte_idx: 0});
    localparam apb3_addr_t ADDR_DN_LINK_ERR_CNT = TIP_CFG_ADDR_DN_LINK_ERR_CNT + apb3_addr_t'('{word_addr: DN_ID, byte_idx: 0});


    // Variables
    logic           wr_ena;
    //
    logic           transp_ena = '0;
    //
    logic           link_up_d = '0;
    logic           link_up_rise = '0;
    apb3_data_t     link_up_cnt = '0;
    //
    apb3_data_t     link_err_cnt = '0;


    // No APB3 wait states
    assign dn_apb3_s.pready = '1;


    // No APB3 slave error indication
    assign dn_apb3_s.pslverr = '0;


    // Detect APB3 write transfers
    assign wr_ena = dn_apb3_s.psel & dn_apb3_s.penable & dn_apb3_s.pwrite;


    // REVIEW: if software writes transp_ena=1 while link_up is still 0, the AND here clears it
    // back to 0 immediately, and it stays 0 forever afterwards (the 'else' branch only ANDs the
    // existing value with link_up, it never re-asserts once the link comes up) -- software must
    // write this register again *after* observing link_up, a write-before-link-up is silently lost.
    // Enables the downstream enpoint to send/receive traffic
    // from/to the transport
    always @(posedge rst, posedge clk) begin
        if (rst)
            transp_ena <= '0;
        else if (wr_ena & (dn_apb3_s.paddr.word_addr == ADDR_DN_ENA.word_addr))
            transp_ena <= dn_apb3_s.pwdata[0] & dn_transp_stat.link_up;
        else
            transp_ena <= transp_ena & dn_transp_stat.link_up;
    end
    assign dn_ctrl.transp_rx_ena = transp_ena;
    assign dn_ctrl.transp_tx_ena = transp_ena;


    // Detect when the transport link comes up
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            link_up_d <= '0;
            link_up_rise <= '0;
        end
        else begin
            link_up_d <= dn_transp_stat.link_up;
            link_up_rise <= dn_transp_stat.link_up & !link_up_d;
        end
    end


    // Link-up event counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            link_up_cnt <= '0;
        else if (wr_ena & (dn_apb3_s.paddr.word_addr == ADDR_DN_LINK_UP_CNT.word_addr))
            link_up_cnt <= dn_apb3_s.pwdata;
        else
            link_up_cnt <= link_up_cnt + apb3_data_t'(link_up_rise);
    end


    // Link error counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            link_err_cnt <= '0;
        else if (wr_ena & (dn_apb3_s.paddr.word_addr == ADDR_DN_LINK_ERR_CNT.word_addr))
            link_err_cnt <= dn_apb3_s.pwdata;
        else
            link_err_cnt <= link_err_cnt + apb3_data_t'(dn_transp_stat.hard_err);
    end


    // REVIEW: this module also uses always_comb for combinational logic (consistent with a few
    // other tip_* files), but every sequential block in this file -- and in the codebase overall
    // -- still uses the legacy 'always @(posedge rst, posedge clk)' form instead of always_ff.
    // Worth picking one style consistently (always_comb/always_ff pair, or plain always @ for both).
    //
    // ABP3 read logic
    always_comb begin
        case (dn_apb3_s.paddr.word_addr)
            // REVIEW: always returns a hardcoded 1 regardless of DN_ID/actual downstream count,
            // and this address (TIP_CFG_ADDR_DN_CNT, no +DN_ID offset) is also intercepted and
            // answered directly by tip_mid_apb3_intcon before reaching this slave, so this case
            // is unreachable/dead from the host's point of view -- consider removing it or wiring
            // it to something meaningful.
            ADDR_DN_CNT.word_addr:          dn_apb3_s.prdata = apb3_data_t'(1);
            ADDR_DN_LINK_STATE.word_addr:   dn_apb3_s.prdata = '{DN_ID: dn_transp_stat.link_up, default: 1'b0};
            ADDR_DN_ENA.word_addr:          dn_apb3_s.prdata = '{0: transp_ena, default: 1'b0};
            ADDR_DN_LINK_UP_CNT.word_addr:  dn_apb3_s.prdata = link_up_cnt;
            ADDR_DN_LINK_ERR_CNT.word_addr: dn_apb3_s.prdata = link_err_cnt;
            default:                        dn_apb3_s.prdata = apb3_data_t'(0);
        endcase
    end

endmodule: tip_dn_conf