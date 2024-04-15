interface uart_if(input bit clock);


	bit wb_clk_i;

	
	bit  wb_rst_i;
	logic [2:0] wb_adr_i;
	logic [3:0] wb_sel_i;
	logic [7:0] wb_dat_i;
	logic [7:0] wb_dat_o;
	logic wb_we_i;
	logic wb_stb_i;
	logic wb_cyc_i;
	logic wb_ack_o;

	bit int_o;             //interface signal//
	bit baud_o;
	
	bit stx_pad_o, srx_pad_i;



 //master driver clocking block

 clocking m_drv_cb @(posedge clock);
   default input #1 output #1;

output wb_clk_i;
output wb_adr_i;
output wb_dat_i;
output wb_we_i;
output wb_sel_i;
output wb_rst_i;
output wb_cyc_i;
output wb_stb_i;

input wb_ack_o;
input int_o;
input wb_dat_o;

endclocking

  //master monitor clocking block


 clocking m_mon_cb @(posedge clock);
 default input #1 output #1;

input wb_clk_i;
input wb_adr_i;
input wb_dat_i;
input wb_we_i;
input wb_sel_i;
input wb_rst_i;
input wb_cyc_i;
input wb_stb_i;
input wb_ack_o;
input int_o;
input wb_dat_o;

endclocking
	
 modport UART_DRV(clocking m_drv_cb);
 modport UART_MON(clocking m_mon_cb); 

endinterface