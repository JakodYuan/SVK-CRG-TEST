/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_NODE__SV
`define SVK_CLK_NODE__SV

virtual class svk_clk_node extends uvm_component;

    svk_clk_node_cfg       cfg;

    extern function new(string name="svk_clk_node", uvm_component parent=null);
    pure virtual task get_expe_clk(output real period, output real duty_ratio);
    extern virtual task get_real_clk(output real period, output real duty_ratio, input int time_out_time=1000, input int MEAN_CYCLE_NUM=1);
    extern task check_clk();
    extern task check_glitch();
    extern task set_next_freq(input real freq=-1);
    extern task run_phase(uvm_phase phase);
    extern virtual function svk_clk_node get_pre_node();

endclass

function svk_clk_node::new(string name="svk_clk_node", uvm_component parent);
    super.new(name, parent);

    cfg = new();
endfunction


task svk_clk_node::get_real_clk(output real period, output real duty_ratio, input int time_out_time=1000, input int MEAN_CYCLE_NUM=1);
    string          log;
    real            all_h_time;
    real            all_l_time;
    real            period_h;
    real            period_l;
    real            t1;
    real            t2;

    fork
        fork
            begin
                @(negedge cfg.ci.clk);
                t2 = $realtime();
                repeat(MEAN_CYCLE_NUM)begin
                    @(posedge cfg.ci.clk);
                    t1 = $realtime();
                    all_l_time += t1 - t2;
                    @(negedge cfg.ci.clk);
                    t2 = $realtime();
                    all_h_time += t2 - t1;
                end

                period_l    = all_l_time / MEAN_CYCLE_NUM;
                period_h    = all_h_time / MEAN_CYCLE_NUM;
                period      = period_h + period_l;
                duty_ratio  = period_h / period;
            end
            begin
                #time_out_time;
                period     = 0;
                duty_ratio = 0;
            end
        join_any
        disable fork;
    join


    log = $sformatf("%s:\nall_h_time=%0.2fns", cfg.ci.clk_hire, all_h_time);
    log = $sformatf("%s, all_l_time=%0.2fns", log, all_l_time);
    log = $sformatf("%s, period_h=%0.2fns", log, period_h);
    log = $sformatf("%s, period_l=%0.2dns", log, period_l);
    log = $sformatf("%s, period=%0.2fns", log, period);
    log = $sformatf("%s, ratio=%0.2f\n", log, duty_ratio);

    `uvm_info("svk_clk_interface", log, UVM_HIGH)

endtask

task svk_clk_node::check_clk();
    string         log;
    real real_period;
    real expe_period;
    real real_duty_ratio;
    real expe_duty_ratio;

    real jetter_time;
    real ppm_time;

    real expe_period_l;
    real expe_period_h;
    real expe_duty_ratio_l;
    real expe_duty_ratio_h;

    get_expe_clk(expe_period, expe_duty_ratio);
    get_real_clk(real_period, real_duty_ratio);

    ppm_time    = expe_period * cfg.ppm / 1000_000;
    jetter_time = expe_period * cfg.jetter / 2.0;

    expe_period_l = expe_period - jetter_time + ppm_time;
    expe_period_h = expe_period + jetter_time + ppm_time;

    expe_duty_ratio_l = expe_duty_ratio - cfg.jetter;
    expe_duty_ratio_h = expe_duty_ratio + cfg.jetter;


    if(real_period < expe_period_l || real_period > expe_period_h)begin
        log = $sformatf("%s:period %0.2f not in", cfg.ci.clk_hire, real_period);
        log = $sformatf("%s [%0.2f:%0.2f]", log, expe_period_l, expe_period_h);
        `uvm_error("check_clk", log);
        return;
    end

    if(real_duty_ratio < expe_duty_ratio_l || real_duty_ratio > expe_duty_ratio_h)begin
        log = $sformatf("%s:duty ratio %0.2f not in", cfg.ci.clk_hire, real_duty_ratio);
        log = $sformatf("%s [%0.2f:%0.2f]", log, expe_duty_ratio_l, expe_duty_ratio_h);
        `uvm_error("check_clk", log);
    end


endtask

