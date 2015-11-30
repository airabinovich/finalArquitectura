`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:43:58 11/19/2015 
// Design Name: 
// Module Name:    IF_ID 
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
module IF_ID(
		input clock,
		input reset,
		input debugEnable,
		input debugReset,
		input notEnable,
		input clear,
		input[31:0] instruction,
		input[7:0] pcNext,
		output reg[31:0] instructionOut,
		output reg[7:0] pcNextOut
    );
	 
	 always @(negedge clock,posedge reset)begin
		if(reset)begin
			instructionOut<=0;
			pcNextOut<=0;
		end
		else if(debugReset)begin
			  instructionOut<=0;
			  pcNextOut<=0;
		end
		else if(~notEnable && debugEnable)begin
			if(clear)begin
				instructionOut<=0;
			end
			else begin
				instructionOut<=instruction;
			end
			pcNextOut<=pcNext;
		end
		
	 end


endmodule
