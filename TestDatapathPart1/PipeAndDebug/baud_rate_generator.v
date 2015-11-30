`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:42:06 10/11/2015 
// Design Name: 
// Module Name:    UART_baud_rate_generator 
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
module UART_baud_rate_generator #(parameter COUNT = 163 )(
		input clock,
		output reg baud_rate
    );
	 reg [15:0]counter=0;
	 always @(posedge clock) begin
		counter <= (counter < COUNT)? counter+16'b1 : 16'b0;
		baud_rate <= (counter == COUNT)? 1'b1 : 1'b0;
	 end


endmodule
