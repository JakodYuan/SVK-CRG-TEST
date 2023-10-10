/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_RST_CFG_NODE__SV
`define SVK_RST_CFG_NODE__SV

class svk_rst_cfg_node extends svk_rst_node;
    `uvm_component_utils(svk_rst_cfg_node)

    function new(string name="svk_rst_cfg_node", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_rst(output logic rst);
        logic           pre_rst;
        bit             cfg_rst;
        uvm_status_e    status;

        if(cfg.reg_fields.exists("cfg"))begin
            cfg.reg_fields["cfg"].read(status, cfg_rst);
        end
        else begin
            uvm_hdl_read(cfg.hdl_paths["cfg"], cfg_rst);
        end
        
        cfg.pre_nodes[0].get_expe_rst(pre_rst);

        rst = pre_rst & cfg_rst;

        `uvm_info("get_expe_rst", $sformatf("%s: cfg_rst=%0b, rst=%0b",get_name(),  cfg_rst, rst), UVM_NONE)
    endtask

endclass


`endif
