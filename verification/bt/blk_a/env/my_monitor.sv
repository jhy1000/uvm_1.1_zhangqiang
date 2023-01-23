

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_monitor extends uvm_monitor;
    virtual my_if vif;
    uvm_analysis_port #(my_transcation) ap;
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
    extern task receive_one_pkt(ref my_transcation get_pkt);
    extern task get_one_byte(ref logic valid, ref logic [7:0] data);

    `uvm_component_utils(my_monitor)
endclass

function my_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void my_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual my_if)::get(this,"","my_if",vif)) begin
        uvm_report_fatal("my_monitor", "Error in Getting interface.");
    end
    ap = new("ap", this);
endfunction

task my_monitor::main_phase(uvm_phase phase);
    logic valid;
    logic [7:0] data;
    my_transcation tr;
    super.main_phase(phase);
    while(1) begin
        tr = new();
        receive_one_pkt(tr);
        ap.write(tr);
    end
endtask

task my_monitor::get_one_byte(ref logic valid, ref logic [7:0] data);
    @vif.mon_cb;
    data    = vif.mon_cb.txd;
    valid   = vif.mon_cb.tx_en;
endtask

task my_monitor::receive_one_pkt(ref my_transcation get_pkt);
    byte unsigned data_q[$];
    byte unsigned data_array[];
    logic [7:0] data;
    logic       valid =0;
    int         data_size;
    while(valid !== 1) begin
        get_one_byte(valid, data);
    end
    while(valid == 1) begin
        data_q.push_back(data);
        get_one_byte(valid,data);
    end
    data_size = data_q.size();
    data_array = new[data_size];
    for(int i=0; i<data_size; i++) begin
        data_array[i] = data_q[i];
    end
    get_pkt.pload = new[data_size - 18]; // da sa, e_type, crc
    data_size = get_pkt.unpack_bytes(data_array) / 8;

endtask


