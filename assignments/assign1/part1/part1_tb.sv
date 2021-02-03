module tb_mask532();

logic [4:0]  n;
logic [31:0] value_in;
logic [31:0] value_out;

logic [31:0] value_golden;
initial begin
    value_in = 32'hffffffff;
    for (int i = 0; i < 32; i++) begin
        n = i;
        #5;
        value_golden = value_in & (32'hffffffff >> i);
        $monitor("MONITOR: n=%x, value_in=%x, value_out=%x value_golden=%x",
        n, value_in, value_out, value_golden);
        $display("DISPLAY: n=%x, value_in=%x, value_out=%x value_golden=%x",
        n, value_in, value_out, value_golden);
        assert(value_out == value_golden) else $error("Golden %x != Output %x", value_golden, value_out);
    end
    $finish();
end


mask532 dut(
    .n(n),
    .value_in(value_in),
    .value_out(value_out)
);

endmodule
