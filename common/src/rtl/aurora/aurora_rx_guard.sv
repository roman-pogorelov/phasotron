/*
    // Handles the stream coming from an Aurora IP in the event
    // of a link failure or an overflow condition
    aurora_rx_guard #(
        .DATA_W             (), // AXI-S data bus width
        .KEEP_W             ()  // AXI-S keep bus width
    )
    the_aurora_rx_guard (
        // Reset and clock
        .rst                (), // i
        .clk                (), // i

        // Link status
        .channel_up         (), // i

        // FIFO status
        .fifo_ready         (), // i
        .fifo_below_lwm     (), // i
        .fifo_above_hwm     (), // i

        // Loss detection
        .loss_data          (), // i
        .loss_frame         (), // i

        // RX AXI stream coming in from an Aurora IP
        .i_rx_tdata         (), // i  [DATA_W - 1 : 0]
        .i_rx_tkeep         (), // i  [KEEP_W - 1 : 0]
        .i_rx_tvalid        (), // i
        .i_rx_tlast         (), // i

        // RX AXI stream going out
        .o_rx_tdata         (), // o  [DATA_W - 1 : 0]
        .o_rx_tkeep         (), // o  [KEEP_W - 1 : 0]
        .o_rx_tvalid        (), // o
        .o_rx_tlast         ()  // o
    ); // the_aurora_rx_guard
*/


module aurora_rx_guard
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

    // FIFO status
    input  logic                    fifo_ready,
    input  logic                    fifo_below_lwm,
    input  logic                    fifo_above_hwm,

    // Loss detection
    output logic                    loss_data,
    output logic                    loss_frame,

    // RX AXI stream coming in from an Aurora IP
    input  logic [DATA_W - 1 : 0]   i_rx_tdata,
    input  logic [KEEP_W - 1 : 0]   i_rx_tkeep,
    input  logic                    i_rx_tvalid,
    input  logic                    i_rx_tlast,

    // RX AXI stream going out
    output logic [DATA_W - 1 : 0]   o_rx_tdata,
    output logic [KEEP_W - 1 : 0]   o_rx_tkeep,
    output logic                    o_rx_tvalid,
    output logic                    o_rx_tlast
);
    // Types
    typedef enum int unsigned {
        st_wait_fifo_ready,
        st_wait_channel_up,
        st_wait_frame_start,
        st_forward,
        st_wait_fifo_room
    } fsm_t;


    // Variables
    logic                   i_rx_tfirst = 1'b1;
    //
    logic                   buf_capture;
    logic [DATA_W - 1 : 0]  buf_tdata = '0;
    logic [KEEP_W - 1 : 0]  buf_tkeep = '0;
    logic                   buf_tlast = '0;
    //
    fsm_t                   cstate = st_wait_fifo_ready;
    fsm_t                   nstate;


    // Indicates the first word of the frame coming in from an Aurora IP
    always @(posedge rst, posedge clk) begin
        if (rst)
            i_rx_tfirst <= 1'b1;
        else if (channel_up)
            if (i_rx_tvalid)
                i_rx_tfirst <= i_rx_tlast;
            else
                i_rx_tfirst <= i_rx_tfirst;
        else
            i_rx_tfirst <= 1'b1;
    end


    // Capture the stream coming in from an Aurora IP
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            buf_tdata <= '0;
            buf_tkeep <= '0;
            buf_tlast <= '0;
        end
        else if (buf_capture) begin
            buf_tdata <= i_rx_tdata;
            buf_tkeep <= i_rx_tkeep;
            buf_tlast <= i_rx_tlast;
        end
        else begin
            buf_tdata <= buf_tdata;
            buf_tkeep <= buf_tkeep;
            buf_tlast <= buf_tlast;
        end
    end
    assign o_rx_tdata = buf_tdata;
    assign o_rx_tkeep = buf_tkeep;


    // FSM state register
    always @(posedge rst, posedge clk) begin
        if (rst)
            cstate <= st_wait_fifo_ready;
        else
            cstate <= nstate;
    end


    // FSM transition logic
    always_comb begin

        // Defaults
        buf_capture = 1'b0;
        o_rx_tvalid = 1'b0;
        o_rx_tlast = 1'b0;

        // State-dependent logic
        case (cstate)
            st_wait_fifo_ready: begin
                if (fifo_ready) begin
                    nstate = st_wait_channel_up;
                end
                else begin
                    nstate = st_wait_fifo_ready;
                end
            end

            st_wait_channel_up: begin
                if (channel_up) begin
                    buf_capture = i_rx_tvalid & i_rx_tfirst;
                    if (i_rx_tvalid & i_rx_tfirst) begin
                        nstate = st_forward;
                    end
                    else begin
                        nstate = st_wait_frame_start;
                    end
                end
                else begin
                    nstate = st_wait_channel_up;
                end
            end

            st_wait_frame_start: begin
                if (channel_up) begin
                    buf_capture = i_rx_tvalid & i_rx_tfirst;
                    if (i_rx_tvalid & i_rx_tfirst) begin
                        nstate = st_forward;
                    end
                    else begin
                        nstate = st_wait_frame_start;
                    end
                end
                else begin
                    nstate = st_wait_channel_up;
                end
            end

            st_forward: begin
                if (channel_up) begin
                    if (fifo_above_hwm) begin
                        o_rx_tvalid = 1'b1;
                        o_rx_tlast = 1'b1;
                        nstate = st_wait_fifo_room;
                    end
                    else begin
                        buf_capture = i_rx_tvalid;
                        o_rx_tlast = buf_tlast;
                        if (!i_rx_tvalid & buf_tlast) begin
                            o_rx_tvalid = 1'b1;
                            nstate = st_wait_frame_start;
                        end
                        else begin
                            o_rx_tvalid = i_rx_tvalid;
                            nstate = st_forward;
                        end
                    end
                end
                else begin
                    o_rx_tvalid = 1'b1;
                    o_rx_tlast = 1'b1;
                    nstate = st_wait_channel_up;
                end
            end

            st_wait_fifo_room: begin
                if (fifo_below_lwm) begin
                    if (channel_up) begin
                        buf_capture = i_rx_tvalid & i_rx_tfirst;
                        if (i_rx_tvalid & i_rx_tfirst) begin
                            nstate = st_forward;
                        end
                        else begin
                            nstate = st_wait_frame_start;
                        end
                    end
                    else begin
                        nstate = st_wait_channel_up;
                    end
                end
                else begin
                    nstate = st_wait_fifo_room;
                end
            end

            default: begin
                nstate = st_wait_fifo_ready;
            end
        endcase // cstate
    end


    // Data loss detection
    initial {loss_data, loss_frame} = '0;
    always @(posedge rst, posedge clk) begin
        if (rst) begin
            loss_data <= 1'b0;
            loss_frame <= 1'b0;
        end
        else begin
            loss_data <= i_rx_tvalid & !buf_capture;
            loss_frame <= i_rx_tvalid & i_rx_tlast & !buf_capture;
        end
    end

endmodule: aurora_rx_guard