`timescale 1ns/1ps
module ai_accelerator_tb;
    reg clk,reset,start;
    reg signed [15:0] pixel;
    wire [3:0] prediction;
    wire done;

    reg signed [15:0] image_mem [0:783];

    ai_accelerator dut(clk,reset,start,pixel,prediction,done);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer i;
    initial begin

        $readmemh("outputs/mem/test_image.mem",image_mem);

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
        $display("------------------------------------------");

        $display("REAL MNIST IMAGE TEST");

        $display("------------------------------------------");

        $display("Actual label = 2");

        $display("Prediction    = %0d", prediction);

        $display("Done          = %b", done);

        $display("------------------------------------------");


        // -----------------------------------------
        // Display output scores
        // -----------------------------------------

        $display("OUTPUT LAYER SCORES");

        for (i = 0; i < 10; i = i + 1) begin

            $display("Output[%0d] = %0d",
                     i,
                     uut.output_scores[i]);

        end

        $display("------------------------------------------");


        // -----------------------------------------
        // Check prediction
        // -----------------------------------------

        if (prediction == 4'd2)

            $display("PREDICTION MATCHES ACTUAL LABEL");

        else

            $display("PREDICTION DOES NOT MATCH ACTUAL LABEL");


        $display("------------------------------------------");

        $finish;

    end

endmodule
