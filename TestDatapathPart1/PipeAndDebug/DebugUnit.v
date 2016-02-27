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
		input uartDataSent,
		
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
		input [31:0]	readDataFromRegs,
		
		
		output reg [7:0] 	dataToUartOutFifo,
		output reg			readFifoFlag,
		output reg			writeFifoFlag,
		output reg pipeEnable,
		output reg pipeReset ,
		output reg [4:0] readAddrFromBank,
		output reg ledStep,
		output reg ledCont,
		output reg ledIdle,
		output reg ledSend,
		output reg notStartUartTrans,
		output reg [7:0]sendCounter,
		output reg sentFlag,
		output waitingForReg
		
    );
	 
	 reg [2:0] current_state;
	 reg [2:0] next_state;
//	 reg [7:0]sendCounter;
//	 reg [7:0]sendCounterNext;
	 reg restartCounter;
	 //wire waitingForReg;
//	 reg sentFlag;
	 localparam [2:0]	INIT = 0,
							IDLE = 1,
							CONTINUOUS = 2,
							STEP = 3,
							SEND = 4;
							
	 localparam [7:0]cantDatos=8'd111;
	 
	 assign waitingForReg= 
	 (sendCounter==55)|(sendCounter==56)|
	 (sendCounter==61)|(sendCounter==62)|
	 (sendCounter==67)|(sendCounter==68)|
	 (sendCounter==73)|(sendCounter==74)|
	 (sendCounter==79)|(sendCounter==80)|
	 (sendCounter==85)|(sendCounter==86);
//	 (sendCounter==91)|(sendCounter==92)|
//	 (sendCounter==97)|(sendCounter==98)|
//	 (sendCounter==103)|(sendCounter==104);
	 
	 always @(posedge clock, posedge reset) begin
		if(reset)begin
			current_state = INIT ;
			sendCounter=0;
		end
		else begin
			current_state = next_state;
			if(current_state==SEND && (uartDataSent || sendCounter==cantDatos || waitingForReg))begin
				sendCounter=sendCounter+1;
			end
			if(current_state!=SEND) begin
				sendCounter=0;
//				notStartUartTrans=1;
			end
//			else begin
//				notStartUartTrans=0;
//			end
		end
	 end

	 always @(*) begin
		case(current_state)
			INIT:begin
				writeFifoFlag=0;
				readFifoFlag=0;
//				sendCounterNext=0;
				ledIdle=0;
				ledStep=0;
				ledCont=0;
				ledSend=0;
				pipeReset=1;
				pipeEnable=0;
//				waitingForReg=0;
				restartCounter=0;
				notStartUartTrans=1;
				next_state=IDLE;
			end
			IDLE:begin
				ledIdle=1;
				ledStep=0;
				ledCont=0;
				ledSend=0;
				pipeReset=1;
				pipeEnable=0;
				sentFlag=0;
//				waitingForReg=0;
				notStartUartTrans=1;
//				sendCounterNext=0;
				if(uartDataAvailable)begin
					if(uartFifoDataIn==99)begin //'c' en ascii
						next_state=CONTINUOUS;
						pipeReset=0;
					end
					else if (uartFifoDataIn==115)begin //'s' en ascii
						next_state=STEP;
						pipeReset=0;
					end
					else begin
						next_state=IDLE;
					end
					readFifoFlag=1;
			   end
				else begin
					readFifoFlag=0;
//					next_state=IDLE;
				end
			end
			CONTINUOUS: begin
				ledIdle=0;
				ledStep=0;
				ledCont=1;
				ledSend=0;
				pipeReset=0;
//				waitingForReg=0;
				readFifoFlag=0;
				sentFlag=0;	
//				sendCounterNext=0;
				pipeEnable=1;
				if(endOfProgram)
					next_state=SEND;
				else
					next_state=CONTINUOUS;
			end
			STEP: begin
				ledIdle=0;
				ledStep=1;
				ledCont=0;
				ledSend=0;
