/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/




class crg_nodes extends uvm_component;
    `uvm_component_utils(crg_nodes)
    
    svk_clk_node   clk_nodes[string];
    svk_rst_node   rst_nodes[string];
    xxx_reg_block  model;// nead to modify
    
    function new(string name="", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        clk_nodes["node1"] = svk_clock_drv_node::type_id::create("clk_node1", this);
        clk_nodes["node2"] = svk_clock_drv_node::type_id::create("clk_node2", this);
        clk_nodes["node3"] = svk_clock_pll_node::type_id::create("clk_node3", this);
        clk_nodes["node4"] = svk_clock_sel_node::type_id::create("clk_node4", this);
        clk_nodes["node5"] = svk_clock_div_node::type_id::create("clk_node5", this);
        clk_nodes["node6"] = svk_clock_gate_node::type_id::create("clk_node6", this);
        clk_nodes["node7"] = svk_clock_wire_node::type_id::create("clk_node7", this);
        rst_nodes["node1"] = svk_reset_drv_node::type_id::create("rst_node1", this);
        rst_nodes["node2"] = svk_reset_drv_node::type_id::create("rst_node2", this);
        rst_nodes["node3"] = svk_reset_drv_node::type_id::create("rst_node3", this);
        rst_nodes["node4"] = svk_reset_sel_node::type_id::create("rst_node4", this);
        rst_nodes["node5"] = svk_reset_and_node::type_id::create("rst_node5", this);
        rst_nodes["node6"] = svk_reset_sync_node::type_id::create("rst_node6", this);
        rst_nodes["node7"] = svk_reset_cfg_node::type_id::create("rst_node7", this);
        rst_nodes["node8"] = svk_reset_wire_node::type_id::create("rst_node8", this);

        clk_nodes["node1"].cfg.ci = clk_ifs["u_clk_if1"];
        clk_nodes["node1"].cfg.freqs = new[2];
        clk_nodes["node1"].cfg.freqs[0] = 19.2;
        clk_nodes["node1"].cfg.freqs[1] = 100.0;
        clk_nodes["node1"].cfg.current_freq = 19.2;
        clk_nodes["node1"].cfg.duty_ratio = 0.5;
        clk_nodes["node1"].cfg.jetter = 0.01;
        clk_nodes["node1"].cfg.ppm = 1.0;
        clk_nodes["node1"].cfg.is_active = 1;

        clk_nodes["node2"].cfg.ci = clk_ifs["u_clk_if2"];
        clk_nodes["node2"].cfg.freqs = new[1];
        clk_nodes["node2"].cfg.freqs[0] = 83.0;
        clk_nodes["node2"].cfg.duty_ratio = 0.5;
        clk_nodes["node2"].cfg.jetter = 0.01;
        clk_nodes["node2"].cfg.ppm = 1.0;
        clk_nodes["node2"].cfg.is_active = 1;

        clk_nodes["node3"].cfg.ci = clk_ifs["u_clk_if3"];
        clk_nodes["node3"].cfg.node_numbers = new[1];
        clk_nodes["node3"].cfg.node_numbers[0] = clk_nodes["node1"];
        clk_nodes["node3"].cfg.duty_ratio = 0.5;
        clk_nodes["node3"].cfg.jetter = 0.05;
        clk_nodes["node3"].cfg.ppm = 1.0;
        clk_nodes["node3"].cfg.reg_fields["dsmen"] = model.dsmen;
        clk_nodes["node3"].cfg.hdl_paths["refdiv"] = "modelrefdiv";
        clk_nodes["node3"].cfg.reg_fields["fbdiv"] = model.fbdiv;
        clk_nodes["node3"].cfg.reg_fields["frac"] = model.frac;
        clk_nodes["node3"].cfg.reg_fields["postdiv1"] = model.postdiv1;
        clk_nodes["node3"].cfg.reg_fields["postdiv2"] = model.postdiv2;
        clk_nodes["node3"].cfg.reg_fields["lock"] = model.lock;
        clk_nodes["node3"].cfg.is_active = 0;
        clk_nodes["node3"].cfg.is_end_point = 0;

        clk_nodes["node4"].cfg.ci = clk_ifs["u_clk_if4"];
        clk_nodes["node4"].cfg.node_numbers = new[2];
        clk_nodes["node4"].cfg.node_numbers[0] =  clk_nodes["node3"];
        clk_nodes["node4"].cfg.node_numbers[1] =  clk_nodes["node2"];
        clk_nodes["node4"].cfg.duty_ratio = 0.5;
        clk_nodes["node4"].cfg.jetter = 0.05;
        clk_nodes["node4"].cfg.ppm = 1.0;
        clk_nodes["node4"].cfg.reg_fields["sel"] = model.sel;
        clk_nodes["node4"].cfg.is_active = 0;
        clk_nodes["node4"].cfg.is_end_point = 0;

        clk_nodes["node5"].cfg.ci = clk_ifs["u_clk_if5"];
        clk_nodes["node5"].cfg.node_numbers = new[1];
        clk_nodes["node5"].cfg.node_numbers[0] = clk_nodes["node4"];
        clk_nodes["node5"].cfg.duty_ratio = 0.5;
        clk_nodes["node5"].cfg.jetter = 0.05;
        clk_nodes["node5"].cfg.ppm = 1.0;
        clk_nodes["node5"].cfg.reg_fields["div"] = model.div;
        clk_nodes["node5"].cfg.is_active = 0;
        clk_nodes["node5"].cfg.is_end_point = 0;

        clk_nodes["node6"].cfg.ci = clk_ifs["u_clk_if6"];
        clk_nodes["node6"].cfg.node_numbers = new[1];
        clk_nodes["node6"].cfg.node_numbers[0] = clk_nodes["node5"];
        clk_nodes["node6"].cfg.duty_ratio = 0.5;
        clk_nodes["node6"].cfg.jetter = 0.05;
        clk_nodes["node6"].cfg.ppm = 1.0;
        clk_nodes["node6"].cfg.hdl_paths["gate"] = "mode.gate";
        clk_nodes["node6"].cfg.is_active = 0;
        clk_nodes["node6"].cfg.is_end_point = 0;

        clk_nodes["node7"].cfg.ci = clk_ifs["u_clk_if7"];
        clk_nodes["node7"].cfg.node_numbers = new[1];
        clk_nodes["node7"].cfg.node_numbers[0] = clk_nodes["node6"];
        clk_nodes["node7"].cfg.duty_ratio = 0.5;
        clk_nodes["node7"].cfg.jetter = 0.05;
        clk_nodes["node7"].cfg.ppm = 1.0;
        clk_nodes["node7"].cfg.is_active = 0;
        clk_nodes["node7"].cfg.is_end_point = 0;


        rst_nodes["node1"].cfg.ri = rst_ifs["u_rst_if1"];
        rst_nodes["node1"].cfg.sync_check_en = 0;
        rst_nodes["node1"].cfg.up_time = $urandom_range(0,5);
        rst_nodes["node1"].cfg.down_time = $urandom_range(20,100);
        rst_nodes["node1"].cfg.is_active = 1;

        rst_nodes["node2"].cfg.ri = rst_ifs["u_rst_if2"];
        rst_nodes["node2"].cfg.up_time = $urandom_range(0,10);
        rst_nodes["node2"].cfg.down_time = $urandom_range(20,50);
        rst_nodes["node2"].cfg.is_active = 1;

        rst_nodes["node3"].cfg.ri = rst_ifs["u_rst_if3"];
        rst_nodes["node3"].cfg.up_time = $urandom_range(0,10);
        rst_nodes["node3"].cfg.down_time = $urandom_range(20,50);
        rst_nodes["node3"].cfg.is_active = 1;

        rst_nodes["node4"].cfg.ri = rst_ifs["u_rst_if4"];
        rst_nodes["node4"].cfg.node_numbers = new[2];
        rst_nodes["node4"].cfg.node_numbers[0] =  rst_nodes["node1"];
        rst_nodes["node4"].cfg.node_numbers[1] =  rst_nodes["node2"];
        rst_nodes["node4"].cfg.sync_check_en = 0;
        rst_nodes["node4"].cfg.reg_fields["cfg"] = model.sel;

        rst_nodes["node5"].cfg.ri = rst_ifs["u_rst_if5"];
        rst_nodes["node5"].cfg.node_numbers = new[2];
        rst_nodes["node5"].cfg.node_numbers[0] =  rst_nodes["node4"];
        rst_nodes["node5"].cfg.node_numbers[1] =  rst_nodes["node3"];
        rst_nodes["node5"].cfg.reg_fields["cfg"] = model.cfg;

        rst_nodes["node6"].cfg.ri = rst_ifs["u_rst_if6"];
        rst_nodes["node6"].cfg.node_numbers = new[1];
        rst_nodes["node6"].cfg.node_numbers[0] = rst_nodes["node5"];
        rst_nodes["node6"].cfg.sync_check_en = 1;
        rst_nodes["node6"].cfg.ci = clk_nodes["node4"].cfg.ci;

        rst_nodes["node7"].cfg.ri = rst_ifs["u_rst_if7"];
        rst_nodes["node7"].cfg.node_numbers = new[1];
        rst_nodes["node7"].cfg.node_numbers[0] = rst_nodes["node6"];
        rst_nodes["node7"].cfg.sync_check_en = 0;
        rst_nodes["node7"].cfg.reg_fields["cfg"] = model.cfg_rst;

        rst_nodes["node8"].cfg.ri = rst_ifs["u_rst_if8"];
        rst_nodes["node8"].cfg.node_numbers = new[1];
        rst_nodes["node8"].cfg.node_numbers[0] = rst_nodes["node7"];
        rst_nodes["node8"].cfg.sync_check_en = 0;
        rst_nodes["node8"].cfg.is_end_point = 1;

    
    endfunction
    
    task check_clk();
        foreach(clk_nodes[i])begin
            if(clk_nodes[i].cfg.is_end_point)
                clk_nodes[i].check_clk();
        end
    endtask
    task check_rst();
        foreach(rst_nodes[i])begin
            if(rst_nodes[i].cfg.is_end_point)
                rst_nodes[i].check_rst();
        end
    endtask
endclass
