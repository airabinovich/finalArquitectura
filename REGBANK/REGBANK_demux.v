`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:40:20 11/07/2015 
// Design Name: 
// Module Name:    REGBANK_demux 
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
module REGBANK_demux #(parameter select_bits=5)(
	input in,
	input [select_bits-1:0] select,
	output reg [out_bits-1:0] out
);

	localparam out_bits = 1<<select_bits;
	
	always @(select,in) begin
		out = 0;
		out[select] = in;
	end


endmodule
