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
		output reg RegDst,
		output reg Branch,
		output reg MemRead,
		output reg MemtoReg,
		output reg [1:0] AluOp,
		output reg MemWrite,
		output reg ALUSrc,
		output reg RegWrite
    );

always @* begin
	/*AluOp: 00 Store and Load
	  AluOp: 01 Branch Equal y Not Equal
	  AluOp: 10 Operaciones Tipo R
	  AluOp: 11 Operaciones con Immediate
	*/
	case (Special)
		'b100000:begin		//LB
			RegDst<=0; 
			Branch<=0;
			MemRead<=1;
			MemtoReg<=1;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<=2'b0;
		end		
		'b100001:begin		//LH
			RegDst<=0;
			Branch<=0;
			MemRead<=1;
			MemtoReg<=1;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<=2'b0;
		end
		'b100011:begin		//LW
			RegDst<=0;
			Branch<=0;
			MemRead<=1;
			MemtoReg<=1;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<=2'b0;
		end
		'b100111:begin		//LWU
			RegDst<=0;
			Branch<=0;
			MemRead<=1;
			MemtoReg<=1;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<=2'b0;
		end
		'b100100:begin	//LBU
			RegDst<=0;
			Branch<=0;
			MemRead<=1;
			MemtoReg<=1;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<=2'b0;
		end
		'b100101:begin	//LHU
			RegDst<=0;
			Branch<=0;
			MemRead<=1;
			MemtoReg<=1;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<=2'b0;
		end
		'b101000:begin	//SB
			RegDst<=0;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=1;
			ALUSrc<=1;
			RegWrite<=0;
			AluOp<=2'b0;
		end
		'b101001:begin	//SH
			RegDst<=0;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=1;
			ALUSrc<=1;
			RegWrite<=0;
			AluOp<=2'b0;
		end
		'b101011:begin	//SW
			RegDst<=0;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=1;
			ALUSrc<=1;
			RegWrite<=0;
			AluOp<=2'b0;
		end
		'b001000:begin	//ADDI
			RegDst<=0;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<='b11;
		end
		'b001100:begin	//ANDI
			RegDst<=0;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<='b11;
		end
		'b001101:begin	//ORI
			RegDst<=0;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<='b11;
		end
		'b001110:begin	//XORI
			RegDst<=0;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<='b11;
		end
		'b001010:begin	//SLTI
			RegDst<=0;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=0;
			ALUSrc<=1;
			RegWrite<=1;
			AluOp<='b11;
		end	
		'b000100:begin //BEQ
			RegDst<=0;
			Branch<=1;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=0;
			ALUSrc<=0;
			RegWrite<=0;
			AluOp<='b01;
		end
		'b000101:begin //BNE
			RegDst<=0;
			Branch<=1;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=0;
			ALUSrc<=0;
			RegWrite<=0;
			AluOp<='b01;
		end
		default:begin //Tipo R
			RegDst<=1;
			Branch<=0;
			MemRead<=0;
			MemtoReg<=0;
			MemWrite<=0;
			ALUSrc<=0;
			RegWrite<=1;
			AluOp<='b10;
		end
		
	endcase;
end


endmodule
