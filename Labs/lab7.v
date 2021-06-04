module testmod();
	reg clk, clr;
	reg[15:0] sw;
	wire[0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	
	
	part5 p5(clr, clk, sw, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	
	always
	#5 clk = !clk;
	initial begin
		sw[15:0] = 0;
		clk = 0;
		clr = 1;
		#1
		$monitor("clk: %b switch:%h second:%h%h%h%h first: %h%h%h%h",clk,sw , HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
		#1
		sw[0] = 1;
		#10
		sw[1] = 1;
		#5
		clr = 0;
		#50
		
		
		$finish;
	end
	
	
endmodule

module part5(KEY0, KEY1, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	input KEY0, KEY1;
	input [0:15] SW;
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	
	wire[0:15] Q;
	reg[0:15] first, second;
	
	//16 flipflops
	/*genvar k;
	generate
		
		for(k = 0; k<16;k = k+1)
		begin
			dFlip savedNum(KEY1, KEY0, SW[k], Q[k]);
			
		end
	endgenerate*/
	dFlip savedNum[15:0] (KEY1, KEY0, SW, Q);
	
	
	
	always @(KEY1)
	begin
		$display("q:%b", Q);
		if(KEY1 == 0)//hex7-4
		begin
			first = Q;
		end
		else//hex3-0
		begin
			second = Q;
		end
	end
	sevenSegment firstcol1(HEX4, first[0:3]);
	sevenSegment firstcol2(HEX5, first[4:7]);
	sevenSegment firstcol3(HEX6, first[8:11]);
	sevenSegment firstcol4(HEX7, first[12:15]);
	
	sevenSegment secondcol1(HEX0, second[0:3]);
	sevenSegment secondcol2(HEX1, second[4:7]);
	sevenSegment secondcol3(HEX2, second[8:11]);
	sevenSegment secondcol4(HEX3, second[12:15]);
	
	
endmodule


module dFlip(clk, clr, D, Q);
	input clk, clr, D;
	output reg Q;
	
	always @(posedge clk)
	begin
	$display("clk: %b, D: %b, Q: %b", clk, D, Q);
		if(clr == 0) //clear
			Q <= 0;
		else
			Q <= D;
	end
endmodule

module part4(Qa, Qb, Qc, D, clk);
	input D, clk;
	output reg Qa, Qb, Qc;
	//gated D
	always @(clk, D)
	begin
		if(clk)
			Qa = D;
	end
	//D Flip flop
	always @(posedge clk)
	begin
		Qb = D;
	end
	//M-S D latch
	always @(negedge clk)
	begin
		Qc = D;
	end
	
endmodule

module rsLatch(clk, R, S, Q);// RS latch
	input clk, R, S;
	output Q;
	
	wire R_g, S_g, Qa, Qb /* sythesis keep*/;
	
	assign R_g = R & clk;
	assign S_g = S & clk;
	assign Qa = ~(R_g | Qb);
	assign Qb = ~(S_g | Qa);
	
	assign Q = Qa;
	
endmodule

module dLatch(clk, D, Q);
	input clk, D;
	output Q;
	
	wire R_g, S_g, Qa, Qb /*synthesis keep*/;
	
	assign S = D;
	assign R = ~D;
	
	assign S_g = ~(S & clk);
	assign R_g = ~(R & clk);
	
	assign Qa = ~(S_g & Qb);
	assign Qb = ~(R_g & Qa);
	
	assign Q = Qa;

endmodule

module masterSlaveLatch(Q, QNot, clk, D);
	input clk, D;
	output Q, QNot;
	
	wire Qm, Qs /*synthesis keep*/;
	
	dLatch master(~clk, D, Qm);
	dLatch slave(clk, Qm, Qs);
	
	assign Q = Qs;
	assign QNot = ~Qs;
	
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