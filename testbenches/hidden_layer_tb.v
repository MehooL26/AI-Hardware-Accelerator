`timescale 1ps/1ps
module hidden_layer_tb;

reg clk,reset,enable;
reg signed [15:0] pixel;

wire signed [31:0] neuron_out [0:63];
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
    $display("Neuron %0d",i,neuron_out[i]);
end 

$finish;
end
endmodule