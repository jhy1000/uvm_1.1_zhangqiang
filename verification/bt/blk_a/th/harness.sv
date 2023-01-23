
module harness;

    reg clk;
    my_if my_my_if(clk, clk);
    dut my_dut(.clk(clk),
               .rxd(my_my_if.rxd),
               .rx_dv(my_my_if.rx_dv),
               .txd(my_my_if.txd),
               .tx_en(my_my_if.tx_en)
    );

    initial begin
        clk = 0;
        forever begin
            #10; clk = ~clk;
        end
    end

    initial begin
        uvm_config_db #(virtual my_if)::set(null,"uvm_test_top.env.i_agt.drv", "my_if", my_my_if);
        uvm_config_db #(virtual my_if)::set(null,"uvm_test_top.env.o_agt.mon", "my_if", my_my_if);
        run_test();
    end
endmodule

