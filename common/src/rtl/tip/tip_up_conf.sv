/*
    // TIP upstream endpoint configuration unit
    tip_up_conf #(
        .TYPE_ID        (), // Node type ID
        .FW_REV_ID      ()  // FW revision ID
    )
    the_tip_up_conf (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // Transport status interface
        .up_transp_stat (), // tip_transp_stat_if.slave

        // Configuration control
        .up_conf        (), // tip_up_conf_if.master

        // APB3 slave interface
        .apb3_s         (), // apb3_if.slave

        // APB3 msater interface
        .dn_apb3_m      (), // apb3_if.master

        // Request interface
        .up_req         ()  // tip_up_req_if.master
    ); // the_tip_up_conf
*/

import apb3_defs::*;
import tip_defs::*;

module tip_up_conf
#(
    parameter logic [31 : 0]    TYPE_ID     = 32'h00000000, // Node type ID
    parameter logic [31 : 0]    FW_REV_ID   = 32'h00000000  // FW revision ID
)
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // Transport status interface
    tip_transp_stat_if.slave    up_transp_stat,

    // Configuration control
    tip_up_conf_if.master       up_conf,

    // APB3 slave interface
    apb3_if.slave               apb3_s,

    // APB3 msater interface
    apb3_if.master              dn_apb3_m,

    // Request interface
    tip_up_req_if.master        up_req
);
    // Constants
    localparam apb3_addr_t      DN_ADDR_BASE = TIP_CFG_ADDR_DN_CNT;


    // Variables
    logic           wr_ena;
    //
    logic           link_up_d = '0;
    logic           link_up_rise = '0;
    apb3_data_t     link_up_cnt = '0;
    //
    apb3_data_t     link_err_cnt = '0;
    //
    logic           reset_req = '0;
    //
    apb3_data_t     indiv_addr = '0;
    //
    apb3_data_t     group_addr0 = '0;
    apb3_data_t     group_addr1 = '0;
    apb3_data_t     group_addr2 = '0;
    apb3_data_t     group_addr3 = '0;
    apb3_data_t     group_addr4 = '0;
    apb3_data_t     group_addr5 = '0;
    apb3_data_t     group_addr6 = '0;
    apb3_data_t     group_addr7 = '0;


    // Froward some APB3 signals from the slave to the master
    assign dn_apb3_m.paddr = apb3_s.paddr;
    assign dn_apb3_m.psel = apb3_s.psel;
    assign dn_apb3_m.penable = apb3_s.penable;
    assign dn_apb3_m.pwrite = apb3_s.pwrite;
    assign dn_apb3_m.pwdata = apb3_s.pwdata;


    // Detect APB3 write transfers
    assign wr_ena = apb3_s.psel & apb3_s.penable & apb3_s.pwrite;


    // Detect when the transport link comes up
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            link_up_d <= '0;
            link_up_rise <= '0;
        end
        else begin
            link_up_d <= up_transp_stat.link_up;
            link_up_rise <= up_transp_stat.link_up & !link_up_d;
        end
    end


    // Link-up event counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            link_up_cnt <= '0;
        else if (wr_ena & (apb3_s.paddr.word_addr == TIP_CFG_ADDR_LINK_UP_CNT.word_addr))
            link_up_cnt <= apb3_s.pwdata;
        else
            link_up_cnt <= link_up_cnt + apb3_data_t'(link_up_rise);
    end


    // Link error counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            link_err_cnt <= '0;
        else if (wr_ena & (apb3_s.paddr.word_addr == TIP_CFG_ADDR_LINK_ERR_CNT.word_addr))
            link_err_cnt <= apb3_s.pwdata;
        else
            link_err_cnt <= link_err_cnt + apb3_data_t'(up_transp_stat.hard_err);
    end


    // Reset request
    always @(posedge rst, posedge clk) begin
        if (rst)
            reset_req <= '0;
        else if (wr_ena & (apb3_s.paddr.word_addr == TIP_CFG_ADDR_RST_REQ.word_addr))
            reset_req <= (apb3_s.pwdata == TIP_CFG_RST_REQ_KEY);
        else
            reset_req <= '0;
    end
    assign up_req.reset = reset_req;


    // Individual address
    always @(posedge rst, posedge clk) begin
        if (rst)
            indiv_addr <= '0;
        else if (wr_ena & (apb3_s.paddr.word_addr == TIP_CFG_ADDR_INDIV_ADDR.word_addr))
            indiv_addr <= apb3_s.pwdata;
        else
            indiv_addr <= indiv_addr;
    end
    assign up_conf.indiv_addr = indiv_addr;


    // Group addresses
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            group_addr0 <= '0;
            group_addr1 <= '0;
            group_addr2 <= '0;
            group_addr3 <= '0;
            group_addr4 <= '0;
            group_addr5 <= '0;
            group_addr6 <= '0;
            group_addr7 <= '0;
        end
        else if (wr_ena) begin
            if (apb3_s.paddr.word_addr == TIP_CFG_ADDR_GROUP_ADDR0.word_addr) begin
                group_addr0 <= apb3_s.pwdata;
            end
            if (apb3_s.paddr.word_addr == TIP_CFG_ADDR_GROUP_ADDR1.word_addr) begin
                group_addr1 <= apb3_s.pwdata;
            end
            if (apb3_s.paddr.word_addr == TIP_CFG_ADDR_GROUP_ADDR2.word_addr) begin
                group_addr2 <= apb3_s.pwdata;
            end
            if (apb3_s.paddr.word_addr == TIP_CFG_ADDR_GROUP_ADDR3.word_addr) begin
                group_addr3 <= apb3_s.pwdata;
            end
            if (apb3_s.paddr.word_addr == TIP_CFG_ADDR_GROUP_ADDR4.word_addr) begin
                group_addr4 <= apb3_s.pwdata;
            end
            if (apb3_s.paddr.word_addr == TIP_CFG_ADDR_GROUP_ADDR5.word_addr) begin
                group_addr5 <= apb3_s.pwdata;
            end
            if (apb3_s.paddr.word_addr == TIP_CFG_ADDR_GROUP_ADDR6.word_addr) begin
                group_addr6 <= apb3_s.pwdata;
            end
            if (apb3_s.paddr.word_addr == TIP_CFG_ADDR_GROUP_ADDR7.word_addr) begin
                group_addr7 <= apb3_s.pwdata;
            end
        end
    end
    assign up_conf.group_addr0 = group_addr0;
    assign up_conf.group_addr1 = group_addr1;
    assign up_conf.group_addr2 = group_addr2;
    assign up_conf.group_addr3 = group_addr3;
    assign up_conf.group_addr4 = group_addr4;
    assign up_conf.group_addr5 = group_addr5;
    assign up_conf.group_addr6 = group_addr6;
    assign up_conf.group_addr7 = group_addr7;


    // ABP3 read logic
    always_comb begin
        if (apb3_s.paddr < DN_ADDR_BASE) begin
            case (apb3_s.paddr.word_addr)
                TIP_CFG_ADDR_MAGIC_ID.word_addr:        apb3_s.prdata = apb3_data_t'(TIP_CFG_MAGIC_ID);
                TIP_CFG_ADDR_REV_ID.word_addr:          apb3_s.prdata = apb3_data_t'(TIP_CFG_REV_ID);
                TIP_CFG_ADDR_TYPE_ID.word_addr:         apb3_s.prdata = apb3_data_t'(TYPE_ID);
                TIP_CFG_ADDR_FW_REV_ID.word_addr:       apb3_s.prdata = apb3_data_t'(FW_REV_ID);
                TIP_CFG_ADDR_INDIV_ADDR.word_addr:      apb3_s.prdata = indiv_addr;
                TIP_CFG_ADDR_GROUP_ADDR0.word_addr:     apb3_s.prdata = group_addr0;
                TIP_CFG_ADDR_GROUP_ADDR1.word_addr:     apb3_s.prdata = group_addr1;
                TIP_CFG_ADDR_GROUP_ADDR2.word_addr:     apb3_s.prdata = group_addr2;
                TIP_CFG_ADDR_GROUP_ADDR3.word_addr:     apb3_s.prdata = group_addr3;
                TIP_CFG_ADDR_GROUP_ADDR4.word_addr:     apb3_s.prdata = group_addr4;
                TIP_CFG_ADDR_GROUP_ADDR5.word_addr:     apb3_s.prdata = group_addr5;
                TIP_CFG_ADDR_GROUP_ADDR6.word_addr:     apb3_s.prdata = group_addr6;
                TIP_CFG_ADDR_GROUP_ADDR7.word_addr:     apb3_s.prdata = group_addr7;
                TIP_CFG_ADDR_LINK_UP_CNT.word_addr:     apb3_s.prdata = link_up_cnt;
                TIP_CFG_ADDR_LINK_ERR_CNT.word_addr:    apb3_s.prdata = link_err_cnt;
                default:                                apb3_s.prdata = apb3_data_t'(0);
            endcase
            apb3_s.pready = '1;
            apb3_s.pslverr = '0;
        end
        else begin
            apb3_s.prdata = dn_apb3_m.prdata;
            apb3_s.pready = dn_apb3_m.pready;
            apb3_s.pslverr = dn_apb3_m.pslverr;
        end
    end

endmodule: tip_up_conf