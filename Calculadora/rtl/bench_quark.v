`timescale 1ns/1ps
module bench();

// Clock de 30 MHz → periodo = 33 ns
parameter tck = 38; // 26MHz

// UART a 115200 baud
// Bit period = 1 / 115200 = 8680 ns
parameter c_BIT_PERIOD = 8680;

reg CLK = 0;
reg RESET;
reg RXD = 1'b1; 
wire TXD;
wire LEDS;

always #(tck/2) CLK = ~CLK;

task UART_WRITE_BYTE;
  input [7:0] i_Data;
  integer ii;
  begin
    // Start bit
    RXD <= 1'b0;
    #(c_BIT_PERIOD);

    // 8 bits de datos LSB primero
    for (ii = 0; ii < 8; ii = ii + 1) begin
      RXD <= i_Data[ii];
      #(c_BIT_PERIOD);
    end

    // Stop bit
    RXD <= 1'b1;
    #(c_BIT_PERIOD);
  end
endtask

SOC uut(
  .clk(CLK),
  .resetn(RESET),  
  .LEDS(LEDS),
  .RXD(RXD),
  .TXD(TXD)
);

always @(LEDS) begin
  $display("LEDS = %b  (t = %0t ns)", LEDS, $time);
end

integer idx;

initial begin
  $dumpfile("bench.vcd");
  $dumpvars(0, bench);
  `ifndef SYNTH
    for(idx=0; idx<32; idx=idx+1)
      $dumpvars(0, bench.uut.CPU.registerFile[idx]);
  `endif
end

initial begin
  
  RESET = 0;    
  #200;         
  RESET = 1;    

    @(posedge CLK);
    #(tck*60000)
    UART_WRITE_BYTE(8'h31);
    #(tck*1500)
    UART_WRITE_BYTE(8'h32);
    #(tck*1500)  
    UART_WRITE_BYTE(8'h33);
    #(tck*1500)  
    UART_WRITE_BYTE(8'h34);
    #(tck*1500)  
    UART_WRITE_BYTE(8'h0A);
    #(tck*2500)
    UART_WRITE_BYTE(8'h0D);
    
    #(tck*2500)
    UART_WRITE_BYTE(8'h2F); // '/'

    #(tck*90000)
    UART_WRITE_BYTE(8'h35);
    #(tck*1500)
    UART_WRITE_BYTE(8'h0A);
    #(tck*2500)
    UART_WRITE_BYTE(8'h0D);
    
    @(posedge CLK);
    #(tck*900000) $finish;
 end
 

endmodule

