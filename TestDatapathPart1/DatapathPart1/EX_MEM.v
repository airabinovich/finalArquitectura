`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:08:40 11/19/2015 
// Design Name: 
// Module Name:    EX_MEM 
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
module EX_MEM(
		input clock,
		input reset,
		input[4:0] writeRegister,
		input[31:0] writeData,
		input[31:0] aluOut,
		input regWrite,
		input memToReg,
		input [3:0]memWrite,
		input [1:0] memReadWidth,
		
		output reg[4:0] writeRegisterOut,
		output reg[31:0] writeDataOut,
		output reg[31:0] aluOutOut,
		output reg regWriteOut,
		output reg memToRegOut,
		output reg [3:0]memWriteOut,
		output reg [1:0] memReadWidthOut
		
    );
	 
	 always @(posedge clock,posedge reset)begin
		if(reset)begin
			writeRegisterOut<=0;
			writeDataOut<=0;
			aluOutOut<=0;
			regWriteOut<=0;
			memToRegOut<=0;
			memWriteOut<=0;
			memReadWidthOut<=0;
		end
		else begin
			writeRegisterOut<=writeRegister;
			writeDataOut<=writeData;
			aluOutOut<=aluOut;
			regWriteOut<=regWrite;
			memToRegOut<=memToReg;
			memWriteOut<=memWrite;
			memReadWidthOut<=memReadWidth;

		end
		
	 end


endmodule
