/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_RST_NODE_CFG__SV
`define SVK_RST_NODE_CFG__SV

typedef class svk_rst_node;

class svk_rst_node_cfg;
    svk_rst_node                pre_nodes[];
    virtual svk_clk_if          ci;
    virtual svk_rst_if          ri;
    uvm_reg_field               reg_fields[string];
    string                      hdl_paths[string];
    real                        up_time;
    real                        down_time;
    bit                         is_active;
    bit                         glitch_check_en;
    real                        glitch_high_th=10;
    real                        glitch_low_th=10;
    bit                         sync_check_en;
    real                        sync_ignore_th=0.0011;
    bit                         is_end_point;
    string                      node_type;


endclass

`endif
