module output_layer(
    input clk,reset,enable,
    input signed [31:0] hidden_output [0:63],
    output signed [31:0] outputs [0:9],
    output reg done
);

reg [5:0] hidden_index;
wire signed [31:0] output_accumulator [0:9];

// sabse pehle saved weights chahiye which are w2_fixed and b2_fixed

reg signed [15:0] weight_mem [0:639];
reg signed [15:0] biased_mem [0:9];

initial begin
    $readmemh("w2_fixed.mem",weight_mem);
    $readmemh("b2_fixed.mem",biased_mem);
end

always @(posedge clk) begin
    if(reset) begin
        hidden_index <= 6'd0;
        done <= 1'b0;
    end
    else if(enable) begin
        if(hidden_index == 6'd63) begin
            done <= 1'b1;
            hidden_index <= hidden_index;
        end
        else begin
            hidden_index <= hidden_index + 1'b1;
            done <= 1'b0;
        end
    end
end
// generating 10 neuron outputs
// now in this case we dont want to apply ReLU to the output so we need a seperate MAC unit for this file
/*
genvar i;
generate
    for(i=0;i<10;i=i+1) begin
        hidden_layer hidden_layer_inst(clk,reset,enable,pixel,output,done);
    end
endgenerate
*/

// above is the wrong approach as it will apply ReLU to the output

genvar i;
generate
    for(i=0;i<10;i++) begin
        output_mac inst(clk,reset,enable,hidden_output[hidden_index],weight_mem[i*64+hidden_index],output_accumulator[i]);
    end
endgenerate

genvar j;
generate
    for(j=0;j<10;j++) begin
        wire signed [31:0] bias_extended;

        assign bias_extended = {{16{biased_mem[j][15]}},biased_mem};

        assign outputs[j] = output_accumulator[j] + bias_extended; 
    end
endgenerate

endmodule

// so our output needs 32 bit hidden output but our current mac unit takes 16 bits as output, so instead of editing that
// we add 2 files for mac operation and multiplying operation for output