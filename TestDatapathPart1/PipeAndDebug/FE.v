`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:20:35 11/20/2015 
// Design Name: 
// Module Name:    FE 
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
module FE(
		input 		clock,
		input 		reset,
		input 		debugEnable,
		input 		debugReset,
		input 		notEnable,
		input 		[7:0]pc,
		output reg 	[7:0]pcOut
);
	 
	 always @(negedge clock,posedge reset)begin
			if(reset)begin
				pcOut<=0;
			end
			else if(debugReset)begin
				pcOut<=0;
			end
			else if(~notEnable && debugEnable) begin
				pcOut<=pc;
			end
		end
		

endmodule
