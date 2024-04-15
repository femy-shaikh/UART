
class uart_config extends uvm_object;

`uvm_object_utils(uart_config)

virtual uart_if vif;
int no_of_agents=2;
uvm_active_passive_enum is_active = UVM_ACTIVE;

//static int mon_rcvd_xtn_cnt = 0;
//static int drv_data_sent_cnt = 0;

extern function new(string name = "uart_config");

endclass 


// Constructor 
function uart_config::new(string name = "uart_config");
  super.new(name);

endfunction
