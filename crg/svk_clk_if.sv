/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_IF__SV
`define SVK_CLK_IF__SV







interface svk_clk_if(
    inout           clk,
    input string    clk_hire
);
    
    real      period     = 5;
    real      duty_ratio = 0.5;
    real      jetter     = 0.01;
    real      ppm        = 1;
    real      offset     = -1; 

    bit       stop_clk;
    bit       stop_complete;

    import uvm_pkg::*;

    task undrive();
        stop_clk = 1;
        wait(stop_complete);
        stop_complete = 0;
    endtask

    task drive();
        automatic real    ppm_time;
        automatic real    jetter_time;
        automatic real    period_h;
        automatic real    period_l;
        automatic real    PERIOD_H;
        automatic real    PERIOD_L;
        process           proc;

        proc = process::self();
        proc.srandom(uvm_create_random_seed("svk_clk", clk_hire));

        if(offset == -1)
            offset = $urandom_range(0,100) * 0.1;

        
        #(offset);

        while(1)begin

            if(period <= 0 || period > 10000000)
                `uvm_fatal("svk_clk_if", $sformatf("%s: period  is error period=%0f", clk_hire, period))

            if(duty_ratio >= 1 || duty_ratio <= 0)begin
                `uvm_fatal("svk_clk_if", $sformatf("%s: duty_ratio is error! duty_ratio=%0f", clk_hire, duty_ratio))
            end
            if(jetter >= 1 || jetter <= 0)begin
                `uvm_fatal("svk_clk_if", $sformatf("%s: jetter is error! jetter=%0f", clk_hire, jetter))
            end

            period_h    = period * duty_ratio;
            period_l    = period - period_h;
            ppm_time    = (period_h + period_l) * ppm / 1000_000 / 2;
            jetter_time = (period_h + period_l) * jetter / 4.0;



            force clk = 0;
            PERIOD_L = period_l + ppm_time + jetter_time;
            #(PERIOD_L);

            if(stop_clk)begin
                stop_complete = 1;
                stop_clk = 0;
                `uvm_info("svk_clk_if", $sformatf("%s, clk stoped!", clk_hire), UVM_NONE)
                release clk;
                break;
            end

            force clk = 1;
            PERIOD_H = period_h + ppm_time + jetter_time;
            #(PERIOD_H);

            force clk = 0;
            PERIOD_L = period_l + ppm_time - jetter_time;
            #(PERIOD_L);

            force clk = 1;
            PERIOD_H = period_h + ppm_time - jetter_time;
            #(PERIOD_H);
        end
    endtask

endinterface

`endif