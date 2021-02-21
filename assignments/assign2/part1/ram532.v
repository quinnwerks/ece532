(* ram_style = "block" *)
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

reg [C_DATA_WIDTH-1:0] mem [(2**C_ADDR_WIDTH)-1:0];
reg [C_DATA_WIDTH-1:0] data_0;
reg [C_DATA_WIDTH-1:0] data_1;

// Your Code Here
// Read Logic
always @(posedge clk) begin
    data_0 <= mem[raddr_0];
    data_1 <= mem[raddr_1];
end

// Write logic
always @(posedge clk) begin
    if (wen) begin
        mem[waddr] <= wdata;
    end
end

assign rdata_0 = data_0;
assign rdata_1 = data_1;

endmodule
