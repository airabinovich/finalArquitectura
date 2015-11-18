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
		input [31:0]instruction,
		input resetGral
    );
	 reg [31:0] IF_ID;
	 reg [120:0] ID_EX;
	 wire RegDst;
	 wire Branch;
	 wire MemRead;
	 wire MemtoReg;
	 wire [1:0]AluOp;
	 wire MemWrite;
	 wire AluSrc;
	 wire RegWrite;
	 wire [31:0]sigExtOut;
	 wire [4:0]writeRegister;
	 wire [3:0]aluOperationCode;
	 wire [31:0]aluOperand2;
	 wire [31:0]aluOutput;
	 wire aluZero;
	 wire aluOverflow;
	 wire [31:0]readData1;
	 wire [31:0]readData2;
	 assign writeRegister = (RegDst)? IF_ID[15:11] : IF_ID[20:16];
	 assign aluOperand2 = (ID_EX[102])? ID_EX[37:6] : ID_EX[69:38];
	  ControlUnit control(
	 	.Special(IF_ID[31:26]),
		.RegDst(RegDst),
		.Branch(Branch),
		.MemRead(MemRead),
		.MemtoReg(MemtoReg),
		.AluOp(AluOp),
		.MemWrite(MemWrite),
		.ALUSrc(AluSrc),
		.RegWrite(RegWrite)
	 );
	 
	 AluControl alu_control(
			.aluOp(ID_EX[107:106]),
			.instructionCodeLowBits(ID_EX[5:0]),
			.instructionCodeHighBits(ID_EX[114:109]),
			.aluOperation(aluOperationCode)
	 );
	 

	 REGBANK_banco bank(
		.clock(clock),
		.regWrite(ID_EX[115]),
		.readReg1(IF_ID[25:21]),
		.readReg2(IF_ID[20:16]),
		.writeReg(ID_EX[120:116]),
		.reset(resetGral),
		.writeData(aluOutput),
		.readData1(readData1),
		.readData2(readData2)
	 );
	 
	 ALU alu(
		.op_code(aluOperationCode),
		.operand1(ID_EX[101:70]),
		.operand2(aluOperand2),
		.result(aluOutput),
		.zero(aluZero),
		.overflow(aluOverflow)
	 );
	 SigExt sigext(
		.in(IF_ID[15:0]),
		.out(sigExtOut)
	 );

	 always @(posedge clock) begin
		ID_EX[5:0]<=IF_ID[5:0];
		ID_EX[37:6]<=sigExtOut;
		ID_EX[69:38]<=readData2;
		ID_EX[101:70]<=readData1;
		ID_EX[102]<=AluSrc;
		ID_EX[103]<=MemWrite;
		ID_EX[104]<=MemRead;
		ID_EX[105]<=MemtoReg;
		ID_EX[107:106]<=AluOp;
		ID_EX[108]<=Branch;
		ID_EX[114:109]<=IF_ID[31:26];
		ID_EX[115]<=RegWrite;
		ID_EX[120:116]<=writeRegister;
		IF_ID<=instruction;
	 end


endmodule
