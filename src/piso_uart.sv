module piso_uart
#(
    parameter DW_DATA = 8
)
(
    input  logic clk,
    input  logic rst,
    input  logic load,
    input  logic shift_enb,
    input  logic [DW_DATA-1:0] data_in,
    output logic serial_out
);

    logic [DW_DATA-1:0] registr_nxt;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            registr_nxt <= '0;

        else if (load)
            registr_nxt <= data_in;

        else if (shift_enb)
            registr_nxt <= {1'b0, registr_nxt[DW_DATA-1:1]};  // shift right
    end

    assign serial_out = registr_nxt[0];  // LSB first

endmodule