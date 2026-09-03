// APB3 simulation utilities
package apb3_sim;

    import apb3_defs::*;

    // APB3 idle set
    task automatic apb3_idle_set(virtual apb3_if.master apb3_m);
        apb3_m.paddr = 0;
        apb3_m.psel = 0;
        apb3_m.penable = 0;
        apb3_m.pwrite = 0;
        apb3_m.pwdata = 0;
    endtask


    // APB3 write
    task automatic apb3_write(virtual apb3_if.master apb3_m, ref logic clk, input apb3_addr_t addr, input apb3_data_t wdata);
        @(posedge clk);
        apb3_m.paddr = addr;
        apb3_m.psel = 1;
        apb3_m.penable = 0;
        apb3_m.pwrite = 1;
        apb3_m.pwdata = wdata;

        @(posedge clk);
        apb3_m.penable = 1;

        do begin
            @(posedge clk);
        end while (!apb3_m.pready);
        $display("APB3 WR: addr = 0x%x, data = 0x%x", addr, wdata);
        apb3_m.paddr = 0;
        apb3_m.psel = 0;
        apb3_m.penable = 0;
        apb3_m.pwrite = 0;
        apb3_m.pwdata = 0;
    endtask


    // APB3 read
    task automatic apb3_read(virtual apb3_if.master apb3_m, ref logic clk, input apb3_addr_t addr);
        @(posedge clk);
        apb3_m.paddr = addr;
        apb3_m.psel = 1;
        apb3_m.penable = 0;
        apb3_m.pwrite = 0;

        @(posedge clk);
        apb3_m.penable = 1;

        do begin
            @(posedge clk);
        end while (!apb3_m.pready);
        $display("APB3 RD: addr = 0x%x, data = 0x%x", addr, apb3_m.prdata);
        apb3_m.paddr = 0;
        apb3_m.psel = 0;
        apb3_m.penable = 0;
    endtask

endpackage: apb3_sim