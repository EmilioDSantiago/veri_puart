
module Datapath
#(
 parameter FRAME_WIDTH = 12,
 parameter DW_DATA = 8
)
(
    input  logic clk,
    input  logic rst,
    input logic baud_tick,
    input  logic load,
    input  logic tx_enable,
    input  logic [DW_DATA-1:0] data_in,

    output logic tx_done,
    output logic tx_out
);

    logic [3:0] bit_counter;
    logic parity_bit;
    logic shift_enable;   

    piso_uart #(
        .DW_DATA(DW_DATA)
    ) piso (
        .clk        (clk),
        .rst        (rst),
        .load       (load),
        .shift_enb  (shift_enable),
        .data_in    (data_in),
        .serial_out (piso_out)
    );

    assign parity_bit = ~(^data_in);
    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            bit_counter <= 0;
            tx_done <= 0;
        end
        else begin

            tx_done <= 0;

            if (load) begin
                bit_counter <= 0;
            end

            else if (baud_tick && tx_enable && bit_counter < FRAME_WIDTH) begin  
                bit_counter <= bit_counter + 1;

                if (bit_counter == FRAME_WIDTH-1) begin
                    tx_done <= 1;
                end
            end
        end
    end

    always_comb begin
        
        if (tx_enable && baud_tick) begin
            case (bit_counter)

                0:  tx_out = 1'b0;         // start
                1:  tx_out = piso_out;      // data bits
                2:  tx_out = piso_out;
                3:  tx_out = piso_out;
                4:  tx_out = piso_out;
                5:  tx_out = piso_out;
                6:  tx_out = piso_out;
                7:  tx_out = piso_out;
                8:  tx_out = piso_out;
                9:  tx_out = parity_bit;   // parity
                10: tx_out = 1'b1;         // stop bits
                11: tx_out = 1'b1;
                default: tx_out = 1'b1;
            endcase
            end
        else begin
            tx_out = 1'b1; 
        end
    end

    always_comb begin
        if(baud_tick && tx_enable && (bit_counter >= 1 && bit_counter <= 8))
            shift_enable = 1;
        else
            shift_enable = 0;
    end
endmodule