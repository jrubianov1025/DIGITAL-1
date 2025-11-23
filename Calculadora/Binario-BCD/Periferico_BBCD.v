module Periferico_BinarioABCD (
  input CLK,
  input reset,
  input [15:0] d_in,    // dato de entrada desde el bus
  input cs,             // chip select
  input [5:0] addr,     // dirección del registro (más ancha para 0x1C)
  input rd,             // lectura
  input wr,             // escritura
  output reg [15:0] d_out // salida hacia el bus (extendida a 32 bits)
);


  // Registros internos

  reg [3:0] s;             // Selector (decodificador)
  reg [15:0] Op_A;         // Número binario de entrada
  reg INIT;                // Señal de inicio

  wire [3:0] UNIT;
  wire [3:0] DEC;
  wire [3:0] CENT;
  wire [3:0] MIL;
  wire DONE;

  wire [15:0] RESULT;
  assign RESULT = {MIL, CENT, DEC, UNIT};
  // 1. Decodificador de direcciones

  always @(*) begin
    if (cs) begin
      case (addr)
        6'h04: s = 4'b0001; // Op_A
        6'h08: s = 4'b0010; // INIT
        6'h0C: s = 4'b0100; // RESULT
        6'h10: s = 4'b1000; // DONE 
        default: s = 4'b0000;
      endcase
    end else
      s = 4'b0000;
  end

  // 2. Escritura de registros

  always @(posedge CLK) begin
    if (reset) begin
      Op_A <= 0;
      INIT <= 0;
    end
    else begin
      if (cs && wr) begin
		   Op_A = s[0] ? d_in    : Op_A;	//Write Registers
		   INIT = s[1] ? d_in[0] : INIT;
      end
    end
  end

  // 3. Lectura de registros

  always @(posedge CLK) begin
    if (reset)
      d_out <= 0;
    else if (cs) begin
      case (s[3:0])
        4'b0100: d_out <= {16'b0, RESULT};   
        4'b1000: d_out <= {31'b0, DONE};     
        default: d_out <= 32'b0;
      endcase
    end
  end

  // 4. Instancia del módulo BinarioABCD

  BinarioABCD u_BinarioABCD (
    .CLK(CLK),
    .Op_A(Op_A),
    .INIT(INIT),
    .UNIT(UNIT),
    .DEC(DEC),
    .CENT(CENT),
    .MIL(MIL),
    .DONE(DONE)
  );

endmodule
