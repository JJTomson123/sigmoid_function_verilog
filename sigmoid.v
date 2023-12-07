module sigmoid (
	input         clk,
	input         rst_n,
	input         i_in_valid,
	input  [ 7:0] i_x,
	output [15:0] o_y,
	output        o_out_valid,
	output [50:0] number
);

// Your design

endmodule

//BW-bit FD2
module REGP#(
	parameter BW = 2
)(
	input           clk,
	input           rst_n,
	output [BW-1:0] Q,
	input  [BW-1:0] D,
	output [  50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FD2 f0(Q[i], D[i], clk, rst_n, numbers[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum;
integer j;
always @(*) begin
	sum = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
	end
end

assign number = sum;

endmodule

module find_region(clk, rst_n, i_x_msb3, i_in_valid, region, number_find_region);
	input clk, rst_n, i_in_valid;
	input [2:0] i_x_msb3;
	output [2:0] region;
	output [50:0] number_find_region;
	wire [2:0] d_output;
	wire [50:0] n_reg001;
	assign number_find_region = n_reg001;

	

	REGP#(.BW(3)) reg001(.clk(clk), .rst_n(rst_n), .Q(d_output), .D(i_x_msb3), .number(n_reg001));





endmodule

module n4Ton2();
	input 


endmodule