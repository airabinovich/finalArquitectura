`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:25:20 11/19/2015 
// Design Name: 
// Module Name:    MEM_WB 
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
module MEM_WB(
		input clock,
		input reset,
		input [4:0] writeRegister,
		input [31:0] aluOut,
		input [31:0] memoryOut,
		input regWrite,
		input memToReg,
		
		output reg [4:0] writeRegisterOut,
		output reg [31:0] aluOutOut,
		output reg [31:0] memoryOutOut,
		output reg regWriteOut,
		output reg memToRegOut
    );
	 
	 	 always @(posedge clock,posedge reset)begin
		if(reset)begin
			writeRegisterOut<=0;
			aluOutOut<=0;
			memoryOutOut<=0;
			regWriteOut<=0;
			memToRegOut<=0;
		end
		else begin
			writeRegisterOut<=writeRegister;
			aluOutOut<=aluOut;
			memoryOutOut<=memoryOut;
			regWriteOut<=regWrite;
			memToRegOut<=memToReg;
		end
		
	 end


endmodule
