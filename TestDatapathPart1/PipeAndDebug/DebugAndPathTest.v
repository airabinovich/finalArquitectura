`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:36 12/01/2015
// Design Name:   Datapath1
// Module Name:   C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/PipeAndDebug/DebugAndPathTest.v
// Project Name:  PipeAndDebug
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Datapath1
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module DebugAndPathTest;

	// Inputs
	reg clock;
	reg resetGral;
	wire uartRxPin;

	// Outputs
	wire uartTxPin;
	wire ALUzero;
	wire ALUOverflow;

	localparam uart_COUNT = 651;
	
	reg txStart=1;
	reg[7:0] dataPC;
	// Instantiate the Unit Under Test (UUT)
	Datapath1 uut (
		.clock(clock), 
		.resetGral(resetGral), 
		.uartRxPin(uartRxPin), 
		.uartTxPin(uartTxPin), 
		.ALUzero(ALUzero), 
		.ALUOverflow(ALUOverflow)
	);
	
	UART_baud_rate_generator #(.COUNT(uart_COUNT*16)) tx_baud_rate(
		.clock(clock),
		.baud_rate(baud_rate_tx)
	);
	
	UART_tx transmisorPC(
	.clock(clock),			// clock de la placa a 50MHz
	.reset(resetGral),
	.s_tick(baud_rate_tx),			// del baud rate generator a 9600bps
	.tx_start(txStart),		// flag de comienzo de envío (LÓGICA NEGATIVA)
	.data_in(dataPC),	// buffer de entrada de datos paralelo
	.tx(uartRxPin),			// salida serie de datos
	.tx_done(txDone)	// flag de finalización de envío
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		resetGral = 1;
		txStart=1;
		// Wait 100 ns for global reset to finish
		#100;
		resetGral=0;
      #100;
		dataPC=115;
		#10;
		txStart=0;
		#5;
		txStart=1;
		#500000;
		dataPC=110;
		#10;
		txStart=0;
		#5;
		txStart=1;
		// Add stimulus here

	end
	
	always begin
		clock=~clock;
		#1;
	end
	
	
      
endmodule

