`timescale 1ns/1ps

module ai_accelerator_tb;

    reg clk;
    reg reset;
    reg start;
    reg signed [15:0] pixel;

    wire [3:0] prediction;
    wire done;

    reg signed [15:0] image_mem [0:783];

    integer i;

    // ==================================================
    // DUT
    // ==================================================

    ai_accelerator dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .pixel(pixel),
        .prediction(prediction),
        .done(done)
    );

    // ==================================================
    // CLOCK
    // ==================================================

    initial begin
        clk = 0;

        forever begin
            #5 clk = ~clk;
        end
    end

    // ==================================================
    // TEST
    // ==================================================

    initial begin

        $display("TESTBENCH STARTED");
        $display("Time = %0t", $time);

        // ----------------------------------------------
        // Load image
        // ----------------------------------------------

        $readmemh("outputs/mem/test_image.mem", image_mem);

        $display("IMAGE LOADED");
        $display("image[0]   = %0d", image_mem[0]);
        $display("image[94]  = %0d", image_mem[94]);
        $display("image[95]  = %0d", image_mem[95]);
        $display("image[97]  = %0d", image_mem[97]);

        // ----------------------------------------------
        // Initial values
        // ----------------------------------------------

        reset = 1'b1;
        start = 1'b0;
        pixel = 16'sd0;

        $display("RESET ASSERTED");
        $display("Time = %0t", $time);

        // ----------------------------------------------
        // Wait for reset clocks
        // ----------------------------------------------

        #20;

        reset = 1'b0;

        $display("RESET RELEASED");
        $display("Time = %0t", $time);

        // ----------------------------------------------
        // START
        // ----------------------------------------------

        #5;

        pixel = image_mem[0];
        start = 1'b1;

        $display("START ASSERTED");
        $display("pixel[0] = %0d", pixel);
        $display("Time = %0t", $time);

        #10;

        start = 1'b0;

        $display("START RELEASED");
        $display("Time = %0t", $time);

        // ----------------------------------------------
        // SEND IMAGE
        // ----------------------------------------------

        for (i = 1; i < 784; i = i + 1) begin

            #5;

            pixel = image_mem[i];

            #5;

        end

        $display("ALL 784 PIXELS SENT");
        $display("Time = %0t", $time);

        // ----------------------------------------------
        // Wait for accelerator
        // ----------------------------------------------

        $display("WAITING FOR DONE...");

        wait(done == 1'b1);

        #1;

        // ----------------------------------------------
        // RESULT
        // ----------------------------------------------

        $display("");
        $display("------------------------------------------");
        $display("REAL MNIST IMAGE TEST");
        $display("------------------------------------------");

        $display("Actual label = 2");
        $display("Prediction    = %0d", prediction);
        $display("Done          = %b", done);

        $display("------------------------------------------");

        // ----------------------------------------------
        // Hidden layer
        // ----------------------------------------------

        $display("HIDDEN LAYER OUTPUTS");
        $display("------------------------------------------");

        for (i = 0; i < 64; i = i + 1) begin

            $display(
                "Hidden[%0d] = %0d",
                i,
                dut.hidden_output[i]
            );

        end

        // ----------------------------------------------
        // Output layer
        // ----------------------------------------------

        $display("------------------------------------------");
        $display("OUTPUT LAYER SCORES");
        $display("------------------------------------------");

        for (i = 0; i < 10; i = i + 1) begin

            $display(
                "Output[%0d] = %0d",
                i,
                dut.output_scores[i]
            );

        end

        $display("------------------------------------------");

        // ----------------------------------------------
        // Check
        // ----------------------------------------------

        if (prediction == 4'd2)
            $display("PREDICTION MATCHES ACTUAL LABEL");
        else
            $display("PREDICTION DOES NOT MATCH ACTUAL LABEL");

        $display("------------------------------------------");

        $finish;

    end

    // ==================================================
    // SAFETY TIMEOUT
    // ==================================================

    initial begin

        #200000;

        $display("");
        $display("------------------------------------------");
        $display("ERROR: SIMULATION TIMEOUT");
        $display("------------------------------------------");
        $display("The accelerator never asserted done.");
        $display("Current time = %0t", $time);
        $display("Current state = %0d", dut.state);
        $display("hidden_done = %b", dut.hidden_done);
        $display("output_done = %b", dut.output_done);
        $display("argmax_done = %b", dut.argmax_done);
        $display("------------------------------------------");

        $finish;

    end

endmodule