module testModule;
	
	 reg [0:15] SW;
	 wire [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	 wire [0:15] p;
	 
	 multiplier mymulti(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, p);
	
	
	initial
	begin
		#5
		//$monitor("SW:%h, HEX0:%h, HEX1:%h, HEX2:%h, HEX3:%h, HEX4:%h, HEX5:%h, HEX6:%h, HEX7:%h", SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
		$monitor("SW:%h, A:%h, B:%h, product:%h", SW, SW[0:7], SW[8:15], p);
		#1
		SW = 'h0000;
		#1
		SW = 'h0002;
		#1
		SW = 'h0101;
		#1
		SW = 'h0201;
		#1
		SW = 'h030a;
		$finish;
	end
endmodule


module multiplier(SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, product);

input [0:15] SW;
output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
output reg[0:15] product;
//reg [0:15] product;

sevenSegment myseg4(HEX4, SW[0:3]);
sevenSegment myseg5(HEX5, SW[4:7]);
sevenSegment myseg6(HEX6, SW[8:11]);
sevenSegment myseg7(HEX7, SW[12:15]);

always@(SW)
	begin
		product = SW[0:7] * SW[8:15];
	end

sevenSegment myseg0(HEX0, product[0:3]);
sevenSegment myseg1(HEX1, product[4:7]);
sevenSegment myseg2(HEX2, product[8:11]);
sevenSegment myseg3(HEX3, product[12:15]);

endmodule


//Full adder
module full_adder 
	(
	in1,
	in2,
	cin,
	sum,
	cout
	);
 
	input  in1;
	input  in2;
	input  cin;
	output sum;
	output cout;

	wire   w_WIRE_1;
	wire   w_WIRE_2;
	wire   w_WIRE_3;
	   
	assign w_WIRE_1 = in1 ^ in2;
	assign w_WIRE_2 = w_WIRE_1 & cin;
	assign w_WIRE_3 = in1 & in2;

	assign sum   = w_WIRE_1 ^ cin;
	assign cout = w_WIRE_2 | w_WIRE_3;

   
endmodule

module sevenSegment (segment, x);
	input [3:0] x;
	output reg [6:0]segment;
	
	always @(x) 
	begin
		case (x)
		4'b0000 :      	
		segment = 7'b1111110;
		4'b0001 :    		
		segment = 7'b0110000  ;
		4'b0010 :  		
		segment = 7'b1101101 ; 
		4'b0011 : 		
		segment = 7'b1111001 ;
		4'b0100 :		
		segment = 7'b0110011 ;
		4'b0101 :		
		segment = 7'b1011011 ;  
		4'b0110 :		
		segment = 7'b1011111 ;
		4'b0111 :	
		segment = 7'b1110000;
		4'b1000 :     		 
		segment = 7'b1111111;
		4'b1001 :    		
		segment = 7'b1111011 ;
		4'b1010 :  		
		segment = 7'b1110111 ; 
		4'b1011 : 		
		segment = 7'b0011111;
		4'b1100 :		
		segment = 7'b1001110 ;
		4'b1101 :		
		segment = 7'b0111101 ;
		4'b1110 :		
		segment = 7'b1001111 ;
		4'b1111 :		
		segment = 7'b1000111 ;
		endcase
		segment = ~segment; //Active low
	end
endmodule

module aSeg(a, in4, in3, in2, in1);
	input in1, in2, in3, in4;
	output a;
	
	//a = b'd' + a'c + bc + ad' + a'bd + ab'c'
	//(~b&~d)|(~a&c)|(b&c)|(a&~d)|(~a&b&d)|(a&~b&~c)
	assign a = (~in3 & ~in1) | (~in4 & in2) |(in3 & in2) |(in4 & ~in1) |(~in4 & in3 & in1) |(in4 & ~in3 & ~in2);
	
endmodule

module bSeg(b, in4, in3, in2, in1);
	input in1, in2, in3, in4;
	output b;
	
	//b = a'b' + b'd' + a'c'd' + a'cd + ac'd
	assign b = (~in4 & ~in3) | (~in3 & ~in1) | (~in4 & ~in2 & ~in1)| (~in4 & in2 & in1) | (in4 & ~in2 &in1);
	
	
endmodule

module cSeg(y, a, b, c, d);
	input a, b, c, d;
	output y;
	
	//c = a'c' + a'd + c'd + a'b + ab'
	assign y = (~a&~c) | (~a&d) | (~c&d) | (~a&b) | (a&~b);
	
	
endmodule

module dSeg(y, a, b, c, d);
	input a, b, c, d;
	output y;
	
	//d = ac' + a'b'd' + b'cd + bc'd + bcd'
	assign y = (a&~c) | (~a&~b&~d) | (~b&c&d) | (b&~c&d) | (b&c&~d);
	
	
endmodule

module eSeg(y, a, b, c, d);
	input a, b, c, d;
	output y;
	
	//e = b'd' + cd' + ac + ab
	assign y = (~b&~d) | (c&~d) | (a&c) | (a&b);
	
	
endmodule

module fSeg(y, a, b, c, d);
	input a, b, c, d;
	output y;
	
	//f = c'd' + bd' + ab' + ac + a'bc'
	assign y = (~c&~d) | (b&~d) | (a&~b) | (a&c) | (~a&b&~c);
	
	
endmodule

module gSeg(y, a, b, c, d);
	input a, b, c, d;
	output y;
	
	//g = b'c + cd' + ab' + ad + a'bc'
	assign y = (~b&c) | (c&~d) | (a&~b) | (a&d) | (~a&b&~c);
	
	
endmodule