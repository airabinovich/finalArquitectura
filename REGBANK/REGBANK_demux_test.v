`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:46:53 11/07/2015
// Design Name:   REGBANK_demux
// Module Name:   C:/Users/Ariel/Documents/finalArquitectura/REGBANK/REGBANK_demux_test.v
// Project Name:  REGBANK
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: REGBANK_demux
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module REGBANK_demux_test;

	// Inputs
	reg in;
	reg [4:0] select;

	// Outputs
	wire [31:0] out;

	// Instantiate the Unit Under Test (UUT)
	REGBANK_demux uut (
		.in(in), 
		.select(select), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		select = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		in = 1;
		#1;
		select = 5;
		#1;
		in = 0;
		select = 32;
		#1;
		in = 1;
	end
      
endmodule

