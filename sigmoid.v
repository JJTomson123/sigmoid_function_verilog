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
	wire [7:0] valid_x_1;
	wire [50:0] n_reg001, n_reg002, number_x_di1, number_find_region, number_adder1, number_adder2, n_reg004;
	wire [6:0] i_x_div;
	wire [6:0] constant, const_t1;
	wire nouse, carryout_1;
	wire [6:0] sum;

	assign sum[6] = 1'b0;
	assign number = n_reg001;

	//start_ok stage00(i_in_valid, i_x, valid_x, number_start_ok);
	find_region fr_ok(i_x[7:5], constant, number_find_region);
	
	x_di1 divide1(i_x[7:1], i_x_div, number_x_di1);

	REGP#(.BW(8)) reg001(.clk(clk), .rst_n(rst_n), .Q(valid_x_1), .D({i_x_div,i_in_valid}), .number(n_reg001));
	REGP#(.BW(7)) reg002(.clk(clk), .rst_n(rst_n), .Q(const_t1), .D(constant), .number(n_reg002));


	adder_adder	adad1(valid_x_1[3:1], const_t1[2:0], 1'b0, sum[2:0], carryout_1, number_adder1);
	adder_adder	adad2(valid_x_1[6:4], const_t1[5:3], carryout_1, sum[5:3], nouse, number_adder2);

	REGP#(.BW(8)) reg003(.clk(clk), .rst_n(rst_n), .Q({o_y[15:9],o_out_valid}), .D({sum,valid_x_1[0]}), .number(n_reg004));


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

module THREE_BIT_ADDER#(
	parameter BW = 3
)(
	output [BW-1:0] S,
	output [  BW:0] CO,
	output [BW-1:0] P,
	input  [BW-1:0] A,
	input  [BW-1:0] B,
	input  CI,
	output [  50:0] number

);

wire [50:0] numbers [0:BW-1];
wire [50:0] numbers2 [0:BW-1];
assign CO[0] = CI;

genvar i;
generate
	for (i=0; i<BW; i=i+1) begin
		FA1 fa000(CO[i+1],S[i],A[i],B[i],CO[i],numbers[i]);
		EO xor000(P[i],A[i],B[i],numbers2[i]);
	end
endgenerate

//sum number of transistors
reg [50:0] sum, sum2;
integer j;
always @(*) begin
	sum = 0;
	sum2 = 0;
	for (j=0; j<BW; j=j+1) begin 
		sum = sum + numbers[j];
		sum2 = sum2 + numbers2[j];
	end
end

assign number = sum + sum2;

endmodule

///////////////////////////////////////////////////////////////////////////

module x_di1(i_x, i_c, number_x_di1);
	input [6:0] i_x;
	output [6:0] i_c;
	output [50:0] number_x_di1;
	wire [50:0] number1, number2, number3, number4, number5, number6;
	wire [50:0] number11, number22, number33, number44, number55, number66;
	assign number_x_di1 = number1 + number2 + number3 + number4 + number5 + number6 + number11 + number22 + number33 + number44 + number55 + number66;
	wire [6:0] i_a;

	assign i_c[6] = i_a[6];
	assign i_a[6] = i_x[6];
	
	MUX21H zx11(i_a[5], i_x[5], i_x[6], i_x[4], number1);
	MUX21H zx12(i_a[4], i_x[4], i_x[5], i_x[4], number2);
	MUX21H zx13(i_a[3], i_x[3], i_x[4], i_x[4], number3);
	MUX21H zx14(i_a[2], i_x[2], i_x[3], i_x[4], number4);
	MUX21H zx15(i_a[1], i_x[1], i_x[2], i_x[4], number5);
	MUX21H zx16(i_a[0], i_x[0], i_x[1], i_x[4], number6);

	
	MUX21H zx111(i_c[5], i_a[5], i_a[6], i_x[5], number11);
	MUX21H zx122(i_c[4], i_a[4], i_a[6], i_x[5], number22);
	MUX21H zx133(i_c[3], i_a[3], i_a[5], i_x[5], number33);
	MUX21H zx144(i_c[2], i_a[2], i_a[4], i_x[5], number44);
	MUX21H zx155(i_c[1], i_a[1], i_a[3], i_x[5], number55);
	MUX21H zx166(i_c[0], i_a[0], i_a[2], i_x[5], number66);


endmodule

//////////////////////////////////////////////////////////////////////////////

module find_region(i_x_msb3, const, number_find_region);
	input [2:0] i_x_msb3;
	output [6:0] const;
	output [50:0] number_find_region;
	wire [2:0] i_x_msb3_n;
	wire n4Ton2_truth, n2Ton1_truth, n1Top1_truth, p1Top2_truth, p2Top4_truth;
	wire [50:0] n1_nd2, n1_nd3, n2_nd2, n2_nd3, n3_nd2, n1_iv, n2_iv, n3_iv;
	wire [50:0] n3_nd3, n7_nd2, n4_nd2, n5_nd2, n6_nd2, n8_nd2;

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


	ND3 nd3_002(const[5], n1Top1_truth, p1Top2_truth, p2Top4_truth, n3_nd3);
	ND2 nd2_002(const[4], n2Ton1_truth, p2Top4_truth, n7_nd2);
	ND2 nd2_003(const[3], n4Ton2_truth, n2Ton1_truth, n4_nd2);
	ND2 nd2_004(const[2], n4Ton2_truth, p1Top2_truth, n5_nd2);
	ND2 nd2_005(const[1], p1Top2_truth, p2Top4_truth, n6_nd2);
	ND2 nd2_006(const[0], n2Ton1_truth, p2Top4_truth, n8_nd2);


endmodule

///////////////////////////////////////////////////////////////////////////////////////////

/* module start_ok(i_in_valid, i_x, o_x, number_start_ok);
	input i_in_valid;
	input [7:0] i_x;
	output [7:0] o_x;
	output [50:0] number_start_ok;

	EIGHT_BIT_AN2 EB_an2_00(.Z(o_x), .A(i_x), .B({8{i_in_valid}}), .number(number_start_ok));

endmodule */

//////////////////////////////////////////////////////////////////////////////////////////////////

module adder_adder(a, b, carryin, sum, carryout, number);
	input [2:0] a,b;
	input carryin;
	output [2:0] sum;
	output carryout;
	output [50:0] number;
	wire [2:0] p_o;
	wire [3:0] co_o;
	wire [50:0] number_nand3, number_mux1, n_tbadder00;
	assign number = number_nand3 + number_mux1 + n_tbadder00;

	THREE_BIT_ADDER#(.BW(3)) tbadder001(.S(sum), .CO(co_o), .P(p_o), .A(a), .B(b), .CI(carryin), .number(n_tbadder00));

	ND3 nand12(temp1,p_o[0],p_o[1],p_o[2],number_nand3);

	MUX21H zx126(carryout, co_o[3], carryin, temp1, number_mux1);

endmodule