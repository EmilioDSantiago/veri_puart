
module Control_Unit

(
    input  logic rst,
    input  logic clk,
    input  logic start,
    input  logic tx_done,   

    output logic load,
    output logic tx_enable,
    output logic baud_enable,
    output logic baud_sync_rst,
    output logic ready
);

    typedef enum logic [1:0] {
        IDLE_state,
        LOAD_state,
        RUN_Tx
    } state_t;

    state_t current_state, next_state;


    always_comb begin
	 next_state = current_state;
        case (current_state)

            IDLE_state:
                if (start)
                    next_state = LOAD_state;

            LOAD_state: //load data via piso
				next_state = RUN_Tx;

            RUN_Tx: //wait unit transmission is done, when tx_done flag sets to 1
                if (tx_done)
                    next_state = IDLE_state;

        endcase
    end

	 
	 always_ff @(posedge clk or negedge rst) begin
        if (!rst)
            current_state <= IDLE_state;
        else
            current_state <= next_state;
    end
	 
	 always_comb begin

        load       = 0;
        tx_enable  = 0;
        baud_enable   = 0;
        baud_sync_rst = 0;
        ready      = 0;

        case (current_state)

            IDLE_state: begin
                ready = 1;
            end

            LOAD_state: begin
                load = 1;   // load 
                baud_sync_rst = 1; //sync rst for the counter
            end

            RUN_Tx: begin
                tx_enable = 1;
                baud_enable = 1;
            end

        endcase
    end

endmodule