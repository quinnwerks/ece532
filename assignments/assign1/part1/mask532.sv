module mask532(
    input [4:0]   n, // number of bits to mask
    input [31:0]  value_in, // input value
    output [31:0] value_out // output value
);

    logic [31:0] initial_mask;
    logic [31:0] mask;

    assign initial_mask = 32'hffffffff;
    assign mask = initial_mask >> n;
    assign value_out = value_in & mask;

endmodule
