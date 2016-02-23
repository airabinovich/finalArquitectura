`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:17:11 02/17/2016 
// Design Name: 
// Module Name:    MainModule 
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
module MainModule(
    input clock,
    input resetGral,
    input uartRxPin,
    output uartTxPin,
	 output ledIdle,
	 output ledStep,
	 output ledSend,
	 output ledCont
    );
	 
	 wire AluZero, ALUOverflow;
	 wire dcmOut;
	 Datapath1 datapath( 		
	   .clock(dcmOut),
		.resetGral(resetGral),
		.uartRxPin(uartRxPin),
		.uartTxPin(uartTxPin),
		
		.ALUzero(AluZero),
		.ALUOverflow(ALUOverflow),
		.ledIdle(ledIdle),
		.ledStep(ledStep),
		.ledSend(ledSend),
		.ledCont(ledCont)
	 );
	 
	 clk_wiz_v3_6(
		.CLK_IN1(clock),
		.CLK_OUT1(dcmOut)
	 );


endmodule
