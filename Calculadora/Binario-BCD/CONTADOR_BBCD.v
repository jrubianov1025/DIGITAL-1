module CONTADOR_BBCD (
    input CLK,
    input LD,      // Señal para cargar el valor inicial (16)
    input DEC,     // Habilitación de decremento
    output reg Z   // Bandera: 1 cuando el contador llega a 0
);

    reg [4:0] count;

always @(posedge CLK) begin
    if (LD) begin
        count <= 5'd15;
        Z <= 0;   // <-- limpiar bandera al cargar
    end
    else if (DEC && count != 0)
        count <= count - 1;

    // Bandera cuando count llega a 0
    else if (count == 0)
        Z <= 1;
end


endmodule
