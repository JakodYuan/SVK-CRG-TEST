/***********************************************************
 *  Copyright (C) 2023 by JakodYuan (JakodYuan@outlook.com).
 *  All right reserved.
************************************************************/

import xlwings as xw
import os,sys
import re
import msvcrt
import traceback
from collections import namedtuple
from datetime import datetime


def gen_clk_cfg(line_idx, line, fid):
    fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.ci = clk_ifs["u_clk_if' + str(int(line.node_number)) + '"];\n')
    if line.pre_node != None:
        if isinstance(line.pre_node, float):
            fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.node_numbers = new[1];\n')
            fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.node_numbers[0] = clk_nodes["node' + str(int(line.pre_node)) + '"];\n')
        else:
            node_numbers = line.pre_node.split('\n')
            fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.node_numbers = new[' + str(len(node_numbers)) + '];\n')
            for i in range(len(node_numbers)):
                fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.node_numbers[' + str(i) + '] =  clk_nodes["node' + str(int(node_numbers[i])) + '"];\n')
    if line.freqs != None:
        if isinstance(line.freqs, float):
            fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.freqs = new[1];\n')
            fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.freqs[0] = ' + str(line.freqs) + ';\n')
        else:
            freqs = line.freqs.split('\n')
            fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.freqs = new[' + str(len(freqs)) + '];\n')
            for i in range(len(freqs)):
                fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.freqs[' + str(i) + '] = ' + str(float(freqs[i])) + ';\n')
    if line.current_freq != None:
        fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.current_freq = ' + str(line[5]) + ';\n')
    if line.duty_ratio != None:
        fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.duty_ratio = ' + str(line[6]) + ';\n')
    if line.jetter != None:
        fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.jetter = ' + str(line[7]) + ';\n')
    if line.ppm != None:
        fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.ppm = ' + str(line[8]) + ';\n')
    if line.cfgs != None:
        fields = line.cfgs.split('\n')
        if line[0] == "svk_clk_pll_node" and len(fields) != 7:     # pll类型需要7个配置
            print("error:len(fields) != 7 in line_idx=%0d" % line_idx)

        for field in fields:
            tmp = field.split(':')
            if len(tmp) != 2:
                print(field + ' format is error\n')
                sys.exit()
            if re.match(r'^model\.', tmp[1]):
                fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.reg_fields["'+tmp[0]+'"] = ' + tmp[1] + ';\n')
            else:
                fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.hdl_paths["'+tmp[0]+'"] = "' + tmp[1] + '";\n')
    if line.is_active != None:
        fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.is_active = ' + str(int(line[10])) + ';\n')
    if line.is_end_point != None:
        fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.is_end_point = ' + str(int(line[11])) + ';\n')
    if line.glitch_check_en != None:
        fid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"].cfg.glitch_check_en = ' + str(int(line[12])) + ';\n')
    fid.writelines('\n')


