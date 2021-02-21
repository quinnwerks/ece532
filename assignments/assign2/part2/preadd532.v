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

// Your Code Here

endmodule
