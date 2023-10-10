/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_GATE_NODE__SV
`define SVK_CLK_GATE_NODE__SV

class svk_clk_gate_node extends svk_clk_node;
    `uvm_component_utils(svk_clk_gate_node)

    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_clk(output real period, output real duty_ratio);
        bit gate;
        uvm_status_e status;

        if(cfg.reg_fields.exists("gate"))
            cfg.reg_fields["gate"].read(status, gate);
        else
            uvm_hdl_read(cfg.hdl_paths["gate"], gate);

        if(gate == 0)begin
            period     = 0;
            duty_ratio = 0;
        end
        else begin
            cfg.pre_nodes[0].get_expe_clk(period, duty_ratio);
        end

        `uvm_info("get_expe_clk", $sformatf("%s:gate=%0b, period=%0f, duty_ratio=%0f",get_name(), gate, period, duty_ratio), UVM_HIGH)
    endtask

    task get_real_clk(output real period, output real duty_ratio, input int time_out_time=1000, input int MEAN_CYCLE_NUM=1);
        svk_clk_node  pre_node;
        real            pre_period;
        real            pre_duty_ratio;

        pre_node = get_pre_node();
        while(1)begin
            pre_node.get_expe_clk(pre_period, pre_duty_ratio);
            if(pre_period != 0)
                break;
            pre_node = pre_node.get_pre_node();    
        end

        super.get_real_clk(period, duty_ratio, pre_period * 10 + 1);

    endtask

endclass

`endif
