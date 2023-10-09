/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_RST_SEL_NODE__SV
`define SVK_RST_SEL_NODE__SV

class svk_rst_sel_node extends svk_rst_node;
    `uvm_component_utils(svk_rst_sel_node)

    function new(string name="svk_rst_sel_node", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_rst(output sel rst);
        bit             sel;

        if(cfg.reg_fields.exists("sel"))
            sel = cfg.reg_fields["sel"].get();
        else
            uvm_hdl_read(cfg.hdl_paths["sel"], sel);

        if(sel == 0)begin
            cfg.pre_nodes[0].get_expe_rst(rst);
        end
        else begin
            cfg.pre_nodes[1].get_expe_rst(rst);
        end
        `uvm_info("get_expe_rst", $sformatf("%s: rst=%0b",get_name(),  rst), UVM_HIGH)
    endtask

endclass


`endif
