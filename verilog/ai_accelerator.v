module ai_accelerator(
    input clk,
    input reset,
    input start,
    input signed [15:0] pixel,
    output [3:0] prediction,
    output reg done
);

    localparam IDLE   = 2'd0;
    localparam HIDDEN = 2'd1;
    localparam OUTPUT = 2'd2;
    localparam ARGMAX = 2'd3;

    reg [1:0] state;

    wire [2047:0] hidden_output;
    wire hidden_done;
    reg hidden_enable;

    wire [319:0] output_scores;
    wire output_done;
    reg output_enable;

    wire argmax_done;
    reg argmax_enable;

    // Sub-module Instantiations using positional binding
    hidden_layer hidden_layer_inst (
        clk,
        reset,
        hidden_enable,
        pixel,
        hidden_output,
        hidden_done
    );

    output_layer output_layer_inst (
        clk,
        reset,
        output_enable,
        hidden_output,
        output_scores,
        output_done
    );

    argmax argmax_inst (
        clk,
        reset,
        argmax_enable,
        output_scores,
        prediction,
        argmax_done
    );

    // State Machine & Done Signal Controller
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done  <= 1'b0;
        end 
        else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start)
                        state <= HIDDEN;
                end 

                HIDDEN: begin
                    if (hidden_done)
                        state <= OUTPUT;
                end

                OUTPUT: begin
                    if (output_done)
                        state <= ARGMAX;
                end

                ARGMAX: begin
                    if (argmax_done) begin
                        done  <= 1'b1;
                        state <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

    // Module Enable Routing Logic
    always @(*) begin
        hidden_enable = (state == HIDDEN);
        output_enable = (state == OUTPUT);
        argmax_enable = (state == ARGMAX);
    end

endmodule
