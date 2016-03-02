`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:48 11/18/2015 
// Design Name: 
// Module Name:    SigExt 
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
module SigExt(
	input			[15:0] in,
	input 		zeroEx,		//flag para indicar si se necesita zero extend en lugar de sign extend
	output reg 	[31:0]out
);
	 
	 always @(*) begin
		if(zeroEx)begin
			out <= {16'h0000,in};
		end
		else if(in[15])begin
			out <= {16'hFFFF,in};
		end
		else begin
		   out <= {16'h0000,in};
		end
	 end


endmodule
