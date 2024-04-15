
`timescale 1ns/10ps


module top;

        import uart_pkg::*;
        import uvm_pkg::*;

        bit clock1;
        bit clock2;

        always
                #10 clock1=~clock1;


        always
                #5 clock2 = ~clock2;


        uart_if in0(clock1);
        uart_if in1(clock2);

wire stx,srx;


uart_top DUT1(.wb_clk_i(clock1),.wb_rst_i(in0.wb_rst_i),.wb_adr_i(in0.wb_adr_i),.wb_dat_i(in0.wb_dat_i),.wb_dat_o(in0.wb_dat_o),
                .wb_we_i(in0.wb_we_i),.wb_stb_i(in0.wb_stb_i),.wb_cyc_i(in0.wb_cyc_i),.wb_ack_o(in0.wb_ack_o),.wb_sel_i(in0.wb_sel_i),
                .int_o(in0.int_o),.stx_pad_o(stx),.srx_pad_i(srx),.baud_o(in0.baud_o));


uart_top DUT2(.wb_clk_i(clock2),.wb_rst_i(in1.wb_rst_i),.wb_adr_i(in1.wb_adr_i),.wb_dat_i(in1.wb_dat_i),.wb_dat_o(in1.wb_dat_o),
                .wb_we_i(in1.wb_we_i),.wb_stb_i(in1.wb_stb_i),.wb_cyc_i(in1.wb_cyc_i),.wb_ack_o(in1.wb_ack_o),.wb_sel_i(in1.wb_sel_i),
                .int_o(in1.int_o),.stx_pad_o(srx),.srx_pad_i(stx),.baud_o(in1.baud_o));

        initial
        begin
                uvm_config_db #(virtual uart_if)::set(null,"*","uart_if0",in0);
                 uvm_config_db #(virtual uart_if)::set(null,"*","uart_if1",in1);


                run_test();
    end
endmodule