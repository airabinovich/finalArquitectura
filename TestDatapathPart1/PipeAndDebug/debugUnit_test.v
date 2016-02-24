`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:43:18 02/23/2016
// Design Name:   DebugUnit
// Module Name:   C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Trabajo Final/finalArquitectura/TestDatapathPart1/PipeAndDebug/debugUnit_test.v
// Project Name:  PipeAndDebug
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: DebugUnit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module debugUnit_test;

	// Inputs
	reg clock;
	reg reset;
	reg endOfProgram;
	reg [7:0] uartFifoDataIn;
	reg uartDataAvailable;
	reg [7:0] FE_pc;
	reg [31:0] IF_ID_instruction;
	reg [7:0] IF_ID_pcNext;
	reg [3:0] ID_EX_aluOperation;
	reg [31:0] ID_EX_sigExt;
	reg [31:0] ID_EX_readData1;
	reg [31:0] ID_EX_readData2;
	reg ID_EX_aluSrc;
	reg ID_EX_aluShiftImm;
	reg [3:0] ID_EX_memWrite;
	reg ID_EX_memToReg;
	reg [1:0] ID_EX_memReadWidth;
	reg [4:0] ID_EX_rs;
	reg [4:0] ID_EX_rt;
	reg [4:0] ID_EX_rd;
	reg [4:0] ID_EX_sa;
	reg ID_EX_regDst;
	reg ID_EX_loadImm;
	reg ID_EX_regWrite;
	reg [4:0] EX_MEM_writeRegister;
	reg [31:0] EX_MEM_writeData;
	reg [31:0] EX_MEM_aluOut;
	reg EX_MEM_regWrite;
	reg EX_MEM_memToReg;
	reg [3:0] EX_MEM_memWrite;
	reg [1:0] EX_MEM_memReadWidth;
	reg [4:0] MEM_WB_writeRegister;
	reg [31:0] MEM_WB_aluOut;
	reg [31:0] MEM_WB_memoryOut;
	reg MEM_WB_regWrite;
	reg MEM_WB_memToReg;

	// Outputs
	wire [7:0] dataToUartOutFifo;
	wire readFifoFlag;
	wire writeFifoFlag;
	wire pipeEnable;
	wire pipeReset;
	wire ledStep;
	wire ledCont;
	wire ledIdle;
	wire ledSend;

	// Instantiate the Unit Under Test (UUT)
	DebugUnit uut (
		.clock(clock), 
		.reset(reset), 
		.endOfProgram(endOfProgram), 
		.uartFifoDataIn(uartFifoDataIn), 
		.uartDataAvailable(uartDataAvailable), 
		.FE_pc(FE_pc), 
		.IF_ID_instruction(IF_ID_instruction), 
		.IF_ID_pcNext(IF_ID_pcNext), 
		.ID_EX_aluOperation(ID_EX_aluOperation), 
		.ID_EX_sigExt(ID_EX_sigExt), 
		.ID_EX_readData1(ID_EX_readData1), 
		.ID_EX_readData2(ID_EX_readData2), 
		.ID_EX_aluSrc(ID_EX_aluSrc), 
		.ID_EX_aluShiftImm(ID_EX_aluShiftImm), 
		.ID_EX_memWrite(ID_EX_memWrite), 
		.ID_EX_memToReg(ID_EX_memToReg), 
		.ID_EX_memReadWidth(ID_EX_memReadWidth), 
		.ID_EX_rs(ID_EX_rs), 
		.ID_EX_rt(ID_EX_rt), 
		.ID_EX_rd(ID_EX_rd), 
		.ID_EX_sa(ID_EX_sa), 
		.ID_EX_regDst(ID_EX_regDst), 
		.ID_EX_loadImm(ID_EX_loadImm), 
		.ID_EX_regWrite(ID_EX_regWrite), 
		.EX_MEM_writeRegister(EX_MEM_writeRegister), 
		.EX_MEM_writeData(EX_MEM_writeData), 
		.EX_MEM_aluOut(EX_MEM_aluOut), 
		.EX_MEM_regWrite(EX_MEM_regWrite), 
		.EX_MEM_memToReg(EX_MEM_memToReg), 
		.EX_MEM_memWrite(EX_MEM_memWrite), 
		.EX_MEM_memReadWidth(EX_MEM_memReadWidth), 
		.MEM_WB_writeRegister(MEM_WB_writeRegister), 
		.MEM_WB_aluOut(MEM_WB_aluOut), 
		.MEM_WB_memoryOut(MEM_WB_memoryOut), 
		.MEM_WB_regWrite(MEM_WB_regWrite), 
		.MEM_WB_memToReg(MEM_WB_memToReg), 
		.dataToUartOutFifo(dataToUartOutFifo), 
		.readFifoFlag(readFifoFlag), 
		.writeFifoFlag(writeFifoFlag), 
		.pipeEnable(pipeEnable), 
		.pipeReset(pipeReset), 
		.ledStep(ledStep), 
		.ledCont(ledCont), 
		.ledIdle(ledIdle), 
		.ledSend(ledSend)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		reset = 0;
		endOfProgram = 0;
		uartFifoDataIn = 0;
		uartDataAvailable = 0;
		FE_pc = 0;
		IF_ID_instruction = 0;
		IF_ID_pcNext = 0;
		ID_EX_aluOperation = 0;
		ID_EX_sigExt = 0;
		ID_EX_readData1 = 0;
		ID_EX_readData2 = 0;
		ID_EX_aluSrc = 0;
		ID_EX_aluShiftImm = 0;
		ID_EX_memWrite = 0;
		ID_EX_memToReg = 0;
		ID_EX_memReadWidth = 0;
		ID_EX_rs = 0;
		ID_EX_rt = 0;
		ID_EX_rd = 0;
		ID_EX_sa = 0;
		ID_EX_regDst = 0;
		ID_EX_loadImm = 0;
		ID_EX_regWrite = 0;
		EX_MEM_writeRegister = 0;
		EX_MEM_writeData = 0;
		EX_MEM_aluOut = 0;
		EX_MEM_regWrite = 0;
		EX_MEM_memToReg = 0;
		EX_MEM_memWrite = 0;
		EX_MEM_memReadWidth = 0;
		MEM_WB_writeRegister = 0;
		MEM_WB_aluOut = 0;
		MEM_WB_memoryOut = 0;
		MEM_WB_regWrite = 0;
		MEM_WB_memToReg = 0;

		// Wait 100 ns for global reset to finish
		#10;
		reset = 1;
		
		#4;
		
		reset = 0;
		
		#4;
		
		uartFifoDataIn = "s";
		
		#4;
		
      uartDataAvailable = 1;
		
		#4;
		
		uartDataAvailable = 0;
		
		#4;
		
		uartFifoDataIn = "n";
		uartDataAvailable = 1;
		
		#4;
		
		// Add stimulus here

	end

always begin
	clock = ~clock;
	#1;
end      
endmodule