task svk_clk_node::check_glitch();
    real jetter_time;
    real ppm_time;

    real period_h;
    real period_l;
    real pre_period_h;
    real pre_period_l;
    real pre_pre_period_h;
    real pre_pre_period_l;

    real t1;
    real t2;

    real pre_period_h_min;
    real pre_period_h_max;
    real pre_period_l_min;
    real pre_period_l_max;

    bit pre_h_ok;
    bit pre_l_ok;

    @(posedge cfg.ci.clk);
    @(negedge cfg.ci.clk);
    t1 = $realtime(); 
    @(posedge cfg.ci.clk);
    t2 = $realtime();
    pre_pre_period_l = t2 - t1;
    @(negedge cfg.ci.clk);
    t1 = $realtime(); 
    pre_pre_period_h = t1 - t2;
    @(posedge cfg.ci.clk);
    t2 = $realtime();
    pre_period_l = t2 - t1;
    @(negedge cfg.ci.clk);
    t1 = $realtime(); 
    pre_period_h = t1 - t2;

    while(1)begin
        @(posedge cfg.ci.clk);
        t2 = $realtime();
        period_l = t2 - t1;
        @(negedge cfg.ci.clk);
        t1 = $realtime(); 
        period_h = t1 - t2;

        ppm_time    = (period_l + period_h) * cfg.ppm / 1000_000;
        jetter_time = (period_l + period_h) * cfg.jetter / 2.0;

        pre_period_l_min = pre_period_l - jetter_time/2 + ppm_time/2;
        pre_period_l_max = pre_period_l + jetter_time/2 + ppm_time/2;
        pre_period_h_min = pre_period_h - jetter_time/2 + ppm_time/2;
        pre_period_h_max = pre_period_h + jetter_time/2 + ppm_time/2;


        pre_h_ok = 0;
        if((pre_period_h_min < pre_pre_period_h && pre_period_h_max > pre_pre_period_h) ||
           (pre_period_h_min < period_h         && pre_period_h_max > period_h))begin
            pre_h_ok = 1;
        end
        else if(pre_period_h_min > pre_pre_period_h && pre_period_h > period_h)begin
            pre_h_ok = 1;
        end


        pre_l_ok = 0;
        if((pre_period_l_min < pre_pre_period_l && pre_period_l_max > pre_pre_period_l) ||
           (pre_period_l_min < period_l         && pre_period_l_max > period_l))begin
            pre_l_ok = 1;
        end
        else if(pre_period_l_min > pre_pre_period_l && pre_period_l > period_l)begin
            pre_l_ok = 1;
        end
        

        if(!(pre_h_ok && pre_l_ok)) 
            `uvm_error("check_glitch", $sformatf("%s has glitch", cfg.ci.clk_hire))

        pre_pre_period_h = pre_period_h;
        pre_pre_period_l = pre_period_l;
        pre_period_h = period_h;
        pre_period_l = period_l;
    end
endtask

task svk_clk_node::set_next_freq(input real freq = -1);
    int idx;
    if(freq == -1)begin
        if(cfg.freqs.size == 0)
            `uvm_fatal("set_next_freq", "freqs.size == 0")
        idx = $urandom_range(0, cfg.freqs.size()-1);
        freq = cfg.freqs[idx];
    end
    else begin
        bit in_freq = 0;
        foreach(cfg.freqs[i])begin
            if(freq == cfg.freqs[i])
                in_freq = 1;
        end
        if(!in_freq)
            `uvm_fatal("set_next_freq", $sformatf("%0f not inside cfg.freqs[]", freq))
    end
    
    cfg.ci.period = 1000 / freq;
endtask


task svk_clk_node::run_phase(uvm_phase phase);

    fork
        if(cfg.is_active)begin
            set_next_freq(cfg.current_freq);
            cfg.ci.duty_ratio = cfg.duty_ratio;
            cfg.ci.jetter     = cfg.jetter;
            cfg.ci.ppm        = cfg.ppm;
            cfg.ci.drive();
        end

        if(cfg.glitch_check_en)begin
            check_glitch();
        end
    join
endtask


function svk_clk_node svk_clk_node::get_pre_node();
    return cfg.pre_nodes[0];
endfunction

`endif
