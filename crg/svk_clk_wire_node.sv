/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_WIRE_NODE__SV
`define SVK_CLK_WIRE_NODE__SV

class svk_clk_wire_node extends svk_clk_node;
    `uvm_component_utils(svk_clk_wire_node)

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_clk(output real period, output real duty_ratio);
        cfg.pre_nodes[0].get_expe_clk(period, duty_ratio);
        `uvm_info("get_expe_clk", $sformatf("%s:period=%0f, duty_ratio=%0f",get_name(),  period, duty_ratio), UVM_HIGH)
    endtask

endclass

`endif