module LSR_A_RAIZ (
    input CLK,
    input LD,       
    input LDA2,
    input SH,       
    input MSB,
    
    input [15:0] Op_A,    // número a evaluar
    input [15:0] SUM_C2,  // Resultado de la resta en el diagrama se llama W_LDA2_in 

    output reg [15:0] A_out    // Valor actual del registro A en el diagrama se llama W_LDA2_out
);                              // comentarios puestos unica y exclusivamente por si alguno de mis compañeros se digna en revisar estos codigos

    reg [15:0] reg_TMP;  // registro temporal para manejar el desplazamiento conjunto
 

    always @(posedge CLK) begin
        if (LD) begin
            A_out <= 16'd0; 
            reg_TMP <= Op_A;
        end
        
        else if (LDA2 && !MSB) begin 
            A_out <= SUM_C2; 
        end
        else if (SH) begin
            {A_out, reg_TMP} <=  {A_out, reg_TMP} << 2; // Desplaza dos bits a la izquierda
        end    
    end

endmodule
