
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_env extends uvm_env;
    my_agent        i_agt;
    my_agent        o_agt;
    my_model        mdl;
    my_scoreboard   scb;

    uvm_tlm_analysis_fifo #(my_transcation) agt_scb_fifo;
    uvm_tlm_analysis_fifo #(my_transcation) agt_mdl_fifo;
    uvm_tlm_analysis_fifo #(my_transcation) mdl_scb_fifo;

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
    extern task main_phase(uvm_phase phase);
    `uvm_component_utils(my_env)
endclass

function my_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void my_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    i_agt = new("i_agt", this);
    o_agt = new("o_agt", this);
    i_agt.is_active = UVM_ACTIVE;
    o_agt.is_active = UVM_PASSIVE;
    mdl = new("mdl", this);
    scb = new("scb", this);
    agt_scb_fifo = new("agt_scb_fifo", this);
    agt_mdl_fifo = new("agt_mdl_fifo", this);
    mdl_scb_fifo = new("mdl_scb_fifo", this);
endfunction

function void my_env::connect_phase(uvm_phase phase);
    super.build_phase(phase);
    i_agt.ap.connect(agt_mdl_fifo.analysis_export);
    mdl.port.connect(agt_mdl_fifo.blocking_get_export);

    mdl.ap.connect(mdl_scb_fifo.analysis_export);
    scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);

    o_agt.ap.connect(agt_scb_fifo.analysis_export);
    scb.act_port.connect(agt_scb_fifo.blocking_get_export);
endfunction

task my_env::main_phase(uvm_phase phase);
    my_sequence my_seq;
    super.main_phase(phase);
    my_seq = new("my_seq");
    my_seq.starting_phase = phase;
    my_seq.start(i_agt.sqr);
endtask

