`timescale 1ns/1ps

module tb_Periferico_raiz;

  // Señales del bus
  reg CLK;
  reg reset;
  reg cs;
  reg rd;
  reg wr;
  reg [4:0] addr;
  reg [15:0] d_in;
  wire [15:0] d_out;

  // Instancia del periférico
  Periferico_raiz DUT (
    .CLK(CLK),
    .reset(reset),
    .d_in(d_in),
    .cs(cs),
    .addr(addr),
    .rd(rd),
    .wr(wr),
    .d_out(d_out)
  );

  // Generador de reloj
  initial CLK = 0;
  always #5 CLK = ~CLK;   // 10 ns de periodo (100 MHz)

  // Archivo de ondas
  initial begin
    $dumpfile("raiz.vcd");
    $dumpvars(0, tb_Periferico_raiz);
  end

  // === Tareas ===
  task write_reg;
    input [4:0] addr_in;
    input [15:0] data;
    begin
      @(negedge CLK);
      cs = 1;
      wr = 1;
      rd = 0;
      addr = addr_in;
      d_in = data;
      @(negedge CLK);
      cs = 0;
      wr = 0;
      d_in = 0;
    end
  endtask

  task read_reg;
    input [4:0] addr_in;
    begin
      @(negedge CLK);
      cs = 1;
      rd = 1;
      wr = 0;
      addr = addr_in;
      @(negedge CLK);
      $display("Tiempo=%0t ns | READ addr=%h -> d_out=%h", $time, addr_in, d_out);
      cs = 0;
      rd = 0;
    end
  endtask

  // === Esperar hasta que DONE = 1 o timeout ===
  task wait_done;
    reg [7:0] contador; // hasta 255 intentos
    begin
      contador = 0;
      while (contador < 200) begin
        read_reg(5'h10); // lee DONE
        if (d_out[0] == 1'b1) begin
          $display("Tiempo=%0t ns | DONE detectado (iter %0d).", $time, contador);
          contador = 200; // salir del while
        end else begin
          contador = contador + 1;
        end
      end
      if (d_out[0] == 1'b0)
        $display("ERROR: Timeout esperando DONE.");
    end
  endtask

  // === Secuencia principal de prueba ===
  initial begin
    // Inicialización
    reset = 1;
    cs = 0;
    rd = 0;
    wr = 0;
    addr = 0;
    d_in = 0;

    // Reset por unos ciclos
    repeat (4) @(negedge CLK);
    reset = 0;
    $display("\n--- INICIO DE SIMULACIÓN ---\n");

    // === Test 1 ===
    $display("Test 1: sqrt(81)");
    write_reg(5'h04, 16'd81);   // Escribir Op_A
    write_reg(5'h08, 16'h0001); // Escribir INIT=1
    wait_done();
    read_reg(5'h0C);
    $display("Resultado sqrt(81) = %0d\n", d_out);

    $display("--- FIN DE SIMULACIÓN ---");
    #20 $finish;
  end

endmodule
/*
 si se quiere simular, pegar esto en consola: 
 iverilog -o sim CONTROL_RAIZ.v COUNT_RAIZ.v LSR_A_RAIZ.v LSR_R_RAIZ.v LSR_TMP_RAIZ.v Periferico_raiz.v RAIZ.v SUM_C2_RAIZ.v tb_Periferico_raiz.v
 vvp sim
*/
