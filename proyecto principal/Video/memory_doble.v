module memory_doble(
    input clk,
    input rd,           // Leer
    input wr,           // Escribir
    input CHANGE,         // Intercambiar memorias

    input [11:0]  address,   // Dirección para lectura / escritura

    input [23:0]  wdata,        // Datos escritura
    output reg [23:0]  rdata         // Datos lectura
);

reg activar_memoria = 1'b0;    // 0 = MEM0 lectura, MEM1 escritura.
                               // 1 = MEM1 lectura, MEM0 escritura.

// Dos memorias de 2048 x 24 bits
reg [23:0] MEM0 [0:2047];
reg [23:0] MEM1 [0:2047];

// Swap síncrono
always @(negedge clk) begin
    if (CHANGE)
        activar_memoria <= ~activar_memoria;
end

// ESCRITURA

always @(negedge clk) begin
    if (wr) begin
        if (activar_memoria == 1'b0)
            MEM1[address] <= wdata; // MEM1 escritura si 0
        else
            MEM0[address] <= wdata; // MEM0 escritura si 1
    end

// LECTURA

    if (rd) begin
        if (activar_memoria == 1'b0)
            rdata <= MEM0[address]; // MEM0 lectura si 0
        else
            rdata <= MEM1[address]; // MEM1 lectura si 1
    end
end

endmodule
