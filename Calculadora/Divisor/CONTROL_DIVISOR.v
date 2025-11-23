module CONTROL_DIVISOR(
    input CLK,
    input START,
    input MSB,
    input Z,
    output reg DONE,
    output reg LDA,
    output reg INIT,
    output reg DV0,
    output reg SH,
    output reg DEC
);

  // DEFINICIÓN DE ESTADOS
    parameter S_START     = 3'b000;
    parameter S_CHECK     = 3'b001;
    parameter S_SHIFT_DEC = 3'b010;
    parameter S_ADD       = 3'b011;
    parameter S_END1      = 3'b100;

    reg [2:0] STATE, NEXT_STATE;

    // MAQUINA DE ESTADOS - REGISTRO DE ESTADO
always @(posedge CLK) begin
    STATE <= NEXT_STATE;
end

always @(*) begin
    case (STATE)
        S_START: begin
            if (START) NEXT_STATE = S_SHIFT_DEC;
            else       NEXT_STATE = S_START;
        end

            S_SHIFT_DEC: begin
                NEXT_STATE = S_CHECK;
            end

            S_CHECK: begin
                if (MSB && !Z)      NEXT_STATE = S_SHIFT_DEC;
                else if (!MSB)      NEXT_STATE = S_ADD;
                else if (Z)         NEXT_STATE = S_END1;
                else                NEXT_STATE = S_CHECK;
            end

            S_ADD: begin
                if (!Z) NEXT_STATE = S_SHIFT_DEC;
                else    NEXT_STATE = S_END1;
            end

            S_END1: begin
                NEXT_STATE = S_END1; // estado final
            end

            default: NEXT_STATE = S_START;
        endcase
    end

    // LÓGICA DE SALIDAS (según diagrama)
    always @(*) begin

        
        case (STATE)
            S_START: begin
                DONE = 0;
                LDA  = 0;
                INIT = 1;
                DV0  = 0;
                SH   = 0;
                DEC  = 0;
            end

            S_SHIFT_DEC: begin
                DONE = 0;
                LDA  = 0;
                INIT = 0;
                DV0  = 0;
                SH   = 1;
                DEC  = 1;
            end

            S_CHECK: begin
                DONE = 0;
                LDA  = 0;
                INIT = 0;
                DV0  = 0;
                SH   = 0;
                DEC  = 0;
            end

            S_ADD: begin
                DONE = 0;
                LDA  = 1;  
                INIT = 0;
                DV0  = 1;
                SH   = 0;
                DEC  = 0;
            end

            S_END1: begin
                DONE = 1;
                LDA  = 0;
                INIT = 0;
                DV0  = 0;
                SH   = 0;
                DEC  = 0;
            end

            default: begin
                DONE = 0;
                LDA  = 0;
                INIT = 0;
                DV0  = 0;
                SH   = 0;
                DEC  = 0;
            end
        endcase
    end

endmodule
