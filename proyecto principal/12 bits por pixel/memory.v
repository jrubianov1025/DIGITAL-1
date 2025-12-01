module memory#(
    parameter size = 2047,
    parameter width = 11
)(
  input              clk,
  input  [width:0]   address,
  input              rd,
  output reg [23:0]  rdata,
  input              we_a,
  input  [10:0]      w_address,
  input  [23:0]      w_data
);

reg [23:0] MEM [0:size];
initial begin
    $readmemh("./image.hex",MEM);
end

  always @(negedge clk) begin
    if(rd) begin
        rdata <= MEM[address];     //{RGB0,RGB1}
    end
  end



//------------------------------------------------------------------
// write port A
//------------------------------------------------------------------
always @(negedge clk)
begin
//	if (en_a) begin
		  if (we_a) begin
			  MEM[w_address] <= w_data;
		  end 
//      dat_a_out<=MEM[w_address];
//	end 
end


endmodule
