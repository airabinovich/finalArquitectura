`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:11:13 10/30/2015
// Design Name:   UART_echo_test_module
// Module Name:   C:/Users/Ariel/Xilinx/Workspace/UART/TestUART_echo_test.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UART_echo_test_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestUART_echo_test;

	// Inputs
	reg clock;
	reg echo_test_rx;
	reg echo_test_reset;

	// Outputs
	wire echo_test_tx;

	// Instantiate the Unit Under Test (UUT)
	UART_echo_test_module uut (
		.clock(clock), 
		.echo_test_rx(echo_test_rx), 
		.echo_test_reset(echo_test_reset), 
		.echo_test_tx(echo_test_tx)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		echo_test_rx = 1;
		  
		// Add stimulus here
		
		echo_test_reset = 1;
		#5;
		echo_test_reset = 0;
		
		// send nothing
		#26080;
		//	send all 0s
		echo_test_rx = 0; // bit de start y 8 bits en 0
		#24450;
		echo_test_rx = 1; // bit de stop y idle	
	end
	
	always begin
		clock = ~clock;
		#1;
	end
endmodule

