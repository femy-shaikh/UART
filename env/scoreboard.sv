class scoreboard extends uvm_scoreboard;

`uvm_component_utils(scoreboard)

uvm_tlm_analysis_fifo #(uart_xtn)fifo_uarth[];
uart_xtn u_data1,u_data2;
uart_xtn u_cov_data1,u_cov_data2;
uart_env_config e_cfg;
uart_xtn xtn;
int xtns_compared;

covergroup uart_fcov1;
    option.per_instance=1;

//address
ADD: coverpoint u_cov_data1.wb_adr_i{
                                    bins b1 = {0,1,2,3,4,5};
}

CHAR: coverpoint u_cov_data1.lcr[1:0]{
                                     bins b4 = {2'b11};

}

STOP_BITS: coverpoint u_cov_data1.lcr[2]{
                                    bins b1 = {0,1};
}

PARITY: coverpoint u_cov_data1.lcr[3]{
                                    bins b1 = {0,1};
}

EVEN_ODD_P: coverpoint u_cov_data1.lcr[4]{
                                    bins b1 = {0,1};
}

STICK_P: coverpoint u_cov_data1.lcr[5]{
                                    bins b1 = {0,1};
}

BREAK_CONTROL: coverpoint u_cov_data1.lcr[6]{
                                    bins b1 = {0};
}

WR_EN: coverpoint u_cov_data1.wb_we_i;

endgroup

covergroup uart_fcov2;
    option.per_instance=1;

//address
ADD: coverpoint u_cov_data2.wb_adr_i{
                                    bins b1 = {0,1,2,3,4,5};
}

CHAR: coverpoint u_cov_data2.lcr[1:0]{
                                      bins b4 = {2'b11};

}

STOP_BITS: coverpoint u_cov_data2.lcr[2]{
                                    bins b1 = {0,1};
}

PARITY: coverpoint u_cov_data2.lcr[3]{
                                    bins b1 = {0,1};
}

EVEN_ODD_P: coverpoint u_cov_data2.lcr[4]{
                                    bins b1 = {0,1};
}

STICK_P: coverpoint u_cov_data2.lcr[5]{
                                    bins b1 = {0,1};
}

BREAK_CONTROL: coverpoint u_cov_data2.lcr[6]{
                                    bins b1 = {0};
}

WR_EN: coverpoint u_cov_data2.wb_we_i;

endgroup


extern function new(string name = "scoreboard",uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern function void compare();
extern function void report_phase(uvm_phase phase);
endclass

//Constuctor
function scoreboard::new(string name = "scoreboard",uvm_component parent=null);
    super.new(name,parent);
    uart_fcov1 = new;
    uart_fcov2 = new;

endfunction

//Build_phase
function void scoreboard::build_phase(uvm_phase phase);
    if(!uvm_config_db #(uart_env_config)::get(this,"","uart_env_config",e_cfg))
        `uvm_fatal("SCOREBOARD","cannot get e_cfg from uvm_config_db. Have you set it?")
            fifo_uarth = new[e_cfg.no_of_agents];

    foreach(fifo_uarth[i])
        begin
            fifo_uarth[i]=new($sformatf("fifo_uarth[%0d]*",i),this);
        end
            u_data1 = uart_xtn::type_id::create("u_data1");
            u_data2 = uart_xtn::type_id::create("u_data2");
            xtn = uart_xtn::type_id::create("xtn");
    super.build_phase(phase);

endfunction

//Run_phase

task scoreboard::run_phase(uvm_phase phase);
fork
        forever
                begin
                $display("before gettig from fifo1");
                fifo_uarth[0].get(u_data1);
                $display("while getting from fifo1");
                //u_data1.print;
                u_cov_data1 = u_data1;
                uart_fcov1.sample();


                end
        forever
                begin
                $display("before gettig from fifo2");
                fifo_uarth[1].get(u_data2);
                $display("while getting from fifo2");
                //u_data2.print;
                u_cov_data2 = u_data2;
                uart_fcov2.sample();
                compare();
                end
         //compare();

join
endtask

function void scoreboard::compare();
//if(u_data1.mcr[4]==1'b0 && u_data2.mcr[4]==0)


$display("checking FD OR HD");

  //               if(u_data1.thr[0]==8'b1  && u_data2.thr[0]==8'b1)

    //    begin
      //$display("it is FD");

                         if((u_data1.thr==u_data2.rb) && (u_data2.thr==u_data1.rb)) //full duplex
                                begin
                                $display("it is FD");
                                `uvm_info(get_type_name(), $sformatf("Scoreboard(full_duplex) - Data Match successful"), UVM_MEDIUM)
                                xtns_compared++ ;
                                end

                         else
                               `uvm_error(get_type_name(), $sformatf("\n Scoreboard(full_duplex) Error [Data Mismatch]: \n"))
                        

        //          if(u_data1.thr[0]==8'b1  && u_data2.thr[0]==8'b0)
                       // begin
                         if((u_data1.thr==u_data2.rb) || (u_data2.thr==u_data1.rb)) //half duplex
                                begin
                                `uvm_info(get_type_name(), $sformatf("Scoreboard(half_duplex) - Data Match successful"), UVM_MEDIUM)
                                xtns_compared++ ;
                                end
                         else
                                 `uvm_error(get_type_name(), $sformatf("\n Scoreboard(half_duplex) Error [Data Mismatch]: \n"))
                        



      if(u_data1.mcr[4]==1'b1 && u_data2.mcr[4]==1)
begin

        if ((u_data1.thr==u_data1.rb) && (u_data2.thr==u_data2.rb))//loop back
          begin
                `uvm_info(get_type_name(), $sformatf("Scoreboard(loop_back) - Data Match successful"), UVM_MEDIUM)
                 xtns_compared++ ;
          end
         else
                `uvm_info(get_type_name(), $sformatf("\n Scoreboard(loop_back) Error [Data Mismatch]: \n"),UVM_MEDIUM)
end


        if(u_data1.lsr[1]==1 || u_data2.lsr[1]==1) //overrun error
                         `uvm_info(get_type_name(), $sformatf("lsr 2nd bit is high------overrun error"),UVM_MEDIUM)


        if(u_data1.lsr[2]==1|| u_data2.lsr[2]==1) //parity error
                         `uvm_info(get_type_name(), $sformatf("lsr 3Rd bit is high------parity error"),UVM_MEDIUM)


        if(u_data1.lsr[3]==1|| u_data2.lsr[3]==1) //framing error
                         `uvm_info(get_type_name(), $sformatf("lsr 4th bit is high------framing error"),UVM_MEDIUM)

        if(u_data1.lsr[4]==1|| u_data2.lsr[4]==1) //break interrupt
                         `uvm_info(get_type_name(), $sformatf("lsr 5th bit is high------break interrupt error"),UVM_MEDIUM)


        if(u_data1.lsr[6]==1|| u_data2.lsr[6]==1) //THR empty
                         `uvm_info(get_type_name(), $sformatf("lsr 6th bit is high------THR EMPTY error"),UVM_MEDIUM)

        if(u_data1.iir[2:2]==2'b11 ||u_data2.iir[2:1]==2'b11)
                        `uvm_info(get_type_name(), $sformatf("iir bit 1 and 2  is high------TIME OUT error"),UVM_MEDIUM)



endfunction


//Report phase
function void scoreboard::report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("MSTB: Simulation Report from ScoreBoard \n Number of Transactions compared : %0d \n\n",xtns_compared), UVM_LOW)
endfunction
