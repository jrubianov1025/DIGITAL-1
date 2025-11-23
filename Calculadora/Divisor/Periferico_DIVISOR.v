module Periferico_DIVISOR (
  input CLK,
  input reset,
  input [15:0] d_in,   // datos desde el bus
  input cs,            // chip select
  input [4:0] addr,    // dirección
  input rd,            // lectura
  input wr,            // escritura
  output reg [15:0] d_out // datos hacia el bus (extendidos a 32 bits)
);

  // Registros internos

  reg [15:0] DV;     // dividendo
  reg [15:0] DR;     // divisor
  reg START;         // señal de inicio
  reg [4:0] s;       // decodificador interno

  wire DONE;
  wire [15:0] R;

  // 1. Decodificador de direcciones

  always @(*) begin
    if (cs) begin
      case (addr)
        5'h04: s = 5'b00001; // DV
        5'h08: s = 5'b00010; // DR
        5'h0C: s = 5'b00100; // START
        5'h10: s = 5'b01000; // R
        5'h14: s = 5'b10000; // DONE
        default: s = 5'b00000;
      endcase
    end else 
      s = 5'b00000;
  end

  // 2. Escritura de registros

always @(posedge CLK) begin
    if (reset) begin
      START = 0;
      DV    = 0;
      DR    = 0;
   end 
  else begin
    if (cs && wr) begin
      DV    <= s[0] ? d_in    : DV;
      DR    <= s[1] ? d_in    : DR;
      START <= s[2] ? d_in[0] : START;
    end
  end
end

  // 3. Lectura de registros

 
  always @(posedge CLK) begin
    if (reset)
      d_out <= 0;
    else if (cs) begin
      case (s[4:0])
        5'b01000: d_out = R;               // Resultado
        5'b10000: d_out = {15'b0, DONE};  
      endcase
    end
  end

  // 4. Instancia del módulo divisor

  DIVISOR u_DIVISOR (
    .CLK(CLK),
    .START(START),
    .DV(DV),
    .DR(DR),
    .DONE(DONE),
    .R(R)
  );

endmodule
