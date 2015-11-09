`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:34 09/03/2015 
// Design Name: 
// Module Name:    TP1_ALU 
// Project Name: 
// Target Devices: 
// Tool veoperand1ions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALU #(parameter N=32)(
    input [5:0] op_code,
	 input signed [N-1:0] operand1,
    input signed [N-1:0] operand2,
	 output reg signed [N-1:0] result,
	 output reg zero,
	 output reg overflow
    );
	 
    always @(*) begin
	 /*El op_code para cada operacion debe definirse*/
		case(op_code)
			6'b000001: {overflow,result} = operand1 <<  operand2[4:0];							//SLL
			6'b000010: {overflow,result} = operand1 >>  operand2[4:0];							//SRL
			6'b000011: {overflow,result} = operand1 >>> operand2[4:0];							//SRA
			6'b100000: {overflow,result} = operand1 + operand2 ;									//ADD
			6'b100001: {overflow,result} = operand1 - operand2;									//SUB
			6'b100010: {overflow,result} = operand1 & operand2;									//AND
			6'b100011: {overflow,result} = operand1 | operand2;									//OR
			6'b100100: {overflow,result} = operand1 ^ operand2;									//XOR
			6'b100101: {overflow,result} = ~(operand1 | operand2);								//NOR
			6'b100110: {overflow,result} = (operand1 < operand2);									//SLT			
		endcase	
		zero= (result==0)? 1'b1:1'b0;
	end

endmodule
