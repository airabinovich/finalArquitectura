`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:00:55 11/27/2015 
// Design Name: 
// Module Name:    DebugUnit 
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
module DebugUnit(
		input clock,
		input reset,
		input endOfProgram,
		input [7:0]uartFifoDataIn,
		input 	  uartDataAvailable,
		
		input [7:0]		FE_pc,	
		input [31:0] 	IF_ID_instruction,
		input [7:0] 	IF_ID_pcNext,		
		input [3:0] 	ID_EX_aluOperation,
		input [31:0] 	ID_EX_sigExt,
		input [31:0] 	ID_EX_readData1,
		input [31:0] 	ID_EX_readData2,
		input 			ID_EX_aluSrc,
		input 			ID_EX_aluShiftImm,
		input [3:0] 	ID_EX_memWrite,
		input 			ID_EX_memToReg,
		input	[1:0] 	ID_EX_memReadWidth,
		input [4:0] 	ID_EX_rs,
		input [4:0] 	ID_EX_rt,
		input [4:0] 	ID_EX_rd,
		input [4:0] 	ID_EX_sa,
		input 			ID_EX_regDst,
		input 			ID_EX_loadImm,
		input 			ID_EX_regWrite,
		input [4:0] 	EX_MEM_writeRegister,
		input [31:0] 	EX_MEM_writeData,
		input [31:0] 	EX_MEM_aluOut,
		input 			EX_MEM_regWrite,
		input 			EX_MEM_memToReg,
		input [3:0]		EX_MEM_memWrite,
		input [1:0] 	EX_MEM_memReadWidth,
		input [4:0] 	MEM_WB_writeRegister,
		input [31:0] 	MEM_WB_aluOut,
		input [31:0] 	MEM_WB_memoryOut,
		input 			MEM_WB_regWrite,
		input 			MEM_WB_memToReg,
		
		output reg [7:0] 	dataToUartOutFifo,
		output reg			readFifoFlag,
		output reg			writeFifoFlag,
		output reg pipeEnable,
		output reg pipeReset ,
		
		output reg ledStep,
		output reg ledCont,
		output reg ledIdle,
		output reg ledSend
		
    );
	 
	 reg [2:0] current_state;
	 reg [2:0] next_state;
	 reg [7:0]sendCounter;
	 reg sentFlag;
	 localparam [2:0]	INIT = 0,
							IDLE = 1,
							CONTINUOUS = 2,
							STEP = 3,
							SEND = 4;
					
	 
	 always @(posedge clock, posedge reset) begin
		if(reset)begin
			current_state <= INIT ;
		end
		else
			current_state <= next_state;
	 end

	 always @(posedge clock) begin
	 	
		case(current_state)
			INIT:begin
				writeFifoFlag=0;
				readFifoFlag=0;
				sendCounter<=0;
				ledIdle<=0;
				ledStep<=0;
				ledCont<=0;
				ledSend<=0;
				next_state<=IDLE;
			end
			IDLE:begin
				ledIdle<=1;
				ledStep<=0;
				ledCont<=0;
				ledSend<=0;
				pipeReset<=1;
				pipeEnable<=0;
				sentFlag<=0;
				sendCounter<=0;
				if(readFifoFlag)begin
					if(uartFifoDataIn==99)begin //'c' en ascii
						next_state<=CONTINUOUS;
						pipeReset<=0;
						readFifoFlag=0;
					end
					else if (uartFifoDataIn==115)begin //'s' en ascii
						next_state<=STEP;
						readFifoFlag=0;
						pipeReset<=0;
					end
//					else begin
//						next_state<=IDLE;
//					end
				end
				else if(uartDataAvailable)begin
					readFifoFlag=1;
			   end
				else begin
					readFifoFlag=0;
//					next_state<=IDLE;
				end
			end
			CONTINUOUS: begin
				ledIdle<=0;
				ledStep<=0;
				ledCont<=1;
				ledSend<=0;
				
				sentFlag<=0;	
				sendCounter<=0;
				pipeEnable<=1;
				if(endOfProgram)
					next_state<=SEND;
				else
					next_state<=CONTINUOUS;
			end
			STEP: begin
				ledIdle<=0;
				ledStep<=1;
				ledCont<=0;
				ledSend<=0;
			
				sentFlag<=0;
				sendCounter<=0;
				if(readFifoFlag)begin
					if(uartFifoDataIn==110)begin //'n' en ascii
						next_state<=SEND;
						readFifoFlag=0;
						pipeEnable<=1;
					end
					readFifoFlag=0;
				end
				else if(uartDataAvailable)begin
					readFifoFlag=1;
				end
				else begin
//					next_state<=STEP;
					readFifoFlag=0;
				end
			end
			SEND: begin
				ledIdle<=0;
				ledStep<=0;
				ledCont<=0;
				ledSend<=1;
				
				pipeEnable<=0;
				if(sentFlag && !endOfProgram)
					next_state<=STEP;
				else if(sentFlag && endOfProgram)
					next_state<=IDLE;
				else begin
					writeFifoFlag=1;
					case(sendCounter)
						0:		dataToUartOutFifo=			FE_pc;
						1:		dataToUartOutFifo=  		IF_ID_instruction		[7:0];
						2:		dataToUartOutFifo=  		IF_ID_instruction		[15:8];
						3:		dataToUartOutFifo=  		IF_ID_instruction 	[23:16];
						4:		dataToUartOutFifo=  		IF_ID_instruction 	[31:24];
						5:		dataToUartOutFifo=			IF_ID_pcNext;
						6:		dataToUartOutFifo=  {4'b0,ID_EX_aluOperation};
						7:		dataToUartOutFifo= 	 		ID_EX_sigExt			[7:0];
						8:		dataToUartOutFifo= 			ID_EX_sigExt			[15:8];
						9:		dataToUartOutFifo=  		ID_EX_sigExt			[23:16];
						10:	dataToUartOutFifo= 			ID_EX_sigExt			[31:24];
						11:	dataToUartOutFifo= 			ID_EX_readData1		[7:0];
						12:	dataToUartOutFifo= 	 		ID_EX_readData1		[15:8];
						13:	dataToUartOutFifo= 			ID_EX_readData1		[23:16];
						14:	dataToUartOutFifo= 			ID_EX_readData1		[31:24];
						15:	dataToUartOutFifo=  		ID_EX_readData2		[7:0];
						16:	dataToUartOutFifo=  		ID_EX_readData2		[15:8];
						17:	dataToUartOutFifo= 			ID_EX_readData2		[23:16];
						18:	dataToUartOutFifo=  		ID_EX_readData2		[31:24];
						19:	dataToUartOutFifo=	{7'b0,ID_EX_aluSrc};
						20:	dataToUartOutFifo=	{7'b0,ID_EX_aluShiftImm};
						21:	dataToUartOutFifo=	{4'b0,ID_EX_memWrite};
						22:	dataToUartOutFifo=	{7'b0,ID_EX_memToReg};
						23:	dataToUartOutFifo=	{6'b0,ID_EX_memReadWidth};
						24:	dataToUartOutFifo=	{3'b0,ID_EX_rs};
						25:	dataToUartOutFifo=	{3'b0,ID_EX_rt};
						26:	dataToUartOutFifo=	{3'b0,ID_EX_rd};
						27:	dataToUartOutFifo=	{3'b0,ID_EX_sa};
						28:	dataToUartOutFifo=	{7'b0,ID_EX_regDst};
						29:	dataToUartOutFifo=	{7'b0,ID_EX_loadImm};
						30:	dataToUartOutFifo=	{7'b0,ID_EX_regWrite};
						31:	dataToUartOutFifo=	{3'b0,EX_MEM_writeRegister};
						32:	dataToUartOutFifo=  		EX_MEM_writeData		[7:0];
						33:	dataToUartOutFifo=  		EX_MEM_writeData		[15:8];
						34:	dataToUartOutFifo= 			EX_MEM_writeData		[23:16];
						35:	dataToUartOutFifo= 			EX_MEM_writeData		[31:24];	
						36:	dataToUartOutFifo=  		EX_MEM_aluOut			[7:0];
						37:	dataToUartOutFifo=  		EX_MEM_aluOut			[15:8];
						38:	dataToUartOutFifo= 			EX_MEM_aluOut			[23:16];
						39:	dataToUartOutFifo= 			EX_MEM_aluOut			[31:24];
						40:	dataToUartOutFifo=	{7'b0,EX_MEM_regWrite};
						41:	dataToUartOutFifo=	{7'b0,EX_MEM_memToReg};
						42:	dataToUartOutFifo=	{4'b0,EX_MEM_memWrite};
						43:	dataToUartOutFifo=	{6'b0,EX_MEM_memReadWidth};
						44:	dataToUartOutFifo=	{3'b0,MEM_WB_writeRegister};
						45:	dataToUartOutFifo=  		MEM_WB_aluOut			[7:0];
						46:	dataToUartOutFifo=  		MEM_WB_aluOut			[15:8];
						47:	dataToUartOutFifo= 			MEM_WB_aluOut			[23:16];
						48:	dataToUartOutFifo= 			MEM_WB_aluOut			[31:24];
						49:	dataToUartOutFifo=  		MEM_WB_memoryOut		[7:0];
						50:	dataToUartOutFifo=  		MEM_WB_memoryOut		[15:8];
						51:	dataToUartOutFifo= 			MEM_WB_memoryOut		[23:16];
						52:	dataToUartOutFifo= 			MEM_WB_memoryOut		[31:24];
						53:	dataToUartOutFifo=	{7'b0,MEM_WB_regWrite};
						54:	dataToUartOutFifo=	{7'b0,MEM_WB_memToReg};
						
						55:	dataToUartOutFifo= 68;
						56:	dataToUartOutFifo= 79;
						57:	dataToUartOutFifo= 78;
						58:	dataToUartOutFifo= 69;
						59:begin
							writeFifoFlag=0;
							sentFlag<=1;
						end
					endcase
					sendCounter<=sendCounter+1;
				end
				
			end
		endcase
	 end
	 


endmodule
