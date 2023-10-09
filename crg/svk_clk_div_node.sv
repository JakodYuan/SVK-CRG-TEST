/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_DIV_NODE__SV
`define SVK_CLK_DIV_NODE__SV

class svk_clk_div_node extends svk_clk_node;
    `uvm_component_utils(svk_clk_div_node)

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_clk(output real period, output real duty_ratio);
        real pre_duty_ratio;
        real pre_period;

        int div;

        if(cfg.reg_fields.exists("div"))
            div = cfg.reg_fields["div"].get();
        else
            uvm_hdl_read(cfg.hdl_paths["div"], div);

        cfg.pre_nodes[0].get_expe_clk(pre_period, pre_duty_ratio);

        period     = pre_period * (div + 1);






        duty_ratio = 0.5;
        if(period == 0)
            duty_ratio = 0;

        `uvm_info("get_expe_clk", $sformatf("%s:div=%0d period=%0f, duty_ratio=%0f",get_name(), div, period, duty_ratio), UVM_HIGH)
    endtask

endclass


`endif