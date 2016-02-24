`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:58:53 02/24/2016
// Design Name:   MainModule
// Module Name:   C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/PipeAndDebug/MainModuleTest.v
// Project Name:  PipeAndDebug
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MainModule
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MainModuleTest;

	// Inputs
	reg clock;
	reg resetGral;
	reg uartRxPin;
	localparam [7:0] sAscii="s";
	localparam [7:0] nAscii="n";
	localparam [7:0] cAscii="c";
	localparam start=0,
				  stop=1;
	integer i;

	// Outputs
	wire uartTxPin;
	wire ledIdle;
	wire ledStep;
	wire ledSend;
	wire ledCont;

	// Instantiate the Unit Under Test (UUT)
	Datapath1 uut (
		.clock(clock), 
		.resetGral(resetGral), 
		.uartRxPin(uartRxPin), 
		.uartTxPin(uartTxPin), 
		.ledIdle(ledIdle), 
		.ledStep(ledStep), 
		.ledSend(ledSend), 
		.ledCont(ledCont)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		resetGral = 1;
		uartRxPin = 1;
		#10;
		resetGral = 0;
		// Wait 100 ns for global reset to finish     
		// Add stimulus here
		
		#300.5;
		uartRxPin = start;
		#10416;
		for (i=0;i<8;i=i+1)begin
			uartRxPin = sAscii[i];
			#10416;
		end
		i=0;
		uartRxPin = stop;
		#10416;
		#30000;
		uartRxPin = start;
		#10416;
		for (i=0;i<8;i=i+1)begin
			uartRxPin = nAscii[i];
			#10416;
		end
		i=0;
		uartRxPin = stop;
		#10416;
	end
	
	always begin
		clock = ~clock;
		#0.5;
	end
	
	
      
endmodule

