/*the MAC unit needs a clock to keep multiplying 784 inputs so we use sequential circuit,
the value of accumulator will be stored in a register consuming space in the hardware.

The clock tells the register to update its value on each rising edge of the clock*/

// we do not use 'assign' here because it does not remember the previous value thus we need to use 'always'

module mac_unit(
    input clk, reset, enable,
    input signed [15:0] a,
    input signed [15:0] b,
    output reg signed [31:0] accumulator
);

    wire signed [15:0] product;

    fixed_point_multiplier multiplier(a,b,product);

    always @(posedge clk) begin
        if (reset)
            accumulator <= 0;
        else if (enable)
            accumulator <= accumulator + product; 
    end
endmodule

// reset will always be checked first -> called priority logic