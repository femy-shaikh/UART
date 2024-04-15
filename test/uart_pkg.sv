
package uart_pkg;

import uvm_pkg::*;

`include "uvm_macros.svh"

`include "uart_xtn.sv"
`include "uart_config.sv"
`include "uart_env_config.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"
`include "uart_sequencer.sv"
`include "uart_agent.sv"
`include "uart_agent_top.sv"
`include "uart_sequence.sv"

`include "virtual_sequencer.sv"
`include "virtual_sequence.sv"
`include "scoreboard.sv"
`include "uart_env.sv"
`include "uart_test.sv"

endpackage