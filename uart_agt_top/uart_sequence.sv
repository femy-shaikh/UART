class uart_sequence extends uvm_sequence#(uart_xtn);
	`uvm_object_utils(uart_sequence)

extern function new(string name="uart_sequence");
endclass

function uart_sequence::new(string name="uart_sequence");
super.new(name);
endfunction

//////////////////////FULL DUPLEX//////////////////////////////////////////////////////////////////////////////
//////////////////////////////IT IS UART -1 SEQUENCE////////////////////////////////////////////////////
class sequence_1 extends uart_sequence;
`uvm_object_utils(sequence_1); 


extern function new(string name="sequence_1");
extern task body();

endclass

function sequence_1::new(string name="sequence_1");
super.new(name);
endfunction

task sequence_1::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
	 req=uart_xtn::type_id::create("req");
	   start_item(req);
   	   assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b10000000 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
	   `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	   finish_item(req); 

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
	    start_item(req);
     
   	   assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
	   `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	   finish_item(req); 

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
	   start_item(req);
     
   	   assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
	   `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
	   finish_item(req); 

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
	 start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});  
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

  

/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

	 start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000001 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


	 start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
 

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

	 start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


//////////////////////for RECEIVING DATA////////////////////////////////////////////////////////

///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

	 start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("RD_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

	 if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);
	  assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("RD_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end

	 if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("RD_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end

end
endtask


///////////////////////////////UART2  FOR TRANSMITING WE NEED 7 START ITEMS(change in DL LSB(for differen baud_out value and THR data_in different data we are loading)/////////////////////////////////////////////


class sequence_2 extends uart_sequence;
`uvm_object_utils(sequence_2);


extern function new(string name="sequence_2");
extern task body();

endclass

function sequence_2::new(string name="sequence_2");
super.new(name);
endfunction

task sequence_2::body();

begin

//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////

 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i==8'b10000000 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value/////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in =108 for baud_out
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////

	  start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000001 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // loading value as 4
		  `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

	get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
		start_item(req);
          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end

         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
end
endtask

/////////////////////////////////////////////HALF DUPLEX///////////////////////////////////////////////////////////////////////////
class half_dup_trans extends uart_sequence;
`uvm_object_utils(half_dup_trans);


extern function new(string name="half_dup_trans");
extern task body();

endclass

function half_dup_trans::new(string name="half_dup_trans");
super.new(name);
endfunction

task half_dup_trans::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000001 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
end
endtask
//////////////////////half duplex reception////////////////////////////
class half_dup_rec extends uart_sequence;
`uvm_object_utils(half_dup_rec);


extern function new(string name="half_dup_rec");
extern task body();

endclass

function half_dup_rec::new(string name="half_dup_rec");
super.new(name);
endfunction

task half_dup_rec::body();

begin

 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in=108
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000001 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         //start_item(req);

           //assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;});
           //`uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           //finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
end
endtask

///////////////////////////////////LOOP BACK MODE//////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////FOR UART -1///////////////////////////////////////////////////////////////////

class loop_back_seq1 extends uart_sequence;
`uvm_object_utils(loop_back_seq1);


extern function new(string name="loop_back_seq1");
extern task body();

endclass

function loop_back_seq1::new(string name="loop_back_seq1");
super.new(name);
endfunction


task loop_back_seq1::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000001 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

////////////////////////////////// LOOP back mode MCR[4] make data_in of 4 bit is equal to 1 so that PISO is connected to SIP0 of uart1////////////////////

           start_item(req);

           assert(req.randomize() with {wb_adr_i==4;wb_we_i==1;wb_dat_i==8'b00010000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
end
endtask
///////////////////////////////////////////UART-2/////////////////////////////////////////////////////////////////////////////////

class loop_back_seq2 extends uart_sequence;
`uvm_object_utils(loop_back_seq2);


extern function new(string name="loop_back_seq2");

extern task body();

endclass

function loop_back_seq2::new(string name="loop_back_seq2");
super.new(name);
endfunction


task loop_back_seq2::body();

begin

 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value/////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in =108 for baud_out
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////

          start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000001 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

