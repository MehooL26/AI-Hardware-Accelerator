`timescale 1ns/1ps
module ai_accelerator_tb;
    reg clk,reset,start;
    reg signed [15:0] pixel;
    wire [3:0] prediction;
    wire done;

    ai_accelerator dut(clk,reset,start,pixel,prediction,done);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer i;
    initial begin
        reset = 1;
        start = 0;
        pixel = 16'sd0;
        #10;
        reset = 0;

        @(negedge clk);
        start = 1;
        pixel = 16'sd256;

        @(negedge clk);
        start = 0;

        for (i=0;i<783;i=i+1) begin
            @(negedge clk);
            pixel = 16'sd256;
        end

        wait(done == 1'b1);

        #1;
        $display("FULL AI ACCELERATOR TEST");
        $display("Prediction = %0d", prediction);
        $display("Done       = %b", done);
        $display("AI ACCELERATOR TESTBENCH COMPLETED");
        $finish;
    end
endmodule
