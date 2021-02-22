module preadd532_tb();
    localparam C_WIDTH_SMALL = 16;
    localparam C_WIDTH_BIG = 32;

    logic clk;
    logic [C_WIDTH_SMALL-1:0] in_a_small, in_b_small, in_c_small;
    logic [2*C_WIDTH_SMALL:0] out_small;
    logic [C_WIDTH_BIG-1:0] in_a_big, in_b_big, in_c_big;
    logic [2*C_WIDTH_BIG:0] out_big;
    logic in_vld, out_vld_small, out_vld_big;
    
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
            in_a_small = a[i];
            in_b_small = b[i];
            in_c_small = c[i];
            in_a_big = a[i];
            in_b_big = b[i];
            in_c_big = c[i];
            in_vld = '1;
            @(posedge clk);
            assert(out_vld_small == 1'b1 && out_vld_big == 1'b1) else $stop("Output should be valid");
            assert(out_small == (a[i] + b[i]) * c[i]) else $stop("Output Small is incorrect");
            assert(out_big == (a[i] + b[i]) * c[i]) else $stop("Output Big is incorrect");
            in_vld = '0;
            @(posedge clk);
            assert(out_vld_small == 1'b0 && out_vld_big == 1'b0) else $stop("Output should no longer be valid!");            
        end
        
    end
    
    preadd532_16_dsp_yes dut_small (
        .clk(clk),
        .in_a(in_a_small),
        .in_b(in_b_small),
        .in_c(in_c_small),
        .in_vld(in_vld),
        .out(out_small),
        .out_vld(out_vld_small)
    );
    
    preadd532_32_dsp_yes dut_big (
        .clk(clk),
        .in_a(in_a_big),
        .in_b(in_b_big),
        .in_c(in_c_big),
        .in_vld(in_vld),
        .out(out_big),
        .out_vld(out_vld_big)
    );
endmodule 