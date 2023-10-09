/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/


`ifndef SVK_CRG__SV
`define SVK_CRG__SV

virtual svk_clk_if clks[string];
virtual svk_rst_if rsts[string];

function virtual svk_clk_if get_clk_if(string wildcard_path);
    virtual svk_clk_if ci_q[$];

    foreach(clks[clk_hire])begin
        if(uvm_is_match(wildcard_path, clk_hire))begin
            ci_q.push_back(clks[clk_hire]);
        end
    end

    if(ci_q.size == 1)begin
        return ci_q[0];
    end
    else if(ci_q.size > 1)begin
        `uvm_error("get_clk_if", $sformatf("find more than one svk_clk_if with wildcard_path=%0s", wildcard_path))
        `uvm_info("get_clk_if", "all find svk_clk_if:", UVM_NONE)
        foreach(ci_q[i])begin
           `uvm_info("get_clk_if", $sformatf("clk_hire=%0s", ci_q[i].clk_hire), UVM_NONE)
        end
    end
    else begin
        `uvm_error("get_clk_if", $sformatf("not find any svk_clk_if with wildcard_path=%0s", wildcard_path))
        `uvm_info("get_clk_if", "all svk_clk_if:", UVM_NONE)
        foreach(clks[clk_hire])begin
            `uvm_info("get_clk_if", $sformatf("clk_hire=%0s", clk_hire), UVM_NONE)
        end
    end
endfunction

function virtual svk_rst_if get_rst_if(string wildcard_path);
    virtual svk_rst_if ri_q[$];

    foreach(rsts[rst_hire])begin
        if(uvm_is_match(wildcard_path, rst_hire))begin
            ri_q.push_back(rsts[rst_hire]);
        end
    end

    if(ri_q.size == 1)begin
        return ri_q[0];
    end
    else if(ri_q.size > 1)begin
        `uvm_error("get_rst_if", $sformatf("find more than one svk_rst_if with wildcard_path=%0s", wildcard_path))
        `uvm_info("get_rst_if", "all find svk_rst_if:", UVM_NONE)
        foreach(ri_q[i])begin
           `uvm_info("get_rst_if", $sformatf("rst_hire=%0s", ri_q[i].rst_hire), UVM_NONE)
        end
    end
    else begin
        `uvm_error("get_rst_if", $sformatf("not find any svk_rst_if with wildcard_path=%0s", wildcard_path))
        `uvm_info("get_rst_if", "all svk_rst_if:", UVM_NONE)
        foreach(rsts[rst_hire])begin
            `uvm_info("get_rst_if", $sformatf("rst_hire=%0s", rst_hire), UVM_NONE)
        end
    end
endfunction

`endif

