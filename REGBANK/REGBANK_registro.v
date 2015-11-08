`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:05:51 11/07/2015 
// Design Name: 
// Module Name:    REGBANK_registro 
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
module REGBANK_registro #(parameter bits_wide = 32)(
	input clock,
	input write_enable,
	input read_enable,
	input [bits_wide-1:0] data_in,
	output reg [bits_wide-1:0] data_out
);
	reg [bits_wide-1:0] data;

	always @(posedge clock) begin
		if(write_enable) begin
			data <= data_in;
		end
		if(read_enable) begin
			data_out <= data;
		end
		else begin
			data_out <= 32'hz;
		end
	end


endmodule
