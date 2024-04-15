class uart_env extends uvm_env;

//factory reg
`uvm_component_utils(uart_env)

//handle declarations
uart_agent_top agt_top;

uart_env_config e_cfg;
scoreboard sb;
virtual_sequencer vsqrh;

//uvm_methods
extern function new(string name = "uart_env", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass
// code for new
function uart_env::new(string name = "uart_env", uvm_component parent);
super.new(name,parent);
endfunction

//code for build_phase
function void uart_env::build_phase(uvm_phase phase);
super.build_phase(phase);
        if(!uvm_config_db#(uart_env_config)::get(this,"","uart_env_config",e_cfg))
        `uvm_fatal("CONFIG","Cannot get env config from uvm_config_db.Have you set it?")
         $display("----%0d",e_cfg.no_of_agents);

 if(e_cfg.has_agt)
        begin
                 agt_top=uart_agent_top::type_id::create("agt_top" ,this);
        end



if(e_cfg.has_scoreboard)
sb=scoreboard::type_id::create("scoreboard",this);
//sb.rd_fifo=new[m_cfg.no_of_agents];


if(e_cfg.has_virtual_sequencer)
vsqrh=virtual_sequencer::type_id::create("virtual_sequencer",this);
endfunction


//code for connect phase


function void uart_env::connect_phase(uvm_phase phase);
super.connect_phase(phase);

        if(e_cfg.has_virtual_sequencer)
                begin
                                //connecting virtual sequencer to write sequencer
                if(e_cfg.has_agt)
                        begin

                         foreach(agt_top.u_agt[i])
                                vsqrh.u_seqrh[i]=agt_top.u_agt[i].u_seqrh;

                         end

                                //connecting virtual sequencer to read sequencer
                if(e_cfg.has_agt)
                begin
                        foreach(vsqrh.u_seqrh[i])
                                vsqrh.u_seqrh[i]=agt_top.u_agt[i].u_seqrh;
                end
                if(e_cfg.has_scoreboard)
                begin
                //wagt_top.agent.mon.monitor_port.connect(sb.fifo_wrh.analysis_export);
                foreach(sb.fifo_uarth[i])
                agt_top.u_agt[i].u_monh.monitor_port.connect(sb.fifo_uarth[i].analysis_export);


                end
end
endfunction