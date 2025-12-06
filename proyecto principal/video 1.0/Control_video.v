module control_video(
    input   clk,
    input   init,
    input   rst,
    input   ZR,
    input   ZC,
    input   ZD,
    input   ZI,
    input   ZFRAME,

    output  reg RST_R,
    output  reg RST_C,
    output  reg RST_D,
    output  reg RST_I,
    output  reg RST_F,

    output  reg INC_R,
    output  reg INC_C,
    output  reg INC_D,
    output  reg INC_I,
    output  reg INC_F,

    output  reg CHANGE,
    output  reg LD,
    output  reg SHD,
    
    output  reg LATCH,
    output  reg NOE,
    output  reg PX_CLK_EN
);

 parameter START       = 4'b0000;
 parameter GET_PIXEL   = 4'b0001;
 parameter INC_COL     = 4'b0010;
 parameter SEND_ROW    = 4'b0011;
 parameter DELAY_ROW   = 4'b0100;
 parameter NEXT_BIT    = 4'b0101;
 parameter NEXT_DELAY  = 4'b0110;
 parameter INC_ROW     = 4'b0111;
 parameter READY_FRAME = 4'b1000;
 parameter NEXT_FRAME  = 4'b1001;
 parameter WAIT_FRAME  = 4'b1010;   

 reg [9:0] state;

 // -------------------------------------------------------
 // Temporizador de frame
 // parameter FRAME_TARGET = 20;    30 FPS
 // parameter FRAME_TARGET = 295;   2 FPS
 // -------------------------------------------------------
 reg [7:0] frame_counter;
 parameter FRAME_TARGET = 25;   // 24 FPS

 always @(posedge clk) begin
  if (rst) begin
    state = START;
    frame_counter = 0;
  end else begin
    case(state)

      START: begin
        frame_counter = 0;
        if(init)
          state = GET_PIXEL;
        else
          state = START;
      end

      GET_PIXEL: begin
        state = INC_COL;
      end

      INC_COL: begin
        if(ZC)
          state = SEND_ROW;
        else 
          state = INC_COL;
      end

      SEND_ROW: begin
        state = DELAY_ROW;
      end

      DELAY_ROW: begin
        if(ZD)
          state = NEXT_BIT;
        else
          state = DELAY_ROW;
      end

      NEXT_BIT: begin
        state = NEXT_DELAY;
      end

      NEXT_DELAY: begin
        if(ZI)
          state = INC_ROW;
        else
          state = GET_PIXEL;
      end

      INC_ROW: begin
        state = READY_FRAME;
      end

      READY_FRAME: begin
        if(ZR)
          state = WAIT_FRAME;    
        else
          state = GET_PIXEL;
      end

      WAIT_FRAME: begin
        if(frame_counter >= FRAME_TARGET) begin
            frame_counter = 0;
            state = NEXT_FRAME;
        end else begin
            frame_counter = frame_counter + 1;
            state = GET_PIXEL;
        end
      end

      NEXT_FRAME: begin
        frame_counter = 0;
        if(ZFRAME)
          state = START;
        else
          state = GET_PIXEL;
      end

      default: state = START;

    endcase
  end
end

always @(*) begin
    case(state)

      START: begin
        RST_R = 0; RST_C = 0; RST_D = 0; RST_I = 0; RST_F = 0;
        INC_R = 0; INC_C = 0; INC_D = 0; INC_I = 0; INC_F = 0;
        LD    = 1; SHD   = 0; CHANGE = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      GET_PIXEL: begin
        RST_R = 1; RST_C = 1; RST_D = 1; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 0; INC_I = 0; INC_F = 0;
        LD    = 0; SHD   = 0; CHANGE = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      INC_COL: begin
        RST_R = 1; RST_C = 1; RST_D = 1; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 1; INC_D = 0; INC_I = 0; INC_F = 0;
        LD    = 0; SHD   = 0; CHANGE = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 1;
      end

      SEND_ROW: begin
        RST_R = 1; RST_C = 1; RST_D = 1; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 0; INC_I = 0; INC_F = 0;
        LD    = 0; SHD   = 0; CHANGE = 0;
        LATCH = 1; NOE   = 0; PX_CLK_EN = 0;
      end

      DELAY_ROW: begin
        RST_R = 1; RST_C = 1; RST_D = 1; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 1; INC_I = 0; INC_F = 0;
        LD    = 0; SHD   = 0; CHANGE = 0;
        LATCH = 0; NOE   = 0; PX_CLK_EN = 0;
      end

      NEXT_BIT: begin
        RST_R = 1; RST_C = 1; RST_D = 0; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 0; INC_I = 1; INC_F = 0;
        LD    = 0; SHD   = 1; CHANGE = 0;
        LATCH = 0; NOE   = 0; PX_CLK_EN = 0;
      end

      NEXT_DELAY: begin
        RST_R = 1; RST_C = 1; RST_D = 1; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 1; INC_I = 0; INC_F = 0;
        LD    = 0; SHD   = 0; CHANGE = 0;
        LATCH = 0; NOE   = 0; PX_CLK_EN = 0;
      end

      INC_ROW: begin
        RST_R = 1; RST_C = 0; RST_D = 0; RST_I = 1; RST_F = 1;
        INC_R = 1; INC_C = 0; INC_D = 0; INC_I = 0; INC_F = 0;
        LD    = 1; SHD   = 1; CHANGE = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      READY_FRAME: begin
        RST_R = 1; RST_C = 1; RST_D = 1; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 0; INC_I = 0; INC_F = 0;
        LD    = 0; SHD   = 0; CHANGE = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      WAIT_FRAME: begin
        RST_R = 1; RST_C = 1; RST_D = 1; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 0; INC_I = 0; INC_F = 0;
        LD    = 0; SHD   = 0; CHANGE = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      NEXT_FRAME: begin
        RST_R = 1; RST_C = 1; RST_D = 1; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 0; INC_I = 0; INC_F = 1;
        LD    = 0; SHD   = 0; CHANGE = 1;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

      default: begin
        RST_R = 0; RST_C = 0; RST_D = 0; RST_I = 1; RST_F = 1;
        INC_R = 0; INC_C = 0; INC_D = 0; INC_I = 0; INC_F = 0;
        LD    = 0; SHD   = 0; CHANGE = 0;
        LATCH = 0; NOE   = 1; PX_CLK_EN = 0;
      end

    endcase
end

endmodule