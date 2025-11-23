module COMPARADOR_DIVISOR(
    input  [4:0] COUNT, 
    output reg Z     // bandera de fin (1 cuando COUNT == 0)
);

 always @(*) begin
        if (COUNT == 5'd0)
            Z = 1'b1;    // cuando el contador llega a 0
        else
            Z = 1'b0;    // mientras tanto
    end
endmodule
