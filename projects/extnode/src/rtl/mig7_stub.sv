/*
    // Simple stub to drive a MIG7 instance
    mig7_stub the_mig7_stub
    (
        // Reset and clock
        .rst                    (), // i
        .clk                    (), // i

        // MIG local interface
        .app_addr               (), // o  [27 : 0]
        .app_cmd                (), // o  [2 : 0]
        .app_en                 (), // o
        .app_wdf_data           (), // o  [127 : 0]
        .app_wdf_end            (), // o
        .app_wdf_mask           (), // o  [15 : 0]
        .app_wdf_wren           (), // o
        .app_rd_data            (), // i  [127 : 0]
        .app_rd_data_end        (), // i
        .app_rd_data_valid      (), // i
        .app_rdy                (), // i
        .app_wdf_rdy            (), // i
        .app_sr_req             (), // o
        .app_ref_req            (), // o
        .app_zq_req             (), // o
        .app_sr_active          (), // i
        .app_ref_ack            (), // i
        .app_zq_ack             (), // i

        // Calibration status
        .init_calib_complete    ()  // i
    ); // the_mig7_stub
*/


module mig7_stub
(
    // Reset and clock
    input  logic            rst,
    input  logic            clk,

    // MIG local interface
    output logic [27 : 0]   app_addr,
    output logic [2 : 0]    app_cmd,
    output logic            app_en,
    output logic [127 : 0]  app_wdf_data,
    output logic            app_wdf_end,
    output logic [15 : 0]   app_wdf_mask,
    output logic            app_wdf_wren,
    input  logic [127 : 0]  app_rd_data,
    input  logic            app_rd_data_end,
    input  logic            app_rd_data_valid,
    input  logic            app_rdy,
    input  logic            app_wdf_rdy,
    output logic            app_sr_req,
    output logic            app_ref_req,
    output logic            app_zq_req,
    input  logic            app_sr_active,
    input  logic            app_ref_ack,
    input  logic            app_zq_ack,

    // Calibration status
    input  logic            init_calib_complete
);
    // Constants
    localparam logic [2 : 0]    CMD_WRITE   = 3'b000;
    localparam logic [2 : 0]    CMD_READ    = 3'b001;


    // FSM encoding
    enum int unsigned {
        IDLE,
        WRITE,
        WRITE_DONE,
        READ,
        READ_DONE,
        PARK
    } state;


    // Variables
    logic [127 : 0] data_to_write           = {32'hcafebabe, 32'h12345678, 32'hAA55AA55, 32'h55AA55AA};
    logic [127 : 0] data_read_from_memory   = 128'd0;


    always @ (posedge clk) begin
        if (rst) begin
            state <= IDLE;
            app_en <= 0;
            app_wdf_wren <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (init_calib_complete) begin
                        state <= WRITE;
                    end
                end

                WRITE: begin
                    if (app_rdy & app_wdf_rdy) begin
                        state <= WRITE_DONE;
                        app_en <= 1;
                        app_wdf_wren <= 1;
                        app_addr <= 0;
                        app_cmd <= CMD_WRITE;
                        app_wdf_data <= data_to_write;
                    end
                end

                WRITE_DONE: begin
                    if (app_rdy & app_en) begin
                        app_en <= 0;
                    end

                    if (app_wdf_rdy & app_wdf_wren) begin
                        app_wdf_wren <= 0;
                    end

                    if (~app_en & ~app_wdf_wren) begin
                        state <= READ;
                    end
                end

                READ: begin
                    if (app_rdy) begin
                        app_en <= 1;
                        app_addr <= 0;
                        app_cmd <= CMD_READ;
                        state <= READ_DONE;
                    end
                end

                READ_DONE: begin
                    if (app_rdy & app_en) begin
                        app_en <= 0;
                    end

                    if (app_rd_data_valid) begin
                        data_read_from_memory <= app_rd_data;
                        state <= PARK;
                    end
                end

                PARK: begin
                    state <= PARK;
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end


    // Constant signals
    assign app_wdf_end  = '1;
    assign app_wdf_mask = '0;
    assign app_sr_req   = '0;
    assign app_ref_req  = '0;
    assign app_zq_req   = '0;


endmodule: mig7_stub