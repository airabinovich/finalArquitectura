`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:49:53 10/19/2015
// Design Name:   UART_fifo_interface
// Module Name:   C:/Users/Ariel/Xilinx/Workspace/UART/fifoTest.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: UART_fifo_interface
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module fifoTest;

	// Inputs
	reg write_flag;
	reg read_flag;
	reg [7:0] data_in;
	reg clock;
	reg reset;

	// Outputs
	wire [7:0] data_out;
	wire empty_flag;
	wire full_flag;

	// Instantiate the Unit Under Test (UUT)
	UART_fifo_interface #(
		.bits_depth(2)
	) uut (
		.write_flag(write_flag), 
		.read_flag(read_flag), 
		.data_in(data_in), 
		.clock(clock), 
		.reset(reset), 
		.data_out(data_out), 
		.empty_flag(empty_flag), 
		.full_flag(full_flag)
	);

	initial begin
		// Initialize Inputs
		write_flag = 0;
		read_flag = 0;
		data_in = 0;
		clock = 0;
		reset = 1;

		// comienza prueba de escritura
		#10;
		reset = 0;
		data_in = 1;
		write_flag = 1;
		#1;
		write_flag = 0;
		#1;
      data_in = 2;
		write_flag = 1;
		#1;
		write_flag = 0;
		#1;  
		data_in = 3;
		write_flag = 1;
		#1;
		write_flag = 0;
		#1;
		data_in = 4;
		write_flag = 1;
		#1;
		write_flag = 0;
		#1;
		data_in = 5;
		write_flag = 1;
		#1;
		write_flag = 0;
		#1;
		// hasta acá prueba de escritura, comienza prueba de lectura
		read_flag = 1;
		#1;
		read_flag = 0;
		#1;
		read_flag = 1;
		#1;
		
	end
	
	always begin
		clock = ~clock;
		#1;
	end
      
endmodule

