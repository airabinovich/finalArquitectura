`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:56:12 10/31/2015 
// Design Name: 
// Module Name:    RAM_addresser_and_data 
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
module RAM_addresser_and_data(
    input [3:0] address_in,
    input [3:0] data_in,
    input read_mode,
	 input write_mode,
    input clock,
	 output [3:0] data_out,
	 output reg reading,
	 output reg writing
    );

	reg read_write;
	
	RAM_ram_bank RAM (
	  .clka(clock),
	  .wea(read_write),
	  .addra(address_in),
	  .dina(data_in),
	  .douta(data_out)
	);
	
	always@(read_mode, write_mode) begin
		read_write = write_mode & ~read_mode;
	end
	
	always@(read_write) begin
		if(read_write == 0) begin
			reading = 1;
			writing = 0;
		end
		else begin
			reading = 0;
			writing = 1;
		end
	end
endmodule
