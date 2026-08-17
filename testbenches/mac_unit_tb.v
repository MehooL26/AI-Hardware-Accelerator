`timescale 1ps/1ps
module mac_unit_tb;
    reg clk,reset,enable;
    reg signed [15:0] a;
    reg signed [15:0] b;
    wire signed [31:0] accumulator;

    mac_unit uut(clk,reset,enable,a,b,accumulator);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        enable = 0;
        a = 0;
        b = 0;

        #10;

        reset = 0;
        enable = 1;
        a = 12800;
        b = 512;

        #10;
        enable = 0;
        #10;
        //this won't be added because enable=0
        a = 321;
        b = 123;

        #10;
        $display("accumulator=%d",accumulator);
    end
endmodule