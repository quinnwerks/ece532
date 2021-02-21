(* use_dsp48 = "yes" *)
module preadd532
#(
  parameter C_WIDTH = 16
)
(
  input clk,
  input in_vld,
  input  signed [C_WIDTH-1: 0] in_a,
  input  signed [C_WIDTH-1: 0] in_b,
  input  signed [C_WIDTH-1: 0] in_c,
  output signed [2*C_WIDTH: 0] out,
  output out_vld
);
reg [C_WIDTH-1:0] reg_a, reg_b, reg_c;
reg [2*C_WIDTH:0] reg_out;

// Your Code Here
// Input
always @(posedge clk) begin
    // Input
    if (in_vld) begin
        reg_a <= in_a;
        reg_b <= in_b;
        reg_c <= in_c;
    end
    else begin
        reg_a <= reg_a;
        reg_b <= reg_b;
        reg_c <= reg_c;
    end
    
end

assign out_vld = in_vld;
assign out = (reg_a + reg_b) * reg_c;

endmodule
