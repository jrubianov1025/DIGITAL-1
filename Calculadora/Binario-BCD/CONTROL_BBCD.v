  module CONTROL_BBCD(
    input CLK,
    input MSB,
    input Z,
    input INIT,

    output reg LD,
    output reg DEC,
    output reg SH,
    output reg ADD3,
    output reg DONE
  );    
    
  // DEFINICIÓN DE ESTADOS
    parameter S_START     = 3'b000;
    parameter S_SUM       = 3'b001;
    parameter S_SHIFT_DEC = 3'b010;
    parameter S_CHECK     = 3'b011;
    parameter S_END1      = 3'b100;
    
    reg [2:0] NEXT_STATE;
    reg [5:0] count;

    // MAQUINA DE ESTADOS - REGISTRO DE ESTADO

always @(posedge CLK) begin
    
  case (NEXT_STATE)
  
    S_START: begin
      count = 0;
      if (INIT)  NEXT_STATE = S_SUM;
      else       NEXT_STATE = S_START;
 
    end

    S_SUM: begin
    NEXT_STATE = S_SHIFT_DEC;
    end

    S_SHIFT_DEC: begin
      NEXT_STATE = S_CHECK;
    end

    S_CHECK: begin
        if (Z)                    NEXT_STATE = S_END1;
        else if (!MSB && !Z)      NEXT_STATE = S_SHIFT_DEC;
        else if (MSB && !Z)       NEXT_STATE = S_SUM;
        else                      NEXT_STATE = S_CHECK;
    end

    S_END1: begin
      count = count + 1;
      if (count > 30)
      	NEXT_STATE = S_START;
      else
      	NEXT_STATE = S_END1;
    end

    default: NEXT_STATE = S_START;
  endcase
end

    // LÓGICA DE SALIDAS (según diagrama)
    always @(*) begin
      case (NEXT_STATE)

        S_START: begin
          DONE = 0;
          SH   = 0;
          DEC  = 0;
          LD   = 1;
          ADD3 = 0;
        end

        S_SUM: begin
          DONE = 0;
          SH   = 0;
          DEC  = 0;
          LD   = 0;
          ADD3 = 1; 
        end

        S_SHIFT_DEC: begin
          DONE = 0;
          SH   = 1;
          DEC  = 1;
          LD   = 0;
          ADD3 = 0;
        end

        S_CHECK: begin
          DONE = 0;
          SH   = 0;
          DEC  = 0;
          LD   = 0;
          ADD3 = 0;
        end

        S_END1: begin
          DONE = 1;
          SH   = 0;
          DEC  = 0;
          LD   = 0;
          ADD3 = 0;
        end

        default: begin
          DONE = 0;
          SH   = 0;
          LD   = 0;
          DEC  = 0;
          ADD3 = 0;
        end

      endcase
    end

endmodule
