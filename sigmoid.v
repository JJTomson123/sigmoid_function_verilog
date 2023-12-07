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
	wire [7:0] valid_x, valid_x_r;
	wire [50:0] number_start_ok, n_reg001;
	assign number = number_start_ok + n_reg001;

	start_ok stage00(i_in_valid, i_x, valid_x, number_start_ok);

	REGP#(.BW(8)) reg001(.clk(clk), .rst_n(rst_n), .Q(valid_x_r), .D(valid_x), .number(n_reg001));





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

///////////////////////////////////////////////////////////////////////////

module EIGHT_BIT_AN2#(
	parameter BW = 8
)(
	output [BW-1:0] Z,
	input  [BW-1:0] A,
	input  [BW-1:0] B,
	output [  50:0] number
);

wire [50:0] numbers [0:BW-1];

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		AN2	an0(Z[i], A[i], B[i], numbers[i]);
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

///////////////////////////////////////////////////////////////////////////

module find_region(i_x_msb3, B, number_find_region);
	input clk, rst_n;
	input [2:0] i_x_msb3;
	output [2:0] region;
	output [50:0] number_find_region;
	wire [2:0] d_output;
	assign number_find_region = n_reg001;

	AN2()



	

endmodule

///////////////////////////////////////////////////////////////////////////////////////////

module start_ok(i_in_valid, i_x, o_x, number_start_ok);
	input i_in_valid;
	input [7:0] i_x;
	output [7:0] o_x;
	output [50:0] number_start_ok;

	EIGHT_BIT_AN2 EB_an2_00(.Z(o_x), .A(i_x), .B({8{i_in_valid}}), .number(number_start_ok));

endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////

module n4Ton2();
	input 


endmodule