def gen_rst_cfg(line_idx:int, line, fid):
    fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.ri = rst_ifs["u_rst_if' + str(int(line.node_number)) + '"];\n')
    if line.pre_node != None:
        if isinstance(line.pre_node, float):
            fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.node_numbers = new[1];\n')
            fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.node_numbers[0] = rst_nodes["node' + str(int(line.pre_node)) + '"];\n')
        else:
            node_numbers = line.pre_node.split('\n')
            fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.node_numbers = new[' + str(len(node_numbers)) + '];\n')
            for i in range(len(node_numbers)):
                fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.node_numbers[' + str(i) + '] =  rst_nodes["node' + str(int(node_numbers[i])) + '"];\n')
    if line.sync_check_en != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.sync_check_en = ' + str(int(line.sync_check_en)) + ';\n')
    if line.sync_clk != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.ci = clk_nodes["node' + str(int(line.sync_clk)) + '"].cfg.ci;\n')
    if line.up_time != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.up_time = ' + str(line.up_time) + ';\n')
    elif line.is_active != None and int(line.is_active) == 1:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.up_time = $urandom_range(0,10);\n')

    if line.down_time != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.down_time = ' + str(line.down_time) + ';\n')
    elif line.is_active != None and int(line.is_active) == 1:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.down_time = $urandom_range(20,50);\n')

    if line.cfgs != None:
        fields = line.cfgs.split('\n')
        for field in fields:
            tmp = field.split(':')
            if len(tmp) != 2:
                print('line='+line_idx + ':' + field + ' format is error\n')
                sys.exit()
            if re.match(r'^model\.', tmp[1]):
                fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.reg_fields["'+tmp[0]+'"] = ' + tmp[1] + ';\n')
            else:
                fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.hdl_paths["'+tmp[0]+'"] = "' + tmp[1] + '";\n')
    if line.glitch_check_en != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.glitch_check_en = ' + str(int(line.glitch_check_en)) + ';\n')
    if line.glitch_high_th != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.glitch_high_th = ' + str(line.glitch_high_th) + ';\n')
    if line.glitch_low_th != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.glitch_low_th = ' + str(line.glitch_low_th) + ';\n')
    if line.is_active != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.is_active = ' + str(int(line.is_active)) + ';\n')
    if line.is_end_point != None:
        fid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"].cfg.is_end_point = ' + str(int(line.is_end_point)) + ';\n')
    fid.writelines('\n')


