`timescale 1 ns / 1ps
module cube532_tb();
logic clk;
logic [7:0] in;
logic [23:0] out;
logic [23:0] out_golden;

int correct_out;

initial clk = 1'b1;
always #5 clk = ~clk;

initial begin
    #5;
    for (int i = 0; i < 256; i++) begin
        correct_out = i*i*i;
        in = i;
        // Takes one cycle to register input, another cycle for output to appear
        #20;
        assert(correct_out == out_golden && correct_out == out) else $stop("Values incorrect");
    end
end


cube532 dut (
    .clk(clk),
    .in(in),
    .out(out)
);

cube532_golden dut_golden (
    .clk(clk),
    .in(in),
    .out(out_golden)
);

endmodule