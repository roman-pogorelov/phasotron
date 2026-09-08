/*
    // Converts TIP AXIS packets into APB3 transactions and
    // converts APB3 responses back into TIP AXIS packets
    tip_axis_apb3_bridge #(
        .RPT_TYPE   () // Report type: 0 - configuration report, 1 - user report
    )
    the_tip_axis_apb3_bridge (
        // Reset and clock
        .rst        (), // i
        .clk        (), // i

        // Configuration interface
        .conf       (), // tip_up_conf_if.slave

        // Control streams
        .ctrl_in    (), // axis_if.slave
        .ctrl_out   (), // axis_if.master

        // APB3 master
        .apb3_m     ()  // apb3_if.master
    ); // the_tip_axis_apb3_bridge
*/

import apb3_defs::*;
import tip_defs::*;

module tip_axis_apb3_bridge
#(
    parameter int unsigned  RPT_TYPE = 0    // Report type: 0 - configuration report, 1 - user report
)
(
    // Reset and clock
    input  logic            rst,
    input  logic            clk,

    // Configuration interface
    tip_up_conf_if.slave    conf,

    // Control streams
    axis_if.slave           ctrl_in,
    axis_if.master          ctrl_out,

    // APB3 master
    apb3_if.master          apb3_m
);
    // Constants
    localparam logic [7 : 0]                        PKT_TYPE_RPT            = RPT_TYPE ? TIP_PKT_TYPE_RPT_USR : TIP_PKT_TYPE_RPT_CFG;
    //
    localparam logic [TIP_AXIS_TKEEP_W - 1 : 0]     AXIS_TKEEP_ALL          = '1;
    localparam int unsigned                         AXIS_APB3_RATIO         = TIP_AXIS_TDATA_W / $bits(apb3_data_t);
    //
    localparam int unsigned                         APB3_TIMEOUT_CNT_W      = $clog2(TIP_APB3_TIMEOUT_CY);
    localparam int unsigned                         APB3_TIMEOUT_CNT_MAX    = TIP_APB3_TIMEOUT_CY - 1;
    //
    localparam int unsigned                         RAM_BUF_DATA_W          = TIP_AXIS_TDATA_W;
    localparam int unsigned                         RAM_BUF_DEPTH           = (2 ** $bits(tip_pkt_ctl_count_t)) / AXIS_APB3_RATIO;
    localparam int unsigned                         RAM_BUF_ADDR_W          = $bits(tip_pkt_ctl_count_t) - $clog2(AXIS_APB3_RATIO);
    localparam int unsigned                         RAM_BUF_IDX_W           = $clog2(AXIS_APB3_RATIO);


    // FSM states
    typedef enum int unsigned {
        st_wait_pkt,
        st_receive_wr_data,
        st_do_apb3_wr_setup,
        st_do_apb3_wr_access,
        st_send_wr_report,
        st_do_apb3_rd_setup,
        st_do_apb3_rd_access,
        st_send_rd_report_head,
        st_send_rd_report_data,
        st_remove_bad_pkt
    } fsm_t;


    // APB3 timeout counter type
    typedef logic [APB3_TIMEOUT_CNT_W - 1 : 0] apb3_timeout_cnt_t;


    // RAM buffer address type
    typedef struct packed {
        logic [RAM_BUF_ADDR_W - 1 : 0]  off;
        logic [RAM_BUF_IDX_W - 1 : 0]   idx;
    } ram_buf_addr_t;


    // Returns the expected TKEEP based on the given transfer counter
    function logic [TIP_AXIS_TKEEP_W - 1 : 0] axis_tkeep_calc(input tip_pkt_ctl_count_t count);
        if (count == 0)
            return 16'h000F;
        else if (count == 1)
            return 16'h00FF;
        else if (count == 2)
            return 16'h0FFF;
        else
            return AXIS_TKEEP_ALL;
    endfunction


    // Returns the RAM buffer WE mask based on the given address counter
    function logic [AXIS_APB3_RATIO - 1 : 0] ram_buf_we_calc(input ram_buf_addr_t addr);
        if (addr.idx == 0)
            return 4'h1;
        else if (addr.idx == 1)
            return 4'h2;
        else if (addr.idx == 2)
            return 4'h4;
        else
            return 4'h8;
    endfunction


    // Interfaces
    axis_if                                 ctrl_out_buf();


    // Signals
    tip_pkt_hdr_t                           pkt_hdr;
    //
    logic                                   cmd_init;
    //
    logic                                   cmd_failed = '0;
    logic                                   cmd_failed_set;
    //
    tip_pkt_ctl_hdr_t                       ctl_hdr_copy = '0;
    //
    apb3_addr_t                             apb3_paddr = '0;
    logic                                   apb3_pwrite = '0;
    //
    apb3_data_t                             apb3_pwdata = '0;
    logic                                   apb3_pwdata_init;
    //
    logic                                   apb3_psel = '0;
    logic                                   apb3_psel_next;
    logic                                   apb3_penable = '0;
    logic                                   apb3_penable_next;
    //
    tip_pkt_ctl_count_t                     axis_xfer_cnt = '0;
    logic                                   axis_xfer_done;
    //
    tip_pkt_ctl_count_t                     apb3_xfer_cnt = '0;
    apb3_timeout_cnt_t                      apb3_timeout_cnt = '0;
    //
    logic [RAM_BUF_DATA_W - 1 : 0]          ram_buf_in;
    logic [AXIS_APB3_RATIO - 1 : 0]         ram_buf_we;
    logic [RAM_BUF_DATA_W - 1 : 0]          ram_buf_out;
    apb3_data_t [RAM_BUF_DATA_W - 1 : 0]    ram_buf_out_apb3;
    //
    ram_buf_addr_t                          ram_buf_wr_addr = 0;
    logic                                   ram_buf_wr_addr_clr;
    ram_buf_addr_t                          ram_buf_wr_addr_inc;
    //
    ram_buf_addr_t                          ram_buf_rd_addr = 0;
    logic                                   ram_buf_rd_addr_clr;
    ram_buf_addr_t                          ram_buf_rd_addr_inc;
    //
    fsm_t                                   cstate = st_wait_pkt;
    fsm_t                                   nstate;


    // RAM blocks
    (* ram_style = "distributed" *)
    reg [RAM_BUF_DATA_W - 1 : 0] ram_buf [RAM_BUF_DEPTH - 1 : 0];


    // Do sanity checks
    initial begin
        if (TIP_AXIS_TDATA_W != 128) begin
            $error("TIP_AXIS_TDATA_W must be 128. Nothing else is supported");
        end
    end


    // 2-stage AXIS buffer
    axis_2stage_buf ctrl_out_buffer (
        // Reset and clock
        .rst        (rst),          // i
        .clk        (clk),          // i

        // Input AXIS interface
        .in         (ctrl_out_buf), // axis_if.slave

        // Output AXIS interface
        .out        (ctrl_out)      // axis_if.master
    ); // ctrl_out_buffer


    // Packet header
    assign pkt_hdr = ctrl_in.tdata;


    // Indicates if a command failed
    always @(posedge rst, posedge clk) begin
        if (rst)
            cmd_failed <= '0;
        else if (cmd_init)
            cmd_failed <= '0;
        else
            cmd_failed <= cmd_failed | cmd_failed_set;
    end


    // Control header copy
    always @(posedge rst, posedge clk) begin
        if (rst)
            ctl_hdr_copy <= '0;
        else if (cmd_init)
            ctl_hdr_copy <= pkt_hdr.ctl;
        else
            ctl_hdr_copy <= ctl_hdr_copy;
    end


    // APB3 PADDR and PWRITE signals
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            apb3_paddr <= '0;
            apb3_pwrite <= '0;
        end
        else if (cmd_init) begin
            apb3_paddr <= pkt_hdr.ctl.addr;
            apb3_pwrite <= (pkt_hdr.ctl.flags.cmd_type == TIP_CMD_WR);
        end
        else if (apb3_psel & apb3_penable & apb3_m.pready & !ctl_hdr_copy.flags.no_addr_inc) begin
            apb3_paddr <= apb3_paddr + apb3_addr_t'('{word_addr: 1, byte_idx: 0});
        end
        else begin
            apb3_paddr <= apb3_paddr;
            apb3_pwrite <= apb3_pwrite;
        end
    end
    assign apb3_m.paddr = apb3_paddr;
    assign apb3_m.pwrite = apb3_pwrite;


    // APB3 PWDATA signal
    always @(posedge rst, posedge clk) begin
        if (rst)
            apb3_pwdata <= '0;
        else if (cmd_init)
            apb3_pwdata <= '0;
        else if (apb3_pwdata_init)
            apb3_pwdata <= ctrl_in.tdata[$high(apb3_pwdata) : 0];
        else if (apb3_psel & apb3_penable & apb3_pwrite & apb3_m.pready)
            apb3_pwdata <= ram_buf_out_apb3[ram_buf_rd_addr.idx];
        else
            apb3_pwdata <= apb3_pwdata;
    end
    assign apb3_m.pwdata = apb3_pwdata;


    // APB3 PSEL and PENABLE signals
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            apb3_psel <= '0;
            apb3_penable <= '0;
        end
        else begin
            apb3_psel <= apb3_psel_next;
            apb3_penable <= apb3_penable_next;
        end
    end
    assign apb3_m.psel = apb3_psel;
    assign apb3_m.penable = apb3_penable;


    // AXIS transfer counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            axis_xfer_cnt <= '0;
        else if (cmd_init)
            axis_xfer_cnt <= pkt_hdr.ctl.count;
        else if (axis_xfer_done)
            axis_xfer_cnt <= axis_xfer_cnt - tip_pkt_ctl_count_t'(AXIS_APB3_RATIO);
        else
            axis_xfer_cnt <= axis_xfer_cnt;
    end


    // APB3 transfer counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            apb3_xfer_cnt <= '0;
        else if (cmd_init)
            apb3_xfer_cnt <= pkt_hdr.ctl.count;
        else if (apb3_psel & apb3_penable & apb3_m.pready)
            apb3_xfer_cnt <= apb3_xfer_cnt - tip_pkt_ctl_count_t'(1);
        else
            apb3_xfer_cnt <= apb3_xfer_cnt;
    end


    // APB3 timeout counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            apb3_timeout_cnt <= '0;
        else if (apb3_psel & apb3_penable & !apb3_m.pready)
            apb3_timeout_cnt <= apb3_timeout_cnt - apb3_timeout_cnt_t'(1);
        else
            apb3_timeout_cnt <= apb3_timeout_cnt_t'(APB3_TIMEOUT_CNT_MAX);
    end


    // RAM buffer initialization
    generate
        genvar j;
        for (j = 0; j < RAM_BUF_DEPTH; j++) begin: ram_buf_init
            initial begin
                ram_buf[j] = {TIP_AXIS_TDATA_W{1'b0}};
            end
        end // ram_buf_init
    endgenerate


    // RAM buffer logic
    generate
        genvar i;
        for (i = 0; i < AXIS_APB3_RATIO; i++) begin: ram_buf_gen
            always @(posedge clk) begin
                if (ram_buf_we[i]) begin
                    ram_buf[ram_buf_wr_addr.off][i * $bits(apb3_data_t) +: $bits(apb3_data_t)] <= ram_buf_in[i * $bits(apb3_data_t) +: $bits(apb3_data_t)];
                end
            end
        end // ram_buf_gen
    endgenerate
    assign ram_buf_out = ram_buf[ram_buf_rd_addr.off];
    assign ram_buf_out_apb3 = ram_buf_out;


    // RAM buffer write address counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            ram_buf_wr_addr <= '0;
        else if (ram_buf_wr_addr_clr)
            ram_buf_wr_addr <= '0;
        else
            ram_buf_wr_addr <= ram_buf_wr_addr + ram_buf_wr_addr_inc;
    end


    // RAM buffer read address counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            ram_buf_rd_addr <= '0;
        else if (ram_buf_rd_addr_clr)
            ram_buf_rd_addr <= '0;
        else
            ram_buf_rd_addr <= ram_buf_rd_addr + ram_buf_rd_addr_inc;
    end


    // FSM state
    always @(posedge rst, posedge clk) begin
        if (rst)
            cstate <= st_wait_pkt;
        else
            cstate <= nstate;
    end


    // FSM transition logic
    always_comb begin

        // Defaults
        ctrl_in.tready = '0;
        ctrl_out_buf.tdata = '0;
        ctrl_out_buf.tkeep = '0;
        ctrl_out_buf.tlast = '0;
        ctrl_out_buf.tvalid = '0;
        cmd_init = '0;
        cmd_failed_set = '0;
        apb3_pwdata_init = '0;
        apb3_psel_next = '0;
        apb3_penable_next = '0;
        axis_xfer_done = '0;
        ram_buf_in = ctrl_in.tdata;
        ram_buf_we = '0;
        ram_buf_wr_addr_clr = '0;
        ram_buf_wr_addr_inc = '0;
        ram_buf_rd_addr_clr = '0;
        ram_buf_rd_addr_inc = '0;

        // State-dependent logic
        case (cstate)
            st_wait_pkt: begin
                ctrl_in.tready = '1;
                cmd_init = '1;
                ram_buf_wr_addr_clr = '1;
                ram_buf_rd_addr_clr = '1;

                if (ctrl_in.tvalid) begin
                    if (ctrl_in.tkeep == AXIS_TKEEP_ALL) begin
                        if (pkt_hdr.ctl.flags.cmd_type == TIP_CMD_RD) begin
                            if (ctrl_in.tlast) begin
                                if (pkt_hdr.ctl.flags.no_report)
                                    nstate = st_wait_pkt;
                                else begin
                                    apb3_psel_next = '1;
                                    nstate = st_do_apb3_rd_setup;
                                end
                            end
                            else begin
                                nstate = st_remove_bad_pkt;
                            end
                        end
                        else begin
                            if (ctrl_in.tlast) begin
                                nstate = st_wait_pkt;
                            end
                            else begin
                                nstate = st_receive_wr_data;
                            end
                        end
                    end
                    else begin
                        if (ctrl_in.tlast) begin
                            nstate = st_wait_pkt;
                        end
                        else begin
                            nstate = st_remove_bad_pkt;
                        end
                    end
                end
                else begin
                    nstate = st_wait_pkt;
                end
            end

            st_receive_wr_data: begin
                ctrl_in.tready = '1;
                apb3_pwdata_init = ctrl_in.tvalid & (axis_xfer_cnt == ctl_hdr_copy.count);
                axis_xfer_done = ctrl_in.tvalid;
                ram_buf_we = '1;
                ram_buf_wr_addr_inc = ram_buf_addr_t'('{off: ctrl_in.tvalid, idx: 0});

                if (ctrl_in.tvalid) begin
                    if (ctrl_in.tkeep != axis_tkeep_calc(axis_xfer_cnt)) begin
                        if (ctrl_in.tlast) begin
                            nstate = st_wait_pkt;
                        end
                            nstate = st_remove_bad_pkt;
                    end
                    else begin
                        if (axis_xfer_cnt < AXIS_APB3_RATIO) begin
                            if (ctrl_in.tlast) begin
                                apb3_psel_next = '1;
                                nstate = st_do_apb3_wr_setup;
                            end
                            else begin
                                nstate = st_remove_bad_pkt;
                            end
                        end
                        else begin
                            if (ctrl_in.tlast) begin
                                nstate = st_wait_pkt;
                            end
                            else begin
                                nstate = st_receive_wr_data;
                            end
                        end
                    end
                end
                else begin
                    nstate = st_receive_wr_data;
                end
            end

            st_do_apb3_wr_setup: begin
                apb3_psel_next = '1;
                apb3_penable_next = '1;
                ram_buf_rd_addr_inc = ram_buf_addr_t'('{off: 0, idx: 1});
                nstate = st_do_apb3_wr_access;
            end

            st_do_apb3_wr_access: begin
                if (apb3_m.pready) begin
                    cmd_failed_set = apb3_m.pslverr;
                    apb3_penable_next = '0;
                    if ((apb3_xfer_cnt == 0) | apb3_m.pslverr) begin
                        apb3_psel_next = '0;
                        if (ctl_hdr_copy.flags.no_report) begin
                            nstate = st_wait_pkt;
                        end
                        else begin
                            nstate = st_send_wr_report;
                        end
                    end
                    else begin
                        apb3_psel_next = '1;
                        nstate = st_do_apb3_wr_setup;
                    end
                end
                else if (apb3_timeout_cnt == 0) begin
                    cmd_failed_set = '1;
                    apb3_psel_next = '0;
                    apb3_penable_next = '0;
                    nstate = st_send_rd_report_head;
                end
                else begin
                    apb3_psel_next = '1;
                    apb3_penable_next = '1;
                    nstate = st_do_apb3_wr_access;
                end
            end

            st_send_wr_report: begin
                ctrl_out_buf.tdata = tip_pkt_hdr_t'('{
                    ctl: '{
                        addr: ctl_hdr_copy.addr,
                        reserved: '0,
                        flags: '{
                            cmd_failed: cmd_failed,
                            reserved: '0,
                            no_addr_inc: ctl_hdr_copy.flags.no_addr_inc,
                            no_report: '0,
                            cmd_type: ctl_hdr_copy.flags.cmd_type
                        },
                        count: ctl_hdr_copy.count
                    },
                    cmn: '{
                        node_addr: conf.indiv_addr,
                        reserved: '0,
                        type_id: PKT_TYPE_RPT,
                        rev_id: TIP_PROTOCOL_REV_ID
                    }
                });
                ctrl_out_buf.tkeep = AXIS_TKEEP_ALL;
                ctrl_out_buf.tlast = '1;
                ctrl_out_buf.tvalid = '1;

                if (ctrl_out_buf.tready) begin
                    nstate = st_wait_pkt;
                end
                else begin
                    nstate = st_send_wr_report;
                end
            end

            st_do_apb3_rd_setup: begin
                apb3_psel_next = '1;
                apb3_penable_next = '1;
                nstate = st_do_apb3_rd_access;
            end

            st_do_apb3_rd_access: begin
                ram_buf_in = {AXIS_APB3_RATIO{apb3_m.prdata}};
                ram_buf_we = ram_buf_we_calc(ram_buf_wr_addr);
                ram_buf_wr_addr_inc = ram_buf_addr_t'('{off: 0, idx: apb3_m.pready});
                if (apb3_m.pready) begin
                    cmd_failed_set = apb3_m.pslverr;
                    apb3_penable_next = '0;
                    if ((apb3_xfer_cnt == 0) | apb3_m.pslverr) begin
                        apb3_psel_next = '0;
                        nstate = st_send_rd_report_head;
                    end
                    else begin
                        apb3_psel_next = '1;
                        nstate = st_do_apb3_rd_setup;
                    end
                end
                else if (apb3_timeout_cnt == 0) begin
                    cmd_failed_set = '1;
                    apb3_psel_next = '0;
                    apb3_penable_next = '0;
                    nstate = st_send_rd_report_head;
                end
                else begin
                    apb3_psel_next = '1;
                    apb3_penable_next = '1;
                    nstate = st_do_apb3_rd_access;
                end
            end

            st_send_rd_report_head: begin
                ctrl_out_buf.tdata = tip_pkt_hdr_t'('{
                    ctl: '{
                        addr: ctl_hdr_copy.addr,
                        reserved: '0,
                        flags: '{
                            cmd_failed: cmd_failed,
                            reserved: '0,
                            no_addr_inc: ctl_hdr_copy.flags.no_addr_inc,
                            no_report: '0,
                            cmd_type: ctl_hdr_copy.flags.cmd_type
                        },
                        count: ctl_hdr_copy.count
                    },
                    cmn: '{
                        node_addr: conf.indiv_addr,
                        reserved: '0,
                        type_id: PKT_TYPE_RPT,
                        rev_id: TIP_PROTOCOL_REV_ID
                    }
                });
                ctrl_out_buf.tkeep = AXIS_TKEEP_ALL;
                ctrl_out_buf.tlast = cmd_failed;
                ctrl_out_buf.tvalid = '1;

                if (ctrl_out_buf.tready) begin
                    if (cmd_failed) begin
                        nstate = st_wait_pkt;
                    end
                    else begin
                        nstate = st_send_rd_report_data;
                    end
                end
                else begin
                    nstate = st_send_rd_report_head;
                end
            end

            st_send_rd_report_data: begin
                ctrl_out_buf.tdata = ram_buf_out;
                ctrl_out_buf.tkeep = axis_tkeep_calc(axis_xfer_cnt);
                ctrl_out_buf.tlast = (axis_xfer_cnt < AXIS_APB3_RATIO);
                ctrl_out_buf.tvalid = '1;
                axis_xfer_done = ctrl_out_buf.tready;
                ram_buf_rd_addr_inc = ram_buf_addr_t'('{off: ctrl_out_buf.tready, idx: 0});

                if (ctrl_out_buf.tready & (axis_xfer_cnt < AXIS_APB3_RATIO)) begin
                    nstate = st_wait_pkt;
                end
                else begin
                    nstate = st_send_rd_report_data;
                end
            end

            st_remove_bad_pkt: begin
                ctrl_in.tready = '1;

                if (ctrl_in.tvalid & ctrl_in.tlast) begin
                    nstate = st_wait_pkt;
                end
                else begin
                    nstate = st_remove_bad_pkt;
                end
            end

            default: begin
                nstate = st_wait_pkt;
            end
        endcase // cstate
    end

endmodule: tip_axis_apb3_bridge