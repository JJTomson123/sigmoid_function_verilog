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
	wire valid;
	wire [50:0] number_start_ok, n_reg001;
	assign number = number_start_ok + n_reg001;

	//start_ok stage00(i_in_valid, i_x, valid_x, number_start_ok);
	REGP#(.BW(9)) reg001(.clk(clk), .rst_n(rst_n), .Q({valid_x_r,valid}), .D({i_x,i_in_valid}), .number(n_reg001));







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

module x_di1(i_x, i_a, control, number_x_di1);
	input [ 7:0] i_x;
	input control;
	output [6:0] i_a;
	output [50:0] number_x_di1;
	wire [50:0] number1, number2, number3, number4, number5, number6;
	assign number_x_di1 = number1 + number2 + number3 + number4 + number5 + number6;

	assign i_a[6] = i_x[7];
	MUX21H zx11(i_a[5], i_x[6], i_x[7], control, number1);
	MUX21H zx12(i_a[4], i_x[5], i_x[6], control, number2);
	MUX21H zx13(i_a[3], i_x[4], i_x[5], control, number3);
	MUX21H zx14(i_a[2], i_x[3], i_x[4], control, number4);
	MUX21H zx15(i_a[1], i_x[2], i_x[3], control, number5);
	MUX21H zx16(i_a[0], i_x[1], i_x[2], control, number6);


endmodule

//////////////////////////////////////////////////////////////////////////////

module find_region(i_x_msb3, const, number_find_region);
	input [2:0] i_x_msb3;
	output [2:0] region;
	output [50:0] number_find_region;
	wire [6:0] const;
	wire [2:0] i_x_msb3_n;
	wire n4Ton2_truth, n2Ton1_truth, n1Top1_truth, p1Top2_truth, p2Top4_truth;
	wire [50:0] n1_nd2, n1_nd3, n2_nd2, n2_nd3, n3_nd2, n1_iv, n2_iv, n3_iv;
	wire [50:0] n3_nd3, n7_nd2, n4_nd2, n5_nd2, n6_nd2;

	assign number_find_region = n1_iv + n2_iv + n3_iv;
	assign const[6] = 1'b0;
	
	IV iv_000(i_x_msb3_n[2], i_x_msb3[2], n1_iv);
	IV iv_001(i_x_msb3_n[1], i_x_msb3[1], n2_iv);
	IV iv_002(i_x_msb3_n[0], i_x_msb3[0], n3_iv);

	ND2	nd2_000(n4Ton2_truth, i_x_msb3[2], i_x_msb3[1], n1_nd2);
	ND3 nd3_000(n2Ton1_truth, i_x_msb3[2], i_x_msb3_n[1], i_x_msb3[0], n1_nd3);
	ND2 nd2_001(n1Top1_truth, i_x_msb3_n[1], i_x_msb3_n[0], n2_nd2);
	ND3 nd3_001(p1Top2_truth, i_x_msb3_n[2], i_x_msb3_n[1], i_x_msb3[0], n2_nd3);
	ND2 nd2_010(p2Top4_truth, i_x_msb3_n[2], i_x_msb3[1], n3_nd2);


	ND3 nd3_001(const[5], n1Top1_truth, p1Top2_truth, p2Top4_truth, n3_nd3);
	ND2 nd2_002(const[4], n2Ton1_truth, p2Top4_truth, n7_nd2);
	ND2 nd2_003(const[3], n4Ton2_truth, n2Ton1_truth, n4_nd2);
	ND2 nd2_004(const[2], n4Ton2_truth, p1Top2_truth, n5_nd2);
	ND2 nd2_005(const[1], p1Top2_truth, p2Top4_truth, n6_nd2);
	ND2 nd2_006(const[0], n2Ton1_truth, p2Top4_truth, n6_nd2);


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