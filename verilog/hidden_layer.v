/* each pixel of the input image is passed on to each neuron so each neuron requires 784 weights,
so accordingly 64 neurons would require 64*784 weights. 

Now we need to save these weights somewhere.

First Option : one huge memory containing all the weights
Second Option : one memory per neuron
Third Option : reuse a single neuron 

for my project I am using first option because all the weights are stored in a single mem file,
so we just need to read it as all weights are stored in order */

module hidden_layer(
    input clk,reset,enable,
    input signed [15:0] pixel,
    output signed [31:0] neuron_out [0:63],
    output reg done
);

// PIXEL COUNTER
reg [9:0] pixel_index;

// WEIGHT MEMORY
reg signed [15:0] weight_mem [0:50175];
reg signed [15:0] biased_mem [0:63];

//LOADING WEIGHTS AND BIASES FROM mem FILE
initial begin
    $readmemh("w1_fixed.mem",weight_mem);
    $readmemh("b1_fixed.mem",biased_mem);
end

// COUNTER LOGIC
always @(posedge clk) begin
    if(reset) begin
        pixel_index <= 10'd0;
        done <= 1'b0;
    end
    else if (enable) begin
        if(pixel_index == 10'd783) begin
            done <= 1'b1;
            pixel_index <= pixel_index;
        end
        else begin
            pixel_index <= pixel_index + 1'b1;
            done <= 1'b0;
        end
    end

end

// GENERATING 64 NEURONS
genvar i;

generate
    for (i = 0; i<64 ; i=i+1) begin
        neuron neuron_inst(clk,reset,enable,pixel,weight_mem[i*784+pixel_index],biased_mem[i],neuron_out[i]);
    end
endgenerate

endmodule