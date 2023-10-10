/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_PLL_NODE__SV
`define SVK_CLK_PLL_NODE__SV

class svk_clk_pll_node extends svk_clk_node;
    `uvm_component_utils(svk_clk_pll_node)

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_clk(output real period, output real duty_ratio);
        int     values[string] = '{"lock":0, "dsmen":0, "frac":0, "refdiv":0, "fbdiv":0, "postdiv1":0, "postdiv2":0};

        

        real    pre_period;
        real    pre_duty_ratio;
        uvm_status_e  status;
        int     rdata;

        foreach(values[i])begin
            if(cfg.reg_fields.exists(i))
                cfg.reg_fields[i].read(status, values[i]);
            else
                uvm_hdl_read(cfg.hdl_paths[i], values[i]);
        end


        if(values["lock"] == 1)begin
            cfg.pre_nodes[0].get_expe_clk(pre_period, pre_duty_ratio);
            if(values["dsmen"] == 1'b1)begin
                period = pre_period * values["refdiv"] / (values["fbdiv"] + values["frac"] / 2**24);
            end
            else begin
                period = pre_period * values["refdiv"] / values["fbdiv"];
            end
            if(pre_period != 0)
                duty_ratio = 0.5;
            else
                duty_ratio = 0;
        end
        else begin
            `uvm_error("get_expe_clk", $sformatf("%s not lock", cfg.ci.clk_hire))
        end

        `uvm_info("get_expe_clk", $sformatf("%s:refdiv=%0d, fbdiv=%0d, frac=%0f period=%0f, duty_ratio=%0f",get_name(), values["refdiv"], values["fbdiv"], values["frac"]/real'(2**24), period, duty_ratio), UVM_HIGH)
    endtask

endclass


`endif