`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:54 11/17/2015 
// Design Name: 
// Module Name:    Datapath1 
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
module Datapath1(
		input 	clock,
		input    clock70,
		input 	resetGral,
		input 	uartRxPin,
		output 	uartTxPin,
		
		output 	ALUzero,
		output 	ALUOverflow,
		
		output ledStep,
		output ledCont,
		output ledIdle,
		output ledSend,
		output [7:0]sendCounter,
		output sentFlag,
		output notStartUartTx
    ); 
		assign ALUzero=aluZero;
		assign ALUOverflow=aluOverflow;
	 
	 
	 
	 wire [31:0]instruction;
	 wire [31:0]instructionID;
	  	 
	 wire regWrite;
	 wire regWriteEX;
	 wire regWriteMEM;
	 wire regWriteWB;
	 
	 wire memToReg;
	 wire memToRegEX;
	 wire memToRegMEM;
	 wire memToRegWB;
	 
	 wire [3:0]memWrite;
	 wire [3:0]memWriteEX;
	 wire [3:0]memWriteMEM;
	 
	 wire [3:0]aluControl;
	 wire [3:0]aluControlEX;
	 
	 wire aluSrc;
	 wire aluSrcEX;
	 
	 wire aluShiftImm;
	 wire aluShiftImmEX;
	 
	 wire regDst;
	 wire regDstEX;
	 
	 wire loadImm;
	 wire loadImmEX;
	 
	 wire branch;
	 wire branchType;
	 
	 wire eopFlag;
	 wire eopFlagEX;
	 wire eopFlagMEM;
	 wire eopFlagWB;
		 
	 wire [1:0] memReadWidth;
	 wire [1:0] memReadWidthEX;
	 wire [1:0] memReadWidthMEM;

	 wire [31:0]sigExtOut;
	 wire [31:0]sigExtEX;
	 
	 wire zeroExtendFlag;

	 wire [31:0]aluOut;
	 wire [31:0]aluOutMEM;
	 wire [31:0]aluOutWB;
	 
	 wire aluZero;
	 wire aluOverflow;

	 wire [31:0]readData1;
	 wire [31:0]readData1EX;
	 wire [31:0]readData2;
	 wire [31:0]readData2EX;
	 
	 wire [31:0]readDataMemory;
	 wire [31:0]readDataMemoryMasked;
	 
	 wire [31:0]memoryOutWB;
	 
	 wire [7:0] PC;
	 wire [7:0] pcFE;
	 
	 wire [7:0] pcNext;
	 wire [7:0] pcNextID;
	 
	 wire [4:0]rsEX;
	 wire [4:0]rtEX;
	 wire [4:0]rdEX;
	 wire [4:0]saEX;
		
	 wire [4:0]writeRegisterMEM;
	 wire [4:0]writeRegisterWB;
	 
	 wire [7:0]pcBranchAddr;
	 
	 wire [31:0] writeDataEX; 
	 wire [31:0] writeDataMEM;
	 
	 //Salidas Hazard Unit
	 wire stallFE;
	 wire stallID;
	 wire forwardAID;
	 wire forwardBID;
	 wire flushEX;
	 wire [1:0] forwardAEX;
	 wire [1:0] forwardBEX;
	 
	 
	 wire uartWriteFlag;
	 wire uartReadFlag;
	 wire [7:0]uartFifoDataIn;
	 wire uartDataAvailable;
	 wire [7:0]dataToUartOutFifo;
	 wire debugEnable;
	 wire debugReset;
	 
	 //Multiplexores:
		 //Declaracion
		 wire [4:0]writeRegister;
		 wire [31:0]aluOperand1;
		 wire [31:0]aluOperand2;
//		 wire [31:0]sigExtShifted; //No se usa el shifted porque se accede con valores absolutos a la memoria de instr
		 wire [31:0] resultWB;
		 wire branchTaken;
		 assign notStartUartTx = notStartUartTrans;
		 //Asignacion		
		 assign writeRegister = (regDstEX)? rdEX : rtEX;
		 assign aluOperand1 = (loadImmEX)? 'd16 : ((aluShiftImmEX)? saEX: srcAEX);
		 assign aluOperand2 = (aluSrcEX)? sigExtEX: srcBEX;
//		 assign sigExtShifted = sigExtOut<<2; //No se usa el shifted porque se accede con valores absolutos a la memoria de instr
		 assign pcSrc = branch & branchTaken;
		 assign branchTaken = (branchType)? (branchSrcA!=branchSrcB) : (branchSrcA==branchSrcB); //branchType(flag from control) 1: check if branch NE 0: check if branch EQ
		 assign resultWB = (memToRegWB)? memoryOutWB : aluOutWB;
		 assign PC = (pcSrc)? pcBranchAddr : pcNext;
		 
		 
		 
	//Multiplexores Hazards:
		 //Declaracion
		 wire [31:0]srcAEX;
		 wire [31:0]srcBEX;
		 wire [31:0]branchSrcA;
		 wire [31:0]branchSrcB;
		 //Asignacion
		 assign srcAEX= (forwardAEX==0)? readData1EX : ((forwardAEX==1)? resultWB : aluOutMEM);
		 assign srcBEX= (forwardBEX==0)? readData2EX : ((forwardBEX==1)? resultWB : aluOutMEM);
		 assign writeDataEX = srcBEX;
		 assign branchSrcA= (forwardAID)? aluOutMEM: readData1;
		 assign branchSrcB= (forwardBID)? aluOutMEM: readData2;
		 
		 wire uartDataSent;
		 wire notStartUartTrans;
	  ControlUnit control(
	 	.Special(instructionID[31:26]),
		.instructionCode(instructionID[5:0]),
		.RegDst(regDst),
		.Branch(branch),
		.BranchType(branchType),
		.MemtoReg(memToReg),
		.MemWrite(memWrite),
		.ALUSrc(aluSrc),
		.ALUShiftImm(aluShiftImm),
		.RegWrite(regWrite),
		.LoadImm(loadImm),
		.ZeroEx(zeroExtendFlag),
		.EOP(eopFlag),
		.memReadWidth(memReadWidth), // 0:Word 1:Halfword 2:Byte
	   .aluOperation(aluControl)
	 );
	 
	 
	 RAM ram(
	  .clka(clock), // input clka niego el clock para no perder un ciclo en la lectura
	  .wea(memWriteMEM), 
	  .addra(aluOutMEM[7:0]), // input [7 : 0] addra
	  .dina(writeDataMEM), // input [31 : 0] dina
	  .douta(readDataMemory) // output [31 : 0] douta
	);
	
	instructionROM instructionMemory (
	  .clka(clock), // input clka
	  .addra(pcFE), // input [7 : 0] addra
	  .douta(instruction) // output [31 : 0] douta
	);

	 REGBANK_banco bank(
		.clock(clock),
		.regWrite(regWriteWB),
		.readReg1(instructionID[25:21]),
		.readReg2(instructionID[20:16]),
		.writeReg(writeRegisterWB),
		.reset(resetGral),
		.writeData(resultWB),
		.readData1(readData1),
		.readData2(readData2)
	 );
	 
	 ALU alu(
		.op_code(aluControlEX),
		.operand1(aluOperand1),
		.operand2(aluOperand2),
		.result(aluOut),
		.zero(aluZero),
		.overflow(aluOverflow)
	 );
	 SigExt sigext(
		.in(instructionID[15:0]),
		.zeroEx(zeroExtendFlag),
		.out(sigExtOut)
	 );
	 
	 Adder branchPCAdd(
		.a(pcNextID),
		.b(sigExtOut[7:0]),
		.sum(pcBranchAddr)
	 );
	 
	 Adder PCAdd(
		.a(pcFE),
		.b(8'b1),
		.sum(pcNext)
	 );

								
	IF_ID if_id(
		.clock(clock),
		.reset(resetGral),
		.debugEnable(debugEnable),
		.debugReset(debugReset),
		.notEnable(stallID),
		.instruction(instruction),
		.pcNext(pcNext),
		.instructionOut(instructionID),
		.pcNextOut(pcNextID),
		.clear(pcSrc)
	);
			
			
		  EX_MEM ex_mem(
				.clock(clock),
				.reset(resetGral),
				.debugEnable(debugEnable),
				.debugReset(debugReset),
				.writeRegister(writeRegister),
				.writeData(writeDataEX),
				.aluOut(aluOut),
				.regWrite(regWriteEX),
				.memToReg(memToRegEX),
				.memWrite(memWriteEX),
				.memReadWidth(memReadWidthEX),
				.eop(eopFlagEX),
				
				.writeRegisterOut(writeRegisterMEM),
				.writeDataOut(writeDataMEM),
				.aluOutOut(aluOutMEM),
				.regWriteOut(regWriteMEM),
				.memToRegOut(memToRegMEM),
				.memWriteOut(memWriteMEM),
				.memReadWidthOut(memReadWidthMEM),
				.eopOut(eopFlagMEM)
    );
			
		 ID_EX id_ex(
			.clock(clock),
			.reset(resetGral),
			.debugEnable(debugEnable),
			.debugReset(debugReset),
			.syncClr(flushEX),
			.rs(instructionID[25:21]),
			.rt(instructionID[20:16]),
			.rd(instructionID[15:11]),
			.sa(instructionID[10:6]),
			.aluOperation(aluControl),
			.sigExt(sigExtOut),
			.readData1(readData1),
			.readData2(readData2),
			.aluSrc(aluSrc),
			.aluShiftImm(aluShiftImm),
			.regDst(regDst),
			.loadImm(loadImm),
			.memWrite(memWrite),
			.memToReg(memToReg),
			.memReadWidth(memReadWidth),
			.regWrite(regWrite),
			.eop(eopFlag),

			
			.aluOperationOut(aluControlEX),
			.sigExtOut(sigExtEX),
			.readData1Out(readData1EX),
			.readData2Out(readData2EX),
			.aluSrcOut(aluSrcEX),
			.aluShiftImmOut(aluShiftImmEX),
			.memWriteOut(memWriteEX),
			.memToRegOut(memToRegEX),
			.memReadWidthOut(memReadWidthEX),
			.rsOut(rsEX),
			.rtOut(rtEX),
			.rdOut(rdEX),
			.saOut(saEX),
			.regDstOut(regDstEX),
			.loadImmOut(loadImmEX),
			.regWriteOut(regWriteEX),
			.eopOut(eopFlagEX)			
    );			
	 
	 MemoryLoadMask mask (
		.dataIn(readDataMemory),
		.maskLength(memReadWidthMEM),
		.dataOut(readDataMemoryMasked)
	 );
	 MEM_WB mem_wb(
		.clock(clock),
		.reset(resetGral),
		.debugEnable(debugEnable),
		.debugReset(debugReset),
		.writeRegister(writeRegisterMEM),
		.aluOut(aluOutMEM),
		.memoryOut(readDataMemoryMasked),
		.regWrite(regWriteMEM),
		.memToReg(memToRegMEM),
		.eop(eopFlagMEM),
		
		.writeRegisterOut(writeRegisterWB),
		.aluOutOut(aluOutWB),
		.memoryOutOut(memoryOutWB),
		.regWriteOut(regWriteWB),
		.memToRegOut(memToRegWB),
		.eopOut(eopFlagWB)
    );
	 
	 FE fetch(
		.clock(clock),
		.reset(resetGral),
		.debugEnable(debugEnable),
		.debugReset(debugReset),
		.notEnable(stallFE),
		.pc(PC),
		.pcOut(pcFE)
	 );
	 
	 HazardsUnit hazards (
	 	.branchID(branch),
		.rsID(instructionID[25:21]),
		.rtID(instructionID[20:16]),
		.rsEX(rsEX),
		.rtEX(rtEX),
		.writeRegEX(writeRegister),
		.writeRegMEM(writeRegisterMEM),
		.writeRegWB(writeRegisterWB),
		.memToRegEX(memToRegEX),
		.memToRegMEM(memToRegMEM),
		.regWriteEX(regWriteEX),
		.regWriteMEM(regWriteMEM),
		.regWriteWB(regWriteWB),

		.stallFE(stallFE),
		.stallID(stallID),
		.forwardAID(forwardAID),
		.forwardBID(forwardBID),
		.flushEX(flushEX),
		.forwardAEX(forwardAEX),
		.forwardBEX(forwardBEX)
	 );
	 
	 DebugUnit debugUnit(
					.clock(clock70),
					.reset(resetGral),
					.endOfProgram(eopFlagWB),
			
					.uartFifoDataIn(uartFifoDataIn),
					.uartDataAvailable(uartDataAvailable),
					.uartDataSent(uartDataSent),
			
					.FE_pc(pcFE),	
					.IF_ID_instruction(instructionID),
					.IF_ID_pcNext(pcNextID),		
					.ID_EX_aluOperation(aluControlEX),
					.ID_EX_sigExt(sigExtEX),
					.ID_EX_readData1(readData1EX),
					.ID_EX_readData2(readData2EX),
					.ID_EX_aluSrc(aluSrcEX),
					.ID_EX_aluShiftImm(aluShiftImmEX),
					.ID_EX_memWrite(memWriteEX),
					.ID_EX_memToReg(memToRegEX),
					.ID_EX_memReadWidth(memReadWidthEX),
					.ID_EX_rs(rsEX),
					.ID_EX_rt(rtEX),
					.ID_EX_rd(rdEX),
					.ID_EX_sa(saEX),
					.ID_EX_regDst(regDstEX),
					.ID_EX_loadImm(loadImmEX),
					.ID_EX_regWrite(regWriteEX),
					.EX_MEM_writeRegister(writeRegisterMEM),
					.EX_MEM_writeData(writeDataMEM),
					.EX_MEM_aluOut(aluOutMEM),
					.EX_MEM_regWrite(regWriteMEM),
					.EX_MEM_memToReg(memToRegMEM),
					.EX_MEM_memWrite(memWriteMEM),
					.EX_MEM_memReadWidth(memReadWidthMEM),
					.MEM_WB_writeRegister(writeRegisterWB),
					.MEM_WB_aluOut(aluOutWB),
					.MEM_WB_memoryOut(memoryOutWB),
					.MEM_WB_regWrite(regWriteWB),
					.MEM_WB_memToReg(memToRegWB),
			
					.dataToUartOutFifo(dataToUartOutFifo),
					.readFifoFlag(uartReadFlag),
					.writeFifoFlag(uartWriteFlag),
					.pipeEnable(debugEnable),
					.pipeReset (debugReset),
					
					.ledStep(ledStep),
					.ledCont(ledCont),
					.ledIdle(ledIdle),
					.ledSend(ledSend),
					.notStartUartTrans(notStartUartTrans),
					.sendCounter(sendCounter),
					.sentFlag(sentFlag)
	 );

		UART_uart uartMod(
			.clock(clock70),
			.uart_rx(uartRxPin),
			.uart_reset(resetGral),
			.readFlag(uartReadFlag),
			.writeFlag(uartWriteFlag),
			.dataToSend(dataToUartOutFifo),
			.uart_tx_start(notStartUartTrans),
			.receivedData(uartFifoDataIn),
			.dataAvailable(uartDataAvailable),
			.uart_tx(uartTxPin),
			.uart_tx_done(uartDataSent)
		);

endmodule
