`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:58:38 11/19/2015 
// Design Name: 
// Module Name:    Adder 
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
module Adder(
	input signed [7:0] a,
	input signed [7:0] b,
	output reg 	 [7:0] sum
);
	always @* begin
		sum <= a+b;
	end

endmodule
