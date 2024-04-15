
class uart_env_config extends uvm_object;

`uvm_object_utils(uart_env_config)

//bit has_functional_coverage = 0;

bit has_scoreboard = 1;

bit has_agt=1;
bit has_virtual_sequencer = 1;

//byte i = 8'b1100_0110;

int no_of_agents = 2;
uart_config cfg[];

extern function new(string name = "uart_env_config");

endclass

// Constuctor
function uart_env_config::new(string name = "uart_env_config");
    super.new(name);

endfunction