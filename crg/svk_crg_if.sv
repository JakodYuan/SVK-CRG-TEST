/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_CRG_IF__SV
`define SVK_CRG_IF__SV

interface svk_crg_if#(int CLK_NUM=1, int RST_NUM=1)();
    logic [CLK_NUM-1:0] clks;
    logic [RST_NUM-1:0] rsts;

    genvar i;

    generate;
       for(i=0; i<CLK_NUM; ++i) 
            svk_clk_if u_clk_if(clks[i], $sformatf("%0d", i));
       for(i=0; i<RST_NUM; ++i) 
            svk_rst_if u_clk_if(clks[i], $sformatf("%0d", i));
    endgenerate
endinterface

`endif
