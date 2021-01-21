`timescale 1 ns / 1 ps
module tb();
    // Set up clock signal
    logic clk;
    initial clk = 'b1;
    always #10 clk = ~clk;

    logic reset, in_valid;
    logic [3:0] in_data, out_largest;

    // Test case
    initial begin
        // test reset
        #20;
        reset = 1;
        #80;
        assert(out_largest == 0) else $error("Reset don't work!");
        reset = 0;
                
        // test select signal with valid on
        in_valid = 1;
        in_data = 4'd5;
        #20;
        assert(out_largest == 5) else $error("Unexpected value case 1!");

        
        // test don't select a smaller signal
        in_data = 4'd4;
        #20;
        assert(out_largest == 5) else $error("Unexpected value case 2!");
        
        // test don't select a larger signal if not valid
        in_valid = 0;
        in_data = 4'd6;
        #20
        assert(out_largest == 5) else $error("Unexpected value case 3!");

        
        // test larger signal if valid
        in_valid = 1;
        in_data = 4'd6;
        #20
        assert(out_largest == 6) else $error("Unexpected value case 3!");

        
        $finish();
    end

    max dut (
        .clk(clk),
        .reset(reset),
        .in_data(in_data),
        .in_valid(in_valid),
        .out_largest(out_largest)
    );
endmodule
