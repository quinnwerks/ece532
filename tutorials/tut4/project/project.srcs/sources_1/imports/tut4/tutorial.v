`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tutorial
//////////////////////////////////////////////////////////////////////////////////


module tutorial (
	input clk,
	input reset,
    input [7:0] swt,
    output [7:0] led
    );

	wire direct_connect = swt[7];
	wire [7:0] out_value;

	//Counter
	wire[26:0] count_limit = {swt[6:0],20'd0};
	reg [26:0] counter;

	always @(posedge clk) begin
		if(~reset) begin
			counter <= 27'd0;
		end else if(counter == count_limit) begin
			counter <= 27'd0;
		end else begin
			counter <= counter + 1;
		end
	end

	//Shift LED values
	reg [6:0] led_shift;

	always @(posedge clk) begin
		if(~reset) begin
			led_shift <= 7'b0000001;
		end else if(counter == count_limit) begin
			led_shift <= {led_shift[5:0],led_shift[6]};
		end
	end

	//Output
	assign out_value = {direct_connect,led_shift};
	assign led = out_value;
    
endmodule