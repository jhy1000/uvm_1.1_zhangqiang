
class my_agent extends uvm_agent;
    my_sequencer sqr;
    my_driver    drv;
    my_monitor   mon;

    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);

    uvm_analysis_port#(my_transcation) ap;

    `uvm_component_utils_begin(my_agent)
        `uvm_field_object(sqr,  UVM_ALL_ON)
        `uvm_field_object(drv,  UVM_ALL_ON)
        `uvm_field_object(mon,  UVM_ALL_ON)
    `uvm_component_utils_end
endclass

function my_agent::new(string name, uvm_component parent);
    super.new(name,parent);
endfunction

function void my_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE) begin
        sqr = my_sequencer::type_id::create("sqr",this);
        drv = my_driver::type_id::create("drv", this);
    end
    else begin
        mon = my_monitor::type_id::create("mon",this);
    end
endfunction

function void my_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE) begin
        drv.seq_item_port.connect(sqr.seq_item_export);
        this.ap = drv.ap;
    end
    else begin
        this.ap = mon.ap;
    end
endfunction

    
