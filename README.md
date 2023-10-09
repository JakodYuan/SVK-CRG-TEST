# SVK-CRG-TEST

## 1 Function
This is a kit for clock and reset verification in ASIC, the kit provide follow functions: 
- Auto check clock frequency
- Auto check Clock duty ratio
- Auto check Reset value
- Auto check glitch in Clock and Reset 

## 2 Usage

<img  style="width:500px" src="https://img2023.cnblogs.com/blog/898240/202310/898240-20231009154237403-880237961.png">


1. Fill in CRG Form
2. Run Script to generate the component
3. Integrate component to the evironment.
4. Configure and Simulation

## 3 Example

simple clock tree

<img  style="width:800px" src="https://img2023.cnblogs.com/blog/898240/202310/898240-20231009112622074-1047173914.png">
simple reset tree

<img  style="width:800px" src="https://img2023.cnblogs.com/blog/898240/202310/898240-20231009172003776-270156522.png">

### 3.1 Fill in form as follow

clock sheet
![img](https://img2023.cnblogs.com/blog/898240/202310/898240-20231009113028320-1096003165.png)
reset sheet
![img](https://img2023.cnblogs.com/blog/898240/202310/898240-20231009171520311-1156407629.png)

### 3.2 Run the script

User should install Python in windows or Linux，and install `xlwings` package.

```py
python gen_crg_nodes.py
```
![img](https://img2023.cnblogs.com/blog/898240/202310/898240-20231009113115611-1981816766.png)

After runing script, will generate two files - "crg_nodes.sv" and "crg_if_inst.sv"

### 3.3 Integrate

1. copy the "crg" directory to the testbench(such as dir of CRG_NODE_DIR), and add this directory into incdir
    ```sv
    +incdir+$CRG_NODE_DIR
    ```
2. add "svk_crg_pkg.sv" into filelist
    ```sv
    ...
    $CRG_NODE_DIR/svk_crg_pkg.sv
    ...
    ```
2. instantion crg_nodes
    ```sv
    class env extends uvm_env;
        import svk_crg_pkg::*;
        crg_nodes nodes;
        ...
        function build_phase();
            crg_nodes nodes = crg_nodes::type_id::create("nodes", this);
            nodes.model = xxx_model;   // set the register model
    endfunction
    endclass
    ```
3. add `include "crg_if_inst.sv"` into tb_top
    ```sv
        module tb_top();
            import svk_crg_pkg::*;
            ...
            `include "crg_if_inst.sv"
            ...
        endmodule
    ```
### 3.4 Configure and Simulation

configure the register of clock and reset and run the DUT, the kit will check clock and reset auomaticlly 

### 4 The Format of form

#### Clock

- node_type：(required)
    - svk_clk_drv_node：generate clock according to the configure
    - svk_clk_pll_node：pll, have 5 configure.
    - svk_clk_sel_node：clock select, have 1 configure.
    - svk_clk_div_node: clock divder, have 1 configure.
    - svk_clk_gate_node：clock gate, have 1 configure.
    - svk_clk_wire_node: wire, not have configure.

- node_number：(required)
    can be digital or string, recommand to be a digital

- pre_node：(required)
    father node number

- clk_hire：(required)
    clock hirearchy in the RTL, user can define micro in env and use micro to shoren hirearchy

- freqs：(optionalal)
    - only svk_clk_drv_node required, clock frequency in Mhz
    - can be multi frequencies, seperate by enter key

- current_freq：(optionalal)
    only svk_clock_drv_node have multi frequencies required, use to set the start frequency

- duty_ratio：(optionalal)
    - svk_clk_drv_node, set the clock duty ratio
    - other nodes, set the expect clock duty ratio
    - the default duty ratio is 0.5
- jetter：(optional)
    - svk_clk_drv_node, set the clock jetter
    - other nodes, Add redundancy to the clock check
    - the default jetter is 0.01
- ppm：(optional)
    - svk_clk_drv_node, set the clock ppm
    - other nodes, Add redundancy to the clock check
    - the default ppm is 1

- cfg：(required)
    - the configure of node, can fill with in reg_block format or hirearchy format
    - configure consist of key and value，sperate by ':'
    - multi configure seperate by enter key
    - reg_block format must begin with 'model.', with model is set by `nodes.model = xxx_model;`
    - hirearchy format must not begin with 'model.', hireachy can use micro
    - different node have different keys
        - svk_clk_drv_node
            - null
        - svk_clk_pll_node
            - dsmen:
            - lock:
            - refdiv:
            - fbdiv:
            - frac:
            - postdiv1:
            - postdiv2:
        - svk_clk_sel_node 
            - sel：
        - svk_clk_div_node 
            - div：
        - svk_clk_gate_node
            - gate：
        - svk_clk_wire_node
            - null

- is_active:(optional)
    only svk_clk_drv_node required, 1:svk_clk_drv_node work, 0:svk_clk_drv_node not work

- is_end_point:(required)
    - whether it is leaf node or not
    - default is 0 

- glitch_check_en:(optional)
    - glitch check enable
    - default is 0

- gen_en:(required)
    - node generate enable
    - default is 0

#### Reset

- node_type：(required)
    - svk_rst_drv_node：generate reset accoding to the configure. 
    - svk_rst_sel_node：reset select, have 1 configure.
    - svk_rst_and_node：output = (&inputs) & (&cfgs), this node can have multi input and multi cfg.
    - svk_rst_sync_node：Reset synchronization
    - svk_rst_cfg_node：output = input & cfg，have 1 configure
    - svk_rst_wire_node：wire, not have configure.

- node_number：(required)
    can be digital or string, recommand to be a digital

- pre_node：(required)
    father node number

- rst_hire：(required)
    reset hirearchy in the RTL, user can define micro in env and use micro to shoren hirearchy

- sync_check_en:(optional)
    synchronization check enable

- sync_check_en:(optional)
    - required when sync_check_en=1
    - indicate the synchonization clock number in the clock sheet

- up_time:(optional)
    - only svk_rst_drv_node required，indicate the reset asset time begin 0
    - fill in digital or use random function like `$urandom_range(10,200)`

- down_time:(optional)
    - only svk_rst_drv_node required，indicate the reset deasset time after asset.
    - fill in digital or use random function like `$urandom_range(10,200)`

- cfgs:(optional)
    the format is like clock cfgs
    - svk_rst_drv_node： 
        - null
    - svk_rst_sel_node：
        - cfg:model.sel
    - svk_rst_and_node：
        - cfg:model.cfg(can have multi configure, seperate by enter key)
    - svk_rst_sync_node：
        - null
    - svk_rst_cfg_node：
        - cfg:model.cfg
    - svk_rst_wire_node：
        - null

- glitch_check_en:(optional)
    gltich check enable

- gltich_high_th:(optioan)
    - required when glitch_check_en=1,
    - The high pulse which width is less than glitch_high_th will identified as glitch

- gltich_low_th:(optioan)
    - required when glitch_check_en=1,
    - The low pulse which width is less than glitch_low_th will identified as glitch

- is_active:(optional)
    only svk_rst_drv_node required, 1:svk_rst_drv_node work, 0:svk_rst_drv_node not work

- is_end_point:(required)
    - whether it is leaf node or not
    - default is 0 

- gen_en:(required)
    - node generate enable
    - default is 0
 
## 5 Create new node

In sometimes the nodes provides above is not enough, users can create a new node by extends `"svk_rst_node"` and `"svk_clk_node"` class.

```sv
class svk_clk_new_node extends svk_clk_node;
    `uvm_component_utils(svk_clk_new_node)

    function new(string name="svk_clk_new_node", uvm_component parent);
        super.new(name, parent);
    endfunction

    task get_expe_clk(output logic clk);
        // get pre node value
        // cfg.pre_nodes[0].get_expe_clk(clk);

        // use cfg
        // foreach(cfg.hdl_paths[i])begin
        //     uvm_hdl_read(cfg.hdl_paths[i], tmp);
        // end
        // foreach(cfg.reg_fields[i])begin
        //     cfg.reg_fields[i].read(status, tmp);
        // end
    endtask
endclass
```
