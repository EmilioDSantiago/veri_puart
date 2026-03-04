module Baud_gen
#(
    parameter baud = 5
)
(
    input logic clk,
    input logic rst,
    input logic sync_rst,
    input logic start_count,


    output logic baud_tick
);
    logic [(baud-2):0] counter;

    always_ff @(posedge clk or negedge rst) begin
        if(!rst) begin
            counter <= 0;
            baud_tick <= 0;
        end
        else begin
            if (sync_rst) begin //this should 
                counter   <= 0;
                baud_tick <= 0;
            end

            else if (start_count) begin
                if (counter == baud-1) begin
                    counter   <= 0;
                    baud_tick <= 1;   //1 baud each 5 clk pulses
                end
                else begin
                    counter   <= counter + 1;
                    baud_tick <= 0;
                end
            end
            else begin
                counter   <= 0;
                baud_tick <= 0;
            end
        end
    end

endmodule
