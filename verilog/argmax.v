module argmax(
    input clk,reset,enable,
    input signed [31:0] output [0:9],
    output reg [3:0] prediction,
    output reg done
);

    always @