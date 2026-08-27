`timescale 1ns/1ps

module neuron_tb;

    reg clk;
    reg reset;
    reg enable;

    reg signed [15:0] pixel;
    reg signed [15:0] weight;
    reg signed [15:0] bias;

    wire signed [31:0] neuron_out;

    // Instantiate one neuron
    neuron uut(
        clk,
        reset,
        enable,
        pixel,
        weight,
        bias,
        neuron_out
    );

    // Image and weight memories
    reg signed [15:0] image_mem [0:783];
    reg signed [15:0] weight_mem [0:50175];

    integer i;

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Load image
        $readmemh("outputs/mem/test_image.mem", image_mem);

        // Load all hidden-layer weights
        $readmemh("outputs/mem/w1_fixed.mem", weight_mem);

        // Neuron 1 bias
        bias = 16'sd25;

        // Initial values
        reset = 1;
        enable = 0;
        pixel = 16'sd0;
        weight = 16'sd0;

        // Reset
        #10;
        reset = 0;

        // Start processing
        @(negedge clk);
        enable = 1;

        // Process 784 pixels
        for (i = 0; i < 784; i = i + 1) begin

            pixel = image_mem[i];

            // Neuron 1 weight:
            // weight_mem[i*64 + 1]
            weight = weight_mem[i*64 + 1];

            @(negedge clk);

        end

        // Give final MAC result time to update
        @(posedge clk);
        #1;

        $display("------------------------------------------");
        $display("SINGLE NEURON TEST");
        $display("------------------------------------------");

        $display("Expected Python result = 448");
        $display("Verilog neuron result  = %0d", neuron_out);

        $display("------------------------------------------");

        if (neuron_out == 32'sd448)
            $display("NEURON TEST PASSED");
        else
            $display("NEURON TEST FAILED");

        $display("------------------------------------------");

        $finish;
    end

endmodule