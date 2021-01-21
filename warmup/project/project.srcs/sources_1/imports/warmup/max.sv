`timescale 1 ns / 1 ps
module top (
    input       clk,
    input       reset
);

max m (
    .clk(clk),
    .reset(reset),
    .in_data(),
    .in_valid(),
    .out_largest()
);

endmodule


module max (
    input       clk,
    input       reset,
    input[3:0]  in_data,
    input       in_valid,
    output[3:0] out_largest
);

reg [3:0] max_data;

always_ff@(posedge clk or posedge reset) begin
    if (reset == 'b1) begin
        max_data <= 'b0;
    end
    else if (in_valid == 'b1 & in_data > max_data) begin
        max_data <= in_data;
    end
end

assign out_largest = max_data;

endmodule
