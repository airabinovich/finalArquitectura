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
		input clock,
		input [31:0]instruction, //hardcodeo la instruccion porq no hay instruction memory
		input resetGral,
		
		//señales desconectadas por ahora, las saco para evitar warnings
		output [7:0]fetchOut,	// no tengo instruction memory, veo el PC aca
		output ALUzero,
		output ALUOverflow,
		output [4:0]rsEXOut
    );
	 //aca asigno salidas, esto hay que borrarlo despues:
			 assign fetchOut = pcFE;
			 assign rsEXOut = rsEX;
			 assign ALUzero=aluZero;
			 assign ALUOverflow=aluOverflow;
	 
	 
	 reg [128:0] ID_EX;
	 reg [106:0] EX_MEM;
	 
	 reg [2:0]instructionMemSize;
	 
	 wire [31:0]instructionID;
	 wire [7:0] pcID;
	  	 
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
	 
	 wire regDst;
	 wire regDstEX;
	 
	 wire branch;
		 
	 wire [1:0] memReadWidth;
	 wire [1:0] memReadWidthEX;
	 wire [1:0] memReadWidthMEM;

	 wire [31:0]sigExtOut;
	 wire [31:0]sigExtEX;

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
		
	 wire [4:0]writeRegisterMEM;
	 wire [4:0]writeRegisterWB;
	 
	 wire [7:0]pcBranchAddr;
	  
	 wire [31:0] writeDataMEM;
	 
	 //Multiplexores:
		 //Declaracion
		 wire [4:0]writeRegister;
		 wire [31:0]aluOperand2;
//		 wire [31:0]sigExtShifted; //No se usa el shifted porque se accede con valores absolutos a la memoria de instr
		 wire [31:0] resultWB;
				
		 //Asignacion		
		 assign writeRegister = (regDstEX)? rdEX : rtEX;
		 assign aluOperand2 = (aluSrcEX)? sigExtEX: readData2EX;
//		 assign sigExtShifted = sigExtOut<<2; //No se usa el shifted porque se accede con valores absolutos a la memoria de instr
		 assign pcSrc = branch & (readData1==readData2);
		 assign resultWB = (memToRegWB)? memoryOutWB : aluOutWB;
		 assign PC = (pcSrc)? pcBranchAddr : pcNext;
	  ControlUnit control(
	 	.Special(instructionID[31:26]),
		.instructionCode(instructionID[5:0]),
		.RegDst(regDst),
		.Branch(branch),
		.MemtoReg(memToReg),
		.MemWrite(memWrite),
		.ALUSrc(aluSrc),
		.RegWrite(regWrite),
		.memReadWidth(memReadWidth), // 0:Word 1:Halfword 2:Byte
	   .aluOperation(aluControl)
	 );
	 
	 
	 RAM ram(
	  .clka(clock), // input clka
	  .wea(memWriteMEM), 
	  .addra(aluOutMEM[7:0]), // input [7 : 0] addra
	  .dina(writeDataMEM), // input [31 : 0] dina
	  .douta(readDataMemory) // output [31 : 0] douta
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
		.operand1(readData1EX),
		.operand2(aluOperand2),
		.result(aluOut),
		.zero(aluZero),
		.overflow(aluOverflow)
	 );
	 SigExt sigext(
		.in(instructionID[15:0]),
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
					.instruction(instruction),
					.pcNext(pcNext),
					.instructionOut(instructionID),
					.pcNextOut(pcNextID),
					.clear(pcSrc)
			);
			
			
		  EX_MEM ex_mem(
				.clock(clock),
				.reset(resetGral),
				.writeRegister(writeRegister),
				.writeData(readData2EX),
				.aluOut(aluOut),
				.regWrite(regWriteEX),
				.memToReg(memToRegEX),
				.memWrite(memWriteEX),
				.memReadWidth(memReadWidthEX),
				
				.writeRegisterOut(writeRegisterMEM),
				.writeDataOut(writeDataMEM),
				.aluOutOut(aluOutMEM),
				.regWriteOut(regWriteMEM),
				.memToRegOut(memToRegMEM),
				.memWriteOut(memWriteMEM),
				.memReadWidthOut(memReadWidthMEM)
    );
			
		 ID_EX id_ex(
			.clock(clock),
			.reset(resetGral),
			.rs(instructionID[25:21]),
			.rt(instructionID[20:16]),
			.rd(instructionID[15:11]),
			.aluOperation(aluControl),
			.sigExt(sigExtOut),
			.readData1(readData1),
			.readData2(readData2),
			.aluSrc(aluSrc),
			.regDst(regDst),
			.memWrite(memWrite),
			.memToReg(memToReg),
			.memReadWidth(memReadWidth),
			.regWrite(regWrite),

			
			.aluOperationOut(aluControlEX),
			.sigExtOut(sigExtEX),
			.readData1Out(readData1EX),
			.readData2Out(readData2EX),
			.aluSrcOut(aluSrcEX),
			.memWriteOut(memWriteEX),
			.memToRegOut(memToRegEX),
			.memReadWidthOut(memReadWidthEX),
			.rsOut(rsEX),
			.rtOut(rtEX),
			.rdOut(rdEX),
			.regDstOut(regDstEX),
			.regWriteOut(regWriteEX)		
    );			
	 
	 MemoryLoadMask mask (
		.dataIn(readDataMemory),
		.maskLength(memReadWidthMEM),
		.dataOut(readDataMemoryMasked)
	 );
	 MEM_WB mem_wb(
		.clock(clock),
		.reset(resetGral),
		.writeRegister(writeRegisterMEM),
		.aluOut(aluOutMEM),
		.memoryOut(readDataMemoryMasked),
		.regWrite(regWriteMEM),
		.memToReg(memToRegMEM),
		
		.writeRegisterOut(writeRegisterWB),
		.aluOutOut(aluOutWB),
		.memoryOutOut(memoryOutWB),
		.regWriteOut(regWriteWB),
		.memToRegOut(memToRegWB)
    );
	 
	 FE fetch(
		.clock(clock),
		.reset(resetGral),
		.pc(PC),
		.pcOut(pcFE)
	 );


endmodule
