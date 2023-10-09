/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_DRV_NODE__SV
`define SVK_CLK_DRV_NODE__SV

class svk_clk_drv_node extends svk_clk_node;
    `uvm_component_utils(svk_clk_drv_node)

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_clk(output real period, output real duty_ratio);
        period      = cfg.ci.period;
        duty_ratio  = cfg.ci.duty_ratio;
        `uvm_info("get_expe_clk", $sformatf("%s:period=%0f, duty_ratio=%0f",get_name(), period, duty_ratio), UVM_HIGH)
    endtask

    function svk_clk_node get_pre_node();
        `uvm_error("get_pre_node", "should not call this function")
        return null;
    endfunction

endclass



`endif