/*
    // Handles the stream going to an Aurora IP in the event
    // of a link failure
    aurora_tx_guard #(
        .DATA_W             (), // AXI-S data bus width
        .KEEP_W             ()  // AXI-S keep bus width
    )
    the_aurora_tx_guard (
        // Reset and clock
        .rst                (), // i
        .clk                (), // i

        // Link status
        .channel_up         (), // i

        // Loss detection
        .loss_data          (), // i
        .loss_frame         (), // i

        // TX AXI stream coming in from the TX FIFO
        .i_tx_tdata         (), // i  [DATA_W - 1 : 0]
        .i_tx_tkeep         (), // i  [KEEP_W - 1 : 0]
        .i_tx_tvalid        (), // i
        .i_tx_tlast         (), // i
        .i_tx_tready        (), // o

        // TX AXI stream going out to an Aurora IP
        .o_tx_tdata         (), // o  [DATA_W - 1 : 0]
        .o_tx_tkeep         (), // o  [KEEP_W - 1 : 0]
        .o_tx_tvalid        (), // o
        .o_tx_tlast         (), // o
        .o_tx_tready        ()  // i
    ); // the_aurora_tx_guard
*/


module aurora_tx_guard
#(
    parameter int unsigned          DATA_W  = 8,            // AXI-S data bus width
    parameter int unsigned          KEEP_W  = DATA_W / 8    // AXI-S keep bus width
)
(
    // Reset and clock
    input  logic                    rst,
    input  logic                    clk,

    // Link status
    input  logic                    channel_up,

    // Loss detection
    output logic                    loss_data,
    output logic                    loss_frame,

    // TX AXI stream coming in from the TX FIFO
    input  logic [DATA_W - 1 : 0]   i_tx_tdata,
    input  logic [KEEP_W - 1 : 0]   i_tx_tkeep,
    input  logic                    i_tx_tvalid,
    input  logic                    i_tx_tlast,
    output logic                    i_tx_tready,

    // TX AXI stream going out to an Aurora IP
    output logic [DATA_W - 1 : 0]   o_tx_tdata,
    output logic [KEEP_W - 1 : 0]   o_tx_tkeep,
    output logic                    o_tx_tvalid,
    output logic                    o_tx_tlast,
    input  logic                    o_tx_tready
);
    // Variables
    logic   removal_wip = 1'b0;


    // Indicates that a frame is being removed
    initial removal_wip = 1'b0;
    always @(posedge rst, posedge clk) begin
        if (rst)
            removal_wip <= 1'b0;
        else if (removal_wip)
            removal_wip <= !(i_tx_tvalid & i_tx_tlast);
        else
            removal_wip <= !channel_up & i_tx_tvalid & !i_tx_tlast;
    end


    // Pass through some AXI signals
    assign o_tx_tdata = i_tx_tdata;
    assign o_tx_tkeep = i_tx_tkeep;
    assign o_tx_tlast = i_tx_tlast;


    // Drop incoming frames when there is no link
    assign i_tx_tready = (channel_up & !removal_wip) ? o_tx_tready : 1'b1;
    assign o_tx_tvalid = (channel_up & !removal_wip) ? i_tx_tvalid : 1'b0;


    // Data loss detection
    initial {loss_data, loss_frame} = '0;
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            loss_data <= 1'b0;
            loss_frame <= 1'b0;
        end
        else begin
            loss_data <= i_tx_tvalid & (!channel_up | removal_wip);
            loss_frame <= i_tx_tvalid & (!channel_up | removal_wip) & i_tx_tlast;
        end
    end

endmodule: aurora_tx_guard