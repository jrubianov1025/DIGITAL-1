module COUNT_RAIZ (
    input CLK,
    input LD,     
    input SH,      
    output reg Z   // Z: 1 cuando el contador llega a 0
);

    reg [4:0] count;

    always @(posedge CLK) begin
        if (LD) begin
            count <= 5'd8;
            Z <= 0;
        end else if (SH) begin
            if (count > 0)
                count <= count - 1;
            // Si ya llega a 0, mantener Z=1
            if (count == 1)
                Z <= 1;  // Se activará justo cuando llegue a 0
        end
    end

endmodule
