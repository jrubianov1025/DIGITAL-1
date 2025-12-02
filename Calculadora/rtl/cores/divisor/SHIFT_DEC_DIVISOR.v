module SHIFT_DEC_DIVISOR (
    input CLK,
    input DV0,       
    input INIT,     
    input SH,        
    input [15:0] DV_IN,     
    input LDA,       
    input [15:0] RES,       
    input MSB,
    input Z,

    output reg [15:0] DV,        
    output reg [15:0] R,        
    output reg [15:0] A   
);

    always @(posedge CLK) begin
        if (INIT) begin
        
            A  <= 16'd0;      // limpia acumulador
            DV <= DV_IN;      // carga el dividendo inicial
            R  <= 16'd0;      // limpia el resultado
        end
        else if (SH) begin
            // Corrimiento concatenado entre A y DV
            {A, DV} <= {A, DV} << 1;
        end
        else if (!SH && MSB==1 && !Z) begin
            R <= {R[14:0], DV0};
        end
        else if (LDA) begin
            // Actualiza A con el resultado del sumador
            A <= RES;
            // Construye R bit a bit usando DV0
            R <= {R[14:0], DV0};
        end
    end

endmodule
