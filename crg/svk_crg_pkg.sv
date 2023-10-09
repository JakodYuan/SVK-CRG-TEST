/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CRG_PKG__SV
`define SVK_CRG_PKG__SV

`include "svk_clk_if.sv"
`include "svk_rst_if.sv"

package svk_crg_pkg;

    import uvm_pkg::*;

    `include "svk_clk_node_cfg.sv"
    `include "svk_clk_node.sv"
    `include "svk_clk_pll_node.sv"
    `include "svk_clk_div_node.sv"
    `include "svk_clk_sel_node.sv"
    `include "svk_clk_gate_node.sv"
    `include "svk_clk_drv_node.sv"
    `include "svk_clk_wire_node.sv"

    `include "svk_rst_node_cfg.sv"
    `include "svk_rst_node.sv"
    `include "svk_rst_drv_node.sv"
    `include "svk_rst_cfg_node.sv"
    `include "svk_rst_logic_node.sv"
    `include "svk_rst_sync_node.sv"
    `include "svk_rst_wire_node.sv"


    `include "crg_nodes.sv"
endpackage

`endif
