module Lab2(SW, LEDR);
	input [3:0] SW;
	output [0:0] LEDR;
	
	three_in_xor (parity, SW[0], SW[1], SW[2]);
	
	assign LEDR[0] = parity ^ SW[3];
	
endmodule
//truth table
primitive three_in_xor (Y, x1, x2, x3);
		input x1, x2, x3;
		output Y;
		
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