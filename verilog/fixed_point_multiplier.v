/*in this module I take inputs, multiply them, scale them by dividing by 
256 by shifting arithmetic right and finally storing the result*/

/* we use combinational circuit because multiplication requires no clock,
memory, register or previous state.*/
module fixed_point_multiplier (
    input signed [15:0] a,
    input signed [15:0] b,
    output signed [15:0] result
);

    wire signed [31:0] full_product;
    wire signed [31:0] scaled_product;

    assign full_product = a * b;
    assign scaled_product = full_product >>> 8;
    assign result = scaled_product[15:0];
endmodule