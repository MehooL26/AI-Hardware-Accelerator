module weight_memory_tb;
    reg [15:0] address;
    wire signed [15:0] weight;

    weight_memory uut (address,weight);

    initial begin
        {address} = 0;
    end

    initial begin
        $display("Address = %d",address);
        $display("Weights = %d",weight);

        #10;
        address = 100;
        $display("Address = %d",address);
        $display("Weights = %d",weight);

        #10;
        address = 50175;
        $display("Address = %d",address);
        $display("Weights = %d",weight);

        $finish;
    end
endmodule