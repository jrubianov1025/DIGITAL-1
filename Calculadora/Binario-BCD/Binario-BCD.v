module BinarioABCD(
input CLK,
input [15:0] Op_A, //numero binario entrada
input INIT,

output [3:0] UNIT,
output [3:0] DEC,
output [3:0] CENT,
output [3:0] MIL,
output DONE

);

// Señales internas
        wire W_MSB; 
        wire W_Z;
        wire W_LD;
        wire W_DEC;
        wire W_SH;
        wire W_ADD3;
        
        wire [3:0] W_UNITN;
        wire [3:0] W_DECN;
        wire [3:0] W_CENTN;
        wire [3:0] W_MILN;

SUM_C2_BBCD SUM_C2_BBCD0(
        .ADD3(W_ADD3),
        .UNIT(UNIT),
        .DEC(DEC),
        .CENT(CENT),
        .MIL(MIL),

        .UNITN(W_UNITN),
        .DECN(W_DECN),
        .CENTN(W_CENTN),
        .MILN(W_MILN),
        .MSB(W_MSB)        
);

CONTADOR_BBCD CONTADOR_BBCD0 (
        .CLK(CLK),
        .LD(W_LD),
        .DEC(W_DEC),
        .Z(W_Z)
);

LSR_BBCD LSR_BBCD0(
        .CLK(CLK),
        .SH(W_SH),
        .LD(W_LD),

        .Op_A_in(Op_A),

        .UNITN(W_UNITN),
        .DECN(W_DECN),
        .CENTN(W_CENTN),
        .MILN(W_MILN),   

        .UNIT(UNIT),
        .DEC(DEC),
        .CENT(CENT),
        .MIL(MIL)
);

CONTROL_BBCD CONTROL_BBCD0 (
        .CLK(CLK),
        .MSB(W_MSB),
        .Z(W_Z),
        .INIT(INIT),
    
        .LD(W_LD),
        .DEC(W_DEC),
        .SH(W_SH),
        .ADD3(W_ADD3),
        .DONE(DONE)        
);

endmodule
