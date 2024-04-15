
class uart_xtn extends uvm_sequence_item;
    `uvm_object_utils(uart_xtn)

rand logic [2:0] wb_adr_i;
 rand logic [7:0] wb_dat_i;
 rand logic wb_we_i;
 rand logic wb_stb_i;
 rand logic wb_cyc_i;
 rand logic [3:0] wb_sel_i;
   bit wb_rst_i;

	 bit int_o;             //interface signal//
        bit baud_o;

       // bit stx_pad_o, srx_pad_i;


///////////////////////INTERNAL_REGISTERS///////////////////////////////////


     
bit [7:0] 								ier;///////////////////////INTERRUPT_ENABLE_REGISTER
bit [7:0] 								iir;////////////////////INTERUPT IDENTIFICATION REGISTER
bit [7:0] 								fcr;///////////////////////FIFO_CONTROL_REGISTER
bit [7:0] 								mcr;/////////////////MODEM_CONTROL_REGISTER
bit [7:0] 								lcr;//////////////////////////////LINE_CONTROL_REGISTER
bit [7:0] 								msr;//////////////////////////MODEM_STATUS_REGISTER
bit [7:0]                                                               thr[$];///TRANSMITTER HOLDING REGISTER
bit [7:0]    								dlb1;/////////////DLV REGISTER
bit [7:0]                                                               dlb2;///////////////DL REGISTER
bit [7:0]                                                               rb[$];
bit [7:0]                                                               lsr;


extern function new(string name="uart_xtn");
extern  function void do_print(uvm_printer printer);
endclass



//endclass

function uart_xtn::new(string name="uart_xtn");
        super.new(name);
endfunction


 function  void uart_xtn::do_print (uvm_printer printer);
    super.do_print(printer);

   
	printer.print_field( "wb_dat_i", 		this.wb_dat_i, 	    256,	UVM_BIN);
	printer.print_field( "wb_adr_i", 		this.wb_adr_i, 	    8,		 UVM_DEC);
	printer.print_field( "wb_stb_i", 		this.wb_stb_i, 	    8,		 UVM_DEC);
	printer.print_field( "wb_we_i", 		this.wb_we_i, 	    8,		 UVM_DEC);
	printer.print_field( "wb_rst_i", 		this.wb_rst_i, 	    8,		 UVM_DEC);
	printer.print_field( "wb_cyc_i", 		this.wb_cyc_i, 	    8,		 UVM_DEC);
	printer.print_field( "lcr", 			this.lcr, 	    8,		 UVM_DEC);
	printer.print_field( "fcr", 			this.fcr, 	    8,		 UVM_DEC);
//	printer.print_field( "rb", 			this.rb, 	    12,		 UVM_DEC);
	printer.print_field( "lsr", 			this.lsr, 	    8,		 UVM_DEC);

	printer.print_field( "mcr", 			this.mcr, 	    8,		 UVM_DEC);

	printer.print_field( "iir", 			this.iir, 	    8,		 UVM_DEC);

	printer.print_field( "ier", 			this.ier, 	    8,		 UVM_DEC);

	printer.print_field( "msr", 			this.msr, 	    8,		 UVM_DEC);




foreach(thr[i])
  begin
printer.print_field($sformatf("thr[%0d]",i),		this.thr[i], 	    8,		 UVM_DEC);
end

foreach(rb[i])
begin
printer.print_field($sformatf("rb[%0d]",i),		this.rb[i], 	    8,		 UVM_DEC);

end
     endfunction

