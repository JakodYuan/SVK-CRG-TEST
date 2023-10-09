/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_SEL_NODE__SV
`define SVK_CLK_SEL_NODE__SV

class svk_clk_sel_node extends svk_clk_node;
    `uvm_component_utils(svk_clk_sel_node)

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_clk(output real period, output real duty_ratio);
        bit sel;

        if(cfg.reg_fields.exists("sel"))
            sel = cfg.reg_fields["sel"].get();
        else
            uvm_hdl_read(cfg.hdl_paths["sel"], sel);

        if(sel == 0)begin
            cfg.pre_nodes[0].get_expe_clk(period, duty_ratio);
        end
        else begin
            cfg.pre_nodes[1].get_expe_clk(period, duty_ratio);
        end

        `uvm_info("get_expe_clk", $sformatf("%s:sel=%0b, period=%0f, duty_ratio=%0f",get_name(), sel, period, duty_ratio), UVM_HIGH)
    endtask

    function svk_clk_node get_pre_node();
        int sel;

        if(cfg.reg_fields.exists("sel"))
            sel = cfg.reg_fields["sel"].get();
        else
            uvm_hdl_read(cfg.hdl_paths["sel"], sel);

        if(sel == 0)
            return cfg.pre_nodes[0];
        else
            return cfg.pre_nodes[1];

    endfunction

endclass


`endif
