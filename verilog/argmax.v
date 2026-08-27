module argmax(
    input clk,reset,enable,
    input signed [31:0] outputs [0:9],
    output reg [3:0] prediction,
    output reg done
);

    reg [3:0] index;
    reg signed [31:0] max_value;

    always @(posedge clk) begin
        if(reset) begin
            index <= 4'b0;
            done <= 1'b0;
            max_value <= -32'sd2147483648;
            prediction <= 4'd0;
        end

        else if(enable) begin
            if(index == 4'd0) begin
                max_value <= outputs[0];
                prediction <= 4'd0;
                index <= 4'd1;
                done <= 1'b0;
            end
            else if(index < 4'd10) begin
                if(outputs[index] > max_value) begin
                    max_value <= outputs[index];
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