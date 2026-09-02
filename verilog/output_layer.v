/*
    The ai_accelerator file calls output_layer after completing the hidden_layer.
    This file produces 10 output neurons from the 64 previous hidden layer neurons,
    which are then sent to the argmax module
*/
module output_layer(
    input clk,reset,enable,
    // Packed buses: element i occupies bus[i*32 +: 32].
    input [2047:0] hidden_output,
    output [319:0] outputs,
    output reg done
);

    reg [6:0] hidden_index;
    wire signed [319:0] output_accumulator;

// the weights and biases for output neurons are extracted
    reg signed [15:0] weight_mem [0:639];
    reg signed [15:0] biased_mem [0:9];

    initial begin
        $readmemh("outputs/mem/w2_fixed.mem", weight_mem);
        $readmemh("outputs/mem/b2_fixed.mem", biased_mem);
    end

/* 
    the whole architecture is similar to hidden_layer module but in this case I 
    have used output_layers' own neuron layer as we cannot apply ReLU to this module
    else we will get completely wrong results
*/

    always @(posedge clk) begin
        if(reset) begin
            hidden_index <= 7'd0;
            done <= 1'b0;
        end
        else if(enable) begin
            if(hidden_index == 7'd63) begin
                done <= 1'b1;
                hidden_index <= hidden_index;
            end
            else begin
                hidden_index <= hidden_index + 1'b1;
                done <= 1'b0;
            end
        end
    end

    genvar i;
    generate
        for(i=0;i<10;i=i+1) begin
            output_mac inst(clk,reset,enable,hidden_output[hidden_index*32 +: 32],weight_mem[10 * hidden_index + i],output_accumulator[i*32 +: 32]);
        end
    endgenerate

// neuron layer
    genvar j;
    generate
        for(j=0;j<10;j=j+1) begin
            wire signed [31:0] bias_extended;

            assign bias_extended = {{16{biased_mem[j][15]}},biased_mem[j]};

            assign outputs[j*32 +: 32] = output_accumulator[j*32 +: 32] + bias_extended;
        end
    endgenerate

endmodule
