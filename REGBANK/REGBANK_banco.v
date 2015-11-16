`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:28:24 11/07/2015 
// Design Name: 
// Module Name:    REGBANK_banco 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module REGBANK_banco #(parameter addr_bits=5, word_wide=32)(
	input clock,
	input regWrite,
	input [addr_bits-1:0] readReg1,
	input [addr_bits-1:0] readReg2,
	input [addr_bits-1:0] writeReg,
	input [word_wide-1:0] writeData,
	output [word_wide-1:0] readData1,
	output [word_wide-1:0] readData2
);
	/* bank_depth = 2^(addr_bits)
		el banco tiene la profundidad máxima que se puede direccionar
	*/
	localparam bank_depth = 1 << addr_bits;
	
	reg [word_wide-1:0] banco [bank_depth-1:0];
	
	assign readData1 = banco[readReg1];
	assign readData2 = banco[readReg2];
	
	always@(posedge clock) begin
		if (regWrite) begin
			banco[writeReg] = writeData;
		end
	end

endmodule
