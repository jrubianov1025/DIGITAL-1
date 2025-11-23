`timescale 1ns/1ps

module tb_Periferico_BinarioABCD;

  // ==========================
  // Entradas principales
  // ==========================
  reg CLK;
  reg reset;
  reg cs;
  reg rd;
  reg wr;
  reg [5:0] addr;
  reg [15:0] d_in;

  // ==========================
  // Salidas
  // ==========================
  wire [15:0] d_out;

  // ==========================
  // Instancia del periférico
  // ==========================
  Periferico_BinarioABCD uut (
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
  wire [15:0] OpA_int   = uut.Op_A;
  wire INIT_int         = uut.INIT;
  wire [3:0] UNIT_int   = uut.UNIT;
  wire [3:0] DEC_int    = uut.DEC;
  wire [3:0] CENT_int   = uut.CENT;
  wire [3:0] MIL_int    = uut.MIL;
  wire DONE_int         = uut.DONE;

  // ==========================
  // Generador de reloj
  // ==========================
  initial begin
    CLK = 0;
    forever #5 CLK = ~CLK; // 10ns periodo
  end

  // ==========================
  // Tareas de lectura y escritura
  // ==========================
  task write_reg(input [5:0] address, input [15:0] data);
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

  task read_reg(input [5:0] address);
    begin
      @(posedge CLK);
      cs   = 1;
      rd   = 1;
      wr   = 0;
      addr = address;
      @(posedge CLK);
      cs   = 0;
      rd   = 0;
    end
  endtask

 
  initial begin
    $dumpfile("tb_Periferico_BinarioABCD.vcd");
    $dumpvars(0, tb_Periferico_BinarioABCD);

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

    $display("\n Prueba de conversión BIN->BCD\n");

    // Escribir valor binario (ejemplo: 1234 decimal)
    write_reg(6'h04, 16'd1234); // Op_A
    write_reg(6'h08, 16'd1);    // INIT

    // Esperar hasta que DONE sea 1
    for (i = 0; i < 500; i = i + 1) begin
      @(posedge CLK);
      if (DONE_int) begin
        $display("\n DONE detectado en t=%0t", $time);
        i = 500;
      end
    end

    // Leer resultados
    read_reg(6'h0C); // UNIT
    read_reg(6'h10); // DEC
    read_reg(6'h14); // CENT
    read_reg(6'h18); // MIL
    read_reg(6'h1C); // DONE

    $display("\n[RESULTADO FINAL]");
    $display("BIN = %0d (0x%0h)", OpA_int, OpA_int);
    $display("BCD = %1d%1d%1d%1d", MIL_int, CENT_int, DEC_int, UNIT_int);

    #50;
    $display("\n=== FIN DE SIMULACIÓN ===");
    $finish;
  end

endmodule

/*
 si se quiere simular, pegar esto en consola: 
 iverilog -o sim Binario-BCD.v CONTADOR_BBCD.v CONTROL_BBCD.v LSR_BBCD.v Periferico_BBCD.v SUM_C2_BBCD.v testbench.v
 vvp sim
*/
