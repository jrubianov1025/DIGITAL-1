module memory_principal #(
    parameter N_FRAMES = 24,
    parameter FRAME_PIXELS = 2048, 
    parameter TOTAL_PIXELS = N_FRAMES * FRAME_PIXELS
)(
    input                       clk,
    input                       rd_image,
    input  [$clog2(TOTAL_PIXELS)-1:0] address_image,
    output reg [23:0]           data_out
);

    reg [23:0] MEM [0:TOTAL_PIXELS-1];

    initial begin
    $readmemh("./video.hex",MEM);
    end

  always @(negedge clk) begin
    if(rd_image) begin
        data_out <= MEM[address_image];     //{RGB0,RGB1}
    end
  end

endmodule
