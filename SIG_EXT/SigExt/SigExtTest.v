`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:45:51 11/18/2015
// Design Name:   SigExt
// Module Name:   C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/DatapathPart1/SigExtTest.v
// Project Name:  DatapathPart1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SigExt
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SigExtTest;

	// Inputs
	reg [15:0] in;

	// Outputs
	wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
	SigExt uut (
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 122;
		// Wait 100 ns for global reset to finish
		#100;
      in = 650;
		#100;
		in = 300;
		#100;
		in = 15000;
		#100;
		in = -15000;
		#100;
		in = -150;
		// Add stimulus here

	end
      
endmodule

