module DIVISOR(
    input CLK,
    input START,
    input [15:0] DV,   // dividendo
    input [15:0] DR,   // divisor
    
    output DONE,
    output [15:0] R    // cociente final
);

    // Señales internas
    wire W_SH;
    wire W_INIT;
    wire W_LDA;
    wire W_DV0;
    wire W_DEC;
    wire W_MSB;
    wire W_Z;
    wire [15:0] W_RES;
    wire [15:0] W_A;
    wire [15:0] W_DV;     
    wire [4:0]  W_COUNT;

    // REGISTRO DE DESPLAZAMIENTO
    SHIFT_DEC_DIVISOR SHIFT_DEC_DIVISOR0 (
        .CLK(CLK),
        .DV0(W_DV0),
        .INIT(W_INIT),
        .SH(W_SH),
        .DV_IN(DV),     
        .LDA(W_LDA),
        .RES(W_RES),
        .DV(W_DV),      
        .R(R),
        .A(W_A),
        .MSB(W_MSB),
        .Z(W_Z)
    );

    // SUMADOR (A - DR)
    SUMADOR_DIVISOR SUMADOR_DIVISOR0 (
        .A(W_A),
        .DR(DR),
        .RES(W_RES),
        .MSB(W_MSB)
    );

    // CONTADOR DESCENDENTE
    CONTADOR_DIVISOR CONTADOR_DIVISOR0 (
        .CLK(CLK),
        .INIT(W_INIT),
        .DEC(W_DEC),
        .COUNT(W_COUNT)
    );

    // COMPARADOR DE FIN DE CICLO
    COMPARADOR_DIVISOR COMPARADOR_DIVISOR0 (
        .COUNT(W_COUNT),
        .Z(W_Z)
    );

    // UNIDAD DE CONTROL
    CONTROL_DIVISOR CONTROL_DIVISOR0 (
        .CLK(CLK),
        .START(START),
        .MSB(W_MSB),
        .Z(W_Z),
        .SH(W_SH),
        .INIT(W_INIT),
        .LDA(W_LDA),
        .DV0(W_DV0),
        .DEC(W_DEC),
        .DONE(DONE)
    );

endmodule

