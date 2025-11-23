module Periferico_raiz (
  input CLK,
  input reset,
  input [15:0] d_in,    // dato de entrada desde el bus
  input cs,             // chip select
  input [4:0] addr,     // dirección (desde el bus)
  input rd,             // lectura
  input wr,             // escritura
  output reg [15:0] d_out // salida hacia el bus (extendida a 32 bits)
);

  // Registros internos

  reg [4:0] s;           // Selector de registro (decodificación)
  reg [15:0] Op_A;       // Operando de entrada
  reg INIT;              // Señal de inicio del cálculo

  wire [15:0] Resultado; // Resultado de la raíz
  wire DONE;             // Bandera de finalización

  // 1. Decodificador de direcciones

  always @(*) begin
    if (cs) begin
      case (addr)
        5'h04: s = 5'b00001; // Op_A
        5'h08: s = 5'b00010; // INIT
        5'h0C: s = 5'b00100; // Resultado
        5'h10: s = 5'b01000; // DONE
        default: s = 5'b00000;
      endcase
    end else begin
      s = 5'b00000;
    end
  end

  // 2. Escritura de registros

  always @(posedge CLK) begin
    if (reset) begin
      Op_A <= 0;
      INIT <= 0;
    end else if (cs && wr) begin
      if (s[0]) Op_A <= d_in;     // Escribir operando
      if (s[1]) INIT <= d_in[0];  // Escribir bit de inicio
    end
  end

  // 3. Lectura de registros

  always @(posedge CLK) begin
    if (reset) begin
      d_out <= 0;
    end else if (cs && rd) begin
      case (s)
        5'b00100: d_out <= {16'b0, Resultado};  // Lectura del resultado
        5'b01000: d_out <= {31'b0, DONE};       // Lectura del estado
        default:  d_out <= 32'b0;
      endcase
    end
  end

  // 4. Instancia del módulo de raíz

  RAIZ u_RAIZ (
    .CLK(CLK),
    .INIT(INIT),
    .Op_A(Op_A),
    .DONE(DONE),
    .Resultado(Resultado)
  );

endmodule
