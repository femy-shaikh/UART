
class virtual_sequence extends uvm_sequence #(uvm_sequence_item);

        `uvm_object_utils(virtual_sequence)

         virtual_sequencer vsqrh;

        uart_sequencer u_seqrh[];

        uart_env_config e_cfg;

        sequence_1 fd1;
        sequence_2 fd2;

        half_dup_trans hd1;
        half_dup_rec  hd2;

        loop_back_seq1 lb1;
        loop_back_seq2 lb2;

        parity_error_FD_U1 pr1;
        parity_error_FD_U2 pr2;

        frame_error_FD_U1 fr1;
        frame_error_FD_U2 fr2;

        overrun_error_FD_U1 or1;
        overrun_error_FD_U2 or2;

        breakin_FD_U1 br1;
        breakin_FD_U2 br2;

        timeout_FD_U1 to1;
        timeout_FD_U2 to2;

        thrempty_FD_U1 tr1;
        thrempty_FD_U2 tr2;

 extern function new(string name="virtual_sequence");
        extern task body();
endclass

function virtual_sequence::new(string name="virtual_sequence");
        super.new(name);
endfunction

task virtual_sequence::body();
        if(!uvm_config_db #(uart_env_config)::get(null,get_full_name(),"uart_env_config",e_cfg))
                `uvm_fatal("CONFIG","Cannot get env_config from uvm_config_db.Have you set it?")

        u_seqrh=new[e_cfg.no_of_agents];


        assert($cast(vsqrh,m_sequencer))
        else
        begin
                `uvm_error("BODY","Error in $cast of virtual sequencer")
        end

        foreach(u_seqrh[i])
               u_seqrh[i]=vsqrh.u_seqrh[i];

endtask

/////// full duplex//////////////////////////
class vseq extends virtual_sequence;
`uvm_object_utils(vseq)

extern function new(string name = "vseq");
extern task body();
endclass

function vseq::new(string name ="vseq");
                super.new(name);
endfunction

task vseq::body();
 super.body();
                        fd1=sequence_1::type_id::create("fd1");
                         fd2=sequence_2::type_id::create("fd2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                fd1.start(u_seqrh[0]);
                                                fd2.start(u_seqrh[1]);
                                        join
                                //end



       endtask
/////////////////////half duplex////////////////////////////////////////////
class half_dub_seq extends virtual_sequence;
`uvm_object_utils(half_dub_seq)

extern function new(string name = "half_dub_seq");
extern task body();
endclass

function half_dub_seq::new(string name ="half_dub_seq");
                super.new(name);
endfunction

task half_dub_seq::body();
 super.body();
                        hd1=half_dup_trans::type_id::create("hd1");
                         hd2=half_dup_rec::type_id::create("hd2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                hd1.start(u_seqrh[0]);
                                                hd2.start(u_seqrh[1]);
                                        join
                                //end



       endtask

////////////////////////loop back mode//////////////////////////////////////////////////////////////////
class loop_back_seq extends virtual_sequence;
`uvm_object_utils(loop_back_seq)

extern function new(string name = "loop_back_seq");
extern task body();
endclass

function loop_back_seq::new(string name ="loop_back_seq");
                super.new(name);
endfunction

task loop_back_seq::body();
 super.body();
                        lb1=loop_back_seq1::type_id::create("lb1");
                         lb2=loop_back_seq2::type_id::create("lb2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                lb1.start(u_seqrh[0]);
                                                lb2.start(u_seqrh[1]);
                                        join
                                //end



       endtask

///////////
class parity_err_FD_U extends virtual_sequence;
`uvm_object_utils(parity_err_FD_U)

extern function new(string name = "parity_err_FD_U");
extern task body();
endclass

function parity_err_FD_U::new(string name ="parity_err_FD_U");
                super.new(name);
endfunction

task parity_err_FD_U::body();
 super.body();
                        pr1=parity_error_FD_U1::type_id::create("pr1");
                         pr2=parity_error_FD_U2::type_id::create("pr2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                pr1.start(u_seqrh[0]);
                                                pr2.start(u_seqrh[1]);
                                        join
                                //end



       endtask



class frame_err_FD_U extends virtual_sequence;
`uvm_object_utils(frame_err_FD_U)

extern function new(string name = "frame_err_FD_U");
extern task body();
endclass

function frame_err_FD_U::new(string name ="frame_err_FD_U");
                super.new(name);
endfunction

task frame_err_FD_U::body();
 super.body();
                        fr1=frame_error_FD_U1::type_id::create("fr1");
                         fr2=frame_error_FD_U2::type_id::create("fr2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                fr1.start(u_seqrh[0]);
                                                fr2.start(u_seqrh[1]);
                                        join
                                //end



       endtask

class overrun_err_FD_U extends virtual_sequence;
`uvm_object_utils(overrun_err_FD_U)

extern function new(string name = "overrun_err_FD_U");
extern task body();
endclass

function overrun_err_FD_U::new(string name ="overrun_err_FD_U");
                super.new(name);
endfunction

task overrun_err_FD_U::body();
 super.body();
                        or1=overrun_error_FD_U1::type_id::create("or1");
                         or2=overrun_error_FD_U2::type_id::create("or2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                or1.start(u_seqrh[0]);
                                                or2.start(u_seqrh[1]);
                                        join
                                //end



       endtask


class break_FD_U extends virtual_sequence;
`uvm_object_utils(break_FD_U)

extern function new(string name = "break_FD_U");
extern task body();
endclass

function break_FD_U::new(string name ="break_FD_U");
                super.new(name);
endfunction

task break_FD_U::body();
 super.body();
                        br1=breakin_FD_U1::type_id::create("br1");
                         br2=breakin_FD_U2::type_id::create("br2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                br1.start(u_seqrh[0]);
                                                br2.start(u_seqrh[1]);
                                        join
                                //end



       endtask


class timeout_FD_U extends virtual_sequence;
`uvm_object_utils(timeout_FD_U)

extern function new(string name = "timeout_FD_U");
extern task body();
endclass

function timeout_FD_U::new(string name ="timeout_FD_U");
                super.new(name);
endfunction

task timeout_FD_U::body();
 super.body();
                        to1=timeout_FD_U1::type_id::create("to1");
                         to2=timeout_FD_U2::type_id::create("to2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                to1.start(u_seqrh[0]);
                                                to2.start(u_seqrh[1]);
                                        join
                                //end



       endtask



class thrempty_FD_U extends virtual_sequence;
`uvm_object_utils(thrempty_FD_U)

extern function new(string name = "thrempty_FD_U");
extern task body();
endclass

function thrempty_FD_U::new(string name ="thrempty_FD_U");
                super.new(name);
endfunction

task thrempty_FD_U::body();
 super.body();
                        tr1=thrempty_FD_U1::type_id::create("tr1");
                         tr2=thrempty_FD_U2::type_id::create("tr2");

//if(m_cfg.has_magt)
                                   //  begin
                                        fork

                                                tr1.start(u_seqrh[0]);
                                                tr2.start(u_seqrh[1]);
                                        join
                                //end



       endtask




