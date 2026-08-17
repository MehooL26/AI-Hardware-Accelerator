`timescale 1ps/1ps
module neuron_tb;
    reg clk,reset,enable,
    reg signed [15:0] a;
    reg signed [15:0] bias;
    wire signed [31:0] neuron_out;

    neuron dut(clk,reset,enable,a,b,bias,neuron_out);

    always #5 clk = ~clk;

    initial begin
        mac_out = 500;
        bias = 100;
        #10;
        $display("MAC=%d, Bias=%d, Output=%d",mac_out, bias, neuron_out);

        mac_out = -700;
        bias = 400;
        #10;
        $display("MAC=%d, Bias=%d, Output=%d",mac_out, bias, neuron_out);
        $finish;
    end
endmodule