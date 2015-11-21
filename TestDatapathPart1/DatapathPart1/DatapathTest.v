`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:36:10 11/21/2015
// Design Name:   Datapath1
// Module Name:   C:/Users/Ariel/Documents/finalArquitectura/TestDatapathPart1/DatapathPart1/DatapathTest.v
// Project Name:  DatapathPart1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Datapath1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DatapathTestFinal;

	// Inputs
	reg clock;
	reg resetGral;

	// Outputs
	wire ALUzero;
	wire ALUOverflow;

	// Instantiate the Unit Under Test (UUT)
	Datapath1 uut (
		.clock(clock), 
		.resetGral(resetGral), 
		.ALUzero(ALUzero), 
		.ALUOverflow(ALUOverflow)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		resetGral = 1;

		// Wait 100 ns for global reset to finish
		#100;
		resetGral=0;
        
		// Add stimulus here

	end
	
	always begin
		clock = ~clock;
		#1;
	end
      
endmodule

