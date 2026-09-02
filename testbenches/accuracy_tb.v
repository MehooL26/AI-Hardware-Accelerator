`timescale 1ns/1ps

module accuracy_tb;

    reg clk;
    reg reset;
    reg start;
    reg signed [15:0] pixel;

    wire [3:0] prediction;
    wire done;

    reg signed [15:0] image_mem [0:783999];
    reg [9:0] label_mem [0:999];

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

    initial begin

        $readmemh(
            "C:/Users/Aindril/Documents/daddy/AI-Hardware-Accelerator/outputs/mem/test_1000_images.mem",
            image_mem
        );
        $readmemh(
            "C:/Users/Aindril/Documents/daddy/AI-Hardware-Accelerator/outputs/mem/test_1000_labels.mem",
            label_mem
        );

        clk     = 0;
        reset   = 1;
        start   = 0;
        pixel   = 0;
        correct = 0;

        $display("ACCURACY TEST STARTED");

        for (img = 0; img < 1000; img = img + 1) begin

            //--------------------------------
            // RESET (every image)
            //--------------------------------
            reset = 1;
            start = 0;
            pixel = 0;

            @(posedge clk);
            @(posedge clk);

            reset = 0;

            @(posedge clk);

            //--------------------------------
            // START PULSE + FIRST PIXEL
            //--------------------------------
            @(negedge clk);
            pixel = image_mem[img * 784];
            start = 1'b1;

            @(posedge clk);      // accelerator samples start = 1
            #1;
            start = 1'b0;

            // Keep pixel 0 stable until the hidden layer consumes it.
            @(posedge clk);

            //--------------------------------
            // REMAINING 783 PIXELS
            //--------------------------------
            for (i = 1; i < 784; i = i + 1) begin
                @(negedge clk);
                pixel = image_mem[img * 784 + i];
            end

            $display(
                "Image %0d | pixels sent | waiting for done...",
                img
            );

            //--------------------------------
            // WAIT FOR DONE
            //--------------------------------
            fork : WAIT_OR_TIMEOUT
    begin
        wait (done == 1'b1);
        disable WAIT_OR_TIMEOUT;
    end

    begin
        #50000;
        $display("TIMEOUT ON IMAGE %0d", img);
        $finish;
    end
join

            #1;

            //--------------------------------
            // CHECK RESULT
            //--------------------------------
            if (prediction == label_mem[img]) begin
                correct = correct + 1;
                $display(
                    "Image %0d | Actual = %0d | Prediction = %0d | PASS",
                    img,
                    label_mem[img],
                    prediction
                );
            end
            else begin
                $display(
                    "Image %0d | Actual = %0d | Prediction = %0d | FAIL",
                    img,
                    label_mem[img],
                    prediction
                );
            end

        end

        $display("------------------------------------------");
        $display("1000 IMAGE ACCURACY");
        $display("------------------------------------------");
        $display("Correct = %0d / 1000", correct);
        $display("Accuracy = %0.2f%%", correct * 10.0);
        $display("------------------------------------------");
        
        $finish;

    end

endmodule