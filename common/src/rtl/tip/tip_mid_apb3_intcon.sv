/*
    // APB3 interconnect routing downstream control transactions
    // driven by the upstream endpoint
    tip_mid_apb3_intcon #(
        .DN_CNT         ()  // Number of downstream links
    )
    tip_mid_apb3_intcon (
        // Reset and clock
        .rst            (), // i
        .clk            (), // i

        // APB3 slave from the upstream endpoint
        .up_apb3_s      (), // apb3_if.slave

        // APB3 masters to the downstream endpoints
        .dn_apb3_m      ()  // apb3_if[DN_CNT].master
    ); // tip_mid_apb3_intcon
*/

import apb3_defs::*;
import tip_defs::*;

module tip_mid_apb3_intcon
#(
    parameter int unsigned      DN_CNT      = 1             // Number of downstream links
)
(
    // Reset and clock
    input  logic                rst,
    input  logic                clk,

    // APB3 slave from the upstream endpoint
    apb3_if.slave               up_apb3_s,

    // APB3 masters to the downstream endpoints
    apb3_if.master              dn_apb3_m[DN_CNT]
);
    // Constants
    localparam int              ADDR_SEC_MASK   = int'(TIP_CFG_ADDR_SEC_MASK.word_addr);
    localparam int unsigned     DN_ADDR_LSB     = $clog2(unsigned'(ADDR_SEC_MASK & -ADDR_SEC_MASK));
    localparam int unsigned     DN_CNT_MAX      = 2 ** DN_ADDR_LSB;


    // Variables
    logic [DN_ADDR_LSB - 1 : 0]         dn_index;
    //
    logic [DN_CNT_MAX - 1 : 0]          dn_link_up_state;
    //
    apb3_data_t [DN_CNT_MAX - 1 : 0]    dn_apb3_m_prdata;
    logic [DN_CNT_MAX - 1 : 0]          dn_apb3_m_pready;
    logic [DN_CNT_MAX - 1 : 0]          dn_apb3_m_pslverr;


    // Sanity checks
    initial begin
        if (DN_CNT > $bits(apb3_data_t)) begin
            $error("DN_CNT must not exceed %d", $bits(apb3_data_t));
        end
    end


    // Derive the downsteram endpoint index from the address
    assign dn_index = up_apb3_s.paddr.word_addr[DN_ADDR_LSB - 1 : 0];


    // Generate logic for each downstream endpoint
    generate
        genvar i;
        for (i = 0; i < DN_CNT_MAX; i++) begin: dn_ep_logic_gen

            // Real logic
            if (i < DN_CNT) begin: dn_ep_logic_real

                // APB3 master output signal logic
                assign dn_apb3_m[i].paddr = up_apb3_s.paddr;
                assign dn_apb3_m[i].psel = up_apb3_s.psel;
                assign dn_apb3_m[i].penable = up_apb3_s.penable;
                assign dn_apb3_m[i].pwrite = up_apb3_s.pwrite;
                assign dn_apb3_m[i].pwdata = up_apb3_s.pwdata;


                // Merge APB3 read data busses from the downstream endpoints
                // to make a single link status register
                assign dn_link_up_state[i] = dn_apb3_m[i].prdata[i];


                // Merge APB3 slave input signals
                assign dn_apb3_m_prdata[i] = dn_apb3_m[i].prdata;
                assign dn_apb3_m_pready[i] = dn_apb3_m[i].pready;
                assign dn_apb3_m_pslverr[i] = dn_apb3_m[i].pslverr;

            end

            // Dummy logic
            else begin: dn_ep_logic_real

                // Merge APB3 read data busses from the downstream endpoints
                // to make a single link status register
                assign dn_link_up_state[i] = 1'b0;


                // Merge APB3 slave input signals
                assign dn_apb3_m_prdata[i] = apb3_data_t'(0);
                assign dn_apb3_m_pready[i] = 1'b1;
                assign dn_apb3_m_pslverr[i] = 1'b0;

            end

        end // dn_ep_logic_gen
    endgenerate


    // APB3 read logic
    always_comb begin
        case (up_apb3_s.paddr.word_addr)
            TIP_CFG_ADDR_DN_CNT.word_addr: begin
                up_apb3_s.prdata = apb3_data_t'(DN_CNT);
                up_apb3_s.pready = 1'b1;
                up_apb3_s.pslverr = 1'b0;
            end

            TIP_CFG_ADDR_DN_LINK_STATE.word_addr: begin
                up_apb3_s.prdata = apb3_data_t'(dn_link_up_state);
                up_apb3_s.pready = dn_apb3_m[0].pready;
                up_apb3_s.pslverr = dn_apb3_m[0].pslverr;
            end

            default: begin
                up_apb3_s.prdata = dn_apb3_m_prdata[dn_index];
                up_apb3_s.pready = dn_apb3_m_pready[dn_index];
                up_apb3_s.pslverr = dn_apb3_m_pslverr[dn_index];
            end
        endcase
    end

endmodule: tip_mid_apb3_intcon