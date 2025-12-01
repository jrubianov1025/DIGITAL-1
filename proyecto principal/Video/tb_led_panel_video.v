`timescale 1ns/1ps

module tb_led_panel_video;

// =======================
//  Señales del DUT
// =======================
reg         clk;
reg         rst;
reg         init;

wire        LP_CLK;
wire        LATCH;
wire        NOE;
wire [4:0]  ROW;
wire [2:0]  RGB0;
wire [2:0]  RGB1;

// =======================
//  Generación de reloj
// =======================
initial begin
    clk = 0;
    forever #10 clk = ~clk;     // reloj de 50 MHz -> periodo 20ns
end

// =======================
//  RESET + INIT
// =======================
initial begin
    rst  = 0;
    init = 0;
    #100;
    rst  = 1;
    init = 1;
end

// =======================
//  DUT
// =======================
led_panel_video DUT (
    .rst(rst),
    .clk(clk),
    .init(init),

    .LP_CLK(LP_CLK),
    .LATCH(LATCH),
    .NOE(NOE),

    .ROW(ROW),
    .RGB0(RGB0),
    .RGB1(RGB1)
);

// =======================
//  Simulación + VCD
// =======================
initial begin
    $dumpfile("tb_led_panel_video.vcd");
    $dumpvars(0, tb_led_panel_video);

    // Tiempo total de simulación
    #100000000;   // 0.5ms de simulación real
    $finish;
end

endmodule
