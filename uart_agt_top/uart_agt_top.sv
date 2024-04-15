class uart_agent_top extends uvm_env;
`uvm_component_utils(uart_agent_top)

	uart_agent u_agt[];
	uart_config cfg[];
	uart_env_config e_cfg;
extern function new(string name="uart_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

//Constuctor
function uart_agent_top::new(string name="uart_agent_top",uvm_component parent);
  super.new(name,parent);

endfunction


//Build_phase 
function  void uart_agent_top::build_phase(uvm_phase phase);
  super.build_phase(phase);
e_cfg=uart_env_config::type_id::create("e_cfg");

if(!uvm_config_db #(uart_env_config)::get(this,"","uart_env_config",e_cfg))
 `uvm_fatal("MASTER CONFIG","Cannot get master agent config from uvm_config_db.Have you set it?")

	u_agt =new[e_cfg.no_of_agents];
	cfg=new[e_cfg.no_of_agents];
	 $display("-------%0d",e_cfg.no_of_agents);


foreach(u_agt[i])
begin
cfg[i]= uart_config::type_id::create($sformatf("cfg[%d]",i),this);
cfg[i]=e_cfg.cfg[i];
 u_agt[i]=uart_agent::type_id::create($sformatf("u_agt[%0d]",i),this);
 uvm_config_db #(uart_config)::set(this,$sformatf("u_agt[%0d]*",i),"uart_config",e_cfg.cfg[i]);

end
  
endfunction



task uart_agent_top::run_phase(uvm_phase phase);
            uvm_top.print_topology;
endtask

