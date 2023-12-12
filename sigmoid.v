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
	wire [50:0] n_reg001, number_x_di1, number_find_region, number_adder1, number_adder2;
	wire [7:0] i_x_div;
	wire [7:0] constant;
	wire nouse, carryout_1;
	wire [7:0] sum;

	assign number = n_reg001 + number_find_region + number_x_di1 + number_adder1 + number_adder2;
	assign o_y[7:0] = 9'd0;

	//start_ok stage00(i_in_valid, i_x, valid_x, number_start_ok);
	find_region fr_ok(i_x[7:5], constant, number_find_region);
	
	x_di1 divide1(i_x, i_x_div, number_x_di1);

	//REGP#(.BW(9)) reg001(.clk(clk), .rst_n(rst_n), .Q(valid_x_1), .D({i_in_valid,i_x_div}), .number(n_reg001));
	//REGP#(.BW(7)) reg002(.clk(clk), .rst_n(rst_n), .Q(const_t1), .D(constant), .number(n_reg002));

	adder_adder	adad1(i_x_div[3:0], constant[3:0], 1'b0, sum[3:0], carryout_1, number_adder1);
	adder_adder	adad2(i_x_div[7:4], constant[7:4], carryout_1, sum[7:4], nouse, number_adder2);

	REGP#(.BW(9)) reg003(.clk(clk), .rst_n(rst_n), .Q({o_y[15:8],o_out_valid}), .D({sum,i_in_valid}), .number(n_reg001));


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
	input [7:0] i_x;
	output [7:0] i_c;
	output [50:0] number_x_di1;
	wire [50:0] number0, number1, number2, number3, number4, number5, number6, number7, inv_n1, inv_n2;
	wire [50:0] number00, number11, number22, number33, number44, number55, number66, number77, mux_n2;
	assign number_x_di1 = number1 + number2 + number3 + number4 + number5 + number6 + number7 + mux_n2 + number0;
	assign mux_n2 = number11 + number22 + number33 + number44 + number55 + number66 + number77 + number00 + inv_n1 + inv_n2;
	wire [7:0] i_a;
	wire [1:0] ctrl, i_x_n;

	assign i_c[7] = i_a[7];
	assign i_a[7] = i_x[7];

	IV inv_020(i_x_n[0], i_x[5], inv_n1);
	IV inv_021(i_x_n[1], i_x[6], inv_n2);
	MUX21H zx1220(ctrl[1], i_x[6], i_x_n[1], i_x[7], number00);
	MUX21H zx1221(ctrl[0], i_x[5], i_x_n[0], i_x[7], number0);
	
	MUX21H zx10(i_a[6], i_x[6], i_x[7], ctrl[0], number7);
	MUX21H zx11(i_a[5], i_x[5], i_x[6], ctrl[0], number1);
	MUX21H zx12(i_a[4], i_x[4], i_x[5], ctrl[0], number2);
	MUX21H zx13(i_a[3], i_x[3], i_x[4], ctrl[0], number3);
	MUX21H zx14(i_a[2], i_x[2], i_x[3], ctrl[0], number4);
	MUX21H zx15(i_a[1], i_x[1], i_x[2], ctrl[0], number5);
	MUX21H zx16(i_a[0], i_x[0], i_x[1], ctrl[0], number6);

	MUX21H zx177(i_c[6], i_a[6], i_a[7], ctrl[1], number77);
	MUX21H zx111(i_c[5], i_a[5], i_a[7], ctrl[1], number11);
	MUX21H zx122(i_c[4], i_a[4], i_a[6], ctrl[1], number22);
	MUX21H zx133(i_c[3], i_a[3], i_a[5], ctrl[1], number33);
	MUX21H zx144(i_c[2], i_a[2], i_a[4], ctrl[1], number44);
	MUX21H zx155(i_c[1], i_a[1], i_a[3], ctrl[1], number55);
	MUX21H zx166(i_c[0], i_a[0], i_a[2], ctrl[1], number66);


endmodule

//////////////////////////////////////////////////////////////////////////////

module find_region(i_x_msb3, const, number_find_region);
	input [2:0] i_x_msb3;
	output [7:0] const;
	output [50:0] number_find_region;
	wire [2:0] i_x_msb3_n;
	wire n4tn3, n3tn2, n2tn1, n1tp1, p1tp2, p2tp3, p3tp4, n1tp1_1, n1tp1_2;
	wire [50:0] ivv0, ivv1, n1_iv, n2_iv, n3_iv, n1_an3, n2_an3, n1_or2, n1_nd3, n2_nd3, n3_nd3, n4_nd3, n5_nd3, n6_nd3, nd_num1;
	wire [50:0] n1_nd4, n2_nd4, n2_nd2, n3_nd2, n4_nd2, nd_num2;

	assign number_find_region = n1_iv + n2_iv + n3_iv + nd_num1 + nd_num2 + ivv0 + ivv1;
	assign nd_num1 = n1_an3 + n2_an3 + n1_or2 + n1_nd3 + n2_nd3 + n3_nd3 + n4_nd3 + n5_nd3 + n6_nd3;
	assign nd_num2 = n1_nd4 + n2_nd4 + n2_nd2 + n3_nd2 + n4_nd2;
	assign const[7] = 1'b0;
	
	IV iv_000(i_x_msb3_n[2], i_x_msb3[2], n1_iv);
	IV iv_001(i_x_msb3_n[1], i_x_msb3[1], n2_iv);
	IV iv_002(i_x_msb3_n[0], i_x_msb3[0], n3_iv);

	/* ND2	nd2_000(n4Ton2_truth, i_x_msb3[2], i_x_msb3[1], n1_nd2);
	ND3 nd3_000(n2Ton1_truth, i_x_msb3[2], i_x_msb3_n[1], i_x_msb3[0], n1_nd3);
	ND2 nd2_001(n1Top1_truth, i_x_msb3_n[1], i_x_msb3_n[0], n2_nd2);
	ND3 nd3_001(p1Top2_truth, i_x_msb3_n[2], i_x_msb3_n[1], i_x_msb3[0], n2_nd3);
	ND2 nd2_010(p2Top4_truth, i_x_msb3_n[2], i_x_msb3[1], n3_nd2); */

	ND3 nd3_1(n4tn3, i_x_msb3[2], i_x_msb3_n[1], i_x_msb3_n[0], n1_nd3);
	ND3 nd3_2(n3tn2, i_x_msb3[2], i_x_msb3_n[1], i_x_msb3[0], n2_nd3);
	ND3 nd3_3(n2tn1, i_x_msb3[2], i_x_msb3[1], i_x_msb3_n[0], n3_nd3);
	
	ND3 an3_1(n1tp1_1, i_x_msb3[2], i_x_msb3[1], i_x_msb3[0], n1_an3);
	ND3 an3_2(n1tp1_2, i_x_msb3_n[2], i_x_msb3_n[1], i_x_msb3_n[0], n2_an3);
	
	ND3 nd3_4(p1tp2, i_x_msb3_n[2], i_x_msb3_n[1], i_x_msb3[0], n4_nd3);
	ND3 nd3_5(p2tp3, i_x_msb3_n[2], i_x_msb3[1], i_x_msb3_n[0], n5_nd3);
	ND3 nd3_6(p3tp4, i_x_msb3_n[2], i_x_msb3[1], i_x_msb3[0], n6_nd3);
	
	AN2 or2_1(n1tp1, n1tp1_1, n1tp1_2, n1_or2);

	ND4 nd3_072(const[6], n1tp1, p1tp2, p2tp3, p3tp4, n1_nd4);
	ND4 nd3_002(const[5], n3tn2, n2tn1, p2tp3, p3tp4, n2_nd4);
	ND2 nd2_002(const[4], n4tn3, n2tn1, n2_nd2);
	ND2 nd2_003(const[3], p1tp2, p3tp4, n3_nd2);
	ND2 nd2_004(const[2], p1tp2, p3tp4, n4_nd2);
	IV iv_0190(const[1], n4tn3, ivv0);
	IV iv_0199(const[0], n4tn3, ivv1);


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
	input [3:0] a,b;
	input carryin;
	output [3:0] sum;
	output carryout;
	output [50:0] number;
	wire [3:0] p_o;
	wire [4:0] co_o;
	wire [50:0] number_nand3, number_mux1, n_tbadder00;
	assign number = number_nand3 + number_mux1 + n_tbadder00;

	THREE_BIT_ADDER#(.BW(4)) tbadder001(.S(sum), .CO(co_o), .P(p_o), .A(a), .B(b), .CI(carryin), .number(n_tbadder00));

	ND4 nand112(temp1, p_o[0], p_o[1], p_o[2], p_o[3], number_nand3);

	MUX21H zx126(carryout, co_o[4], carryin, temp1, number_mux1);

endmodule