//				waitingForReg=0;
				pipeEnable=0;
				pipeReset=0;
				restartCounter=0;
				notStartUartTrans=1;
				sentFlag=0;
				if(uartDataAvailable)begin
					if(uartFifoDataIn==110)begin //'n' en ascii
						next_state=SEND;
						pipeEnable=1;
					end
					else begin
						next_state=STEP;
						pipeEnable=0;
					end
					readFifoFlag=1;
				end
				else begin
					next_state=STEP;
					readFifoFlag=0;
				end
			end
			SEND: begin
				ledIdle=0;
				ledStep=0;
				ledCont=0;
				ledSend=1;
				pipeReset=0;
				readFifoFlag=0;
				pipeEnable=0;
				if(sentFlag && !endOfProgram)begin
					next_state=STEP;
				end
				else if(sentFlag && endOfProgram)begin
					next_state=IDLE;
				end
				else begin
				   next_state=SEND;
					writeFifoFlag=1;
//					notStartUartTrans=0;
					case(sendCounter)
//						0: begin 
//								notStartUartTrans=0;
//								dataToUartOutFifo= 1;
//							end
//						1: dataToUartOutFifo= 0;
//						2: dataToUartOutFifo= 0;
//						3: dataToUartOutFifo= 0;
//						4: dataToUartOutFifo= 2;
//						5: dataToUartOutFifo= 3;
//						6: dataToUartOutFifo= 4;
//						7: dataToUartOutFifo= 0;
//						8: dataToUartOutFifo= 0;
//						9: dataToUartOutFifo= 0;
//						10: dataToUartOutFifo= 5;
//						11: dataToUartOutFifo= 0;
//						12: dataToUartOutFifo= 0;
//						13: dataToUartOutFifo= 0;
//						14: dataToUartOutFifo= 6;
//						15: dataToUartOutFifo= 0;
//						16: dataToUartOutFifo= 0;
//						17: dataToUartOutFifo= 0;
//						18: dataToUartOutFifo= 7;
//						19: dataToUartOutFifo= 8;
//						20: dataToUartOutFifo= 9;
//						21: dataToUartOutFifo= 10;
//						22: dataToUartOutFifo= 11;
//						23: dataToUartOutFifo= 12;
//						24: dataToUartOutFifo= 13;
//						25: dataToUartOutFifo= 14;
//						26: dataToUartOutFifo= 15;
//						27: dataToUartOutFifo= 16;
//						28: dataToUartOutFifo= 17;
//						29: dataToUartOutFifo= 18;
//						30: dataToUartOutFifo= 19;
//						31: dataToUartOutFifo= 20;
//						32: dataToUartOutFifo= 0;
//						33: dataToUartOutFifo= 0;
//						34: dataToUartOutFifo= 0;
//						35: dataToUartOutFifo= 21;
//						36: dataToUartOutFifo= 0;
//						37: dataToUartOutFifo= 0;
//						38: dataToUartOutFifo= 0;
//						39: dataToUartOutFifo= 22;
//						40: dataToUartOutFifo= 23;
//						41: dataToUartOutFifo= 24;
//						42: dataToUartOutFifo= 25;
//						43: dataToUartOutFifo= 26;
//						44: dataToUartOutFifo= 27;
//						45: dataToUartOutFifo= 0;
//						46: dataToUartOutFifo= 0;
//						47: dataToUartOutFifo= 0;
//						48: dataToUartOutFifo= 28;
//						49: dataToUartOutFifo= 0;
//						50: dataToUartOutFifo= 0;
//						51: dataToUartOutFifo= 0;
//						52: dataToUartOutFifo= 29;
//						53: dataToUartOutFifo= 30;
//						54: dataToUartOutFifo= 31;
//						55: dataToUartOutFifo= 0;
//						56: dataToUartOutFifo= 0;
//						57: dataToUartOutFifo= 0;
//						58: dataToUartOutFifo= 32;
//						59: dataToUartOutFifo= 0;
//						60: dataToUartOutFifo= 0;
//						61: dataToUartOutFifo= 0;
//						62: dataToUartOutFifo= 33;
//						63: dataToUartOutFifo= 0;
//						64: dataToUartOutFifo= 0;
//						65: dataToUartOutFifo= 0;
//						66: dataToUartOutFifo= 34;
//						67: dataToUartOutFifo= 0;
//						68: dataToUartOutFifo= 0;
//						69: dataToUartOutFifo= 0;
//						70: dataToUartOutFifo= 35;
//						71: dataToUartOutFifo= 0;
//						72: dataToUartOutFifo= 0;
//						73: dataToUartOutFifo= 0;
//						74: dataToUartOutFifo= 36;
//						75: dataToUartOutFifo= 0;
//						76: dataToUartOutFifo= 0;
//						77: dataToUartOutFifo= 0;
//						78: dataToUartOutFifo= 37;
//						79: dataToUartOutFifo= 0;
//						80: dataToUartOutFifo= 0;
//						81: dataToUartOutFifo= 0;
//						82: dataToUartOutFifo= 38;
//						83: dataToUartOutFifo= 0;
//						84: dataToUartOutFifo= 0;
//						85: dataToUartOutFifo= 0;
//						86: dataToUartOutFifo= 39;
//						87: dataToUartOutFifo= 0;
//						88: dataToUartOutFifo= 0;
//						89: dataToUartOutFifo= 0;
//						90: dataToUartOutFifo= 40;
//						91: dataToUartOutFifo= 0;
//						92: dataToUartOutFifo= 0;
//						93: dataToUartOutFifo= 0;
//						94: dataToUartOutFifo= 41;	
						
						0: begin 
								notStartUartTrans=0;
								dataToUartOutFifo=			FE_pc;
							end
						1:		dataToUartOutFifo=  			IF_ID_instruction		[7:0];
						2:		dataToUartOutFifo=  			IF_ID_instruction		[15:8];
						3:		dataToUartOutFifo=  			IF_ID_instruction 	[23:16];
						4:		dataToUartOutFifo=  			IF_ID_instruction 	[31:24];
						5:		dataToUartOutFifo=			IF_ID_pcNext;
						6:		dataToUartOutFifo=  {4'b0,ID_EX_aluOperation};
						7:		dataToUartOutFifo= 	 		ID_EX_sigExt			[7:0];
						8:		dataToUartOutFifo= 			ID_EX_sigExt			[15:8];
						9:		dataToUartOutFifo=  			ID_EX_sigExt			[23:16];
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
						32:	dataToUartOutFifo=  			EX_MEM_writeData		[7:0];
						33:	dataToUartOutFifo=  			EX_MEM_writeData		[15:8];
						34:	dataToUartOutFifo= 			EX_MEM_writeData		[23:16];
						35:	dataToUartOutFifo= 			EX_MEM_writeData		[31:24];	
						36:	dataToUartOutFifo=  			EX_MEM_aluOut			[7:0];
						37:	dataToUartOutFifo=  			EX_MEM_aluOut			[15:8];
						38:	dataToUartOutFifo= 			EX_MEM_aluOut			[23:16];
						39:	dataToUartOutFifo= 			EX_MEM_aluOut			[31:24];
						40:	dataToUartOutFifo=	{7'b0,EX_MEM_regWrite};
						41:	dataToUartOutFifo=	{7'b0,EX_MEM_memToReg};
						42:	dataToUartOutFifo=	{4'b0,EX_MEM_memWrite};
						43:	dataToUartOutFifo=	{6'b0,EX_MEM_memReadWidth};
						44:	dataToUartOutFifo=	{3'b0,MEM_WB_writeRegister};
						45:	dataToUartOutFifo=  			MEM_WB_aluOut			[7:0];
						46:	dataToUartOutFifo=  			MEM_WB_aluOut			[15:8];
						47:	dataToUartOutFifo= 			MEM_WB_aluOut			[23:16];
						48:	dataToUartOutFifo= 			MEM_WB_aluOut			[31:24];
						49:	dataToUartOutFifo=  			MEM_WB_memoryOut		[7:0];
						50:	dataToUartOutFifo=  			MEM_WB_memoryOut		[15:8];
						51:	dataToUartOutFifo= 			MEM_WB_memoryOut		[23:16];
						52:	dataToUartOutFifo= 			MEM_WB_memoryOut		[31:24];
						53:	dataToUartOutFifo=	{7'b0,MEM_WB_regWrite};
//						54:	dataToUartOutFifo=	{7'b0,MEM_WB_memToReg};
						54:	dataToUartOutFifo=	99;
						
						
//						55:   notStartUartTrans=1;
//						56:   readAddrFromBank=0;
//						57:	begin
//									notStartUartTrans=0;
//									dataToUartOutFifo= readDataFromRegs[31:24];
//								end
//						58:	dataToUartOutFifo= readDataFromRegs[23:16];
//						59: 	dataToUartOutFifo= readDataFromRegs[15:8];
//						60: 	dataToUartOutFifo= readDataFromRegs[7:0];
						55: begin 
								//waitingForReg=1;
								notStartUartTrans=1;
							end
						56:begin 
								readAddrFromBank=0;
								//waitingForReg=1;
							end
						57: begin
//								waitingForReg=0;
								notStartUartTrans=0;
								dataToUartOutFifo= readDataFromRegs[31:24];
							end
						58:dataToUartOutFifo= readDataFromRegs[23:16];
						59:dataToUartOutFifo= readDataFromRegs[15:8];
						60:dataToUartOutFifo= readDataFromRegs[7:0];
						61: begin 
//								waitingForReg=1;
								notStartUartTrans=1;
							end
						62:begin 
								readAddrFromBank=1;
								//waitingForReg=1;
							end
						63: begin
//								waitingForReg=0;
								notStartUartTrans=0;
								dataToUartOutFifo= readDataFromRegs[31:24];
							end
						64:dataToUartOutFifo= readDataFromRegs[23:16];
						65:dataToUartOutFifo= readDataFromRegs[15:8];
						66:dataToUartOutFifo= readDataFromRegs[7:0];
						67: begin 
//								waitingForReg=1;
								notStartUartTrans=1;
							end
						68:begin 
								readAddrFromBank=2;
//								waitingForReg=1;
							end
						69: begin
//								waitingForReg=0;
								notStartUartTrans=0;
								dataToUartOutFifo= readDataFromRegs[31:24];
							end
						70:dataToUartOutFifo= readDataFromRegs[23:16];
						71:dataToUartOutFifo= readDataFromRegs[15:8];
						72:dataToUartOutFifo= readDataFromRegs[7:0];
						73: begin 
//								waitingForReg=1;
								notStartUartTrans=1;
							end
						74:begin 
								readAddrFromBank=3;
//								waitingForReg=1;
							end
						75: begin
//								waitingForReg=0;
								notStartUartTrans=0;
								dataToUartOutFifo= readDataFromRegs[31:24];
							end
						76:dataToUartOutFifo= readDataFromRegs[23:16];
						77:dataToUartOutFifo= readDataFromRegs[15:8];
						78:dataToUartOutFifo= readDataFromRegs[7:0];
						79: begin 
//								waitingForReg=1;
								notStartUartTrans=1;
							end
						80:begin 
								readAddrFromBank=4;
//								waitingForReg=1;
							end
						81: begin
//								waitingForReg=0;
								notStartUartTrans=0;
								dataToUartOutFifo= readDataFromRegs[31:24];
							end
						82:dataToUartOutFifo= readDataFromRegs[23:16];
						83:dataToUartOutFifo= readDataFromRegs[15:8];
						84:dataToUartOutFifo= readDataFromRegs[7:0];
						85: begin 
//								waitingForReg=1;
								notStartUartTrans=1;
							end
						86:begin 
								readAddrFromBank=5;
//								waitingForReg=1;
							end
						87: begin
							notStartUartTrans = 0;
							dataToUartOutFifo= 0;
						end
						88: dataToUartOutFifo= 0;
						89: dataToUartOutFifo= 0;
						90: dataToUartOutFifo= 5;
						91: dataToUartOutFifo= 0;
						92: dataToUartOutFifo= 0;
						93: dataToUartOutFifo= 0;
						94: dataToUartOutFifo= 5;
						95: dataToUartOutFifo= 0;
						96: dataToUartOutFifo= 0;
						97: dataToUartOutFifo= 0;
						98: dataToUartOutFifo= 5;
						99: dataToUartOutFifo= 0;
						100: dataToUartOutFifo= 0;
						101: dataToUartOutFifo= 0;
						102: dataToUartOutFifo= 5;
						103: dataToUartOutFifo= 0;
						104: dataToUartOutFifo= 0;
						105: dataToUartOutFifo= 0;
						106: dataToUartOutFifo= 5;
						107: dataToUartOutFifo= 0;
						108: dataToUartOutFifo= 0;
						109: dataToUartOutFifo= 0;
						110: dataToUartOutFifo= 5;		
						
						111: notStartUartTrans=1;
						112: sentFlag=1;

						
						
//						95: notStartUartTrans=1;
//						96: sentFlag=1;
						
//						96:begin
////						   notStartUartTrans=1;
//							writeFifoFlag=0;
//							sentFlag=1;
//							restartCounter=1;
//						end
						
						
					endcase
				end
			end
			default:begin 	 	
				next_state=INIT;
			end
		endcase
	 end

endmodule
