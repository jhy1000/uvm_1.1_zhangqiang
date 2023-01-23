
interface my_if(input logic rxc, input logic txc);

    logic [7:0] rxd;
    logic       rx_dv;
    logic [7:0] txd;
    logic       tx_en;

    // from model to dut
    clocking drv_cb @(posedge rxc);
        output #1 rxd, rx_dv;
    endclocking

    clocking mon_cb @(posedge txc);
        input #1 txd, tx_en;
    endclocking
endinterface


