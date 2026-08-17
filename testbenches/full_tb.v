`timescale 1ns / 1ps

module neuron_tb;

    // Inputs to the neuron
    reg clk;
    reg reset;
    reg enable;

    reg signed [15:0] a;
    reg signed [15:0] b;
    reg signed [15:0] bias;

    // Output from the neuron
    wire signed [31:0] neuron_out;

    // Instantiate the neuron using positional port mapping
    neuron uut (
        clk,
        reset,
        enable,
        a,
        b,
        bias,
        neuron_out
    );

    // Generate a clock:
    // LOW for 5 ns and HIGH for 5 ns
    // Complete period = 10 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Apply test inputs
    initial begin

        // Initial values
        reset  = 1;
        enable = 0;

        a    = 0;
        b    = 0;
        bias = 0;

        // Keep reset active for one positive clock edge
        #10;

        // Release reset
        reset = 0;

        // -------------------------------------------------
        // TEST 1: Positive result
        // -------------------------------------------------
        //
        // Q8.8 representations:
        //
        // 2.0 = 2 × 256 = 512
        // 3.0 = 3 × 256 = 768
        //
        // Product = 2 × 3 = 6
        // Q8.8 product = 6 × 256 = 1536
        //

        @(negedge clk);
        enable = 1;
        a      = 512;       // 2.0
        b      = 768;       // 3.0
        bias   = 256;       // 1.0

        // MAC updates at the next positive edge
        @(posedge clk);

        // Wait for combinational bias and ReLU logic
        #1;

        $display("------------------------------------------");
        $display("TEST 1");
        $display("Expected MAC result     = 1536");
        $display("Expected neuron output  = 1792");
        $display("Actual neuron output    = %0d", neuron_out);

        if (neuron_out == 1792)
            $display("TEST 1 PASSED");
        else
            $display("TEST 1 FAILED");

        // -------------------------------------------------
        // TEST 2: Accumulate another multiplication
        // -------------------------------------------------
        //
        // a = 1.0
        // b = 2.0
        //
        // Product = 2.0 = 512 in Q8.8
        //
        // Previous accumulator = 1536
        // New accumulator      = 1536 + 512 = 2048
        // Bias                 = 256
        //
        // Output = 2048 + 256 = 2304
        //

        @(negedge clk);
        a = 256;            // 1.0
        b = 512;            // 2.0

        @(posedge clk);
        #1;

        $display("------------------------------------------");
        $display("TEST 2");
        $display("Expected MAC result     = 2048");
        $display("Expected neuron output  = 2304");
        $display("Actual neuron output    = %0d", neuron_out);

        if (neuron_out == 2304)
            $display("TEST 2 PASSED");
        else
            $display("TEST 2 FAILED");

        // Stop accumulation
        @(negedge clk);
        enable = 0;

        // -------------------------------------------------
        // Reset before the negative-result test
        // -------------------------------------------------

        reset = 1;

        // Reset accumulator on the next positive edge
        @(posedge clk);
        #1;

        reset = 0;

        // -------------------------------------------------
        // TEST 3: Negative result should become zero
        // -------------------------------------------------
        //
        // a = -2.0
        // b = 3.0
        //
        // Product = -6.0
        // Q8.8 product = -1536
        //
        // Bias = 1.0 = 256
        //
        // Biased sum = -1536 + 256 = -1280
        // ReLU output = 0
        //

        @(negedge clk);
        enable = 1;
        a      = -512;      // -2.0
        b      = 768;       // 3.0
        bias   = 256;       // 1.0

        @(posedge clk);
        #1;

        $display("------------------------------------------");
        $display("TEST 3");
        $display("Expected MAC result     = -1536");
        $display("Expected biased sum     = -1280");
        $display("Expected neuron output  = 0");
        $display("Actual neuron output    = %0d", neuron_out);

        if (neuron_out == 0)
            $display("TEST 3 PASSED");
        else
            $display("TEST 3 FAILED");

        // Stop accumulation
        @(negedge clk);
        enable = 0;

        $display("------------------------------------------");
        $display("NEURON TESTBENCH COMPLETED");
        $display("------------------------------------------");

        $finish;

    end

endmodule