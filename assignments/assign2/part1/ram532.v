(* ram_style = "registers" *)
module ram532_registers
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

(* ram_style = "bram" *)
module ram532_bram
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

(* ram_style = "distributed" *)
module ram532_distributed
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

module ram532_addr08_registers(
  input  clk,
  input  wen,
  input  [31: 0] wdata,
  input  [7: 0] waddr,
  output [31: 0] rdata_0,
  input  [7: 0] raddr_0,
  output [31: 0] rdata_1,
  input  [7: 0] raddr_1
);

ram532_registers #(
    .C_ADDR_WIDTH(8),
    .C_DATA_WIDTH(32)
)inst (
    .clk(clk),
    .wen(wen),
    .wdata(wdata),
    .waddr(waddr),
    .rdata_0(rdata_0),
    .raddr_0(raddr_0),
    .rdata_1(rdata_1),
    .raddr_1(raddr_1)
);
endmodule

module ram532_addr08_bram (
  input  clk,
  input  wen,
  input  [31: 0] wdata,
  input  [7: 0] waddr,
  output [31: 0] rdata_0,
  input  [7: 0] raddr_0,
  output [31: 0] rdata_1,
  input  [7: 0] raddr_1
);

ram532_bram #(
    .C_ADDR_WIDTH(8),
    .C_DATA_WIDTH(32)
)inst (
    .clk(clk),
    .wen(wen),
    .wdata(wdata),
    .waddr(waddr),
    .rdata_0(rdata_0),
    .raddr_0(raddr_0),
    .rdata_1(rdata_1),
    .raddr_1(raddr_1)
);
endmodule

module ram532_addr08_distributed (
  input  clk,
  input  wen,
  input  [31: 0] wdata,
  input  [7: 0] waddr,
  output [31: 0] rdata_0,
  input  [7: 0] raddr_0,
  output [31: 0] rdata_1,
  input  [7: 0] raddr_1
);

ram532_distributed #(
    .C_ADDR_WIDTH(8),
    .C_DATA_WIDTH(32)
)inst (
    .clk(clk),
    .wen(wen),
    .wdata(wdata),
    .waddr(waddr),
    .rdata_0(rdata_0),
    .raddr_0(raddr_0),
    .rdata_1(rdata_1),
    .raddr_1(raddr_1)
);
endmodule

module ram532_addr10_registers(
  input  clk,
  input  wen,
  input  [31: 0] wdata,
  input  [9: 0] waddr,
  output [31: 0] rdata_0,
  input  [9: 0] raddr_0,
  output [31: 0] rdata_1,
  input  [9: 0] raddr_1
);

ram532_registers #(
    .C_ADDR_WIDTH(10),
    .C_DATA_WIDTH(32)
)inst (
    .clk(clk),
    .wen(wen),
    .wdata(wdata),
    .waddr(waddr),
    .rdata_0(rdata_0),
    .raddr_0(raddr_0),
    .rdata_1(rdata_1),
    .raddr_1(raddr_1)
);
endmodule

module ram532_addr10_bram(
  input  clk,
  input  wen,
  input  [31: 0] wdata,
  input  [9: 0] waddr,
  output [31: 0] rdata_0,
  input  [9: 0] raddr_0,
  output [31: 0] rdata_1,
  input  [9: 0] raddr_1
);

ram532_bram #(
    .C_ADDR_WIDTH(10),
    .C_DATA_WIDTH(32)
)inst (
    .clk(clk),
    .wen(wen),
    .wdata(wdata),
    .waddr(waddr),
    .rdata_0(rdata_0),
    .raddr_0(raddr_0),
    .rdata_1(rdata_1),
    .raddr_1(raddr_1)
);
endmodule

module ram532_addr10_distributed(
  input  clk,
  input  wen,
  input  [31: 0] wdata,
  input  [9: 0] waddr,
  output [31: 0] rdata_0,
  input  [9: 0] raddr_0,
  output [31: 0] rdata_1,
  input  [9: 0] raddr_1
);

ram532_distributed #(
    .C_ADDR_WIDTH(10),
    .C_DATA_WIDTH(32)
)inst (
    .clk(clk),
    .wen(wen),
    .wdata(wdata),
    .waddr(waddr),
    .rdata_0(rdata_0),
    .raddr_0(raddr_0),
    .rdata_1(rdata_1),
    .raddr_1(raddr_1)
);
endmodule
