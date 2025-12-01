// ============================================================================
// Módulo: memory.v
// Descripción: Memoria con soporte opcional para animación GIF
// Compatible con formato original (RGB0[2:0], RGB1[2:0])
// Lee 24 bits del .hex pero extrae solo los 6 bits necesarios
// ============================================================================

module memory
#(
    parameter size = 2047,              // Tamaño: última dirección (2047 = 2048 líneas)
    parameter width = 10,               // Ancho del bus de direcciones
    parameter TOTAL_FRAMES = 1,         // Número de frames (1 = estático, >1 = animado)
    parameter FRAME_DELAY_MS = 100,     // Delay entre frames en milisegundos
    parameter CLK_FREQ_MHZ = 50         // Frecuencia del reloj en MHz
)
(
    input wire              clk,
    input wire [width:0]    address,    // Dirección dentro del frame
    input wire              rd,
    output reg [5:0]        rdata       // Mantiene los 6 bits originales
);

    // ========================================================================
    // PARÁMETROS CALCULADOS
    // ========================================================================
    localparam LINES_PER_FRAME = size + 1;  // 2048 líneas por frame
    localparam TOTAL_LINES = TOTAL_FRAMES * LINES_PER_FRAME;
    localparam CLOCKS_PER_FRAME = (CLK_FREQ_MHZ * 1_000_000 / 1000) * FRAME_DELAY_MS;
    
    // ========================================================================
    // MEMORIA PRINCIPAL - Almacena 24 bits pero extrae 6
    // ========================================================================
    reg [23:0] MEM [0:TOTAL_LINES-1];  // 24 bits en memoria
    
    // ========================================================================
    // CONTROL DE ANIMACIÓN
    // ========================================================================
    reg [31:0] frame_counter;
    reg [7:0]  current_frame;
    
    wire [31:0] base_address;
    wire [31:0] real_address;
    wire [23:0] raw_data;
    
    // Dirección real = frame_actual * 2048 + address
    assign base_address = (TOTAL_FRAMES > 1) ? (current_frame * LINES_PER_FRAME) : 0;
    assign real_address = base_address + address;
    
    // ========================================================================
    // EXTRACCIÓN DE 6 BITS desde 24 bits
    // Formato .hex: R1G1B1R2G2B2 (cada componente 4 bits)
    // Salida: {RGB0[2:0], RGB1[2:0]} (tomar bit más significativo)
    // ========================================================================
    wire [2:0] RGB0_extracted;
    wire [2:0] RGB1_extracted;
    
    // Extraer bit más significativo de cada componente de 4 bits
    assign RGB0_extracted[2] = raw_data[23];  // R1 bit alto
    assign RGB0_extracted[1] = raw_data[19];  // G1 bit alto
    assign RGB0_extracted[0] = raw_data[15];  // B1 bit alto
    
    assign RGB1_extracted[2] = raw_data[11];  // R2 bit alto
    assign RGB1_extracted[1] = raw_data[7];   // G2 bit alto
    assign RGB1_extracted[0] = raw_data[3];   // B2 bit alto
    
    // ========================================================================
    // INICIALIZACIÓN
    // ========================================================================
    initial begin
        if (TOTAL_FRAMES > 1) begin
            $readmemh("../animation.hex", MEM);
            $display("=== MEMORY MODULE: ANIMATED MODE ===");
            $display("Frames: %0d | Delay: %0dms | Total Lines: %0d", 
                     TOTAL_FRAMES, FRAME_DELAY_MS, TOTAL_LINES);
        end else begin
            $readmemh("../image.hex", MEM);
            $display("=== MEMORY MODULE: STATIC MODE ===");
        end
        
        current_frame = 0;
        frame_counter = 0;
    end
    
    // ========================================================================
    // LÓGICA DE ANIMACIÓN (solo si TOTAL_FRAMES > 1)
    // ========================================================================
    generate
        if (TOTAL_FRAMES > 1) begin : gen_animation
            always @(posedge clk) begin
                if (frame_counter >= CLOCKS_PER_FRAME - 1) begin
                    frame_counter <= 0;
                    
                    if (current_frame >= TOTAL_FRAMES - 1)
                        current_frame <= 0;
                    else
                        current_frame <= current_frame + 1;
                end else begin
                    frame_counter <= frame_counter + 1;
                end
            end
        end
    endgenerate
    
    // ========================================================================
    // LECTURA DE DATOS
    // Lee 24 bits de memoria y extrae los 6 bits necesarios
    // ========================================================================
    assign raw_data = MEM[real_address];
    
    always @(negedge clk) begin
        if (rd) begin
            // Empaquetar RGB0 y RGB1 en 6 bits como espera el hardware
            rdata <= {RGB0_extracted, RGB1_extracted};
        end
    end

endmodule
