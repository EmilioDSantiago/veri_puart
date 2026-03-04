`timescale 1ns/1ps

module tb_uart_tx;

    parameter DW_DATA = 8;
    parameter FRAME_WIDTH = 12;
    parameter BAUD = 5;

    logic clk;
    logic rst;
    logic start;
    logic [DW_DATA-1:0] data_in;
    logic tx_out;
    logic ready;

 
    Uart_tx #(
        .FRAME_WIDTH(FRAME_WIDTH),
        .DW_DATA(DW_DATA),
        .baud(BAUD)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .tx_out(tx_out),
        .ready(ready)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;
        start = 0;
        data_in = 0;

        //---------------------------------
        // Reset
        //---------------------------------
        #20;
        rst = 1;

        //---------------------------------
        // Esperar ready
        //---------------------------------
        wait (ready == 1);

        data_in = 8'b1011_0010;   
        #10;
        start = 1;
        #10;
        start = 0;   // solo 1 ciclo

        wait (ready == 1);

        #100;
        $stop;
    end

endmodule