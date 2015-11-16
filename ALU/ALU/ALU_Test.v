`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:46:20 11/08/2015
// Design Name:   ALU
// Module Name:   C:/Users/Juanjo/Documents/Juanjo/Facu/Arquitectura/Workspace Xilinx/ALUFinal/ALU_Test.v
// Project Name:  ALUFinal
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_Test;

	// Inputs
	reg [5:0] op_code;
	reg [31:0] operand1;
	reg [31:0] operand2;

	// Outputs
	wire [31:0] result;
	wire zero;
	wire overflow;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.op_code(op_code), 
		.operand1(operand1), 
		.operand2(operand2), 
		.result(result), 
		.zero(zero), 
		.overflow(overflow)
	);

	initial begin
		// Initialize Inputs
		op_code = 6'b100000;
		operand1 = 100;
		operand2 = 45;

		// Testing Operations
		
		#100;
		op_code = 6'b100000;
		#100;
		op_code = 6'b100001;
		#100;
		op_code = 6'b100010;
		#100;
		op_code = 6'b100011;
		#100;
		op_code = 6'b100100;
		#100;
		op_code = 6'b100101;
		#100;
		op_code = 6'b100110;
		#1000;
		
		
		// Testing Shift Operations
		operand1 = 1;
		#100;
		operand2 = 0;
		op_code = 6'b000001;
		#100;
		operand2 = 1;
		#100;
		operand2 = 2;
		#100;
		operand2 = 3;
		#100;
		operand2 = 4;
		#100;
		operand2 = 5;
		#100;
		operand2 = 31;
		#100;
		operand2 = 32;
		#1000;

		operand2 = 0;
		op_code = 6'b000010;
		#100;
		operand2 = 1;
		#100;
		operand2 = 2;
		#100;
		operand2 = 3;
		#100;
		operand2 = 4;
		#100;
		operand2 = 5;
		#100;
		operand2 = 31;
		#100;
		operand2 = 32;
		#1000;
		
		operand2 = 0;
		op_code = 6'b000011;
		#100;
		operand2 = 1;
		#100;
		operand2 = 2;
		#100;
		operand2 = 3;
		#100;
		operand2 = 4;
		#100;
		operand2 = 5;
		#100;
		operand2 = 31;
		#100;
		operand2 = 32;
		#100;

        
		// Add stimulus here

	end
      
endmodule

