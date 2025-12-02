`timescale 1ns/1ps

module tb_Periferico_DIVISOR;

  // Entradas
  reg CLK;
  reg reset;
  reg cs;
  reg rd;
  reg wr;
  reg [4:0] addr;
  reg [15:0] d_in;

  // Salidas
  wire [15:0] d_out;

  // Instancia del periférico
  Periferico_DIVISOR uut (
    .CLK(CLK),
    .reset(reset),
    .d_in(d_in),
    .cs(cs),
    .addr(addr),
    .rd(rd),
    .wr(wr),
    .d_out(d_out)
  );

  // ==========================
  // Señales internas para debug
  // ==========================
  wire DONE_int = uut.DONE;
  wire [15:0] R_int = uut.R;
  wire [15:0] DV_int = uut.DV;
  wire [15:0] DR_int = uut.DR;
  wire START_int = uut.START;

  // ==========================
  // Generador de reloj
  // ==========================
  initial begin
    CLK = 0;
    forever #5 CLK = ~CLK;
  end

  // ==========================
  // Tareas de lectura y escritura
  // ==========================
  task write_reg(input [4:0] address, input [15:0] data);
    begin
      @(posedge CLK);
      cs   = 1;
      wr   = 1;
      rd   = 0;
      addr = address;
      d_in = data;
      @(posedge CLK);
      cs   = 0;
      wr   = 0;
      d_in = 0;
      $display("[%0t] WRITE addr=0x%0h data=%0d (0x%0h)", $time, address, data, data);
    end
  endtask

  task read_reg(input [4:0] address);
    begin
      @(posedge CLK);
      cs   = 1;
      rd   = 1;
      wr   = 0;
      addr = address;
      @(posedge CLK);
      $display("[%0t] READ  addr=0x%0h -> d_out=%0d (0x%0h)", $time, address, d_out, d_out);
      cs   = 0;
      rd   = 0;
    end
  endtask

  initial begin
    $dumpfile("tb_Periferico_DIVISOR.vcd");
    $dumpvars(0, tb_Periferico_DIVISOR);

  end


  // ==========================
  // Secuencia principal
  // ==========================
  integer i;

  initial begin
    reset = 1;
    cs = 0; wr = 0; rd = 0;
    addr = 0; d_in = 0;

    #20 reset = 0;

    $display("\n[INFO] 900 / 5\n");

    // Escribir valores
    write_reg(5'h04, 16'd900);  // DV
    write_reg(5'h08, 16'd5);   // DR
    write_reg(5'h0C, 16'd1);    // START

    // Esperar hasta que DONE sea 1
    for (i = 0; i < 200; i = i + 1) begin
      @(posedge CLK);
      if (DONE_int) begin
        $display("\n[INFO] DONE detectado en t=%0t", $time);
        i = 200; // salir del bucle
      end
    end

    // Leer resultado final
    read_reg(5'h10);
    $display("\n[INFO] Resultado final: %0d (0x%0h)", d_out, d_out);

    #50;
    $display("\n=== FIN DE SIMULACIÓN ===");
    $finish;
  end

endmodule
/*
 si se quiere simular, pegar esto en consola: 
 iverilog -o sim tb_divisor.v SUMADOR_DIVISOR.v SHIFT_DEC_DIVISOR.v Periferico_divisor.v DIVISOR.v CONTROL_DIVISOR.v CONTADOR_DIVISOR.v COMPARADOR_DIVISOR.v 
 vvp sim
 */