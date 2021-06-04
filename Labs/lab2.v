/*Lab 2 pre-lab
Daniel Kozlovsky
214874879
*/

module test;
	
	reg i1, i2, i3, i4;
	wire p0;
	odd_parity_checker test (p0, i1, i2, i3,i4);
	
	initial begin
		$monitor("isError:%b, %b%b%b%b", p0, i1, i2, i3, i4);
		i1 = 0;
		i2 = 0;
		i3 = 0;
		i4 = 0;
		#2
		i4 = 1;
		#2
		i1 = 1;
		#2
		i2 = 1;
		#2
		i3 = 1;
		#2
		i1 = 0; 
		#2
		i2 = 0;
		#5
		i1 = 0;
		i2 = 0;
		i3 = 0;
		i4 = 0;
		
		$finish;
	end
	
endmodule

module odd_parity_checker(error, b0, b1, b2, b3);
	input b0, b1, b2, b3;
	output error;
	
	three_in_xor (parity, b0, b1, b2);
	
	assign error = parity ^ b3;
	
endmodule
//truth table
primitive three_in_xor (aY, ax1, ax2, ax3);
		input ax1, ax2, ax3;
		output aY;
		
		table
		//x1 x2 x3 : Y
			0 0 0 : 0;
			0 0 1 : 1;
			0 1 0 : 1;
			0 1 1 : 0;
			1 0 0 : 1;
			1 0 1 : 0;
			1 1 0 : 0;
			1 1 1 : 1;
		endtable
endprimitive

//standard gate structural 
module simple_structural(bY, bx1, bx2, bx3);
	output bY;
	input bx1, bx2, bx3;
	
	xor (bY, bx1, bx2, bx3);

endmodule

//pos structural
module pos_structural(cY, cx1, cx2, cx3);
	output cY;
	input cx1, cx2, cx3;
	
	//x1, x2
	or (w0, cx1, cx2);
	or (w1, !cx1, !cx2);
	and (z0, w0, w1);
	//x3
	or (y0, cx3, z0);
	or (y1, !cx3, !z0);
	and (cY, y0, y1);
	
endmodule

//behavioural
module behavioural(dY, dx1, dx2, dx3);
	output dY;
	input dx1, dx2, dx3;
	
	assign dY = dx1 ^ dx2 ^ dx3;
	
endmodule
