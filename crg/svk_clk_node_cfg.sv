/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CLK_NODE_CFG__SV
`define SVK_CLK_NODE_CFG__SV

typedef class svk_clk_node;

class svk_clk_node_cfg;
    svk_clk_node                pre_nodes[];
    virtual svk_clk_if          ci;
    uvm_reg_field               reg_fields[string];
    string                      hdl_paths[string];
    real                        freqs[];
    real                        duty_ratio=0.5;
    real                        jetter=0.01;
    real                        ppm=1;
    bit                         is_active;
    bit                         glitch_check_en;
    bit                         is_end_point;
    real                        current_freq=-1;
    string                      node_type;

    function void print();








    endfunction


endclass

`endif