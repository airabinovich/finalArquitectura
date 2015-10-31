`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:29:53 10/26/2015
// Design Name:   UART_tx
// Module Name:   C:/Users/Ariel/Xilinx/Workspace/UART/TXTest.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UART_tx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TXTest;

	// Inputs
	reg clock;
	reg reset;
	reg s_tick;
	reg tx_start;
	reg [7:0] data_in;

	// Outputs
	wire tx;
	wire tx_done;
	wire baud_rate_clock;

	// Instantiate the Unit Under Test (UUT)
	UART_tx uut (
		.clock(clock), 
		.reset(reset), 
		.s_tick(baud_rate_clock), 
		.tx_start(tx_start), 
		.data_in(data_in), 
		.tx(tx), 
		.tx_done(tx_done)
	);
	
	// Instantiate the Unit Under Test (UUT)
	UART_baud_rate_generator #(.COUNT(2608)) baud_rate (
		.clock(clock), 
		.baud_rate_clock(baud_rate_clock)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 1;
		s_tick = 0;
		tx_start = 1;
		data_in = 48;

		// Wait 100 ns for global reset to finish
		#100;
       reset=1;
		 #100;
		 reset=0;
		// Add stimulus here

	end
	
	always begin
		clock = ~clock;
		#3;
	end
	always begin
	   #1000;
		tx_start=0;
		#1000;
		tx_start=1;
		#500000;
		data_in=data_in+5;
		#100;
	end
      
endmodule



