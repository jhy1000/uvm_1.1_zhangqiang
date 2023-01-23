
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequencer extends uvm_sequencer #(my_transcation);
    // Component
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);

    // Register
    `uvm_component_utils(my_sequencer)
endclass

function my_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void my_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

