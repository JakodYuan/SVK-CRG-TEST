/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_RST_AND_NODE__SV
`define SVK_RST_AND_NODE__SV

class svk_rst_and_node extends svk_rst_node;
    `uvm_component_utils(svk_rst_and_node)

    function new(string name="svk_rst_and_node", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_rst(output and rst);
        logic           pre_rst;
        logic           tmp;
        uvm_status_e    status;

        cfg.pre_nodes[0].get_expe_rst(rst);
        for(int i=1; i<cfg.pre_nodes.size; ++i)begin
            cfg.pre_nodes[0].get_expe_rst(pre_rst);
            rst = rst & pre_rst; 
        end

        foreach(cfg.hdl_paths[i])begin
            uvm_hdl_read(cfg.hdl_paths[i], tmp);
            rst = rst & tmp;
            `uvm_info("get_exp_rst", $sformatf("hdl_paths[%s]=%0b", i, tmp), UVM_NONE)
        end
        foreach(cfg.reg_fields[i])begin
            cfg.reg_fields[i].read(status, tmp);
            rst = rst & tmp;
            `uvm_info("get_exp_rst", $sformatf("reg_fields[%s]=%0b", i, tmp), UVM_NONE)
        end
        `uvm_info("get_expe_rst", $sformatf("%s: rst=%0b",get_name(),  rst), UVM_NONE)
    endtask

endclass


`endif
