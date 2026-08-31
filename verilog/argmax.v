// This module selects the largest value among the output neurons and gives the prediction

module argmax(
    input clk,reset,enable,
    // Packed bus: score i occupies outputs[i*32 +: 32].
    input [319:0] outputs,
    output reg [3:0] prediction,
    output reg done
);

    reg [3:0] index;
    reg signed [31:0] max_value;
    wire signed [31:0] current_value;

    assign current_value = outputs[index*32 +: 32];

    always @(posedge clk) begin
        if(reset) begin
            index <= 4'b0;
            done <= 1'b0;
            max_value <= -32'sd2147483648;
            prediction <= 4'd0;
        end

        else if(enable) begin
            if(index == 4'd0) begin
                max_value <= outputs[0 +: 32];
                prediction <= 4'd0;
                index <= 4'd1;
                done <= 1'b0;
            end
            else if(index < 4'd10) begin
                if(current_value > max_value) begin
                    max_value <= current_value;
                    prediction <= index;
                end
                if (index == 4'd9) begin
                    done <= 1'b1;
                    index <= index;
                end

                else begin
                    index <= index + 1'b1;
                    done <= 1'b0;
                end
            end
        end
    end
endmodule
