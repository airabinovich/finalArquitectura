`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:38:12 11/20/2015 
// Design Name: 
// Module Name:    HazardsUnit 
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
module HazardsUnit(
		
		input branchID,
		input [4:0]rsID,
		input [4:0]rtID,
		input [4:0]rsEX,
		input [4:0]rtEX,
		input [4:0]writeRegEX,
		input [4:0]writeRegMEM,
		input [4:0]writeRegWB,
		input memToRegEX,
		input memToRegMEM,
		input regWriteEX,
		input regWriteMEM,
		input regWriteWB,

		output stallFE,
		output stallID,
		output forwardAID,
		output forwardBID,
		output flushEX,
		output reg [1:0]forwardAEX,
		output reg [1:0]forwardBEX
		
    );
	 
	 wire lwstall;
	 wire branchstall;
	 
		assign lwstall = ((rsID == rtEX) || (rtID == rtEX)) && memToRegEX;
		assign stallFE = lwstall || branchstall;
		assign stallID = lwstall || branchstall;
		assign flushEX = lwstall || branchstall;
		
		assign forwardAID =  (rsID == writeRegMEM) && regWriteMEM;
      assign forwardBID =  (rtID == writeRegMEM) && regWriteMEM;
		
		assign branchstall = (branchID && regWriteEX && (writeRegEX == rsID || writeRegEX == rtID)) || (branchID && memToRegMEM && (writeRegMEM == rsID || writeRegMEM == rtID));

	always @* begin
		if ((rsEX == writeRegMEM) && regWriteMEM) begin
				forwardAEX <= 'b10;
		end
		else if ((rsEX == writeRegWB) && regWriteWB) begin
				forwardAEX <= 'b01;
		end
		else begin
				forwardAEX <= 'b00;
		end
		
		if ((rtEX == writeRegMEM) && regWriteMEM) begin
				forwardBEX <= 'b10;
		end
		else if ((rtEX == writeRegWB) && regWriteWB) begin
				forwardBEX <= 'b01;
		end
		else begin
				forwardBEX <= 'b00;
		end
		
		

		
	end

endmodule
