
`ifndef MY_CASE1__SV
`define MY_CASE1__SV

class my_case1 extends tc_base;

    extern function new(string name="my_case1", uvm_component parent=null);
    extern virtual function void build_phase(uvm_phase phase);

    `uvm_component_utils(my_case1)
endclass

function my_case1::new(string name="my_case1",uvm_component parent=null);
    super.new(name,parent);
    $display("SHORT_SEQ::NEW");
endfunction

function void my_case1::build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db #(uvm_object_wrapper)::set(this, "env.i_agt.sqr.main_phase",
                                                   "default_sequence",
                                                   my_sequence1::type_id::get());
endfunction

`endif
