class uart_agent extends uvm_agent;

`uvm_component_utils(uart_agent)

uart_config cfg;
uart_driver u_drvh;
uart_monitor u_monh;
uart_sequencer u_seqrh;

extern function new(string name="uart_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass


// Constuctor
function uart_agent::new(string name="uart_agent",uvm_component parent);
    super.new(name,parent);

endfunction


//Build_phase
function void uart_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(uart_config)::get(this,"","uart_config",cfg))
	    `uvm_fatal("CONFIG","cannot get() cfg from uvm_config_db. Have you set() it?") 
       
        u_monh=uart_monitor::type_id::create("u_monh",this);
    
    if(cfg.is_active==UVM_ACTIVE)
        begin
        u_drvh=uart_driver::type_id::create("u_drvh",this);
        u_seqrh=uart_sequencer::type_id::create("u_seqrh",this);
	end
endfunction

//Connect_phase
function void uart_agent::connect_phase(uvm_phase phase);
super.connect_phase(phase);    
    if(cfg.is_active==UVM_ACTIVE)
        begin
        u_drvh.seq_item_port.connect(u_seqrh.seq_item_export);
        end

endfunction