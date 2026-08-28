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

    ai_accelerator dut (clk,reset,start,pixel,prediction,done);

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

        // ----------------------------------------------
        // Load image
        // ----------------------------------------------
       $readmemh("outputs/mem/test_image.mem", image_mem);

        // ----------------------------------------------
        // Initial values
        // ----------------------------------------------
        reset = 1'b1;
        start = 1'b0;
        pixel = 16'sd0;

        // ----------------------------------------------
        // Wait for reset clocks
        // ----------------------------------------------

        #20;
        reset = 1'b0;

        // ----------------------------------------------
        // START
        // ----------------------------------------------

        #5;

        pixel = image_mem[0];
        start = 1'b1;

        #10;

        start = 1'b0;

        // ----------------------------------------------
        // SEND IMAGE
        // ----------------------------------------------
        for (i = 1; i < 784; i = i + 1) begin
            #5;
            pixel = image_mem[i];
            #5;
        end

        // ----------------------------------------------
        // Wait for accelerator
        // ----------------------------------------------
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