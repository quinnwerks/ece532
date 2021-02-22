(* use_dsp48 = "yes" *)
module preadd532_dsp_yes
#(
  parameter C_WIDTH = 32
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

(* use_dsp48 = "no" *)
module preadd532_dsp_no
#(
  parameter C_WIDTH = 32
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


module preadd532_16_dsp_yes (
  input clk,
  input in_vld,
  input  signed [15: 0] in_a,
  input  signed [15: 0] in_b,
  input  signed [15: 0] in_c,
  output signed [2*16: 0] out,
  output out_vld
);

preadd532_dsp_yes #(
    .C_WIDTH(16)
) inst (
    .clk(clk),
    .in_a(in_a),
    .in_b(in_b),
    .in_c(in_c),
    .in_vld(in_vld),
    .out(out),
    .out_vld(out_vld)
);

endmodule

module preadd532_32_dsp_yes (
  input clk,
  input in_vld,
  input  signed [31: 0] in_a,
  input  signed [31: 0] in_b,
  input  signed [31: 0] in_c,
  output signed [2*32: 0] out,
  output out_vld
);

preadd532_dsp_yes #(
    .C_WIDTH(32)
) inst (
    .clk(clk),
    .in_a(in_a),
    .in_b(in_b),
    .in_c(in_c),
    .in_vld(in_vld),
    .out(out),
    .out_vld(out_vld)
);

endmodule

module preadd532_16_dsp_no (
  input clk,
  input in_vld,
  input  signed [15: 0] in_a,
  input  signed [15: 0] in_b,
  input  signed [15: 0] in_c,
  output signed [2*16: 0] out,
  output out_vld
);

preadd532_dsp_no #(
    .C_WIDTH(16)
) inst (
    .clk(clk),
    .in_a(in_a),
    .in_b(in_b),
    .in_c(in_c),
    .in_vld(in_vld),
    .out(out),
    .out_vld(out_vld)
);

endmodule

module preadd532_32_dsp_no (
  input clk,
  input in_vld,
  input  signed [31: 0] in_a,
  input  signed [31: 0] in_b,
  input  signed [31: 0] in_c,
  output signed [2*32: 0] out,
  output out_vld
);

preadd532_dsp_no #(
    .C_WIDTH(32)
) inst (
    .clk(clk),
    .in_a(in_a),
    .in_b(in_b),
    .in_c(in_c),
    .in_vld(in_vld),
    .out(out),
    .out_vld(out_vld)
);

endmodule
