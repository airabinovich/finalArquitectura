`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:28:24 11/07/2015 
// Design Name: 
// Module Name:    REGBANK_banco 
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
module REGBANK_banco #(parameter addr_bits=5, word_wide=32)(
	input clock,
	input regWrite,
	input [addr_bits-1:0] readReg1,
	input [addr_bits-1:0] readReg2,
	input [addr_bits-1:0] writeReg,
	input reset,
	input [word_wide-1:0] writeData,
	output [word_wide-1:0] readData1,
	output [word_wide-1:0] readData2,
	output  [word_wide-1:0] readDataToDebug0,
	output  [word_wide-1:0] readDataToDebug1,
	output  [word_wide-1:0] readDataToDebug2,
	output  [word_wide-1:0] readDataToDebug3,
	output  [word_wide-1:0] readDataToDebug4
);
	/* bank_depth = 2^(addr_bits)
		el banco tiene la profundidad m�xima que se puede direccionar
	*/
	localparam bank_depth = 1 << addr_bits;
	
	reg [word_wide-1:0] banco [bank_depth-1:0];

	
	assign readData1 = banco[readReg1];
	assign readData2 = banco[readReg2];
	assign readDataToDebug0 = banco[0];
	assign readDataToDebug1 = banco[1];
	assign readDataToDebug2 = banco[2];
	assign readDataToDebug3 = banco[3];
	assign readDataToDebug4 = banco[4];
	always@(posedge clock,posedge reset) begin
//		if(reset)begin
//			banco[0]=90;banco[1]=91;banco[2]=92;banco[3]=93;
//			banco[4]=94;
//			banco[5]=99;banco[6]=99;banco[7]=99;
//			banco[8]=99;banco[9]=99;banco[10]=99;banco[11]=99;
//			banco[12]=99;banco[13]=99;banco[14]=99;banco[15]=99;
//			banco[16]=99;banco[17]=99;banco[18]=99;banco[19]=99;
//			banco[20]=99;banco[21]=99;banco[22]=99;banco[23]=99;
//			banco[24]=99;banco[25]=99;banco[26]=99;banco[27]=99;
//			banco[28]=99;banco[29]=99;banco[30]=99;banco[31]=99;
//		end
		if(reset)begin
			banco[0]=0;banco[1]=0;banco[2]=0;banco[3]=0;
			banco[4]=0;banco[5]=0;banco[6]=0;banco[7]=0;
			banco[8]=0;banco[9]=0;banco[10]=0;banco[11]=0;
			banco[12]=0;banco[13]=0;banco[14]=0;banco[15]=0;
			banco[16]=0;banco[17]=0;banco[18]=0;banco[19]=0;
			banco[20]=0;banco[21]=0;banco[22]=0;banco[23]=0;
			banco[24]=0;banco[25]=0;banco[26]=0;banco[27]=0;
			banco[28]=0;banco[29]=0;banco[30]=0;banco[31]=0;
		end
		else if (regWrite) begin
			banco[writeReg] = writeData;
		end
	end

endmodule
