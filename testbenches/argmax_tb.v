`timescale 1ns/1ps
module argmax_tb;
    reg clk,reset,enable;
    reg [319:0] outputs;
    wire [3:0] prediction;
    wire done;

    integer i;

    argmax dut(clk,reset,enable,outputs,prediction,done);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        enable = 0;

        for(i=0;i<10;i=i+1) begin
            outputs[i*32 +: 32] = 32'sd0;
        end
        #10;
        reset = 0;

        @(negedge clk);
        outputs[0*32 +: 32] = 100;
        outputs[1*32 +: 32] = 250;
        outputs[2*32 +: 32] = 80;
        outputs[3*32 +: 32] = 900;
        outputs[4*32 +: 32] = 150;
        outputs[5*32 +: 32] = 50;
        outputs[6*32 +: 32] = 300;
        outputs[7*32 +: 32] = 400;
        outputs[8*32 +: 32] = 200;
        outputs[9*32 +: 32] = 100;

        enable = 1;

        for(i=0;i<10;i=i+1) begin
            @(posedge clk);
        end

        $display("expected prediction = 3");
        $display("actual prediction = %0d",prediction);
        
        if (prediction == 4'd3) 
            $display("test passed");
        else
            $display("test failed");

        $finish;

    end
endmodule
