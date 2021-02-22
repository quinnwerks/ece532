module cube532
(
  input clk,
  input  [7:0]  in,
  output [23:0] out
);

wire [31:0] rom_out;

rom rom_inst (
    .clk(clk),
    .raddr(in),
    .data(rom_out)
);

assign out = rom_out[23:0];
endmodule

module cube532_golden (
    input clk,
    input [7:0] in,
    output [23:0] out
);
    reg [23:0] reg_out;
    reg [23:0] reg_out_2;
    always @(posedge clk) begin
        reg_out <= in*in*in;
        reg_out_2 <= reg_out;
    end
    
    assign out = reg_out_2;
endmodule

module rom (
    input clk,
    input [7:0]     raddr,
    input [31:0]    data
);

(* rom_style = "block" *) reg [31:0] rom [255:0];
reg [31:0] reg_data;
reg [31:0] reg_data_2;

initial $readmemh("cube.mem", rom);
always @(posedge clk) begin
    reg_data <= rom[raddr];
    reg_data_2 <= reg_data;
end
assign data = reg_data_2;

endmodule
