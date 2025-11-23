module LSR_TMP_RAIZ (
    input CLK,
    input LD_TMP,     
    input LD,

    input [15:0] Resultado,      // Entrada: valor actual de R
    
    output reg [15:0] TMP_out    // Salida: valor temporal
);

    always @(posedge CLK) begin
        if (LD) 
            TMP_out <= 16'd0;  
        else if (LD_TMP)
            TMP_out <= Resultado;     // Guarda el valor actual de R
    end

endmodule

