
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_sequence extends uvm_sequence #(my_transcation);
    my_transcation m_trans;

    extern function new(string name="my_sequence");
    virtual task body();
        if(starting_phase != null) begin
            starting_phase.raise_objection(this);
        end
        repeat(10) begin
            `uvm_do(m_trans)
        end
        #100;
        if(starting_phase != null) begin
            starting_phase.drop_objection(this);
        end
    endtask

    `uvm_object_utils(my_sequence)
endclass

function my_sequence::new(string name="my_sequence");
    super.new(name);
endfunction