////////////////////////////////// LOOP back mode MCR[4] make data_in of 4 bit is equal to 1 so that SIP0 is connected to PISO of uart2////////////////////

	   start_item(req);

           assert(req.randomize() with {wb_adr_i==4;wb_we_i==1;wb_dat_i==8'b00010000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // loading value as 4
                  `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

	  start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
        begin
        start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
        begin
        start_item(req);

          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end

end
endtask






/////////////////////////////////// ERROR SEQUENCES //////////////////////////////////////////////////////////////////////////////
////////////////////////////////// PARITY ERRORS(make changes only in LCR , IER and IIR ) /////////////////////////////////////////////////////////////////////////  UART-1 TRANSMITTER (FD) /////////////////////////////////////////////////////////////////

class parity_error_FD_U1 extends uart_sequence;
`uvm_object_utils(parity_error_FD_U1);


extern function new(string name="parity_error_FD_U1");
extern task body();

endclass

function parity_error_FD_U1::new(string name="parity_error_FD_U1");
super.new(name);
endfunction

task parity_error_FD_U1::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00001011 ;}); // make third bit has one for parity_enable and 4th bit 0 for odd parity and 5th bit 0 for stick parity
           `uvm_info("ODD_PARITY",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // make IER=4 for parity error
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;}); // we are sending 7 
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end

end
endtask


/////////////////////////////////////////////UART-2(PARITY-ERROR-FD)/////////////////////////////////////////////////////////////////////

class parity_error_FD_U2 extends uart_sequence;
`uvm_object_utils(parity_error_FD_U2);


extern function new(string name="parity_error_FD_U2");
extern task body();

endclass

function parity_error_FD_U2::new(string name="parity_error_FD_U2");
super.new(name);
endfunction

task parity_error_FD_U2::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in=108
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00011011 ;}); // make third bit has one for parity_enable and 4th bit 1 for even  parity and 5th bit 0 for stick parity
           `uvm_info("EVEN_PARITY",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // make IER=4 for parity error
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // we are sending 4
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);
	 assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
        begin
        start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end

end
endtask

//////////////////////////////////////////////////// FRAMING ERROR /////////////////////////////////////////////////////////////
////////////////////////////////////////////////// UART-1(FD) /////////////////////////////////////////////////////////////////

class frame_error_FD_U1 extends uart_sequence;
`uvm_object_utils(frame_error_FD_U1);


extern function new(string name="frame_error_FD_U1");
extern task body();

endclass

function frame_error_FD_U1::new(string name="frame_error_FD_U1");
super.new(name);
endfunction

task frame_error_FD_U1::body();

begin
///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00001000 ;}); // LCR[1:0] =00 indicates only 5 bits will be transfered  by uart-1 and 3rd bit will be 1 for extra stop bit
           `uvm_info("frame_error",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // make IER=4 for frame error
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;}); // we are sending 7
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

        if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
        begin
        start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end

end
endtask

/////////////////////////////////////////////UART-2(FRAME-ERROR-FD)/////////////////////////////////////////////////////////////////////

class frame_error_FD_U2 extends uart_sequence;
`uvm_object_utils(frame_error_FD_U2);


extern function new(string name="frame_error_FD_U2");
extern task body();

endclass

function frame_error_FD_U2::new(string name="frame_error_FD_U2");
super.new(name);
endfunction

task frame_error_FD_U2::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in=108
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00001011 ;}); // LCR[1:0]=11 indicates we are sending 8 bits of data to uart1  and 3rd bit =1 indicates extra stop bit
           `uvm_info("FRAME_ERROR_IN_UART2",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
           finish_item(req); // here only 5 bits of data is send by uart1 but uart2 will receive 8 bits of data which consider 5 bits along with start and stop bit as data bit so there will be normal error in uart-2.
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // make IER=4 for frame_error(normal interrupt)
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // we are sending 4 here 6th bit must be 0 for framing error at uart1
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
        begin
        start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end

end
endtask

///////////////////////////////////////// OVER RUN ERROR /////////////////////////////////////////////////////////////////////////////
class overrun_error_FD_U1 extends uart_sequence;
`uvm_object_utils(overrun_error_FD_U1);


extern function new(string name="overrun_error_FD_U1");
extern task body();

endclass

function overrun_error_FD_U1::new(string name="overrun_error_FD_U1");
super.new(name);
endfunction

task overrun_error_FD_U1::body();

begin
///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;}); // LCR[1:0] =11 normal overrun_error
           `uvm_info("fifo-full_normal_error",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000001 ;}); 
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////
	repeat(14)
	begin
         start_item(req);
		
           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;}); // we are sending 7
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address
//repeat(3)
//begin
        if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
	begin
     $display("the value stored in iir is %d",req.iir);
	
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
	begin
     $display("the value stored in iir is %d",req.iir);
	
        begin
        start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end
	end
//end
//endtask

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////
        repeat(3)
        begin
         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;}); // we are sending 7
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end

// total 17 bytes of data we are transmitting to uart2

end
endtask


/////////////////////////////////////////////UART-2(OVERRUN-ERROR-FD)/////////////////////////////////////////////////////////////////////

class overrun_error_FD_U2 extends uart_sequence;
`uvm_object_utils(overrun_error_FD_U2);


