module ai_accelerator(
    input clk,reset,
    input reg start,
    input signed[15:0] pixel,
    output [3:0] prediction,
    output done
);

    localparam IDLE = 2'd0;
    localparam HIDDEN = 2'd1;
    localparam OUTPUT = 2'd2;
    localparam ARGMAX = 2'd3;

    reg [1:0] state;

    wire signed [31:0] hidden_output [63:0];
    wire hidden_done;
    reg hidden_enable;

    wire signed [31:0] output_scores [0:9];
    wire output_done;
    reg output_enable;

    wire argmax_done;
    reg argmax_enable;

    hidden_layer inst(clk,reset,hidden_enable,pixel,hidden_output,hidden_done);

    output_layer output_layer_inst(clk,reset,output_enable,hidden_output,output_scores,output_done);

    argmax argmax_inst(clk,reset,argmax_enable,output_scores,prediction,argmax_done);

    always @(posedge clk) begin
        if(reset) begin
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE : begin
                    if(start)
                        state <= HIDDEN; 
                end 
                HIDDEN : begin
                    if(hidden_done)
                        state <= OUTPUT; 
                end
                OUTPUT : begin
                    if(output_done)
                        state <= ARGMAX; 
                end
                ARGMAX : begin
                    if(argmax_done)
                        state <= IDLE;
                end 
            endcase
        end
    end

    always @(*) begin
        hidden_enable = 1'b0;
        output_enable = 1'b0;
        argmax_enable = 1'b0;

        case(state)
            HIDDEN:
                hidden_enable = 1'b1;
            OUTPUT:
                output_enable = 1'b1;
            ARGMAX:
                argmax_enable = 1'b1;
            default: begin
                hidden_enable = 1'b0;
                output_enable = 1'b0;
                argmax_enable = 1'b0;
            end
        endcase
    end

    assign done = argmax_done;
endmodule