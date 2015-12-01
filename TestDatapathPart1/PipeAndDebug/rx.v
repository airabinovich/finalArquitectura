`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:46:45 10/11/2015 
// Design Name: 
// Module Name:    rx 
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
module UART_rx(
	input rx,					// entrada serie de datos
	input s_tick,				// clock baud rate (9600 bps)
	input reset,
	input clock,				// clock de la placa (50MHz)
	output reg rx_done,		// flag de finalización de recepción
	output reg [7:0] d_out	// salida paralela de datos
);
	localparam [1:0]	IDLE = 0,
							START = 1,
							DATA = 2,
							STOP = 3;

	localparam 			D_BIT = 8,
							B_start= 0,
							B_stop= 1;
	
	reg [1:0] current_state, next_state;
	reg [3:0] s;
	reg [3:0] n;

	// algoritmo de cambio de estado
	always @(posedge clock, posedge reset) begin
		if(reset)
			current_state <= IDLE ;
		else
			current_state <= s_tick ? next_state : current_state;
	end
	
	//lógica interna de estados
	always @(posedge clock) begin
		if(rx_done==1)begin
			rx_done = 0;
		end
		if(s_tick) begin
			case(current_state)
				IDLE: begin
					rx_done=0;
					s = 0;
					next_state = (rx == B_start) ? START : IDLE;
				end
				START: begin
					rx_done=0;
					if(s >= 7) begin
						s = 0;
						n = 0;
						next_state = DATA;
					end
					else begin
						s = s + 1;
					end
				end
				DATA: begin
					if(s >= 15) begin
						s = 0;
						if(n >= D_BIT) begin
							next_state = STOP;
						end
						else begin
							d_out = {rx,d_out[7:1]};
							n = n + 1;
						end
					end
					else begin
						s = s + 1;
					end
				end
				STOP: begin
				   if(rx==0)begin
						rx_done = 1;
						next_state = START;
						s = 0;
						n = 0;					
					end
					else if(s == 15) begin
						rx_done = 1;
						s=0;
						next_state = IDLE;
					end
					else begin
						s = s + 1;
					end
				end
			endcase
		end
	end
	
endmodule
