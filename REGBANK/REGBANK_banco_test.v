`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:43:12 11/07/2015
// Design Name:   REGBANK_banco
// Module Name:   C:/Users/Ariel/Documents/finalArquitectura/REGBANK/REGBANK_banco_test.v
// Project Name:  REGBANK
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: REGBANK_banco
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module REGBANK_banco_test;

	// Inputs
	reg clock;
	reg read_enable;
	reg write_enable;
	reg [4:0] addr_bus;
	reg [31:0] data_reg;
	// Bidirs
	wire [31:0] data_bus;

	// Instantiate the Unit Under Test (UUT)
	REGBANK_banco uut (
		.clock(clock), 
		.read_enable(read_enable), 
		.write_enable(write_enable), 
		.addr_bus(addr_bus), 
		.data_bus(data_bus)
	);

	assign data_bus = data_reg;
	
	initial begin
		// Initialize Inputs
		clock = 0;
		read_enable = 0;
		write_enable = 0;
		addr_bus = 0;

		// Wait 100 ns for global reset to finish
		#10;
		
		data_reg = 32'hFFFFFFFF;
		write_enable = 1;
      #10;
		write_enable = 0;
		read_enable = 1;
		#10;
		addr_bus = 5'd1;
		data_reg = 32'hAAAAAAAA;
		write_enable = 1;
		#10;
		write_enable = 0;
		addr_bus = 5'd0;
		read_enable = 1;
		#10;
		data_reg = 32'h00000000;
		write_enable = 1;
		// Add stimulus here
		
	end

always begin
	clock = ~clock;
	#1;
end
endmodule

