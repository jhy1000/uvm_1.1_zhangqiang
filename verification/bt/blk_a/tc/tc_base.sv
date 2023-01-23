
`include "uvm_macros.svh"
import uvm_pkg::*;

`ifndef TC_BASE__SV
`define TC_BASE__SV

class tc_base extends uvm_test;
    my_env  env;

    `uvm_component_utils(tc_base)

    extern function new(string name = "tc_base", uvm_component parent = null);
    extern virtual function void build_phase(uvm_phase phase);
    
endclass

function tc_base::new(string name="tc_base", uvm_component parent = null);
    super.new(name,parent);
    env = new("env", this);
endfunction

function void tc_base::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


`endif


