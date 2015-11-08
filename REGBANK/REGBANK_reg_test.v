`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:21:21 11/07/2015
// Design Name:   REGBANK_registro
// Module Name:   C:/Users/Ariel/Documents/finalArquitectura/REGBANK/REGBANK_reg_test.v
// Project Name:  REGBANK
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: REGBANK_registro
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module REGBANK_reg_test;

	// Inputs
	reg clock;
	reg write_enable;
	reg read_enable;
	reg [31:0] data_in;

	// Outputs
	wire [31:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	REGBANK_registro uut (
		.clock(clock), 
		.write_enable(write_enable), 
		.read_enable(read_enable), 
		.data_in(data_in), 
		.data_out(data_out)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		write_enable = 0;
		read_enable = 0;
		data_in = 0;

		// Wait 100 ns for global reset to finish
		#10;
        
		data_in = 32'hF305218F;
		read_enable = 1;
		#5;
		read_enable = 0;
		write_enable = 1;
		#5;
		write_enable = 0;
		read_enable = 1;

	end

always begin
	clock = ~clock;
	#1;
end
endmodule

