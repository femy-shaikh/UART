class uart_driver extends uvm_driver#(uart_xtn);

//factory registration
`uvm_component_utils(uart_driver)

// declaring virtual  interface
virtual uart_if.UART_DRV vif; 

//declaring handle for write_ agent confif
   uart_config cfg;
	extern function new(string name ="uart_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(uart_xtn xtn);
//	extern function void report_phase(uvm_phase phase);
endclass

 //code for new
function uart_driver::new(string name ="uart_driver",uvm_component parent);
super.new(name,parent);
endfunction

//code for build
function void uart_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
 if(!uvm_config_db #(uart_config)::get(this,"","uart_config",cfg))
`uvm_fatal("CONFIG","cannot get() wcfg from uvm_config_db. Have you set() it?")
$display("%p",cfg);
 endfunction

// code for connect phase 
function void uart_driver::connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=cfg.vif;
endfunction

//code for run phase
task  uart_driver::run_phase(uvm_phase phase);
	@(vif.m_drv_cb);
		vif.m_drv_cb.wb_rst_i <= 1'b1;
	@(vif.m_drv_cb);
		vif.m_drv_cb.wb_rst_i <= 1'b0;
               	forever
		 begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		end
  `uvm_info("M_DRIVER",$sformatf("printing from master driver \n %s", req.sprint()),UVM_LOW) 
   req.print();
endtask

/////code for send to dut 
task uart_driver::send_to_dut(uart_xtn xtn);
	 begin
	
		`uvm_info("UART DRIVER",$sformatf("Printing from driver \n %s",xtn.sprint()),UVM_LOW)
		@(vif.m_drv_cb);
		vif.m_drv_cb.wb_we_i<=xtn.wb_we_i;
		vif.m_drv_cb.wb_adr_i<=xtn.wb_adr_i;
		vif.m_drv_cb.wb_dat_i<=xtn.wb_dat_i;
		vif.m_drv_cb.wb_stb_i<=1'b1;//we giving strobe and cycle value as 1 directly(so that it indicates that there is a proper datain driver) because we have not given in m_seq.
		vif.m_drv_cb.wb_cyc_i<=1'b1;
		vif.m_drv_cb.wb_sel_i<=4'b0001;//one hot style because the least significant byte will be considered.
                
		wait(vif.m_drv_cb.wb_ack_o)
		vif.m_drv_cb.wb_stb_i<=1'b0;
                vif.m_drv_cb.wb_cyc_i<=1'b0;
		
////receiving the data and verify its correctness
	
if(xtn.wb_adr_i==2 && xtn.wb_we_i==0)  // wait for interrupt to occur so that m_seq come to know from driver 
begin
   wait(vif.m_drv_cb.int_o)
       xtn.iir=vif.m_drv_cb.wb_dat_o;  // read the data from the dut and store in iir register
        seq_item_port.put_response(xtn);  // xtn handle consists of iir value
        

	end
end
    endtask
