/* each pixel of the input image is passed on to each neuron so each neuron requires 784 weights,
so accordingly 64 neurons would require 64*784 weights. 

Now we need to save these weights somewhere.

First Option : one huge memory containing all the weights
Second Option : one memory per neuron
Third Option : reuse a single neuron 

for my project I am using first option because all the weights are stored in a single mem file,
so we just need to read it as all weights are stored in order */

/*
    The ai_accelerator file will call this module first to get the 64 neurons.
    This file collects the outputs of the neuron file i.e. 64 times for 64 neurons.

    neuron_out is taken for 32 bits because it is the result of multiplication of 16 bit digits
*/

module hidden_layer(
    input clk,reset,enable,
    input signed [15:0] pixel,
    // Packed bus: neuron i occupies hidden_out[i*32 +: 32].
    // A packed bus is supported by Verilog-2001; an unpacked array port is not.
    output [2047:0] hidden_out,
    output reg done
);

    reg [9:0] pixel_index;

// the weights and biases are extracted from the saved file during python phase
    reg signed [15:0] weight_mem [0:50175];
    reg signed [15:0] biased_mem [0:63];

    initial begin
        $readmemh("outputs/mem/w1_fixed.mem", weight_mem);
        $readmemh("outputs/mem/b1_fixed.mem", biased_mem);
    end

// this block keeps track of the weight index, each neuron needs 784 weights to give output 
    always @(posedge clk) begin
        if(reset) begin
            pixel_index <= 10'd0;
            done <= 1'b0;
        end
        else if (enable) begin
            if(pixel_index == 10'd783) begin
                pixel_index <= 10'd0;
                done <= 1'b1;
            end

            else begin
                pixel_index <= pixel_index + 1'b1;
                done <= 1'b0;
            end
        end

    end

/* 
    generating 64 neurons, the weights are stored as 784 for each neuron so the address for those is
        784*i + pixel_index
    as this block is working on each neuron parallely so neuron[0] first gets weight[0] and 
    neuron[1] gets weight[784], and so on...
    then these 64 outputs are sent to output layer
*/
    genvar i;
    generate
        for (i = 0; i<64 ; i=i+1) begin
            neuron neuron_inst(clk,reset,enable,pixel,weight_mem[64*pixel_index + i],biased_mem[i],hidden_out[i*32 +: 32]);
        end
    endgenerate
endmodule
