/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/


`ifndef SVK_RST_INTERFACE__SV
`define SVK_RST_INTERFACE__SV

interface svk_rst_interface(
    inout           rst,
    input string    rst_hire
);

    import uvm_pkg::*;

    function void pull_up();
        force rst = 1;
    endfunction

    function void pull_down();
        force rst = 0;
    endfunction

    function void release_rst();
        release rst;
    endfunction

    task init(real pre_rst_time=0,
              real rst_time = 100);

        fork
            pull_up();
            #(pre_rst_time);
            pull_down();
            #(rst_time);
            pull_up();
            `uvm_info("rst_init", "%s:reset initial is complete!", UVM_NONE)
        join_none
    endtask

    function bit is_pull_up();
        return rst == 1;
    endfunction

    function bit is_pull_down();
        return rst == 0;
    endfunction

    task wait_pull_up();
        @(posedge rst);
        `uvm_info("wait_pull_up", $sformatf("%s pull up", rst_hire), UVM_NONE)
    endtask

    task wait_pull_down();
        @(negedge rst);
        `uvm_info("wait_pull_down", $sformatf("%s pull down", rst_hire), UVM_NONE)
    endtask


    task is_syn_with(virtual svk_clk_interface ci, output bit is_syn, real th = 0);
        realtime    pll_up_time;
        realtime    clk_edge_time;

        wait(rst==1);
        pll_up_time = $realtime();
        wait(ci.clk == 1);
        clk_edge_time = $realtime();

        if(clk_edge_time - pll_up_time < th)
            is_syn = 1;
        else
            is_syn = 0;

    endtask


endinterface
`endif
