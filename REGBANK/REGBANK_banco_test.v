`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:57:54 11/15/2015
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
	reg regWrite;
	reg [4:0] readReg1;
	reg [4:0] readReg2;
	reg [4:0] writeReg;
	reg [31:0] writeData;

	// Outputs
	wire [31:0] readData1;
	wire [31:0] readData2;

	// Instantiate the Unit Under Test (UUT)
	REGBANK_banco uut (
		.clock(clock), 
		.regWrite(regWrite), 
		.readReg1(readReg1), 
		.readReg2(readReg2), 
		.writeReg(writeReg), 
		.writeData(writeData), 
		.readData1(readData1), 
		.readData2(readData2)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		regWrite = 0;
		readReg1 = 0;
		readReg2 = 0;
		writeReg = 0;
		writeData = 0;

		#10;
		regWrite = 0;
		writeReg = 0;
		writeData = 32'hFFFFFFFF;
		regWrite = 1;
		#2;
		regWrite = 0;
		writeReg = 1;
		writeData = 32'hAAAAAAAA;
		regWrite = 1;
		readReg1 = 0;
		#2;
		regWrite = 0;
		writeReg = 2;
		writeData = 32'h55555555;
		regWrite = 1;
		readReg2 = 1;
		#2;
		regWrite = 0;
		readReg1 = 2;
		

	end
      
	always begin
		clock = ~clock;
		#1;
	end
		
endmodule

