`timescale  1ns / 1ps

// Simulation delay
`define SIM_DLY     #1ps


// TIP simulation utilities
package tip_sim;

    import tip_defs::*;

    // Parses a TIP packet
    task automatic tip_pkt_parse(virtual axis_if axis, ref logic clk, input string name);
        static int xfer_id = 0;
        static tip_pkt_hdr_t pkt_hdr = '0;
        static logic bad_pkt = '0;
        static logic ctrl_pkt = '0;

        forever begin
            do begin
                @(posedge clk);
            end while (!(axis.tvalid & axis.tready));

            if (!bad_pkt) begin
                if (xfer_id == 0) begin
                    if (!(axis.tkeep[7 : 0] == 8'hFF)) begin
                        $display("\n%0t %s: Corrupter TIP packet header", $realtime(), name);
                        bad_pkt = '1;
                    end
                    else begin
                        pkt_hdr = axis.tdata;
                        if (pkt_hdr.cmn.rev_id != TIP_PROTOCOL_REV_ID) begin
                            $display("\n%0t %s: Unknown TIP protocol revision", $realtime(), name);
                            bad_pkt = '1;
                        end
                        else begin
                            case (pkt_hdr.cmn.type_id)
                                TIP_PKT_TYPE_CMD_CFG: begin
                                    ctrl_pkt = '1;
                                    $display("\n%0t %s: TIP packet type: CONF COMMAND", $realtime(), name);
                                end

                                TIP_PKT_TYPE_CMD_USR: begin
                                    ctrl_pkt = '1;
                                    $display("\n%0t %s: TIP packet type: USER COMMAND", $realtime(), name);
                                end

                                TIP_PKT_TYPE_RPT_CFG: begin
                                    ctrl_pkt = '1;
                                    $display("\n%0t %s: TIP packet type: CONF REPORT", $realtime(), name);
                                end

                                TIP_PKT_TYPE_RPT_USR: begin
                                    ctrl_pkt = '1;
                                    $display("\n%0t %s: TIP packet type: USER REPORT", $realtime(), name);
                                end

                                TIP_PKT_TYPE_DATA: begin
                                    ctrl_pkt = '0;
                                    $display("\n%0t %s: TIP packet type: DATA", $realtime(), name);
                                end

                                default: begin
                                    $display("\n%0t %s: Unknown TIP packet type", $realtime(), name);
                                    bad_pkt = '1;
                                end
                            endcase
                        end

                        if (!bad_pkt) begin
                            $display("\tNode address: %0x", pkt_hdr.cmn.node_addr);
                            if (ctrl_pkt) begin
                                if (!(axis.tkeep[15 : 8] == 8'hFF)) begin
                                    $display("\tCorrupter control header");
                                    bad_pkt = '1;
                                end
                                else begin
                                    $display("\tAddress: %0x", pkt_hdr.ctl.addr);
                                    $display("\tCount: %0d", pkt_hdr.ctl.count);
                                    $display("\tCmd failed: %0x", pkt_hdr.ctl.flags.cmd_failed);
                                    $display("\tNo address increment: %0x", pkt_hdr.ctl.flags.no_addr_inc);
                                    $display("\tNo report: %0x", pkt_hdr.ctl.flags.no_report);
                                    $display("\tCmd type: %s", pkt_hdr.ctl.flags.cmd_type ? "RD" : "WR");
                                end
                            end
                        end
                    end
                end

                else begin
                    if (ctrl_pkt) begin
                        automatic int word_cnt = 4;
                        if (axis.tlast) begin
                            case (axis.tkeep)
                                16'h000F: word_cnt = 1;
                                16'h00FF: word_cnt = 2;
                                16'h0FFF: word_cnt = 3;
                                16'hFFFF: word_cnt = 4;
                                default: begin
                                    $display("\tCorrupter data");
                                    bad_pkt = '1;
                                end
                            endcase
                        end

                        if (!bad_pkt) begin
                            automatic logic [3 : 0][31 : 0] data = axis.tdata;
                            if (xfer_id == 1) begin
                                $display("\tData:");
                            end
                            for (int i = 0; i < word_cnt; i++) begin
                                $display("\t\t%0x", data[i]);
                            end
                        end
                    end
                end

            end

            if (axis.tlast) begin
                xfer_id = 0;
                bad_pkt = '0;
            end
            else begin
                xfer_id++;
            end
        end
    endtask


    // Sends a TIP data packet
    task automatic tip_data_send(virtual axis_if.master axis_m, ref logic clk, input int node_addr, input byte data[]);

        automatic tip_pkt_cmn_hdr_t pkt_hdr = '{
            node_addr: node_addr,
            reserved: 0,
            type_id: TIP_PKT_TYPE_DATA,
            rev_id: 0
        };
        automatic int offset = 8;
        automatic int byte_id = 0;
        automatic int byte_cnt = data.size();
        automatic int xter_cnt = (byte_cnt + offset + 15) / 16;
        //
        automatic logic [15 : 0][7 : 0] xfer_data = pkt_hdr;
        automatic logic [15 : 0]        xfer_mask = 16'h00FF;
        automatic logic                 xfer_last = '0;

        @(posedge clk);
        `SIM_DLY;

        for (int i = 0; i < xter_cnt; i++) begin
            xfer_last = (i == xter_cnt - 1);

            for (int j = offset; j < 16; j++) begin
                if (byte_id < byte_cnt) begin
                    xfer_data[j] = data[byte_id];
                    xfer_mask[j] = 1'b1;
                    byte_id++;
                end
                else begin
                    break;
                end
            end

            axis_m.tdata = xfer_data;
            axis_m.tkeep = xfer_mask;
            axis_m.tlast = xfer_last;
            axis_m.tvalid = 1;

            do begin
                @(posedge clk);
            end while (!axis_m.tready);
            `SIM_DLY;

            offset = 0;
            xfer_data = '0;
            xfer_mask = '0;
        end

        axis_m.tdata = 0;
        axis_m.tkeep = 0;
        axis_m.tlast = 0;
        axis_m.tvalid = 0;

    endtask


    // Send a TIP write command
    task automatic tip_ctrl_wr_send(virtual axis_if.master axis_m, ref logic clk, input logic mode, input int node_addr, input int addr, input int data[]);

        automatic tip_pkt_hdr_t pkt_hdr = '{
            ctl: '{
                addr: addr,
                reserved: 0,
                flags: '{
                    cmd_failed: 0,
                    reserved: 0,
                    no_addr_inc: 0,
                    no_report: 0,
                    cmd_type: TIP_CMD_WR
                },
                count: data.size() - 1
            },

            cmn: '{
                node_addr: node_addr,
                reserved: 0,
                type_id: mode ? TIP_PKT_TYPE_CMD_USR : TIP_PKT_TYPE_CMD_CFG,
                rev_id: 0
            }
        };
        automatic int word_id = 0;
        automatic int word_cnt = data.size();
        automatic int xter_cnt = (word_cnt + 3) / 4;

        @(posedge clk);
        `SIM_DLY;

        axis_m.tdata = pkt_hdr;
        axis_m.tkeep = 16'hFFFF;
        axis_m.tlast = 0;
        axis_m.tvalid = 1;

        do begin
            @(posedge clk);
        end while (!axis_m.tready);
        `SIM_DLY;

        for (int i = 0; i < xter_cnt; i++) begin
            automatic logic [3 : 0][31 : 0] xfer_data = '0;
            automatic logic [3 : 0][3 : 0]  xfer_mask = '0;
            automatic logic                 xfer_last = (i == xter_cnt - 1);

            for (int j = 0; j < 4; j++) begin
                if (word_id < word_cnt) begin
                    xfer_data[j] = data[word_id];
                    xfer_mask[j] = 4'hF;
                    word_id++;
                end
                else begin
                    break;
                end
            end

            axis_m.tdata = xfer_data;
            axis_m.tkeep = xfer_mask;
            axis_m.tlast = xfer_last;

            do begin
                @(posedge clk);
            end while (!axis_m.tready);
            `SIM_DLY;
        end

        axis_m.tdata = 0;
        axis_m.tkeep = 0;
        axis_m.tlast = 0;
        axis_m.tvalid = 0;
    endtask


    // Send a TIP read command
    task automatic tip_ctrl_rd_send(virtual axis_if.master axis_m, ref logic clk, input logic mode, input int node_addr, input int addr, input int count);

        automatic tip_pkt_hdr_t pkt_hdr = '{
            ctl: '{
                addr: addr,
                reserved: 0,
                flags: '{
                    cmd_failed: 0,
                    reserved: 0,
                    no_addr_inc: 0,
                    no_report: 0,
                    cmd_type: TIP_CMD_RD
                },
                count: count - 1
            },

            cmn: '{
                node_addr: node_addr,
                reserved: 0,
                type_id: mode ? TIP_PKT_TYPE_CMD_USR : TIP_PKT_TYPE_CMD_CFG,
                rev_id: 0
            }
        };

        if (count > 0) begin
            @(posedge clk);
            `SIM_DLY;

            axis_m.tdata = pkt_hdr;
            axis_m.tkeep = 16'hFFFF;
            axis_m.tlast = 1;
            axis_m.tvalid = 1;

            do begin
                @(posedge clk);
            end while (!axis_m.tready);
            `SIM_DLY;
        end

        axis_m.tdata = 0;
        axis_m.tkeep = 0;
        axis_m.tlast = 0;
        axis_m.tvalid = 0;
    endtask


    // Send a TIP configuration write command
    task automatic tip_cmd_cfg_wr(virtual axis_if.master axis_m, ref logic clk, input int node_addr, input int addr, input int data[]);

        automatic tip_pkt_hdr_t pkt_hdr = '{
            ctl: '{
                addr: addr,
                reserved: 0,
                flags: '{
                    cmd_failed: 0,
                    reserved: 0,
                    no_addr_inc: 0,
                    no_report: 0,
                    cmd_type: TIP_CMD_WR
                },
                count: data.size() - 1
            },

            cmn: '{
                node_addr: node_addr,
                reserved: 0,
                type_id: TIP_PKT_TYPE_CMD_CFG,
                rev_id: 0
            }
        };
        automatic int word_id = 0;
        automatic int word_cnt = data.size();
        automatic int xter_cnt = (word_cnt + 3) / 4;

        @(posedge clk);
        `SIM_DLY;

        axis_m.tdata = pkt_hdr;
        axis_m.tkeep = 16'hFFFF;
        axis_m.tlast = 0;
        axis_m.tvalid = 1;

        do begin
            @(posedge clk);
        end while (!axis_m.tready);
        `SIM_DLY;

        for (int i = 0; i < xter_cnt; i++) begin
            automatic logic [3 : 0][31 : 0] xfer_data = '0;
            automatic logic [3 : 0][3 : 0]  xfer_mask = '0;
            automatic logic                 xfer_last = (i == xter_cnt - 1);

            for (int j = 0; j < 4; j++) begin
                if (word_id < word_cnt) begin
                    xfer_data[j] = data[word_id];
                    xfer_mask[j] = 4'hF;
                    word_id++;
                end
                else begin
                    break;
                end
            end

            axis_m.tdata = xfer_data;
            axis_m.tkeep = xfer_mask;
            axis_m.tlast = xfer_last;

            do begin
                @(posedge clk);
            end while (!axis_m.tready);
            `SIM_DLY;
        end

        axis_m.tdata = 0;
        axis_m.tkeep = 0;
        axis_m.tlast = 0;
        axis_m.tvalid = 0;
    endtask


    // Send a TIP configuration write report
    task automatic tip_rpt_cfg_wr(virtual axis_if.master axis_m, ref logic clk, input int node_addr, input int addr, input logic cmd_failed);

        automatic tip_pkt_hdr_t pkt_hdr = '{
            ctl: '{
                addr: addr,
                reserved: 0,
                flags: '{
                    cmd_failed: cmd_failed,
                    reserved: 0,
                    no_addr_inc: 0,
                    no_report: 0,
                    cmd_type: TIP_CMD_WR
                },
                count: 0
            },

            cmn: '{
                node_addr: node_addr,
                reserved: 0,
                type_id: TIP_PKT_TYPE_RPT_CFG,
                rev_id: 0
            }
        };

        @(posedge clk);
        `SIM_DLY;

        axis_m.tdata = pkt_hdr;
        axis_m.tkeep = 16'hFFFF;
        axis_m.tlast = 1;
        axis_m.tvalid = 1;

        do begin
            @(posedge clk);
        end while (!axis_m.tready);
        `SIM_DLY;

        axis_m.tdata = 0;
        axis_m.tkeep = 0;
        axis_m.tlast = 0;
        axis_m.tvalid = 0;
    endtask


    // Send a TIP configuration read command
    task automatic tip_cmd_cfg_rd(virtual axis_if.master axis_m, ref logic clk, input int node_addr, input int addr, input int count);

        automatic tip_pkt_hdr_t pkt_hdr = '{
            ctl: '{
                addr: addr,
                reserved: 0,
                flags: '{
                    cmd_failed: 0,
                    reserved: 0,
                    no_addr_inc: 0,
                    no_report: 0,
                    cmd_type: TIP_CMD_RD
                },
                count: count - 1
            },

            cmn: '{
                node_addr: node_addr,
                reserved: 0,
                type_id: TIP_PKT_TYPE_CMD_CFG,
                rev_id: 0
            }
        };

        if (count > 0) begin
            @(posedge clk);
            `SIM_DLY;

            axis_m.tdata = pkt_hdr;
            axis_m.tkeep = 16'hFFFF;
            axis_m.tlast = 1;
            axis_m.tvalid = 1;

            do begin
                @(posedge clk);
            end while (!axis_m.tready);
            `SIM_DLY;
        end

        axis_m.tdata = 0;
        axis_m.tkeep = 0;
        axis_m.tlast = 0;
        axis_m.tvalid = 0;
    endtask

endpackage: tip_sim