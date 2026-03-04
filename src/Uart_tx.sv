module Uart_tx
#(
    parameter FRAME_WIDTH = 12,
    parameter DW_DATA     = 8,
    parameter baud    = 5
)
(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic [DW_DATA-1:0] data_in,

    output logic tx_out,
    output logic ready
);

    logic load;
    logic tx_enable;
    logic baud_enable;
    logic baud_sync_rst;
    logic baud_tick;
    logic tx_done;

    Control_Unit Cu (
        .rst(rst),
        .clk(clk),
        .start(start),
        .tx_done(tx_done),
        .load(load),
        .tx_enable(tx_enable),
        .baud_enable(baud_enable),
        .baud_sync_rst(baud_sync_rst),
        .ready(ready)
    );

    Baud_gen #(
        .baud(baud)
    ) baud_gen (
        .clk(clk),
        .rst(rst),
        .start_count(baud_enable),
        .sync_rst(baud_sync_rst),
        .baud_tick(baud_tick)
    );

    Datapath #(
        .FRAME_WIDTH(FRAME_WIDTH),
        .DW_DATA(DW_DATA)
    ) Dp (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .load(load),
        .tx_enable(tx_enable),
        .data_in(data_in),
        .tx_done(tx_done),
        .tx_out(tx_out)
    );

endmodule