module preadd532_tb();
    localparam C_WIDTH = 16;
    logic clk;
    logic [C_WIDTH-1:0] in_a, in_b, in_c;
    logic [2*C_WIDTH:0] out;
    logic in_vld, out_vld;
    
    int a [$], b [$], c [$];
    int num_cases;

    initial begin
        clk = 1'b1;
    end
    always #5 clk = ~clk;
    
    initial begin
        // Setup cases
        a = {5, 3, 3, 1};
        b = {7, 0, 2, 4};
        c = {9, 2, 0, 2};
        assert(a.size == b.size && c.size == b.size) else $stop("Cases not setup properly");
        num_cases = a.size;
    
        @(posedge clk);
        //assert(out_vld == 1'b0) else $stop("Output should not be valid yet");
        @(posedge clk);
        for (int i = 0; i < num_cases; i++) begin
            in_a = a[i];
            in_b = b[i];
            in_c = c[i];
            in_vld = '1;
            @(posedge clk);
            assert(out_vld == 1'b1) else $stop("Output should be valid");
            assert(out == (in_a + in_b) * in_c) else $stop("Output is incorrect");
            in_vld = '0;
            @(posedge clk);
            assert(out_vld == 1'b0) else $stop("Output should no longer be valid!");            
        end
        
    end
    
    preadd532 #(
        .C_WIDTH(C_WIDTH)
    ) dut (
        .clk(clk),
        .in_a(in_a),
        .in_b(in_b),
        .in_c(in_c),
        .in_vld(in_vld),
        .out(out),
        .out_vld(out_vld)
    );
endmodule 