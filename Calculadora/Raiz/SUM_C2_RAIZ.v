module SUM_C2_RAIZ (
    input [15:0] A_out,    
    input [15:0] TMP_out,   

    output MSB,    
    output [15:0] SUM_C2
);

 wire [15:0] TMP_shift;

    // Desplaza TMP_out dos bit a la izquierda y suma un '1'
    assign TMP_shift = (TMP_out << 2) + 1;

    // Resta en complemento a dos: A_out - TMP_shift
    assign SUM_C2 = A_out - TMP_shift;

    // Bit de signo (MSB)
    assign MSB = SUM_C2[15];

endmodule
