module output_multiplier(
    input signed [31:0] a,
    input signed [15:0] b,
    output signed [31:0] result
);

    wire signed [47:0] full_product;
    wire signed [47:0] scaled_product;

    assign full_product = a*b;
    assign scaled_product = full_product >> 8;
    assign result = scaled_product [15:0];
endmodule