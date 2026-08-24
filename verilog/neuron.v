// this block performs only addition of bias and applies relu so we can use a combinational logic here.
module neuron(
    input clk,reset,enable,
    input signed [15:0] a,
    input signed [15:0] b,
    input signed [15:0] bias,
    output wire signed [31:0] neuron_out
);

    wire signed [31:0] mac_out;
    wire signed [31:0] bias_extended;
    wire signed [31:0] biased_sum;

    mac_unit mac_instantiation(clk,reset,enable,a,b,mac_out);

    assign bias_extended = {{16{bias[15]}},bias};
    assign biased_sum = mac_out + bias_extended;
    assign neuron_out = biased_sum[31] ? 32'd0 : biased_sum;
endmodule