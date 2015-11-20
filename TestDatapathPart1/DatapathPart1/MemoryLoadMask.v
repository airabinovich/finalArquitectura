`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:10:57 11/20/2015 
// Design Name: 
// Module Name:    MemoryLoadMask 
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
module MemoryLoadMask(
		 input [31:0]dataIn,
		 input [1:0]maskLength, // 0:Word , 1:HalfWord, 2: Byte, 3:Word
		 output reg [31:0]dataOut
    );
	 
	 always @* begin
		case (maskLength)
			1: dataOut<=dataIn;
			2: dataOut<=dataIn&32'hFFFF;
			3: dataOut<=dataIn&32'hFF;
			default: dataOut<=dataIn;
		endcase
	 
	 end


endmodule
