/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

    svk_clk_if u_clk_if1(`TOP.clk_in1, "`TOP.clk_in1");
    svk_clk_if u_clk_if2(`TOP.clk_in2, "`TOP.clk_in2");
    svk_clk_if u_clk_if3(`TOP.u_crg.clk_pll, "`TOP.u_crg.clk_pll");
    svk_clk_if u_clk_if4(`TOP.u_crg.clk_sel, "`TOP.u_crg.clk_sel");
    svk_clk_if u_clk_if5(`TOP.u_crg.clk_div, "`TOP.u_crg.clk_div");
    svk_clk_if u_clk_if6(`TOP.u_crg.clk_gate, "`TOP.u_crg.clk_gate");
    svk_clk_if u_clk_if7(`TOP.clk_out, "`TOP.clk_out");
    svk_rst_if u_rst_if1(`TOP.rst_in1, "`TOP.rst_in1");
    svk_rst_if u_rst_if2(`TOP.rst_in2, "`TOP.rst_in2");
    svk_rst_if u_rst_if3(`TOP.rst_in2, "`TOP.rst_in2");
    svk_rst_if u_rst_if4(`TOP.u_crg.rst_sel, "`TOP.u_crg.rst_sel");
    svk_rst_if u_rst_if5(`TOP.u_crg.rst_and, "`TOP.u_crg.rst_and");
    svk_rst_if u_rst_if6(`TOP.u_crg.rst_sync, "`TOP.u_crg.rst_sync");
    svk_rst_if u_rst_if7(`TOP.rst_cfg, "`TOP.rst_cfg");
    svk_rst_if u_rst_if8(`TOP.rst_out, "`TOP.rst_out");
    initial begin
        clk_ifs["u_clk_if1"] =  u_clk_if1;
        clk_ifs["u_clk_if2"] =  u_clk_if2;
        clk_ifs["u_clk_if3"] =  u_clk_if3;
        clk_ifs["u_clk_if4"] =  u_clk_if4;
        clk_ifs["u_clk_if5"] =  u_clk_if5;
        clk_ifs["u_clk_if6"] =  u_clk_if6;
        clk_ifs["u_clk_if7"] =  u_clk_if7;
        rst_ifs["u_rst_if1"] =  u_rst_if1;
        rst_ifs["u_rst_if2"] =  u_rst_if2;
        rst_ifs["u_rst_if3"] =  u_rst_if3;
        rst_ifs["u_rst_if4"] =  u_rst_if4;
        rst_ifs["u_rst_if5"] =  u_rst_if5;
        rst_ifs["u_rst_if6"] =  u_rst_if6;
        rst_ifs["u_rst_if7"] =  u_rst_if7;
        rst_ifs["u_rst_if8"] =  u_rst_if8;
    end