extern function new(string name="overrun_error_FD_U2");
extern task body();

endclass

function overrun_error_FD_U2::new(string name="overrun_error_FD_U2");
super.new(name);
endfunction

task overrun_error_FD_U2::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in=108
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;}); // LCR[1:0]=11 indicates we are sending 8 bits of data to uart1  and 3rd bit =1 indicates extra stop bit
           `uvm_info("fifo_full_error_UART2",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req); // here only 5 bits of data is send by uart1 but uart2 will receive 8 bits of data which consider 5 bits along with start and stop bit as data bit so there will be normal error in uart-2.
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

 start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // make IER=4 indicates fifo is full(16x8) so overrun error 
           `uvm_info("fifo_full_error",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // we are sending 4 as a data to uart1
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
	begin
     $display("the value stored in iir is %d",req.iir);
	
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
	begin
     $display("the value stored in iir is %d",req.iir);
	
        begin
        start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end
	end
end
endtask
//////////////////////////////////////////////// BREAK_INTREPPUT(internal reset) /////////////////////////////////////////////////////////
///////////////////////////////////////////////// UART-1 ///////////////////////////////////////////////////////////////

class breakin_FD_U1 extends uart_sequence;
`uvm_object_utils(breakin_FD_U1);


extern function new(string name="breakin_FD_U1");
extern task body();

endclass

function breakin_FD_U1::new(string name="breakin_FD_U1");
super.new(name);
endfunction

task breakin_FD_U1::body();

begin
///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b01000000 ;}); // LCR[6] =1 internal reset of fifo irrespective of what THR will have than interrupt will occur in both uarts
           `uvm_info("fifo-full_normal_error",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // 
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////
        
        
         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;}); // we are sending 7
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);



 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

        if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
        begin
        start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        end

end
endtask


/////////////////////////////////////////UART-2//////////////////////////////////////////////////////////////////////////
class breakin_FD_U2 extends uart_sequence;
`uvm_object_utils(breakin_FD_U2);


extern function new(string name="breakin_FD_U2");
extern task body();

endclass

function breakin_FD_U2::new(string name="breakin_FD_U2");
super.new(name);
endfunction

task breakin_FD_U2::body();

begin
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////

 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value/////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in =108 for baud_out
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////

          start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b01000000 ;});  //LCR[6]=1 internal reset of fifo irrespective of data(thr) we are transmitting we ger interrupt error
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000100 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // loading value as 4
                  `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

        get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

        if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);
	begin
          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
	end
         if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);
	begin
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
	end
end
endtask

///////////////////////////////////////////////////TIMEOUT CONDITION /////////////////////////////////////////////////////////
//////////////////////////////////////////////////UART -1 ///////////////////////////////////////////////////

class timeout_FD_U1 extends uart_sequence;
`uvm_object_utils(timeout_FD_U1);


extern function new(string name="timeout_FD_U1");
extern task body();

endclass

function timeout_FD_U1::new(string name="timeout_FD_U1");
super.new(name);
endfunction

task timeout_FD_U1::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000001 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110;}); // uart1 receiving 1 byte from uart2
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////
	repeat(6)
	begin
         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
	
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);
	begin
	          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
	end
        /* if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
	begin
     $display("the value stored in iir is %d",req.iir);
	
	start_item(req);
	
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	
	end*/
	 if(req.iir[3:1]==3'b110) //implise data available is wrong it has some error so now read from LSR register
	begin
     $display("the value stored in iir is %d",req.iir);
       
        start_item(req);
        
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
        
        end

end
endtask

/////////////////////////////////////////////// TIMEOUT CONDITION /////////////////////////////////////////
/////////////////////////////////////////////// UART-2 //////////////////////////////////////////////////////
class timeout_FD_U2 extends uart_sequence;
`uvm_object_utils(timeout_FD_U2);


extern function new(string name="timeout_FD_U2");
extern task body();

endclass

function timeout_FD_U2::new(string name="timeout_FD_U2");
super.new(name);
endfunction

task timeout_FD_U2::body();

