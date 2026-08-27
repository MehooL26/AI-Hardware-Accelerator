module output_mac(
    input clk,reset,enable,
    input signed [31:0] a,
    input signed [15:0] b,
    output reg signed [31:0] output_mac_accumulator
);

wire signed [31:0] product;

output_multiplier multiplier(a,b,product);

always @(posedge clk) begin
    if(reset) begin
        output_mac_accumulator <= 0;
    end
    else if(enable) begin
        output_mac_accumulator <= output_mac_accumulator + product;
    end
end
endmodule