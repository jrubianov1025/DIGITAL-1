module CONTADOR_DIVISOR(
    input CLK,
    input INIT,      
    input DEC,       
    output reg [4:0] COUNT
);

    always @(posedge CLK) begin
        if (INIT)
            COUNT <= 5'd17;              // Valor inicial 
        else if (DEC && COUNT != 0)      // para que no se reinicie el contador
            COUNT <= COUNT - 1;          

    end

endmodule
