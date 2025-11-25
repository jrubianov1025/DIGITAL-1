  module CONTROL_RAIZ(
    input CLK,
    input MSB,
    input Z,
    input INIT,

    output reg LDA2,
    output reg LD,
    output reg SH,
    output reg R0,
    output reg LD_TMP,
    output reg DONE
  );    


// DEFINICIÓN DE ESTADOS
    parameter S_START     = 3'b000;
    parameter S_SHIFT_DEC = 3'b001;
    parameter S_LOAD_TMP  = 3'b010;
    parameter S_CHECK     = 3'b011;
    parameter S_CHECK_Z   = 3'b100;
    parameter S_LOAD_0     =3'b101;
    parameter S_LOAD_A2   = 3'b110;
    parameter S_END1      = 3'b111;
    
    reg [2:0] NEXT_STATE;
    reg [5:0] count;

    // MAQUINA DE ESTADOS - REGISTRO DE ESTADO
  
    always @(posedge CLK) begin

        case (NEXT_STATE)
               
            S_START: begin
                if (INIT)  NEXT_STATE = S_SHIFT_DEC;
                else       NEXT_STATE = S_START;
                count = 0;
            end

            S_SHIFT_DEC: begin
                NEXT_STATE = S_LOAD_TMP;
            end

            S_LOAD_TMP: begin
                NEXT_STATE = S_CHECK;
            end

            S_CHECK: begin
                if (MSB)        NEXT_STATE = S_LOAD_0;
                else if (!MSB)  NEXT_STATE = S_LOAD_A2;
            end

            S_LOAD_0: begin
                NEXT_STATE = S_CHECK_Z;

            end
            S_LOAD_A2: begin
                NEXT_STATE = S_CHECK_Z;
            end
            
            S_CHECK_Z: begin
                if (!Z)        NEXT_STATE = S_SHIFT_DEC;
                else if (Z)    NEXT_STATE = S_END1;
            end
            
            S_END1: begin
              count = count + 1;
              NEXT_STATE = (count>30) ? S_START : S_END1;
            end

            default: NEXT_STATE = S_START;
        endcase
    end

    // LÓGICA DE SALIDAS (según diagrama)
    always @(*) begin
      case (NEXT_STATE)

        S_START: begin
          DONE   = 0;
          LD_TMP = 0;
          R0     = 0;  
          SH     = 0;
          LD     = 1;
          LDA2   = 0;
        end

        S_SHIFT_DEC: begin
          DONE   = 0;
          LD_TMP = 0;
          R0     = 0;  
          SH     = 1;
          LD     = 0;
          LDA2   = 0;
        end

        S_LOAD_TMP: begin
          DONE   = 0;
          LD_TMP = 1;
          R0     = 0;  
          SH     = 0;
          LD     = 0;
          LDA2   = 0;
        end

        S_CHECK: begin
          DONE   = 0;
          LD_TMP = 0;
          R0     = 0;  
          SH     = 0;
          LD     = 0;
          LDA2   = 0;
        end
        
        S_LOAD_0: begin
          DONE   = 0;
          LD_TMP = 0;
          R0     = 0;  
          SH     = 0;
          LD     = 0;
          LDA2   = 1;
        end

        S_LOAD_A2: begin
          DONE   = 0;
          LD_TMP = 0;
          R0     = 1;  
          SH     = 0;
          LD     = 0;
          LDA2   = 1;
        end

        S_CHECK_Z: begin
          DONE   = 0;
          LD_TMP = 0;
          R0     = 0;  
          SH     = 0;
          LD     = 0;
          LDA2   = 0;
        end

        S_END1: begin
          DONE   = 1;
          LD_TMP = 0;
          R0     = 0;  
          SH     = 0;
          LD     = 0;
          LDA2   = 0;
        end

        default: begin
          DONE   = 0;
          LD_TMP = 0;
          R0     = 0;  
          SH     = 0;
          LD     = 0;
          LDA2   = 0;
        end

      endcase
    end

endmodule
