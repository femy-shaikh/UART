
class uart_test extends uvm_test;

//factory reg
`uvm_component_utils(uart_test)

uart_env env;
uart_env_config e_cfg;
uart_config cfg[];
int no_of_agents=2;
int has_agt = 1;
//int has_wagent = 1;

//router_wr_config wcfg;


//uvm metods
extern function new(string name = "uart_test" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
//extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

//cod for new
function uart_test::new( string name="uart_test",uvm_component parent);
super.new(name,parent);
endfunction
////////////build phase


function void  uart_test::build_phase(uvm_phase phase);
super.build_phase(phase);
e_cfg=uart_env_config::type_id::create("e_cfg");


if(has_agt)
        cfg=new[no_of_agents];
        e_cfg.cfg=new[no_of_agents];


foreach(cfg[i])
begin
cfg[i]=uart_config::type_id::create($sformatf("cfg[%0d]",i));
                if(!uvm_config_db#(virtual uart_if)::get(this,"",$sformatf("uart_if%0d",i),cfg[i].vif))
                `uvm_fatal("VIF CONFIG","Cannot get interface from uvm_config_db.Have you set it?")
cfg[i].is_active=UVM_ACTIVE;

e_cfg.cfg[i]=cfg[i];
cfg[i].no_of_agents=no_of_agents;
end


e_cfg.has_agt=has_agt;

//env
 uvm_config_db#(uart_env_config)::set(this,"*","uart_env_config",e_cfg);
env=uart_env::type_id::create("env",this);

endfunction
///////////////////full duplex//////////////////////////////////////

class ful_dup extends uart_test;
`uvm_component_utils(ful_dup)

 vseq seqh;

extern function new(string name = "ful_dup" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function ful_dup::new(string name = "ful_dup" , uvm_component parent);
                super.new(name,parent);
        endfunction

function void ful_dup::build_phase(uvm_phase phase);
            super.build_phase(phase);
endfunction

        task ful_dup::run_phase(uvm_phase phase);
 //raise objection
         phase.raise_objection(this);
 //create instance for sequence
          seqh=vseq::type_id::create("seqh");
 //start the sequence wrt virtual sequencer
          seqh.start(env.vsqrh);
 //drop objection
                #1000;
         phase.drop_objection(this);
        endtask
//////////////////////////////////half duplex//////////////////////////////
class half_dup extends uart_test;
`uvm_component_utils(half_dup)

 half_dub_seq  seqh;

extern function new(string name = "half_dup" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function half_dup::new(string name = "half_dup" , uvm_component parent);
                super.new(name,parent);
        endfunction

function void half_dup::build_phase(uvm_phase phase);
            super.build_phase(phase);
endfunction

        task half_dup::run_phase(uvm_phase phase);
 //raise objection
         phase.raise_objection(this);
 //create instance for sequence
          seqh=half_dub_seq::type_id::create("seqh");
 //start the sequence wrt virtual sequencer
          seqh.start(env.vsqrh);
 //drop objection
                #1000;
         phase.drop_objection(this);
        endtask
////////////////////////////////loop back /////////////////////////////////////////
class loop_back extends uart_test;
`uvm_component_utils(loop_back)

 loop_back_seq  seqh2;

extern function new(string name = "loop_back" , uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
endclass

function loop_back::new(string name = "loop_back" , uvm_component parent);
                super.new(name,parent);
        endfunction

function void loop_back::build_phase(uvm_phase phase);
            super.build_phase(phase);
endfunction

        task loop_back::run_phase(uvm_phase phase);
 //raise objection
         phase.raise_objection(this);
 //create instance for sequence
          seqh2=loop_back_seq::type_id::create("seqh2");
 //start the sequence wrt virtual sequencer
          seqh2.start(env.vsqrh);
 //drop objection
                #1000;
         phase.drop_objection(this);
        endtask
/////////////////////////////////PARITY////////////////////////
class parity_test extends uart_test;

  `uvm_component_utils(parity_test)

 parity_err_FD_U  seqh3;

  extern function new(string name = "parity_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function parity_test::new(string name = "parity_test",uvm_component parent);
  super.new(name,parent);

endfunction

function void parity_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

endfunction

task parity_test::run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seqh3=parity_err_FD_U::type_id::create("seqh3");

    seqh3.start(env.vsqrh);

    phase.drop_objection(this);

endtask
/////////////////////////////////framing////////////////////////
class framing_test extends uart_test;

  `uvm_component_utils(framing_test)

 frame_err_FD_U seqh4;

  extern function new(string name = "framing_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function framing_test::new(string name = "framing_test",uvm_component parent);
  super.new(name,parent);

endfunction

function void framing_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

endfunction

task framing_test::run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seqh4=frame_err_FD_U::type_id::create("seqh4");

    seqh4.start(env.vsqrh);

    phase.drop_objection(this);

endtask

/////////////////////////////////OVER_RUN////////////////////////
class over_run_test extends uart_test;

  `uvm_component_utils(over_run_test)

 overrun_err_FD_U seqh5;

  extern function new(string name = "over_run_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function over_run_test::new(string name = "over_run_test",uvm_component parent);
  super.new(name,parent);

endfunction

function void over_run_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

endfunction

task over_run_test::run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seqh5=overrun_err_FD_U::type_id::create("seqh5");

    seqh5.start(env.vsqrh);
        #10000;
    phase.drop_objection(this);

endtask

/////////////////////////////////BREAK_INTERRUPT////////////////////////
class break_interrupt_test extends uart_test;

  `uvm_component_utils(break_interrupt_test)

 break_FD_U seqh6;

  extern function new(string name = "break_interrupt_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function break_interrupt_test::new(string name = "break_interrupt_test",uvm_component parent);
  super.new(name,parent);

endfunction

function void break_interrupt_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

endfunction

task break_interrupt_test::run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seqh6=break_FD_U::type_id::create("seqh6");

    seqh6.start(env.vsqrh);

    phase.drop_objection(this);

endtask


/////////////////////////////////TIME_OUT////////////////////////
class time_out_test extends uart_test;

  `uvm_component_utils(time_out_test)

 timeout_FD_U seqh7;

  extern function new(string name = "time_out_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function time_out_test::new(string name = "time_out_test",uvm_component parent);
  super.new(name,parent);

endfunction

function void time_out_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

endfunction

task time_out_test::run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seqh7=timeout_FD_U::type_id::create("seqh7");

    seqh7.start(env.vsqrh);
        #1000;
    phase.drop_objection(this);

endtask

/////////////////////////////////THR_EMPTY////////////////////////
class thr_empty_test extends uart_test;

  `uvm_component_utils(thr_empty_test)

 thrempty_FD_U seqh8;

  extern function new(string name = "thr_empty_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

function thr_empty_test::new(string name = "thr_empty_test",uvm_component parent);
  super.new(name,parent);

endfunction

function void thr_empty_test::build_phase(uvm_phase phase);
  super.build_phase(phase);

endfunction

task thr_empty_test::run_phase(uvm_phase phase);

    phase.raise_objection(this);

    seqh8=thrempty_FD_U::type_id::create("seqh8");

    seqh8.start(env.vsqrh);

    phase.drop_objection(this);

endtask



