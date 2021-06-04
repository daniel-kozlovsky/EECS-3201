/*module Lab3(SW, HEX0);
	//Seven segment display
	input [0:3] SW;
	output [0:6] HEX0;
	
	sevenSegment myseg(HEX0, SW);
	
	
endmodule*/

module Lab3(SW, HEX0);
	//Seven segment display
	 //reg [0:3] SW;
	 //wire[0:6] HEX0, temp;
	 //wire a, b, c, d, e, f, g;
	 
	input [0:3] SW;
	output [0:6] HEX0;
	wire [0:6] tempHEX0;
	
	
	
	aSeg aS2(tempHEX0[0], SW[0], SW[1], SW[2], SW[3]);
	bSeg bS2(tempHEX0[1], SW[0], SW[1], SW[2], SW[3]);
	cSeg cS2(tempHEX0[2], SW[0], SW[1], SW[2], SW[3]);
	dSeg dS2(tempHEX0[3], SW[0], SW[1], SW[2], SW[3]);
	eSeg eS2(tempHEX0[4], SW[0], SW[1], SW[2], SW[3]);
	fSeg fS2(tempHEX0[5], SW[0], SW[1], SW[2], SW[3]);
	gSeg gS2(tempHEX0[6], SW[0], SW[1], SW[2], SW[3]);
	
	assign HEX0 = ~tempHEX0;
	
	//sevenSegment myseg(HEX0, SW);
	//a,b,c etc.. --> HEX0[0], HEX0[1]....
	/*
	aSeg aS(a, SW[0], SW[1], SW[2], SW[3]);
	bSeg bS(b, SW[0], SW[1], SW[2], SW[3]);
	cSeg cS(c, SW[0], SW[1], SW[2], SW[3]);
	dSeg dS(d, SW[0], SW[1], SW[2], SW[3]);
	eSeg eS(e, SW[0], SW[1], SW[2], SW[3]);
	fSeg fS(f, SW[0], SW[1], SW[2], SW[3]);
	gSeg gS(g, SW[0], SW[1], SW[2], SW[3]);
	*/
endmodule
	
	/*initial
	begin
		#5
		$monitor("hex:%h , segment:%b, notsegment:%b a:%b,b:%b,c:%b,d:%b,e:%b,f:%b,g:%b, ", SW, HEX0, test, a, b, c, d, e, f, g);
		#1
		SW = 'b0000;
		#1
		SW = 'b0001;
		#1
		SW = 'b0010;
		#1
		SW = 'b0011;
		#1
		SW = 'b0100;
		#1
		SW = 'b0101;
		#1
		$finish;
	end*/
//endmodule

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

	/*table
	//x3, x2, x1, x0 : a, b, c, d ,e , f, g
	0 0 0 0 : 1 1 1 1 1 1 0;
	0 0 0 1 : 0 1 1 0 0 0 0;
	0 0 1 0 : 1 1 0 1 1 0 1;
	0 0 1 1 : 1 1 1 1 0 0 1;
	0 1 0 0 : 0 1 1 0 0 1 1;
	0 1 0 1 : 1 0 1 1 0 1 1;
	0 1 1 0 : 1 0 1 1 1 1 1;
	0 1 1 1 : 1 1 1 0 0 0 0;
	1 0 0 0 : 1 1 1 1 1 1 1;
	1 0 0 1 : 1 1 1 1 0 1 1; 
	1 0 1 0 : 1 1 1 0 1 1 1;//A
	1 0 1 1 : 0 0 1 1 1 1 1;
	1 1 0 0 : 1 0 0 1 1 1 0;
	1 1 0 1 : 0 1 1 1 1 0 1;
	1 1 1 0 : 1 0 0 1 1 1 1;
	1 1 1 1 : 1 0 0 0 1 1 1;//F
	
	endtable
*/