`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:34:06 10/26/2015
// Design Name:   UART_rx
// Module Name:   C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Workspace Xilinx/UART/RXTest.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UART_rx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module RXTest;

	// Inputs
	reg rx;
	reg reset;
	reg clock;

	// Outputs
	wire rx_done;
	wire [7:0] d_out;
	
		
	// Outputs
	wire baud_rate_clock;
	
	reg [5:0]counter;
	reg [4:0]counter_baud;
	// Instantiate the Unit Under Test (UUT)
	UART_rx uut (
		.rx(rx), 
		.s_tick(baud_rate_clock), 
		.reset(reset), 
		.clock(clock), 
		.rx_done(rx_done), 
		.d_out(d_out)
	);
	


	// Instantiate the Unit Under Test (UUT)
	UART_baud_rate_generator  baud_rate  (
		.clock(clock), 
		.baud_rate_clock(baud_rate_clock)
	);


	initial begin
		// Initialize Inputs
		rx = 1;
		reset = 1;
		clock = 0;
		counter = 0;
		counter_baud=0;
		// Wait 100 ns for global reset to finish
		#100;
      reset = 0;
		// Add stimulus here

	end
	
	always begin 
		clock = ~clock;
		#10;
	end
	
	always @(baud_rate_clock) begin 
		
		counter_baud=counter_baud+1;
		if(counter_baud==0) begin
			counter=counter+1;
			case (counter) 
			7: rx=0; //start bit
			8: rx=1;
			9: rx=1;
			10: rx=1;
			11: rx=0;
			12: rx=1;
			13: rx=0;
			14: rx=1;
			15: rx=0;
			16: rx=1;// stop bit
			17: rx=1;// otro porque soy re heavy
			18: counter=0;
			default: rx=1;
			endcase;
		end
	end
	
      
endmodule

