
`include "uvm_macros.svh"
import uvm_pkg::*;

class my_driver extends uvm_driver #(my_transcation);
    virtual my_if vif;
    uvm_analysis_port #(my_transcation) ap;

    `uvm_component_utils(my_driver)

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    extern task drive_one_pkt(my_transcation req);
    extern task drive_one_byte(bit [7:0] data);
endclass

function my_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void my_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual my_if)::get(this,"","my_if",vif)) begin
        `uvm_fatal("my_driver", "Error in Getting interface.");
    end
    ap = new("ap", this);
endfunction

task my_driver::main_phase(uvm_phase phase);
    my_transcation req;
    super.main_phase(phase);

    vif.drv_cb.rxd      <= 0;
    vif.drv_cb.rx_dv    <= 1'b0;
    while(1) begin
        seq_item_port.get_next_item(req);
        drive_one_pkt(req);
        ap.write(req);
        seq_item_port.item_done();
    end
endtask

task my_driver::drive_one_pkt(my_transcation req);
    byte unsigned  data_q[];
    int  data_size;
    data_size = req.pack_bytes(data_q) /8;
    repeat(3) @vif.drv_cb;
    for(int i=0; i<data_size; i++) begin
        drive_one_byte(data_q[i]); // drive data pattern
    end
    @vif.drv_cb;
    vif.drv_cb.rx_dv    <= 1'b0;
endtask

task my_driver::drive_one_byte(bit [7:0] data);
    @vif.drv_cb;
    vif.drv_cb.rxd      <= data;
    vif.drv_cb.rx_dv    <= 1'b1;
endtask

