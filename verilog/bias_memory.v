module bias_memory(
    input [0:5] address,
    output signed [15:0] bias
);

reg signed [15:0] memory [0:63];

initial begin
    $readmemh("b1_fixed.mem", memory);
end

assign bias = memory[address];
endmodule 