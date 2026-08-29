`timescale 1ns/1ps

module accuracy_tb;

    reg clk, reset, start;
    reg signed [15:0] pixel;

    wire [3:0] prediction;
    wire done;

    reg signed [15:0] image_mem [0:7839];
    reg [3:0] label_mem [0:9];

    integer i;
    integer img;
    integer correct;

    ai_accelerator dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .pixel(pixel),
        .prediction(prediction),
        .done(done)
    );

    always #5 clk = ~clk;

    // VCD Dump for waveform inspection
    initial begin
        $dumpfile("accuracy_tb.vcd");
        $dumpvars(0, accuracy_tb);
    end

    initial begin
        $readmemh("outputs/mem/test_images.mem", image_mem);
        $readmemh("outputs/mem/test_labels.mem", label_mem);

        correct = 0;
        clk = 0;

        for (img = 0; img < 10; img = img + 1) begin

            // Reset accelerator
            reset = 1;
            start = 0;
            pixel = 0;

            #10;
            reset = 0;

            // Send first pixel
            @(negedge clk);
            start = 1;
            pixel = image_mem[img * 784];

            @(posedge clk);
            start = 0;

            // Send remaining pixels
            for (i = 1; i < 784; i = i + 1) begin
                @(negedge clk);
                pixel = image_mem[img * 784 + i];
            end

            // Wait for prediction with a per-image safety timeout
            fork : wait_block
                begin
                    wait(done == 1'b1);
                    disable wait_block;
                end
                begin
                    #50000; // Adjust max expected processing time per image
                    $display("ERROR: Timeout waiting for 'done' on Image %0d", img);
                    $finish;
                end
            join

            #1;

            if (prediction == label_mem[img]) begin
                correct = correct + 1;
                $display("Image %0d | Actual = %0d | Prediction = %0d | PASS", img, label_mem[img], prediction);
            end
            else begin
                $display("Image %0d | Actual = %0d | Prediction = %0d | FAIL", img, label_mem[img], prediction);
            end

        end

        $display("------------------------------------------");
        $display("10 IMAGE ACCURACY");
        $display("------------------------------------------");
        $display("Correct = %0d / 10", correct);
        $display("Accuracy = %0.2f%%", correct * 10.0);
        $display("------------------------------------------");

        $finish;
    end

endmodule