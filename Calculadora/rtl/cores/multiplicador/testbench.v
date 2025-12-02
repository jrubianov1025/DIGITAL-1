`timescale 1ns / 1ps

module tb_Periferico_multiplicador;

// Señales del testbench
reg clk;
reg reset;
reg [15:0] d_in;
reg cs;
reg [4:0] addr;
reg rd;
reg wr;
wire [31:0] d_out;

// Instancia del periférico
Periferico_multiplicador dut (
    .clk(clk),
    .reset(reset),
    .d_in(d_in),
    .cs(cs),
    .addr(addr),
    .rd(rd),
    .wr(wr),
    .d_out(d_out)
);

// Generador de reloj
initial clk = 0;
always #5 clk = ~clk;  // periodo de 10 ns -> 100 MHz

// Procedimiento de prueba
initial begin
  // Inicialización
  cs = 0; rd = 0; wr = 0;
  d_in = 0; addr = 0;
  reset = 1;
  #20;
  reset = 0;
  #10;

  // Escritura de A = 
  write_reg(5'h04, 16'd934);

  // Escritura de B = 
  write_reg(5'h08, 16'd367);

  // Escritura de init = 1
  write_reg(5'h0C, 16'd1);

  // Esperar que done = 1
  wait_done();

  // Leer resultado pp
  read_reg(5'h10);

  // Mostrar resultado esperado
  $display("Resultado esperado: %d", 934*367);
  $finish;
end

// Tareas auxiliares
task write_reg(input [4:0] address, input [15:0] value);
  begin
    @(posedge clk);
    cs = 1; wr = 1; rd = 0;
    addr = address;
    d_in = value;
    @(posedge clk);
    cs = 0; wr = 0;
    d_in = 0;
  end
endtask

task read_reg(input [4:0] address);
  begin
    @(posedge clk);
    cs = 1; rd = 1; wr = 0;
    addr = address;
    @(posedge clk);
    $display("Lectura addr %h -> d_out = %d", address, d_out);
    cs = 0; rd = 0;
  end
endtask

task wait_done();
  begin
    repeat (100) begin
      read_reg(5'h14);
      if (d_out[0] == 1'b1) begin
        $display("DONE recibido en tiempo %t", $time);
        disable wait_done;
      end
      #10;
    end
    $display("ERROR: no se recibió DONE");
  end
endtask

endmodule

/*
 si se quiere simular, pegar esto en consola: 
 iverilog -o sim testbench.v Periferico_multiplicador.v multiplicador.v acc.v comp.v control_mult.v lsr.v rsr.v
 vvp sim
*/