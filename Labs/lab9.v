/*
*	EECS 3201
*	Lab 9 Intersection FSM
* 	Daniel Kozlovsky 214874879
* 	November 27 2019
*/
//Yellow and minimum green time
`define T_YELLOW 3
//Maximum green time
`define T_GREEN 6

//Controller/FSM
module Lab9(LEDR, LEDG, SW, KEY, CLOCK_50);
	output reg [17:0] LEDR;//Red and yellow LEDs
	//output [17:14] LEDR;
	output reg [4:0] LEDG;//Green LEDs
	input [0:1] SW, KEY;//Car and pedestrian request sensor
	input CLOCK_50;
	
	
	parameter T_GREEN = `T_GREEN;
	parameter T_YELLOW = `T_YELLOW;
	//Enumerated states -- six in total 
	parameter hwyGreen = 6'b000001, hwyTrans = 6'b000010, secGreen = 6'b000100, secTrans = 6'b001000, pedGreen = 6'b010000, pedTrans = 6'b100000;
	
	//timer control and pedestrian clear
	reg cEnable, cReset, pedClear; 
	//store last serviced state in order to alternate
	reg[5:0] lastServiced;
	
	reg[5:0] state, nextState;
	wire clk, pedReq, car;
	wire[3:0] Q;//counter output
	
	
	
	//1hz clock
	//clock c(clk);
	clockToSec cs(CLOCK_50, clk);
	//assign clk = KEY[1];
	
	//timer 4bit
	upcount uc(cReset, clk, cEnable, Q);
	//pedestrian control
	pedRequest pr(pedReq,CLOCK_50, pedr, pedClear);
	
	assign car = SW[0];//control car request
	
	assign pedr = !KEY[0]; //control pedestrian request
	//initialize idle state
	initial 
	begin
		state = hwyGreen;
		//pedClear = 0;
	end
	
	//sequential block
	always@(posedge CLOCK_50)
	begin
		LEDR[17:14] = Q;
		LEDR[13] = pedReq;
		//next state
		state <= nextState;
		//$display("state: %d, nstate: %d", state, nextState);
	end
	
	//combinational block; relies on state change, car or ped request, or counter change
	always@(state, car, pedReq, Q)
	begin
		case (state)
			hwyGreen: begin //highway is green -- "idle state"
				//make sure timer is working
				cReset = 1;
				
				cEnable = 1;
				
				pedClear = 0;
				//debug
				$display("%d: counter: %d; hwyGreen", $time, Q);
				//outputs
				//Highway should be green, all others red
				//greens
				LEDG[0] = 1;//hwy
				LEDG[2] = 0;//secondary
				LEDG[4] = 0;//pedestrian
				//reds/yellows
				LEDR[0] = 0;//hwy red
				LEDR[1] = 0;//+hwy yellow
				
				LEDR[4] = 1;//secondary red
				LEDR[5] = 0;//secondary yellow
				
				LEDR[8] = 1;//pedestrian red
				LEDR[9] = 0;//pedestrian yellow;
				
				//change state if a request has been made and the minimum green has passed
				if((car || pedReq) && Q >= T_GREEN)
				begin
					nextState = hwyTrans;//change to yellow light transistional state
					//reset timer for next state
					cReset = 0;
					cEnable = 0;
				end
			end
			hwyTrans: begin //hwy light turning to yellow
				//make sure timer is working
				cReset = 1;
				cEnable = 1;
				pedClear = 0;
				$display("%d: counter: %d. hwyTrans", $time, Q);//debug
				//outputs-- highway yellow all other red
				//greens
				LEDG[0] = 0;//hwy
				LEDG[2] = 0;//secondary
				LEDG[4] = 0;//pedestrian
				//reds/yellows
				LEDR[0] = 1;//hwy red
				LEDR[1] = 1;//+hwy yellow
				
				LEDR[4] = 1;//secondary red
				LEDR[5] = 0;//+secondary yellow
				
				LEDR[8] = 1;//pedestrian red
				LEDR[9] = 0;//+pedestrian yellow;
				
				//wait until yellow is over
				if(Q >= T_YELLOW)
				begin
					if(car && pedReq)//both requested
					begin
						if(lastServiced == secGreen)//alternate between requests if both requested
						begin
							nextState = pedGreen;// next is pedestrian crossing
						end
						else
						begin
							nextState = secGreen;//next is secondary road
						end
					end
					else if(pedReq)//pedestrian requested
					begin
						nextState = pedGreen;//pedestrian crossing
					end
					else //go to secondary if car is still there or not since it was triggered and pedestrian request cannot be cleared
					begin
						nextState = secGreen;//secondary road
					end
				//reset timer for next state
				cReset = 0;
				cEnable = 0;
				end
			end
			secGreen: begin //secondary road is green all other are red
				//make sure timer works
				cReset = 1;
				cEnable = 1;
				pedClear = 0;
				$display("%d: counter: %d. secGreen", $time, Q);
				//outputs--sec green all other red
				//greens
				LEDG[0] = 0;//hwy
				LEDG[2] = 1;//secondary
				LEDG[4] = 0;//pedestrian
				//reds/yellows
				LEDR[0] = 1;//hwy red
				LEDR[1] = 0;//+hwy yellow
				
				LEDR[4] = 0;//secondary red
				LEDR[5] = 0;//secondary yellow
				
				LEDR[8] = 1;//pedestrian red
				LEDR[9] = 0;//pedestrian yellow;
				
				if(Q >= T_YELLOW)//wait for car to pass(minimum green)
				begin
					if(car && (Q <= T_GREEN))//if car is still there and less than max green time
					begin
						//nextState = secGreen;//no change
					end
					else
					begin
						nextState = secTrans;//yellow light state
						lastServiced = secGreen;//record last request
						//reset timer for next state
						cReset = 0;
						cEnable = 0;
					end
				
				end
			end
			secTrans: begin //transition for secondary road
				cReset = 1;
				cEnable = 1;
				pedClear = 0;
				$display("%d: counter: %d. secTrans", $time, Q);
				//outputs--sec yellow all other red
				//greens
				LEDG[0] = 0;//hwy
				LEDG[2] = 0;//secondary
				LEDG[4] = 0;//pedestrian
				//reds/yellows
				LEDR[0] = 1;//hwy red
				LEDR[1] = 0;//+hwy yellow
				
				LEDR[4] = 1;//secondary red
				LEDR[5] = 1;//secondary yellow
				
				LEDR[8] = 1;//pedestrian red
				LEDR[9] = 0;//pedestrian yellow;
				
				
				if(Q >= T_YELLOW)//wait for yellow to finish
				begin
					//go to highway (idle/default)
					nextState = hwyGreen;
					//reset timer for next state
					cReset = 0;
					cEnable = 0;
				end
			end
			pedGreen: begin //pedestrian crossing
				//make sure timer works
				cReset = 1;
				cEnable = 1;
				$display("%d: counter: %d. pedGreen", $time, Q);
				//outputs--ped green all other red
				//greens
				LEDG[0] = 0;//hwy
				LEDG[2] = 0;//secondary
				LEDG[4] = 1;//pedestrian
				//reds/yellows
				LEDR[0] = 1;//hwy red
				LEDR[1] = 0;//+hwy yellow
				
				LEDR[4] = 1;//secondary red
				LEDR[5] = 0;//secondary yellow
				
				LEDR[8] = 0;//pedestrian red
				LEDR[9] = 0;//pedestrian yellow;
				
				
				if(Q >= T_GREEN) //wait for max green time
				begin
					//transition
					nextState = pedTrans;//turn light yellow
					lastServiced = pedGreen;//record last request
					pedClear = 1; //clear pedestrian request
					//reset timer for next state
					cReset = 0;
					cEnable = 0;
				end
			end
			pedTrans: begin //pedestrain yellow
				//make sure timer works
				cReset = 1;
				cEnable = 1;
				$display("%d: counter: %d. pedTrans", $time, Q);
				//outputs--pedestrian yellow all other red
				//greens
				LEDG[0] = 0;//hwy
				LEDG[2] = 0;//secondary
				LEDG[4] = 0;//pedestrian
				//reds/yellows
				LEDR[0] = 1;//hwy red
				LEDR[1] = 0;//+hwy yellow
				
				LEDR[4] = 1;//secondary red
				LEDR[5] = 0;//secondary yellow
				
				LEDR[8] = 1;//pedestrian red
				LEDR[9] = 1;//pedestrian yellow;
				
				if(Q >= T_YELLOW)//wait for yellow time to finish
				begin
					//highway
					nextState = hwyGreen;
					pedClear = 0; //stop pedestrian request clear so it can be requested again
					//reset timer
					cReset = 0;
					cEnable = 0;
				end
			end
			default : begin //safety, set to idle
				cReset = 0;
				pedClear = 0;
				nextState = hwyGreen;
			end
		endcase
	end
endmodule

//pedestrian latch with reset
//has button been pressed?
module pedRequest(isReq,clk, button, clr);
	input button,clr,clk;
	output reg isReq;
	
	always@(posedge clk)
	begin
		if(button)//request
			isReq <= 1;
		if(clr)//clear request
			isReq <= 0;
	end
	
endmodule

//4 bit up counter
module upcount (Resetn, Clock, E, Q);
	input Resetn, Clock, E;
	output reg [3:0] Q;
	always @(negedge Resetn, posedge Clock)
	begin
		if (!Resetn)
			Q <= 0;
		else if (E)
			Q <= Q + 1;

//$display("q: %b, res: %b, clk:%b, e:%b", Q, Resetn, Clock, E);
end
endmodule

module clockToSec(clkin, clk);
input clkin;
output reg clk;
	
integer count;
	always@(posedge clkin)
	begin
		if(count == 50000000)
		begin
			clk <= 1;
			count <= 0;
		end
		else
		begin
			clk <= 0;
			count <= count + 1;
		end
	end
	
endmodule

//1hz clock
module clock(clk);
output clk;
reg tmp;
	always
	begin
		#1
		tmp = 0;
		tmp = 1;
	end
assign clk = tmp;
endmodule
