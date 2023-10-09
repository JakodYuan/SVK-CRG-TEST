/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_INTERFACE__SV
`define SVK_CLK_INTERFACE__SV

`timescale 1ns/1ps
interface svk_clk_interface(
    inout           clk,
    input string    clk_hire
);
    import uvm_pkg::*;

    real    period;
    real    duty_ratio;
    real    jetter;
    int     ppm;

    real    ppm_time;
    real    jetter_time;
    real    period_h;
    real    period_l;
    real    PERIOD_H;
    real    PERIOD_L;
    bit     close_clk;
    bit     close_complete;
    bit     glitch_check_en;


    function void set_cfg(real _period, real _duty_ratio=0.5, real _jetter=0, int _ppm=0);
        string log;

        period     = _period;
        duty_ratio = _duty_ratio;
        jetter     = _jetter;
        ppm        = _ppm;

        log = $sformatf("%s:\nperiod=%0.2fns", clk_hire, period);
        log = $sformatf("%s, duty_ratio=%0.2f%%", log, duty_ratio*100);
        log = $sformatf("%s, jetter=%0.2f%%", log, jetter*100);
        log = $sformatf("%s, ppm=%0.2d\n", log, ppm);

        `uvm_info("svk_clk_interface", log, UVM_NONE)
    endfunction

    task get_period_ratio(ref real _period, ref real _duty_ratio);
        string    log;
        parameter MEAN_CYCLE_NUM = 10;
        automatic real all_h_time;
        automatic real all_l_time;
        automatic real real_period_h;
        automatic real real_period_l;
        automatic real real_period;
        automatic real real_ratio;
        automatic real t1;
        automatic real t2;

        @(negedge clk);
        t2 = $realtime();
        repeat(MEAN_CYCLE_NUM)begin
            @(posedge clk);
            t1 = $realtime();
            all_l_time += t1 - t2;
            @(negedge clk);
            t2 = $realtime();
            all_h_time += t2 - t1;
        end

        real_period_l = all_l_time / MEAN_CYCLE_NUM;
        real_period_h = all_h_time / MEAN_CYCLE_NUM;
        real_period   = real_period_h + real_period_l;
        real_ratio    = real_period_h / real_period;

        log = $sformatf("%s:\nall_h_time=%0.2fns", clk_hire, all_h_time);
        log = $sformatf("%s, all_l_time=%0.2fns", log, all_l_time);
        log = $sformatf("%s, real_period_h=%0.2fns", log, real_period_h);
        log = $sformatf("%s, real_period_l=%0.2dns", log, real_period_l);
        log = $sformatf("%s, real_period=%0.2fns", log, real_period);
        log = $sformatf("%s, real_ratio=%0.2f\n", log, real_ratio);

        `uvm_info("svk_clk_interface", log, UVM_HIGH)

        _period     = real_period;
        _duty_ratio = real_ratio;
    endtask

    task check(real _period, real _duty_ratio, real _jetter, int _ppm);
        string         log;
        automatic real real_period;
        automatic real real_ratio;
        automatic real jetter_time;
        automatic real ppm_time;
        automatic real exp_period_l;
        automatic real exp_period_h;
        automatic real exp_duty_ratio_l;
        automatic real exp_duty_ratio_h;

        set_cfg(_period, _duty_ratio, _jetter, _ppm);

        get_period_ratio(real_period, real_ratio);

        ppm_time    = period * ppm / 1000_000;
        jetter_time = period * jetter / 2.0;

        exp_period_l = period - jetter_time + ppm_time;
        exp_period_h = period + jetter_time + ppm_time;

        exp_duty_ratio_l = duty_ratio - jetter;
        exp_duty_ratio_h = duty_ratio + jetter;


        if(real_ratio < exp_duty_ratio_l || real_ratio > exp_duty_ratio_h)begin
            log = $sformatf("%s:duty ratio %0.2f no  in", clk_hire, real_ratio);
            log = $sformatf("%s [%0.2f:%0.2f]", log, exp_duty_ratio_l, exp_duty_ratio_h);
            `uvm_error("check_clk", log);
        end

        if(real_period < exp_period_l || real_period > exp_period_h)begin
            log = $sformatf("%s:period %0.2f no  in", clk_hire, real_period);
            log = $sformatf("%s [%0.2f:%0.2f]", log, exp_period_l, exp_period_h);
            `uvm_error("check_clk", log);
        end

    endtask


    task check_glitch(real period_th);
        automatic realtime t1;
        automatic realtime t2;

        fork
            begin
                glitch_check_en = 1;
                @(posedge clk);
                t1 = $realtime();
                while(1)begin
                    if(glitch_check_en == 0)
                        break;

                    @(negedge clk);
                    t2 = $realtime();
                    if(t2 - t1 < period_th)begin
                        `uvm_error("check_glitch", $sformatf("%s:has high glitch: period=%0.2f < %0.2f", clk_hire, t2-t1, period_th))
                    end
                    @(posedge clk);
                    t1 = $realtime();
                    if(t1 - t2 < period_th)begin
                        `uvm_error("check_glitch", $sformatf("%s:has low glitch: period=%0.2f < %0.2f", clk_hire, t1-t2, period_th))
                    end
                end
            end
        join_none
    endtask


    task stop_check_glitch();
        glitch_check_en = 0;
    endtask


    task is_closed(real _period, ref bit is_close);
        fork
            begin
                @(2*_period);
                is_close = 1;
            end
            begin
                @(clk);
                is_close = 0;
            end
        join_any
        disable fork;
    endtask

    task close();
        close_clk = 1;
        wait(close_complete);
        close_complete = 0;
    endtask

    task run();
        while(1)begin

            if(period == 0)begin
                `uvm_fatal("svk_clk_interface", $sformatf("%s: period is error! period=%0f",clk_hire, period))
            end
            if(duty_ratio >= 1)begin
                `uvm_fatal("svk_clk_interface", $sformatf("%s: duty_ratio is error! duty_ratio=%0f", clk_hire, duty_ratio))
            end
            if(jetter >= 1)begin
                `uvm_fatal("svk_clk_interface", $sformatf("%s: jetter is error! jetter=%0f", clk_hire, jetter))
            end

            period_h    = period * duty_ratio;
            period_l    = period - period_h;
            ppm_time    = (period_h + period_l) * ppm / 1000_000 / 2;
            jetter_time = (period_h + period_l) * jetter / 4.0;



            force clk = 0;
            PERIOD_L = period_l + ppm_time + jetter_time;
            #(PERIOD_L);

            if(close_clk)begin
                close_complete = 1;
                close_clk = 0;
                `uvm_info("svk_clk_interface", $sformatf("%m, clock closed!"), UVM_NONE)
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