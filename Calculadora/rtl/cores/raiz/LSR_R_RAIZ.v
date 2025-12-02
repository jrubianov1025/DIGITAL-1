module LSR_R_RAIZ (
    input CLK,
    input LD,
    input R0,
    input LDA2,

    output reg [15:0] Resultado
);

    always @(posedge CLK) begin
        if (LD)
            Resultado <= 16'd0;               
       else if (LDA2)
            Resultado <= {Resultado[14:0], R0};    

end

endmodule 