begin
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////

 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value/////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in =108 for baud_out
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////

          start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000101 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////

	
         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b10000110 ;}); // uart 2 must recieve 4bytes since FCR[7:6]=01 but it recives only 3 bytes becaues uart1 will send only 3 bytes of data
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////
         start_item(req);
           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // loading value as 4
                  `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

        get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

        if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
        /* if(req.iir[3:1]==3'b011) //implise data available is wrong it has some error so now read from LSR register
	begin
     $display("the value stored in iir is %d",req.iir);
	
	start_item(req);
          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end*/
	 if(req.iir[3:1]==3'b110) //implise data available is wrong it has some error so now read from LSR register
	begin
     $display("the value stored in iir is %d",req.iir);
        
        start_item(req);
        
          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
       
        end

end
endtask

////////////////////////////////////////////// THR-EMPTY //////////////////////////////////////////////////////
/////////////////////////////////////////// UART-1//////////////////////////////////////////////////////////////////////

class thrempty_FD_U1 extends uart_sequence;
`uvm_object_utils(thrempty_FD_U1);


extern function new(string name="thrempty_FD_U1");
extern task body();

endclass

function thrempty_FD_U1::new(string name="thrempty_FD_U1");
super.new(name);
endfunction

task thrempty_FD_U1::body();

begin

///////////////////////////////UART1  FOR TRANSMITING WE NEED 7 START ITEMS/////////////////////////////////////////////
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////
 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value//////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00110110 ;});  // data_in=54
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////
         start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000010 ;}); //IER=2 indicates that after sending all data from thr fifo thr will become that output is 1(this interrupt will happen)
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000111 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


 get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
         if(req.iir[3:1]==3'b001) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
	end
end
endtask

////////////////////////////////////// THR-EMPTY  ////////////////////////////////////////////////////
//////////////////////////////////////// UART -2 /////////////////////////////////////////////////////


class thrempty_FD_U2 extends uart_sequence;
`uvm_object_utils(thrempty_FD_U2);


extern function new(string name="thrempty_FD_U2");
extern task body();

endclass

function thrempty_FD_U2::new(string name="thrempty_FD_U2");
super.new(name);
endfunction

task thrempty_FD_U2::body();

begin
//////////////////////////// selecting line control register for divisor latch loading///////////////////////////////

 req=uart_xtn::type_id::create("req");
           start_item(req);
           assert(req.randomize() with { wb_adr_i==3; wb_we_i==1; wb_dat_i[7]==1 ;}); // 7th bit of data_in is 1 than u_art start transmitting the values and write_enb=1(writing into the register) if addr=3 than the uart we will understand what register(LCR) is configured.
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

//////////////////////////////Making DL MSB as 0(7th bit of data_in)for debugging purpose////////////////////////////////////////////////////////////
            start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000000 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////load the DL(LSB) value/////////////////////////////////////////////////////////////////
           start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b01101100 ;});  // data_in =108 for baud_out
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

///////////////////////////////make 8 bit as 0 for normal operation and make data_in =3 so that we are transmiting 8 bits per character /////////////////////////////////////

          start_item(req);

           assert(req.randomize() with {wb_adr_i==3;wb_we_i==1;wb_dat_i==8'b00000011 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
/////////////////////// enable IER interrupt by making data_in =1 so that data is avaliable ////////////////////////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==1;wb_we_i==1;wb_dat_i==8'b00000010 ;}); //IER =2 this indicates that thr is empty and interrupt is high
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

/////////////////////////////////FCR reister  make 6 and 7 th bit of data_in so that we are receiving 1 byte of data from u_art and make 1 and 2 bit of data_in as 1 so that we are clearing the fifo before writing into fifo(THR,RB) /////////////////////////


         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==1;wb_dat_i==8'b00000110 ;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);


///////////////////////////////////THR register now we writing or transmiting the data(up to 255)/////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==0;wb_we_i==1;wb_dat_i==8'b00000100 ;}); // loading value as 4
                  `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
///////////////////////////////////// NOW FOR RECEIVING DATA ////////////////////////////////////////////////////////////


///////////////////////////////////IIR REGISER TO CHECK  WHETHER DATA RECEIVED IS CORRECT OR NOT///////////////////////////////////

         start_item(req);

           assert(req.randomize() with {wb_adr_i==2;wb_we_i==0;});
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);

        get_response(req);  // after recieving iir value from driver and now sequence will decide whether it should call the RB or LSR register according sequence will generate the address

         if(req.iir[3:1]==3'b010) //implies data available is correct we are reading from RB register
     $display("the value stored in iir is %d",req.iir);
begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==0;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
end
         if(req.iir[3:1]==3'b001) //implise data available is wrong it has some error so now read from LSR register
     $display("the value stored in iir is %d",req.iir);
	begin
	start_item(req);

          assert(req.randomize() with {wb_adr_i==5;wb_we_i==0; });
           `uvm_info("WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
           finish_item(req);
end
end
endtask