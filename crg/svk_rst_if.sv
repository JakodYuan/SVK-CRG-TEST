/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

`ifndef SVK_RST_IF__SV
`define SVK_RST_IF__SV

interface svk_rst_if(
    inout           rst,
    input string    rst_hire
);
    real      up_time;
    real      down_time;

    import uvm_pkg::*;

    task undrive();
        release rst;
    endtask

    task drive();
        force rst = 1;
        #(up_time);
        force rst = 0;
        #(down_time);
        force rst = 1;
    endtask

    task set_rst(input logic rst_value);
        force rst = rst_value;
    endtask

endinterface

`endif