def gen_file_head(wid):
    wid.writelines('
    wid.writelines('
    wid.writelines('\n')
    wid.writelines('virtual svk_clk_if  clk_ifs[string];\n')
    wid.writelines('virtual svk_rst_if  rst_ifs[string];\n')
    wid.writelines('\n')
    wid.writelines('class crg_nodes extends uvm_component;\n')
    wid.writelines('    `uvm_component_utils(crg_nodes)\n')
    wid.writelines('    \n')
    wid.writelines('    svk_clk_node   clk_nodes[string];\n')
    wid.writelines('    svk_rst_node   rst_nodes[string];\n')
    wid.writelines('    xxx_reg_block  model;\n')
    wid.writelines('    \n')
    wid.writelines('    function new(string name="", uvm_component parent);\n')
    wid.writelines('        super.new(name, parent);\n')
    wid.writelines('    endfunction\n')
    wid.writelines('    \n')
    wid.writelines('    function void build_phase(uvm_phase phase);\n')

def gen_crg_nodes(clk_lines, rst_lines, wid):
    for line in clk_lines:
        if line.node_type != None and line.gen_en == 1:
            wid.writelines('        clk_nodes["node' + str(int(line.node_number)) + '"] = ' + line.node_type + '::type_id::create("clk_node' + str(int(line.node_number)) + '", this);\n')
    for line in rst_lines:
        if line.node_type != None and line.gen_en == 1:
            wid.writelines('        rst_nodes["node' + str(int(line.node_number)) + '"] = ' + line.node_type + '::type_id::create("rst_node' + str(int(line.node_number)) + '", this);\n')

    wid.writelines('\n')
    i = 0
    for line in clk_lines:
        i = i + 1
        if line.node_type != None and line.gen_en == 1:
               gen_clk_cfg(i, line, wid)

    wid.writelines('\n')
    for line in rst_lines:
        i = i + 1
        if line.node_type != None and line.gen_en == 1:
               gen_rst_cfg(i, line, wid)



def gen_file_tail(wid):
    wid.writelines('    \n')
    wid.writelines('    endfunction\n')
    wid.writelines('    \n')
    wid.writelines('    task check_clk();\n')
    wid.writelines('        foreach(clk_nodes[i])begin\n')
    wid.writelines('            if(clk_nodes[i].cfg.is_end_point)\n')
    wid.writelines('                clk_nodes[i].check_clk();\n')
    wid.writelines('        end\n')
    wid.writelines('    endtask\n')
    wid.writelines('    task check_rst();\n')
    wid.writelines('        foreach(rst_nodes[i])begin\n')
    wid.writelines('            if(rst_nodes[i].cfg.is_end_point)\n')
    wid.writelines('                rst_nodes[i].check_rst();\n')
    wid.writelines('        end\n')
    wid.writelines('    endtask\n')
    wid.writelines('endclass\n')



def gen_clk_ifs(clk_lines, rst_lines, wid):
    i = 0
    for line in clk_lines:
        i = i + 1
        if line.node_type != None and line.gen_en == 1:
            if line.clk_hire == None:
                print("error: clk_hier is null in row_idx=%0d" % i)
                sys.exit()
            wid.writelines('    svk_clk_if u_clk_if' + str(int(line.node_number)) + '(' + line.clk_hire + ', "'+ line.clk_hire + '");\n')
    i = 0
    for line in rst_lines:
        i = i + 1
        if line.node_type != None and line.gen_en == 1:
            if line.rst_hire == None:
                print("error: rst_hier is null in row_idx=%0d" % i)
                sys.exit()
            wid.writelines('    svk_rst_if u_rst_if' + str(int(line.node_number)) + '(' + line.rst_hire + ', "'+ line.rst_hire + '");\n')


    wid.writelines('    initial begin\n')
    for line in clk_lines:
        if line.node_type != None and line.gen_en == 1:
            wid.writelines('        clk_ifs["u_clk_if' + str(int(line.node_number)) + '"] =  u_clk_if' + str(int(line.node_number)) + ';\n')
    for line in rst_lines:
        if line.node_type != None and line.gen_en == 1:
            wid.writelines('        rst_ifs["u_rst_if' + str(int(line.node_number)) + '"] =  u_rst_if' + str(int(line.node_number)) + ';\n')
    wid.writelines('    end\n')


def main():
    crg_nodes_fid = open(sys.path[0] + "/crg_nodes.sv", "w")
    if_inst_fid = open(sys.path[0] + "/crg_if_inst.sv", "w")

    app = xw.App(visible=False, add_book=False)
    wb = app.books.open(sys.path[0] + '\crg_nodes.xlsm')

    print("open ok!")
    try:
        max_row = wb.sheets["CLK"].used_range.last_cell.row
        max_col = wb.sheets["CLK"].used_range.last_cell.column
        clk_values = wb.sheets["CLK"].range((2,1), (max_row, max_col)).value
        if(max_row == 2):
            clk_values = [clk_values]
        
        clk_line = namedtuple("clk_line", "node_type node_number pre_node clk_hire freqs current_freq duty_ratio jetter ppm cfgs is_active is_end_point glitch_check_en gen_en")
        clk_lines = list(map(clk_line._make, clk_values))

        max_row = wb.sheets["RST"].used_range.last_cell.row
        max_col = wb.sheets["RST"].used_range.last_cell.column
        rst_values = wb.sheets["RST"].range((2,1), (max_row, max_col)).value
        if(max_row == 2):
            rst_values = [rst_values]

        rst_line = namedtuple("rst_line", "node_type node_number pre_node rst_hire sync_check_en sync_clk up_time down_time cfgs glitch_check_en glitch_high_th glitch_low_th is_active is_end_point gen_en")
        rst_lines = list(map(rst_line._make, rst_values))

        print("gen crg nodes")
        gen_file_head(crg_nodes_fid)
        gen_crg_nodes(clk_lines, rst_lines, crg_nodes_fid)
        gen_file_tail(crg_nodes_fid)

        print("gen crg ifs")
        gen_clk_ifs(clk_lines, rst_lines, if_inst_fid)


        #wb.sheets["RST"].range((20,1)).value = "hello"
    except Exception as e:
        print(traceback.format_exc())

    finally:
        crg_nodes_fid.close()
        if_inst_fid.close()
        wb.save()
        wb.close()
        app.quit()
        print(datetime.now().strftime('%H:%M')+"\n")

        print("Press any key to Exit")
        msvcrt.getch()


if __name__ == "__main__":
    main()