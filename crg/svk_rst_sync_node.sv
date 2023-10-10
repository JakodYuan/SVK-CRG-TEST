/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_RST_SYNC_NODE__SV
`define SVK_RST_SYNC_NODE__SV

class svk_rst_sync_node extends svk_rst_node;
    `uvm_component_utils(svk_rst_sync_node)

    function new(string name="svk_rst_sync_node", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_rst(output logic rst);
        cfg.pre_nodes[0].get_expe_rst(rst);
        `uvm_info("get_expe_rst", $sformatf("%s: rst=%0b",get_name(),  rst), UVM_NONE)
    endtask

endclass


`endif
