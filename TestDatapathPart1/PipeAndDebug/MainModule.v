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
	 output ledCont,
	 output [7:0]sendCounter,
	 output sentFlag,
	 output notStartUartTx,
	 output waitingForReg,
	 output ledDataAvailable
    );
	 
	 wire AluZero, ALUOverflow;
	 wire dcmOut;
	 wire dcmOut70;
	 Datapath1 datapath( 		
	   .clock(dcmOut),
		.clock70(dcmOut70),
		.resetGral(resetGral),
		.uartRxPin(uartRxPin),
		.uartTxPin(uartTxPin),
		
		.ALUzero(AluZero),
		.ALUOverflow(ALUOverflow),
		.ledIdle(ledIdle),
		.ledStep(ledStep),
		.ledSend(ledSend),
		.ledCont(ledCont),
		.sendCounter(sendCounter),
		.sentFlag(sentFlag),
		.notStartUartTx(notStartUartTx),
		.ledDataAvailable(ledDataAvailable)
	 );
	 
	 clk_wiz_v3_6(
		.CLK_IN1(clock),		// clock de la placa a 100MHz
		.CLK_OUT1(dcmOut),	// clock a 12.5MHz
		.CLK_OUT2(dcmOut70)	// clock a 12.5MHz desfasado 70 grados
	 );


endmodule
