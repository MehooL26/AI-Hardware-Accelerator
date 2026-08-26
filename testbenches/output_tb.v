`timescale 1ns/1ps
module output_tb;
    reg clk,reset,enable;
    reg signed [31:0] hidden_output [0:63];
    wire signed [31:0] output [0:9];
    wire done;

    output_layer uut (clk,reset,enable,hidden_output,output,done);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer i;
    initial begin
        reset = 1;
        enable = 0;
        for(i=0;i<64;i++) begin
            hidden_output[i] = 32'sd0;
        end
        #10;
        reset = 0;

        @(negedge clk);
        enable = 1;
        for(i=0;i<64;i=i+1) begin
            hidden_output[i] = 32'sd256;
        end
        for (i = 0; i < 64; i = i + 1) begin
            @(posedge clk);
        end
        @(posedge clk);
        #1;

        $display("------------------------------------------");
        $display("OUTPUT LAYER TEST");
        $display("------------------------------------------");
        for (i = 0; i < 10; i = i + 1) begin
            $display("Output neuron %0d = %0d", i, output[i]);
        end
        $display("------------------------------------------");
        $display("DONE = %b", done);
        $display("------------------------------------------");

        // -----------------------------------------
        // Finish
        // -----------------------------------------
        $display("OUTPUT LAYER TESTBENCH COMPLETED");

        $finish;
    end
endmodule