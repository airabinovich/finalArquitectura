`timescale 1ns / 1ps
	
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:05 10/11/2015 
// Design Name: 
// Module Name:    UART_fifo_interface 
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
module UART_fifo_interface #(parameter bits_depth=4)(
			input	write_flag,
			input read_next,
			input	[7:0] data_in,
			input clock,
			input reset,
			output reg [7:0] data_out,
			output reg empty_flag,
			output reg full_flag
		
    );

	localparam depth= 1<<(bits_depth);
	reg [7:0] FIFO [depth-1:0];
	reg [(bits_depth-1):0]	read_pointer, 
									write_pointer;
	
	reg [(bits_depth):0]		free_space;
	
	always @* begin
	
		full_flag = (free_space==0);
		empty_flag = (free_space==depth); 
		data_out <= FIFO[read_pointer];
	end
	
	always @(posedge clock, posedge reset)	begin
		if(reset) begin
			write_pointer <= 0;
			read_pointer <=  0;
			free_space <= depth;
		end
		else begin
			if(read_next) begin
				if(!empty_flag) begin
					read_pointer <= read_pointer + 'b1;
					free_space <= free_space + 'b1;
				end
			end
			if(write_flag) begin
				FIFO[write_pointer] <= data_in;
				write_pointer <= write_pointer + 'b1;
				if(!full_flag) begin
					free_space <= (free_space - 'b1) ;
				end
				else if(!empty_flag) begin
					read_pointer <= read_pointer + 'b1;
				end
			end
		end
	end

endmodule
