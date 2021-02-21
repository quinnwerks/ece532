module ram532
#(
  parameter C_ADDR_WIDTH = 8,
  parameter C_DATA_WIDTH = 32
)
(
  input  clk,
  input  wen,
  input  [C_DATA_WIDTH-1: 0] wdata,
  input  [C_ADDR_WIDTH-1: 0] waddr,
  output [C_DATA_WIDTH-1: 0] rdata_0,
  input  [C_ADDR_WIDTH-1: 0] raddr_0,
  output [C_DATA_WIDTH-1: 0] rdata_1,
  input  [C_ADDR_WIDTH-1: 0] raddr_1
);

// Your Code Here

endmodule
