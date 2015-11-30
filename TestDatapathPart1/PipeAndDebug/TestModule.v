`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:51 10/19/2015 
// Design Name: 
// Module Name:    UART_TestModule 
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
module UART_TestModule(
	input test_rx,		// al tx de la compu
	input clock,		// clock de la placa a 50Mhz
	output test_tx		// al rx de la compu
    );

	
	wire [7:0] 	rcvd_data,		// dato a la salida del receptor
					get_data_fifo;	// dato a la salida de la fifo
	
	wire 			rx_done,
					baud_rate,	// clock a 9600 baudios
					tx_start,	// trabaja por lógica negativa
					tx_done,
					empty_fifo,
					full_fifo;
	
	reg			reset;

	UART_baud_rate_generator BRG(
		.clock(clock),
		.baud_rate_clock(baud_rate)
	);
	
	UART_rx RX(
		.rx(test_rx),
		.s_tick(baud_rate),
		.reset(reset),
		.clock(clock),
		.rx_done(rx_done),
		.d_out(rcvd_data)
	);
	
	UART_fifo_interface FIFO_BUFFER(
		.write_flag(rx_done),
		.read_flag(tx_start),
		.data_in(rcvd_data),
		.clock(clock),
		.reset(reset),
		.data_out(get_data_fifo),
		.empty_flag(empty_fifo),
		.full_flag(full_fifo)
	);
	
	UART_tx TX(
		.clock(clock),
		.data_in(get_data_fifo),
		.tx_start(tx_start),
		.reset(reset),
		.tx_done(tx_done),
		.tx(test_tx)
	);

	assign tx_start = rx_done;
	
	initial begin
		reset = 1;
		#1;
		reset = 0;
	end
	
endmodule
