// this file is to connect the python phase with the verilog phase, it tracks the weights stored in .mem files
module weight_memory (
    input [15:0] address,
    output signed [15:0] weight
);

reg signed [15:0] memory [0:50175];

initial begin
    $readmemh("w1_fixed.mem", memory);
end

assign weight = memory[address];
    
endmodule

// we have 50176 total weights so we need to use 2^16 i.e address width becomes 16 bits