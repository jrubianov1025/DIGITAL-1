module RAIZ(
    input CLK,
    input INIT,
    input [15:0] Op_A,   // Numero para la raiz
   
    output DONE,
    output [15:0] Resultado   
);

    // Señales internas
    wire W_LDA2;
    wire W_LD;
    wire W_SH;
    wire W_R0;
    wire W_LD_TMP;
    wire W_MSB;
    wire W_Z;

    wire [15:0] W_SUM_C2;
    wire [15:0] W_A_out;
    wire [15:0] W_TMP_out;

CONTROL_RAIZ CONTROL_RAIZ0(
        .CLK(CLK),
        .MSB(W_MSB),
        .Z(W_Z),
        .INIT(INIT),

        .LDA2(W_LDA2),
        .LD(W_LD),
        .SH(W_SH),
        .R0(W_R0),
        .LD_TMP(W_LD_TMP),
        .DONE(DONE)
);

COUNT_RAIZ COUNT_RAIZ0(
        .CLK(CLK),
        .LD(W_LD),
        .SH(W_SH),
        .Z(W_Z)
);

LSR_A_RAIZ LSR_A_RAIZ0(
        .CLK(CLK),
        .LD(W_LD),
        .LDA2(W_LDA2),
        .SH(W_SH),
        .MSB(W_MSB),

        .Op_A(Op_A),
        .SUM_C2(W_SUM_C2),

        .A_out(W_A_out)
);

LSR_R_RAIZ LSR_R_RAIZ0(
        .CLK(CLK),
        .LD(W_LD),
        .R0(W_R0),
        .LDA2(W_LDA2),

        .Resultado(Resultado)
);

LSR_TMP_RAIZ LSR_TMP_RAIZ0(
        .CLK(CLK),
        .LD_TMP(W_LD_TMP),
        .LD(W_LD),
        .Resultado(Resultado),

        .TMP_out(W_TMP_out)
);

SUM_C2_RAIZ SUM_C20_RAIZ(
        .A_out(W_A_out),
        .TMP_out(W_TMP_out),

        .MSB(W_MSB),
        .SUM_C2(W_SUM_C2)

);

endmodule




