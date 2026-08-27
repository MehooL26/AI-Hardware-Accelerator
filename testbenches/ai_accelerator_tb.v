`timescale 1ns/1ps

module ai_accelerator_tb;

    reg clk;
    reg reset;
    reg start;

    reg signed [15:0] pixel;

    wire [3:0] prediction;
    wire done;

    // 784 pixels
    reg signed [15:0] image_mem [0:783];

    // Instantiate accelerator
    ai_accelerator dut(
        clk,
        reset,
        start,
        pixel,
        prediction,
        done
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer i;

    initial begin

        // Load MNIST image
        $readmemh("outputs/mem/test_image.mem", image_mem);

        // Initial values
        reset = 1;
        start = 0;
        pixel = 16'sd0;

        // Reset
        #10;
        reset = 0;

        // -----------------------------------------
        // Start accelerator with first pixel
        // -----------------------------------------

        @(negedge clk);

        pixel = image_mem[0];
        start = 1;

        @(negedge clk);

        start = 0;

        // -----------------------------------------
        // Send remaining pixels
        // -----------------------------------------

        for (i = 1; i < 784; i = i + 1) begin

            pixel = image_mem[i];

            @(negedge clk);

        end

        // -----------------------------------------
        // Wait for accelerator
        // -----------------------------------------

        wait(done == 1'b1);

        #1;

        // -----------------------------------------
        // Display prediction
        // -----------------------------------------

        $display("------------------------------------------");
        $display("REAL MNIST IMAGE TEST");
        $display("------------------------------------------");

        $display("Actual label = 2");
        $display("Prediction    = %0d", prediction);
        $display("Done          = %b", done);

        $display("------------------------------------------");

        // -----------------------------------------
        // Hidden layer
        // -----------------------------------------

        $display("HIDDEN LAYER OUTPUTS");
        $display("------------------------------------------");

        for (i = 0; i < 64; i = i + 1) begin
            $display("Hidden[%0d] = %0d",
                     i,
                     dut.hidden_output[i]);
        end

        $display("------------------------------------------");

        // -----------------------------------------
        // Output layer
        // -----------------------------------------

        $display("OUTPUT LAYER SCORES");
        $display("------------------------------------------");

        for (i = 0; i < 10; i = i + 1) begin
            $display("Output[%0d] = %0d",
                     i,
                     dut.output_scores[i]);
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