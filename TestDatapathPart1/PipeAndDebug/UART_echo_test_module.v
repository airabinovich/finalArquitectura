`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:12 10/28/2015 
// Design Name: 
// Module Name:    UART_uart_module 
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
module UART_uart(
	input clock,
	input uart_rx,
	input uart_reset,
	input readFlag,
	input writeFlag,
	input [7:0]dataToSend,
	output [7:0]receivedData,
	output dataAvailable,
	output uart_tx
    );

	wire 		baud_rate_rx,
				baud_rate_tx,
				uart_rx_done,
				uart_tx_done,
				uart_tx_start,
				send_next_tx,
				uart_empty_flag_rx,
				uart_not_empty_flag_rx,
				uart_empty_flag_tx,
				uart_not_empty_flag_tx;
//				uart_full_flag_rx,
//				uart_full_flag_tx;
	
	wire [7:0]	uart_data_rx;
	wire [7:0]	uart_data_tx;
	wire [7:0]	uart_data;
	
	localparam uart_COUNT = 651;
	
	UART_baud_rate_generator #(.COUNT(uart_COUNT)) rx_baud_rate(
		.clock(clock),
		.baud_rate(baud_rate_rx)
	);
	
	UART_rx receptor(
		.rx(uart_rx),
		.s_tick(baud_rate_rx),
		.clock(clock),
		.reset(uart_reset),
		.rx_done(uart_rx_done),
		.d_out(uart_data_rx)
	);
	
	UART_fifo_interface fifo_rx(
		.clock(clock),
		.reset(uart_reset),
		.write_flag(uart_rx_done),
		.read_next(readFlag),
		.data_in(uart_data_rx),
		.data_out(receivedData),
		.empty_flag(uart_empty_flag_rx)
//		.full_flag(uart_full_flag_rx)
	);
	
	UART_baud_rate_generator #(.COUNT(uart_COUNT*16)) tx_baud_rate(
		.clock(clock),
		.baud_rate(baud_rate_tx)
	);
	
	UART_tx transmisor(
		.clock(clock),
		.reset(uart_reset),
		.s_tick(baud_rate_tx),		
		.tx_start(uart_start_tx),
		.data_in(uart_data_tx),
		.tx(uart_tx),
		.tx_done(uart_tx_done)
	);
	
	UART_fifo_interface fifo_tx(
		.clock(clock),
		.reset(uart_reset),
		.write_flag(writeFlag),
		.read_next(send_next_tx),
		.data_in(dataToSend),
		.data_out(uart_data_tx),
		.empty_flag(uart_empty_flag_tx)
//		.full_flag(uart_full_flag_tx)
	);
	assign send_next_tx = uart_not_empty_flag_tx && uart_tx_done;
	assign uart_start_tx = uart_empty_flag_tx;
	assign uart_not_empty_flag_tx = ~uart_empty_flag_tx;
	assign dataAvailable = ~uart_empty_flag_rx;
endmodule
