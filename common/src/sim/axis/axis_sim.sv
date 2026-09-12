// AXIS simulation unilities
package axis_sim;

    // Set the AXIS master to the idle state
    task automatic axis_master_idle_set(virtual axis_if.master axis_m);
        axis_m.tdata = '0;
        axis_m.tkeep = '0;
        axis_m.tvalid = '0;
        axis_m.tlast = '0;
    endtask


    // Enable or disable AXIS transfer at the slave
    task automatic axis_slave_ready_set(virtual axis_if.slave axis_s, input logic ready);
        axis_s.tready = ready;
    endtask


    // Waits for a packet to come in
    task automatic axis_packet_wait(virtual axis_if axis, ref logic clk);
        do begin
            @(posedge clk);
        end while (!(axis.tvalid & axis.tready & axis.tlast));
    endtask

endpackage:  axis_sim