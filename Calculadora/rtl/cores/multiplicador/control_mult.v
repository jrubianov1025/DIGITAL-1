module control_mult(clk , rst, lsb_B, init , z, done , sh ,reset , add);
    input clk;
    input rst;
    input lsb_B;
    input init;
    input z;

    output reg done;
    output reg sh;
    output reg reset;
    output reg add;

    parameter START = 3'b000;
    parameter CHECK = 3'b001;
    parameter SHIFT = 3'b010;
    parameter ADD   = 3'b011;
    parameter fin   = 3'b100;

    reg [2:0] state;
    reg [5:0] count;

    initial begin
        done = 0;
        sh = 0;
        reset = 0;
        add = 0;
        state = 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            state = START;
            count = 0;
        end
        else begin
            case(state)
                START: begin
                    count = 0;
                    if(init)
                        state = CHECK;
                    else
                        state = START;
                end

                CHECK: begin
                    if(lsb_B)
                        state = ADD;
                    else
                        state = SHIFT;
                end

                SHIFT: begin
                    if(z)
                        state = fin;
                    else
                        state = CHECK;
                end

                ADD: begin
                    state = SHIFT;
                end

                fin: begin
                    count = count + 1;
                    if(count > 30)
                        state = START;
                    else
                        state = fin;
                end

                default: state = START;
            endcase
        end
    end

    always @(state) begin
        case(state)
            START: begin
                done = 0;
                sh   = 0;
                reset = 1;
                add  = 0;
            end

            CHECK: begin
                done = 0;
                sh   = 0;
                reset = 0;
                add  = 0;
            end

            SHIFT: begin
                done = 0;
                sh   = 1;
                reset = 0;
                add  = 0;
            end

            ADD: begin
                done = 0;
                sh   = 0;
                reset = 0;
                add  = 1;
            end

            fin: begin
                done = 1;
                sh   = 0;
                reset = 0;
                add  = 0;
            end

            default: begin
                done = 0;
                sh   = 0;
                reset = 0;
                add  = 0;
            end
        endcase
    end
endmodule

