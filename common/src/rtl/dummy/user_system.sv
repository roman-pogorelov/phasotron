/*
    // Placeholder for the user_system
    user_system the_user_system (
        // Reset and clock
        .rst        (), // i
        .clk        (), // i

        // APB3 slave interface
        .apb3_s     ()  // apb3_if.slave
    ); // the_user_system
*/

import apb3_defs::*;

module user_system
(
    // Reset and clock
    input  logic            rst,
    input  logic            clk,

    // APB3 slave interface
    apb3_if.slave           apb3_s
);
    // Constants
    localparam apb3_addr_t      MAGIC_ID_ADDR   = 32'h00000000;
    localparam apb3_addr_t      COUNTER_ADDR    = 32'h00000004;
    localparam apb3_addr_t      RDWR_REG_ADDR   = 32'h00000008;
    //
    localparam apb3_data_t      MAGIC_ID_VAL    = 32'hDEADBEEF;


    // Variables
    logic           wr_ena;
    //
    apb3_data_t     counter = '0;
    apb3_data_t     rdwr_reg = '0;
    //
    apb3_data_t     apb3_prdata = '0;


    // No APB3 wait states
    assign apb3_s.pready = '1;


    // No APB3 slave error indication
    assign apb3_s.pslverr = '0;


    // Detect APB3 write transfers
    assign wr_ena = apb3_s.psel & apb3_s.penable & apb3_s.pwrite;


    // Test counter
    always @(posedge rst, posedge clk) begin
        if (rst)
            counter <= '0;
        else if (wr_ena & (apb3_s.paddr.word_addr == COUNTER_ADDR.word_addr))
            counter <= apb3_s.pwdata;
        else
            counter <= counter + 1'b1;
    end


    // Test register
    always @(posedge rst, posedge clk) begin
        if (rst)
            rdwr_reg <= '0;
        else if (wr_ena & (apb3_s.paddr.word_addr == RDWR_REG_ADDR.word_addr))
            rdwr_reg <= apb3_s.pwdata;
        else
            rdwr_reg <= rdwr_reg;
    end


    // APB3 read logic
    always @(posedge rst, posedge clk) begin
        if (rst)
            apb3_prdata <= '0;
        else if (apb3_s.psel & !apb3_s.penable & !apb3_s.pwrite)
            case (apb3_s.paddr.word_addr)
                MAGIC_ID_ADDR.word_addr:    apb3_prdata <= MAGIC_ID_VAL;
                COUNTER_ADDR.word_addr:     apb3_prdata <= counter;
                RDWR_REG_ADDR.word_addr:    apb3_prdata <= rdwr_reg;
                default:                    apb3_prdata <= '0;
            endcase
        else
            apb3_prdata <= apb3_prdata;
    end
    assign apb3_s.prdata = apb3_prdata;

endmodule: user_system