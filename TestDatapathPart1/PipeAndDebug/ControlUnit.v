`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:33:15 11/16/2015 
// Design Name: 
// Module Name:    ControlUnit 
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
module ControlUnit(
		input [5:0] Special,
		input [5:0] instructionCode,
		output reg RegDst,
		output reg Branch,
		output reg BranchType,
		output reg MemtoReg,
		output reg [3:0]MemWrite,
		output reg ALUSrc,
		output reg ALUShiftImm,
		output reg RegWrite,
		output reg LoadImm,
		output reg ZeroEx,
		output reg EOP,
		output reg [1:0] memReadWidth, // 0:Word 1:Halfword 2:Byte
	   output reg [3:0] aluOperation
    );

always @* begin

	case (Special)
		'b100000:begin		//LB
			EOP			<= 0; 
			RegDst 		<= 0; 
			Branch 		<= 0;
			BranchType 	<= 0;
			MemtoReg		<= 1;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite	 	<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 2;
		end		
		'b100001:begin		//LH
			EOP			<= 0; 
			RegDst		<= 0;
			Branch		<=	0;
			BranchType	<= 0;
			MemtoReg		<= 1;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 1;
		end
		'b100011:begin		//LW
			EOP			<= 0; 
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 1;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 0;
		end
		'b100111:begin		//LWU
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 1;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm  	<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 0;
		end
		'b100100:begin	//LBU
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 1;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 2;
		end
		'b100101:begin	//LHU
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 1;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 1;
		end
		'b101000:begin	//SB
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 4'd1;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 0;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 0;
		end
		'b101001:begin	//SH
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 4'b0011;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 0;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 0;
		end
		'b101011:begin	//SW
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 4'b1111;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 0;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 0;
		end
		'b001000:begin	//ADDI
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 3;
			memReadWidth<= 0;
		end
		'b001100:begin	//ANDI
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 1;
			aluOperation<= 5;
			memReadWidth<= 0;
		end
		'b001101:begin	//ORI
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 1;
			aluOperation<= 6;
			memReadWidth<= 0;
		end
		'b001110:begin	//XORI
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 1;
			aluOperation<= 7;
			memReadWidth<= 0;
		end
		'b001010:begin	//SLTI
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 9;
			memReadWidth<= 0;
		end	
	   'b001111:begin	//LUI
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 1;
			LoadImm		<= 1;
			ZeroEx		<= 0;
			aluOperation<= 0;
			memReadWidth<= 0;
		end	
		'b000100:begin //BEQ
			EOP			<= 0;
			RegDst		<=	0;
			Branch		<= 1;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 0;
			ALUShiftImm	<= 0;
			RegWrite		<= 0;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<= 4;
			memReadWidth<= 0;
		end
		'b000101:begin //BNE
			EOP			<= 0;
			RegDst		<= 0;
			Branch		<= 1;
			BranchType	<= 1;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 0;
			ALUShiftImm	<= 0;
			RegWrite		<= 0;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			aluOperation<=	4;
			memReadWidth<= 0;
		end
		'b111111:begin // End of Program
			EOP			<= 1;
			RegDst		<= 0;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 1;
			ALUShiftImm	<= 0;
			RegWrite		<= 0;
			LoadImm		<= 0;
			ZeroEx		<= 1;
			aluOperation<= 6;
			memReadWidth<= 0;
		end
		default:begin //Tipo R
			EOP			<= 0;
			RegDst		<= 1;
			Branch		<= 0;
			BranchType	<= 0;
			MemtoReg		<= 0;
			MemWrite		<= 0;
			ALUSrc		<= 0;
			ALUShiftImm <=((instructionCode==0) ||(instructionCode==2)||(instructionCode==3));
			RegWrite		<= 1;
			LoadImm		<= 0;
			ZeroEx		<= 0;
			memReadWidth<= 0;
			case(instructionCode)
				6'b000000: aluOperation <= 0; //SLL
				6'b000010: aluOperation <= 1; //SRL
				6'b000011: aluOperation <= 2; //SRA
				6'b000110: aluOperation <= 1; //SRLV
				6'b000111: aluOperation <= 2; //SRAV
				6'b000100: aluOperation <= 0; //SLLV
				6'b100000: aluOperation <= 3; //ADD
				6'b100010: aluOperation <= 4; //SUB
				6'b100100: aluOperation <= 5; //AND
				6'b100101: aluOperation <= 6; //OR
				6'b100110: aluOperation <= 7; //XOR
				6'b100111: aluOperation <= 8; //NOR
				6'b101010: aluOperation <= 9; //SLT
				default: aluOperation	<= 'hF;
			endcase
		end
		
	endcase;
end


endmodule
