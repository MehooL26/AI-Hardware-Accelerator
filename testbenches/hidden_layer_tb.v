`timescale 1ns/1ps
module hidden_layer_tb;

reg clk,reset,enable;
reg signed [15:0] pixel;

wire [2047:0] neuron_out;
wire done;

hidden_layer uut (clk,reset,enable,pixel,neuron_out,done);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;
initial begin
    reset = 1;
    enable =0;
    pixel = 0;
    #10;
    reset = 0;

    @(negedge clk);
    enable = 1;
    pixel = 16'sd256;

    for (i=0;i<784;i=i+1)
    begin
        @(posedge clk);
    end

    @(posedge clk);
    #1;

for (i=0;i<64;i=i+1) begin
    $display("Neuron= %0d output=%0d",i,$signed(neuron_out[i*32 +: 32]));
end 

$finish;
end
endmodule
