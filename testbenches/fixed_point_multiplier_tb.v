`timescale 1ps/1ps
module fixed_point_multiplier_tb;
    reg signed [15:0] a;
    reg signed [15:0] b;
    wire signed [15:0] result;

    fixed_point_multiplier dut(a,b,result);

    initial begin
        
        // TEST-1 : 0.5*0.8
        a = 16'sd128;
        b = 16'sd205;
        $display("Test 1: a=%d, b=%d, result=%d",a,b,result);
        #10;

        // TEST-2 : 1.5*2.0
        a = 16'sd384;
        b = 16'sd512;
        $display("Test 2: a=%d, b=%d, result=%d",a,b,result);
        #10;

        // TEST-3 : 0.75*(-0.5)
        a = 16'sd192;
        b = -16'sd128;
        $display("Test 3: a=%d, b=%d, result=%d",a,b,result);
        #10;

        // TEST-4 : (-1.25)*(-2.0)
        a = -16'sd320;
        b = -16'sd512;
        $display("Test 4: a=%d, b=%d, result=%d",a,b,result);
        #10;
        $finish;
    end
endmodule