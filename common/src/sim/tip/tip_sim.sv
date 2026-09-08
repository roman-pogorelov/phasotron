// TIP simulation utilities
package tip_sim;

    import tip_defs::*;


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

            offset = 0;
            xfer_data = '0;
            xfer_mask = '0;
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

        axis_m.tdata = pkt_hdr;
        axis_m.tkeep = 16'hFFFF;
        axis_m.tlast = 0;
        axis_m.tvalid = 1;

        do begin
            @(posedge clk);
        end while (!axis_m.tready);

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

        axis_m.tdata = pkt_hdr;
        axis_m.tkeep = 16'hFFFF;
        axis_m.tlast = 1;
        axis_m.tvalid = 1;

        do begin
            @(posedge clk);
        end while (!axis_m.tready);

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

            axis_m.tdata = pkt_hdr;
            axis_m.tkeep = 16'hFFFF;
            axis_m.tlast = 1;
            axis_m.tvalid = 1;

            do begin
                @(posedge clk);
            end while (!axis_m.tready);
        end

        axis_m.tdata = 0;
        axis_m.tkeep = 0;
        axis_m.tlast = 0;
        axis_m.tvalid = 0;
    endtask


endpackage: tip_sim