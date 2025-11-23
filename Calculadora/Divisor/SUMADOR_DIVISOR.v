module SUMADOR_DIVISOR (
    input [15:0] A,    
    input [15:0] DR,  
    output [15:0] RES, 
    output MSB  
);

 wire [15:0] SUB;
// Resta en complemento a dos
    assign RES = A - DR;

    // Bit de signo
    assign MSB = RES[15];

endmodule

