class uart_monitor extends uvm_monitor;

//factory reg
`uvm_component_utils(uart_monitor)

//interface declaration
virtual uart_if.UART_MON vif;
// declaring handle of rd_config class

uart_config cfg;
//declaring analysis port
uvm_analysis_port #(uart_xtn) monitor_port;

// declare handle for write trans
uart_xtn xtn;
//uvm_methods
extern function new(string name = "uart_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass 

//code for new
 function uart_monitor:: new(string name = "uart_monitor", uvm_component parent);
super.new(name,parent);
monitor_port=new("monitor_port",this);

endfunction

//code for build phase
function void uart_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);
//geting config class 
 if(!uvm_config_db #(uart_config)::get(this,"","uart_config",cfg))
		`uvm_fatal("CONFIG","cannot get() cfg from uvm_config_db. Have you set() it?") 
xtn=uart_xtn::type_id::create("xtn");

endfunction

//code for connect phase
	function void uart_monitor::connect_phase(uvm_phase phase);
          vif=cfg.vif;
        endfunction

//////////////////////////////////RUN PHASE//////////////////////////////////////////////
task uart_monitor::run_phase(uvm_phase phase);
   xtn=uart_xtn::type_id::create("xtn");
     
 
forever
     begin
 collect_data();
  end
     endtask

///////////////////////////collect data task///////////////////////////////////////////////////////////////
 task uart_monitor::collect_data();
                 @(vif.m_mon_cb);
wait(vif.m_mon_cb.wb_ack_o);
xtn.wb_rst_i= vif.m_mon_cb.wb_rst_i;
xtn.wb_stb_i= vif.m_mon_cb.wb_stb_i;
xtn.wb_cyc_i=   vif.m_mon_cb.wb_cyc_i;
xtn.wb_adr_i=vif.m_mon_cb.wb_adr_i;
xtn.wb_dat_i=vif.m_mon_cb.wb_dat_i;
xtn.wb_we_i=vif.m_mon_cb.wb_we_i;



       if(xtn.wb_adr_i==0 && xtn.wb_we_i==0 && xtn.lcr[7]==0)
         xtn.rb.push_back(vif.m_mon_cb.wb_dat_o);


       if(xtn.wb_adr_i==0 && xtn.wb_we_i==1 && xtn.lcr[7]==0)
          xtn.thr.push_back(vif.m_mon_cb.wb_dat_i);

       if(xtn.wb_adr_i==1 && xtn.wb_we_i==1 )
           xtn.ier=vif.m_mon_cb.wb_dat_i;

       if(xtn.wb_adr_i==2 && xtn.wb_we_i==0 )
           xtn.iir=vif.m_mon_cb.wb_dat_i;

       if(xtn.wb_adr_i==2 && xtn.wb_we_i==1 )
           xtn.fcr=vif.m_mon_cb.wb_dat_i;

       if(xtn.wb_adr_i==3 && xtn.wb_we_i==1 )
           xtn.lcr=vif.m_mon_cb.wb_dat_i;

       if(xtn.wb_adr_i==4 && xtn.wb_we_i==1)
           xtn.mcr=vif.m_mon_cb.wb_dat_i;

       if(xtn.wb_adr_i==5 && xtn.wb_we_i==0)
           xtn.lsr=vif.m_mon_cb.wb_dat_i;

      if(xtn.wb_adr_i==6 && xtn.wb_we_i==0)
          xtn.msr=vif.m_mon_cb.wb_dat_i;

      if(xtn.wb_adr_i==0 && xtn.wb_we_i==1 && xtn.lcr[7]==1)
           xtn.dlb1=vif.m_mon_cb.wb_dat_i;

      if(xtn.wb_adr_i==1 && xtn.wb_we_i==1 && xtn.lcr[7]==1)
           xtn.dlb2=vif.m_mon_cb.wb_dat_i;



  `uvm_info("UART_MONITOR",$sformatf("printing from write monitor \n %s", xtn.sprint()),UVM_LOW) 


  	monitor_port.write(xtn);


endtask


