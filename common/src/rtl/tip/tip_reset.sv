/*
    // TIP reset unit
    tip_reset the_tip_reset (
        // Free running clock input
        .init_clk   (), // i

        // User reset and clock inputs
        .user_rst   (), // i
        .user_clk   (), // i

        // Reset request input @ user_clk
        .rst_req    (), // i

        // Common reset output
        .rst_out    ()  // o
    ); // the_tip_reset
*/


module tip_reset
(
    // Free running clock input
    input  logic    init_clk,

    // User reset and clock inputs
    input   logic   user_rst,
    input   logic   user_clk,

    // Reset request input @ user_clk
    input  logic    rst_req,

    // Common reset output
    output logic    rst_out
);
    // Constants
    localparam int unsigned     CMN_RST_LEN         = 10;   // Common reset duration, in cycles
    localparam int unsigned     RST_REQ_LEN         = 16;   // Reset request duration, in cycles
    //
    localparam int unsigned     CMN_RST_CNT_W       = $clog2(CMN_RST_LEN + 1);
    localparam int unsigned     RST_REQ_CNT_W       = $clog2(RST_REQ_LEN + 1);


    // Variables
    logic [RST_REQ_CNT_W - 1 : 0]   rst_req_cnt = '0;
    logic                           rst_req_extended = '0;
    //
    logic                           rst_request;
    logic                           rst_request_d = '0;
    logic                           rst_request_fall = '0;
    //
    logic [CMN_RST_CNT_W - 1 : 0]   cmn_rst_cnt = '0;
    logic                           cmn_rst = '1;


    // Extend the reset request
    always @(posedge user_rst, posedge user_clk) begin
        if (user_rst) begin
            rst_req_cnt <= '0;
            rst_req_extended <= '0;
        end
        else if (rst_req) begin
            rst_req_cnt <= {{$size(rst_req_cnt) - 1{1'b0}}, 1'b1};
            rst_req_extended <= '1;
        end
        else if (rst_req_cnt > 0) begin
            if (rst_req_cnt != RST_REQ_LEN) begin
                rst_req_cnt <= rst_req_cnt + 1'b1;
                rst_req_extended <= '1;
            end
            else begin
                rst_req_cnt <= '0;
                rst_req_extended <= '0;
            end
        end
        else begin
            rst_req_cnt <= '0;
            rst_req_extended <= '0;
        end
    end


    // XPM single bit synchronizer
    xpm_cdc_single #(
        .DEST_SYNC_FF   (4),
        .INIT_SYNC_FF   (1),
        .SIM_ASSERT_CHK (0),
        .SRC_INPUT_REG  (0)
    )
    rst_req_sync (
        .src_clk        (user_clk),         // i
        .dest_clk       (init_clk),         // i
        .src_in         (rst_req_extended), // i
        .dest_out       (rst_request)       // o
    ); // rst_req_sync


    // Detect a falling edge of the reset request
    always @(posedge init_clk) begin
        rst_request_d <= rst_request;
        rst_request_fall <= !rst_request & rst_request_d;
    end


    // Common reset logic
    always @(posedge init_clk) begin
        if (rst_request_fall) begin
            cmn_rst_cnt <= '0;
            cmn_rst <= '1;
        end
        else if (cmn_rst_cnt != (CMN_RST_LEN - 1)) begin
            cmn_rst_cnt <= cmn_rst_cnt + 1'b1;
            cmn_rst <= '1;
        end
        else begin
            cmn_rst_cnt <= cmn_rst_cnt;
            cmn_rst <= '0;
        end
    end
    assign rst_out = cmn_rst;

endmodule: tip_reset