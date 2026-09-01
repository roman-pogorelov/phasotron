// TIP (tree-based interconnect protocol) defenitions
package tip_defs;

    // AXIS parameters
    parameter int unsigned      TIP_AXIS_TDATA_W    = 128;
    parameter int unsigned      TIP_AXIS_TKEEP_W    = 16;


    // TIP packet: common header
    typedef struct packed {
        logic [31 : 0]  node_addr;
        logic [15 : 0]  reserved;
        logic [7 : 0]   type_id;
        logic [7 : 0]   rev_id;
    } tip_pkt_cmn_hdr_t;


    // TIP packet: control flags
    typedef struct packed {
        logic           cmd_failed;
        logic [3 : 0]   reserved;
        logic           no_addr_inc;
        logic           no_report;
        logic           cmd_type;
    } tip_pkt_ctl_flags_t;


    // TIP packet: control header
    typedef struct packed {
        logic [31 : 0]      addr;
        logic [15 : 0]      reserved;
        tip_pkt_ctl_flags_t flags;
        logic [7 : 0]       count;
    } tip_pkt_ctl_hdr_t;


    // TIP packet: the entire header
    typedef struct packed {
        tip_pkt_ctl_hdr_t   ctl;
        tip_pkt_cmn_hdr_t   cmn;
    } tip_pkt_hdr_t;


    // TIP packet types
    parameter logic [7 : 0] TIP_PKT_TYPE_CMD_CFG    = 8'h00;
    parameter logic [7 : 0] TIP_PKT_TYPE_CMD_USR    = 8'h01;
    parameter logic [7 : 0] TIP_PKT_TYPE_RPT_CFG    = 8'h80;
    parameter logic [7 : 0] TIP_PKT_TYPE_RPT_USR    = 8'h81;
    parameter logic [7 : 0] TIP_PKT_TYPE_DATA       = 8'h82;


    // TIP command types
    parameter logic TIP_CMD_WR  = 1'b0;
    parameter logic TIP_CMD_RD  = 1'b1;


    // Import APB3 address structure
    import apb3_defs::apb3_addr_t;


    // TIP configuration register map
    parameter apb3_addr_t  TIP_CFG_ADDR_MAGIC_ID        = 32'h0000_0000;
    parameter apb3_addr_t  TIP_CFG_ADDR_REV_ID          = 32'h0000_0004;
    parameter apb3_addr_t  TIP_CFG_ADDR_TYPE_ID         = 32'h0000_0008;
    parameter apb3_addr_t  TIP_CFG_ADDR_FW_REV_ID       = 32'h0000_000C;
    //
    parameter apb3_addr_t  TIP_CFG_ADDR_RST_REQ         = 32'h0000_0010;
    //
    parameter apb3_addr_t  TIP_CFG_ADDR_INDIV_ADDR      = 32'h0000_0100;
    //
    parameter apb3_addr_t  TIP_CFG_ADDR_GROUP_ADDR0     = 32'h0000_0200;
    parameter apb3_addr_t  TIP_CFG_ADDR_GROUP_ADDR1     = 32'h0000_0204;
    parameter apb3_addr_t  TIP_CFG_ADDR_GROUP_ADDR2     = 32'h0000_0208;
    parameter apb3_addr_t  TIP_CFG_ADDR_GROUP_ADDR3     = 32'h0000_020C;
    parameter apb3_addr_t  TIP_CFG_ADDR_GROUP_ADDR4     = 32'h0000_0210;
    parameter apb3_addr_t  TIP_CFG_ADDR_GROUP_ADDR5     = 32'h0000_0214;
    parameter apb3_addr_t  TIP_CFG_ADDR_GROUP_ADDR6     = 32'h0000_0218;
    parameter apb3_addr_t  TIP_CFG_ADDR_GROUP_ADDR7     = 32'h0000_021C;
    //
    parameter apb3_addr_t  TIP_CFG_ADDR_LINK_UP_CNT     = 32'h0000_0300;
    parameter apb3_addr_t  TIP_CFG_ADDR_LINK_ERR_CNT    = 32'h0000_0304;
    //
    parameter apb3_addr_t  TIP_CFG_ADDR_DN_CNT          = 32'h0000_0400;
    parameter apb3_addr_t  TIP_CFG_ADDR_DN_LINK_STATE   = 32'h0000_0404;
    //
    parameter apb3_addr_t  TIP_CFG_ADDR_DN_ENA          = 32'h0000_0500;
    parameter apb3_addr_t  TIP_CFG_ADDR_DN_LINK_UP_CNT  = 32'h0000_0600;
    parameter apb3_addr_t  TIP_CFG_ADDR_DN_LINK_ERR_CNT = 32'h0000_0700;

endpackage: tip_defs