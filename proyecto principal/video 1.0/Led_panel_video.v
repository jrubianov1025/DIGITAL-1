module led_panel_video#(
    parameter N_FRAMES = 20        // cantidad de frames del video
)(
    input         rst,
    input         clk,
    input         init,

    output        LP_CLK,
    output        LATCH,
    
    output        NOE,
    output  [4:0] ROW,
    output  [2:0] RGB0,
    output  [2:0] RGB1
);
    localparam TOTAL_PIXELS = N_FRAMES * 2048;
     
    wire w_ZR;
    wire w_ZC;
    wire w_ZD;
    wire w_ZI;
    wire w_ZFRAME;

    wire w_RST_R;
    wire w_RST_C;
    wire w_RST_D;
    wire w_RST_I;
    wire w_RST_F;    

    wire w_INC_R;
    wire w_INC_C;
    wire w_INC_D;
    wire w_INC_I;
    wire w_INC_F;

    wire w_LD;
    wire w_SHD;    

    wire PX_CLK_EN;
    wire tmp_noe;
    wire tmp_latch;
    wire w_CHANGE;    
    
    wire [10:0] count_delay;
    wire [10:0] delay;
    wire [1:0]  index;
    wire [11:0] PIX_ADDR;
    wire [23:0] mem_data;

    wire [5:0]  COL;
    wire [23:0] w_data;

    wire [$clog2(N_FRAMES)-1:0] FRAME;
    wire [$clog2(TOTAL_PIXELS)-1:0] w_address_image;
    
    reg clk1;

assign LATCH = ~tmp_latch;
assign NOE = tmp_noe;

parameter DELAY = 10; 
reg [4:0] clk_counter;
   always @(posedge clk) begin
      if (!rst) begin
        clk_counter <= 0;
        clk1        <= 0;
      end else begin
         if(clk_counter == 2) begin
            clk1    <= ~clk1;
            clk_counter <= 0;
         end
         else
            clk_counter <= clk_counter + 1;
      end
   end

    assign PIX_ADDR = {ROW, COL};
    assign w_address_image = FRAME * 2048 + PIX_ADDR;
    assign LP_CLK = clk1 & PX_CLK_EN;

    Contador #(.width(4))  Contador_row(
        .clk(clk1),
        .reset(w_RST_R),
        .inc(w_INC_R),
        .outc(ROW),
        .zero(w_ZR)
    );

    Contador #(.width(5))  Contador_col(
        .clk(clk1),
        .reset(w_RST_C),
        .inc(w_INC_C),
        .outc(COL),
        .zero(w_ZC)
    );
    
    Contador #(.width (10))   Contador_delay(
        .clk(clk1),
        .reset(w_RST_D),
        .inc(w_INC_D),
        .outc(count_delay)
    );
    
    Contador #(.width (1))   Contador_index(
        .clk(clk1),
        .reset(w_RST_I),
        .inc(w_INC_I),
        .outc(index),
        .zero(w_ZI)
    );

    Contador #(.width ($clog2(N_FRAMES)))   Contador_Frame(
        .clk(clk1),
        .reset(w_RST_F),
        .inc(w_INC_F),
        .outc(FRAME),
        .zero(w_ZFRAME)
    );
    
    Lsr_led #(.init_value(DELAY), .width(10)) lsr_led0(
        .clk(clk1),
        .load(w_LD),
        .shift(w_SHD),
        .s_A(delay)
    );
    
    Comparador #(.width(10) ) Comparador0 (
        .in1(delay),
        .in2(count_delay),
        .out(w_ZD)
    );
    
    Multiplexor Multiplexor0 (
        .in0(mem_data),
        .out0({RGB0, RGB1}),
        .sel(index)
    );

    memory_principal #(.N_FRAMES(N_FRAMES), .FRAME_PIXELS(2048), .TOTAL_PIXELS(TOTAL_PIXELS)) memory_principal0 (
    .clk(clk1),
    .rd_image(1'b1),
    .address_image(w_address_image),
    .data_out(w_data)
    );


    memory_doble memory_doble0(
        .clk(clk1),
        .rd(1'b1),
        .wr(1'b1),
        .CHANGE(w_CHANGE),
        .address(PIX_ADDR),
        .wdata(w_data),
        .rdata(mem_data)
    );

    control_video control_video0 (
        .clk(clk1),
        .rst(!rst),
        .init(1'b1),
        
        .ZR(w_ZR),
        .ZC(w_ZC),
        .ZD(w_ZD),
        .ZI(w_ZI),
        .ZFRAME(w_ZFRAME),

        .RST_R(w_RST_R),
        .RST_C(w_RST_C),
        .RST_D(w_RST_D),
        .RST_I(w_RST_I),
        .RST_F(w_RST_F),

        .INC_R(w_INC_R),
        .INC_C(w_INC_C),
        .INC_D(w_INC_D),
        .INC_I(w_INC_I),
        .INC_F(w_INC_F),

        .CHANGE(w_CHANGE),
        .LD(w_LD),
        .SHD(w_SHD),
        
        .LATCH(tmp_latch),
        .NOE(tmp_noe),
        .PX_CLK_EN(PX_CLK_EN)
    ) ;

endmodule