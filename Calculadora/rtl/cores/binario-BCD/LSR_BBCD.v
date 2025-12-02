module LSR_BBCD (
    input CLK,
    input SH,
    input LD,

    input  [15:0] Op_A_in,    // valor binario de entrada 

 // Entradas desde los sumadores (nuevos valores de cada nibble)
    input  [3:0] UNITN,
    input  [3:0] DECN,
    input  [3:0] CENTN,
    input  [3:0] MILN,

  // Salidas: nibbles actuales de A
    output [3:0]UNIT,
    output [3:0]DEC,
    output [3:0]CENT,
    output [3:0]MIL
    

);  
    reg [15:0] A;
    reg [15:0] Op_A;
    
    assign UNIT = A[3:0];     // bits 3 a 0
    assign DEC  = A[7:4];     // bits 7 a 4
    assign CENT = A[11:8];    // bits 11 a 8
    assign MIL  = A[15:12];   // bits 15 a 12

    always @(posedge CLK) begin
      if (LD) begin
            // Inicializa los registros
            A    <= 16'd0;
            Op_A <= Op_A_in;
        end
        
        else begin
            if (SH) begin
                {A, Op_A} <= {A, Op_A} << 1;
            end
            else begin
                A[3:0]   <= UNITN;
                A[7:4]   <= DECN;
                A[11:8]  <= CENTN;
                A[15:12] <= MILN;
            end
        end
    end

endmodule