/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_RST_DRV_NODE__SV
`define SVK_RST_DRV_NODE__SV

class svk_rst_drv_node extends svk_rst_node;
    `uvm_component_utils(svk_rst_drv_node)

    function new(string name="svk_rst_drv_node", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_rst(output logic rst);
        rst = cfg.ri.rst;
        `uvm_info("get_expe_rst", $sformatf("%s: rst=%0b",get_name(),  rst), UVM_NONE)
    endtask

endclass


`endif
