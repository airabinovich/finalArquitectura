`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:07:12 10/28/2015 
// Design Name: 
// Module Name:    UART_echo_test_module 
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
module UART_echo_test_module(
	input clock,
	input echo_test_rx,
	input echo_test_reset,
	output echo_test_tx
    );

	wire 		baud_rate_rx,
				baud_rate_tx,
				echo_test_rx_done,
//				echo_test_tx_done,
				echo_test_tx_start,
				echo_test_empty_flag_rx,
				echo_test_not_empty_flag_rx,
				echo_test_empty_flag_tx,
				echo_test_not_empty_flag_tx;
//				echo_test_full_flag_rx,
//				echo_test_full_flag_tx;
	
	wire [7:0]	echo_test_data_rx;
	wire [7:0]	echo_test_data_tx;
	wire [7:0]	echo_test_data;
	
	localparam echo_test_COUNT = 651;
	
	UART_baud_rate_generator #(.COUNT(echo_test_COUNT)) rx_baud_rate(
		.clock(clock),
		.baud_rate(baud_rate_rx)
	);
	
	UART_rx receptor(
		.rx(echo_test_rx),
		.s_tick(baud_rate_rx),
		.clock(clock),
		.reset(echo_test_reset),
		.rx_done(echo_test_rx_done),
		.d_out(echo_test_data_rx)
	);
	
	UART_fifo_interface fifo_rx(
		.clock(clock),
		.reset(echo_test_reset),
		.write_flag(echo_test_rx_done),
		.read_flag(echo_test_not_empty_flag_rx),
		.data_in(echo_test_data_rx),
		.data_out(echo_test_data),
		.empty_flag(echo_test_empty_flag_rx)
//		.full_flag(echo_test_full_flag_rx)
	);
	
	UART_baud_rate_generator #(.COUNT(echo_test_COUNT*16)) tx_baud_rate(
		.clock(clock),
		.baud_rate(baud_rate_tx)
	);
	
	UART_tx transmisor(
		.clock(clock),
		.reset(echo_test_reset),
		.s_tick(baud_rate_tx),		
		.tx_start(echo_test_start_tx),
		.data_in(echo_test_data_tx),
		.tx(echo_test_tx)
//		.tx_done(echo_test_tx_done)
	);
	
	UART_fifo_interface fifo_tx(
		.clock(clock),
		.reset(echo_test_reset),
		.write_flag(echo_test_not_empty_flag_rx),
		.read_flag(echo_test_not_empty_flag_tx),
		.data_in(echo_test_data),
		.data_out(echo_test_data_tx),
		.empty_flag(echo_test_empty_flag_tx)
//		.full_flag(echo_test_full_flag_tx)
	);
	
	assign echo_test_start_tx = echo_test_empty_flag_tx;
	assign echo_test_not_empty_flag_tx = ~echo_test_empty_flag_tx;
	assign echo_test_not_empty_flag_rx = ~echo_test_empty_flag_rx;
endmodule
